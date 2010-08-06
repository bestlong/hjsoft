{*******************************************************************************
  ����: dmzn@163.com 2010-3-14
  ����: ��������Ƥ��
*******************************************************************************}
unit UFormBangFangP;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFormNormal, USysBusiness, ComCtrls, cxGraphics, cxDropDownEdit,
  cxMaskEdit, cxButtonEdit, cxEdit, cxTextEdit, cxListView, cxContainer,
  cxMCListBox, dxLayoutControl, StdCtrls, cxControls;

type
  TfFormBangFangP = class(TfFormNormal)
    dxGroup2: TdxLayoutGroup;
    ListInfo: TcxMCListBox;
    dxLayout1Item3: TdxLayoutItem;
    ListTruck: TcxListView;
    dxLayout1Item7: TdxLayoutItem;
    EditZK: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    EditCard: TcxTextEdit;
    dxLayout1Item6: TdxLayoutItem;
    dxLayout1Group2: TdxLayoutGroup;
    dxLayout1Group3: TdxLayoutGroup;
    EditValue: TcxButtonEdit;
    dxLayout1Item9: TdxLayoutItem;
    EditTruck: TcxComboBox;
    dxLayout1Item8: TdxLayoutItem;
    BtnGet: TButton;
    dxLayout1Item5: TdxLayoutItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EditTruckPropertiesChange(Sender: TObject);
    procedure BtnGetClick(Sender: TObject);
    procedure EditValuePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnOKClick(Sender: TObject);
    procedure EditValuePropertiesEditValueChanged(Sender: TObject);
  protected
    { Protected declarations }
    function OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean; override;
    procedure InitFormData(const nID: string);
    //��������
    procedure LoadTruckList;
    //���복��
    procedure LoadLadingList(const nTruck: string);
    //�����
    procedure SaveNewWeightData;
    function UpdateTiHuo(const nTruck: TLadingTruckItem): Boolean;

    function IsSanWeightValid: Boolean;
    procedure UpdateSanWeightData(const nTruck: TLadingTruckItem);
    function UpdateSanSongH(const nTruck: TLadingTruckItem): Boolean;
    //��������
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
    //���ຯ��
  end;

implementation

{$R *.dfm}
uses
  IniFiles, DB, ULibFun, UMgrControl, USysPopedom, UFormBase, USysGrid, USysDB,
  USysConst, UDataModule, UFormWeight;

type
  TCommonInfo = record
    FZhiKa: string;
    FCard: string;
    FZKMoney: Boolean; 
    FTruckIdx: Integer;
    FNetWeight: Double; //�������
    FTruckNetW: Double; //��������
  end;

var
  gInfo: TCommonInfo;
  gHKItems: TList;
  gTrucks: TDynamicTruckArray;
  //ȫ��ʹ��

//------------------------------------------------------------------------------
class function TfFormBangFangP.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nStr: string;
    nIdx: Integer;
    nP: TFormCommandParam;
    nTruck: TDynamicTruckArray;
begin
  Result := nil;
  SetLength(nTruck, 0);
  FillChar(nP, SizeOf(nP), #0);

  CreateBaseFormItem(cFI_FormVerifyCard, '', @nP);
  if (nP.FCommand <> cCmd_ModalResult) or (nP.FParamA <> mrOK) then Exit;

  with gInfo do
  begin
    FCard := nP.FParamB;
    FZhiKa := nP.FParamC;
    FTruckIdx := -1;
  end;

  if not LoadLadingTruckItems(gInfo.FCard, sFlag_TruckBFP, sFlag_TruckBFP,
     gTrucks, nStr, False) then
  begin
    if not LoadBillTruckItems(gInfo.FCard, nTruck, nStr) then
    begin
      if not gPopedomManager.HasPopedom(sPopedom_Add, nPopedom) then
      begin
        nStr := nStr + #13#10 + '��û�п������Ȩ��.';
        nStr := '����Ƥ�ز�������ֹ,ԭ������:' + #13#10 + #13#10 +
                AdjustHintToRead(nStr);
        ShowDlg(nStr, sWarn); Exit;
      end;

      ShowMsg('���ȿ������', sHint);
      FillChar(nP, SizeOf(nP), #0);
      nP.FParamB := gInfo.FCard;

      CreateBaseFormItem(cFI_FormBill, '', @nP);
      if (nP.FCommand <> cCmd_ModalResult) or (nP.FParamA <> mrOK) then Exit;

      if not LoadBillTruckItems(gInfo.FCard, nTruck, nStr) then
      begin
        nStr := '����Ƥ�ز�������ֹ,ԭ������:' + #13#10 + #13#10 +
              AdjustHintToRead(nStr);
        ShowDlg(nStr, sWarn); Exit;
      end;
    end;

    for nIdx:=Low(nTruck) to High(nTruck) do
     with nTruck[nIdx] do
      FIsCombine := (FLading = sFlag_TiHuo) or (FStockType <> sFlag_San);
    //xxxxx

    SetLength(gTrucks, 0);
    CombinTruckItems(nTruck, gTrucks);
    //�ϲ������

    if Length(gTrucks) < 1 then
    begin
      nStr := '�ÿ���û����Ҫ����Ƥ�صĳ���.';
      nStr := '����Ƥ�ز�������ֹ,ԭ������:' + #13#10 + #13#10 +
              AdjustHintToRead(nStr);
      ShowDlg(nStr, sWarn); Exit;
    end;
  end;

  with TfFormBangFangP.Create(Application) do
  begin
    Caption := '����Ƥ��';
    PopedomItem := nPopedom;
    
    InitFormData(gInfo.FZhiKa);
    ShowModal;
    Free;
  end;
end;

class function TfFormBangFangP.FormID: integer;
begin
  Result := cFI_FormBangFangP;
end;

procedure TfFormBangFangP.FormCreate(Sender: TObject);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadFormConfig(Self, nIni);
    LoadMCListBoxConfig(Name, ListInfo, nIni);
    LoadcxListViewConfig(Name, ListTruck, nIni);
  finally
    nIni.Free;
  end;
end;

procedure TfFormBangFangP.FormClose(Sender: TObject;
  var Action: TCloseAction);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveFormConfig(Self, nIni);
    SaveMCListBoxConfig(Name, ListInfo, nIni);
    SavecxListViewConfig(Name, ListTruck, nIni);
  finally
    nIni.Free;
  end;
end;

//------------------------------------------------------------------------------
//Desc: ����nIDֽ��������
procedure TfFormBangFangP.InitFormData(const nID: string);
var nStr: string;
begin
  if LoadZhiKaInfo(nID, ListInfo, nStr) = nil then
  begin
    BtnOK.Enabled := False;
    ShowMsg(nStr, sHint); Exit;
  end;

  EditZK.Text := gInfo.FZhiKa;
  EditCard.Text := gInfo.FCard;
  ActiveControl := BtnGet;
  LoadTruckList;
end;

//Desc: ���복���б�����
procedure TfFormBangFangP.LoadTruckList;
var nIdx: Integer;
begin
  EditTruck.Clear;
  for nIdx:=Low(gTrucks) to High(gTrucks) do
   if EditTruck.Properties.Items.IndexOf(gTrucks[nIdx].FTruckNo) < 0 then
    EditTruck.Properties.Items.Add(gTrucks[nIdx].FTruckNo);
  if EditTruck.Properties.Items.Count > 0 then EditTruck.ItemIndex := 0;
end;

//Desc: ����nTruck��Ӧ�������
procedure TfFormBangFangP.LoadLadingList(const nTruck: string);
var i,nIdx: Integer;
begin
  nIdx := ListTruck.ItemIndex;
  ListTruck.Items.BeginUpdate;
  try
    ListTruck.Clear;
    ListTruck.Checkboxes := gTrucks[0].FIsLading = False;
    //�������

    if ListTruck.Checkboxes then
         ListTruck.SmallImages := nil
    else ListTruck.SmallImages := FDM.ImageBar;
                                  
    for i:=Low(gTrucks) to High(gTrucks) do
    if gTrucks[i].FTruckNo = nTruck then
    with ListTruck.Items.Add, gTrucks[i] do
    begin
      Caption := FBill;
      SubItems.Add(FStockName);
      SubItems.Add(FTruckNo);
      SubItems.Add(Format('%.2f', [FValue]));

      ImageIndex := cItemIconIndex;
      Checked := FSelect;
      Data := Pointer(i);
    end;
  finally
    if nIdx < ListTruck.Items.Count then
      ListTruck.ItemIndex := nIdx;
    ListTruck.Items.EndUpdate;
  end;
end;

//Desc: ͬ�������
procedure TfFormBangFangP.EditTruckPropertiesChange(Sender: TObject);
begin
  with gInfo do
  if (EditTruck.ItemIndex > -1) and (EditTruck.ItemIndex <> FTruckIdx) then
  begin
    if IsNumber(EditValue.Text, True) and (StrToFloat(EditValue.Text) > 0) and        
       (not QueryDlg('ȷ��Ҫ�л�������������?', sAsk)) then
    begin
      EditTruck.ItemIndex := FTruckIdx; Exit;
    end;

    FTruckIdx := EditTruck.ItemIndex;
    LoadLadingList(EditTruck.Text);
  end;
end;

//Desc: ����
procedure TfFormBangFangP.BtnGetClick(Sender: TObject);
begin
  Visible := False;
  try
    EditValue.Text := ShowBangFangWeightForm(PopedomItem);
  finally
    Visible := True;
  end;

  if IsNumber(EditValue.Text, False) and (StrToFloat(EditValue.Text) > 0) then
       ActiveControl := BtnOK
  else ActiveControl := BtnGet;
end;

//Desc: �������
procedure TfFormBangFangP.EditValuePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
var nStr: string;
begin
  if not gPopedomManager.HasPopedom(sPopedom_Edit, PopedomItem) then Exit;
  //�޸�Ȩ�޿���

  if EditValue.Properties.ReadOnly then
       nStr := '�Ƿ�Ҫ�ֶ�����Ƥ��?'
  else nStr := '�Ƿ�Ҫ�Զ���ȡ����?';

  if QueryDlg(nStr, sAsk, Handle) then
    EditValue.Properties.ReadOnly := not EditValue.Properties.ReadOnly;
  //xxxxx
end;

//Desc: ɢװ�㾻��
procedure TfFormBangFangP.EditValuePropertiesEditValueChanged(
  Sender: TObject);
var nStr: string;
    nVal: Double;
begin
  if ListTruck.Items.Count > 0 then
   if IsNumber(EditValue.Text, True) and (StrToFloat(EditValue.Text) > 0) then
    with gTrucks[Integer(ListTruck.Items[0].Data)] do
    if FIsLading and (FStockType = sFlag_San) and (FLading <> sFlag_TiHuo) then
    begin
      nVal := StrToFloat(EditValue.Text);
      gInfo.FTruckNetW := GetNetWeight(FTruckID, nVal , False);

      nStr := '����:[ %s ] ë��:[ %.2f ] ����:[ %.2f ]';
      dxGroup2.Caption := Format(nStr, [EditTruck.Text, nVal, gInfo.FTruckNetW]);
    end else
    begin
      gInfo.FTruckNetW := 0;
      dxGroup2.Caption := '�����б�';
     end;
end;

//Desc: ��֤����
function TfFormBangFangP.OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean;
var nStr: string;
    i,nIdx,nD,nS: integer;
begin
  Result := True;

  if Sender = EditValue then
  begin
    Result := IsNumber(EditValue.Text, True) and
              (StrToFloat(EditValue.Text) > 0);
    nHint := '��������Ч������';
  end else

  if Sender = EditTruck then
  begin
    Result := (EditTruck.ItemIndex > -1) and (ListTruck.Items.Count > 0);
    nHint := '��ѡ����Ч�ĳ���';
    if not Result then Exit;

    Result := gTrucks[0].FIsLading or (not IsTruckIn(EditTruck.Text));
    nHint := '�ó������,���Ժ�';
  end;

  if Sender <> ListTruck then Exit;
  if gTrucks[0].FIsLading or (gTrucks[0].FLading <> sFlag_TiHuo) then Exit;
  //�ѽ������ͻ����������ж��ϳ�

  nS := 0;
  nD := 0;
  //��,ɢ����
  
  for i:=ListTruck.Items.Count - 1 downto 0 do
  if ListTruck.Items[i].Checked then
  begin
    nIdx := Integer(ListTruck.Items[i].Data);
    if gTrucks[nIdx].FStockType = sFlag_San then
         Inc(nS)
    else Inc(nD);
  end;

  Result := nS + nD > 0;
  nHint := '��ѡ��Ҫ���صĳ���';
  if not Result then Exit;

  Result := not ((nS > 0) and (nD > 0));
  nHint := '����ɢ���ܻ��װ��';
  if not Result then Exit;

  Result := nS < 2;
  nHint := 'ɢ�Ҳ��ܺϳ����';
  if not Result then Exit;

  nStr := Format('��ѡ����[ %d ]�������,ȷ��Ҫ�ϳ������?', [nD]);
  Result := (nD < 2) or QueryDlg(nStr, sAsk);
  nHint := '������ѡ��';
end;

//Desc: ����������
procedure TfFormBangFangP.SaveNewWeightData;
var i,nIdx: integer;
    nTrucks: TDynamicTruckArray;
begin
  for nIdx:=Low(gTrucks) to High(gTrucks) do
    gTrucks[nIdx].FIsCombine := False;
  //�ȴ��ϲ�

  for i:=ListTruck.Items.Count - 1 downto 0 do
  if ListTruck.Items[i].Checked then
  begin
    nIdx := Integer(ListTruck.Items[i].Data);
    gTrucks[nIdx].FIsCombine := True;
  end;

  CombinTruckItems(gTrucks, nTrucks);
  //����������

  for nIdx:=Low(nTrucks) to High(nTrucks) do
    nTrucks[nIdx].FSelect := True;
  //xxxxx
  
  MakeTrucksIn(nTrucks);
  MakeTruckBFP(nTrucks[0], StrToFloat(EditValue.Text));
end;

//Desc: ���ᴦ��
function TfFormBangFangP.UpdateTiHuo(const nTruck: TLadingTruckItem): Boolean;
begin
  Result := True;
  FDM.ADOConn.BeginTrans;
  try
    if nTruck.FIsLading then
         MakeTruckBFP(nTruck, StrToFloat(EditValue.Text))
    else SaveNewWeightData;
    FDM.ADOConn.CommitTrans;
  except
    Result := False;
    FDM.ADOConn.RollbackTrans;
    ShowMsg('����Ƥ��ʧ��', sError);
  end;
end;

//Desc: ��֤�ͻ�ɢװ�����Ƿ���Ч
function TfFormBangFangP.IsSanWeightValid: Boolean;
var nInt: Integer;
    nVal,nNet: Double;
    nP: TFormCommandParam;
begin
  Result := False;
  with gTrucks[Integer(ListTruck.Items[0].Data)] do
  begin
    nNet := gInfo.FTruckNetW;
    gInfo.FNetWeight := nNet;
    //����

    if nNet <= 0 then
    begin
      EditValue.SetFocus;
      ShowMsg('����Ϊ0�����ϳ�ʶ��..!', sHint); Exit;
    end;

    nVal := GetValidMoneyByZK(gInfo.FZhiKa, gInfo.FZKMoney);
    nVal := nVal + FPrice * FValue;
    //���ý�

    if FPrice > 0 then
         nVal := nVal / FPrice
    else nVal := 0;
    //�������

    Result := FloatRelation(nVal, nNet, rtGE, cPrecision);
    if not Result then
    begin
      gInfo.FNetWeight := nVal;
      nInt := Integer(ListTruck.Items[0].Data);

      nP.FCommand := cCmd_EditData;
      nP.FParamA := gTrucks[nInt].FBill;
      nP.FParamB := gTrucks[nInt].FTruckNo;
      nP.FParamC := nNet - nVal;
      nP.FParamD := Integer(gHKItems);

      CreateBaseFormItem(cFI_FormSanHeKa, '', @nP);
      Result := (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOk);
    end;
  end;
end;

//Desc: ����ɢװ�ͻ������ݿ�
procedure TfFormBangFangP.UpdateSanWeightData(const nTruck: TLadingTruckItem);
var nStr: string;
    nVal: Double;
begin
  MakeTruckBFP(nTruck, StrToFloat(EditValue.Text));
  //xxxxx

  with nTruck do
  begin
    nStr := 'Update %s Set L_Value=%.2f Where L_ID=''%s''';
    nStr := Format(nStr, [sTable_Bill, gInfo.FNetWeight, FBill]);
    FDM.ExecuteSQL(nStr);

    nStr := 'Update %s Set E_Value=%.2f Where E_ID=%s';
    nStr := Format(nStr, [sTable_TruckLogExt, gInfo.FNetWeight, FRecord]);
    FDM.ExecuteSQL(nStr);

    nVal := FPrice * FValue;
    nVal := FPrice * gInfo.FNetWeight - nVal;

    nStr := 'Update %s Set A_FreezeMoney=A_FreezeMoney+(%.2f) ' +
            'Where A_CID=''%s''';
    nStr := Format(nStr, [sTable_CusAccount, nVal, FCusID]);
    FDM.ExecuteSQL(nStr);

    if gInfo.FZKMoney then
    begin
      nStr := 'Update %s Set Z_FixedMoney=Z_FixedMoney-(%.2f) ' +
              'Where Z_ID=''%s''';
      nStr := Format(nStr, [sTable_ZhiKa, nVal, gInfo.FZhiKa]);
      FDM.ExecuteSQL(nStr);
    end;
  end;
end;

//Desc: ����ɢװ�ͻ�
function TfFormBangFangP.UpdateSanSongH(const nTruck: TLadingTruckItem): Boolean;
var nStr: string;
    nIdx: Integer;
    nTrucks: TDynamicTruckArray;
begin
  gHKItems.Clear;
  Result := IsSanWeightValid;
  if not Result then Exit;
  
  FDM.ADOConn.BeginTrans;
  try
    UpdateSanWeightData(nTruck);
    SaveSanHKData(gHKItems);

    LoadLadingTruckItems(gInfo.FCard, '', sFlag_TruckOut, nTrucks, nStr, False);
    //�ÿ�������Ҫ���������б�
    MakeTrucksOut(nTrucks, nTruck.FTruckID);

    FDM.ADOConn.CommitTrans;
    Result := True;
  except
    Result := False;
    FDM.ADOConn.RollbackTrans;
    ShowMsg('����Ƥ��ʧ��', sError); Exit;
  end;

  nStr := '';
  for nIdx:=Low(nTrucks) to High(nTrucks) do
    nStr := nStr + nTrucks[nIdx].FRecord + ',';
  //xxxxx

  if nStr <> '' then
  begin
    System.Delete(nStr, Length(nStr), 1);
    PrintPoundReport(nStr, True);
  end;
end;

//Desc: ����
procedure TfFormBangFangP.BtnOKClick(Sender: TObject);
var nIdx: Integer;
    nBool: Boolean;
begin
  if IsDataValid then
  begin
    nIdx := Integer(ListTruck.Items[0].Data);
    if IsTruckSongHuo(gTrucks[nIdx]) then
         nBool := UpdateSanSongH(gTrucks[nIdx])
    else nBool := UpdateTiHuo(gTrucks[nIdx]);

    if nBool then
    begin
      ModalResult := mrOk;
      ShowMsg('����Ƥ�سɹ�', sHint);
    end;
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormBangFangP, TfFormBangFangP.FormID);
  gHKItems := TList.Create;
finalization
  gHKItems.Free;
end.

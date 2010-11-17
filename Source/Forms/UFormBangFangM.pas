{*******************************************************************************
  ����: dmzn@163.com 2010-3-14
  ����: ��������ë��
*******************************************************************************}
unit UFormBangFangM;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFormNormal, USysBusiness, ComCtrls, cxGraphics, cxDropDownEdit,
  cxMaskEdit, cxButtonEdit, cxEdit, cxTextEdit, cxListView, cxContainer,
  cxMCListBox, dxLayoutControl, StdCtrls, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters;

type
  TfFormBangFangM = class(TfFormNormal)
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
    procedure BtnOKClick(Sender: TObject);
    procedure BtnGetClick(Sender: TObject);
    procedure EditValuePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
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
    function IsWeightValid: Boolean;
    //������Ч
    procedure UpdateWeightData(const nTruck: TLadingTruckItem);
    //��������
    function UpdateTiHuo(const nTruck: TLadingTruckItem): Boolean;
    function UpdateSanSongH(const nTruck: TLadingTruckItem): Boolean;
    //ɢװ�ͻ�
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
    FCusID: string;
    FCusName: string;
    FZKMoney: Boolean;
    FTruckIdx: Integer; //����
    FNetWeight: Double; //�������
    FTruckNetW: Double; //��������
  end; 

var
  gInfo: TCommonInfo;
  gHKItems: TList;
  gTrucks: TDynamicTruckArray;
  //ȫ��ʹ��

//------------------------------------------------------------------------------
class function TfFormBangFangM.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nStr: string;
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

  if not LoadLadingTruckItems(gInfo.FCard, sFlag_TruckBFM, sFlag_TruckBFM,
     gTrucks, nStr, False) then
  begin
    nStr := '����û���ҵ��ʺϳ���ë�صĳ���,��������:' + #13#10 + #13#10 +
            AdjustHintToRead(nStr);
    ShowDlg(nStr, sHint); Exit;
  end;

  with TfFormBangFangM.Create(Application) do
  begin
    Caption := '����ë��';
    PopedomItem := nPopedom;

    InitFormData(gInfo.FZhiKa);
    ShowModal;
    Free;
  end;
end;

class function TfFormBangFangM.FormID: integer;
begin
  Result := cFI_FormBangFangM;
end;

procedure TfFormBangFangM.FormCreate(Sender: TObject);
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

procedure TfFormBangFangM.FormClose(Sender: TObject;
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
procedure TfFormBangFangM.InitFormData(const nID: string);
var nStr: string;
    nDB: TDataSet;
begin
  gHKItems.Clear;
  nDB := LoadZhiKaInfo(nID, ListInfo, nStr);

  if Assigned(nDB) then
  begin
    gInfo.FCusID := nDB.FieldByName('Z_Custom').AsString;
    gInfo.FCusName := nDB.FieldByName('C_Name').AsString;
  end else
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
procedure TfFormBangFangM.LoadTruckList;
var nIdx: Integer;
begin
  EditTruck.Clear;
  for nIdx:=Low(gTrucks) to High(gTrucks) do
   if EditTruck.Properties.Items.IndexOf(gTrucks[nIdx].FTruckNo) < 0 then
    EditTruck.Properties.Items.Add(gTrucks[nIdx].FTruckNo);
  if EditTruck.Properties.Items.Count > 0 then EditTruck.ItemIndex := 0;
end;

//Desc: ����nTruck��Ӧ�������
procedure TfFormBangFangM.LoadLadingList(const nTruck: string);
var i,nIdx: Integer;
begin
  nIdx := ListTruck.ItemIndex;
  ListTruck.Items.BeginUpdate;
  try
    ListTruck.Clear;
    ListTruck.Checkboxes := False;
    ListTruck.SmallImages := FDM.ImageBar;
                                  
    for i:=Low(gTrucks) to High(gTrucks) do
    if gTrucks[i].FTruckNo = nTruck then
    with ListTruck.Items.Add, gTrucks[i] do
    begin
      Caption := FBill;
      SubItems.Add(FStockName);
      SubItems.Add(FTruckNo);
      SubItems.Add(Format('%.2f', [FValue]));

      ImageIndex := cItemIconIndex;
      Data := Pointer(i);
    end;
  finally
    if nIdx < ListTruck.Items.Count then
      ListTruck.ItemIndex := nIdx;
    ListTruck.Items.EndUpdate;
  end;
end;

//Desc: ͬ�������
procedure TfFormBangFangM.EditTruckPropertiesChange(Sender: TObject);
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
procedure TfFormBangFangM.BtnGetClick(Sender: TObject);
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
procedure TfFormBangFangM.EditValuePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
var nStr: string;
begin
  if not gPopedomManager.HasPopedom(PopedomItem, sPopedom_Edit) then Exit;
  //�޸�Ȩ�޿���

  if EditValue.Properties.ReadOnly then
       nStr := '�Ƿ�Ҫ�ֶ�����ë��?'
  else nStr := '�Ƿ�Ҫ�Զ���ȡ����?';

  if QueryDlg(nStr, sAsk, Handle) then
    EditValue.Properties.ReadOnly := not EditValue.Properties.ReadOnly;
  //xxxxx
end;

//Desc: ���¾���
procedure TfFormBangFangM.EditValuePropertiesEditValueChanged(
  Sender: TObject);
var nStr: string;
    nVal: Double;
begin
  if ListTruck.Items.Count > 0 then
   if IsNumber(EditValue.Text, True) and (StrToFloat(EditValue.Text) > 0) then
    with gTrucks[Integer(ListTruck.Items[0].Data)] do
    if (FStockType = sFlag_Dai) or (FLading = sFlag_TiHuo) then
    begin
      nVal := StrToFloat(EditValue.Text);
      gInfo.FTruckNetW := GetNetWeight(FTruckID, nVal);

      nStr := '����:[ %s ] Ƥ��:[ %.2f ] ����:[ %.2f ]';
      dxGroup2.Caption := Format(nStr, [EditTruck.Text, nVal, gInfo.FTruckNetW]);
    end else
    begin
      gInfo.FTruckNetW := 0;
      dxGroup2.Caption := '�����б�';
     end;
end;

//Desc: ��֤�����Ƿ�����Ч��Χ
function TfFormBangFangM.IsWeightValid: Boolean;
var nStr: string;
    nInt: Integer;
    nP: TFormCommandParam;
    nVal,nNet,nBill,nTmp: Double;
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

    if FStockType = sFlag_Dai then
    begin
      nBill := 0;
      for nInt := ListTruck.Items.Count - 1 downto 0 do
        nBill := nBill + gTrucks[Integer(ListTruck.Items[nInt].Data)].FValue;
      //�����

      nVal := GetWeightWuCha(nBill);
      //�������
      nTmp := (nBill - nNet) * 1000;
      if nTmp < 0 then nTmp := - nTmp;
      //������
      Result := FloatRelation(nVal, nTmp, rtGE, cPrecision);

      if not Result  then
      begin
        nStr := '�ó�ʵ��������뿪Ʊ�����ϴ�,��ϸ����:' + #13#10#13#10 +
                '*.��Ʊ��: %.2f ��' + #13#10 +
                '*.װ����: %.2f ��' + #13#10 +
                '*.�����: %.2f ����' + #13#10#13#10 +
                'ϵͳ�������Ϊ %.2f ����,�Ƿ�����ó�������?';
        nStr := Format(nStr, [nBill, nNet, nTmp, nVal]);
        Result := QueryDlg(nStr, sAsk, Handle);
      end;
    end else
    begin
      nVal := GetValidMoneyByZK(gInfo.FZhiKa, gInfo.FZKMoney);
      nVal := nVal + FPrice * FValue;
      //���ý�

      if FPrice > 0 then
           nVal := nVal / FPrice
      else nVal := 0;
      //�������

      nVal := Float2Float(nVal, cPrecision);
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
end;

//Desc: ��������
procedure TfFormBangFangM.UpdateWeightData(const nTruck: TLadingTruckItem);
var nStr: string;
    nVal: Double;
begin
  MakeTruckBFM(nTruck, StrToFloat(EditValue.Text));
  //xxxxx

  with nTruck do
  begin
    if FStockType <> sFlag_San then Exit;
    //����ɢװ������Ͷ����ʽ�

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
    nStr := Format(nStr, [sTable_CusAccount, nVal, gInfo.FCusID]);
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

//Desc: ��������
function TfFormBangFangM.UpdateTiHuo(const nTruck: TLadingTruckItem): Boolean;
var nStr: string;
    i,nIdx: Integer;
    nTrucks: TDynamicTruckArray;
begin
  gHKItems.Clear;
  Result := IsWeightValid;
  if not Result then Exit;

  FDM.ADOConn.BeginTrans;
  try
    UpdateWeightData(nTruck);
    SaveSanHKData(gHKItems);

    if IsTruckAutoOut then
    begin
      LoadLadingTruckItems(gInfo.FCard, '', sFlag_TruckOut, nTrucks, nStr, False);
      //���������г���
      MakeTrucksOut(nTrucks, nTruck.FTruckID);
    end;
    FDM.ADOConn.CommitTrans;
  except
    Result := False;
    FDM.ADOConn.RollbackTrans;
    ShowMsg('����ë��ʧ��', sError); Exit;
  end;

  nStr := '';
  for i:=ListTruck.Items.Count - 1 downto 0 do
  begin
    nIdx := Integer(ListTruck.Items[0].Data);
    if gTrucks[nIdx].FStockType = sFlag_San then
      nStr := nStr + gTrucks[nIdx].FRecord + ',';
    //xxxxx
  end;

  for i:=gHKItems.Count - 1 downto 0 do
    nStr := nStr + PLadingTruckItem(gHKItems[i]).FRecord + ',';
  //xxxxx

  if nStr <> '' then
  begin
    System.Delete(nStr, Length(nStr), 1);
    PrintPoundReport(nStr, True);
  end;
end;

//Desc: ����ɢװ�ͻ�
function TfFormBangFangM.UpdateSanSongH(const nTruck: TLadingTruckItem): Boolean;
begin
  FDM.ADOConn.BeginTrans;
  try
    MakeTruckBFM(nTruck, StrToFloat(EditValue.Text));
    //xxxxx

    if IsTruckAutoOut then
      MakeSongHuoTruckOut(nTruck);
    //xxxxx

    FDM.ADOConn.CommitTrans;
    Result := True;
  except
    Result := False;
    FDM.ADOConn.RollbackTrans;
    ShowMsg('����ë��ʧ��', sError);
  end;
end;

//Desc: ��֤����
function TfFormBangFangM.OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean;
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
  end;
end;

//Desc: ����
procedure TfFormBangFangM.BtnOKClick(Sender: TObject);
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
      ShowMsg('����ë�سɹ�', sHint);
    end;
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormBangFangM, TfFormBangFangM.FormID);
  gHKItems := TList.Create;
finalization
  gHKItems.Free;
end.

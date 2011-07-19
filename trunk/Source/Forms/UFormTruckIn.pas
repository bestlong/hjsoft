{*******************************************************************************
  ����: dmzn@163.com 2010-3-14
  ����: ��������
*******************************************************************************}
unit UFormTruckIn;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, dxLayoutControl, StdCtrls, cxControls, cxCheckBox,
  cxEdit, cxTextEdit, cxContainer, cxMCListBox, ComCtrls, cxMaskEdit,
  cxButtonEdit, cxListView, cxGraphics, cxDropDownEdit, cxRadioGroup,
  cxLookAndFeels, cxLookAndFeelPainters;

type
  TfFormTruckIn = class(TfFormNormal)
    dxGroup2: TdxLayoutGroup;
    ListInfo: TcxMCListBox;
    dxLayout1Item3: TdxLayoutItem;
    ListTruck: TcxListView;
    dxLayout1Item7: TdxLayoutItem;
    EditTruck: TcxComboBox;
    dxLayout1Item4: TdxLayoutItem;
    EditCID: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    EditZID: TcxTextEdit;
    dxLayout1Item6: TdxLayoutItem;
    dxLayout1Group2: TdxLayoutGroup;
    Radio1: TcxRadioButton;
    dxLayout1Item9: TdxLayoutItem;
    Radio2: TcxRadioButton;
    dxLayout1Item10: TdxLayoutItem;
    dxLayout1Group4: TdxLayoutGroup;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EditTruckPropertiesChange(Sender: TObject);
    procedure ListTruckClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure Radio1Click(Sender: TObject);
    procedure ListTruckAdvancedCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; Stage: TCustomDrawStage;
      var DefaultDraw: Boolean);
  protected
    { Protected declarations }
    function OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean; override;
    procedure LoadTruckList;
    procedure InitFormData;
    //��������
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  IniFiles, DB, ULibFun, UMgrControl, UFormCtrl, UFormBase, UAdjustForm,
  USysGrid, USysBusiness, USysDB, USysConst, UDataModule;

type
  TZhiKaItem = record
    FZID: string;
    FCard: string;
  end;

var
  gZhiKa: TZhiKaItem;
  gLadItems: TDynamicTruckArray;
  //ȫ��ʹ��

//------------------------------------------------------------------------------
class function TfFormTruckIn.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nStr: string;
    nIdx: Integer;
    nP: TFormCommandParam;
    nTrucks: TDynamicTruckArray;
begin
  Result := nil;
  CreateBaseFormItem(cFI_FormVerifyCard, '', @nP);
  if (nP.FCommand <> cCmd_ModalResult) or (nP.FParamA <> mrOK) then Exit;

  gZhiKa.FCard := nP.FParamB;
  gZhiKa.FZID := nP.FParamC;

  if nP.FParamE = sFlag_Provide then
  begin
    nP.FParamA := gZhiKa.FCard;
    nP.FParamB := sFlag_TruckIn;
    CreateBaseFormItem(cFI_FormProvideInOut, '', @nP); Exit;
  end; //��Ӧ�ſ���ת

  if not LoadBillTruckItems(gZhiKa.FCard, nTrucks, nStr) then
  begin
    nStr := '������û���ҵ�Ҫ�����ĳ���,��������:' + #13#10 + #13#10 +
            AdjustHintToRead(nStr);
    ShowDlg(nStr, sHint); Exit;
  end;

  for nIdx:=Low(nTrucks) to High(nTrucks) do
    nTrucks[nIdx].FIsCombine := not IsTruckSongHuo(nTrucks[nIdx]);
  //ɢװ�ͻ����账��

  SetLength(gLadItems, 0);
  CombinTruckItems(nTrucks, gLadItems);

  if Length(gLadItems) < 1 then
  begin
    nStr := 'ɢװ�ͻ��������ֱ�ӵ��ŻҴ�.';
    nStr := '������û���ҵ�Ҫ�����ĳ���,��������:' + #13#10 + #13#10 +
            AdjustHintToRead(nStr);
    ShowDlg(nStr, sHint); Exit;
  end;

  with TfFormTruckIn.Create(Application) do
  begin
    Caption := '��������';
    InitFormData;
    ShowModal;
    Free;
  end;
end;

class function TfFormTruckIn.FormID: integer;
begin
  Result := cFI_FormTruckIn;
end;

procedure TfFormTruckIn.FormCreate(Sender: TObject);
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

procedure TfFormTruckIn.FormClose(Sender: TObject;
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
procedure TfFormTruckIn.InitFormData;
var nStr: string;
begin
  EditCID.Text := gZhiKa.FCard;
  EditZID.Text := gZhiKa.FZID;

  if LoadZhiKaInfo( gZhiKa.FZID, ListInfo, nStr) = nil then
  begin
    BtnOK.Enabled := False;
    ShowMsg(nStr, sHint); Exit;
  end;

  gLadItems[0].FSelect := True;
  LoadTruckList;
end;

//Desc: ���복���б�
procedure TfFormTruckIn.LoadTruckList;
var nIdx,nD,nS: integer;
begin
  nD := 0;
  nS := 0;
  EditTruck.Clear;

  for nIdx:=Low(gLadItems) to High(gLadItems) do
  begin
    if EditTruck.Properties.Items.IndexOf(gLadItems[nIdx].FTruckNo) < 0 then
      EditTruck.Properties.Items.Add(gLadItems[nIdx].FTruckNo);
    //xxxxx

    if gLadItems[nIdx].FStockType = sFlag_Dai then
         Inc(nD)
    else Inc(nS);
  end;

  if nD >= nS then
       Radio1.Checked := True
  else Radio2.Checked := True;
  EditTruck.ItemIndex := 0;
end;

//Desc: ����nTruck��Ӧ�������
procedure TfFormTruckIn.EditTruckPropertiesChange(Sender: TObject);
var nIdx: Integer;
begin
  ListTruck.Clear;
  if EditTruck.ItemIndex < 0 then Exit;

  for nIdx:=Low(gLadItems) to High(gLadItems) do
  if CompareText(gLadItems[nIdx].FTruckNo, EditTruck.Text) = 0 then
  with ListTruck.Items.Add,gLadItems[nIdx] do
  begin
    Caption := FBill;
    SubItems.Add(FTruckNo);
    SubItems.Add(FStockName);
    SubItems.Add(FloatToStr(FValue));

    Checked := gLadItems[nIdx].FSelect and
               ((Radio1.Checked and (FStockType = sFlag_Dai)) or
               (Radio2.Checked and (FStockType = sFlag_San)));;
    Data := Pointer(nIdx);
  end;
end;

//Desc: ��ɢ�л�
procedure TfFormTruckIn.Radio1Click(Sender: TObject);
begin
  if TWinControl(Sender).Focused then EditTruckPropertiesChange(nil);
end;

//Desc: ͬ��ѡ��
procedure TfFormTruckIn.ListTruckClick(Sender: TObject);
var i,nIdx: Integer;
begin
  for i:=ListTruck.Items.Count - 1 downto 0 do
  begin
    nIdx := Integer(ListTruck.Items[i].Data);
    with gLadItems[nIdx] do
    if (Radio1.Checked and (FStockType = sFlag_Dai)) or
       (Radio2.Checked and (FStockType = sFlag_San)) then
    begin
      FSelect := ListTruck.Items[i].Checked;
    end else
    begin
      ListTruck.Items[i].Checked := False;
    end;
  end;
end;

procedure TfFormTruckIn.ListTruckAdvancedCustomDrawItem(
  Sender: TCustomListView; Item: TListItem; State: TCustomDrawState;
  Stage: TCustomDrawStage; var DefaultDraw: Boolean);
var nIdx: integer;
begin
  nIdx := Integer(Item.Data);
  with gLadItems[nIdx] do
  begin
    if (Radio1.Checked and (FStockType <> sFlag_Dai)) or
       (Radio2.Checked and (FStockType <> sFlag_San)) then
    begin
      Sender.Canvas.Font.Color := clSilver;
    end;
  end;
end;

//Desc: ��֤����
function TfFormTruckIn.OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean;
var nStr: string;
    i,nIdx,nNum: Integer;
begin
  Result := True;

  if Sender = EditTruck then
  begin
    Result := EditTruck.ItemIndex > -1;
    nHint := '��ѡ����Ч�ĳ���';
    if not Result then Exit;

    Result := not IsTruckIn(EditTruck.Text);
    nHint := '�ó������,���Ժ�';
  end else

  if Sender = ListTruck then
  begin
    nNum := 0;
    for nIdx:=ListTruck.Items.Count - 1 downto 0 do
    begin
      if ListTruck.Items[nIdx].Checked then
           Inc(nNum)
      else Continue;

      i := Integer(ListTruck.Items[nIdx].Data);
      with gLadItems[i] do
      if (Radio1.Checked and (FStockType <> sFlag_Dai)) or
         (Radio2.Checked and (FStockType <> sFlag_San)) then
      begin
        Result := False;
        nHint := '����ɢ���ܻ��װ��'; Exit;
      end;
    end;

    Result := nNum > 0;
    nHint := '��ѡ��Ҫ����ĳ���';
    if not Result then Exit;

    Result := Radio1.Checked or (nNum < 2);
    nHint := 'ɢ�Ҳ��ܺϳ����';
    if not Result then Exit;

    nStr := Format('��ѡ����[ %d ]�������,ȷ��Ҫ�ϳ������?', [nNum]);
    Result := (nNum < 2) or QueryDlg(nStr, sAsk);
    nHint := '������ѡ��';
  end;
end;

//Desc: ͬ�����
procedure TfFormTruckIn.BtnOKClick(Sender: TObject);
var i,nIdx: Integer;
    nTrucks: TDynamicTruckArray;
begin
  if not IsDataValid then Exit;

  FDM.ADOConn.BeginTrans;
  try
    for nIdx:=Low(gLadItems) to High(gLadItems) do
      gLadItems[nIdx].FIsCombine := False;
    //���账��

    for i:=ListTruck.Items.Count - 1 downto 0 do
    if ListTruck.Items[i].Checked then
    begin
      nIdx := Integer(ListTruck.Items[i].Data);
      gLadItems[nIdx].FIsCombine := True;
    end;

    CombinTruckItems(gLadItems, nTrucks);
    //����������
    MakeTrucksIn(nTrucks);

    FDM.ADOConn.CommitTrans;
    ModalResult := mrOk;
    ShowMsg('�����ѳɹ�����', sHint);
  except
    FDM.ADOConn.RollbackTrans;
    ShowMsg('���ݲ���ʧ��', sError);
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormTruckIn, TfFormTruckIn.FormID);
end.

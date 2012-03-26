{*******************************************************************************
  ����: dmzn@163.com 2010-3-14
  ����: ɢװ�Ż�
*******************************************************************************}
unit UFormLadingSan;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFormNormal, ComCtrls, cxTextEdit, cxMaskEdit, cxButtonEdit, cxListView,
  cxEdit, cxCheckBox, cxContainer, cxMCListBox, dxLayoutControl, StdCtrls,
  cxControls, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters;

type
  TfFormLadingSan = class(TfFormNormal)
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
    EditStock: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    EditNo: TcxTextEdit;
    dxLayout1Item8: TdxLayoutItem;
    dxLayout1Group3: TdxLayoutGroup;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ListTruckClick(Sender: TObject);
    procedure ListTruckSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure EditNoExit(Sender: TObject);
    procedure ListTruckDblClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
  protected
    { Protected declarations }
     function OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean; override;
    //���ຯ��
    procedure InitFormData(const nID: string);
    //��������
    procedure LoadTruckList;
    //���복��
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
  IniFiles, DB, ULibFun, UMgrControl, UFormCtrl, UFormBase, UForminputbox,
  USysGrid, USysBusiness, USysDB, USysConst, UDataModule;

type
  TZhiKaItem = record
    FZID: string;
    FCard: string;
    FHint: string;
  end; 

var
  gZhiKa: TZhiKaItem;
  gTrucks: TDynamicTruckArray;
  //ȫ��ʹ��

//------------------------------------------------------------------------------
//Desc: �Ƿ��з�����(�ͻ�)�����
function HasSongHBill: Boolean;
var nStr: string;
    nIdx: Integer;
    nTrucks: TDynamicTruckArray;
begin
  Result := False;
  if not LoadBillTruckItems(gZhiKa.FCard, nTrucks, nStr) then Exit;

  for nIdx:=Low(nTrucks) to High(nTrucks) do
    nTrucks[nIdx].FIsCombine := IsTruckSongHuo(nTrucks[nIdx]);
  //xxxxx

  SetLength(gTrucks, 0);
  CombinTruckItems(nTrucks, gTrucks);
  Result := Length(gTrucks) > 0;
end;

class function TfFormLadingSan.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nStr: string;
    nP: TFormCommandParam;
begin
  Result := nil;
  if Assigned(nParam) then
       nP := PFormCommandParam(nParam)^
  else FillChar(nP, SizeOf(nP), #0);

  if (nP.FParamB = '') or (nP.FParamC = '') then
  begin
    CreateBaseFormItem(cFI_FormVerifyCard, '', @nP);
    if (nP.FCommand <> cCmd_ModalResult) or (nP.FParamA <> mrOK) then Exit;
  end;

  with gZhiKa do
  begin
    FCard := nP.FParamB;
    FZID := nP.FParamC;
  end;

  if not (LoadLadingTruckItems(gZhiKa.FCard, sFlag_TruckBFP, sFlag_TruckFH,
     gTrucks, nStr) or HasSongHBill) then
  begin
    nStr := '�ŻҴ�û���ҵ��ʺϵĳ���,��������:' + #13#10 + #13#10 +
            AdjustHintToRead(nStr);
    ShowDlg(nStr, sHint); Exit;
  end;

  with TfFormLadingSan.Create(Application) do
  begin
    Caption := 'ɢװ���';
    InitFormData(gZhiKa.FZID);

    if Assigned(nParam) then
    with PFormCommandParam(nParam)^ do
    begin
      FCommand := cCmd_ModalResult;
      FParamA := ShowModal;
    end else ShowModal;
    Free;
  end;
end;

class function TfFormLadingSan.FormID: integer;
begin
  Result := cFI_FormLadSan;
end;

procedure TfFormLadingSan.FormCreate(Sender: TObject);
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

procedure TfFormLadingSan.FormClose(Sender: TObject;
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
procedure TfFormLadingSan.InitFormData(const nID: string);
var nStr: string;
begin
  if LoadZhiKaInfo(nID, ListInfo, nStr) = nil then
  begin
    BtnOK.Enabled := False;
    ShowMsg(nStr, sHint); Exit;
  end;

  EditZK.Text := gZhiKa.FZID;
  EditCard.Text := gZhiKa.FCard;

  ActiveControl := EditNo;
  LoadTruckList;
end;

//Desc: ���복���б�����
procedure TfFormLadingSan.LoadTruckList;
var i,nIdx: Integer;
begin
  nIdx := ListTruck.ItemIndex;
  if nIdx < 0 then nIdx := 0;
  ListTruck.Items.BeginUpdate;
  try
    ListTruck.Clear;
    if gTrucks[0].FIsLading then
    begin
      ListTruck.Checkboxes := True;
      ListTruck.SmallImages := nil;
    end else
    begin
      ListTruck.Checkboxes := False;
      ListTruck.SmallImages := FDM.ImageBar;
    end;

    for i:=Low(gTrucks) to High(gTrucks) do
    with ListTruck.Items.Add, gTrucks[i] do
    begin
      Caption := FBill;
      SubItems.Add(FTruckNo);
      SubItems.Add(FStockName);
      SubItems.Add(FStockNo);

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

//Desc: ͬ��ѡ��
procedure TfFormLadingSan.ListTruckClick(Sender: TObject);
var nIdx: integer;
begin
  for nIdx:=Low(gTrucks) to High(gTrucks) do
   if gTrucks[nIdx].FSelect <> ListTruck.Items[nIdx].Checked then
    gTrucks[nIdx].FSelect := ListTruck.Items[nIdx].Checked;
  //xxxxx
end;

procedure TfFormLadingSan.ListTruckSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
var nIdx: integer;
begin
  nIdx := Integer(Item.Data);
  EditStock.Text := gTrucks[nIdx].FStockName;
  EditNo.Text := gTrucks[nIdx].FStockNo;
end;

//Desc: ͬ�����
procedure TfFormLadingSan.EditNoExit(Sender: TObject);
begin
  if ListTruck.ItemIndex > -1 then
  with gTrucks[ListTruck.ItemIndex] do
  begin
    EditNo.Text := Trim(EditNo.Text);
    if EditNo.Text <> '' then
      SetStockNo(FStockName, EditNo.Text);
    //xxxxx

    FStockNo := EditNo.Text;
    LoadTruckList;
  end;
end;

//Desc: ����ˮ����
procedure TfFormLadingSan.ListTruckDblClick(Sender: TObject);
var nStr: string;
begin
  if ListTruck.ItemIndex > -1 then
  with gTrucks[ListTruck.ItemIndex] do
  begin
    nStr := FStockNo;
    while True do
    begin
      if ShowInputBox('�������µ�ˮ����:', sHint, nStr, 15) then
           nStr := Trim(nStr)
      else Exit;

      if nStr <> '' then
           Break
      else ShowMsg('��������Ч��ˮ����', sHint);
    end;

    SetStockNo(FStockName, nStr);
    FStockNo := nStr;
    LoadTruckList;
  end;
end;

//Desc: ��֤����
function TfFormLadingSan.OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean;
var nStr: string;
    nIdx,nNum: integer;
begin
  Result := True;
  if Sender <> ListTruck then Exit;

  if not gTrucks[0].FIsLading then
  begin
    Result := ListTruck.ItemIndex > -1;
    nHint := '��ѡ��Ҫ����ĳ���';
    if not Result then Exit;

    Result := not IsTruckIn(gTrucks[ListTruck.ItemIndex].FTruckNo);
    nHint := '�ó������,���Ժ�'; Exit;
  end;

  nNum := 0;
  for nIdx:=Low(gTrucks) to High(gTrucks) do
   if gTrucks[nIdx].FSelect then Inc(nNum);
  //xxxxx

  Result := nNum > 0;
  nHint := '��ѡ��Ҫ����ĳ���';
  if not Result then Exit;

  nStr := Format('��ѡ����[ %d ]�������,ȷ��Ҫȫ�������?', [nNum]);
  Result := (nNum < 2) or QueryDlg(nStr, sAsk);
  nHint := '������ѡ��';
end;

//Desc: ����
procedure TfFormLadingSan.BtnOKClick(Sender: TObject);
var nStr,nSQL: string;
    nIdx: integer;
begin
  if not IsDataValid then Exit;

  FDM.ADOConn.BeginTrans;
  try
    nStr := 'Update $TL Set T_FHSTime=$FT,T_FHMan=''$FM'',' +
            'T_Status=''$FH'',T_NextStatus=''$BFM'' Where T_ID=''$ID''';
    nStr := MacroValue(nStr, [MI('$TL', sTable_TruckLog),
            MI('$FT', FDM.SQLServerNow), MI('$FM', gSysParam.FUserID),
            MI('$FH', sFlag_TruckFH), MI('$BFM', sFlag_TruckBFM)]);
    //xxxxx

    if not gTrucks[0].FIsLading then
    begin
      for nIdx:=Low(gTrucks) to High(gTrucks) do
        gTrucks[nIdx].FSelect := False;
      gTrucks[ListTruck.ItemIndex].FSelect := True;

      MakeTrucksIn(gTrucks);
      nSQL := MacroValue(nStr, [MI('$ID', gTrucks[ListTruck.ItemIndex].FTruckID)]);
      FDM.ExecuteSQL(nSQL);
    end else //ɢװ�ͻ�
    begin
      for nIdx:=Low(gTrucks) to High(gTrucks) do
      with gTrucks[nIdx] do
      begin
        if not FSelect then Continue;
        nSQL := MacroValue(nStr, [MI('$ID', FTruckID)]);
        FDM.ExecuteSQL(nSQL);

        nSQL := 'Update $TE Set E_StockNo=''$No'' Where E_ID=$ID';
        nSQL := MacroValue(nSQL, [MI('$TE', sTable_TruckLogExt),
                MI('$No', FStockNo), MI('$ID', FRecord)]);
        FDM.ExecuteSQL(nSQL);
      end;
    end;

    FDM.ADOConn.CommitTrans;
    ModalResult := mrOk;
    ShowMsg('ɢװ����ɹ�', sHint);
  except
    FDM.ADOConn.RollbackTrans;
    ShowMsg('���ݲ���ʧ��', sError);
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormLadingSan, TfFormLadingSan.FormID);
end.

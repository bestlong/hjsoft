{*******************************************************************************
  ����: dmzn@163.com 2010-3-14
  ����: ջ̨���
*******************************************************************************}
unit UFormLadingDai;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFormNormal, ComCtrls, cxTextEdit, cxMaskEdit, cxButtonEdit, cxListView,
  cxEdit, cxCheckBox, cxContainer, cxMCListBox, dxLayoutControl, StdCtrls,
  cxControls, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters;

type
  TfFormLadingDai = class(TfFormNormal)
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
  protected
    { Protected declarations }
     function OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean; override;
    procedure GetSaveSQLList(const nList: TStrings); override;
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
class function TfFormLadingDai.CreateForm(const nPopedom: string;
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

  if not LoadLadingTruckItems(gZhiKa.FCard, sFlag_TruckBFP, sFlag_TruckZT,
     gTrucks, nStr) then
  begin
    nStr := 'ջ̨û���ҵ��ʺϵĳ���,��������:' + #13#10 + #13#10 +
            AdjustHintToRead(nStr);
    ShowDlg(nStr, sHint); Exit;
  end;

  with TfFormLadingDai.Create(Application) do
  begin
    Caption := '��װ���';
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

class function TfFormLadingDai.FormID: integer;
begin
  Result := cFI_FormLadDai;
end;

procedure TfFormLadingDai.FormCreate(Sender: TObject);
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

procedure TfFormLadingDai.FormClose(Sender: TObject;
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
procedure TfFormLadingDai.InitFormData(const nID: string);
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
procedure TfFormLadingDai.LoadTruckList;
var i,nIdx: Integer;
begin
  nIdx := ListTruck.ItemIndex;
  if nIdx < 0 then nIdx := 0;
  ListTruck.Items.BeginUpdate;
  try
    ListTruck.Clear;

    for i:=Low(gTrucks) to High(gTrucks) do
    with ListTruck.Items.Add, gTrucks[i] do
    begin
      Caption := FBill;
      SubItems.Add(FTruckNo);
      SubItems.Add(FStockName);
      SubItems.Add(FStockNo);

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
procedure TfFormLadingDai.ListTruckClick(Sender: TObject);
var nIdx: integer;
begin
  for nIdx:=Low(gTrucks) to High(gTrucks) do
   if gTrucks[nIdx].FSelect <> ListTruck.Items[nIdx].Checked then
    gTrucks[nIdx].FSelect := ListTruck.Items[nIdx].Checked;
  //xxxxx
end;

procedure TfFormLadingDai.ListTruckSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
var nIdx: integer;
begin
  nIdx := Integer(Item.Data);
  EditStock.Text := gTrucks[nIdx].FStockName;
  EditNo.Text := gTrucks[nIdx].FStockNo;
end;

//Desc: ͬ�����
procedure TfFormLadingDai.EditNoExit(Sender: TObject);
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
procedure TfFormLadingDai.ListTruckDblClick(Sender: TObject);
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
function TfFormLadingDai.OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean;
var nStr: string;
    nIdx,nNum: integer;
begin
  Result := True;
  if Sender <> ListTruck then Exit;

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
procedure TfFormLadingDai.GetSaveSQLList(const nList: TStrings);
var nStr: string;
    nIdx: integer;
begin
  for nIdx:=Low(gTrucks) to High(gTrucks) do
  with gTrucks[nIdx] do
  begin
    nStr := 'Update $TL Set T_ZTTime=$ZT,T_ZTMan=''$ZM'',T_Status=''$ST'',' +
            'T_NextStatus=''$BFM'' Where T_ID=''$ID''';
    nStr := MacroValue(nStr, [MI('$TL', sTable_TruckLog), MI('$ID', FTruckID),
            MI('$ZT', FDM.SQLServerNow), MI('$ZM', gSysParam.FUserID),
            MI('$ST', sFlag_TruckZT), MI('$BFM', sFlag_TruckBFM)]);
    nList.Add(nStr);

    nStr := 'Update $TE Set E_StockNo=''$No'' Where E_ID=$ID';
    nStr := MacroValue(nStr, [MI('$TE', sTable_TruckLogExt),
            MI('$No', FStockNo), MI('$ID', FRecord)]);
    nList.Add(nStr);
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormLadingDai, TfFormLadingDai.FormID);
end.

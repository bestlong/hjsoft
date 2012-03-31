{*******************************************************************************
  ����: dmzn@163.com 2010-3-14
  ����: ��������
*******************************************************************************}
unit UFormTruckOut;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFormNormal, ComCtrls, cxTextEdit, cxMaskEdit, cxButtonEdit, cxListView,
  cxEdit, cxCheckBox, cxContainer, cxMCListBox, dxLayoutControl, StdCtrls,
  cxControls, cxGraphics, cxDropDownEdit, cxLookAndFeels,
  cxLookAndFeelPainters;

type
  TfFormTruckOut = class(TfFormNormal)
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
    EditTruck: TcxComboBox;
    dxLayout1Item8: TdxLayoutItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EditTruckPropertiesChange(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
  protected
    { Protected declarations }
    function OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean; override;
    procedure InitFormData(const nID: string);
    //��������
    procedure LoadTruckList;
    //���복��
    procedure LoadLadingList(const nTruck: string);
    //�����
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
  IniFiles, DB, ULibFun, UMgrControl, UDataModule, UFormBase, USysBusiness,
  USysGrid, USysDB, USysConst, USysPopedom;

type
  TZhiKaItem = record
    FZID: string;
    FCard: string;
    FCusID: string;
    FTruckIdx: Integer;
  end;

var
  gZhiKa: TZhiKaItem;
  gTrucks: TDynamicTruckArray;
  //ȫ��ʹ��

//------------------------------------------------------------------------------
class function TfFormTruckOut.CreateForm(const nPopedom: string;
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

  with gZhiKa do
  begin
    FCard := nP.FParamB;
    FZID := nP.FParamC;
    FTruckIdx := -1;
  end;

  if nP.FParamE = sFlag_Provide then
  begin
    nP.FParamA := gZhiKa.FCard;
    nP.FParamB := sFlag_TruckOut;
    CreateBaseFormItem(cFI_FormProvideInOut, '', @nP); Exit;
  end; //��Ӧ�ſ���ת

  if not LoadLadingTruckItems(gZhiKa.FCard, sFlag_TruckBFM, sFlag_TruckOut,
     gTrucks, nStr, False) then
  begin
    nStr := '������û���ҵ�Ҫ�����ĳ���,��������:' + #13#10 + #13#10 +
            AdjustHintToRead(nStr);
    ShowDlg(nStr, sHint); Exit;
  end;

  with TfFormTruckOut.Create(Application) do
  begin
    Caption := '��������';
    PopedomItem := nPopedom;
    
    InitFormData(gZhiKa.FZID);
    ShowModal;
    Free;
  end;
end;

class function TfFormTruckOut.FormID: integer;
begin
  Result := cFI_FormTruckOut;
end;

procedure TfFormTruckOut.FormCreate(Sender: TObject);
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

procedure TfFormTruckOut.FormClose(Sender: TObject;
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
procedure TfFormTruckOut.InitFormData(const nID: string);
var nStr: string;
    nDB: TDataSet;
begin
  nDB := LoadZhiKaInfo(nID, ListInfo, nStr);
  if Assigned(nDB) then
  begin
    gZhiKa.FCusID := nDB.FieldByName('Z_Custom').AsString;
  end else
  begin
    BtnOK.Enabled := False;
    ShowMsg(nStr, sHint); Exit;
  end;

  EditZK.Text := gZhiKa.FZID;
  EditCard.Text := gZhiKa.FCard;
  LoadTruckList;
end;

//Desc: ���복���б�����
procedure TfFormTruckOut.LoadTruckList;
var nIdx: Integer;
begin
  EditTruck.Clear;
  for nIdx:=Low(gTrucks) to High(gTrucks) do
   if EditTruck.Properties.Items.IndexOf(gTrucks[nIdx].FTruckNo) < 0 then
    EditTruck.Properties.Items.Add(gTrucks[nIdx].FTruckNo);
  if EditTruck.Properties.Items.Count > 0 then EditTruck.ItemIndex := 0;
end;

//Desc: ����nTruck��Ӧ�������
procedure TfFormTruckOut.LoadLadingList(const nTruck: string);
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
procedure TfFormTruckOut.EditTruckPropertiesChange(Sender: TObject);
begin
  if (EditTruck.ItemIndex <> gZhiKa.FTruckIdx) and
     (EditTruck.ItemIndex > -1) then
  begin
    gZhiKa.FTruckIdx := EditTruck.ItemIndex;
    LoadLadingList(EditTruck.Text);
  end;
end;

//Desc: ��֤����
function TfFormTruckOut.OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean;
begin
  Result := True;

  if Sender = EditTruck then
  begin
    Result := (EditTruck.ItemIndex > -1) and (ListTruck.Items.Count > 0);
    nHint := '��ѡ����Ч�ĳ���';
  end;
end;

procedure TfFormTruckOut.BtnOKClick(Sender: TObject);
var nInt: Integer;
begin
  if IsDataValid then
  begin
    nInt := Integer(ListTruck.Items[0].Data);
    if IsTruckSongHuo(gTrucks[nInt]) then
         MakeSongHuoTruckOut(gTrucks[nInt])
    else MakeTrucksOut(gTrucks, gTrucks[nInt].FTruckID);

    ModalResult := mrOk;
    ShowMsg('�����ѳɹ�����', sHint);
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormTruckOut, TfFormTruckOut.FormID);
end.

{*******************************************************************************
  作者: dmzn@163.com 2010-3-14
  描述: 车辆出厂
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
    //载入数据
    procedure LoadTruckList;
    //载入车辆
    procedure LoadLadingList(const nTruck: string);
    //提货单
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
    //基类函数
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
  //全局使用

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
  end; //供应磁卡跳转

  if not LoadLadingTruckItems(gZhiKa.FCard, sFlag_TruckBFM, sFlag_TruckOut,
     gTrucks, nStr, False) then
  begin
    nStr := '门卫室没有找到要出厂的车辆,详情如下:' + #13#10 + #13#10 +
            AdjustHintToRead(nStr);
    ShowDlg(nStr, sHint); Exit;
  end;

  with TfFormTruckOut.Create(Application) do
  begin
    Caption := '车辆出厂';
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
//Desc: 载入nID纸卡的内容
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

//Desc: 载入车辆列表到界面
procedure TfFormTruckOut.LoadTruckList;
var nIdx: Integer;
begin
  EditTruck.Clear;
  for nIdx:=Low(gTrucks) to High(gTrucks) do
   if EditTruck.Properties.Items.IndexOf(gTrucks[nIdx].FTruckNo) < 0 then
    EditTruck.Properties.Items.Add(gTrucks[nIdx].FTruckNo);
  if EditTruck.Properties.Items.Count > 0 then EditTruck.ItemIndex := 0;
end;

//Desc: 载入nTruck对应的提货单
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

//Desc: 同步提货单
procedure TfFormTruckOut.EditTruckPropertiesChange(Sender: TObject);
begin
  if (EditTruck.ItemIndex <> gZhiKa.FTruckIdx) and
     (EditTruck.ItemIndex > -1) then
  begin
    gZhiKa.FTruckIdx := EditTruck.ItemIndex;
    LoadLadingList(EditTruck.Text);
  end;
end;

//Desc: 验证数据
function TfFormTruckOut.OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean;
begin
  Result := True;

  if Sender = EditTruck then
  begin
    Result := (EditTruck.ItemIndex > -1) and (ListTruck.Items.Count > 0);
    nHint := '请选择有效的车辆';
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
    ShowMsg('车辆已成功放行', sHint);
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormTruckOut, TfFormTruckOut.FormID);
end.

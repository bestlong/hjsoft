{*******************************************************************************
  作者: dmzn@163.com 2010-3-15
  描述: 卡片信息
*******************************************************************************}
unit UFormZhiKaInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, dxLayoutControl, StdCtrls, cxControls, cxContainer,
  cxMCListBox, ComCtrls, cxListView, cxEdit, cxTextEdit, cxGraphics,
  cxMaskEdit, cxDropDownEdit, cxLookAndFeels, cxLookAndFeelPainters;

type
  TfFormZhiKaInfo = class(TfFormNormal)
    dxGroup2: TdxLayoutGroup;
    dxLayout1Item3: TdxLayoutItem;
    ListInfo: TcxMCListBox;
    dxLayout1Item4: TdxLayoutItem;
    EditZK: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    EditCard: TcxTextEdit;
    dxLayout1Item6: TdxLayoutItem;
    dxLayout1Group2: TdxLayoutGroup;
    ListTruck: TcxListView;
    EditSC: TcxTextEdit;
    dxLayout1Item8: TdxLayoutItem;
    EditXT: TcxTextEdit;
    dxLayout1Item9: TdxLayoutItem;
    dxGroup3: TdxLayoutGroup;
    BtnMore: TButton;
    dxLayout1Item11: TdxLayoutItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnMoreClick(Sender: TObject);
  protected
    { Protected declarations }
    procedure LoadFormData(const nZID: string);
    //载入数据
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  DB, IniFiles, ULibFun, UMgrControl, UAdjustForm, UFormBase, USysConst,
  USysDB, USysGrid, USysBusiness, UDataModule, USysPopedom, UForminputbox;

type
  TCommonInfo = record
    FZhiKa: string;
    FCusID: string;
    FCardNo: string;
  end;

var
  gInfo: TCommonInfo;
  //全局使用

//------------------------------------------------------------------------------
class function TfFormZhiKaInfo.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nStr,nSQL: string;
begin
  Result := nil;
  if Assigned(nParam) then
       nStr := PFormCommandParam(nParam).FParamA
  else nStr := '';

  while True do
  begin
    if nStr = '' then
     if not ShowInputBox('请输入有效的纸卡或磁卡编号:', '纸卡', nStr) then Exit;
    //xxxxx
    
    nSQL := 'Select Z_ID,C_Card From %s zk ' +
            ' Left Join %s zc on zc.C_ZID=zk.Z_ID ' +
            'Where Z_ID=''%s'' or C_Card=''%s''';
    nSQL := Format(nSQL, [sTable_ZhiKa, sTable_ZhiKaCard, nStr, nStr]);

    with FDM.QueryTemp(nSQL) do
    if RecordCount > 0 then
    begin
      gInfo.FZhiKa := Fields[0].AsString;
      gInfo.FCardNo := Fields[1].AsString; Break;
    end else
    begin
      nStr := '';
      ShowMsg('输入内容无效', '请重试');
    end;
  end;

  with TfFormZhiKaInfo.Create(Application) do
  begin
    Caption := '卡片';
    PopedomItem := nPopedom;
    BtnMore.Enabled := gPopedomManager.HasPopedom(nPopedom, sPopedom_Add);

    LoadFormData(gInfo.FZhiKa);
    ShowModal;
    Free;
  end;
end;

class function TfFormZhiKaInfo.FormID: integer;
begin
  Result := cFI_FormZhiKaQuery;
end;

procedure TfFormZhiKaInfo.FormCreate(Sender: TObject);
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

procedure TfFormZhiKaInfo.FormClose(Sender: TObject; var Action: TCloseAction);
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
//Desc: 载入界面数据
procedure TfFormZhiKaInfo.LoadFormData(const nZID: string);
var nStr: string;
    nVal: Double;
    nDB: TDataSet;
    nBool: Boolean;
    nDT,nValid: TDateTime;
begin
  EditZK.Text := gInfo.FZhiKa;
  EditCard.Text := gInfo.FCardNo;
  nDB := LoadZhiKaInfo(gInfo.FZhiKa, ListInfo, nStr);

  if Assigned(nDB) then
  begin
    nValid := nDB.FieldByName('Z_ValidDays').AsDateTime;
    gInfo.FCusID := nDB.FieldByName('Z_Custom').AsString;
  end else
  begin
    ShowMsg(nStr, sHint); Exit;
  end;

  nVal := GetValidMoneyByZK(gInfo.FZhiKa, nBool);
  if nBool then
       nStr := '限提纸卡 可用金额:[ %.2f ]元'
  else nStr := '普通纸卡 可用金额:[ %.2f ]元';
  EditXT.Text := Format(nStr, [nVal]);

  nDT := nValid - FDM.ServerNow;
  if nDT <= 0 then
  begin
    nDT := -nDT;
    nStr := '有效期至:[ %s ] 已过期:[ %d ]天';
  end else nStr := '有效期至:[ %s ] 还剩余:[ %d ]天';
  EditSC.Text := Format(nStr, [Date2Str(nValid), Trunc(nDT)]);

  //----------------------------------------------------------------------------
  nStr := 'Select T_Truck,T_Status,T_InTime From %s te ' +
          ' Left Join %s tl on tl.T_ID=te.E_TID ' +
          'Where E_ZID=''%s'' Order By T_Truck';
  nStr := Format(nStr, [sTable_TruckLogExt, sTable_TruckLog, gInfo.FZhiKa]);

  ListTruck.Clear;
  ListTruck.SmallImages := FDM.ImageBar;

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    First;

    while not Eof do
    with ListTruck.Items.Add do
    begin
      Caption := FieldByName('T_Truck').AsString;
      SubItems.Add(TruckStatusToStr(FieldByName('T_Status').AsString));
      SubItems.Add(DateTime2Str(FieldByName('T_InTime').AsDateTime));

      ImageIndex := cItemIconIndex;
      Next;
    end;
  end;
end;

//Desc: 更多纸卡信息
procedure TfFormZhiKaInfo.BtnMoreClick(Sender: TObject);
var nP: TFormCommandParam;
begin
  nP.FCommand := cCmd_ViewData;
  nP.FParamA := gInfo.FZhiKa;
  nP.FParamB := gInfo.FCusID;
  CreateBaseFormItem(cFI_FormZhiKaInfoExt1, PopedomItem, @nP);
end;

initialization
  gControlManager.RegCtrl(TfFormZhiKaInfo, TfFormZhiKaInfo.FormID);
end.

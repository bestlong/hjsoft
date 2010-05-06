{*******************************************************************************
  作者: dmzn@163.com 2010-3-15
  描述: 卡片扩展信息
*******************************************************************************}
unit UFormZhiKaInfoExt;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, dxLayoutControl, StdCtrls, cxControls, cxContainer,
  cxMCListBox, ComCtrls, cxListView, cxEdit, cxTextEdit, cxGraphics,
  cxMaskEdit, cxDropDownEdit;

type
  TfFormZhiKaInfoExt = class(TfFormNormal)
    dxLayout1Item4: TdxLayoutItem;
    ListCard: TcxListView;
    dxGroup2: TdxLayoutGroup;
    dxLayout1Item5: TdxLayoutItem;
    ListStock: TcxListView;
    dxGroup3: TdxLayoutGroup;
    EditSC: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    BtnMore: TButton;
    dxLayout1Item6: TdxLayoutItem;
    EditXT: TcxTextEdit;
    dxLayout1Item7: TdxLayoutItem;
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
  IniFiles, ULibFun, UMgrControl, UFormBase, USysConst, USysDB, USysGrid,
  UDataModule, USysBusiness;

type
  TCommonInfo = record
    FZhiKa: string;
  end;

var
  gInfo: TCommonInfo;
  //全局使用

//------------------------------------------------------------------------------
class function TfFormZhiKaInfoExt.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
begin
  Result := nil;
  if Assigned(nParam) then
       gInfo.FZhiKa := PFormCommandParam(nParam).FParamA
  else Exit;

  with TfFormZhiKaInfoExt.Create(Application) do
  begin
    Caption := '卡片 - ' + gInfo.FZhiKa;
    LoadFormData(gInfo.FZhiKa);
    ShowModal;
    Free;
  end;
end;

class function TfFormZhiKaInfoExt.FormID: integer;
begin
  Result := cFI_FormZhiKaInfoExt1;
end;

procedure TfFormZhiKaInfoExt.FormCreate(Sender: TObject);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadFormConfig(Self, nIni);
    LoadcxListViewConfig(Name, ListStock, nIni);
    LoadcxListViewConfig(Name, ListCard, nIni);
  finally
    nIni.Free;
  end;
end;

procedure TfFormZhiKaInfoExt.FormClose(Sender: TObject; var Action: TCloseAction);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveFormConfig(Self, nIni);
    SavecxListViewConfig(Name, ListStock, nIni);
    SavecxListViewConfig(Name, ListCard, nIni);
  finally
    nIni.Free;
  end;
end;

//------------------------------------------------------------------------------
//Desc: 载入界面数据
procedure TfFormZhiKaInfoExt.LoadFormData(const nZID: string);
var nStr: string;
    nVal: Double;
    nDT: TDateTime;
    nBool: Boolean;
begin
  nStr := 'Select * From %s Where D_ZID=''%s''';
  nStr := Format(nStr, [sTable_ZhiKaDtl, nZID]);

  ListStock.Items.Clear;
  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    First;

    while not Eof do
    with ListStock.Items.Add do
    begin
      Caption := FieldByName('D_Stock').AsString;
      SubItems.Add(FieldByName('D_Price').AsString);
      SubItems.Add(FieldByName('D_Value').AsString);

      ImageIndex := cItemIconIndex;
      Next;
    end;
  end;

  nStr := 'Select * From %s Where C_ZID=''%s''';
  nStr := Format(nStr, [sTable_ZhiKaCard, nZID]);

  ListCard.Items.Clear;
  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    First;

    while not Eof do
    with ListCard.Items.Add do
    begin
      Caption := FieldByName('C_Card').AsString;
      nStr := FieldByName('C_Status').AsString;
      SubItems.Add(CardStatusToStr(nStr));

      if FieldByName('C_IsFreeze').AsString = sFlag_Yes then
           SubItems.Add('Y、是')
      else SubItems.Add('N、否');

      ImageIndex := cItemIconIndex;
      Next;
    end;
  end;

  nVal := GetValidMoneyByZK(nZID, nBool);
  if nBool then
       nStr := '限提纸卡 可用金额:[ %.2f ]元'
  else nStr := '不限制纸卡 可用金额:[ %.2f ]元';
  EditXT.Text := Format(nStr, [nVal]);

  //----------------------------------------------------------------------------
  nStr := 'Select Z_ValidDays,%s as S_Now From %s Where Z_ID=''%s''';
  nStr := Format(nStr, [FDM.SQLServerNow, sTable_ZhiKa, nZID]);

  with FDM.QuerySQL(nStr) do
  if RecordCount > 0 then
  begin
    nDT := FieldByName('Z_ValidDays').AsDateTime;
    nDT := nDT - FieldByName('S_Now').AsDateTime;

    if nDT <= 0 then
    begin
      nDT := -nDT;
      EditSC.Text := '有效期至:[ %s ] 已过期:[ %d ]天';
    end else EditSC.Text := '有效期至:[ %s ] 还剩余:[ %d ]天';

    nStr := Date2Str(FieldByName('Z_ValidDays').AsDateTime);
    EditSC.Text := Format(EditSC.Text, [nStr, Trunc(nDT)]);
  end else EditSC.Text := '未知';
end;

//Desc: 更多纸卡信息
procedure TfFormZhiKaInfoExt.BtnMoreClick(Sender: TObject);
var nP: TFormCommandParam;
begin
  nP.FCommand := cCmd_ViewData;
  nP.FParamA := gInfo.FZhiKa;
  CreateBaseFormItem(cFI_FormZhiKaInfoExt2, PopedomItem, @nP);
end;

initialization
  gControlManager.RegCtrl(TfFormZhiKaInfoExt, TfFormZhiKaInfoExt.FormID);
end.

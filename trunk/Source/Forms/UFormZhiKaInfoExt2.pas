{*******************************************************************************
  作者: dmzn@163.com 2010-3-15
  描述: 卡片扩展信息
*******************************************************************************}
unit UFormZhiKaInfoExt2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, dxLayoutControl, StdCtrls, cxControls, cxContainer,
  cxMCListBox, ComCtrls, cxListView, cxEdit, cxTextEdit, cxGraphics,
  cxMaskEdit, cxDropDownEdit;

type
  TfFormZhiKaInfoExt2 = class(TfFormNormal)
    dxLayout1Item5: TdxLayoutItem;
    ListBill: TcxListView;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
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
class function TfFormZhiKaInfoExt2.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
begin
  Result := nil;
  if Assigned(nParam) then
       gInfo.FZhiKa := PFormCommandParam(nParam).FParamA
  else Exit;

  with TfFormZhiKaInfoExt2.Create(Application) do
  begin
    Caption := '卡片 - ' + gInfo.FZhiKa;
    LoadFormData(gInfo.FZhiKa);
    ShowModal;
    Free;
  end;
end;

class function TfFormZhiKaInfoExt2.FormID: integer;
begin
  Result := cFI_FormZhiKaInfoExt2;
end;

procedure TfFormZhiKaInfoExt2.FormCreate(Sender: TObject);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadFormConfig(Self, nIni);
    LoadcxListViewConfig(Name, ListBill, nIni);
  finally
    nIni.Free;
  end;
end;

procedure TfFormZhiKaInfoExt2.FormClose(Sender: TObject; var Action: TCloseAction);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveFormConfig(Self, nIni);
    SavecxListViewConfig(Name, ListBill, nIni);
  finally
    nIni.Free;
  end;
end;

//------------------------------------------------------------------------------
//Desc: 载入界面数据
procedure TfFormZhiKaInfoExt2.LoadFormData(const nZID: string);
var nStr,nTE: string;
begin
  nTE := 'Select E_Bill,T_Status From $TE te ' +
         ' Left Join $TL tl on tl.T_ID=te.E_TID ' +
         'Where E_ZID=''$ZID''';
  nTE := MacroValue(nTE, [MI('$TE', sTable_TruckLogExt),
         MI('$TL', sTable_TruckLog), MI('$ZID', nZID)]);
  //xxxxx

  nStr := 'Select * From $Bill b ' +
          ' Left Join ($TE) te on te.E_Bill=b.L_ID' +
          ' Where L_ZID=''$ZID'' Order By L_ID';
  nStr := MacroValue(nStr, [MI('$Bill', sTable_Bill),
          MI('$TE', nTE), MI('$ZID', nZID)]);
  //xxxxx

  ListBill.Clear;
  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    First;

    while not Eof do
    with ListBill.Items.Add do
    begin
      Caption := FieldByName('L_ID').AsString;
      SubItems.Add(FieldByName('L_Stock').AsString);
      SubItems.Add(FieldByName('L_Price').AsString);
      SubItems.Add(FieldByName('L_Value').AsString);
      SubItems.Add(FieldByName('L_TruckNo').AsString);

      nStr := FieldByName('T_Status').AsString;
      SubItems.Add(TruckStatusToStr(nStr));
      ImageIndex := cItemIconIndex;
      Next;
    end;
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormZhiKaInfoExt2, TfFormZhiKaInfoExt2.FormID);
end.

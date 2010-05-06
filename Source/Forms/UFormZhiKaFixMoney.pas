{*******************************************************************************
  作者: dmzn@163.com 2010-3-15
  描述: 卡片限提金额

  备注:
  *.若纸卡有限提金额,则该纸卡最多只能提出这么多银两的货.
*******************************************************************************}
unit UFormZhiKaFixMoney;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, dxLayoutControl, StdCtrls, cxControls, cxContainer,
  cxMCListBox, ComCtrls, cxListView, cxEdit, cxTextEdit, cxGraphics,
  cxMaskEdit, cxDropDownEdit, cxCheckBox;

type
  TfFormZhiKaFixMoney = class(TfFormNormal)
    dxGroup2: TdxLayoutGroup;
    dxLayout1Item3: TdxLayoutItem;
    ListInfo: TcxMCListBox;
    EditZK: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    EditOut: TcxTextEdit;
    dxLayout1Item8: TdxLayoutItem;
    EditIn: TcxTextEdit;
    dxLayout1Item9: TdxLayoutItem;
    dxGroup3: TdxLayoutGroup;
    EditFreeze: TcxTextEdit;
    dxLayout1Item7: TdxLayoutItem;
    EditValid: TcxTextEdit;
    dxLayout1Item10: TdxLayoutItem;
    dxLayout1Group4: TdxLayoutGroup;
    dxLayout1Group5: TdxLayoutGroup;
    EditMoney: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    Check1: TcxCheckBox;
    dxLayout1Item11: TdxLayoutItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnOKClick(Sender: TObject);
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
  USysDB, USysGrid, USysBusiness, UDataModule, USysPopedom;

type
  TCommonInfo = record
    FZhiKa: string;
    FCusID: string;
  end;

var
  gInfo: TCommonInfo;
  //全局使用

//------------------------------------------------------------------------------
class function TfFormZhiKaFixMoney.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  if Assigned(nParam) then
       nP := nParam
  else Exit;

  with TfFormZhiKaFixMoney.Create(Application) do
  begin
    Caption := '限提金额';
    gInfo.FZhiKa := nP.FParamA;

    LoadFormData(gInfo.FZhiKa);
    nP.FCommand := cCmd_ModalResult;
    nP.FParamA := ShowModal;
    Free;
  end;
end;

class function TfFormZhiKaFixMoney.FormID: integer;
begin
  Result := cFI_FormZhiKaFixMoney;
end;

procedure TfFormZhiKaFixMoney.FormCreate(Sender: TObject);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadFormConfig(Self, nIni);
    LoadMCListBoxConfig(Name, ListInfo, nIni);
  finally
    nIni.Free;
  end;
end;

procedure TfFormZhiKaFixMoney.FormClose(Sender: TObject; var Action: TCloseAction);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveFormConfig(Self, nIni);
    SaveMCListBoxConfig(Name, ListInfo, nIni);
  finally
    nIni.Free;
  end;
end;

//------------------------------------------------------------------------------
//Desc: 载入界面数据
procedure TfFormZhiKaFixMoney.LoadFormData(const nZID: string);
var nStr: string;
    nDB: TDataSet;
begin
  EditZK.Text := gInfo.FZhiKa;
  nDB := LoadZhiKaInfo(gInfo.FZhiKa, ListInfo, nStr);

  if Assigned(nDB) then
  begin
    gInfo.FCusID := nDB.FieldByName('Z_Custom').AsString;
    EditMoney.Text := Format('%.2f', [nDB.FieldByName('Z_FixedMoney').AsFloat]);
    Check1.Checked := nDB.FieldByName('Z_OnlyMoney').AsString = sFlag_Yes;
  end else
  begin
    ShowMsg(nStr, sHint); Exit;
  end;

  nStr := 'Select * From %s Where A_CID=''%s''';
  nStr := Format(nStr, [sTable_CusAccount, gInfo.FCusID]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    EditIn.Text := Format('%.2f', [FieldByName('A_InMoney').AsFloat]);
    EditOut.Text := Format('%.2f', [FieldByName('A_OutMoney').AsFloat]);
    EditFreeze.Text := Format('%.2f', [FieldByName('A_FreezeMoney').AsFloat]);

    EditValid.Text := Format('%.2f', [GetCustomerValidMoney(gInfo.FCusID)]);
    //xxxxx
  end;
end;

//Desc: 保存
procedure TfFormZhiKaFixMoney.BtnOKClick(Sender: TObject);
var nStr: string;
begin
  if (not IsNumber(EditMoney.Text, True)) or (StrToFloat(EditMoney.Text) < 0) then
  begin
    EditMoney.SetFocus;
    ShowMsg('请输入正确的金额', sHint); Exit;
  end;

  nStr := 'Update %s Set Z_FixedMoney=$My,Z_OnlyMoney=$F ' +
          'Where Z_ID=''%s''';
  nStr := Format(nStr, [sTable_ZhiKa, gInfo.FZhiKa]);

  if Check1.Checked then
  begin
    nStr := MacroValue(nStr, [MI('$My', EditMoney.Text)]);
    nStr := MacroValue(nStr, [MI('$F', '''' + sFlag_Yes + '''')]);
  end else nStr := MacroValue(nStr, [MI('$My', 'Null'), MI('$F', 'Null')]);

  FDM.ExecuteSQL(nStr);
  ModalResult := mrOk;
end;

initialization
  gControlManager.RegCtrl(TfFormZhiKaFixMoney, TfFormZhiKaFixMoney.FormID);
end.

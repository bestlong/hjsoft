{*******************************************************************************
  作者: dmzn@163.com 2010-3-8
  描述: 纸卡审核开关
*******************************************************************************}
unit UFormZhiKaParam;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, dxLayoutControl, StdCtrls, cxControls, cxContainer,
  cxEdit, cxLabel, cxRadioGroup;

type
  TfFormZhiKaParam = class(TfFormNormal)
    Radio1: TcxRadioButton;
    dxLayout1Item3: TdxLayoutItem;
    Radio2: TcxRadioButton;
    dxLayout1Item4: TdxLayoutItem;
    cxLabel1: TcxLabel;
    dxLayout1Item5: TdxLayoutItem;
    cxLabel2: TcxLabel;
    dxLayout1Item6: TdxLayoutItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  protected
    { Protected declarations }
    procedure OnLoadPopedom; override;
    procedure GetSaveSQLList(const nList: TStrings); override;
    procedure InitFormData;
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}

uses
  ULibFun, UFormCtrl, UMgrControl, UDataModule, USysBusiness, USysPopedom,
  USysDB, USysConst;

class function TfFormZhiKaParam.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
begin
  Result := nil;
  with TfFormZhiKaParam.Create(Application) do
  begin
    Caption := '纸卡审核';
    PopedomItem := nPopedom;

    InitFormData;
    ShowModal;
    Free;
  end;
end;

class function TfFormZhiKaParam.FormID: integer;
begin
  Result := cFI_FormZhiKaParam;
end;

procedure TfFormZhiKaParam.OnLoadPopedom;
var nStr: string;
begin
  if not gSysParam.FIsAdmin then
  begin
    nStr := gPopedomManager.FindUserPopedom(gSysParam.FUserID, PopedomItem);
    BtnOK.Enabled := Pos(sPopedom_Edit, nStr) > 0;
  end;
end;

procedure TfFormZhiKaParam.FormCreate(Sender: TObject);
begin
  inherited;
  LoadFormConfig(Self);
end;

procedure TfFormZhiKaParam.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  SaveFormConfig(Self);
end;

//------------------------------------------------------------------------------
//Desc: 初始化界面数据
procedure TfFormZhiKaParam.InitFormData;
begin
  if IsZhiKaNeedVerify then
       Radio2.Checked := True
  else Radio1.Checked := True;
end;

//Desc: 保存SQL
procedure TfFormZhiKaParam.GetSaveSQLList(const nList: TStrings);
var nStr,nSQL: string;
begin
  if Radio1.Checked then
       nStr := sFlag_No
  else nStr := sFlag_Yes;

  nSQL := 'Select D_ID From $T Where D_Name=''$N'' and D_Memo=''$M''';
  nSQL := MacroValue(nSQL, [MI('$T', sTable_SysDict), MI('$N', sFlag_SysParam),
                           MI('$M', sFlag_ZhiKaVerify)]);
  //xxxxx

  with FDM.QueryTemp(nSQL) do
  if RecordCount > 0 then
  begin
    nSQL := 'Update $T Set D_Value=''$V'' Where D_ID=$ID';
    nSQL := MacroValue(nSQL, [MI('$T', sTable_SysDict), MI('$V', nStr),
                              MI('$ID', Fields[0].AsString)]);
  end else
  begin
    nSQL := 'Insert Into $T(D_Name,D_Memo,D_Value) Values(''$N'',''$M'',''$V'')';
    nSQL := MacroValue(nSQL, [MI('$T', sTable_SysDict), MI('$N', sFlag_SysParam),
            MI('$M', sFlag_ZhiKaVerify), MI('$V', nStr)]);
  end;

  nList.Add(nSQL);
end;

initialization
  gControlManager.RegCtrl(TfFormZhiKaParam, TfFormZhiKaParam.FormID);
end.

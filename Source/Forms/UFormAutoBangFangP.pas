{*******************************************************************************
  作者: dmzn@163.com 2010-3-8
  描述: 24小时自动皮重
*******************************************************************************}
unit UFormAutoBangFangP;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, dxLayoutControl, StdCtrls, cxControls, cxContainer,
  cxEdit, cxLabel, cxRadioGroup;

type
  TfFormAutoBFP = class(TfFormNormal)
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

class function TfFormAutoBFP.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
begin
  Result := nil;
  with TfFormAutoBFP.Create(Application) do
  begin
    Caption := '自动称重';
    PopedomItem := nPopedom;

    InitFormData;
    ShowModal;
    Free;
  end;
end;

class function TfFormAutoBFP.FormID: integer;
begin
  Result := cFI_FormAutoBFP;
end;

procedure TfFormAutoBFP.OnLoadPopedom;
begin
  BtnOK.Enabled := gPopedomManager.HasPopedom(PopedomItem, sPopedom_Edit);
end;

procedure TfFormAutoBFP.FormCreate(Sender: TObject);
begin
  inherited;
  LoadFormConfig(Self);
end;

procedure TfFormAutoBFP.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  SaveFormConfig(Self);
end;

//------------------------------------------------------------------------------
//Desc: 初始化界面数据
procedure TfFormAutoBFP.InitFormData;
begin
  if IsBangFangAutoP_24H then
       Radio1.Checked := True
  else Radio2.Checked := True;
end;

//Desc: 保存SQL
procedure TfFormAutoBFP.GetSaveSQLList(const nList: TStrings);
var nStr,nSQL: string;
begin
  if Radio1.Checked then
       nStr := sFlag_No
  else nStr := sFlag_Yes;

  nSQL := 'Select D_ID From $T Where D_Name=''$N'' and D_Memo=''$M''';
  nSQL := MacroValue(nSQL, [MI('$T', sTable_SysDict), MI('$N', sFlag_SysParam),
                           MI('$M', sFlag_AutoP24H)]);
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
            MI('$M', sFlag_AutoP24H), MI('$V', nStr)]);
  end;

  nList.Add(nSQL);
end;

initialization
  gControlManager.RegCtrl(TfFormAutoBFP, TfFormAutoBFP.FormID);
end.

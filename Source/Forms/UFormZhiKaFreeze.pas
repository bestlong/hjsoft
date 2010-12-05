{*******************************************************************************
  作者: dmzn@163.com 2010-3-16
  描述: 纸卡冻结
*******************************************************************************}
unit UFormZhiKaFreeze;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, dxLayoutControl, StdCtrls, cxControls, cxMemo,
  cxButtonEdit, cxLabel, cxTextEdit, cxContainer, cxEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, cxRadioGroup;

type
  TfFormZKFreeze = class(TfFormNormal)
    EditStock: TcxComboBox;
    dxLayout1Item13: TdxLayoutItem;
    Radio1: TcxRadioButton;
    dxLayout1Item3: TdxLayoutItem;
    Radio2: TcxRadioButton;
    dxLayout1Item4: TdxLayoutItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnOKClick(Sender: TObject);
  private
    { Private declarations }
    procedure InitFormData;
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
  IniFiles, ULibFun, UFormBase, UMgrControl, USysDB, USysConst, USysBusiness,
  UDataModule;

class function TfFormZKFreeze.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  if Assigned(nParam) then
       nP := nParam
  else Exit;

  with TfFormZKFreeze.Create(Application) do
  begin
    Caption := '纸卡冻结';
    InitFormData;
    
    nP.FCommand := cCmd_ModalResult;
    nP.FParamA := ShowModal;
    Free;
  end;
end;

class function TfFormZKFreeze.FormID: integer;
begin
  Result := cFI_FormFreezeZK;
end;

procedure TfFormZKFreeze.FormCreate(Sender: TObject);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadFormConfig(Self, nIni);
  finally
    nIni.Free;
  end;
end;

procedure TfFormZKFreeze.FormClose(Sender: TObject;
  var Action: TCloseAction);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveFormConfig(Self, nIni);
  finally
    nIni.Free;
  end;
end;

//------------------------------------------------------------------------------
procedure TfFormZKFreeze.InitFormData;
begin
  LoadSysDictItem(sFlag_StockItem, EditStock.Properties.Items);
end;

procedure TfFormZKFreeze.BtnOKClick(Sender: TObject);
var nStr,nY: string;
begin
  if EditStock.ItemIndex < 0 then
  begin
    EditStock.SetFocus;
    ShowMsg('请选择有效的水泥类型', sHint); Exit;
  end;

  if Radio1.Checked then
  begin
    nY := '''Y''';
    nStr := '确定要冻结所有包含[ %s ]的纸卡吗?';
  end else
  begin
    nY := 'Null';
    nStr := '确定要解冻所有包含[ %s ]的纸卡吗?';
  end;

  nStr := Format(nStr, [EditStock.Text]);
  if not QueryDlg(nStr, sAsk, Handle) then Exit;

  nStr := 'Update $ZK Set Z_Freeze=$Frz Where Z_ID In (' +
          'Select D_ZID From $Dtl Where D_Stock=''$Stock'')';
  nStr := MacroValue(nStr, [MI('$ZK', sTable_ZhiKa), MI('$Frz', nY),
          MI('$Dtl', sTable_ZhiKaDtl), MI('$Stock', EditStock.Text)]);
  //xxxxxx

  FDM.ExecuteSQL(nStr);
  ModalResult := mrOk;
end;

initialization
  gControlManager.RegCtrl(TfFormZKFreeze, TfFormZKFreeze.FormID);
end.

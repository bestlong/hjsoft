{*******************************************************************************
  作者: dmzn@163.com 2009-7-2
  描述: 供应磁卡
*******************************************************************************}
unit UFramePProvideCard;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFrameNormal, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, dxLayoutControl, cxMaskEdit,
  cxButtonEdit, cxTextEdit, ADODB, cxContainer, cxLabel, UBitmapPanel,
  cxSplitter, cxGridLevel, cxClasses, cxControls, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  ComCtrls, ToolWin, Menus, cxLookAndFeels, cxLookAndFeelPainters;

type
  TfFrameProvideCard = class(TfFrameNormal)
    cxTextEdit1: TcxTextEdit;
    dxLayout1Item1: TdxLayoutItem;
    EditName: TcxButtonEdit;
    dxLayout1Item2: TdxLayoutItem;
    cxTextEdit2: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    EditCard: TcxButtonEdit;
    dxLayout1Item5: TdxLayoutItem;
    cxTextEdit4: TcxTextEdit;
    dxLayout1Item6: TdxLayoutItem;
    EditMate: TcxButtonEdit;
    dxLayout1Item3: TdxLayoutItem;
    cxTextEdit3: TcxTextEdit;
    dxLayout1Item7: TdxLayoutItem;
    PMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    procedure EditNamePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
  private
    { Private declarations }
  protected
    function InitFormDataSQL(const nWhere: string): string; override;
    {*查询SQL*}
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl, USysConst, USysDB, UDataModule, UFormBase;

class function TfFrameProvideCard.FrameID: integer;
begin
  Result := cFI_FrameProvideCard;
end;

function TfFrameProvideCard.InitFormDataSQL(const nWhere: string): string;
begin
  Result := 'Select * From ' + sTable_ProvideCard;
  if nWhere <> '' then
    Result := Result + ' Where (' + nWhere + ')';
  Result := Result + ' Order By P_Card';
end;

//Desc: 添加
procedure TfFrameProvideCard.BtnAddClick(Sender: TObject);
var nP: TFormCommandParam;
begin
  nP.FCommand := cCmd_AddData;
  CreateBaseFormItem(cFI_FormProvideCard, '', @nP);

  if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
  begin
    InitFormData('');
  end;
end;

//Desc: 修改
procedure TfFrameProvideCard.BtnEditClick(Sender: TObject);
var nP: TFormCommandParam;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要修改的记录', sHint); Exit;
  end;

  nP.FCommand := cCmd_EditData;
  nP.FParamA := SQLQuery.FieldByName('P_ID').AsString;
  CreateBaseFormItem(cFI_FormProvideCard, '', @nP);

  if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
  begin
    InitFormData(FWhere);
  end;
end;

//Desc: 删除
procedure TfFrameProvideCard.BtnDelClick(Sender: TObject);
var nStr,nID: string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nStr := '确定要删除编号为[ %s ]的记录吗?';
    nID := SQLQuery.FieldByName('P_ID').AsString;
    nStr := Format(nStr, [nID]);

    if not QueryDlg(nStr, sAsk) then Exit;
    nStr := 'Delete From %s Where P_ID=%s';
    nStr := Format(nStr, [sTable_ProvideCard, nID]);

    FDM.ExecuteSQL(nStr);
    InitFormData(FWhere);
  end;
end;

//Desc: 查询
procedure TfFrameProvideCard.EditNamePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditName then
  begin
    EditName.Text := Trim(EditName.Text);
    if EditName.Text = '' then Exit;

    FWhere := Format('P_Provider Like ''%%%s%%''', [EditName.Text]);
    InitFormData(FWhere);
  end else

  if Sender = EditCard then
  begin
    EditCard.Text := Trim(EditCard.Text);
    if EditCard.Text = '' then Exit;

    FWhere := Format('P_Card=''%s''', [EditCard.Text]);
    InitFormData(FWhere);
  end else

  if Sender = EditMate then
  begin
    EditMate.Text := Trim(EditMate.Text);
    if EditMate.Text = '' then Exit;

    FWhere := Format('P_Mate Like ''%%%s%%''', [EditMate.Text]);
    InitFormData(FWhere);
  end;
end;

//Desc: 挂失
procedure TfFrameProvideCard.N2Click(Sender: TObject);
var nStr: string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nStr := 'Update %s Set P_Status=''$Status'' Where P_Card=''%s''';
    nStr := Format(nStr, [sTable_ProvideCard, SQLQuery.FieldByName('P_Card').AsString]);

    case TComponent(Sender).Tag of
     10: nStr := MacroValue(nStr, [MI('$Status', sFlag_CardLoss)]);
     20: nStr := MacroValue(nStr, [MI('$Status', sFlag_CardUsed)]);
    end;

    FDM.ExecuteSQL(nStr);
    InitFormData(FWhere);
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameProvideCard, TfFrameProvideCard.FrameID);
end.

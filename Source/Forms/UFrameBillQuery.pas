{*******************************************************************************
  作者: dmzn@163.com 2009-6-22
  描述: 开提货单查询
*******************************************************************************}
unit UFrameBillQuery;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrameNormal, cxStyles, cxCustomData, cxGraphics, cxFilter,
  cxData, cxDataStorage, cxEdit, DB, cxDBData, ADODB, cxContainer, cxLabel,
  dxLayoutControl, cxGridLevel, cxClasses, cxControls, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  ComCtrls, ToolWin, cxTextEdit, cxMaskEdit, cxButtonEdit, Menus,
  UBitmapPanel, cxSplitter, cxLookAndFeels, cxLookAndFeelPainters;

type
  TfFrameBillQuery = class(TfFrameNormal)
    EditCus: TcxButtonEdit;
    dxLayout1Item1: TdxLayoutItem;
    EditCard: TcxButtonEdit;
    dxLayout1Item2: TdxLayoutItem;
    cxTextEdit1: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    cxTextEdit2: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    cxTextEdit4: TcxTextEdit;
    dxLayout1Item6: TdxLayoutItem;
    cxTextEdit3: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    EditDate: TcxButtonEdit;
    dxLayout1Item7: TdxLayoutItem;
    PMenu1: TPopupMenu;
    N2: TMenuItem;
    EditLID: TcxButtonEdit;
    dxLayout1Item8: TdxLayoutItem;
    N1: TMenuItem;
    procedure EditIDPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure EditDatePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure N2Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
  protected
    FStart,FEnd: TDate;
    //时间区间
    FJBWhere: string;
    //交班条件
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    function InitFormDataSQL(const nWhere: string): string; override;
    {*查询SQL*}
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl, UDataModule, UFormBase, USysConst, USysDB, USysBusiness, 
  UFormDateFilter;

//------------------------------------------------------------------------------
class function TfFrameBillQuery.FrameID: integer;
begin
  Result := cFI_FrameBillQuery;
end;

procedure TfFrameBillQuery.OnCreateFrame;
begin
  inherited;
  InitDateRange(Name, FStart, FEnd);
end;

procedure TfFrameBillQuery.OnDestroyFrame;
begin
  SaveDateRange(Name, FStart, FEnd);
  inherited;
end;

//Desc: 数据查询SQL
function TfFrameBillQuery.InitFormDataSQL(const nWhere: string): string;
begin
  EditDate.Text := Format('%s 至 %s', [Date2Str(FStart), Date2Str(FEnd)]);

  Result := 'Select b.*,L_Value*L_Price as L_Money,S_Name,C_Name,C_PY From $Bill b' +
            ' Left Join $Cus cus On cus.C_ID=b.L_Custom' +
            ' Left Join $SM sm On sm.S_ID=b.L_SaleMan ';
  //提货单

  if nWhere = '' then
  begin
    if FJBWhere = '' then
         Result := Result + 'Where (L_Date>=''$ST'' and L_Date <''$End'')'
    else Result := Result + 'Where (' + FJBWhere + ')';
  end else Result := Result + 'Where (' + nWhere + ')';

  Result := MacroValue(Result, [MI('$SM', sTable_Salesman),
            MI('$Cus', sTable_Customer), MI('$Bill', sTable_Bill),
            MI('$ST', Date2Str(FStart)), MI('$End', Date2Str(FEnd + 1))]);
  //xxxxx
end;

//Desc: 执行查询
procedure TfFrameBillQuery.EditIDPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditLID then
  begin
    EditLID.Text := Trim(EditLID.Text);
    if EditLID.Text = '' then Exit;

    FWhere := 'L_ID like ''%' + EditLID.Text + '%''';
    InitFormData(FWhere);
  end else

  if Sender = EditCus then
  begin
    EditCus.Text := Trim(EditCus.Text);
    if EditCus.Text = '' then Exit;

    FWhere := 'C_PY like ''%%%s%%'' Or C_Name like ''%%%s%%''';
    FWhere := Format(FWhere, [EditCus.Text, EditCus.Text]);
    InitFormData(FWhere);
  end else

  if Sender = EditCard then
  begin
    EditCard.Text := Trim(EditCard.Text);
    if EditCard.Text = '' then Exit;

    FWhere := Format('L_Card=''%s''', [EditCard.Text]);
    InitFormData(FWhere);
  end;
end;

//Desc: 未开始提货的提货单
procedure TfFrameBillQuery.N2Click(Sender: TObject);
begin
  FWhere := 'L_ID Not In (Select IsNull(E_Bill, '''') From %s)';
  FWhere := Format(FWhere, [sTable_TruckLogExt]);
  InitFormData(FWhere);
end;

//Desc: 日期筛选
procedure TfFrameBillQuery.EditDatePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if ShowDateFilterForm(FStart, FEnd) then InitFormData('');
end;

//Desc: 交接班
procedure TfFrameBillQuery.N1Click(Sender: TObject);
var nStart,nEnd: TDateTime;
begin
  if not GetJiaoBanTime(nStart, nEnd) then
  begin
    ShowMsg('交班时段无效', sHint); Exit;
  end;

  try
    FJBWhere := '(L_Date>=''%s'' and L_Date<''%s'')';
    FJBWhere := Format(FJBWhere, [DateTime2Str(nStart), DateTime2Str(nEnd)]);
    InitFormData;
  finally
    FJBWhere := '';
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameBillQuery, TfFrameBillQuery.FrameID);
end.

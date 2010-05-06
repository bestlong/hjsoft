{*******************************************************************************
  作者: dmzn@163.com 2009-09-04
  描述: 发货明细
*******************************************************************************}
unit UFrameSaleDetailQuery;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  IniFiles, UFrameNormal, cxStyles, cxCustomData, cxGraphics, cxFilter,
  cxData, cxDataStorage, cxEdit, DB, cxDBData, dxLayoutControl, cxTextEdit,
  cxMaskEdit, cxButtonEdit, ADODB, cxContainer, cxLabel, UBitmapPanel,
  cxSplitter, cxGridLevel, cxClasses, cxControls, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  ComCtrls, ToolWin, Menus;

type
  TfFrameSaleDetailQuery = class(TfFrameNormal)
    cxTextEdit3: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    EditDate: TcxButtonEdit;
    dxLayout1Item6: TdxLayoutItem;
    cxTextEdit4: TcxTextEdit;
    dxLayout1Item7: TdxLayoutItem;
    EditCustomer: TcxButtonEdit;
    dxLayout1Item8: TdxLayoutItem;
    EditSaleMan: TcxButtonEdit;
    dxLayout1Item9: TdxLayoutItem;
    cxTextEdit5: TcxTextEdit;
    dxLayout1Item10: TdxLayoutItem;
    cxTextEdit1: TcxTextEdit;
    dxLayout1Item1: TdxLayoutItem;
    PMenu1: TPopupMenu;
    N1: TMenuItem;
    procedure EditDatePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure EditTruckPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure N1Click(Sender: TObject);
  private
    { Private declarations }
  protected
    FStart,FEnd: TDate;
    //时间区间
    FValue,FMoney: Double;
    //均价参数
    FJBWhere: string;
    //交班条件
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    procedure OnLoadGridConfig(const nIni: TIniFile); override;
    function InitFormDataSQL(const nWhere: string): string; override;
    //查询SQL
    procedure SummaryItemsGetText(Sender: TcxDataSummaryItem;
      const AValue: Variant; AIsFooter: Boolean; var AText: String);
    //处理摘要
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl, USysConst, USysDB, UDataModule, UFormDateFilter,
  USysBusiness;

class function TfFrameSaleDetailQuery.FrameID: integer;
begin
  Result := cFI_FrameSaleDetailQuery;
end;

procedure TfFrameSaleDetailQuery.OnCreateFrame;
begin
  inherited;
  FJBWhere := '';
  InitDateRange(Name, FStart, FEnd);
end;

procedure TfFrameSaleDetailQuery.OnDestroyFrame;
begin
  SaveDateRange(Name, FStart, FEnd);
  inherited;
end;

procedure TfFrameSaleDetailQuery.OnLoadGridConfig(const nIni: TIniFile);
var i,nCount: Integer;
begin
  with cxView1.DataController.Summary do
  begin
    nCount := FooterSummaryItems.Count - 1;
    for i:=0 to nCount do
      FooterSummaryItems[i].OnGetText := SummaryItemsGetText;
    //绑定事件

    nCount := DefaultGroupSummaryItems.Count - 1;
    for i:=0 to nCount do
      DefaultGroupSummaryItems[i].OnGetText := SummaryItemsGetText;
    //绑定事件
  end;

  inherited;
end;

//------------------------------------------------------------------------------
function TfFrameSaleDetailQuery.InitFormDataSQL(const nWhere: string): string;
var nStr: string;
begin
  EditDate.Text := Format('%s 至 %s', [Date2Str(FStart), Date2Str(FEnd)]);

  Result := 'Select zk.*,C_Area,S_PY,S_Name,C_PY,C_Name From $ZK zk ' +
            ' Left Join $SC sc on sc.C_ID=zk.Z_CID' +
            ' Left Join $SM sm on sm.S_ID=zk.Z_SaleMan' +
            ' Left Join $Cus cus on cus.C_ID=zk.Z_Custom';
  Result := MacroValue(Result, [MI('$ZK', sTable_ZhiKa),
            MI('$SM', sTable_Salesman),
            MI('$SC', sTable_SaleContract), MI('$Cus', sTable_Customer)]);
  //纸卡

  nStr := 'Select te.*,zk.*,(E_Price*E_Value) as E_Money,T_Truck,T_OutTime,' +
          'L_Type,L_Stock,L_Lading from $TE te' +
          ' Left Join $TL tl on tl.T_ID=E_TID' +
          ' Left Join $Bill b on b.L_ID=te.E_Bill ' +
          ' Left Join ($ZK) zk On zk.Z_ID=E_ZID ';
  //xxxxx

  if FJBWhere = '' then
       nStr := nStr + 'Where (T_OutTime>=''$S'' And T_OutTime <''$End'')'
  else nStr := nStr + 'Where (' + FJBWhere + ')';
  
  if nWhere <> '' then
    nStr := nStr + ' And (' + nWhere + ')';
  //xxxxx

  Result := MacroValue(nStr, [MI('$TE', sTable_TruckLogExt), MI('$ZK', Result),
            MI('$TL', sTable_TruckLog), MI('$Bill', sTable_Bill),
            MI('$S', Date2Str(FStart)), MI('$End', Date2Str(FEnd + 1))]);
  //xxxxx
end;

//Desc: 日期筛选
procedure TfFrameSaleDetailQuery.EditDatePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if ShowDateFilterForm(FStart, FEnd) then InitFormData(FWhere);
end;

//Desc: 执行查询
procedure TfFrameSaleDetailQuery.EditTruckPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditCustomer then
  begin
    EditCustomer.Text := Trim(EditCustomer.Text);
    if EditCustomer.Text = '' then Exit;

    FWhere := 'C_PY like ''%%%s%%'' Or C_Name like ''%%%s%%''';
    FWhere := Format(FWhere, [EditCustomer.Text, EditCustomer.Text]);
    InitFormData(FWhere);
  end else

  if Sender = EditSaleMan then
  begin
    EditSaleMan.Text := Trim(EditSaleMan.Text);
    if EditSaleMan.Text = '' then Exit;

    FWhere := 'S_PY like ''%%%s%%'' Or S_Name like ''%%%s%%''';
    FWhere := Format(FWhere, [EditSaleMan.Text, EditSaleMan.Text]);
    InitFormData(FWhere);
  end;
end;

//Desc: 交接班查询
procedure TfFrameSaleDetailQuery.N1Click(Sender: TObject);
var nStart,nEnd: TDateTime;
begin
  if not GetJiaoBanTime(nStart, nEnd) then
  begin
    ShowMsg('交班时段无效', sHint); Exit;
  end;

  try
    FJBWhere := '(T_OutTime>=''%s'' and T_OutTime<''%s'')';
    FJBWhere := Format(FJBWhere, [DateTime2Str(nStart), DateTime2Str(nEnd)]);
    InitFormData;
  finally
    FJBWhere := '';
  end;
end;

//Desc: 处理均价
procedure TfFrameSaleDetailQuery.SummaryItemsGetText(Sender: TcxDataSummaryItem;
  const AValue: Variant; AIsFooter: Boolean; var AText: String);
var nStr: string;
begin
  nStr := TcxGridDBColumn(TcxGridTableSummaryItem(Sender).Column).DataBinding.FieldName;
  try
    if CompareText(nStr, 'E_Value') = 0 then FValue := SplitFloatValue(AText);
    if CompareText(nStr, 'E_Money') = 0 then FMoney := SplitFloatValue(AText);

    if CompareText(nStr, 'E_Price') = 0 then
    begin
      if FValue = 0 then
           AText := '均价: 0.00元'
      else AText := Format('均价: %.2f元', [Round(FMoney / FValue * cPrecision) / cPrecision]);
    end;
  except
    //ignor any error
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameSaleDetailQuery, TfFrameSaleDetailQuery.FrameID);
end.

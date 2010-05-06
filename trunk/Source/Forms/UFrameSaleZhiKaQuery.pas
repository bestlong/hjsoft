{*******************************************************************************
  作者: dmzn@163.com 2009-09-04
  描述: 用户业务,查询纸卡办理、提货等
*******************************************************************************}
unit UFrameSaleZhiKaQuery;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFrameNormal, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, dxLayoutControl, cxTextEdit,
  cxMaskEdit, cxButtonEdit, ADODB, cxContainer, cxLabel, UBitmapPanel,
  cxSplitter, cxGridLevel, cxClasses, cxControls, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  ComCtrls, ToolWin;

type
  TfFrameSaleZhiKaQuery = class(TfFrameNormal)
    EditDate: TcxButtonEdit;
    dxLayout1Item6: TdxLayoutItem;
    EditCustomer: TcxButtonEdit;
    dxLayout1Item8: TdxLayoutItem;
    EditCard: TcxButtonEdit;
    dxLayout1Item9: TdxLayoutItem;
    EditSMan: TcxButtonEdit;
    dxLayout1Item1: TdxLayoutItem;
    cxTextEdit1: TcxTextEdit;
    dxLayout1Item2: TdxLayoutItem;
    cxTextEdit2: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    cxTextEdit3: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    cxTextEdit4: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    procedure EditDatePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure EditTruckPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
  private
    { Private declarations }
  protected
    FStart,FEnd: TDate;
    //时间区间
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    function InitFormDataSQL(const nWhere: string): string; override;
    //查询SQL
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl, USysConst, USysDB, UDataModule, UFormDateFilter;

class function TfFrameSaleZhiKaQuery.FrameID: integer;
begin
  Result := cFI_FrameSaleZhiKaQuery;
end;

procedure TfFrameSaleZhiKaQuery.OnCreateFrame;
begin
  inherited;
  InitDateRange(Name, FStart, FEnd);
end;

procedure TfFrameSaleZhiKaQuery.OnDestroyFrame;
begin
  SaveDateRange(Name, FStart, FEnd);
  inherited;
end;

//------------------------------------------------------------------------------
function TfFrameSaleZhiKaQuery.InitFormDataSQL(const nWhere: string): string;
var nZK,nBill: string;
begin
  EditDate.Text := Format('%s 至 %s', [Date2Str(FStart), Date2Str(FEnd)]);

  nZK := 'Select zk.*,C_Area,S_PY,S_Name,C_PY,C_Name From $ZK zk ' +
          ' Left Join $SC sc on sc.C_ID=zk.Z_CID' +
          ' Left Join $Cus cus on cus.C_ID=zk.Z_Custom' +
          ' Left Join $SM sm on sm.S_ID=zk.Z_SaleMan';
  nZK := MacroValue(nZK, [MI('$ZK', sTable_ZhiKa), MI('$SM', sTable_Salesman),
            MI('$SC', sTable_SaleContract), MI('$Cus', sTable_Customer)]);
  //纸卡

  nBill := 'Select Sum(L_Value) as L_AllValue,L_ZID,L_Type,L_Stock,' +
          'L_Price,L_Lading From $Bill b ' +
          'Where L_IsDone=''$Yes'' and (L_OKDate>=''$S'' and ' +
          'L_OKDate<''$End'') Group By L_ZID,L_Type,L_Stock,L_Price,L_Lading';
  nBill := MacroValue(nBill, [MI('$Bill', sTable_Bill), MI('$Yes', sFlag_Yes),
            MI('$S', Date2Str(FStart)), MI('$End', Date2Str(FEnd + 1))]);
  //提货单

  Result := 'Select * From (%s) b ' +
            ' Left Join (%s) zk on zk.Z_ID=b.L_ZID ';
  Result := Format(Result, [nBill, nZK]);

  if nWhere <> '' then
    Result := Result + 'Where (' + nWhere + ')';
  //xxxxx
end;

//Desc: 日期筛选
procedure TfFrameSaleZhiKaQuery.EditDatePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if ShowDateFilterForm(FStart, FEnd) then InitFormData(FWhere);
end;

//Desc: 执行查询
procedure TfFrameSaleZhiKaQuery.EditTruckPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
var nStr: string;
begin
  if Sender = EditSMan then
  begin
    EditSMan.Text := Trim(EditSMan.Text);
    if EditSMan.Text = '' then Exit;

    FWhere := 'S_PY like ''%%%s%%'' Or S_Name like ''%%%s%%''';
    FWhere := Format(FWhere, [EditSMan.Text, EditSMan.Text]);
    InitFormData(FWhere);
  end else

  if Sender = EditCustomer then
  begin
    EditCustomer.Text := Trim(EditCustomer.Text);
    if EditCustomer.Text = '' then Exit;

    FWhere := 'C_PY like ''%%%s%%'' Or C_Name like ''%%%s%%''';
    FWhere := Format(FWhere, [EditCustomer.Text, EditCustomer.Text]);
    InitFormData(FWhere);
  end else

  if Sender = EditCard then
  begin
    EditCard.Text := Trim(EditCard.Text);
    if EditCard.Text = '' then Exit;

    nStr := 'Select C_ZID From %s Where C_Card=''%s''';
    nStr := Format(nStr, [sTable_ZhiKaCard, EditCard.Text]);

    with FDM.QueryTemp(nStr) do
    if RecordCount > 0 then
    begin
      FWhere := 'L_ZID like ''%%%s%%''';
      FWhere := Format(FWhere, [Fields[0].AsString]);
      InitFormData(FWhere);
    end else ShowMsg('磁卡号无效', sHint);
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameSaleZhiKaQuery, TfFrameSaleZhiKaQuery.FrameID);
end.

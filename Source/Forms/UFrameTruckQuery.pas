{*******************************************************************************
  作者: dmzn@163.com 2009-09-04
  描述: 出入车辆查询
*******************************************************************************}
unit UFrameTruckQuery;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrameNormal, cxStyles, cxCustomData, cxGraphics, cxFilter,
  cxData, cxDataStorage, cxEdit, DB, cxDBData, ADODB, cxContainer, cxLabel,
  dxLayoutControl, cxGridLevel, cxClasses, cxControls, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  ComCtrls, ToolWin, cxMaskEdit, cxButtonEdit, cxTextEdit, Menus,
  UBitmapPanel, cxSplitter;

type
  TfFrameTruckQuery = class(TfFrameNormal)
    cxTextEdit1: TcxTextEdit;
    dxLayout1Item1: TdxLayoutItem;
    EditTruck: TcxButtonEdit;
    dxLayout1Item2: TdxLayoutItem;
    EditCard: TcxButtonEdit;
    dxLayout1Item3: TdxLayoutItem;
    cxTextEdit2: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
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
    PMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
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
  ULibFun, UMgrControl, USysConst, USysDB, UDataModule, UFormDateFilter;

class function TfFrameTruckQuery.FrameID: integer;
begin
  Result := cFI_FrameTruckQuery2;
end;

procedure TfFrameTruckQuery.OnCreateFrame;
begin
  inherited;
  InitDateRange(Name, FStart, FEnd);
end;

procedure TfFrameTruckQuery.OnDestroyFrame;
begin
  SaveDateRange(Name, FStart, FEnd);
  inherited;
end;

//------------------------------------------------------------------------------
function TfFrameTruckQuery.InitFormDataSQL(const nWhere: string): string;
var nStr: string;
begin
  EditDate.Text := Format('%s 至 %s', [Date2Str(FStart), Date2Str(FEnd)]);

  nStr := 'Select zk.*,S_PY,S_Name,C_PY,C_Name From $ZK zk ' +
          ' Left Join $SM sm on sm.S_ID=zk.Z_SaleMan' +
          ' Left Join $Cus cus on cus.C_ID=zk.Z_Custom';
  nStr := MacroValue(nStr, [MI('$ZK', sTable_ZhiKa),
          MI('$SM', sTable_Salesman), MI('$Cus', sTable_Customer)]);
  //xxxxx

  Result := 'Select * from $TE te' +
            ' Left Join $TL tl on tl.T_ID=te.E_TID' +
            ' Left Join $Bill b on b.L_ID=te.E_Bill' +
            ' Left Join ($ZK) zk on zk.Z_ID=te.E_ZID ' +
            'Where ((T_InTime>=''$S'' and T_InTime <''$End'') Or ' +
            '(T_OutTime>=''$S'' and T_OutTime <''$End''))';
  //xxxxx

  if nWhere <> '' then
    Result := Result + ' And (' + nWhere + ')';
  //xxxxx
  
  Result := MacroValue(Result, [MI('$TE', sTable_TruckLogExt), MI('$ZK', nStr),
            MI('$TL', sTable_TruckLog), MI('$Bill', sTable_Bill),
            MI('$S', Date2Str(FStart)), MI('$End', Date2Str(FEnd + 1))]);
  //xxxxx
end;

//Desc: 日期筛选
procedure TfFrameTruckQuery.EditDatePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if ShowDateFilterForm(FStart, FEnd) then InitFormData(FWhere);
end;

//Desc: 执行查询
procedure TfFrameTruckQuery.EditTruckPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditTruck then
  begin
    EditTruck.Text := Trim(EditTruck.Text);
    if EditTruck.Text = '' then Exit;

    FWhere := 'E_Truck like ''%' + EditTruck.Text + '%''';
    InitFormData(FWhere);
  end else

  if Sender = EditCard then
  begin
    EditCard.Text := Trim(EditCard.Text);
    if EditCard.Text = '' then Exit;

    FWhere := 'E_Card like ''%' + EditCard.Text + '%''';
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

  if Sender = EditSaleMan then
  begin
    EditSaleMan.Text := Trim(EditSaleMan.Text);
    if EditSaleMan.Text = '' then Exit;

    FWhere := 'S_PY like ''%%%s%%'' Or S_Name like ''%%%s%%''';
    FWhere := Format(FWhere, [EditSaleMan.Text, EditSaleMan.Text]);
    InitFormData(FWhere);
  end;
end;

//Desc: 快捷菜单
procedure TfFrameTruckQuery.N1Click(Sender: TObject);
begin
  case TComponent(Sender).Tag of
    10: //显示全部
     begin
       FWhere := '';
       InitFormData;
     end;
    20: //未出厂
     begin
       FWhere := 'T_Status<>''' + sFlag_TruckOut + '''';
       InitFormData(FWhere);
     end;
    30: //已出厂
     begin
       FWhere := '';
       InitFormData('T_Status=''' + sFlag_TruckOut + '''');
     end;
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameTruckQuery, TfFrameTruckQuery.FrameID);
end.

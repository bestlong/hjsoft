{*******************************************************************************
  作者: dmzn@163.com 2009-10-28
  描述: 客户信用管理
*******************************************************************************}
unit UFrameCustomerCredit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IniFiles, UFrameNormal, cxStyles, cxCustomData, cxGraphics,
  cxFilter, cxData, cxDataStorage, cxEdit, DB, cxDBData, dxLayoutControl,
  cxTextEdit, cxMaskEdit, cxButtonEdit, ADODB, cxContainer, cxLabel,
  UBitmapPanel, cxSplitter, cxGridLevel, cxClasses, cxControls,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, ComCtrls, ToolWin;

type
  TfFrameCustomerCredit = class(TfFrameNormal)
    EditID: TcxButtonEdit;
    dxLayout1Item1: TdxLayoutItem;
    EditName: TcxButtonEdit;
    dxLayout1Item2: TdxLayoutItem;
    EditCusID: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    EditCusName: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    EditMoney: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    cxView2: TcxGridDBTableView;
    QueryDtl: TADOQuery;
    DataSource2: TDataSource;
    EditMemo: TcxTextEdit;
    dxLayout1Item7: TdxLayoutItem;
    cxLevel2: TcxGridLevel;
    procedure EditIDPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnRefreshClick(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
    procedure cxView2FocusedRecordChanged(Sender: TcxCustomGridTableView;
      APrevFocusedRecord, AFocusedRecord: TcxCustomGridRecord;
      ANewItemRecordFocusingChanged: Boolean);
    procedure cxView1DblClick(Sender: TObject);
  protected
    FWhereDtl: string;
    //查询条件
    procedure OnCreateFrame; override;
    procedure OnLoadGridConfig(const nIni: TIniFile); override;
    procedure OnSaveGridConfig(const nIni: TIniFile); override;
    procedure OnInitFormData(var nDefault: Boolean; const nWhere: string = '';
     const nQuery: TADOQuery = nil); override;
    //查询数据
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl, UFormBase, USysConst, USysDB, USysGrid, USysDataDict,
  UDataModule;

class function TfFrameCustomerCredit.FrameID: integer;
begin
  Result := cFI_FrameCusCredit;
end;

procedure TfFrameCustomerCredit.OnCreateFrame;
begin
  inherited;
  FWhereDtl := '';
end;

procedure TfFrameCustomerCredit.OnLoadGridConfig(const nIni: TIniFile);
begin
  cxGrid1.ActiveLevel := cxLevel1;
  gSysEntityManager.BuildViewColumn(cxView2, 'CusCredit');
  InitTableView(Name, cxView2, nIni);
end;

procedure TfFrameCustomerCredit.OnSaveGridConfig(const nIni: TIniFile);
begin
  SaveUserDefineTableView(Name, cxView2, nIni);
end;

procedure TfFrameCustomerCredit.OnInitFormData(var nDefault: Boolean;
  const nWhere: string; const nQuery: TADOQuery);
var nStr,nSQL: string;
begin
  nDefault := False;
  nStr := 'Select Distinct C_CusID From ' + sTable_CusCredit;
  //has credit acount

  nSQL := 'Select cus.*,A_CreditLimit,S_Name From $Cus cus ' +
          ' Left Join $CA ca On ca.A_CID=cus.C_ID ' +
          ' Left Join $SM sm On sm.S_ID=cus.C_SaleMan ' +
          ' Left Join ($CC) cc On cc.C_CusID=cus.C_ID ' +
          'Where (C_CusID Is Not Null)';
  //xxxxx
  
  nSQL := MacroValue(nSQL, [MI('$Cus', sTable_Customer), MI('$CC', nStr),
          MI('$CA', sTable_CusAccount), MI('$SM', sTable_Salesman)]);
  //xxxxx
  
  if FWhere <> '' then
    nSQL := nSQL + ' And (' + FWhere + ')';
  nSQL := nSQL + ' Order By C_ID';
  FDM.QueryData(SQLQuery, nSQL);                  

  nStr := 'Select cc.*,C_Name From %s cc ' +
          ' Left Join %s cus On cus.C_ID=cc.C_CusID';
  nStr := Format(nStr, [sTable_CusCredit, sTable_Customer]);

  if FWhereDtl <> '' then
    nStr := nStr + ' Where (' + FWhereDtl + ')';
  FDM.QueryData(QueryDtl, nStr)
end;

//------------------------------------------------------------------------------
//Desc: 刷新
procedure TfFrameCustomerCredit.BtnRefreshClick(Sender: TObject);
begin
  FWhere := '';
  FWhereDtl := '';

  InitFormData;
  cxView2.DataController.Filter.Root.Clear;
end;

//Desc: 信用变动
procedure TfFrameCustomerCredit.BtnEditClick(Sender: TObject);
var nP: TFormCommandParam;
begin
  if (cxGrid1.ActiveView = cxView1) and
     (cxView1.DataController.GetSelectedCount > 0) then
    nP.FParamA := SQLQuery.FieldByName('C_ID').AsString else
  if (cxGrid1.ActiveView = cxView2) and
     (cxView2.DataController.GetSelectedCount > 0) then
    nP.FParamA := QueryDtl.FieldByName('C_CusID').AsString;

  CreateBaseFormItem(cFI_FormCusCredit, '', @nP);
  if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOk) then
    BtnRefreshClick(nil);
  //xxxxx
end;

//Desc: 执行查询
procedure TfFrameCustomerCredit.EditIDPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditID then
  begin
    FWhere := 'C_ID like ''%' + EditID.Text + '%''';
    FWhereDtl := 'C_CusID like ''%' + EditID.Text + '%''';
    InitFormData;
  end else

  if Sender = EditName then
  begin
    FWhere := 'C_Name like ''%%%s%%'' Or C_PY like ''%%%s%%''';
    FWhere := Format(FWhere, [EditName.Text, EditName.Text]);

    FWhereDtl := FWhere;
    InitFormData;
  end;
end;

//Desc: 备注信息
procedure TfFrameCustomerCredit.cxView2FocusedRecordChanged(
  Sender: TcxCustomGridTableView; APrevFocusedRecord,
  AFocusedRecord: TcxCustomGridRecord;
  ANewItemRecordFocusingChanged: Boolean);
begin
  if FShowDetailInfo and Assigned(APrevFocusedRecord) then
  begin
    EditCusID.Text := QueryDtl.FieldByName('C_CusID').AsString;
    EditCusName.Text := QueryDtl.FieldByName('C_Name').AsString;
    EditMemo.Text := QueryDtl.FieldByName('C_Memo').AsString;
    EditMoney.Text := Format('%.2f', [QueryDtl.FieldByName('C_Money').AsFloat]);
  end;
end;

//Desc: 筛选明细
procedure TfFrameCustomerCredit.cxView1DblClick(Sender: TObject);
var nStr: string;
    nColumn: TObject;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nStr := SQLQuery.FieldByName('C_ID').AsString;

    with cxView2.DataController.Filter.Root do
    begin
      Clear;
      nColumn := cxView2.GetColumnByFieldName('C_CusID');
      AddItem(nColumn, foEqual, nStr, nStr);

      cxView2.DataController.Filter.Active := True;
      cxGrid1.ActiveLevel := cxLevel2; 
    end;
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameCustomerCredit, TfFrameCustomerCredit.FrameID);
end.

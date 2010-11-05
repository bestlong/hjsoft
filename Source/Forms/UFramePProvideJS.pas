{*******************************************************************************
  作者: dmzn@163.com 2010-10-16
  描述: 供应结算
*******************************************************************************}
unit UFramePProvideJS;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFrameNormal, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, Menus, dxLayoutControl, cxCheckBox,
  cxMaskEdit, cxButtonEdit, cxTextEdit, ADODB, cxContainer, cxLabel,
  UBitmapPanel, cxSplitter, cxGridLevel, cxClasses, cxControls,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, ComCtrls, ToolWin, cxLookAndFeels,
  cxLookAndFeelPainters;

type
  TfFrameProvideJS = class(TfFrameNormal)
    cxTextEdit1: TcxTextEdit;
    dxLayout1Item1: TdxLayoutItem;
    EditTruck: TcxButtonEdit;
    dxLayout1Item2: TdxLayoutItem;
    EditLID: TcxButtonEdit;
    dxLayout1Item3: TdxLayoutItem;
    cxTextEdit2: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    cxTextEdit3: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    EditDate: TcxButtonEdit;
    dxLayout1Item6: TdxLayoutItem;
    cxTextEdit4: TcxTextEdit;
    dxLayout1Item7: TdxLayoutItem;
    PMenu1: TPopupMenu;
    N1: TMenuItem;
    EditPNum: TcxButtonEdit;
    dxLayout1Item8: TdxLayoutItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    cxTextEdit5: TcxTextEdit;
    dxLayout1Item9: TdxLayoutItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    procedure EditDatePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure EditTruckPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure N1Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
    procedure cxView1DblClick(Sender: TObject);
    procedure PMenu1Popup(Sender: TObject);
    procedure N10Click(Sender: TObject);
  private
    { Private declarations }
  protected
    FStart,FEnd: TDate;
    //时间区间
    FLocalWhere: string;
    //查询条件
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    function InitFormDataSQL(const nWhere: string): string; override;
    //查询SQL
    function GetVal(const nRow: Integer; const nField: string): string;
    procedure HS_P;
    procedure JS_P;
    //批量操作
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl, USysConst, USysDB, UFormBase, UDataModule, USysBusiness,
  UFormDateFilter, USysPopedom;

class function TfFrameProvideJS.FrameID: integer;
begin
  Result := cFI_FrameProvideJS;
end;

procedure TfFrameProvideJS.OnCreateFrame;
begin
  inherited;
  FLocalWhere := '';
  InitDateRange(Name, FStart, FEnd);
end;

procedure TfFrameProvideJS.OnDestroyFrame;
begin
  SaveDateRange(Name, FStart, FEnd);
  inherited;
end;


function TfFrameProvideJS.InitFormDataSQL(const nWhere: string): string;
var nStr: string;
begin
  EditDate.Text := Format('%s 至 %s', [Date2Str(FStart), Date2Str(FEnd)]);

  if FLocalWhere = '' then
  begin
    nStr := '((L_PDate>=''$S'' and L_PDate<''$E'') or ' +    //皮重
            '(L_HSDate>=''$S'' and L_HSDate<''$E'') or ' +   //核算
            '(L_JSDate>=''$S'' and L_JSDate<''$E''))';       //结算
  end else nStr := FLocalWhere;

  Result := 'Select *,L_MValue-L_PValue-IsNull(L_YValue,0) as L_JValue From $T ' +
            'Where ' + nStr;
  //xxxxx

  if nWhere <> '' then
       Result := Result + ' and (' + nWhere + ')';
  //xxxxx

  Result := MacroValue(Result, [MI('$T', sTable_ProvideLog),
            MI('$S', Date2Str(FStart)), MI('$E', Date2Str(FEnd+1))]);
  //xxxxx
end;

procedure TfFrameProvideJS.PMenu1Popup(Sender: TObject);
begin
  N1.Enabled := BtnPrint.Enabled and (cxView1.DataController.GetSelectedCount > 0);
  N9.Enabled := N1.Enabled and (SQLQuery.FieldByName('L_Flag').AsString <> '');
end;

//------------------------------------------------------------------------------
//Desc: 核算
procedure TfFrameProvideJS.BtnAddClick(Sender: TObject);
var nInt: Integer;
    nP: TFormCommandParam;
begin
  nInt := cxView1.DataController.GetSelectedCount;
  if nInt < 1 then
  begin
    ShowMsg('请选择要核算的记录', sHint); Exit;
  end;

  if nInt > 1 then
  begin
    HS_P; Exit;
  end; //批量

  if SQLQuery.FieldByName('L_JSDate').AsString <> '' then
  begin
    ShowMsg('该磅单已经结算', sHint); Exit;
  end;

  nP.FParamA := SQLQuery.FieldByName('L_ID').AsString;
  CreateBaseFormItem(cFI_FormProvideHS, '', @nP);

  if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
  begin
    InitFormData(FWhere);
    ShowMsg('核算成功', sHint);
  end;
end;

//Desc: 结算
procedure TfFrameProvideJS.BtnEditClick(Sender: TObject);
var nStr: string;
    nInt: Integer;
    nY,nM: Double;
begin
  nInt := cxView1.DataController.GetSelectedCount;
  if nInt < 1 then
  begin
    ShowMsg('请选择要结算的记录', sHint); Exit;
  end;

  if nInt > 1 then
  begin
    JS_P; Exit;
  end; //批量

  if SQLQuery.FieldByName('L_HSDate').AsString = '' then
  begin
    ShowMsg('请先核算该磅单', sHint); Exit;
  end;

  if SQLQuery.FieldByName('L_JSDate').AsString <> '' then
  begin
    ShowMsg('该磅单已经结算', sHint); Exit;
  end;

  nY := SQLQuery.FieldByName('L_YunFei').AsFloat;
  nM := SQLQuery.FieldByName('L_Money').AsFloat;

  nStr := '该磅单的结算内容明细如下:' + #13#10#13#10 +
          '*.运费: %.2f￥' + #13#10 +
          '*.结算: %.2f￥' + #13#10 +
          '*.合计: %.2f￥' + #13#10#13#10 +
          '确定要结算编号为[ %s ]的磅单吗?' + StringOfChar(#32, 8);
  //xxxxx
  
  nStr := Format(nStr, [nY, nM, nY + nM,
          SQLQuery.FieldByName('L_ID').AsString]);
  if not QueryDlg(nStr, sAsk, Handle) then Exit;

  nStr := 'Update %s Set L_Flag=null,L_JSer=''%s'',L_JSDate=%s Where L_ID=%s';
  nStr := Format(nStr, [sTable_ProvideLog, gSysParam.FUserID, FDM.SQLServerNow,
          SQLQuery.FieldByName('L_ID').AsString]);
  //xxxxx

  FDM.ExecuteSQL(nStr); 
  PrintProvideJSReport(SQLQuery.FieldByName('L_ID').AsString, '', False);

  InitFormData(FWhere);
  ShowMsg('结算成功', sHint);
end;

//Desc: 核算或结算
procedure TfFrameProvideJS.cxView1DblClick(Sender: TObject);
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    if SQLQuery.FieldByName('L_HSDate').AsString = '' then
      BtnAddClick(nil) else
    if SQLQuery.FieldByName('L_JSDate').AsString = '' then
      BtnEditClick(nil);
  end;
end;

//Desc: 获取nRow行nField字段的内容
function TfFrameProvideJS.GetVal(const nRow: Integer; const nField: string): string;
var nVal: Variant;
begin
  nVal := cxView1.DataController.GetValue(
            cxView1.Controller.SelectedRows[nRow].RecordIndex,
            cxView1.GetColumnByFieldName(nField).Index);
  //xxxxx

  if VarIsNull(nVal) then
       Result := ''
  else Result := nVal;
end;

//Desc: 批量核算
procedure TfFrameProvideJS.HS_P;
var nValue: Double;
    i,nCount: Integer;
    nP: TFormCommandParam;
    nList,nTrucks: TStrings;
    nStr,nMate,nTruck: string;
begin
  nList := TStringList.Create;
  nTrucks := TStringList.Create;
  try
    nValue := 0;
    nMate := GetVal(0, 'L_Mate');
    nTruck := GetVal(0, 'L_Truck');

    nTrucks.Add(nTruck);
    nCount := cxView1.Controller.SelectedRowCount - 1;
    
    for i:=0 to nCount do
    begin
      if GetVal(i, 'L_JSDate') <> '' then
      begin
        nStr := Format('编号为[ %s ]的磅单已结算', [GetVal(i, 'L_ID')]);
        ShowDlg(nStr, sHint); Exit;
      end;

      if CompareText(nMate, GetVal(i, 'L_Mate')) <> 0 then
      begin
        nStr := '相同原料才允许批量核算,编号为[ %s ]的磅单不符合条件!';
        nStr := Format(nStr, [GetVal(i, 'L_ID')]);
        ShowDlg(nStr, sHint); Exit;
      end;

      nStr := GetVal(i, 'L_JValue');
      if IsNumber(nStr, True) then
      begin
        nValue := nValue + StrToFloat(nStr);
        nList.Add(GetVal(i, 'L_ID') + ';' + nStr);
      end;

      nStr := GetVal(i, 'L_Truck');
      if nTrucks.IndexOf(nStr) < 0 then
      begin
        nTrucks.Add(nStr);
        nTruck := nTruck + ',' + nStr;
      end;
    end;

    nP.FParamA := Integer(nList);
    nP.FParamB := Format('%s 至 %s', [Date2Str(FStart), Date2Str(FEnd)]);
    nP.FParamC := nMate;
    nP.FParamD := nTruck;
    nP.FParamE := Float2Float(nValue, cPrecision, True);
    CreateBaseFormItem(cFI_FormProvideHS_P, '', @nP);

    if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
    begin
      InitFormData(FWhere);
      ShowMsg('批量核算成功', sHint);
    end;
  finally
    nList.Free;
    nTrucks.Free;
  end;
end;

//Desc: 批量结算
procedure TfFrameProvideJS.JS_P;
var nM,nY: Double;
    i,nCount: Integer;
    nP: TFormCommandParam;
    nList,nTrucks: TStrings;
    nStr,nMate,nTruck: string;
begin
  nList := TStringList.Create;
  nTrucks := TStringList.Create;
  try
    nM := 0; nY := 0;
    nMate := GetVal(0, 'L_Mate');
    nTruck := GetVal(0, 'L_Truck');

    nTrucks.Add(nTruck);
    nCount := cxView1.Controller.SelectedRowCount - 1;
    
    for i:=0 to nCount do
    begin
      if GetVal(i, 'L_HSDate') = '' then
      begin
        nStr := Format('请先核算编号为[ %s ]的磅单', [GetVal(i, 'L_ID')]);
        ShowDlg(nStr, sHint); Exit;
      end;

      if GetVal(i, 'L_JSDate') <> '' then
      begin
        nStr := Format('编号为[ %s ]的磅单已结算', [GetVal(i, 'L_ID')]);
        ShowDlg(nStr, sHint); Exit;
      end;
      
      if CompareText(nMate, GetVal(i, 'L_Mate')) <> 0 then
      begin
        nStr := '相同原料才允许批量结算,编号为[ %s ]的磅单不符合条件!';
        nStr := Format(nStr, [GetVal(i, 'L_ID')]);
        ShowDlg(nStr, sHint); Exit;
      end;

      nList.Add(GetVal(i, 'L_ID'));
      nStr := GetVal(i, 'L_Money');

      if IsNumber(nStr, True) then
        nM := nM + StrToFloat(nStr);
      //xxxxx

      nStr := GetVal(i, 'L_YunFei');
      if IsNumber(nStr, True) then
        nY := nY + StrToFloat(nStr);
      //xxxxx

      nStr := GetVal(i, 'L_Truck');
      if nTrucks.IndexOf(nStr) < 0 then
      begin
        nTrucks.Add(nStr);
        nTruck := nTruck + ',' + nStr;
      end;
    end;

    nP.FParamA := Integer(nList);
    nP.FParamB := nMate;
    nP.FParamC := nTruck;
    nP.FParamD := Float2Float(nM, cPrecision, True);
    nP.FParamE := Float2Float(nY, cPrecision, True);
    CreateBaseFormItem(cFI_FormProvideJS_P, '', @nP);

    if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
    begin
      InitFormData(FWhere);
      ShowMsg('批量结算成功', sHint);
    end;
  finally
    nList.Free;
    nTrucks.Free;
  end;
end;

//------------------------------------------------------------------------------
//Desc: 日期筛选
procedure TfFrameProvideJS.EditDatePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if ShowDateFilterForm(FStart, FEnd) then InitFormData(FWhere);
end;

//Desc: 执行查询
procedure TfFrameProvideJS.EditTruckPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditTruck then
  begin
    EditTruck.Text := Trim(EditTruck.Text);
    if EditTruck.Text = '' then Exit;

    FWhere := Format('L_Truck like ''%%%s%%''', [EditTruck.Text]);
    InitFormData(FWhere);
  end else

  if Sender = EditPNum then
  begin
    EditPNum.Text := Trim(EditPNum.Text);
    if EditPNum.Text = '' then Exit;

    FLocalWhere := '1 = 1';
    FWhere := Format('L_PaiNum like ''%%%s%%''', [EditPNum.Text]);
    try
      InitFormData(FWhere);
    finally
      FLocalWhere := '';
    end;
  end else

  if Sender = EditLID then
  begin
    EditLID.Text := Trim(EditLID.Text);
    if EditLID.Text = '' then Exit;

    if IsNumber(EditLID.Text, False) then
         EditLID.Text := IntToStr(StrToInt(EditLID.Text))
    else Exit;

    FLocalWhere := '1 = 1';
    FWhere := Format('L_ID like ''%%%s%%''', [EditLID.Text]);
    try
      InitFormData(FWhere);
    finally
      FLocalWhere := '';
    end;
  end else
end;

//Desc: 查询未核算
procedure TfFrameProvideJS.N6Click(Sender: TObject);
begin
  FLocalWhere := 'L_HSDate Is Null';
  if Sender = N6 then
    FLocalWhere := FLocalWhere + ' and L_PDate>=''$S'' and L_PDate<''$E''';
  //xxxxx

  try
    InitFormData;
  finally
    FLocalWhere := '';
  end;
end;

//Desc: 查询未结算
procedure TfFrameProvideJS.N8Click(Sender: TObject);
begin
  FLocalWhere := 'L_JSDate Is Null and L_HSDate Is Not Null';
  if Sender = N8 then
    FLocalWhere := FLocalWhere + ' and L_HSDate>=''$S'' and L_HSDate<''$E''';
  //xxxxx

  try
    InitFormData;
  finally
    FLocalWhere := '';
  end;
end;

//Desc: 打印结算单
procedure TfFrameProvideJS.N1Click(Sender: TObject);
var nStr: string;
begin
  if SQLQuery.FieldByName('L_JSDate').AsString <> '' then
  begin
    nStr := SQLQuery.FieldByName('L_ID').AsString;
    PrintProvideJSReport(nStr, '', False);
  end else ShowMsg('请先结算', sHint);
end;

//Desc: 逐条or合计打印
procedure TfFrameProvideJS.N10Click(Sender: TObject);
var nStr: string;
begin
  nStr := SQLQuery.FieldByName('L_Flag').AsString;
  PrintProvideJSReport('', nStr, Sender = N11);
end;

initialization
  gControlManager.RegCtrl(TfFrameProvideJS, TfFrameProvideJS.FrameID);
end.

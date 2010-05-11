{*******************************************************************************
  作者: dmzn@163.com 2010-3-16
  描述: 开化验单
*******************************************************************************}
unit UFormHYData;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, dxLayoutControl, StdCtrls, cxControls, cxMemo,
  cxButtonEdit, cxLabel, cxTextEdit, cxContainer, cxEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, cxGraphics, ComCtrls, cxListView, Menus;

type
  TfFormHYData = class(TfFormNormal)
    dxLayout1Item7: TdxLayoutItem;
    EditTruck: TcxTextEdit;
    dxLayout1Item8: TdxLayoutItem;
    EditValue: TcxTextEdit;
    EditSMan: TcxComboBox;
    dxLayout1Item13: TdxLayoutItem;
    EditCustom: TcxComboBox;
    dxLayout1Item3: TdxLayoutItem;
    EditNo: TcxButtonEdit;
    dxLayout1Item4: TdxLayoutItem;
    dxLayout1Group2: TdxLayoutGroup;
    EditDate: TcxDateEdit;
    dxLayout1Item5: TdxLayoutItem;
    dxLayout1Group4: TdxLayoutGroup;
    dxGroup2: TdxLayoutGroup;
    ListBill: TcxListView;
    dxLayout1Item6: TdxLayoutItem;
    PMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    EditName: TcxTextEdit;
    dxLayout1Item9: TdxLayoutItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EditCustomKeyPress(Sender: TObject; var Key: Char);
    procedure EditSManPropertiesEditValueChanged(Sender: TObject);
    procedure EditCustomPropertiesEditValueChanged(Sender: TObject);
    procedure ListBillDblClick(Sender: TObject);
    procedure EditNoPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure N1Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure ListBillSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
  protected
    { Protected declarations }
    FSelectVal: Double;
    //选中量
    function OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean; override;
    procedure GetSaveSQLList(const nList: TStrings); override;
    procedure AfterSaveData(var nDefault: Boolean); override;
    //验证数据
    procedure InitFormData(const nID: string);
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
  IniFiles, ULibFun, UFormCtrl, UAdjustForm, UFormBase, UMgrControl, USysGrid,
  USysDB, USysConst, USysBusiness, UDataModule;

var
  gForm: TfFormHYData = nil;
  //全局使用

class function TfFormHYData.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: TFormCommandParam;
begin
  Result := nil;
  if not Assigned(nParam) then
  begin
    FillChar(nP, SizeOf(nP), #0);
    nP.FCommand := cCmd_AddData;
  end else nP := PFormCommandParam(nParam)^;

  case nP.FCommand of
   cCmd_AddData:
    with TfFormHYData.Create(Application) do
    begin
      Caption := '开化验单';
      InitFormData('');
      
      nP.FCommand := cCmd_ModalResult;
      nP.FParamA := ShowModal;
      Free;
    end;
   cCmd_ViewData:
    begin
      if not Assigned(gForm) then
      begin
        gForm := TfFormHYData.Create(Application);
        with gForm do
        begin
          Caption := '化验单 - 查看';
          FormStyle := fsStayOnTop;
          BtnOK.Visible := False;
        end;
      end;

      with gForm  do
      begin
        InitFormData(nP.FParamA);
        if not Showing then Show;
        LoadcxListViewConfig(Name, ListBill);
      end;
    end;
   cCmd_FormClose:
    begin
      if Assigned(gForm) then FreeAndNil(gForm);
    end;
  end;

  if Assigned(nParam) then
  with PFormCommandParam(nParam)^ do
  begin
    FCommand := nP.FCommand;
    FParamA := nP.FParamA;
  end;
end;

class function TfFormHYData.FormID: integer;
begin
  Result := cFI_FormStockHuaYan;
end;

procedure TfFormHYData.FormCreate(Sender: TObject);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadFormConfig(Self, nIni);
    LoadcxListViewConfig(Name, ListBill, nIni);
  finally
    nIni.Free;
  end;
end;

procedure TfFormHYData.FormClose(Sender: TObject;
  var Action: TCloseAction);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveFormConfig(Self, nIni);
    SavecxListViewConfig(Name, ListBill, nIni);
  finally
    nIni.Free;
  end;

  gForm := nil;
  Action := caFree;
  ReleaseCtrlData(Self);
end;

//------------------------------------------------------------------------------
//Desc: 初始化解面
procedure TfFormHYData.InitFormData(const nID: string);
var nStr: string;
begin
  EditDate.Date := Now;
  EditValue.Text := '0';
  
  if EditSMan.Properties.Items.Count < 1 then
    LoadSaleMan(EditSMan.Properties.Items);
  //xxxxx

  if nID <> '' then
  begin
    nStr := 'Select hy.*,C_Name,C_SaleMan From %s hy ' +
            ' Left Join %s on C_ID=H_Custom ' +
            'Where H_ID=%s';
    nStr := Format(nStr, [sTable_StockHuaYan, sTable_Customer, nID]);

    with FDM.QuerySQL(nStr) do
    if RecordCount > 0 then
    begin
      SetCtrlData(EditSMan, FieldByName('C_SaleMan').AsString);
      SetCtrlData(EditCustom, FieldByName('H_Custom').AsString);

      if EditCustom.ItemIndex < 0 then
      begin
        nStr := FieldByName('H_Custom').AsString;
        nStr := Format('%s=%s.%s', [nStr, nStr, FieldByName('C_Name').AsString]);
        EditCustom.ItemIndex := InsertStringsItem(EditCustom.Properties.Items, nStr); 
      end;

      EditDate.Date := FieldByName('H_BillDate').AsDateTime;
      EditNo.Text := FieldByName('H_SerialNo').AsString;
      EditTruck.Text := FieldByName('H_Truck').AsString;
      EditValue.Text := FieldByName('H_Value').AsString;
    end;
  end;
end;

//Desc: 选择客户
procedure TfFormHYData.EditCustomKeyPress(Sender: TObject; var Key: Char);
var nStr: string;
    nP: TFormCommandParam;
begin
  if Key = #13 then
  begin
    Key := #0;
    nP.FParamA := GetCtrlData(EditCustom);
    
    if nP.FParamA = '' then
      nP.FParamA := EditCustom.Text;
    //xxxxx

    CreateBaseFormItem(cFI_FormGetCustom, '', @nP);
    if (nP.FCommand <> cCmd_ModalResult) or (nP.FParamA <> mrOK) then Exit;

    SetCtrlData(EditSMan, nP.FParamD);
    SetCtrlData(EditCustom, nP.FParamB);
    
    if EditCustom.ItemIndex < 0 then
    begin
      nStr := Format('%s=%s.%s', [nP.FParamB, nP.FParamB, nP.FParamC]);
      EditCustom.ItemIndex := InsertStringsItem(EditCustom.Properties.Items, nStr);
    end;
  end;
end;

//Desc: 业务员变更,选择客户
procedure TfFormHYData.EditSManPropertiesEditValueChanged(Sender: TObject);
var nStr: string;
begin
  EditCustom.Text := '';
  
  if EditSMan.ItemIndex >= 0 then
  begin
    AdjustStringsItem(EditCustom.Properties.Items, True);
    nStr := 'C_ID=Select C_ID,C_Name From %s Where C_SaleMan=''%s''';
    nStr := Format(nStr, [sTable_Customer, GetCtrlData(EditSMan)]);

    FDM.FillStringsData(EditCustom.Properties.Items, nStr, -1, '.');
    AdjustStringsItem(EditCustom.Properties.Items, False);
  end;
end;

//Desc: 客户变更,载入提货记录
procedure TfFormHYData.EditCustomPropertiesEditValueChanged(Sender: TObject);
var nStr: string;
    nVal: Double;
begin
  nVal := 0;
  dxGroup2.Caption := '提货信息';
  if EditCustom.ItemIndex < 0 then Exit;

  nStr := EditCustom.Text;
  System.Delete(nStr, 1, Pos('.', nStr));
  EditName.Text := nStr;

  nStr := 'Select b.*,E_ID,E_StockNo From $TE te ' +
          ' Left Join $Bill b on b.L_ID=te.E_Bill ' +
          'Where L_IsDone=''$Yes'' and L_Custom=''$CID'' ';
  //xxxxx

  if N1.Checked then
       nStr := nStr + ' and (E_HyID Is Null)'
  else nStr := nStr + ' and (E_HyID Is Not Null)';

  nStr := nStr + ' Order By E_StockNo';
  nStr := MacroValue(nStr, [MI('$TE', sTable_TruckLogExt),
          MI('$Bill', sTable_Bill), MI('$Yes', sFlag_Yes),
          MI('$CID', GetCtrlData(EditCustom))]);
  //xxxxx

  FSelectVal := 0;
  ListBill.Items.Clear;

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    First;

    while not Eof do
    with ListBill.Items.Add do
    begin
      Caption := FieldByName('E_StockNo').AsString;
      SubItems.Add(FieldByName('L_Stock').AsString);
      SubItems.Add(FieldByName('L_TruckNo').AsString);
      SubItems.Add(FieldByName('L_Value').AsString);

      SubItems.Add(DateTime2Str(FieldByName('L_OKDate').AsDateTime));
      SubItems.Add(FieldByName('E_ID').AsString);
      ImageIndex := cItemIconIndex;
      
      nVal := nVal + FieldByName('L_Value').AsFloat;
      Next;
    end;
  end;

  if nVal > 0 then
  begin
    if N1.Checked then
    begin
      nStr := '提货信息 未开量:[ %.2f ]吨';
      dxGroup2.Caption := Format(nStr, [nVal]); Exit;
    end;

    nStr := 'Select Sum(H_Value) From %s Where H_Custom=''%s''';
    nStr := Format(nStr, [sTable_StockHuaYan, GetCtrlData(EditCustom)]);

    with FDM.QueryTemp(nStr) do
    begin
      nStr := '提货信息 实际提货:[ %.2f ] 实开量:[ %.2f ]';
      nStr := Format(nStr, [nVal, Fields[0].AsFloat]);
      dxGroup2.Caption := nStr;
    end;
  end;
end;

//Desc: 选中记录
procedure TfFormHYData.ListBillDblClick(Sender: TObject);
begin
  if Assigned(ListBill.Selected) then
  with ListBill.Selected do
  begin
    EditNo.Text := Caption;
    EditTruck.Text := SubItems[1];
    EditValue.Text := SubItems[2];
    EditDate.Date := Str2DateTime(SubItems[3]);
  end;
end;

//Desc: 选择水泥编号
procedure TfFormHYData.EditNoPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
var nP: TFormCommandParam;
begin
  nP.FCommand := cCmd_ViewData;
  nP.FParamA := Trim(EditNo.Text);
  CreateBaseFormItem(cFI_FormGetStockNo, '', @nP);

  if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
  begin
    EditNo.Text := nP.FParamB;
  end;
end;

function TfFormHYData.OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean;
var nVal,nMax: Double;
begin
  Result := True;

  if Sender = EditCustom then
  begin
    Result := EditCustom.ItemIndex > -1;
    nHint := '请选择有效的客户';
  end else

  if Sender = EditName then
  begin
    Result := Trim(EditName.Text) <> '';
    nHint := '请填写有效的客户名称';
  end else

  if Sender = EditTruck then
  begin
    Result := Trim(EditTruck.Text) <> '';
    nHint := '请填写有效的车牌号码';
  end else

  if Sender = EditValue then
  begin
    Result := IsNumber(EditValue.Text, True) and (StrToFloat(EditValue.Text) > 0);
    nHint := '请填写有效的提货量';
  end else

  if Sender = EditNo then
  begin
    Result := Trim(EditNo.Text) <> '';
    nHint := '请填写有效的编号';
    if not Result then Exit;

    nVal := GetHYValueByStockNo(EditNo.Text);
    Result := nVal >= 0;
    nHint := '无效的水泥编号';

    if not Result then Exit;
    if not OnVerifyCtrl(EditValue, nHint) then Exit;

    nMax := GetHYMaxValue;
    Result := nVal + StrToFloat(EditValue.Text) <= nMax;

    if not Result then
    begin
      nHint := '系统每个批次最大允许开出[ %.2f ]吨,当前已开出[ %.2f ]吨.' +
               #13#10 +'确定要开出该化验单吗?';
      nHint := Format(nHint, [nMax, nVal]);
      
      Result := QueryDlg(nHint, sAsk, Handle);
      nHint := '';
    end;
  end;
end;

//Desc: 保存SQL
procedure TfFormHYData.GetSaveSQLList(const nList: TStrings);
var nStr: string;
begin
  nStr := 'Insert Into $Table(H_Custom,H_CusName,H_SerialNo,H_Truck,H_Value,' +
          'H_BillDate,H_ReportDate,H_Reporter) Values(''$Cus'',''$CName'',' +
          '''$No'',''$TN'',$Val,''$BD'',$RD,''$RE'')';
  nStr := MacroValue(nStr, [MI('$Table', sTable_StockHuaYan),
          MI('$Cus', GetCtrlData(EditCustom)), MI('$CName', EditName.Text),
          MI('$No', EditNo.Text), MI('$TN', EditTruck.Text),
          MI('$Val', EditValue.Text), MI('$BD', DateTime2Str(EditDate.Date)),
          MI('$RD', FDM.SQLServerNow), MI('$RE', gSysParam.FUserID)]);
  nList.Add(nStr);
end;

//Desc: 打印化验单
procedure TfFormHYData.AfterSaveData(var nDefault: Boolean);
var nStr: string;
begin
  nStr := IntToStr(FDM.GetFieldMax(sTable_StockHuaYan, 'H_ID'));
  PrintHeGeReport(nStr, True);
  PrintHuaYanReport(nStr, True);
end;

//------------------------------------------------------------------------------
//Desc: 未开时合计提货量
procedure TfFormHYData.ListBillSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  if N1.Checked then
  begin
    if Selected then
         FSelectVal := FSelectVal + StrToFloat(Item.SubItems[2])
    else FSelectVal := FSelectVal - StrToFloat(Item.SubItems[2]);

    if FSelectVal < 0 then FSelectVal := 0;
    EditValue.Text := Format('%.2f', [FSelectVal]);
  end;
end;

//Desc: 选择查询
procedure TfFormHYData.N1Click(Sender: TObject);
begin
  TMenuItem(Sender).Checked := True;
  EditCustomPropertiesEditValueChanged(nil);
end;

//Desc: 标记状态
procedure TfFormHYData.N4Click(Sender: TObject);
var nStr,nSQL: string;
    i,nCount: integer;
begin
  if ListBill.SelCount < 1 then
  begin
    ShowMsg('请选择要标记的记录', sHint); Exit;
  end;

  nStr := '';
  nCount := ListBill.Items.Count - 1;

  for i:=0 to nCount do
   if ListBill.Items[i].Selected then
    nStr := nStr + ListBill.Items[i].SubItems[4] + ',';
  System.Delete(nStr, Length(nStr), 1);

  nSQL := 'Update $T Set E_HyID=$F Where E_ID In ($ID)';
  nSQL := MacroValue(nSQL, [MI('$T', sTable_TruckLogExt), MI('$ID', nStr)]);

  if Sender = N4 then
       nStr := 'Null'
  else nStr := '27';

  nSQL := MacroValue(nSQL, [MI('$F', nStr)]);
  FDM.ExecuteSQL(nSQL);
  ShowMsg('标记成功', sHint);
end;

initialization
  gControlManager.RegCtrl(TfFormHYData, TfFormHYData.FormID);
end.

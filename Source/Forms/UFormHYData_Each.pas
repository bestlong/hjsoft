{*******************************************************************************
  作者: dmzn@163.com 2010-3-16
  描述: 随车开化验单
*******************************************************************************}
unit UFormHYData_Each;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, dxLayoutControl, StdCtrls, cxControls, cxMemo,
  cxButtonEdit, cxLabel, cxTextEdit, cxContainer, cxEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, cxGraphics, ComCtrls, cxListView, Menus,
  cxLookAndFeels, cxLookAndFeelPainters, cxMCListBox;

type
  THYTruckItem = record
    FTruckID: string;             //车辆编号
    FTruckNo: string;             //车牌号
    FStockNo: string;             //水泥编号
    FStockNum: Double;            //提货量
    FLadTime: TDateTime;          //提货时间
    FLadingID: array of string;   //提货单号
    FTruckEID: array of string;   //车辆明细
  end;

  TfFormHYData_Each = class(TfFormNormal)
    dxLayout1Item3: TdxLayoutItem;
    InfoList1: TcxMCListBox;
    dxLayout1Item4: TdxLayoutItem;
    EditCard: TcxButtonEdit;
    dxLayout1Item6: TdxLayoutItem;
    EditZID: TcxButtonEdit;
    dxLayout1Item8: TdxLayoutItem;
    TruckList1: TcxMCListBox;
    dxLayout1Item9: TdxLayoutItem;
    ParamList1: TcxMCListBox;
    dxLayout1Group4: TdxLayoutGroup;
    dxLayout1Group5: TdxLayoutGroup;
    dxLayout1Item10: TdxLayoutItem;
    EditLading: TcxTextEdit;
    dxLayout1Item11: TdxLayoutItem;
    EditLDate: TcxDateEdit;
    dxLayout1Item12: TdxLayoutItem;
    EditRDate: TcxDateEdit;
    dxLayout1Item13: TdxLayoutItem;
    EditReporter: TcxTextEdit;
    dxLayout1Item14: TdxLayoutItem;
    EditStockNo: TcxButtonEdit;
    dxLayout1Item15: TdxLayoutItem;
    EditItem: TcxTextEdit;
    dxLayout1Item16: TdxLayoutItem;
    EditValue: TcxTextEdit;
    cxLabel1: TcxLabel;
    dxLayout1Item5: TdxLayoutItem;
    dxLayout1Group2: TdxLayoutGroup;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EditCardPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure EditZIDPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure TruckList1Click(Sender: TObject);
    procedure ParamList1Click(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
  protected
    { Protected declarations }
    FZhiKa,FTruck: string;
    //默认参数
    FTrucks: array of THYTruckItem;
    //提货车辆
    function OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean; override;
    //验证数据
    procedure InitFormData(const nZK,nTruck: string);
    //载入数据
    procedure LoadZhiKaData(const nZK,nTruck: string);
    //读取纸卡
    function LoadStockRecord(const nID: string): Boolean;
    //检验记录
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
  USysDB, USysConst, USysBusiness, UDataModule, UFormInputbox;

class function TfFormHYData_Each.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  if Assigned(nParam) then
  begin
    nP := nParam;
    if nP.FCommand <> cCmd_AddData then Exit;
  end else nP := nil;

  with TfFormHYData_Each.Create(Application) do
  try
    Caption := '开化验单';
    if Assigned(nP) then
    begin
      InitFormData(nP.FParamA, nP.FParamB);
      nP.FCommand := cCmd_ModalResult;
      nP.FParamA := ShowModal;
    end else
    begin
      InitFormData('', '');
      ShowModal;
    end;
  finally
    Free;
  end;
end;

class function TfFormHYData_Each.FormID: integer;
begin
  Result := cFI_FormStockHY_Each;
end;

procedure TfFormHYData_Each.FormCreate(Sender: TObject);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadFormConfig(Self, nIni);
    LoadMCListBoxConfig(Name, InfoList1, nIni);
    LoadMCListBoxConfig(Name, TruckList1, nIni);
    LoadMCListBoxConfig(Name, ParamList1, nIni);
  finally
    nIni.Free;
  end;
end;

procedure TfFormHYData_Each.FormClose(Sender: TObject;
  var Action: TCloseAction);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveFormConfig(Self, nIni);
    SaveMCListBoxConfig(Name, InfoList1, nIni);
    SaveMCListBoxConfig(Name, TruckList1, nIni);
    SaveMCListBoxConfig(Name, ParamList1, nIni);
  finally
    nIni.Free;
  end;
end;

//------------------------------------------------------------------------------
//Desc: 初始化界面
procedure TfFormHYData_Each.InitFormData(const nZK,nTruck: string);
begin
  EditLDate.Date := Now;
  EditRDate.Date := Now;
  
  dxGroup1.AlignHorz := ahClient;
  EditReporter.Text := gSysParam.FUserID;

  if (nZK = '') and (nTruck = '') then
       ActiveControl := EditCard
  else LoadZhiKaData(nZK, nTruck);
end;

//Date: 2011-1-16
//Parm: 纸卡号;车辆记录
//Desc: 载入标识为nZK的纸卡信息
procedure TfFormHYData_Each.LoadZhiKaData(const nZK,nTruck: string);
var nStr,nTmp,nTID: string;
    nIdx,nLen: integer;
begin
  FZhiKa := nZK;
  EditZID.Text := FZhiKa;

  if not Assigned(LoadZhiKaInfo(nZK, InfoList1, nStr)) then
  begin
    ShowMsg(nStr, sHint); Exit;
  end;

  TruckList1.Clear;
  SetLength(FTrucks, 0);

  nStr := 'Select te.*,T_BFMTime,T_Truck From $TE te ' +
          ' Left Join $TL tl On tl.T_ID=te.E_TID ';
  //xxxxx

  if nTruck = '' then
       nTmp := 'E_TID In (Select E_TID From $TE Where (E_ZID=''$ZID''))'
  else nTmp := 'E_TID=''$TID''';

  nStr := nStr + ' Where ' + nTmp +
          ' And (T_BFMTime is Not Null And E_HyID Is Null And ' +
          'E_HyNo Is Null) Order By T_BFMTime,T_Truck';
  //xxxxx

  nStr := MacroValue(nStr, [MI('$TE', sTable_TruckLogExt), MI('$ZID', nZK),
          MI('$TL', sTable_TruckLog), MI('$TID', nTruck),
          MI('$Bill', sTable_Bill)]);
  //xxxxx

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    First;

    while not Eof do
    begin
      nStr := FieldByName('T_Truck').AsString;
      nTmp := FieldByName('E_StockNo').AsString;
      nTID := FieldByName('E_TID').AsString;

      nLen := High(FTrucks);
      for nIdx:=Low(FTrucks) to nLen do
      if (FTrucks[nIdx].FTruckID = nTID) and
         (CompareText(FTrucks[nIdx].FTruckNo, nStr) = 0) and
         (CompareText(FTrucks[nIdx].FStockNo, nTmp) = 0) then
      begin
        FTrucks[nIdx].FStockNum := FTrucks[nIdx].FStockNum +
                                   FieldByName('E_Value').AsFloat;
        //合计提货量
        
        if FieldByName('T_BFMTime').AsDateTime > FTrucks[nIdx].FLadTime then
          FTrucks[nIdx].FLadTime := FieldByName('T_BFMTime').AsDateTime;
        //使用最新提货时间

        nLen := Length(FTrucks[nIdx].FTruckEID);
        SetLength(FTrucks[nIdx].FTruckEID, nLen + 1);
        FTrucks[nIdx].FTruckEID[nLen] := FieldByName('E_ID').AsString;

        nLen := Length(FTrucks[nIdx].FLadingID);
        SetLength(FTrucks[nIdx].FLadingID, nLen + 1);
        FTrucks[nIdx].FLadingID[nLen] := FieldByName('E_Bill').AsString;

        nLen := MaxInt; Next;
        Break;
      end;

      if nLen = MaxInt then Continue;
      //同车同品种合吨

      nLen := Length(FTrucks);
      SetLength(FTrucks, nLen + 1);

      FTrucks[nLen].FTruckID := nTID;
      FTrucks[nLen].FTruckNo := nStr;
      FTrucks[nLen].FStockNo := nTmp;
      FTrucks[nLen].FStockNum := FieldByName('E_Value').AsFloat;
      FTrucks[nLen].FLadTime := FieldByName('T_BFMTime').AsDateTime;

      SetLength(FTrucks[nLen].FTruckEID, 1);
      FTrucks[nLen].FTruckEID[0] := FieldByName('E_ID').AsString;

      SetLength(FTrucks[nLen].FLadingID, 1);
      FTrucks[nLen].FLadingID[0] := FieldByName('E_Bill').AsString;
      Next;
    end;

    nLen := High(FTrucks);
    for nIdx:=Low(FTrucks) to nLen do
    begin
      FTrucks[nIdx].FStockNum := Float2Float(FTrucks[nIdx].FStockNum,
        cPrecision, False);
      //adjust float data
      
      nStr := CombinStr([FTrucks[nIdx].FTruckNo,
              FTrucks[nIdx].FStockNo + ' ',
              Format('%.2f', [FTrucks[nIdx].FStockNum]),
              DateTime2Str(FTrucks[nIdx].FLadTime)], TruckList1.Delimiter);
      TruckList1.Items.Add(nStr);
    end;
  end;
end;

procedure TfFormHYData_Each.EditCardPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
var nStr: string;
begin
  EditCard.Text := Trim(EditCard.Text);
  if EditCard.Text = '' then
  begin
    EditCard.SetFocus;
    ShowMsg('请填写磁卡号', sHint); Exit;
  end;
  
  EditZID.Clear;
  InfoList1.Clear;
  TruckList1.Clear;

  nStr := 'Select C_ZID From %s Where C_Card=''%s''';
  nStr := Format(nStr, [sTable_ZhiKaCard, EditCard.Text]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
       LoadZhiKaData(Fields[0].AsString, '')
  else ShowMsg('无效的磁卡号', sHint);
end;

procedure TfFormHYData_Each.EditZIDPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
var nStr: string;
begin
  EditZID.Text := Trim(EditZID.Text);
  if EditZID.Text = '' then
  begin
    EditZID.SetFocus;
    ShowMsg('请输入纸卡号', sHint); Exit;
  end;

  EditCard.Clear;
  InfoList1.Clear;
  TruckList1.Clear;

  nStr := 'Select Count(*) From %s Where Z_ID=''%s''';
  nStr := Format(nStr, [sTable_ZhiKa, EditZID.Text]);

  with FDM.QueryTemp(nStr) do
  if Fields[0].AsInteger > 0 then
       LoadZhiKaData(EditZID.Text, '')
  else ShowMsg('无效的纸卡号', sHint);
end;

//Desc: 选择记录
procedure TfFormHYData_Each.TruckList1Click(Sender: TObject);
var nStr: string;
    nIdx: Integer;
begin
  EditStockNo.Clear;
  ParamList1.Clear;

  if TruckList1.ItemIndex > -1 then
  with FTrucks[TruckList1.ItemIndex] do
  begin
    EditStockNo.Text := FStockNo;
    EditStockNo.Properties.ReadOnly := True;

    nStr := '';
    for nIdx:=Low(FLadingID) to High(FLadingID) do
     if nStr = '' then
          nStr := FLadingID[nIdx]
     else nStr := nStr + ',' + FLadingID[nIdx];
    EditLading.Text := nStr;

    LoadStockRecord(FStockNo);
    EditLDate.Date := FLadTime;
  end;
end;

//Desc: 载入水泥编号为nID的检验记录
function TfFormHYData_Each.LoadStockRecord(const nID: string): Boolean;
var nStr: string;
begin
  Result := False;
  ParamList1.Clear;

  nStr := 'Select Top 1 * From %s Where R_serialNo=''%s'' Order By R_ID DESC';
  nStr := Format(nStr, [sTable_StockRecord, nID]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    Result := True;
    First;

    nStr := '氧化镁' + ParamList1.Delimiter + FieldByName('R_MgO').AsString + ' ';
    ParamList1.Items.Add(nStr);

    nStr := '三氧化硫' + ParamList1.Delimiter + FieldByName('R_SO3').AsString + ' ';
    ParamList1.Items.Add(nStr);

    nStr := '烧失量' + ParamList1.Delimiter + FieldByName('R_ShaoShi').AsString + ' ';
    ParamList1.Items.Add(nStr);

    nStr := '氯离子' + ParamList1.Delimiter + FieldByName('R_CL').AsString + ' ';
    ParamList1.Items.Add(nStr);

    nStr := '细度' + ParamList1.Delimiter + FieldByName('R_XiDu').AsString + ' ';
    ParamList1.Items.Add(nStr);

    nStr := '稠度' + ParamList1.Delimiter + FieldByName('R_ChouDu').AsString + ' ';
    ParamList1.Items.Add(nStr);

    nStr := '碱含量' + ParamList1.Delimiter + FieldByName('R_Jian').AsString + ' ';
    ParamList1.Items.Add(nStr);

    nStr := '不溶物' + ParamList1.Delimiter + FieldByName('R_BuRong').AsString + ' ';
    ParamList1.Items.Add(nStr);
    
    nStr := '比表面积' + ParamList1.Delimiter + FieldByName('R_BiBiao').AsString + ' ';
    ParamList1.Items.Add(nStr);

    nStr := '初凝时间' + ParamList1.Delimiter + FieldByName('R_ChuNing').AsString + ' ';
    ParamList1.Items.Add(nStr);

    nStr := '终凝时间' + ParamList1.Delimiter + FieldByName('R_ZhongNing').AsString + ' ';
    ParamList1.Items.Add(nStr);

    nStr := '安定性' + ParamList1.Delimiter + FieldByName('R_AnDing').AsString + ' ';
    ParamList1.Items.Add(nStr);

    nStr := '-' + ParamList1.Delimiter + '-';
    ParamList1.Items.Add(nStr);

    nStr := '抗折1(3D)' + ParamList1.Delimiter + FieldByName('R_3DZhe1').AsString + ' ';
    ParamList1.Items.Add(nStr);
    nStr := '抗折2(3D)' + ParamList1.Delimiter + FieldByName('R_3DZhe2').AsString + ' ';
    ParamList1.Items.Add(nStr);
    nStr := '抗折3(3D)' + ParamList1.Delimiter + FieldByName('R_3DZhe3').AsString + ' ';
    ParamList1.Items.Add(nStr);

    nStr := '-' + ParamList1.Delimiter + '-';
    ParamList1.Items.Add(nStr);
    
    nStr := '抗折1(28D)' + ParamList1.Delimiter + FieldByName('R_28Zhe1').AsString + ' ';
    ParamList1.Items.Add(nStr);
    nStr := '抗折2(28D)' + ParamList1.Delimiter + FieldByName('R_28Zhe2').AsString + ' ';
    ParamList1.Items.Add(nStr);
    nStr := '抗折3(28D)' + ParamList1.Delimiter + FieldByName('R_28Zhe3').AsString + ' ';
    ParamList1.Items.Add(nStr);

    nStr := '-' + ParamList1.Delimiter + '-';
    ParamList1.Items.Add(nStr);

    nStr := '抗压1(3D)' + ParamList1.Delimiter + FieldByName('R_3DYa1').AsString + ' ';
    ParamList1.Items.Add(nStr);
    nStr := '抗压2(3D)' + ParamList1.Delimiter + FieldByName('R_3DYa2').AsString + ' ';
    ParamList1.Items.Add(nStr);
    nStr := '抗压3(3D)' + ParamList1.Delimiter + FieldByName('R_3DYa3').AsString + ' ';
    ParamList1.Items.Add(nStr);
    nStr := '抗压4(3D)' + ParamList1.Delimiter + FieldByName('R_3DYa4').AsString + ' ';
    ParamList1.Items.Add(nStr);
    nStr := '抗压5(3D)' + ParamList1.Delimiter + FieldByName('R_3DYa5').AsString + ' ';
    ParamList1.Items.Add(nStr);
    nStr := '抗压6(3D)' + ParamList1.Delimiter + FieldByName('R_3DYa6').AsString + ' ';
    ParamList1.Items.Add(nStr);

    nStr := '-' + ParamList1.Delimiter + '-';
    ParamList1.Items.Add(nStr);
    
    nStr := '抗压1(28D)' + ParamList1.Delimiter + FieldByName('R_28Ya1').AsString + ' ';
    ParamList1.Items.Add(nStr);
    nStr := '抗压2(28D)' + ParamList1.Delimiter + FieldByName('R_28Ya2').AsString + ' ';
    ParamList1.Items.Add(nStr);
    nStr := '抗压3(28D)' + ParamList1.Delimiter + FieldByName('R_28Ya3').AsString + ' ';
    ParamList1.Items.Add(nStr);
    nStr := '抗压4(28D)' + ParamList1.Delimiter + FieldByName('R_28Ya4').AsString + ' ';
    ParamList1.Items.Add(nStr);
    nStr := '抗压5(28D)' + ParamList1.Delimiter + FieldByName('R_28Ya5').AsString + ' ';
    ParamList1.Items.Add(nStr);
    nStr := '抗压6(28D)' + ParamList1.Delimiter + FieldByName('R_28Ya6').AsString + ' ';
    ParamList1.Items.Add(nStr);
  end;
end;

//Desc: 检测项目
procedure TfFormHYData_Each.ParamList1Click(Sender: TObject);
var nStr: string;
    nPos: integer;
begin
  if ParamList1.ItemIndex > -1 then
  begin
    nStr := ParamList1.Items[ParamList1.ItemIndex];
    nPos := Pos(ParamList1.Delimiter, nStr);

    EditItem.Text := Copy(nStr, 1, nPos - 1);
    System.Delete(nStr, 1, nPos);
    EditValue.Text := nStr;
  end;
end;

function TfFormHYData_Each.OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean;
var nStr: string;
begin
  Result := True;

  if Sender = TruckList1 then
  begin
    Result := TruckList1.ItemIndex > -1;
    nHint := '请选择提货车辆';
  end else

  if Sender = EditRDate then
  begin
    Result := EditRDate.Date >= EditLDate.Date;
    nHint := '报告日期应大于提货日期';
  end else

  if Sender = EditReporter then
  begin
    EditReporter.Text := Trim(EditReporter.Text);
    Result := EditReporter.Text <> '';
    nHint := '请填写有效的报告人';
  end else

  if Sender = EditStockNo then
  begin
    nStr := 'Select Count(*) From %s Where R_serialNo=''%s''';
    nStr := Format(nStr, [sTable_StockRecord, EditStockNo.Text]);

    with FDM.QueryTemp(nStr) do
    begin
      Result := (RecordCount > 0) and (Fields[0].AsInteger > 0);
      nHint := '无效的水泥编号';
    end;
  end;
end;

//Desc: 开单
procedure TfFormHYData_Each.BtnOKClick(Sender: TObject);
var nStr,nID: string;
    nIdx: Integer;
begin
  if not IsDataValid then Exit;

  FDM.ADOConn.BeginTrans;
  with FTrucks[TruckList1.ItemIndex] do
  try
    nStr := 'Insert Into $HY(H_SerialNo,H_Truck,H_Value,H_BillDate,H_EachTruck,' +
            'H_ReportDate,H_Reporter) Values(''$NO'',''$Truck'',$Val,''$BD'',' +
            '''$Yes'',''$RD'',''$RM'')';
    //xxxxx

    nStr := MacroValue(nStr, [MI('$Truck', FTruckNo), MI('$Yes', sFlag_Yes),
            MI('$NO', EditStockNo.Text), MI('$HY', sTable_StockHuaYan),
            MI('$Val', FloatToStr(FStockNum)), MI('$BD', DateTime2Str(EditLDate.Date)),
            MI('$RD', DateTime2Str(EditRDate.Date)), MI('$RM', EditReporter.Text)]);
    //xxxxx

    FDM.ExecuteSQL(nStr);
    nIdx := FDM.GetFieldMax(sTable_StockHuaYan, 'H_ID');
    nID := FDM.GetSerialID2('HY', sTable_StockHuaYan, 'H_ID', 'H_No', nIdx);

    nStr := 'Update %s Set H_No=''%s'' Where H_ID=%d';
    nStr := Format(nStr, [sTable_StockHuaYan, nID, nIdx]);
    FDM.ExecuteSQL(nStr);

    for nIdx:=Low(FTruckEID) to High(FTruckEID) do
    begin
      nStr := 'Update %s Set E_HYNo=''%s'',E_HyID=27 Where E_ID=%s';
      nStr := Format(nStr, [sTable_TruckLogExt, nID, FTruckEID[nIdx]]);
      FDM.ExecuteSQL(nStr);
    end;

    FDM.ADOConn.CommitTrans;
    //xxxxx
  except
    FDM.ADOConn.RollbackTrans;
    ShowMsg('化验单保存失败', sHint); Exit;
  end;

  nStr := Format('''%s''', [nID]);
  PrintHuaYanReport_Each(nStr, True);
  PrintHeGeReport_Each(nStr, True);

  ModalResult := mrOk;
  ShowMsg('化验单已成功保存', sHint);   
end;

initialization
  gControlManager.RegCtrl(TfFormHYData_Each, TfFormHYData_Each.FormID);
end.

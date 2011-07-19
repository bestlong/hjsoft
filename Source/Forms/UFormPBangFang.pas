{*******************************************************************************
  作者: dmzn@163.com 2010-3-16
  描述: 供应过磅
*******************************************************************************}
unit UFormPBangFang;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, dxLayoutControl, StdCtrls, cxControls, cxMemo,
  cxButtonEdit, cxLabel, cxTextEdit, cxContainer, cxEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, cxMCListBox, cxCheckBox;

type
  TfFormBangFang = class(TfFormNormal)
    dxLayout1Item12: TdxLayoutItem;
    EditMemo: TcxMemo;
    EditProvider: TcxComboBox;
    dxLayout1Item3: TdxLayoutItem;
    EditMate: TcxComboBox;
    dxLayout1Item4: TdxLayoutItem;
    EditTruck: TcxComboBox;
    dxLayout1Item13: TdxLayoutItem;
    BtnGet: TButton;
    dxLayout1Item5: TdxLayoutItem;
    EditValue: TcxButtonEdit;
    dxLayout1Item6: TdxLayoutItem;
    cxLabel1: TcxLabel;
    dxLayout1Item7: TdxLayoutItem;
    EditPNum: TcxTextEdit;
    dxLayout1Item8: TdxLayoutItem;
    EditPTime: TcxDateEdit;
    dxLayout1Item9: TdxLayoutItem;
    dxLayout1Group2: TdxLayoutGroup;
    EditSM: TcxComboBox;
    dxLayout1Item10: TdxLayoutItem;
    dxLayout1Group3: TdxLayoutGroup;
    dxLayout1Group5: TdxLayoutGroup;
    dxLayout1Group6: TdxLayoutGroup;
    ListTruck: TcxMCListBox;
    dxLayout1Item11: TdxLayoutItem;
    dxLayout1Group7: TdxLayoutGroup;
    Check1: TcxCheckBox;
    dxLayout1Item14: TdxLayoutItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EditValuePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnGetClick(Sender: TObject);
    procedure ListTruckClick(Sender: TObject);
    procedure EditTruckPropertiesEditValueChanged(Sender: TObject);
  protected
    { Protected declarations }
    FLastTruck: string;
    //车牌号
    function OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean; override;
    procedure GetSaveSQLList(const nList: TStrings); override;
    procedure AfterSaveData(var nDefault: Boolean); override;
    //基类方法
    procedure InitFormData(const nID: string);
    //载入数据
    procedure LoadLastTruckProvice(const nTruck: string);
    //上次供应
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  IniFiles, ULibFun, UMgrControl, UFormCtrl, UDataModule, UFrameBase,
  UForminputbox, UFormWeight, USysDB, USysConst, USysGrid, USysBusiness,
  USysPopedom;

type
  TCommonInfo = record
    FRecord: string[20];      //记录号
    FProvider: string[80];    //供应商
    FMate: string[30];        //原材料
    FSaleMan: string[32];     //业务员

    FPrice: Double;           //单价
    FUnit: string[20];        //单位
    FCardNo: string[30];      //磁卡号
    FTruckNo: string[15];     //车牌号
    FStatus: string[2];       //状态(皮,毛)

    FPreValue: Double;        //预置皮重
    FPreMan: string[32];      //预置人
    FPreTime: TDateTime;      //预置时间

    FPaiNum: string[15];      //派车单
    FPaiTime: TDateTime;      //时间
    FMemo: string[50];        //备注
  end;

  TCardItem = record
    FProvider: string;    //供应商
    FMate: string;        //原材料
    FSaleMan: string;     //业务员
    FTruck: string;       //车牌号

    FPreValue: Double;    //预置皮重
    FPreMan: string;      //预置人
    FPreTime: TDateTime;  //预置时间
  end;

var
  gInfo: TCommonInfo;
  gCardItems: array of TCardItem;
  //全局使用

//------------------------------------------------------------------------------
class function TfFormBangFang.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nStr: string;
    nID: Integer;
    nInfo: TDynamicStrArray;
begin
  Result := nil;
  nStr := '';
  SetLength(gCardItems, 0);
             
  while nStr = '' do
  begin
    if ShowInputBox('请输入车牌号或磁卡号:', '称重', nStr) then
         nStr := Trim(nStr)
    else Exit;
  end;

  with gInfo do
  begin
    FillChar(gInfo, SizeOf(gInfo), #0);
    FTruckNo := nStr;
    FStatus := sFlag_TruckBFM;
    FPaiNum := '';
    FPaiTime := Date();
  end;

  nID := GetProvideLog(nStr, nInfo);
  if nID >= 0 then
  begin
    with gInfo do
    begin
      FRecord := IntToStr(nID);
      FTruckNo := nInfo[0];
      FProvider := nInfo[1];
      FMate := nInfo[2];
      FSaleMan := nInfo[3];

      FPaiNum := nInfo[4];
      FPaiTime := Str2Date(nInfo[5]);

      FMemo := nInfo[6];
      FCardNo := nInfo[7];
      FStatus := nInfo[8];
    end;
  end else //是否厂内车
  begin
    if not IsProvideTruckAutoIO(1) then
    begin
      ShowDlg('供应车辆请在门卫室刷卡进厂.', sHint); Exit;
    end;
  end;  

  if (nID < 0) or (gInfo.FStatus = sFlag_TruckBFM) then
  begin
    gInfo.FCardNo := nStr;
    nStr := 'Select * From %s Where P_Card=''%s'' ' +
            'And P_Status=''%s'' Order By P_Owner';
    nStr := Format(nStr, [sTable_ProvideCard, gInfo.FCardNo, sFlag_CardUsed]);

    with FDM.QueryTemp(nStr) do
    if RecordCount > 0 then
    begin
      SetLength(gCardItems, RecordCount);
      nID := 0;
      First;

      while not Eof do
      with gCardItems[nID] do
      begin
        FProvider := FieldByName('P_Provider').AsString;
        FMate := FieldByName('P_Mate').AsString;
        FTruck := FieldByName('P_Owner').AsString;
        FSaleMan := FieldByName('P_SaleMan').AsString;

        FPreValue := FieldByName('P_PrePValue').AsFloat;
        FPreMan := FieldByName('P_PrePMan').AsString;
        FPreTime := FieldByName('P_PrePTime').AsDateTime;

        Next; Inc(nID);
      end;
    end else gInfo.FCardNo := '';
  end; //card valid

  with TfFormBangFang.Create(Application) do
  begin
    PopedomItem := nPopedom;
    if sFlag_TruckBFP = gInfo.FStatus then
         Caption := '称量皮重'
    else Caption := '称量毛重';

    InitFormData(gInfo.FRecord);
    ShowModal;
    Free;
  end;
end;

class function TfFormBangFang.FormID: integer;
begin
  Result := cFI_FormProvideBF;
end;

procedure TfFormBangFang.FormCreate(Sender: TObject);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadFormConfig(Self, nIni);
    LoadMCListBoxConfig(Name, ListTruck, nIni);
  finally
    nIni.Free;
  end;
end;

procedure TfFormBangFang.FormClose(Sender: TObject;
  var Action: TCloseAction);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveFormConfig(Self, nIni);
    SaveMCListBoxConfig(Name, ListTruck, nIni);
  finally
    nIni.Free;
  end;
end;

//------------------------------------------------------------------------------
//Desc: 载入数据
procedure TfFormBangFang.InitFormData(const nID: string);
var nStr: string;
    nIdx: Integer;
begin
  ActiveControl := BtnGet;
  EditValue.Text := '0';
  EditValue.Properties.ReadOnly := True;

  with gInfo do
  begin
    EditMemo.Text := FMemo;
    EditPNum.Text := FPaiNum;
    EditPTime.Date := FPaiTime;
  end;

  dxLayout1Item14.Visible := False;
  //预置皮重开关

  if gInfo.FStatus = sFlag_TruckBFP then
  begin
    EditProvider.Properties.ReadOnly := True;
    EditProvider.Properties.DropDownListStyle := lsEditList;
    EditMate.Properties.ReadOnly := True;
    EditMate.Properties.DropDownListStyle := lsEditList;
    EditTruck.Properties.ReadOnly := True;
    EditTruck.Properties.DropDownListStyle := lsEditList;

    if gInfo.FCardNo <> '' then
    begin
      nStr := 'Select M_PrePValue From %s Where M_Name=''%s''';
      nStr := Format(nStr, [sTable_Materails, gInfo.FMate]);

      with FDM.QueryTemp(nStr) do
      if RecordCount > 0 then
      begin
        Check1.Checked := False;
        dxLayout1Item14.Visible := Fields[0].AsString = sFlag_Yes;
      end;
    end;
  end;

  if Length(gCardItems) > 0 then
  begin
    for nIdx:=Low(gCardItems) to High(gCardItems) do
    with gCardItems[nIdx] do
    begin
      with EditProvider.Properties do
       if Items.IndexOf(FProvider) < 0 then Items.Add(FProvider);
      with EditMate.Properties do
       if Items.IndexOf(FMate) < 0 then Items.Add(FMate);
      with EditSM.Properties do
       if Items.IndexOf(FSaleMan) < 0 then Items.Add(FSaleMan);
      with EditTruck.Properties do
       if Items.IndexOf(FTruck) < 0 then Items.Add(FTruck);

      with ListTruck do
      begin
        nStr := CombinStr([FTruck + ' ', FMate + ' ', FSaleMan + ' ',
                           FProvider + ' '], Delimiter);
        Items.Add(nStr);

        if FTruck = gInfo.FTruckNo then
          ListTruck.ItemIndex := Items.Count - 1;
        //init default
      end;
    end;

    if ListTruck.ItemIndex < 0 then
      ListTruck.ItemIndex := 0;
    ListTruckClick(nil);
  end else

  if gInfo.FCardNo = '' then
  begin
    nStr := 'Select P_Name From %s Order By P_Name ASC';
    nStr := Format(nStr, [sTable_Provider]);
    FDM.FillStringsData(EditProvider.Properties.Items, nStr, -1);

    nStr := 'Select M_Name From %s Order By M_Name ASC';
    nStr := Format(nStr, [sTable_Materails]);
    FDM.FillStringsData(EditMate.Properties.Items, nStr, -1);

    EditSM.Clear;
    EditTruck.Clear;

    nStr := 'Select DISTINCT L_Truck,L_SaleMan From %s Order By L_Truck ASC';
    nStr := Format(nStr, [sTable_ProvideLog]);

    with FDM.QueryTemp(nStr) do
    if RecordCount > 0 then
    begin
      First;

      while not Eof do
      begin
        nStr := Fields[0].AsString;
        if EditTruck.Properties.Items.IndexOf(nStr) < 0 then
          EditTruck.Properties.Items.Add(nStr);
        //xxxxx

        nStr := Trim(Fields[1].AsString);
        if (nStr <> '') and (EditSM.Properties.Items.IndexOf(nStr) < 0) then
          EditSM.Properties.Items.Add(nStr);
        //xxxxx

        Next;
      end;
    end;
  end;    
               
  if Length(gCardItems) < 1 then
  with gInfo do
  begin
    EditProvider.Text := FProvider;
    EditMate.Text := FMate;
    EditSM.Text := FSaleMan;
    EditTruck.ItemIndex := EditTruck.Properties.Items.IndexOf(FTruckNo);

    if EditTruck.ItemIndex < 0 then
    begin
      for nIdx:=0 to EditTruck.Properties.Items.Count - 1 do
      if Pos(FTruckNo, EditTruck.Properties.Items[nIdx]) > 0 then
      begin
        EditTruck.ItemIndex := nIdx; Break;
      end;
    end;

    if EditTruck.ItemIndex < 0 then
      EditTruck.Text := FTruckNo;
    //xxxxx

    if (FProvider = '') and (gInfo.FRecord = '') then
      LoadLastTruckProvice(EditTruck.Text);
    //try load default
  end;
end;

//Desc: 载入nTruck最近几次供应记录
procedure TfFormBangFang.LoadLastTruckProvice(const nTruck: string);
var nStr: string;
    nIdx: Integer;

    //当前记录内容是否存在
    function ItemExists: Boolean;
    var i: Integer;
    begin
      Result := False;

      for i:=Low(gCardItems) to High(gCardItems) do
      with FDM.SqlTemp,gCardItems[i] do
      begin
        if (FProvider = Fields[0].AsString) and (FMate = Fields[1].AsString) and
           (FSaleMan = Fields[2].AsString) then
        begin
          Result := True; Break;
        end;
      end;
    end;
begin
  ListTruck.Clear;
  SetLength(gCardItems, 0);

  nStr := 'Select Top 5 L_Provider,L_Mate,L_SaleMan From %s ' +
          'Where L_Truck=''%s'' Order By L_ID DESC';
  nStr := Format(nStr, [sTable_ProvideLog, nTruck]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    SetLength(gCardItems, RecordCount);
    nIdx := 0;
    First;

    while not Eof do
    begin
      if not ItemExists then
      begin
        FillChar(gCardItems[nIdx], SizeOf(TCardItem), #0);
        //default all field

        with gCardItems[nIdx],ListTruck do
        begin
          FProvider := Fields[0].AsString;
          FMate := Fields[1].AsString;
          FSaleMan := Fields[2].AsString;
          FTruck := nTruck;

          nStr := CombinStr([FTruck + ' ', FMate + ' ', FSaleMan + ' ',
                             FProvider + ' '], Delimiter);
          Items.Add(nStr);
        end;

        Inc(nIdx);
      end;

      Next;
    end;

    ListTruck.ItemIndex := 0;
    ListTruckClick(nil);
  end;
end;

//Desc: 切换车牌
procedure TfFormBangFang.EditTruckPropertiesEditValueChanged(
  Sender: TObject);
begin
  if EditTruck.IsFocused and (EditTruck.ItemIndex > -1) and
     (gInfo.FRecord = '') and (gInfo.FCardNo = '') then
    LoadLastTruckProvice(EditTruck.Text);
  //xxxxx
end;

//Desc:　选择车辆
procedure TfFormBangFang.ListTruckClick(Sender: TObject);
begin
  if ListTruck.ItemIndex > -1 then
  with gCardItems[ListTruck.ItemIndex] do
  begin
    EditProvider.Text := FProvider;
    EditMate.Text := FMate;
    EditSM.Text := FSaleMan;
    EditTruck.Text := FTruck;
  end;
end;

//Desc: 解除锁定
procedure TfFormBangFang.EditValuePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
var nStr: string;
begin
  if not gPopedomManager.HasPopedom(PopedomItem, sPopedom_Edit) then Exit;
  //修改权限控制

  if EditValue.Properties.ReadOnly then
       nStr := '是否要手动输入磅重?'
  else nStr := '是否要自动读取磅重?';

  if QueryDlg(nStr, sAsk, Handle) then
    EditValue.Properties.ReadOnly := not EditValue.Properties.ReadOnly;
  //xxxxx
end;

//Desc: 读磅
procedure TfFormBangFang.BtnGetClick(Sender: TObject);
begin
  Visible := False;
  try
    EditValue.Text := ShowBangFangWeightForm(PopedomItem);
  finally
    Visible := True;
  end;

  if IsNumber(EditValue.Text, False) and (StrToFloat(EditValue.Text) > 0) then
       ActiveControl := BtnOK
  else ActiveControl := BtnGet;
end;

//Desc: 验证数据
function TfFormBangFang.OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean;
var nStr: string;
    nInt: Integer;
begin
  Result := True;
  if Sender = EditProvider then
  begin
    Result := Trim(EditProvider.Text) <> '';
    nHint := '请填写有效的供应商';
  end else

  if Sender = EditMate then
  begin
    Result := Trim(EditMate.Text) <> '';
    nHint := '请填写有效的原材料';
    if not Result then Exit;

    nStr := 'Select *,%s As M_Now From %s Where M_Name=''%s''';
    nStr := Format(nStr, [FDM.SQLServerNow, sTable_Materails, EditMate.Text]);

    with FDM.QueryTemp(nStr) do
    if RecordCount = 1 then
    begin
      gInfo.FPrice := FieldByName('M_Price').AsFloat;
      gInfo.FUnit := FieldByName('M_Unit').AsString;

      gInfo.FPreValue := 0;
      if ListTruck.ItemIndex < 0 then Exit;
      if FieldByName('M_PrePValue').AsString <> sFlag_Yes then Exit;

      with gCardItems[ListTruck.ItemIndex] do
      if FPreValue > 0 then
      begin
        nInt := Trunc(FieldByName('M_Now').AsFloat - FPreTime);
        if nInt < FieldByName('M_PrePTime').AsInteger then
        begin
          gInfo.FPreValue := FPreValue;
          gInfo.FPreMan := FPreMan;
          gInfo.FPreTime := FPreTime;
        end else
        begin
          nStr := '注意: 该车辆的预置皮重已过期,请告知司机出厂前称量皮重!';
          ShowDlg(nStr, sWarn, Handle);
        end;
      end;
    end else
    begin
      Result := False;
      nHint := '无效的原材料名称';
    end;
  end else

  if Sender = EditTruck then
  begin
    Result := Trim(EditTruck.Text) <> '';
    nHint := '请填写有效的车牌号';
  end else

  if Sender = EditValue then
  begin
    Result := IsNumber(EditValue.Text, True) and (StrToFloat(EditValue.Text) > 0);
    nHint := '磅重为大于零的值';
  end
end;

//Desc: SQL
procedure TfFormBangFang.GetSaveSQLList(const nList: TStrings);
var nStr: string;
    nTmp: TStrings;
begin
  nTmp := TStringList.Create;
  try
    if gInfo.FStatus = sFlag_TruckBFP then
    begin
      nTmp.Add(SF('L_Truck', EditTruck.Text));
      nTmp.Add(SF('L_PValue', EditValue.Text, sfVal));
      nTmp.Add(SF('L_PMan', gSysParam.FUserID));
      nTmp.Add(SF('L_PDate', FDM.SQLServerNow, sfVal));
      nTmp.Add(SF('L_PaiNum', EditPNum.Text));
      nTmp.Add(SF('L_PaiTime', Date2Str(EditPTime.Date)));
      nTmp.Add(SF('L_Memo', EditMemo.Text));
      nTmp.Add(SF('L_Price', Format('%.2f', [gInfo.FPrice]), sfVal));
      nTmp.Add(SF('L_SaleMan', EditSM.Text));

      if IsProvideTruckAutoIO(2) then
      begin
        nTmp.Add(SF('L_Card', ''));
        nTmp.Add(SF('L_Status', sFlag_TruckOut));
        nTmp.Add(SF('L_NextStatus', ''));
        nTmp.Add(SF('L_OutMan', gSysParam.FUserID));
        nTmp.Add(SF('L_OutDate', FDM.SQLServerNow, sfVal));
      end else //auto out
      begin
        nTmp.Add(SF('L_Status', sFlag_TruckBFP));
        nTmp.Add(SF('L_NextStatus', sFlag_TruckOut));
      end;

      nStr := MakeSQLByCtrl(nil, sTable_ProvideLog, 'L_ID=' + gInfo.FRecord,
              False, nil, nTmp);
      nList.Add(nStr);
    end else
    begin
      nTmp.Add(Format('L_Provider=''%s''', [EditProvider.Text]));
      nTmp.Add(Format('L_SaleMan=''%s''', [EditSM.Text]));
      nTmp.Add(Format('L_Mate=''%s''', [EditMate.Text]));
      nTmp.Add(Format('L_Unit=''%s''', [gInfo.FUnit]));
      nTmp.Add(Format('L_Truck=''%s''', [EditTruck.Text]));
      nTmp.Add(Format('L_MValue=%s', [EditValue.Text]));
      nTmp.Add(Format('L_MMan=''%s''', [gSysParam.FUserID]));
      nTmp.Add(Format('L_MDate=%s', [FDM.SQLServerNow]));
      nTmp.Add('L_PrintNum=0');
      nTmp.Add(Format('L_PaiNum=''%s''', [EditPNum.Text]));
      nTmp.Add(Format('L_PaiTime=''%s''', [Date2Str(EditPTime.Date)]));
      nTmp.Add(Format('L_Memo=''%s''', [EditMemo.Text]));

      if gInfo.FPreValue > 0 then
      begin
        nTmp.Add(Format('L_PValue=%s', [FloatToStr(gInfo.FPreValue)]));
        nTmp.Add(Format('L_PMan=''%s''', [gInfo.FPreMan]));
        nTmp.Add(Format('L_PDate=''%s''', [DateTime2Str(gInfo.FPreTime)]));

        nTmp.Add(Format('L_Price=%.2f', [gInfo.FPrice]));
        if IsProvideTruckAutoIO(2) then
        begin
          nTmp.Add(SF('L_Card', ''));
          nTmp.Add(SF('L_Status', sFlag_TruckOut));
          nTmp.Add(SF('L_Status', ''));
          nTmp.Add(SF('L_OutMan', gSysParam.FUserID));
          nTmp.Add(SF('L_OutDate', FDM.SQLServerNow, sfVal));
        end else //auto out
        begin
          nTmp.Add(SF('L_Status', sFlag_TruckBFP));
          nTmp.Add(SF('L_NextStatus', sFlag_TruckOut));
        end;
      end else
      begin
        nTmp.Add(Format('L_Card=''%s''', [gInfo.FCardNo]));
        nTmp.Add(SF('L_Status', sFlag_TruckBFM));
        nTmp.Add(SF('L_NextStatus', sFlag_TruckBFP));

        if IsProvideTruckAutoIO(1) then
        begin
          nTmp.Add(SF('L_InMan', gSysParam.FUserID));
          nTmp.Add(SF('L_InDate', FDM.SQLServerNow, sfVal));
        end; //auto in
      end;

      if gInfo.FRecord = '' then
           nStr := MakeSQLByCtrl(nil, sTable_ProvideLog, '', True, nil, nTmp)
      else nStr := MakeSQLByCtrl(nil, sTable_ProvideLog,
                   'L_ID=' + gInfo.FRecord, False, nil, nTmp);
      nList.Add(nStr);
    end;
  finally
    nTmp.Free;
  end;
end;

//Desc: 处理磅单
procedure TfFormBangFang.AfterSaveData(var nDefault: Boolean);
var nStr: string;
begin
  if (gInfo.FStatus = sFlag_TruckBFM) and (gInfo.FPreValue > 0) then
  begin
    gInfo.FStatus := sFlag_TruckBFP;
    if gInfo.FRecord = '' then
      gInfo.FRecord := IntToStr(FDM.GetFieldMax(sTable_ProvideLog, 'L_ID'));
    //get record
  end;

  if gInfo.FStatus = sFlag_TruckBFP then
    PrintProvidePoundReport(gInfo.FRecord, True);
  BroadcastFrameCommand(Self, cCmd_RefreshData);

  if Check1.Checked then
  begin
    nStr := 'Update $TB Set P_PrePValue=$Val,P_PrePTime=$PT,P_PrePMan=''$PM'' ' +
            'Where P_Owner=''$PO''';
    nStr := MacroValue(nStr, [MI('$TB', sTable_ProvideCard),
            MI('$Val', EditValue.Text), MI('$PT', FDM.SQLServerNow),
            MI('$PM', gSysParam.FUserID), MI('$PO', EditTruck.Text)]);
    FDM.ExecuteSQL(nStr);
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormBangFang, TfFormBangFang.FormID);
end.

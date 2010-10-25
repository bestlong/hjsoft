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
  cxLookAndFeelPainters;

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
    dxLayout1Group4: TdxLayoutGroup;
    EditValue: TcxButtonEdit;
    dxLayout1Item6: TdxLayoutItem;
    cxLabel1: TcxLabel;
    dxLayout1Item7: TdxLayoutItem;
    EditPNum: TcxTextEdit;
    dxLayout1Item8: TdxLayoutItem;
    EditPTime: TcxDateEdit;
    dxLayout1Item9: TdxLayoutItem;
    dxLayout1Group2: TdxLayoutGroup;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EditValuePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnGetClick(Sender: TObject);
  protected
    { Protected declarations }
    function OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean; override;
    procedure GetSaveSQLList(const nList: TStrings); override;
    procedure AfterSaveData(var nDefault: Boolean); override;
    //基类方法
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
  ULibFun, UFormCtrl, UFormBase, UFrameBase, UAdjustForm, UMgrControl,
  UDataModule, UForminputbox, UFormWeight, USysDB, USysConst,
  USysBusiness, USysPopedom;

type
  TCommonInfo = record
    FRecord: string;
    FProvider: string;
    FMate: string;
    FPrice: Double;
    FCardNo: string;
    FTruckNo: string;
    FStatus: string;
    FPaiNum: string;
    FPaiTime: TDateTime;
  end;

var
  gInfo: TCommonInfo;
  //全局使用

//------------------------------------------------------------------------------
class function TfFormBangFang.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nStr: string;
    nID: Integer;
    nInfo: TDynamicStrArray;
begin
  nStr := '';
  Result := nil;

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
      FPaiNum := nInfo[3];
      FPaiTime := Str2Date(nInfo[4]);
      FStatus := sFlag_TruckBFP;
    end;
  end else //受否厂内车
  begin
    gInfo.FCardNo := nStr;
    nStr := 'Select * From %s Where P_Card=''%s''';
    nStr := Format(nStr, [sTable_ProvideCard, gInfo.FCardNo]);

    with FDM.QueryTemp(nStr),gInfo do
    if RecordCount = 1 then
    begin
      FProvider := FieldByName('P_Provider').AsString;
      FMate := FieldByName('P_Mate').AsString;
      FTruckNo := FieldByName('P_Owner').AsString;
      FCardNo := FieldByName('P_Card').AsString;
      FStatus := sFlag_TruckBFM;
    end else FCardNo := '';
  end; //是否磁卡

  with TfFormBangFang.Create(Application) do
  begin
    EditPNum.Text := gInfo.FPaiNum;
    EditPTime.Date := gInfo.FPaiTime;
    
    EditPNum.Properties.ReadOnly := gInfo.FStatus = sFlag_TruckBFP;
    EditPTime.Properties.ReadOnly := EditPNum.Properties.ReadOnly;

    if EditPNum.Properties.ReadOnly then
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
begin
  LoadFormConfig(Self);
end;

procedure TfFormBangFang.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveFormConfig(Self);
  ReleaseCtrlData(Self);
end;

//------------------------------------------------------------------------------
//Desc: 载入数据
procedure TfFormBangFang.InitFormData(const nID: string);
var nStr: string;
    nIdx: Integer;
    nArray: TDynamicStrArray;
begin
  ActiveControl := BtnGet;
  EditValue.Text := '0';  
  EditValue.Properties.ReadOnly := True;

  if gInfo.FRecord = '' then
  begin
    nStr := 'Select P_Name From %s Order By P_Name ASC';
    nStr := Format(nStr, [sTable_Provider]);
    FDM.FillStringsData(EditProvider.Properties.Items, nStr, -1);

    nStr := 'M_Unit=Select M_Unit,M_Name From %s Order By M_Name ASC';
    nStr := Format(nStr, [sTable_Materails]);
    
    SetLength(nArray, 1);
    nArray[0] := 'M_Unit';
    FDM.FillStringsData(EditMate.Properties.Items, nStr, -1, '', nArray);
    AdjustCXComboBoxItem(EditMate, False);

    nStr := 'Select DISTINCT L_Truck From %s Order By L_Truck ASC';
    nStr := Format(nStr, [sTable_ProvideLog]);
    FDM.FillStringsData(EditTruck.Properties.Items, nStr, -1);
  end;

  if (gInfo.FRecord <> '') or (gInfo.FCardNo <> '') then
  begin
    EditProvider.Properties.ReadOnly := True;
    EditMate.Properties.ReadOnly := True;
    //EditTruck.Properties.ReadOnly := True;
  end;

  with gInfo do
  begin
    if FProvider <> '' then EditProvider.Text := FProvider;
    if FMate <> '' then EditMate.Text := FMate;
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

    if (FProvider = '') and (not EditProvider.Properties.ReadOnly) then
    begin
      nStr := 'Select Top 1 L_Provider,L_Mate From %s ' +
              'Where L_Truck=''%s'' Order By L_ID DESC';
      nStr := Format(nStr, [sTable_ProvideLog, EditTruck.Text]);

      with FDM.QueryTemp(nStr) do
      if RecordCount > 0 then
      begin
        EditProvider.Text := Fields[0].AsString;
        EditMate.Text := Fields[1].AsString;
      end;
    end;
  end;
end;

//Desc: 解除锁定
procedure TfFormBangFang.EditValuePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
var nStr: string;
begin
  if not gPopedomManager.HasPopedom(sPopedom_Edit, PopedomItem) then Exit;
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

    nStr := 'Select M_Price From %s Where M_Name=''%s''';
    nStr := Format(nStr, [sTable_Materails, EditMate.Text]);

    with FDM.QueryTemp(nStr) do
    if RecordCount = 1 then
    begin
      gInfo.FPrice := Fields[0].AsFloat;
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
begin
  if gInfo.FStatus = sFlag_TruckBFP then
  begin
    nStr := 'Update %s Set L_PValue=%s,L_PMan=''%s'',L_PDate=%s,' +
            'L_Memo=''%s'',L_Price=%.2f Where L_ID=%s';
    nStr := Format(nStr, [sTable_ProvideLog, EditValue.Text, gSysParam.FUserID,
            FDM.SQLServerNow, EditMemo.Text, gInfo.FPrice, gInfo.FRecord]);
    nList.Add(nStr);
  end else
  begin
    nStr := 'Insert Into $TB(L_Provider,L_Mate,L_Unit,L_Truck,L_MValue,L_MMan,' +
            'L_MDate,L_Card,L_PrintNum,L_PaiNum,L_PaiTime,L_Memo) Values(''$PD'',' +
            '''$Mate'',''$Unit'',''$Truck'',$Val,''$Man'',$Date,''$Card'',0,' +
            '''$PNum'',''$PTime'',''$Memo'')';
    nStr := MacroValue(nStr, [MI('$TB', sTable_ProvideLog),
            MI('$PD', EditProvider.Text), MI('$Truck', EditTruck.Text),
            MI('$Val', EditValue.Text), MI('$Man', gSysParam.FUserID),
            MI('$Date', FDM.SQLServerNow), MI('$Memo', EditMemo.Text),
            MI('$Mate', EditMate.Text), MI('$Card', gInfo.FCardNo),
            MI('$PNum', EditPNum.Text), MI('$PTime', Date2Str(EditPTime.Date)),
            MI('$Unit', GetCtrlData(EditMate))]);
    nList.Add(nStr);
  end;
end;

//Desc: 处理磅单
procedure TfFormBangFang.AfterSaveData(var nDefault: Boolean);
begin
  if gInfo.FStatus = sFlag_TruckBFP then
    PrintProvidePoundReport(gInfo.FRecord, True);
  BroadcastFrameCommand(Self, cCmd_RefreshData);
end;

initialization
  gControlManager.RegCtrl(TfFormBangFang, TfFormBangFang.FormID);
end.

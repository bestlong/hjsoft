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
    EditSM: TcxComboBox;
    dxLayout1Item10: TdxLayoutItem;
    dxLayout1Group3: TdxLayoutGroup;
    dxLayout1Group5: TdxLayoutGroup;
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
    FSaleMan: string;

    FPrice: Double;
    FCardNo: string;
    FTruckNo: string;
    FStatus: string;

    FPaiNum: string;
    FPaiTime: TDateTime;
    FMemo: string;
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
      FSaleMan := nInfo[3];

      FPaiNum := nInfo[4];
      FPaiTime := Str2Date(nInfo[5]);
      FStatus := sFlag_TruckBFP;
      FMemo := nInfo[6];
    end;
  end else //是否厂内车
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

      FSaleMan := FieldByName('P_SaleMan').AsString;
      FCardNo := FieldByName('P_Card').AsString;
      FStatus := sFlag_TruckBFM;
    end else FCardNo := '';
  end; //是否磁卡

  with TfFormBangFang.Create(Application) do
  begin
    PopedomItem := nPopedom;
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

    EditSM.Text := FSaleMan;
    EditMemo.Text := FMemo;
    EditTruck.ItemIndex := EditTruck.Properties.Items.IndexOf(FTruckNo);

    if (FCardNo = '') and (EditTruck.ItemIndex < 0) then
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
    nStr := MakeSQLByStr([Format('L_PValue=%s', [EditValue.Text]),
              Format('L_PMan=''%s''', [gSysParam.FUserID]),
              Format('L_PDate=%s', [FDM.SQLServerNow]),
              Format('L_Memo=''%s''', [EditMemo.Text]),
              Format('L_Price=%.2f', [gInfo.FPrice]),
              Format('L_SaleMan=''%s''', [EditSM.Text])
            ], sTable_ProvideLog, Format('L_ID=%s', [gInfo.FRecord]), False);
    nList.Add(nStr);
  end else
  begin
    nStr := MakeSQLByStr([Format('L_Provider=''%s''', [EditProvider.Text]),
              Format('L_SaleMan=''%s''', [EditSM.Text]),
              Format('L_Mate=''%s''', [EditMate.Text]),
              Format('L_Unit=''%s''', [GetCtrlData(EditMate)]),
              Format('L_Truck=''%s''', [EditTruck.Text]),
              Format('L_MValue=%s', [EditValue.Text]),
              Format('L_MMan=''%s''', [gSysParam.FUserID]),
              Format('L_MDate=%s', [FDM.SQLServerNow]),
              Format('L_Card=''%s''', [gInfo.FCardNo]), 'L_PrintNum=0',
              Format('L_PaiNum=''%s''', [EditPNum.Text]),
              Format('L_PaiTime=''%s''', [Date2Str(EditPTime.Date)]),
              Format('L_Memo=''%s''', [EditMemo.Text])
            ], sTable_ProvideLog, '', True);
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

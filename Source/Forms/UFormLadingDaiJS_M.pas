{*******************************************************************************
  作者: dmzn@163.com 2009-6-12
  描述: 袋装计数(多道计数器)
*******************************************************************************}
unit UFormLadingDaiJS_M;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UDataModule, UMultiJS, UFormBase, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, ComCtrls, cxContainer, cxEdit, Menus, ImgList,
  dxLayoutControl, cxGroupBox, cxRadioGroup, cxMaskEdit, cxButtonEdit,
  cxTextEdit, cxListView, StdCtrls;
  
type
  PJSItemData = ^TJSItemData;
  TJSItemData = record
    FStock: string;            //品种
    FTruckNo: string;          //车牌号
    FBillID: string;           //提单号
    FBillBox: string;          //提单备份

    FStatus: string;           //状态
    FZTLine: string;           //栈台
    FComm: string;             //端口
    FTunnel: Word;             //通道
    FIsBC: Boolean;            //是否补差

    FTHValue: Double;          //提货量
    FNowDai: integer;          //待装数量
    FHasDone: integer;         //已装数量

    FTotalDS: Integer;         //已装应提
    FTotalBC: integer;         //已装补差
    FSavedDS: integer;         //已存应提
    FSavedBC: Integer;         //已存补差
    FIsValid: Boolean;         //是否有效
  end;

  TJSTunnelItem = record
    FDesc: string;             //描述
    FComm: string;             //串口
    FBaud: Word;               //速率
    FDelay: Word;              //延迟
    FTunnel: Word;             //道号
  end;

  TfFormLadingDaiJiShu = class(TBaseForm)
    dxLayoutControl1Group_Root: TdxLayoutGroup;
    dxLayoutControl1: TdxLayoutControl;
    dxGroup1: TdxLayoutGroup;
    dxLayoutControl1Item2: TdxLayoutItem;
    BtnRefresh: TButton;
    BtnSetup: TButton;
    dxLayoutControl1Item4: TdxLayoutItem;
    ListTruck: TcxListView;
    dxLayoutControl1Item5: TdxLayoutItem;
    dxGroup2: TdxLayoutGroup;
    EditTruck: TcxTextEdit;
    dxLayoutControl1Item7: TdxLayoutItem;
    EditValue: TcxTextEdit;
    dxLayoutControl1Item8: TdxLayoutItem;
    EditDS: TcxButtonEdit;
    dxLayoutControl1Item9: TdxLayoutItem;
    BtnStart: TButton;
    dxLayoutControl1Item10: TdxLayoutItem;
    ImageList1: TImageList;
    EditZTLine: TcxTextEdit;
    dxLayoutControl1Item11: TdxLayoutItem;
    Radio1: TcxRadioGroup;
    dxLayoutControl1Item6: TdxLayoutItem;
    dxLayoutControl1Group2: TdxLayoutGroup;
    dxLayoutControl1Group3: TdxLayoutGroup;
    dxLayoutControl1Group1: TdxLayoutGroup;
    PMenu1: TPopupMenu;
    N1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BtnSetupClick(Sender: TObject);
    procedure ListTruckClick(Sender: TObject);
    procedure Radio1PropertiesEditValueChanged(Sender: TObject);
    procedure BtnRefreshClick(Sender: TObject);
    procedure BtnStartClick(Sender: TObject);
    procedure EditDSPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure N1Click(Sender: TObject);
    procedure EditValuePropertiesEditValueChanged(Sender: TObject);
    procedure EditDSPropertiesEditValueChanged(Sender: TObject);
  private
    { Private declarations }
    FDataList: TList;
    //数据列表
    FPerWeight: Double;
    //袋重
    FJSer: TMultiJSManager;
    //计数器
    FTunnels: array of TJSTunnelItem;
    //计数通道
    procedure InitFormData;
    procedure LoadZTTruckList;
    procedure RefreshZTTruckList;
    //初始数据
    procedure SaveInvalidTruck;
    //保存数据
    procedure ClearDataList(const nFree: Boolean);
    //清理资源
    function FindTunnel(const nCtrl: TWinControl; const nPort: string;
      const nTunnel: Word; const nStatus: string = ''): Integer;
    //检索通道
    procedure OnData(nPort: string; nData: TMultiJSTunnel);
    //计数数据
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  IniFiles, ULibFun, UMgrControl, UFormCtrl, UAdjustForm, USysGrid, 
  USysDB, USysConst, USysBusiness, UFormLadingDaiParam_M;

var
  gForm: TfFormLadingDaiJiShu = nil;
  //全局使用

resourcestring
  sStatus_Wait = '排队';
  sStatus_Busy = '装车中';
  sStatus_Done = '完成';

//------------------------------------------------------------------------------
class function TfFormLadingDaiJiShu.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
begin
  Result := nil;

  if not Assigned(gForm) then
  begin
    gForm := TfFormLadingDaiJiShu.Create(Application);
    with gForm do
    begin
      Caption := '计数管理';
      FormStyle := fsStayOnTop;
      InitFormData;
    end;
  end;

  with gForm  do
  begin
    if not Showing then Show;
    WindowState := wsNormal;

    LoadZTTruckList;
    LoadcxListViewConfig(Name, ListTruck);
  end;
end;

class function TfFormLadingDaiJiShu.FormID: integer;
begin
  Result := cFI_FormJiShuQi;
end;

//------------------------------------------------------------------------------
procedure TfFormLadingDaiJiShu.FormCreate(Sender: TObject);
var nIni: TIniFile;
begin
  FDataList := TList.Create;
  FJSer := TMultiJSManager.Create;
  FJSer.OnData := OnData;
  
  nIni := TIniFile.Create(gPath + sFormConfig);
  try 
    LoadFormConfig(Self, nIni);
    LoadcxListViewConfig(Name, ListTruck, nIni);
  finally
    nIni.Free;
  end;
end;

procedure TfFormLadingDaiJiShu.FormClose(Sender: TObject;
  var Action: TCloseAction);
var nIni: TIniFile;
begin
  if FDataList.Count > 0 then
  begin
    Action := caHide; Exit;
  end;

  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveFormConfig(Self, nIni);
    SavecxListViewConfig(Name, ListTruck, nIni);
  finally
    nIni.Free;
  end;

  FJSer.Free;
  ClearDataList(True);

  gForm := nil;
  Action := caFree;
end;

procedure TfFormLadingDaiJiShu.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if Key = VK_ESCAPE then
  begin
    Key := 0; Close;
  end;
end;

//------------------------------------------------------------------------------
//Desc: 更新界面数据
procedure TfFormLadingDaiJiShu.InitFormData;
var nList,nTmp: TStrings;
    i,nCount,nIdx,nNum: Integer;
begin
  nList := TStringList.Create;
  nTmp := TStringList.Create;
  try
    SetLength(FTunnels, 0);
    Radio1.Properties.Items.Clear;;
    if not LoadZTList(nList) then Exit;

    FPerWeight := GetWeightPerPackage;
    nCount := nList.Count - 1;

    for i:=0 to nCount do
    if SplitStr(nList[i], nTmp, 4, ';') then
    begin
      nIdx := Length(FTunnels);
      SetLength(FTunnels, nIdx + 1);
      FillChar(FTunnels[nIdx], SizeOf(TJSTunnelItem), #0);

      with FTunnels[nIdx] do
      begin
        FDesc := nTmp[0];
        FComm := nTmp[1];
        FBaud := 9600;
        FTunnel := StrToInt(nTmp[2]);
        FDelay := StrToInt(nTmp[3]);
      end;
    end;

    nList.Clear;
    nNum := GetJSTunnelCount;

    for i:=Low(FTunnels) to High(FTunnels) do
    with Radio1.Properties.Items.Add do
    begin
      Tag := i;
      Caption := FTunnels[i].FDesc;

      if nList.IndexOf(FTunnels[i].FComm) < 0 then
        nList.Add(FTunnels[i].FComm);
      //xxxxx

      if Radio1.Properties.Items.Count >= nNum then
        Break;
      //authorization tunnel count
    end;

    with Radio1.Properties do
    begin
      if nCount < 2 then
           Columns := 1
      else Columns := Trunc(Items.Count / 2);
    end;

    for i:=nList.Count - 1 downto 0 do
    begin
      nCount := 0;

      for nIdx:=Low(FTunnels) to High(FTunnels) do
       if CompareText(FTunnels[nIdx].FComm, nList[i]) = 0 then Inc(nCount);
      FJSer.AddPort(nList[i], 9600, nCount);
    end;
  finally
    nTmp.Free;
    nList.Free;
  end;
end;

//Desc: 释放nList[nIdx]数据项
procedure FreeJSItemData(const nList: TList; const nIdx: integer);
begin
  Dispose(PJSItemData(nList[nIdx]));
  nList.Delete(nIdx);
end; 

//Desc: 清理提货项
procedure TfFormLadingDaiJiShu.ClearDataList(const nFree: Boolean);
var nIdx: integer;
begin
  for nIdx:=FDataList.Count - 1 downto 0 do
    FreeJSItemData(FDataList, nIdx);
  if nFree then FDataList.Free;
end;

//Desc: 在nList中检索车牌号为nTruck,品种为nStock的记录索引
function FindItemByTruck(const nTruck,nStock: string; const nList: TList): integer;
var nIdx: integer;
    nItem: PJSItemData;
begin
  for nIdx := nList.Count - 1 downto 0 do
  begin
    nItem := nList[nIdx];
    if (nItem.FTruckNo = nTruck) and (nItem.FStock = nStock) then
    begin
      Result := nIdx; Exit;
    end;
  end;

  Result := -1;
end;

//Desc: 载入数据
procedure TfFormLadingDaiJiShu.LoadZTTruckList;
var nStr: string;
    nIdx: integer;
    nItem: PJSItemData;
begin
  for nIdx:=FDataList.Count - 1 downto 0 do
  begin
    nItem := FDataList[nIdx];
    nItem.FBillBox := nItem.FBillID;
    nItem.FBillID := '';

    nItem.FTHValue := 0;
    nItem.FIsValid := False;
  end;
  //置为无效,为新数据做准备

  nStr := 'Select L_ID,L_Stock,L_Value,T_Truck From $TE te ' +
          ' Left Join $TL tl on tl.T_ID=te.E_TID ' +
          ' Left Join $Bill b on b.L_ID=te.E_Bill ' +
          'Where T_Status=''$ZT''';
  //xxxxx

  nStr := MacroValue(nStr, [MI('$TE', sTable_TruckLogExt),
          MI('$TL', sTable_TruckLog), MI('$Bill', sTable_Bill),
          MI('$ZT', sFlag_TruckZT)]);
  //栈台车辆


  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    First;

    while not Eof do
    try
      nStr := FieldByName('T_Truck').AsString;
      nIdx := FindItemByTruck(nStr, FieldByName('L_Stock').AsString, FDataList);
      //同车同品种,准备合吨

      if nIdx < 0 then
      begin
        New(nItem);
        FDataList.Add(nItem);
        FillChar(nItem^, SizeOf(TJSItemData), #0);

        with nItem^ do
        begin
          FBillID := FieldByName('L_ID').AsString;
          FStock := FieldByName('L_Stock').AsString;
          FTruckNo := FieldByName('T_Truck').AsString;
          FTHValue := FieldByName('L_Value').AsFloat;

          FIsBC := False;
          FIsValid := True;
          FStatus := sStatus_Wait;
        end;
      end else
      begin
        nItem := FDataList[nIdx];
        nItem.FIsValid := True;
        nItem.FTHValue := nItem.FTHValue + FieldByName('L_Value').AsFloat;

        nStr := FieldByName('L_ID').AsString;
        if nItem.FBillID = '' then
             nItem.FBillID := nStr
        else nItem.FBillID := nItem.FBillID + ',' + nStr; 
      end;
    finally
      Next;
    end;
  end;

  SaveInvalidTruck;
  //保存
  RefreshZTTruckList;
  //刷新到界面
end;

//Desc: 将nData填充到nItem中
procedure CombinTrucItemData(const nItem: TListItem; const nData: PJSItemData);
begin
  with nItem,nData^ do
  begin
    Caption := FStatus;
    SubItems.Clear;
    SubItems.Add(FZTLine);
    SubItems.Add(FTruckNo);
    SubItems.Add(FStock);

    SubItems.Add(Format('%.2f', [FTHValue]));
    SubItems.Add(Format('%.d', [FTotalDS]));
    SubItems.Add(Format('%.d', [FTotalBC]));
    SubItems.Add(Format('%.d/%d', [FHasDone, FNowDai]));
  end;
end;

//Desc: 刷新车辆数据到界面
procedure TfFormLadingDaiJiShu.RefreshZTTruckList;
var nList: TStrings;
    nTruck: TListItem;
    nItem: PJSItemData;
    i,nCount,nInt,nIdx: integer;
begin
  ListTruck.Items.BeginUpdate;
  nList := TStringList.Create;
  nIdx := ListTruck.ItemIndex;
  try
    for nInt:=FDataList.Count - 1 downto 0 do
     if not PJSItemData(FDataList[nInt]).FIsValid then
      FreeJSItemData(FDataList, nInt);
    //清除已经离开栈台的车辆

    LoadForbidZtock(nList);
    ListTruck.Items.Clear;
    nCount := FDataList.Count - 1;
    
    for i:=0 to nCount do
    begin
      nItem := FDataList[i];
      if nList.IndexOf(nItem.FStock) < 0 then
      begin
        nTruck := ListTruck.Items.Add;
        nTruck.Data := Pointer(i);   
        CombinTrucItemData(nTruck, nItem);
      end;
    end;
  finally
    nList.Free;
    if nIdx < ListTruck.Items.Count then
      ListTruck.ItemIndex := nIdx;
    ListTruck.Items.EndUpdate;
  end;
end;

//Desc: 保存已离开栈台的装车数据
procedure TfFormLadingDaiJiShu.SaveInvalidTruck;
var nStr: string;
    nIdx: Integer;
    nItem: PJSItemData;
begin
  for nIdx:=FDataList.Count - 1 downto 0 do
  try
    nItem := FDataList[nIdx];
    if nItem.FIsValid or (nItem.FTotalDS < 1) then Continue;
    //没离开或未装

    nStr := 'Update %s Set J_Value=%.2f,J_DaiShu=%d,J_BuCha=%d,J_Date=%s ' +
            'Where J_Bill=''%s''';
    nStr := Format(nStr, [sTable_TruckJS, nItem.FTHValue, nItem.FTotalDS,
            nItem.FTotalBC, FDM.SQLServerNow, nItem.FBillBox]);
    //xxxxx

    if FDM.ExecuteSQL(nStr) > 0 then Continue;
    //更新成功

    nStr := 'Insert Into %s(J_Truck,J_Stock,J_Value,J_DaiShu,J_BuCha,J_Bill,' +
            'J_Date) Values(''%s'',''%s'',%.2f,%d,%d,''%s'',%s)';
    nStr := Format(nStr, [sTable_TruckJS, nItem.FTruckNo, nItem.FStock,
            nItem.FTHValue, nItem.FTotalDS, nItem.FTotalBC,
            nItem.FBillBox, FDM.SQLServerNow]);
    FDM.ExecuteSQL(nStr);
  except
    Exit;
  end;
end;

//Desc: 在nCtrl中检索nPort.nTunnel通道
function TfFormLadingDaiJiShu.FindTunnel(const nCtrl: TWinControl;
  const nPort: string; const nTunnel: Word; const nStatus: string = ''): Integer;
var nIdx: Integer;
    nPItem: PJSItemData;
    nTItem: TJSTunnelItem;
begin
  Result := -1;

  if nCtrl = ListTruck then
  begin
    for nIdx:=ListTruck.Items.Count - 1 downto 0 do
    begin
      nPItem := FDataList[Integer(ListTruck.Items[nIdx].Data)];
      if (nPItem.FTunnel = nTunnel) and (CompareText(nPItem.FComm, nPort) = 0) and
         ((nStatus = '') or (nPItem.FStatus = nStatus)) then
      begin
        Result := nIdx; Exit;
      end;
    end;
  end else

  if nCtrl = Radio1 then
  begin
    for nIdx:=Radio1.Properties.Items.Count - 1 downto 0 do
    begin
      nTItem := FTunnels[Radio1.Properties.Items[nIdx].tag];
      if (nTItem.FTunnel = nTunnel) and (CompareText(nTItem.FComm, nPort) = 0) then
      begin
        Result := nIdx; Exit;
      end;
    end;
  end;
end;

//Desc: 设置栈台参数
procedure TfFormLadingDaiJiShu.BtnSetupClick(Sender: TObject);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveFormConfig(Self, nIni);
    SavecxListViewConfig(Name, ListTruck, nIni);
    //保存配置

    if ShowZTParamForm then
    begin
      InitFormData;
      RefreshZTTruckList;
    end;
  finally
    nIni.Free;
  end;
end;

//Desc: 选车辆
procedure TfFormLadingDaiJiShu.ListTruckClick(Sender: TObject);
var nIdx: Integer;
    nItem: PJSItemData;
begin
  if ListTruck.ItemIndex > -1 then
  begin
    nIdx := Integer(ListTruck.Items[ListTruck.ItemIndex].Data);
    nItem := FDataList[nIdx];
    EditTruck.Text := nItem.FTruckNo;

    EditZTLine.Text := nItem.FZTLine;
    Radio1.Properties.ReadOnly := nItem.FStatus = sStatus_Busy;
    Radio1.ItemIndex := FindTunnel(Radio1, nItem.FComm, nItem.FTunnel);
                                                               
    if nItem.FIsBC then
    begin
      EditDS.Properties.ReadOnly := False;
      EditValue.Properties.ReadOnly := False;
      dxLayoutControl1Item8.Caption := '补差量:';
      dxLayoutControl1Item9.Caption := '补差袋数:';

      EditDS.Text := '0';
      EditValue.Text := '0';
    end else
    begin
      EditDS.Properties.ReadOnly := True;
      EditValue.Properties.ReadOnly := True;
      dxLayoutControl1Item8.Caption := '提货量:';
      dxLayoutControl1Item9.Caption := '提货袋数:';

      EditValue.Text := Format('%.2f', [nItem.FTHValue]);
      EditDS.Text := Format('%.d', [Trunc(nItem.FTHValue * 1000 / FPerWeight)]);
    end;
  end;
end;

//Desc: 选择栈台
procedure TfFormLadingDaiJiShu.Radio1PropertiesEditValueChanged(Sender: TObject);
begin
  if Radio1.ItemIndex > -1 then
       EditZTLine.Text := Radio1.Properties.Items[Radio1.ItemIndex].Caption
  else EditZTLine.Text := '';
end;

//Desc: 载入车辆列表
procedure TfFormLadingDaiJiShu.BtnRefreshClick(Sender: TObject);
begin
  LoadZTTruckList;
end;

//Desc: 更新袋数
procedure TfFormLadingDaiJiShu.EditValuePropertiesEditValueChanged(
  Sender: TObject);
var nValue: Double;
begin
  if IsNumber(EditValue.Text, True) and (FPerWeight > 0) then
  begin
    nValue := StrToFloat(EditValue.Text)  * 1000;
    EditDS.Text := Format('%d', [Trunc(nValue / FPerWeight)]);
  end else EditValue.Text := '0';
end;

//Desc: 更新提货量
procedure TfFormLadingDaiJiShu.EditDSPropertiesEditValueChanged(
  Sender: TObject);
var nValue: Double;
begin
  if IsNumber(EditDS.Text, False) and (FPerWeight > 0) then
  begin
    nValue := (StrToInt(EditDS.Text) * FPerWeight) / 1000;
    EditValue.Text := Format('%.2f', [nValue]);
  end else EditDS.Text := '0';
end;

//------------------------------------------------------------------------------
//Desc: 开始计数
procedure TfFormLadingDaiJiShu.BtnStartClick(Sender: TObject);
var nStr: string;
    nIdx: integer;
    nPItem: PJSItemData;
    nTItem: TJSTunnelItem;
begin
  if ListTruck.ItemIndex < 0 then
  begin
    ListTruck.SetFocus;
    ShowMsg('请选择要提货的车辆', sHint); Exit;
  end;

  if Radio1.ItemIndex < 0 then
  begin
    Radio1.SetFocus;
    ShowMsg('请选择栈台位置', sHint); Exit;
  end;

  if (not IsNumber(EditDS.Text, False)) or (StrToInt(EditDS.Text) < 1) then
  begin
    EditDS.SetFocus;
    ShowMsg('袋数为大于0的整数', sHint); Exit;
  end;

  nIdx := Integer(ListTruck.Selected.Data);
  nPItem := FDataList[nIdx];

  if nPItem.FStatus = sStatus_Busy then
  begin
    ShowMsg('装车中,请稍候', sHint); Exit;
  end;

  nIdx := Radio1.ItemIndex;
  nTItem := FTunnels[Radio1.Properties.Items[nIdx].Tag];

  if FJSer.SetTunnelData(nTItem.FComm, nTItem.FTunnel, nTItem.FDelay,
     nPItem.FTruckNo, StrToInt(EditDS.Text), nStr) then
  begin
    nPItem.FComm := nTItem.FComm;
    nPItem.FTunnel := nTItem.FTunnel;

    nPItem.FHasDone := 0;
    nPItem.FNowDai := StrToInt(EditDS.Text);
    nPItem.FZTLine := Radio1.Properties.Items[nIdx].Caption;

    nPItem.FStatus := sStatus_Busy;
    CombinTrucItemData(ListTruck.Selected, nPItem);
  end else ShowMsg(nStr, sHint);     
end;

//Desc: 处理计数数据
procedure TfFormLadingDaiJiShu.OnData(nPort: string; nData: TMultiJSTunnel);
var nIdx,nInt: Integer;
    nItem: PJSItemData;
begin
  nIdx := FindTunnel(ListTruck, nPort, nData.FTunnel, sStatus_Busy);
  if nIdx < 0 then Exit;
  nItem := FDataList[Integer(ListTruck.Items[nIdx].Data)];
  
  with nItem^ do
  begin
    if nData.FHasDone <= FHasDone then Exit;
    nInt := nData.FHasDone - FHasDone;

    if FIsBC then
         FTotalBC := FTotalBC + nInt
    else FTotalDS := FTotalDS + nInt;

    FHasDone := nData.FHasDone;
    FNowDai := nData.FDaiNum - nData.FHasDone;

    if FNowDai = 0 then
    begin
      FStatus := sStatus_Done;
      if not FIsBC then FIsBC := True;
    end else FStatus := sStatus_Busy;

    CombinTrucItemData(ListTruck.Items[nIdx], nItem);
    if (FNowDai = 0) and (nIdx = ListTruck.ItemIndex) then
      ListTruckClick(nil);
    //update list ui
  end;
end;

//Desc: 切换手工输入袋数
procedure TfFormLadingDaiJiShu.EditDSPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
var nStr: string;
begin
  if EditDS.Properties.ReadOnly then
       nStr := '确定要手工输入提货袋数吗?'
  else nStr := '确定要关闭手工输入吗?';

  if QueryDlg(nStr, sAsk, Handle) then
    EditDS.Properties.ReadOnly := not EditDS.Properties.ReadOnly;
  EditValue.Properties.ReadOnly := EditDS.Properties.ReadOnly;
end;

//Desc: 重置计数器
procedure TfFormLadingDaiJiShu.N1Click(Sender: TObject);
var nStr: string;
    nIdx: integer;
    nItem: PJSItemData;
begin
  if ListTruck.ItemIndex < 0 then Exit;
  if not QueryDlg('确定要停止该车装车计数吗?', sAsk, Handle) then Exit;

  nIdx := Integer(ListTruck.Items[ListTruck.ItemIndex].Data);
  nItem := FDataList[nIdx];
  FJSer.StopTunnel(nItem.FComm, nItem.FTunnel, nStr);

  nItem.FNowDai := 0;
  nItem.FHasDone := 0;
  nItem.FIsBC := nItem.FTotalDS > 0;

  nItem.FStatus := sStatus_Wait;                    
  CombinTrucItemData(ListTruck.Items[ListTruck.ItemIndex], nItem);
  ListTruckClick(nil);
end;

initialization
  gControlManager.RegCtrl(TfFormLadingDaiJiShu, TfFormLadingDaiJiShu.FormID);
end.

{*******************************************************************************
  作者: dmzn@163.com 2009-6-12
  描述: 袋装计数
*******************************************************************************}
unit UFormLadingDaiJS;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UDataModule, SPComm, UFormBase, ComCtrls, ImgList, cxTextEdit,
  cxListView, cxLabel, StdCtrls, dxLayoutControl, cxContainer, cxEdit,
  cxMaskEdit, cxButtonEdit, cxControls, cxLookAndFeelPainters, cxGroupBox,
  cxRadioGroup, Menus;

const
  //接收缓冲边界
  cRecBuf_Low = 0;
  cRecBuf_Len = 100;
  cRecBuf_Max = cRecBuf_Low + cRecBuf_Len - 1;
  
type
  PJSItemData = ^TJSItemData;
  TJSItemData = record
    FStock: string;            //品种
    FTruckNo: string;          //车牌号

    FStatus: string;           //状态
    FComPort: string;          //通信端口
    FZTLine: string;           //栈台
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

  TCommItem = record
    FComm: TComm;              //通讯组件
    FUIIdx: integer;           //界面索引
    FJSItem: PJSItemData;      //计数项

    FLastDS: Integer;          //上次袋数
    FBufIdx: Integer;          //缓冲当前位置
    FBuffer: array[cRecBuf_Low..cRecBuf_Max] of Char; //接收缓冲
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
    procedure EditValuePropertiesChange(Sender: TObject);
    procedure EditDSPropertiesChange(Sender: TObject);
  private
    { Private declarations }
    FDataList: TList;
    //数据列表
    FPerWeight: Double;
    //袋重
    FJSComm: array of TCommItem;
    //通信组件
    procedure InitFormData;
    procedure LoadZTTruckList;
    procedure RefreshZTTruckList;
    //初始数据
    procedure ClearJSComm;
    procedure ClearDataList(const nFree: Boolean);
    //清理资源
    function ParseZTLine(const nDesc: Boolean; const nIdx: Integer = -1): string;
    //解析栈台
    function GetJSComm(const nComm: string): Integer;
    //获取通信组件
    procedure OnRecData(Sender: TObject; Buffer: Pointer; BufferLength: Word);
    //接收数据
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
  USysDB, USysConst, USysBusiness, UFormLadingDaiParam;

var
  gIsRefreshing: Boolean = False;
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

  ClearJSComm;
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
var nList: TStrings;
    i,nCount: Integer;
begin
  nList := TStringList.Create;
  try
    Radio1.Properties.Items.Clear;;
    FPerWeight := GetWeightPerPackage;

    if LoadZTList(nList, False) then
         nCount := nList.Count - 1
    else Exit;

    with Radio1.Properties do
    begin
      for i:=0 to nCount do
        Items.Add.Caption := nList[i];
      //xxxxx

      if nCount < 3 then
           Columns := 1
      else Columns := Trunc(Items.Count / 3);
    end;
  finally
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

//Desc: 清理通信组件
procedure TfFormLadingDaiJiShu.ClearJSComm;
var nIdx: integer;
begin
  for nIdx:=Low(FJSComm) to High(FJSComm) do
  if Assigned(FJSComm[nIdx].FComm) then
  begin
    FJSComm[nIdx].FComm.StopComm;
    FJSComm[nIdx].FComm.Free;
    FJSComm[nIdx].FComm := nil;
  end;

  SetLength(FJSComm, 0);
end;

//Desc: 获取nComm端口的通信组件
function TfFormLadingDaiJiShu.GetJSComm(const nComm: string): Integer;
var nIdx: integer;
begin
  for nIdx:=Low(FJSComm) to High(FJSComm) do
  if FJSComm[nIdx].FComm.CommName = nComm then
  begin
    Result := nIdx; Exit;
  end;

  Result := Length(FJSComm);
  SetLength(FJSComm, Result + 1);

  FJSComm[Result].FComm := TComm.Create(Self);
  with FJSComm[Result].FComm do
  begin
    Tag := Result;
    CommName := nComm;
    
    BaudRate := 9600;
    ReadIntervalTimeout := 5;
    OnReceiveData := OnRecData;
  end;
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
    i,nIdx: integer;
    nItem: PJSItemData;
begin
  for nIdx:=FDataList.Count - 1 downto 0 do
    PJSItemData(FDataList[nIdx]).FIsValid := False;
  //置为无效,为新数据做准备

  nStr := 'Select T_Truck,L_Stock,Sum(L_Value) as L_Value From $TE te ' +
          ' Left Join $TL tl on tl.T_ID=te.E_TID ' +
          ' Left Join $Bill b on b.L_ID=te.E_Bill ' +
          'Where T_Status=''$ZT'' Group By T_Truck,L_Stock';
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
        nItem.FTHValue := FieldByName('L_Value').AsFloat;
      end;
    finally
      Next;
    end;
  end;

  for nIdx:=FDataList.Count - 1 downto 0 do
  if not PJSItemData(FDataList[nIdx]).FIsValid then
  begin
    for i:=Low(FJSComm) to High(FJSComm) do
    if FJSComm[i].FJSItem = FDataList[nIdx] then
    begin
      FJSComm[i].FUIIdx := -1;
      FJSComm[i].FComm.StopComm;
    end;

    FreeJSItemData(FDataList, nIdx);
  end;
  //清除已经离开栈台的车辆

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
    i,nCount,nInt,nIdx,nIdx2: integer;
begin
  ListTruck.Items.BeginUpdate;
  nList := TStringList.Create;
  nIdx := ListTruck.ItemIndex;
  try
    gIsRefreshing := True;
    LoadForbidZtock(nList);
    ListTruck.Items.Clear;

    nCount := FDataList.Count - 1;
    for i:=0 to nCount do
    begin
      nIdx2 := -1;
      nItem := FDataList[i];

      if nList.IndexOf(nItem.FStock) < 0 then
      begin
        nTruck := ListTruck.Items.Add;
        nTruck.Data := Pointer(i);

        CombinTrucItemData(nTruck, nItem);
        nIdx2 := ListTruck.Items.Count - 1;
      end;

      for nInt:=Low(FJSComm) to High(FJSComm) do
      if FJSComm[nInt].FJSItem = nItem then
      begin
        FJSComm[nIdx].FUIIdx := nIdx2; Break;
      end;
    end;
  finally
    gIsRefreshing := False;
    nList.Free;          

    if nIdx < ListTruck.Items.Count then
      ListTruck.ItemIndex := nIdx;
    ListTruck.Items.EndUpdate;
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

//Date: 2010-4-8
//Parm: 是否描述
//Desc: 获取栈台位置信息,取COM端口或描述
function TfFormLadingDaiJiShu.ParseZTLine(const nDesc: Boolean;
  const nIdx: Integer): string;
var nPos: Integer;
begin
  if nIdx < 0 then
       nPos := Radio1.ItemIndex
  else nPos := nIdx;

  Result := Radio1.Properties.Items[nPos].Caption;
  nPos := Pos('.', Result);
  
  if nDesc then
       System.Delete(Result, 1, nPos)
  else Result := Copy(Result, 1, nPos - 1);
end;

//Desc: 选车辆
procedure TfFormLadingDaiJiShu.ListTruckClick(Sender: TObject);
var nStr: string; 
    i,nIdx: Integer;
    nItem: PJSItemData;
begin
  if ListTruck.ItemIndex > -1 then
  begin
    nIdx := Integer(ListTruck.Items[ListTruck.ItemIndex].Data);
    nItem := FDataList[nIdx];
    EditTruck.Text := nItem.FTruckNo;

    EditZTLine.Text := '';
    Radio1.ItemIndex := -1;

    for i:=Radio1.Properties.Items.Count - 1 downto 0 do
    begin
      nStr := ParseZTLine(True, i);
      if CompareText(nStr, nItem.FZTLine) = 0 then
      begin
        Radio1.ItemIndex := i;
        EditZTLine.Text := nStr;
      end;
    end;

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
procedure TfFormLadingDaiJiShu.Radio1PropertiesEditValueChanged(
  Sender: TObject);
begin
  if Radio1.ItemIndex > -1 then
       EditZTLine.Text := ParseZTLine(True)
  else EditZTLine.Text := '';
end;

//Desc: 载入车辆列表
procedure TfFormLadingDaiJiShu.BtnRefreshClick(Sender: TObject);
begin
  LoadZTTruckList;
end;

//Desc: 更新袋数
procedure TfFormLadingDaiJiShu.EditValuePropertiesChange(Sender: TObject);
var nValue: Double;
begin
  if IsNumber(EditValue.Text, True) then
  begin
    if EditValue.Focused and (FPerWeight > 0) then
    begin
      nValue := StrToFloat(EditValue.Text)  * 1000;
      EditDS.Text := Format('%d', [Trunc(nValue / FPerWeight)]);
    end;
  end else EditValue.Text := '0';
end;

//Desc: 更新提货量
procedure TfFormLadingDaiJiShu.EditDSPropertiesChange(Sender: TObject);
var nValue: Double;
begin
  if IsNumber(EditDS.Text, False) then
  begin
    if EditDS.Focused and (FPerWeight > 0) then
    begin
      nValue := (StrToInt(EditDS.Text) * FPerWeight) / 1000;
      EditValue.Text := Format('%.2f', [nValue]);
    end;
  end else EditDS.Text := '0';
end;

//------------------------------------------------------------------------------
//Desc: 发送计数数据
function SetJsqData(const nComm: TComm; const nData: PJSItemData): Boolean;
var nBuf,nVer: Byte;
    nInt: Integer;
    nStr,nErr: string;
begin
  Result := False;
  if Length(nData.FTruckNo) < 3 then
  begin
    ShowMsg('车牌号应该大于三位', sHint); Exit;
  end;

  try
    if nComm.Handle = 0 then
    begin
      nErr := '与计数器通信失败';
      nComm.StartComm;
      Sleep(1000);
    end;

    nErr := '发送车牌号失败';
    nStr := Copy(nData.FTruckNo, Length(nData.FTruckNo) - 2, 3);

    nVer := 0;
    nBuf := Ord('@');
    //ComJsq.WriteCommData(@nBuf, 1);

    for nInt:=1 to Length(nStr) do
    begin
      nBuf := Ord(nStr[nInt]) - 48;
      nVer := nVer + nBuf;
      nComm.WriteCommData(@nBuf, 1);
    end;

    nErr := '发送袋数失败';
    nData.FHasDone := 0;
    nStr := IntToStr(nData.FNowDai);
    nStr := StringOfChar('0', 4 - Length(nStr)) + nStr;
    //四位补全

    for nInt:=1 to Length(nStr) do
    begin
      nBuf := Ord(nStr[nInt]) - 48;
      nVer := nVer + nBuf;
      nComm.WriteCommData(@nBuf, 1);
    end;

    nComm.WriteCommData(@nVer, 1);
    nBuf := 13;
    nComm.WriteCommData(@nBuf, 1);

    Sleep(1000);
    Result := True;
  except
    ShowMsg(nErr, sHint); Exit;
  end;          
end;

//Desc: 接收数据
procedure TfFormLadingDaiJiShu.OnRecData(Sender: TObject; Buffer: Pointer;
  BufferLength: Word);
var nStr: string;
    nInt,nIdx: integer;
    nItem: PJSItemData;
begin
  if (BufferLength < 1) Or (BufferLength > cRecBuf_Len) then Exit;
  //空数据或超出缓冲
  nIdx := TComponent(Sender).Tag;

  with FJSComm[nIdx] do
  begin
    if FBufIdx + BufferLength > cRecBuf_Max then
      FBufIdx := cRecBuf_Low;
    //避免越界

    Move(Buffer^, FBuffer[FBufIdx], BufferLength);
    FBufIdx := FBufIdx + BufferLength;
    nStr := '';

    for nInt:=FBufIdx - 1 downto cRecBuf_Low do
    if FBuffer[nInt] = #13 then
    begin
      if nInt < 5 then Exit;

      nStr := IntToStr(Ord(FBuffer[nInt-4])) +
            IntToStr(Ord(FBuffer[nInt-3])) +
            IntToStr(Ord(FBuffer[nInt-2])) + IntToStr(Ord(FBuffer[nInt-1]));
      Break;
    end;

    if not IsNumber(nStr, False) then Exit;
    nInt := StrToInt(nStr);
    
    if FLastDS = nInt  then
         Exit
    else FLastDS := nInt;
  end;

  nItem := FJSComm[nIdx].FJSItem;
  if FDataList.IndexOf(nItem) < 0 then
  begin
    TComm(Sender).StopComm; Exit;
  end;
  
  with nItem^ do
  begin
    nInt := FNowDai - FJSComm[nIdx].FLastDS;
    if nInt < 0 then Exit;

    FHasDone := FHasDone + nInt;
    if FIsBC then
         FTotalBC := FTotalBC + nInt
    else FTotalDS := FTotalDS + nInt;

    FNowDai := FJSComm[nIdx].FLastDS;
    //更新计数器当前值

    if FNowDai = 0 then
    begin
      FStatus := sStatus_Done;
      if not FIsBC then FIsBC := True;
      TComm(Sender).StopComm;
    end else FStatus := sStatus_Busy;

    if (not gIsRefreshing) and (FJSComm[nIdx].FUIIdx > -1) then
    begin
      CombinTrucItemData(ListTruck.Items[FJSComm[nIdx].FUIIdx], nItem);
      if (FNowDai = 0) and (ListTruck.ItemIndex = FJSComm[nIdx].FUIIdx) then
        ListTruckClick(nil);
      //xxxxx
    end;
  end;
end;

//Desc: 开始计数
procedure TfFormLadingDaiJiShu.BtnStartClick(Sender: TObject);
var nComm: TComm;
    nIdx: integer;
    nItem: PJSItemData;
begin
  if ListTruck.ItemIndex < 0 then
  begin
    ListTruck.SetFocus;
    ShowMsg('请选择要提货的车辆', sHint); Exit;
  end;

  nIdx := Integer(ListTruck.Items[ListTruck.ItemIndex].Data);
  nItem := FDataList[nIdx];
  
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

  nIdx := GetJSComm(ParseZTLine(False));
  nComm := FJSComm[nIdx].FComm;
  
  if nComm.Handle <> 0 then
  begin
    EditZTLine.SetFocus;
    ShowMsg('该栈台计数器正在提货', sHint); Exit;
  end;

  nItem.FComPort := ParseZTLine(False);
  nItem.FZTLine := ParseZTLine(True);
  nItem.FNowDai := StrToInt(EditDS.Text);

  with FJSComm[nIdx] do
  begin
    FUIIdx := ListTruck.ItemIndex;
    FJSItem := nItem;
    FLastDS := -1;
    FBufIdx := cRecBuf_Low;
  end;

  if SetJsqData(nComm, nItem) then
  begin
    nIdx := ListTruck.ItemIndex;
    nItem.FStatus := sStatus_Busy;
    CombinTrucItemData(ListTruck.Items[nIdx], nItem);
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
  nIdx := Integer(ListTruck.Items[ListTruck.ItemIndex].Data);
  
  nItem := FDataList[nIdx];
  if nItem.FComPort = '' then Exit;
  //未提货

  nStr := '该操作会断开与计数器的通信,但不影响计数器提货!!' + #13#10 +
          '是否继续?';
  if QueryDlg(nStr, sAsk, Handle) then
  begin
    nIdx := GetJSComm(nItem.FComPort);
    FJSComm[nIdx].FComm.StopComm;

    nItem.FStatus := '排队';
    nItem.FIsBC := nItem.FTotalDS > 0;

    CombinTrucItemData(ListTruck.Items[ListTruck.ItemIndex], nItem);
    ListTruckClick(nil);
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormLadingDaiJiShu, TfFormLadingDaiJiShu.FormID);
end.

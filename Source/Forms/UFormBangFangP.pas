{*******************************************************************************
  作者: dmzn@163.com 2010-3-14
  描述: 磅房称量皮重
*******************************************************************************}
unit UFormBangFangP;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFormNormal, USysBusiness, ComCtrls, cxGraphics, cxDropDownEdit,
  cxMaskEdit, cxButtonEdit, cxEdit, cxTextEdit, cxListView, cxContainer,
  cxMCListBox, dxLayoutControl, StdCtrls, cxControls;

type
  TfFormBangFangP = class(TfFormNormal)
    dxGroup2: TdxLayoutGroup;
    ListInfo: TcxMCListBox;
    dxLayout1Item3: TdxLayoutItem;
    ListTruck: TcxListView;
    dxLayout1Item7: TdxLayoutItem;
    EditZK: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    EditCard: TcxTextEdit;
    dxLayout1Item6: TdxLayoutItem;
    dxLayout1Group2: TdxLayoutGroup;
    dxLayout1Group3: TdxLayoutGroup;
    EditValue: TcxButtonEdit;
    dxLayout1Item9: TdxLayoutItem;
    EditTruck: TcxComboBox;
    dxLayout1Item8: TdxLayoutItem;
    BtnGet: TButton;
    dxLayout1Item5: TdxLayoutItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EditTruckPropertiesChange(Sender: TObject);
    procedure BtnGetClick(Sender: TObject);
    procedure EditValuePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnOKClick(Sender: TObject);
    procedure EditValuePropertiesEditValueChanged(Sender: TObject);
  protected
    { Protected declarations }
    function OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean; override;
    procedure InitFormData(const nID: string);
    //载入数据
    procedure LoadTruckList;
    //载入车辆
    procedure LoadLadingList(const nTruck: string);
    //提货单
    procedure SaveNewWeightData;
    function UpdateTiHuo(const nTruck: TLadingTruckItem): Boolean;

    function IsSanWeightValid: Boolean;
    procedure UpdateSanWeightData(const nTruck: TLadingTruckItem);
    function UpdateSanSongH(const nTruck: TLadingTruckItem): Boolean;
    //保存数据
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
    //基类函数
  end;

implementation

{$R *.dfm}
uses
  IniFiles, DB, ULibFun, UMgrControl, USysPopedom, UFormBase, USysGrid, USysDB,
  USysConst, UDataModule, UFormWeight;

type
  TCommonInfo = record
    FZhiKa: string;
    FCard: string;
    FZKMoney: Boolean; 
    FTruckIdx: Integer;
    FNetWeight: Double; //提货净重
    FTruckNetW: Double; //车辆净重
  end;

var
  gInfo: TCommonInfo;
  gHKItems: TList;
  gTrucks: TDynamicTruckArray;
  //全局使用

//------------------------------------------------------------------------------
class function TfFormBangFangP.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nStr: string;
    nIdx: Integer;
    nP: TFormCommandParam;
    nTruck: TDynamicTruckArray;
begin
  Result := nil;
  SetLength(nTruck, 0);
  FillChar(nP, SizeOf(nP), #0);

  CreateBaseFormItem(cFI_FormVerifyCard, '', @nP);
  if (nP.FCommand <> cCmd_ModalResult) or (nP.FParamA <> mrOK) then Exit;

  with gInfo do
  begin
    FCard := nP.FParamB;
    FZhiKa := nP.FParamC;
    FTruckIdx := -1;
  end;

  if not LoadLadingTruckItems(gInfo.FCard, sFlag_TruckBFP, sFlag_TruckBFP,
     gTrucks, nStr, False) then
  begin
    if not LoadBillTruckItems(gInfo.FCard, nTruck, nStr) then
    begin
      if not gPopedomManager.HasPopedom(sPopedom_Add, nPopedom) then
      begin
        nStr := nStr + #13#10 + '您没有开提货单权限.';
        nStr := '称量皮重操作被终止,原因如下:' + #13#10 + #13#10 +
                AdjustHintToRead(nStr);
        ShowDlg(nStr, sWarn); Exit;
      end;

      ShowMsg('请先开提货单', sHint);
      FillChar(nP, SizeOf(nP), #0);
      nP.FParamB := gInfo.FCard;

      CreateBaseFormItem(cFI_FormBill, '', @nP);
      if (nP.FCommand <> cCmd_ModalResult) or (nP.FParamA <> mrOK) then Exit;

      if not LoadBillTruckItems(gInfo.FCard, nTruck, nStr) then
      begin
        nStr := '称量皮重操作被终止,原因如下:' + #13#10 + #13#10 +
              AdjustHintToRead(nStr);
        ShowDlg(nStr, sWarn); Exit;
      end;
    end;

    for nIdx:=Low(nTruck) to High(nTruck) do
     with nTruck[nIdx] do
      FIsCombine := (FLading = sFlag_TiHuo) or (FStockType <> sFlag_San);
    //xxxxx

    SetLength(gTrucks, 0);
    CombinTruckItems(nTruck, gTrucks);
    //合并提货单

    if Length(gTrucks) < 1 then
    begin
      nStr := '该卡上没有需要称量皮重的车辆.';
      nStr := '称量皮重操作被终止,原因如下:' + #13#10 + #13#10 +
              AdjustHintToRead(nStr);
      ShowDlg(nStr, sWarn); Exit;
    end;
  end;

  with TfFormBangFangP.Create(Application) do
  begin
    Caption := '称量皮重';
    PopedomItem := nPopedom;
    
    InitFormData(gInfo.FZhiKa);
    ShowModal;
    Free;
  end;
end;

class function TfFormBangFangP.FormID: integer;
begin
  Result := cFI_FormBangFangP;
end;

procedure TfFormBangFangP.FormCreate(Sender: TObject);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadFormConfig(Self, nIni);
    LoadMCListBoxConfig(Name, ListInfo, nIni);
    LoadcxListViewConfig(Name, ListTruck, nIni);
  finally
    nIni.Free;
  end;
end;

procedure TfFormBangFangP.FormClose(Sender: TObject;
  var Action: TCloseAction);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveFormConfig(Self, nIni);
    SaveMCListBoxConfig(Name, ListInfo, nIni);
    SavecxListViewConfig(Name, ListTruck, nIni);
  finally
    nIni.Free;
  end;
end;

//------------------------------------------------------------------------------
//Desc: 载入nID纸卡的内容
procedure TfFormBangFangP.InitFormData(const nID: string);
var nStr: string;
begin
  if LoadZhiKaInfo(nID, ListInfo, nStr) = nil then
  begin
    BtnOK.Enabled := False;
    ShowMsg(nStr, sHint); Exit;
  end;

  EditZK.Text := gInfo.FZhiKa;
  EditCard.Text := gInfo.FCard;
  ActiveControl := BtnGet;
  LoadTruckList;
end;

//Desc: 载入车辆列表到界面
procedure TfFormBangFangP.LoadTruckList;
var nIdx: Integer;
begin
  EditTruck.Clear;
  for nIdx:=Low(gTrucks) to High(gTrucks) do
   if EditTruck.Properties.Items.IndexOf(gTrucks[nIdx].FTruckNo) < 0 then
    EditTruck.Properties.Items.Add(gTrucks[nIdx].FTruckNo);
  if EditTruck.Properties.Items.Count > 0 then EditTruck.ItemIndex := 0;
end;

//Desc: 载入nTruck对应的提货单
procedure TfFormBangFangP.LoadLadingList(const nTruck: string);
var i,nIdx: Integer;
begin
  nIdx := ListTruck.ItemIndex;
  ListTruck.Items.BeginUpdate;
  try
    ListTruck.Clear;
    ListTruck.Checkboxes := gTrucks[0].FIsLading = False;
    //新提货单

    if ListTruck.Checkboxes then
         ListTruck.SmallImages := nil
    else ListTruck.SmallImages := FDM.ImageBar;
                                  
    for i:=Low(gTrucks) to High(gTrucks) do
    if gTrucks[i].FTruckNo = nTruck then
    with ListTruck.Items.Add, gTrucks[i] do
    begin
      Caption := FBill;
      SubItems.Add(FStockName);
      SubItems.Add(FTruckNo);
      SubItems.Add(Format('%.2f', [FValue]));

      ImageIndex := cItemIconIndex;
      Checked := FSelect;
      Data := Pointer(i);
    end;
  finally
    if nIdx < ListTruck.Items.Count then
      ListTruck.ItemIndex := nIdx;
    ListTruck.Items.EndUpdate;
  end;
end;

//Desc: 同步提货单
procedure TfFormBangFangP.EditTruckPropertiesChange(Sender: TObject);
begin
  with gInfo do
  if (EditTruck.ItemIndex > -1) and (EditTruck.ItemIndex <> FTruckIdx) then
  begin
    if IsNumber(EditValue.Text, True) and (StrToFloat(EditValue.Text) > 0) and        
       (not QueryDlg('确定要切换到其它车辆吗?', sAsk)) then
    begin
      EditTruck.ItemIndex := FTruckIdx; Exit;
    end;

    FTruckIdx := EditTruck.ItemIndex;
    LoadLadingList(EditTruck.Text);
  end;
end;

//Desc: 读磅
procedure TfFormBangFangP.BtnGetClick(Sender: TObject);
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

//Desc: 解除锁定
procedure TfFormBangFangP.EditValuePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
var nStr: string;
begin
  if not gPopedomManager.HasPopedom(sPopedom_Edit, PopedomItem) then Exit;
  //修改权限控制

  if EditValue.Properties.ReadOnly then
       nStr := '是否要手动输入皮重?'
  else nStr := '是否要自动读取磅重?';

  if QueryDlg(nStr, sAsk, Handle) then
    EditValue.Properties.ReadOnly := not EditValue.Properties.ReadOnly;
  //xxxxx
end;

//Desc: 散装算净重
procedure TfFormBangFangP.EditValuePropertiesEditValueChanged(
  Sender: TObject);
var nStr: string;
    nVal: Double;
begin
  if ListTruck.Items.Count > 0 then
   if IsNumber(EditValue.Text, True) and (StrToFloat(EditValue.Text) > 0) then
    with gTrucks[Integer(ListTruck.Items[0].Data)] do
    if FIsLading and (FStockType = sFlag_San) and (FLading <> sFlag_TiHuo) then
    begin
      nVal := StrToFloat(EditValue.Text);
      gInfo.FTruckNetW := GetNetWeight(FTruckID, nVal , False);

      nStr := '车辆:[ %s ] 毛重:[ %.2f ] 净重:[ %.2f ]';
      dxGroup2.Caption := Format(nStr, [EditTruck.Text, nVal, gInfo.FTruckNetW]);
    end else
    begin
      gInfo.FTruckNetW := 0;
      dxGroup2.Caption := '车辆列表';
     end;
end;

//Desc: 验证数据
function TfFormBangFangP.OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean;
var nStr: string;
    i,nIdx,nD,nS: integer;
begin
  Result := True;

  if Sender = EditValue then
  begin
    Result := IsNumber(EditValue.Text, True) and
              (StrToFloat(EditValue.Text) > 0);
    nHint := '请输入有效的重量';
  end else

  if Sender = EditTruck then
  begin
    Result := (EditTruck.ItemIndex > -1) and (ListTruck.Items.Count > 0);
    nHint := '请选择有效的车辆';
    if not Result then Exit;

    Result := gTrucks[0].FIsLading or (not IsTruckIn(EditTruck.Text));
    nHint := '该车提货中,请稍后';
  end;

  if Sender <> ListTruck then Exit;
  if gTrucks[0].FIsLading or (gTrucks[0].FLading <> sFlag_TiHuo) then Exit;
  //已进厂或送货车辆不用判定合车

  nS := 0;
  nD := 0;
  //袋,散计数
  
  for i:=ListTruck.Items.Count - 1 downto 0 do
  if ListTruck.Items[i].Checked then
  begin
    nIdx := Integer(ListTruck.Items[i].Data);
    if gTrucks[nIdx].FStockType = sFlag_San then
         Inc(nS)
    else Inc(nD);
  end;

  Result := nS + nD > 0;
  nHint := '请选择要称重的车辆';
  if not Result then Exit;

  Result := not ((nS > 0) and (nD > 0));
  nHint := '袋、散不能混合装车';
  if not Result then Exit;

  Result := nS < 2;
  nHint := '散灰不能合车提货';
  if not Result then Exit;

  nStr := Format('您选择了[ %d ]张提货单,确定要合车提货吗?', [nD]);
  Result := (nD < 2) or QueryDlg(nStr, sAsk);
  nHint := '请重新选择';
end;

//Desc: 保存新数据
procedure TfFormBangFangP.SaveNewWeightData;
var i,nIdx: integer;
    nTrucks: TDynamicTruckArray;
begin
  for nIdx:=Low(gTrucks) to High(gTrucks) do
    gTrucks[nIdx].FIsCombine := False;
  //等待合并

  for i:=ListTruck.Items.Count - 1 downto 0 do
  if ListTruck.Items[i].Checked then
  begin
    nIdx := Integer(ListTruck.Items[i].Data);
    gTrucks[nIdx].FIsCombine := True;
  end;

  CombinTruckItems(gTrucks, nTrucks);
  //待进厂车辆

  for nIdx:=Low(nTrucks) to High(nTrucks) do
    nTrucks[nIdx].FSelect := True;
  //xxxxx
  
  MakeTrucksIn(nTrucks);
  MakeTruckBFP(nTrucks[0], StrToFloat(EditValue.Text));
end;

//Desc: 自提处理
function TfFormBangFangP.UpdateTiHuo(const nTruck: TLadingTruckItem): Boolean;
begin
  Result := True;
  FDM.ADOConn.BeginTrans;
  try
    if nTruck.FIsLading then
         MakeTruckBFP(nTruck, StrToFloat(EditValue.Text))
    else SaveNewWeightData;
    FDM.ADOConn.CommitTrans;
  except
    Result := False;
    FDM.ADOConn.RollbackTrans;
    ShowMsg('称量皮重失败', sError);
  end;
end;

//Desc: 验证送货散装吨数是否有效
function TfFormBangFangP.IsSanWeightValid: Boolean;
var nInt: Integer;
    nVal,nNet: Double;
    nP: TFormCommandParam;
begin
  Result := False;
  with gTrucks[Integer(ListTruck.Items[0].Data)] do
  begin
    nNet := gInfo.FTruckNetW;
    gInfo.FNetWeight := nNet;
    //净重

    if nNet <= 0 then
    begin
      EditValue.SetFocus;
      ShowMsg('净重为0不符合常识吧..!', sHint); Exit;
    end;

    nVal := GetValidMoneyByZK(gInfo.FZhiKa, gInfo.FZKMoney);
    nVal := nVal + FPrice * FValue;
    //可用金

    if FPrice > 0 then
         nVal := nVal / FPrice
    else nVal := 0;
    //可提货量

    Result := FloatRelation(nVal, nNet, rtGE, cPrecision);
    if not Result then
    begin
      gInfo.FNetWeight := nVal;
      nInt := Integer(ListTruck.Items[0].Data);

      nP.FCommand := cCmd_EditData;
      nP.FParamA := gTrucks[nInt].FBill;
      nP.FParamB := gTrucks[nInt].FTruckNo;
      nP.FParamC := nNet - nVal;
      nP.FParamD := Integer(gHKItems);

      CreateBaseFormItem(cFI_FormSanHeKa, '', @nP);
      Result := (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOk);
    end;
  end;
end;

//Desc: 保存散装送货到数据库
procedure TfFormBangFangP.UpdateSanWeightData(const nTruck: TLadingTruckItem);
var nStr: string;
    nVal: Double;
begin
  MakeTruckBFP(nTruck, StrToFloat(EditValue.Text));
  //xxxxx

  with nTruck do
  begin
    nStr := 'Update %s Set L_Value=%.2f Where L_ID=''%s''';
    nStr := Format(nStr, [sTable_Bill, gInfo.FNetWeight, FBill]);
    FDM.ExecuteSQL(nStr);

    nStr := 'Update %s Set E_Value=%.2f Where E_ID=%s';
    nStr := Format(nStr, [sTable_TruckLogExt, gInfo.FNetWeight, FRecord]);
    FDM.ExecuteSQL(nStr);

    nVal := FPrice * FValue;
    nVal := FPrice * gInfo.FNetWeight - nVal;

    nStr := 'Update %s Set A_FreezeMoney=A_FreezeMoney+(%.2f) ' +
            'Where A_CID=''%s''';
    nStr := Format(nStr, [sTable_CusAccount, nVal, FCusID]);
    FDM.ExecuteSQL(nStr);

    if gInfo.FZKMoney then
    begin
      nStr := 'Update %s Set Z_FixedMoney=Z_FixedMoney-(%.2f) ' +
              'Where Z_ID=''%s''';
      nStr := Format(nStr, [sTable_ZhiKa, nVal, gInfo.FZhiKa]);
      FDM.ExecuteSQL(nStr);
    end;
  end;
end;

//Desc: 保存散装送货
function TfFormBangFangP.UpdateSanSongH(const nTruck: TLadingTruckItem): Boolean;
var nStr: string;
    nIdx: Integer;
    nTrucks: TDynamicTruckArray;
begin
  gHKItems.Clear;
  Result := IsSanWeightValid;
  if not Result then Exit;
  
  FDM.ADOConn.BeginTrans;
  try
    UpdateSanWeightData(nTruck);
    SaveSanHKData(gHKItems);

    LoadLadingTruckItems(gInfo.FCard, '', sFlag_TruckOut, nTrucks, nStr, False);
    //该卡上所有要出厂车辆列表
    MakeTrucksOut(nTrucks, nTruck.FTruckID);

    FDM.ADOConn.CommitTrans;
    Result := True;
  except
    Result := False;
    FDM.ADOConn.RollbackTrans;
    ShowMsg('称量皮重失败', sError); Exit;
  end;

  nStr := '';
  for nIdx:=Low(nTrucks) to High(nTrucks) do
    nStr := nStr + nTrucks[nIdx].FRecord + ',';
  //xxxxx

  if nStr <> '' then
  begin
    System.Delete(nStr, Length(nStr), 1);
    PrintPoundReport(nStr, True);
  end;
end;

//Desc: 保存
procedure TfFormBangFangP.BtnOKClick(Sender: TObject);
var nIdx: Integer;
    nBool: Boolean;
begin
  if IsDataValid then
  begin
    nIdx := Integer(ListTruck.Items[0].Data);
    if IsTruckSongHuo(gTrucks[nIdx]) then
         nBool := UpdateSanSongH(gTrucks[nIdx])
    else nBool := UpdateTiHuo(gTrucks[nIdx]);

    if nBool then
    begin
      ModalResult := mrOk;
      ShowMsg('称量皮重成功', sHint);
    end;
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormBangFangP, TfFormBangFangP.FormID);
  gHKItems := TList.Create;
finalization
  gHKItems.Free;
end.

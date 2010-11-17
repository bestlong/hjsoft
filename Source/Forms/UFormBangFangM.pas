{*******************************************************************************
  作者: dmzn@163.com 2010-3-14
  描述: 磅房称量毛重
*******************************************************************************}
unit UFormBangFangM;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFormNormal, USysBusiness, ComCtrls, cxGraphics, cxDropDownEdit,
  cxMaskEdit, cxButtonEdit, cxEdit, cxTextEdit, cxListView, cxContainer,
  cxMCListBox, dxLayoutControl, StdCtrls, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters;

type
  TfFormBangFangM = class(TfFormNormal)
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
    procedure BtnOKClick(Sender: TObject);
    procedure BtnGetClick(Sender: TObject);
    procedure EditValuePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
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
    function IsWeightValid: Boolean;
    //重量有效
    procedure UpdateWeightData(const nTruck: TLadingTruckItem);
    //保存数据
    function UpdateTiHuo(const nTruck: TLadingTruckItem): Boolean;
    function UpdateSanSongH(const nTruck: TLadingTruckItem): Boolean;
    //散装送货
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
    FCusID: string;
    FCusName: string;
    FZKMoney: Boolean;
    FTruckIdx: Integer; //索引
    FNetWeight: Double; //提货净重
    FTruckNetW: Double; //车辆净重
  end; 

var
  gInfo: TCommonInfo;
  gHKItems: TList;
  gTrucks: TDynamicTruckArray;
  //全局使用

//------------------------------------------------------------------------------
class function TfFormBangFangM.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nStr: string;
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

  if not LoadLadingTruckItems(gInfo.FCard, sFlag_TruckBFM, sFlag_TruckBFM,
     gTrucks, nStr, False) then
  begin
    nStr := '磅房没有找到适合称量毛重的车辆,详情如下:' + #13#10 + #13#10 +
            AdjustHintToRead(nStr);
    ShowDlg(nStr, sHint); Exit;
  end;

  with TfFormBangFangM.Create(Application) do
  begin
    Caption := '称量毛重';
    PopedomItem := nPopedom;

    InitFormData(gInfo.FZhiKa);
    ShowModal;
    Free;
  end;
end;

class function TfFormBangFangM.FormID: integer;
begin
  Result := cFI_FormBangFangM;
end;

procedure TfFormBangFangM.FormCreate(Sender: TObject);
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

procedure TfFormBangFangM.FormClose(Sender: TObject;
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
procedure TfFormBangFangM.InitFormData(const nID: string);
var nStr: string;
    nDB: TDataSet;
begin
  gHKItems.Clear;
  nDB := LoadZhiKaInfo(nID, ListInfo, nStr);

  if Assigned(nDB) then
  begin
    gInfo.FCusID := nDB.FieldByName('Z_Custom').AsString;
    gInfo.FCusName := nDB.FieldByName('C_Name').AsString;
  end else
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
procedure TfFormBangFangM.LoadTruckList;
var nIdx: Integer;
begin
  EditTruck.Clear;
  for nIdx:=Low(gTrucks) to High(gTrucks) do
   if EditTruck.Properties.Items.IndexOf(gTrucks[nIdx].FTruckNo) < 0 then
    EditTruck.Properties.Items.Add(gTrucks[nIdx].FTruckNo);
  if EditTruck.Properties.Items.Count > 0 then EditTruck.ItemIndex := 0;
end;

//Desc: 载入nTruck对应的提货单
procedure TfFormBangFangM.LoadLadingList(const nTruck: string);
var i,nIdx: Integer;
begin
  nIdx := ListTruck.ItemIndex;
  ListTruck.Items.BeginUpdate;
  try
    ListTruck.Clear;
    ListTruck.Checkboxes := False;
    ListTruck.SmallImages := FDM.ImageBar;
                                  
    for i:=Low(gTrucks) to High(gTrucks) do
    if gTrucks[i].FTruckNo = nTruck then
    with ListTruck.Items.Add, gTrucks[i] do
    begin
      Caption := FBill;
      SubItems.Add(FStockName);
      SubItems.Add(FTruckNo);
      SubItems.Add(Format('%.2f', [FValue]));

      ImageIndex := cItemIconIndex;
      Data := Pointer(i);
    end;
  finally
    if nIdx < ListTruck.Items.Count then
      ListTruck.ItemIndex := nIdx;
    ListTruck.Items.EndUpdate;
  end;
end;

//Desc: 同步提货单
procedure TfFormBangFangM.EditTruckPropertiesChange(Sender: TObject);
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
procedure TfFormBangFangM.BtnGetClick(Sender: TObject);
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
procedure TfFormBangFangM.EditValuePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
var nStr: string;
begin
  if not gPopedomManager.HasPopedom(PopedomItem, sPopedom_Edit) then Exit;
  //修改权限控制

  if EditValue.Properties.ReadOnly then
       nStr := '是否要手动输入毛重?'
  else nStr := '是否要自动读取磅重?';

  if QueryDlg(nStr, sAsk, Handle) then
    EditValue.Properties.ReadOnly := not EditValue.Properties.ReadOnly;
  //xxxxx
end;

//Desc: 更新净重
procedure TfFormBangFangM.EditValuePropertiesEditValueChanged(
  Sender: TObject);
var nStr: string;
    nVal: Double;
begin
  if ListTruck.Items.Count > 0 then
   if IsNumber(EditValue.Text, True) and (StrToFloat(EditValue.Text) > 0) then
    with gTrucks[Integer(ListTruck.Items[0].Data)] do
    if (FStockType = sFlag_Dai) or (FLading = sFlag_TiHuo) then
    begin
      nVal := StrToFloat(EditValue.Text);
      gInfo.FTruckNetW := GetNetWeight(FTruckID, nVal);

      nStr := '车辆:[ %s ] 皮重:[ %.2f ] 净重:[ %.2f ]';
      dxGroup2.Caption := Format(nStr, [EditTruck.Text, nVal, gInfo.FTruckNetW]);
    end else
    begin
      gInfo.FTruckNetW := 0;
      dxGroup2.Caption := '车辆列表';
     end;
end;

//Desc: 验证重量是否在有效范围
function TfFormBangFangM.IsWeightValid: Boolean;
var nStr: string;
    nInt: Integer;
    nP: TFormCommandParam;
    nVal,nNet,nBill,nTmp: Double;
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

    if FStockType = sFlag_Dai then
    begin
      nBill := 0;
      for nInt := ListTruck.Items.Count - 1 downto 0 do
        nBill := nBill + gTrucks[Integer(ListTruck.Items[nInt].Data)].FValue;
      //提货量

      nVal := GetWeightWuCha(nBill);
      //允许误差
      nTmp := (nBill - nNet) * 1000;
      if nTmp < 0 then nTmp := - nTmp;
      //提货误差
      Result := FloatRelation(nVal, nTmp, rtGE, cPrecision);

      if not Result  then
      begin
        nStr := '该车实际提货量与开票量误差较大,明细如下:' + #13#10#13#10 +
                '*.开票量: %.2f 吨' + #13#10 +
                '*.装车量: %.2f 吨' + #13#10 +
                '*.误差量: %.2f 公斤' + #13#10#13#10 +
                '系统允许误差为 %.2f 公斤,是否允许该车辆过磅?';
        nStr := Format(nStr, [nBill, nNet, nTmp, nVal]);
        Result := QueryDlg(nStr, sAsk, Handle);
      end;
    end else
    begin
      nVal := GetValidMoneyByZK(gInfo.FZhiKa, gInfo.FZKMoney);
      nVal := nVal + FPrice * FValue;
      //可用金

      if FPrice > 0 then
           nVal := nVal / FPrice
      else nVal := 0;
      //可提货量

      nVal := Float2Float(nVal, cPrecision);
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
end;

//Desc: 更新数据
procedure TfFormBangFangM.UpdateWeightData(const nTruck: TLadingTruckItem);
var nStr: string;
    nVal: Double;
begin
  MakeTruckBFM(nTruck, StrToFloat(EditValue.Text));
  //xxxxx

  with nTruck do
  begin
    if FStockType <> sFlag_San then Exit;
    //更新散装提货量和冻结资金

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
    nStr := Format(nStr, [sTable_CusAccount, nVal, gInfo.FCusID]);
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

//Desc: 保存自提
function TfFormBangFangM.UpdateTiHuo(const nTruck: TLadingTruckItem): Boolean;
var nStr: string;
    i,nIdx: Integer;
    nTrucks: TDynamicTruckArray;
begin
  gHKItems.Clear;
  Result := IsWeightValid;
  if not Result then Exit;

  FDM.ADOConn.BeginTrans;
  try
    UpdateWeightData(nTruck);
    SaveSanHKData(gHKItems);

    if IsTruckAutoOut then
    begin
      LoadLadingTruckItems(gInfo.FCard, '', sFlag_TruckOut, nTrucks, nStr, False);
      //待出厂所有车辆
      MakeTrucksOut(nTrucks, nTruck.FTruckID);
    end;
    FDM.ADOConn.CommitTrans;
  except
    Result := False;
    FDM.ADOConn.RollbackTrans;
    ShowMsg('称量毛重失败', sError); Exit;
  end;

  nStr := '';
  for i:=ListTruck.Items.Count - 1 downto 0 do
  begin
    nIdx := Integer(ListTruck.Items[0].Data);
    if gTrucks[nIdx].FStockType = sFlag_San then
      nStr := nStr + gTrucks[nIdx].FRecord + ',';
    //xxxxx
  end;

  for i:=gHKItems.Count - 1 downto 0 do
    nStr := nStr + PLadingTruckItem(gHKItems[i]).FRecord + ',';
  //xxxxx

  if nStr <> '' then
  begin
    System.Delete(nStr, Length(nStr), 1);
    PrintPoundReport(nStr, True);
  end;
end;

//Desc: 保存散装送货
function TfFormBangFangM.UpdateSanSongH(const nTruck: TLadingTruckItem): Boolean;
begin
  FDM.ADOConn.BeginTrans;
  try
    MakeTruckBFM(nTruck, StrToFloat(EditValue.Text));
    //xxxxx

    if IsTruckAutoOut then
      MakeSongHuoTruckOut(nTruck);
    //xxxxx

    FDM.ADOConn.CommitTrans;
    Result := True;
  except
    Result := False;
    FDM.ADOConn.RollbackTrans;
    ShowMsg('称量毛重失败', sError);
  end;
end;

//Desc: 验证数据
function TfFormBangFangM.OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean;
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
  end;
end;

//Desc: 保存
procedure TfFormBangFangM.BtnOKClick(Sender: TObject);
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
      ShowMsg('称量毛重成功', sHint);
    end;
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormBangFangM, TfFormBangFangM.FormID);
  gHKItems := TList.Create;
finalization
  gHKItems.Free;
end.

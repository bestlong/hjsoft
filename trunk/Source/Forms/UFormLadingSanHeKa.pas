{*******************************************************************************
  作者: dmzn@163.com 2010-3-17
  描述: 散装合卡
*******************************************************************************}
unit UFormLadingSanHeKa;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, cxGraphics, cxLabel, cxMemo, cxTextEdit,
  cxContainer, cxEdit, cxMaskEdit, cxDropDownEdit, dxLayoutControl,
  StdCtrls, cxControls, cxButtonEdit, cxMCListBox, ComCtrls, cxListView;

type
  TfFormSanHeKa = class(TfFormNormal)
    dxGroup2: TdxLayoutGroup;
    dxLayout1Item7: TdxLayoutItem;
    ListInfo: TcxMCListBox;
    ListBill: TcxListView;
    dxLayout1Item3: TdxLayoutItem;
    EditCard: TcxButtonEdit;
    dxLayout1Item4: TdxLayoutItem;
    EditValue: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    BtnAdd: TButton;
    dxLayout1Item8: TdxLayoutItem;
    BtnDel: TButton;
    dxLayout1Item9: TdxLayoutItem;
    dxLayout1Group3: TdxLayoutGroup;
    EditStock: TcxTextEdit;
    dxLayout1Item6: TdxLayoutItem;
    dxLayout1Group4: TdxLayoutGroup;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EditCardPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
  protected
    { Private declarations }
    function OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean; override;
    //基类方法
    procedure InitFormData;
    //载入数据
    procedure LoadBillList;
    //合卡列表
    procedure FillHKItems(const nList: TList);
    //合卡结果
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  DB, IniFiles, ULibFun, UFormBase, UMgrControl, UAdjustForm, UDataModule, 
  USysDB, USysConst, USysGrid, USysBusiness, UForminputbox;

type
  TCommonInfo = record
    FTruckID: string;
    FTruckNo: string;
    FZhiKa: string;
    FLadID: string;
    FCardNo: string;
    FType: string;
    FStock: string;
    FStockNo: string;
    FHKValue: Double;
    FHasValue: Double;
  end;

var
  gInfo: TCommonInfo;
  gActive: TLadingTruckItem;
  gItems: TDynamicTruckArray;
  //全局使用

//------------------------------------------------------------------------------
class function TfFormSanHeKa.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  if Assigned(nParam) then
       nP := nParam
  else Exit;

  with gInfo do
  begin
    FHasValue := 0;
    FLadID := nP.FParamA;
    FTruckNo := nP.FParamB;
    FHKValue := nP.FParamC;
  end;

  with TfFormSanHeKa.Create(Application) do
  begin
    Caption := '散装合卡 - 车辆: ' + gInfo.FTruckNo;
    InitFormData;

    nP.FCommand := cCmd_ModalResult;
    nP.FParamA := ShowModal;
    FillHKItems(TList(Integer(nP.FParamD)));
    Free;
  end;
end;

class function TfFormSanHeKa.FormID: integer;
begin
  Result := cFI_FormSanHeKa;
end;

procedure TfFormSanHeKa.FormCreate(Sender: TObject);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadFormConfig(Self, nIni);
    LoadMCListBoxConfig(Name, ListInfo, nIni);
    LoadcxListViewConfig(Name, ListBill, nIni);
  finally
    nIni.Free;
  end;
end;

procedure TfFormSanHeKa.FormClose(Sender: TObject;
  var Action: TCloseAction);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveFormConfig(Self, nIni);
    SaveMCListBoxConfig(Name, ListInfo, nIni);
    SavecxListViewConfig(Name, ListBill, nIni);
  finally
    nIni.Free;
  end;
end;

//------------------------------------------------------------------------------
//Desc: 初始化数据
procedure TfFormSanHeKa.InitFormData;
var nStr: string;
begin
  SetLength(gItems, 0);
  BtnOK.Enabled := False;
  BtnAdd.Enabled := False;
  ActiveControl := EditCard;

  nStr := 'Select * From $Bill b ' +
          ' Left Join $TE te on te.E_Bill=b.L_ID ' +
          'Where L_ID=''$LID''';
  nStr := MacroValue(nStr, [MI('$TE', sTable_TruckLogExt),
          MI('$Bill', sTable_Bill), MI('$LID', gInfo.FLadID)]);
  //xxxxx

  with FDM.QueryTemp(nStr),gInfo do
  if RecordCount > 0 then
  begin
    FTruckID := FieldByName('E_TID').AsString;
    FTruckNo := FieldByName('E_Truck').AsString;
    FZhiKa := FieldByName('L_ZID').AsString;
    FCardNo := FieldByName('L_Card').AsString;
    FType := FieldByName('L_Type').AsString;
    FStock := FieldByName('L_Stock').AsString;
    FStockNo := FieldByName('E_StockNo').AsString;

    BtnOK.Enabled := True;
    LoadBillList;
  end else ShowMsg('主卡信息丢失', sHint);
end;

//Desc: 载入合卡列表
procedure TfFormSanHeKa.LoadBillList;
var i,nIdx: Integer;
begin
  gInfo.FHasValue := 0;
  nIdx := ListBill.ItemIndex;
  ListBill.Items.BeginUpdate;
  try
    ListBill.Items.Clear;
    ListBill.SmallImages := FDM.ImageBar;

    for i:=Low(gItems) to High(gItems) do
    if gItems[i].FSelect then
    with ListBill.Items.Add do
    begin
      Caption := gItems[i].FZhiKa;
      SubItems.Add(gInfo.FStock);
      SubItems.Add(Format('%.2f', [gItems[i].FPrice]));
      SubItems.Add(Format('%.2f', [gItems[i].FValue]));

      Data := Pointer(i);
      ImageIndex := cItemIconIndex;
      gInfo.FHasValue := gInfo.FHasValue + gItems[i].FValue;
    end;               
  finally
    if nIdx < ListBill.Items.Count then
      ListBill.ItemIndex := nIdx;
    ListBill.Items.EndUpdate;

    dxGroup2.Caption := Format('合卡明细 已合:%.2f吨 剩余:%.2f吨',
                        [gInfo.FHasValue, gInfo.FHKValue - gInfo.FHasValue]);
    //xxxxx
  end;
end;

//Desc: 将合卡结果存入nList,不用手动释放
procedure TfFormSanHeKa.FillHKItems(const nList: TList);
var nIdx: Integer;
begin
  nList.Clear;
  for nIdx:=Low(gItems) to High(gItems) do
   if gItems[nIdx].FSelect then nList.Add(@gItems[nIdx]);
end;

//Desc: 获取磁卡信息
procedure TfFormSanHeKa.EditCardPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
var nStr: string;
    nVal: Double;
begin
  ListInfo.Clear;
  EditStock.Clear;
  EditValue.Text := '0';
  BtnAdd.Enabled := False;

  EditCard.Text := Trim(EditCard.Text);
  if EditCard.Text = '' then Exit;

  if not IsCardCanUsing(EditCard.Text, nStr, True) then
  begin
    nStr := '该磁卡暂时无法用于合卡,详情如下:' + #13#10#13#10 +
            AdjustHintToRead(nStr);
    ShowDlg(nStr, sHint, Handle); Exit;
  end;

  nStr := 'Select zk.*,zd.* from $ZK zk ' +
          ' Left Join $ZD zd on zd.D_ZID=zk.Z_ID ' +
          ' Left Join $ZC zc on zc.C_ZID=zk.Z_ID ' +
          'Where C_Card=''$Card'' and D_Type=''$Type'' and ' +
          ' D_Stock=''$Stock''';
  nStr := MacroValue(nStr, [MI('$ZK', sTable_ZhiKa),
          MI('$ZD', sTable_ZhiKaDtl), MI('$ZC', sTable_ZhiKaCard),
          MI('$Card', EditCard.Text), MI('$Type', gInfo.FType),
          MI('$Stock', gInfo.FStock)]);
  //xxxxx

  with FDM.QueryTemp(nStr),gActive do
  if RecordCount > 0 then
  begin
    FZhiKa := FieldByName('Z_ID').AsString;
    if CompareText(FZhiKa, gInfo.FZhiKa) = 0 then
    begin
      ShowMsg('主卡不可以合卡', sHint); Exit;
    end;

    FSaleMan := FieldByName('Z_SaleMan').AsString;
    FCusID := FieldByName('Z_Custom').AsString;
    FLading := FieldByName('Z_Lading').AsString;
    FPrice := FieldByName('D_Price').AsFloat;
    FMoney := GetValidMoneyByZK(FZhiKa, FZKMoney);

    if FPrice > 0 then
         FValue := StrToFloat(Format('%.2f', [FMoney / FPrice]))
    else FValue := 0;

    nStr := '品种:%s 单价:%.2f 有效吨数:%.2f';
    EditStock.Text := Format(nStr, [gInfo.FStock, FPrice, FValue]);

    nVal := gInfo.FHKValue - gInfo.FHasValue;
    if FValue < nVal then
         EditValue.Text := FloatToStr(FValue)
    else EditValue.Text := FloatToStr(nVal);

    if LoadZhiKaInfo(FZhiKa, ListInfo, nStr) <> nil then
    begin
      EditCard.SetFocus;
      BtnAdd.Enabled := True;
    end else ShowMsg(nStr, sHint);
  end else
  begin
    nStr := Format('该卡上没有[ %s ]的水泥品种.', [gInfo.FStock]);
    ShowDlg(nStr, sHint, Handle);
  end;
end;

//Desc: 添加
procedure TfFormSanHeKa.BtnAddClick(Sender: TObject);
var nInt: Integer;
begin
  for nInt:=Low(gItems) to High(gItems) do
  if gItems[nInt].FSelect and (gItems[nInt].FZhiKa = gActive.FZhiKa) then
  begin
    EditCard.SetFocus;
    ShowMsg('该卡已在列表中', sHint); Exit;
  end;

  if (not IsNumber(EditValue.Text, True)) or (StrToFloat(EditValue.Text) <= 0) then
  begin
    EditValue.SetFocus;
    ShowMsg('请输入有效的吨数', sHint); Exit;
  end;

  nInt := Float2PInt(StrToFloat(EditValue.Text), cPrecision);
  if nInt > Float2PInt(gActive.FValue, cPrecision) then
  begin
    EditValue.SetFocus;
    ShowDlg('已超出可合卡量', sHint); Exit;
  end;

  nInt := Length(gItems);
  SetLength(gItems, nInt + 1);
  CopyTruckItem(gActive, gItems[nInt]);

  with gItems[nInt] do
  begin
    FSelect := True;
    FTruckID := gInfo.FTruckID;
    FTruckNo := gInfo.FTruckNo;
    FCardNo := gInfo.FCardNo;

    FStockType := gInfo.FType;
    FStockName := gInfo.FStock;
    FStockNo := gInfo.FStockNo;
    FValue := StrToFloat(EditValue.Text);
  end;
  LoadBillList;
end;

//Desc: 删除选中项
procedure TfFormSanHeKa.BtnDelClick(Sender: TObject);
var nInt: Integer;
begin
  if ListBill.ItemIndex > -1 then
  begin
    nInt := Integer(ListBill.Items[ListBill.ItemIndex].Data);
    gItems[nInt].FSelect := False;
    LoadBillList;
  end;
end;

//Desc: 验证数据
function TfFormSanHeKa.OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean;
var nIdx: Integer;
begin
  Result := True;
  if Sender = EditCard then
  begin
    Result := gInfo.FHasValue = gInfo.FHKValue;
    nHint := '请合入足够的吨数';
    if not Result then Exit;

    for nIdx:=Low(gItems) to High(gItems) do
    with gItems[nIdx] do
    begin
      if not FSelect then Continue;
      Result := FMoney = GetValidMoneyByZK(FZhiKa, FZKMoney);

      if not Result then
      begin
        nHint := Format('磁卡[ %s ]的资金已发生变动,合卡操作被终止!!' + #13#10 +
                 '请退出后重试.', [FCardNo]);
        ShowDlg(nHint, sHint, Handle);
        nHint := ''; Exit;
      end;
    end;
  end;
end;

//Desc: 保存
procedure TfFormSanHeKa.BtnOKClick(Sender: TObject);
begin
  if IsDataValid then ModalResult := mrOk;
end;

initialization
  gControlManager.RegCtrl(TfFormSanHeKa, TfFormSanHeKa.FormID);
end.

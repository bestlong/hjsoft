{*******************************************************************************
  ����: dmzn@163.com 2010-3-15
  ����: �������
*******************************************************************************}
unit UFormBill;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, dxLayoutControl, StdCtrls, cxControls, cxContainer,
  cxMCListBox, ComCtrls, cxListView, cxEdit, cxTextEdit, cxGraphics,
  cxMaskEdit, cxDropDownEdit, cxLookAndFeels, cxLookAndFeelPainters;

type
  TfFormBill = class(TfFormNormal)
    dxGroup2: TdxLayoutGroup;
    dxLayout1Item3: TdxLayoutItem;
    ListInfo: TcxMCListBox;
    dxLayout1Item4: TdxLayoutItem;
    EditZK: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    EditCard: TcxTextEdit;
    dxLayout1Item6: TdxLayoutItem;
    dxLayout1Group2: TdxLayoutGroup;
    ListBill: TcxListView;
    EditValue: TcxTextEdit;
    dxLayout1Item8: TdxLayoutItem;
    dxLayout1Group3: TdxLayoutGroup;
    EditTruck: TcxTextEdit;
    dxLayout1Item9: TdxLayoutItem;
    EditStock: TcxComboBox;
    dxLayout1Item7: TdxLayoutItem;
    dxLayout1Group4: TdxLayoutGroup;
    BtnAdd: TButton;
    dxLayout1Item10: TdxLayoutItem;
    BtnDel: TButton;
    dxLayout1Item11: TdxLayoutItem;
    EditLading: TcxComboBox;
    dxLayout1Item12: TdxLayoutItem;
    dxLayout1Group5: TdxLayoutGroup;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EditStockPropertiesChange(Sender: TObject);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure ListBillAdvancedCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; Stage: TCustomDrawStage;
      var DefaultDraw: Boolean);
    procedure BtnOKClick(Sender: TObject);
    procedure EditLadingKeyPress(Sender: TObject; var Key: Char);
  protected
    { Protected declarations }
    FShowPrice: Boolean;
    //��ʾ����
    function OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean; override;
    procedure LoadFormData;
    procedure LoadStockList;
    //��������
    function IsCreditValid(const nCusID,nCusName: string): Boolean;
    //��֤����
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  DB, IniFiles, ULibFun, UMgrControl, UAdjustForm, UFormBase, USysConst,
  USysDB, USysGrid, USysBusiness, UDataModule, USysPopedom;

type
  TCommonInfo = record
    FZhiKa: string;
    FCusID: string;
    FCusName: string;
    FSaleMan: string;
    FCardNo: string;
    FTruckNo: string;
    FMoney: Double;
    FIDList: string;
    FOnlyMoney: Boolean;
    FPriceChanged: Boolean;
  end;

  TStockItem = record
    FType: string;
    FStock: string;
    FTruck: string;
    FPrice: Double;
    FValue: Double;
    FValid: Boolean;
    FLading: string;
    FSelecte: Boolean;
  end;

var
  gInfo: TCommonInfo;
  gStockList: array of TStockItem;
  //ȫ��ʹ��
  
//------------------------------------------------------------------------------
//Desc: ��֤�������
function VerifySingBill: Boolean;
var nStr,nTmp,nVal,nHint: string;
begin
  Result := True;
  if GetSingleBillSetting(nVal) and (nVal <> '') then
  begin
    nTmp := '';
    nHint := '';
  end else Exit;
  
  if Pos('+ST', nVal) > 0 then
  begin
    nHint := '����';
    nTmp := Format('L_TruckNo=''%s''', [gInfo.FTruckNo]);
  end;

  if Pos('+SC', nVal) > 0 then
  begin
    nHint := '����' + nHint;
    nStr := Format('L_Card=''%s''', [gInfo.FCardNo]);

    if nTmp = '' then
         nTmp := nStr
    else nTmp := nTmp + ' And ' + nStr;
  end;

  if nTmp = '' then Exit;
  //invalid setting

  nStr := 'Select * From %s Where (%s) And ' +
          'IsNull(L_IsDone,'''')<>''%s'' Order By L_ID';
  nStr := Format(nStr, [sTable_Bill, nTmp, sFlag_Yes]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    nStr := '';
    First;

    while not Eof do
    begin
      nTmp := '����:��%s��Ʒ��:��%s������:��%s�������:%.2f��';
      nTmp := nTmp + #32#32#13#10;

      nTmp := Format(nTmp, [FieldByName('L_ID').AsString,
              StrWithWidth(FieldByName('L_Stock').AsString, 16, 3),
              StrWithWidth(FieldByName('L_TruckNo').AsString, 8, 3),
              FieldByName('L_Value').AsFloat]);
      //xxxxx

      nStr := nStr + nTmp;
      Next;
    end;

    nStr := '����ԱҪ��' + nHint + '��ֻ�ܿ�һ�������,�ѿ�δ��ƾ֤����:' +
            #13#10#13#10 + AdjustHintToRead(nStr) + #13#10 +
            '�Ƿ�������������?';
    Result := QueryDlg(nStr, sHint);
  end;
end;

class function TfFormBill.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nBool: Boolean;
    nP: PFormCommandParam;
begin
  Result := nil;
  if not Assigned(nParam) then
  begin
    New(nP);
    FillChar(nP^, SizeOf(TFormCommandParam), #0);
  end else nP := nParam;

  try
    CreateBaseFormItem(cFI_FormVerifyCardPwd, '', nP);
    if (nP.FCommand <> cCmd_ModalResult) or (nP.FParamA <> mrOK) then Exit;

    with gInfo do
    begin
      FCardNo := nP.FParamB;
      FZhiKa := nP.FParamC;
      FTruckNo := nP.FParamD;
    end;
  finally
    if not Assigned(nParam) then Dispose(nP);
  end;

  if not VerifySingBill then Exit;
  //sing truck single bill

  with TfFormBill.Create(Application) do
  try
    LoadFormData;
    //try load data

    if BtnOK.Enabled then
    begin
      Caption := '�������';
      EditCard.Text := gInfo.FCardNo;
      EditZK.Text := gInfo.FZhiKa;

      nBool := not gPopedomManager.HasPopedom(nPopedom, sPopedom_Edit);
      EditLading.Properties.ReadOnly := nBool;

      if Assigned(nParam) then
      with PFormCommandParam(nParam)^ do
      begin
        FCommand := cCmd_ModalResult;
        FParamA := ShowModal;

        if FParamA = mrOK then
             FParamB := gInfo.FIDList
        else FParamB := '';
      end else ShowModal;
    end; //may be data invalid
  finally
    Free;
  end;
end;

class function TfFormBill.FormID: integer;
begin
  Result := cFI_FormBill;
end;

procedure TfFormBill.FormCreate(Sender: TObject);
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

  AdjustCtrlData(Self);
end;

procedure TfFormBill.FormClose(Sender: TObject; var Action: TCloseAction);
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

  ReleaseCtrlData(Self);
end;

//Desc: �س���
procedure TfFormBill.EditLadingKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = Char(VK_RETURN) then
  begin
    Key := #0;
    Perform(WM_NEXTDLGCTL, 0, 0);
  end;
end;

//------------------------------------------------------------------------------
//Desc: �����������
procedure TfFormBill.LoadFormData;
var nStr,nTmp: string;
    nDB: TDataSet;
    nIdx: integer;
begin
  BtnOK.Enabled := False;
  nDB := LoadZhiKaInfo(gInfo.FZhiKa, ListInfo, nStr);

  if Assigned(nDB) then
  with gInfo do
  begin
    FCusID := nDB.FieldByName('Z_Custom').AsString;
    FCusName := nDB.FieldByName('C_Name').AsString;
    FSaleMan := nDB.FieldByName('Z_SaleMan').AsString;

    FPriceChanged := nDB.FieldByName('Z_TJStatus').AsString = sFlag_TJOver;
    SetCtrlData(EditLading, nDB.FieldByName('Z_Lading').AsString);
    FMoney := GetValidMoneyByZK(gInfo.FZhiKa, gInfo.FOnlyMoney);
  end else
  begin
    ShowMsg(nStr, sHint); Exit;
  end;

  BtnOK.Enabled := IsCreditValid(gInfo.FCusID, gInfo.FCusName);
  if not BtnOK.Enabled then Exit;
  //to verify credit

  SetLength(gStockList, 0);
  nStr := 'Select * From %s Where D_ZID=''%s''';
  nStr := Format(nStr, [sTable_ZhiKaDtl, gInfo.FZhiKa]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    SetLength(gStockList, RecordCount);
    nStr := '';
    nIdx := 0;
    First;

    while not Eof do
    with gStockList[nIdx] do
    begin
      FType := FieldByName('D_Type').AsString;
      FStock := FieldByName('D_Stock').AsString;
      FPrice := FieldByName('D_Price').AsFloat;

      FValue := 0;
      FValid := True;
      FSelecte := False;
      FTruck := gInfo.FTruckNo;

      if gInfo.FPriceChanged then
      begin
        nTmp := 'Ʒ��:[ %-8s ] ԭ��:[ %.2f ] �ּ�:[ %.2f ]' + #32#32;
        nTmp := Format(nTmp, [FStock, FieldByName('D_PPrice').AsFloat, FPrice]);
        nStr := nStr + nTmp + #13#10;
      end;

      Inc(nIdx);
      Next;
    end;
  end else
  begin
    nStr := Format('ֽ��[ %s ]û�п����ˮ��Ʒ��,����ֹ.', [gInfo.FZhiKa]);
    ShowDlg(nStr, sHint);
    BtnOK.Enabled := False; Exit;
  end;

  if gInfo.FPriceChanged then
  begin
    nStr := '����Ա�ѵ���ֽ��[ %s ]�ļ۸�,��ϸ����: ' + #13#10#13#10 +
            AdjustHintToRead(nStr) + #13#10 +
            '��ѯ�ʿͻ��Ƿ�����µ���,���ܵ�"��"��ť.' ;
    nStr := Format(nStr, [gInfo.FZhiKa]);
    
    BtnOK.Enabled := QueryDlg(nStr, sHint);
    if not BtnOK.Enabled then Exit;

    nStr := 'Update %s Set Z_TJStatus=Null Where Z_ID=''%s''';
    nStr := Format(nStr, [sTable_ZhiKa, gInfo.FZhiKa]);
    FDM.ExecuteSQL(nStr);
  end;

  FShowPrice := ShowPriceWhenBill;
  LoadStockList;
  //load stock into window
end;

//Desc: ˢ��ˮ���б�����
procedure TfFormBill.LoadStockList;
var nStr: string;
    i,nIdx: integer;
begin
  AdjustCXComboBoxItem(EditStock, True);
  nIdx := ListBill.ItemIndex;

  ListBill.Items.BeginUpdate;
  try
    ListBill.Clear;
    for i:=Low(gStockList) to High(gStockList) do
    if gStockList[i].FSelecte then
    begin
      with ListBill.Items.Add do
      begin
        Caption := gStockList[i].FStock;
        SubItems.Add(gStockList[i].FTruck);
        SubItems.Add(FloatToStr(gStockList[i].FValue));

        Data := Pointer(i);
        ImageIndex := cItemIconIndex;
      end;
    end else
    begin
      nStr := Format('%d=%s', [i, gStockList[i].FStock]); 
      EditStock.Properties.Items.Add(nStr);
    end;
  finally
    ListBill.Items.EndUpdate;
    if ListBill.Items.Count > nIdx then
      ListBill.ItemIndex := nIdx;
    //xxxxx

    AdjustCXComboBoxItem(EditStock, False);
    EditStock.ItemIndex := 0;
  end;
end;

//Desc: ��֤�ͻ������Ƿ���Ч
function TfFormBill.IsCreditValid(const nCusID,nCusName: string): Boolean;
var nStr,nSQL: string;
begin
  Result := GetCustomerValidMoney(nCusID, False) > 0;
  if Result then Exit;

  nSQL := 'Select Top 1 C_End From %s Where C_CusID=''%s'' and C_Money>=0 ' +
          'Order By C_Date DESC';
  nSQL := Format(nSQL, [sTable_CusCredit, nCusID]);

  nStr := 'Select Count(*) From (%s) t Where C_End>%s';
  nSQL := Format(nStr, [nSQL, FDM.SQLServerNow]);

  Result := FDM.QueryTemp(nSQL).Fields[0].AsInteger > 0;
  if not Result then 
  begin
    nStr := Format('�ͻ�[ %s ]�ʽ�����������ѹ���.', [nCusName]);
    ShowDlg(nStr, sHint);
  end;
end;

procedure TfFormBill.ListBillAdvancedCustomDrawItem(
  Sender: TCustomListView; Item: TListItem; State: TCustomDrawState;
  Stage: TCustomDrawStage; var DefaultDraw: Boolean);
var nIdx: Integer;
begin
  nIdx := Integer(Item.Data);
  if not gStockList[nIdx].FValid then
  with Sender.Canvas.Font do
  begin
    Color := clRed;
    Style := Style + [fsBold];
  end;
end;

//Dessc: ѡ��Ʒ��
procedure TfFormBill.EditStockPropertiesChange(Sender: TObject);
var nInt: Int64;
begin
  dxGroup2.Caption := '�ᵥ��ϸ';
  if EditStock.ItemIndex < 0 then Exit;

  with gStockList[StrToInt(GetCtrlData(EditStock))] do
  begin
    EditTruck.Text := FTruck;
    if FPrice > 0 then
    begin
      nInt := Float2PInt(gInfo.FMoney / FPrice, cPrecision, False);
      EditValue.Text := FloatToStr(nInt / cPrecision);

      if FShowPrice then
        dxGroup2.Caption := Format('�ᵥ��ϸ ����:%.2fԪ/��', [FPrice]);
      //xxxxx
    end;
  end;
end;

function TfFormBill.OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean;
var nVal: Double;
begin
  Result := True;

  if Sender = EditStock then
  begin
    Result := EditStock.ItemIndex > -1;
    nHint := '��ѡ��ˮ������';
  end else

  if Sender = EditTruck then
  begin
    Result := Length(EditTruck.Text) > 2;
    nHint := '���ƺų���Ӧ����2λ';
  end else

  if Sender = EditLading then
  begin
    Result := EditLading.ItemIndex > -1;
    nHint := '��ѡ����Ч�������ʽ';
  end;

  if Sender = EditValue then
  begin
    Result := IsNumber(EditValue.Text, True) and (StrToFloat(EditValue.Text)>0);
    nHint := '����д��Ч�İ�����';

    if not Result then Exit;
    if not OnVerifyCtrl(EditStock, nHint) then Exit;

    with gStockList[StrToInt(GetCtrlData(EditStock))] do
    if FPrice > 0 then
    begin
      nVal := StrToFloat(EditValue.Text);
      Result := FloatRelation(gInfo.FMoney / FPrice, nVal, rtGE, cPrecision);
      nHint := '�ѳ����ɰ�����';
    end else
    begin
      Result := False;
      nHint := '����[ 0 ]��Ч';
    end;
  end;
end;

//Desc: ���
procedure TfFormBill.BtnAddClick(Sender: TObject);
var nIdx: Integer;
begin
  if IsDataValid then
  begin
    nIdx := StrToInt(GetCtrlData(EditStock));
    with gStockList[nIdx] do
    begin
      FTruck := Trim(EditTruck.Text);
      FValue := StrToFloat(EditValue.Text);
      FLading := GetCtrlData(EditLading);

      FValid := True;
      FSelecte := True;
      gInfo.FMoney := gInfo.FMoney - FPrice * FValue;
    end;

    LoadStockList;
    {if EditStock.Properties.Items.Count > 0 then
         EditStock.SetFocus
    else }BtnOK.SetFocus;
  end;
end;

//Desc: ɾ��
procedure TfFormBill.BtnDelClick(Sender: TObject);
var nIdx: integer;
begin
  if ListBill.ItemIndex > -1 then
  begin
    nIdx := Integer(ListBill.Items[ListBill.ItemIndex].Data);
    with gStockList[nIdx] do
    begin
      FSelecte := False;
      gInfo.FMoney := gInfo.FMoney + FPrice * FValue;
    end;
    LoadStockList;
  end;
end;

//Desc: ����
procedure TfFormBill.BtnOKClick(Sender: TObject);
var nVal: Double;
    nIdx,nInt: Integer;
    nStr,nSQL,nTmp: string;
begin
  if ListBill.Items.Count < 1 then
  begin
    ShowMsg('���Ȱ��������', sHint); Exit;
  end;

  gInfo.FIDList := '';
  nVal := GetValidMoneyByZK(gInfo.FZhiKa, gInfo.FOnlyMoney);
  //now valid

  for nIdx:=Low(gStockList) to High(gStockList) do
  with gStockList[nIdx] do
  if FSelecte then
  begin
    FValid := FloatRelation(nVal, FPrice * FValue, rtGE, cPrecision);
    nVal := nVal - Float2Float(FPrice * FValue, cPrecision, True);
  end;
  //check money

  gInfo.FMoney := nVal;
  //adjust money

  if nVal < 0 then
  begin
    LoadStockList;
    ShowMsg('�ͻ��ʽ�����', sHint); Exit;
  end else nVal := 0;

  //----------------------------------------------------------------------------
  FDM.ADOConn.BeginTrans;
  try                                                                           
    nStr := 'Insert Into $Bill(L_ZID,L_Custom,L_SaleMan,L_TruckNo,L_Type,' +
            'L_Stock,L_Value,L_Price,L_ZKMoney,L_Card,L_Lading,L_IsDone,L_Man,' +
            'L_Date) Values(''$ZID'',''$Cus'',''$SM'',''$TN'',''$TP'',' +
            '''$ST'',$Val,$PR,''$ZKM'',''$Card'',''$LA'',''$NO'',''$LM'',$LD)';
    nStr := MacroValue(nStr, [MI('$Bill', sTable_Bill), MI('$NO', sFlag_No),
            MI('$Card', gInfo.FCardNo),
            MI('$LM', gSysParam.FUserID), MI('$Cus', gInfo.FCusID),
            MI('$SM', gInfo.FSaleMan), MI('$ZID', gInfo.FZhiKa)]);
    //xxxxx

    if gInfo.FOnlyMoney then
         nStr := MacroValue(nStr, [MI('$ZKM', sFlag_Yes)])
    else nStr := MacroValue(nStr, [MI('$ZKM', sFlag_No)]);

    for nIdx:=Low(gStockList) to High(gStockList) do
    with gStockList[nIdx] do
    if FSelecte then
    begin
      nSQL := MacroValue(nStr, [MI('$TN', FTruck), MI('$TP', FType),
              MI('$ST', FStock), MI('$Val', Format('%.2f', [FValue])),
              MI('$PR', FloatToStr(FPrice)),
              MI('$LA', FLading), MI('$LD', FDM.SQLServerNow)]);
      FDM.ExecuteSQL(nSQL);

      nInt := FDM.GetFieldMax(sTable_Bill, 'R_ID');
      nTmp := FDM.GetSerialID2('Th', sTable_Bill, 'R_ID', 'L_ID', nInt);

      nSQL := 'Update %s Set L_ID=''%s'' Where R_ID=%d';
      nSQL := Format(nSQL, [sTable_Bill, nTmp, nInt]);
      FDM.ExecuteSQL(nSQL);

      if gInfo.FIDList = '' then
           gInfo.FIDList := IntToStr(nInt)
      else gInfo.FIDList := gInfo.FIDList + ',' + IntToStr(nInt);

      nVal := nVal + FPrice * FValue;
      //freeze money
    end;
    //save lading

    nVal := Float2Float(nVal, cPrecision, True);
    //adjust float value

    nStr := 'Update %s Set A_FreezeMoney=A_FreezeMoney+%.2f Where A_CID=''%s''';
    nStr := Format(nStr, [sTable_CusAccount, nVal, gInfo.FCusID]);
    FDM.ExecuteSQL(nStr);
    //freeze money from account

    if gInfo.FOnlyMoney then
    begin
      nStr := 'Update %s Set Z_FixedMoney=Z_FixedMoney-%.2f Where Z_ID=''%s''';
      nStr := Format(nStr, [sTable_ZhiKa, nVal, gInfo.FZhiKa]);
      FDM.ExecuteSQL(nStr);
    end;
    //freeze money from zhika

    FDM.ADOConn.CommitTrans;
  except
    FDM.ADOConn.RollbackTrans;
    ShowMsg('���������ʧ��', sError); Exit;
  end;

  if gInfo.FIDList <> '' then
    PrintBillReport(gInfo.FIDList, True);
  //print report
  
  ModalResult := mrOk;
  ShowMsg('���������ɹ�', sHint);
end;

initialization
  gControlManager.RegCtrl(TfFormBill, TfFormBill.FormID);
end.

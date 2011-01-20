{*******************************************************************************
  ����: dmzn@163.com 2009-6-12
  ����: ���ۺ�ͬ����
*******************************************************************************}
unit UFormSaleContract;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UDataModule, cxGraphics, dxLayoutControl, cxButtonEdit, StdCtrls,
  cxMaskEdit, cxDropDownEdit, cxMCListBox, cxMemo, cxContainer, cxEdit,
  cxTextEdit, cxControls, cxCalendar, cxCheckBox, UFormBase, cxLabel,
  cxLookAndFeels, cxLookAndFeelPainters;

type
  TfFormSaleContract = class(TBaseForm)
    dxLayoutControl1Group_Root: TdxLayoutGroup;
    dxLayoutControl1: TdxLayoutControl;
    dxLayoutControl1Group1: TdxLayoutGroup;
    EditMemo: TcxMemo;
    dxLayoutControl1Item4: TdxLayoutItem;
    BtnOK: TButton;
    dxLayoutControl1Item10: TdxLayoutItem;
    BtnExit: TButton;
    dxLayoutControl1Item11: TdxLayoutItem;
    dxLayoutControl1Group5: TdxLayoutGroup;
    EditID: TcxButtonEdit;
    dxLayoutControl1Item1: TdxLayoutItem;
    dxLayoutControl1Group9: TdxLayoutGroup;
    dxLayoutControl1Group2: TdxLayoutGroup;
    dxLayoutControl1Group4: TdxLayoutGroup;
    StockList1: TcxMCListBox;
    dxLayoutControl1Item3: TdxLayoutItem;
    EditSalesMan: TcxComboBox;
    dxLayoutControl1Item5: TdxLayoutItem;
    cxTextEdit1: TcxTextEdit;
    dxLayoutControl1Item2: TdxLayoutItem;
    EditCustomer: TcxComboBox;
    dxLayoutControl1Item6: TdxLayoutItem;
    cxTextEdit2: TcxTextEdit;
    dxLayoutControl1Item7: TdxLayoutItem;
    cxTextEdit3: TcxTextEdit;
    dxLayoutControl1Item9: TdxLayoutItem;
    EditPayment: TcxComboBox;
    dxLayoutControl1Item12: TdxLayoutItem;
    cxTextEdit4: TcxTextEdit;
    dxLayoutControl1Item13: TdxLayoutItem;
    dxLayoutControl1Group3: TdxLayoutGroup;
    dxLayoutControl1Group6: TdxLayoutGroup;
    dxLayoutControl1Group7: TdxLayoutGroup;
    EditName: TcxTextEdit;
    dxLayoutControl1Item14: TdxLayoutItem;
    EditMoney: TcxTextEdit;
    dxLayoutControl1Item15: TdxLayoutItem;
    EditPrice: TcxTextEdit;
    dxLayoutControl1Item16: TdxLayoutItem;
    EditValue: TcxTextEdit;
    dxLayoutControl1Item17: TdxLayoutItem;
    dxLayoutControl1Group8: TdxLayoutGroup;
    EditDate: TcxButtonEdit;
    dxLayoutControl1Item19: TdxLayoutItem;
    cxButtonEdit1: TcxButtonEdit;
    dxLayoutControl1Item8: TdxLayoutItem;
    dxLayoutControl1Group10: TdxLayoutGroup;
    Check1: TcxCheckBox;
    dxLayoutControl1Item18: TdxLayoutItem;
    EditDays: TcxTextEdit;
    dxLayoutControl1Item20: TdxLayoutItem;
    cxLabel1: TcxLabel;
    dxLayoutControl1Item21: TdxLayoutItem;
    dxLayoutControl1Group11: TdxLayoutGroup;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EditIDPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnOKClick(Sender: TObject);
    procedure BtnExitClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditDatePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure StockList1Click(Sender: TObject);
    procedure EditValueExit(Sender: TObject);
    procedure cxButtonEdit1PropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure EditSalesManKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditSalesManPropertiesEditValueChanged(Sender: TObject);
  private
    { Private declarations }
    FContractID: string;
    //��ͬ��ʶ
    FPrefixID: string;
    //ǰ׺���
    FIDLength: integer;
    //ǰ׺����
    procedure InitFormData(const nID: string);
    //��������
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

procedure PrintSaleContractReport(const nID: string; const nAsk: Boolean);
//��ں���

implementation

{$R *.dfm}
uses
  DB, IniFiles, ULibFun, UFormCtrl, UAdjustForm, UMgrControl, UFormBaseInfo,
  USysGrid, USysDB, USysConst, UDataReport;

var
  gForm: TfFormSaleContract = nil;
  //ȫ��ʹ��

class function TfFormSaleContract.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  if Assigned(nParam) then
       nP := nParam
  else Exit;

  case nP.FCommand of
   cCmd_AddData:
    with TfFormSaleContract.Create(Application) do
    begin
      FContractID := '';
      Caption := '��ͬ - ����';

      InitFormData('');
      nP.FCommand := cCmd_ModalResult;
      nP.FParamA := ShowModal;
      Free;
    end;
   cCmd_EditData:
    with TfFormSaleContract.Create(Application) do
    begin
      FContractID := nP.FParamA;
      Caption := '��ͬ - �޸�';

      InitFormData(FContractID);
      nP.FCommand := cCmd_ModalResult;
      nP.FParamA := ShowModal;
      Free;
    end;
   cCmd_ViewData:
    begin
      if not Assigned(gForm) then
      begin
        gForm := TfFormSaleContract.Create(Application);
        with gForm do
        begin
          Caption := '��ͬ - �鿴';
          FormStyle := fsStayOnTop;
          BtnOK.Visible := False;
        end;
      end;

      with gForm  do
      begin
        FContractID := nP.FParamA;
        InitFormData(FContractID);
        if not Showing then Show;
      end;
    end;
   cCmd_FormClose:
    begin
      if Assigned(gForm) then FreeAndNil(gForm);
    end;
  end;
end;

class function TfFormSaleContract.FormID: integer;
begin
  Result := cFI_FormSaleContract;
end;

//Desc: ��ӡ��ʶΪnID�����ۺ�ͬ
procedure PrintSaleContractReport(const nID: string; const nAsk: Boolean);
var nStr: string;
    nParam: TReportParamItem;
begin
  if nAsk then
  begin
    nStr := '�Ƿ�Ҫ��ӡ��Ӧ��ͬ?';
    if not QueryDlg(nStr, sAsk) then Exit;
  end;

  nStr := 'Select sc.*,S_Name,C_Name From $SC sc ' +
          '  Left Join ' +
          '   (Select S_ID,S_Name From $SM) sm On sm.S_ID=sc.C_SaleMan ' +
          '  Left Join ' +
          '   (Select C_ID,C_Name From $Cus) cus On cus.C_ID=sc.C_Customer ' +
          'Where sc.C_ID=''$ID''';

  nStr := MacroValue(nStr, [MI('$SC', sTable_SaleContract),
          MI('$SM', sTable_Salesman), MI('$Cus', sTable_Customer),
          MI('$ID', nID)]);

  if FDM.QueryTemp(nStr).RecordCount <> 1 then
  begin
    nStr := '���Ϊ[ %s] �����ۺ�ͬ����Ч!!';
    nStr := Format(nStr, [nID]);
    ShowMsg(nStr, sHint); Exit;
  end;

  nStr := 'Select * From %s Where E_CID=''%s''';
  nStr := Format(nStr, [sTable_SContractExt, nID]);
  FDM.QuerySQL(nStr);

  nStr := gPath + sReportDir + 'SaleContract.fr3';
  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '�޷���ȷ���ر����ļ�';
    ShowMsg(nStr, sHint); Exit;
  end;

  nParam.FName := 'UserName';
  nParam.FValue := gSysParam.FUserID;
  FDR.AddParamItem(nParam);

  FDR.Dataset1.DataSet := FDM.SqlTemp;
  FDR.Dataset2.DataSet := FDM.SqlQuery;
  FDR.ShowReport;
end;

//------------------------------------------------------------------------------
procedure TfFormSaleContract.FormCreate(Sender: TObject);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadFormConfig(Self, nIni);
    LoadMCListBoxConfig(Name, StockList1, nIni);

    FPrefixID := nIni.ReadString(Name, 'IDPrefix', 'HT');
    FIDLength := nIni.ReadInteger(Name, 'IDLength', 8);
  finally
    nIni.Free;
  end;

  EditDate.Text := DateTimeToStr(Now);
  ResetHintAllForm(Self, 'T', sTable_SaleContract);
  //���ñ�����
end;

procedure TfFormSaleContract.FormClose(Sender: TObject;
  var Action: TCloseAction);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveFormConfig(Self, nIni);
    SaveMCListBoxConfig(Name, StockList1, nIni);
  finally
    nIni.Free;
  end;

  gForm := nil;
  Action := caFree;
  ReleaseCtrlData(Self);
end;

procedure TfFormSaleContract.BtnExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfFormSaleContract.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if Key = VK_ESCAPE then
  begin
    Key := 0; Close;
  end;
end;

//------------------------------------------------------------------------------
//Desc: ��nDS��������nStockList�������ݺϲ�
procedure LoadStockList(const nDS: TDataSet; const nStockList: TcxMCListBox);
var nList: TStrings;
    i,nCount: integer;
begin
  nList := TStringList.Create;
  try
    nCount := nStockList.Items.Count - 1;
    for i:=0 to nCount do
    begin
      SplitStr(nStockList.Items[i], nList, 0, nStockList.Delimiter);
      if nList.Count > 1 then
      begin
        nStockList.Items[i] := CombinStr([nList[0], nList[1],
                               '0', '0', '0', '0'], nStockList.Delimiter);
      end else Continue;

      if nDS.RecordCount < 1 then
           Continue
      else nDS.First;
      
      while not nDS.Eof do
      begin
        if nDS.FieldByName('E_Stock').AsString = nList[1] then
        begin
          nStockList.Items[i] := CombinStr([nList[0], nList[1],
                  nDS.FieldByName('E_Value').AsString,
                  nDS.FieldByName('E_Price').AsString,
                  nDS.FieldByName('E_Money').AsString,
                  nDS.FieldByName('E_Price').AsString], nStockList.Delimiter);
          Break;
        end;
        nDS.Next;
      end;
    end;
  finally
    nList.Free;
  end;
end;

//Date: 2009-6-2
//Parm: ��Ӧ�̱��
//Desc: ����nID��Ӧ�̵���Ϣ������
procedure TfFormSaleContract.InitFormData(const nID: string);
var nStr: string;
    nArray: TDynamicStrArray;
begin
  if EditPayment.Properties.Items.Count < 1 then
  begin
    EditPayment.Clear;
    nStr := MacroValue(sQuery_SysDict, [MI('$Table', sTable_SysDict),
                                        MI('$Name', sFlag_PaymentItem)]);
    //�����ֵ��и��ʽ��Ϣ��

    with FDM.QueryTemp(nStr) do
    if RecordCount > 0 then
    begin
      First;

      while not Eof do
      begin
        EditPayment.Properties.Items.Add(FieldByName('D_Value').AsString);
        Next;
      end;
    end;
  end;

  if EditSalesMan.Properties.Items.Count < 1 then
  begin
    nStr := 'S_ID=Select S_ID,S_PY,S_Name From %s ' +
            'Where S_InValid<>''%s'' Order By S_PY';
    nStr := Format(nStr, [sTable_Salesman, sFlag_Yes]);

    SetLength(nArray, 1);
    nArray[0] := 'S_ID';
    FDM.FillStringsData(EditSalesMan.Properties.Items, nStr, -1, '.', nArray);
    AdjustStringsItem(EditSalesMan.Properties.Items, False);
  end;

  if StockList1.Items.Count < 1 then
  begin
    nStr := MacroValue(sQuery_SysDict, [MI('$Table', sTable_SysDict),
                                        MI('$Name', sFlag_StockItem)]);
    with FDM.QueryTemp(nStr) do
    if RecordCount > 0 then
    begin
      First;

      while not Eof do
      begin
        nStr := CombinStr([FieldByName('D_Memo').AsString,
                FieldByName('D_Value').AsString,
                '0', '0', '0', '0'], StockList1.Delimiter);
        StockList1.Items.Add(nStr);
        Next;
      end;
    end;
  end;

  if nID <> '' then
  begin
    nStr := 'Select * From %s Where C_ID=''%s''';
    nStr := Format(nStr, [sTable_SaleContract, nID]);

    LoadDataToCtrl(FDM.QuerySQL(nStr), Self);
    Check1.Checked := FDM.SqlQuery.FieldByName('C_XuNi').AsString = sFlag_Yes;

    nStr := 'Select * From %s Where E_CID=''%s''';
    nStr := Format(nStr, [sTable_SContractExt, nID]);
    LoadStockList(FDM.QueryTemp(nStr), StockList1);
  end;
end;

//Desc: ҵ��Ա���,��ȡ��ؿͻ�
procedure TfFormSaleContract.EditSalesManPropertiesEditValueChanged(
  Sender: TObject);
var nStr: string;
begin
  if EditSalesMan.ItemIndex > -1 then
  begin
    AdjustCXComboBoxItem(EditCustomer, True);
    nStr := 'C_ID=Select C_ID,C_Name From %s Where C_SaleMan=''%s''';
    nStr := Format(nStr, [sTable_Customer, GetCtrlData(EditSalesMan)]);

    FDM.FillStringsData(EditCustomer.Properties.Items, nStr, -1, '.');
    AdjustCXComboBoxItem(EditCustomer, False);
  end;
end;

//Desc: ����������
procedure TfFormSaleContract.EditIDPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  EditID.Text := FDM.GetSerialID(FPrefixID, sTable_SaleContract, 'C_ID');
end;

//Desc: ��ǰʱ��
procedure TfFormSaleContract.EditDatePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  TcxButtonEdit(Sender).Text := DateTimeToStr(Now);
end;

//Desc: ѡ������
procedure TfFormSaleContract.cxButtonEdit1PropertiesButtonClick(
  Sender: TObject; AButtonIndex: Integer);
var nBool,nSelected: Boolean;
begin
  nBool := True;
  nSelected := True;

  with ShowBaseInfoEditForm(nBool, nSelected, '����', '', sFlag_AreaItem) do
  begin
    if nSelected then TcxButtonEdit(Sender).Text := FText;
  end;
end;

//Desc: ���ٶ�λ
procedure TfFormSaleContract.EditSalesManKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var i,nCount: integer;
    nBox: TcxComboBox;
begin
  if Key = 13 then
  begin
    Key := 0;
    nBox := Sender as TcxComboBox;

    nCount := nBox.Properties.Items.Count - 1;
    for i:=0 to nCount do
    if Pos(LowerCase(nBox.Text), LowerCase(nBox.Properties.Items[i])) > 0 then
    begin
      nBox.ItemIndex := i; Break;
    end;
  end;
end;

//Desc: ��ʾ��ϸ����
procedure TfFormSaleContract.StockList1Click(Sender: TObject);
var nStr: string;
    nList: TStrings;
begin
  if StockList1.ItemIndex < 0 then
       Exit
  else nList := TStringList.Create;

  try
    nStr := StockList1.Items[StockList1.ItemIndex];
    if SplitStr(nStr, nList, 6, StockList1.Delimiter) then
    begin
      EditName.Text := nList[1];
      EditValue.Text := nList[2];
      EditPrice.Text := nList[3];
      EditMoney.Text := nList[4];

      EditValue.SetFocus;
    end;
  finally
    nList.Free;
  end;
end;

//Desc: �뿪����ʱȷ������
procedure TfFormSaleContract.EditValueExit(Sender: TObject);
var nStr: string;
    nList: TStrings;
begin
  if (StockList1.ItemIndex < 0) or (not (Sender is TcxTextEdit)) then Exit;
  if not TcxTextEdit(Sender).EditModified then Exit;

  nList := TStringList.Create;
  try
    nStr := StockList1.Items[StockList1.ItemIndex];
    if SplitStr(nStr, nList, 6, StockList1.Delimiter) then
    begin
      if not IsNumber(EditValue.Text, True) then EditValue.Text := '0';
      if not IsNumber(EditPrice.Text, True) then EditPrice.Text := '0';

      if Sender <> EditMoney then
        EditMoney.Text := FloatToStr(StrToFloat(EditValue.Text) *
                                     StrToFloat(EditPrice.Text));
      if not IsNumber(EditMoney.Text, True) then EditMoney.Text := '0';

      nList[2] := EditValue.Text;
      nList[3] := EditPrice.Text;
      nList[4] := EditMoney.Text;

      nStr := StockList1.Delimiter;
      StockList1.Items[StockList1.ItemIndex] := CombinStr(nList, nStr);
    end;
  finally
    nList.Free;
  end;
end;

//Desc: ��������
procedure TfFormSaleContract.BtnOKClick(Sender: TObject);
var nList: TStrings;
    nStr,nSQL: string;
    i,nCount: integer;
begin
  EditID.Text := Trim(EditID.Text);
  if EditID.Text = '' then
  begin
    EditID.SetFocus;
    ShowMsg('����д��Ч�ĺ�ͬ���', sHint); Exit;
  end;

  if (not IsNumber(EditDays.Text, False)) Or (StrToInt(EditDays.Text) < 0 ) then
  begin
    EditDays.SetFocus;
    ShowMsg('����д��Ч��ʱ��', sHint); Exit;
  end;

  nList := TStringList.Create;
  try
    if Check1.Checked then
         nStr := 'C_XuNi=''$Y'''
    else nStr := 'C_XuNi=''$N''';
    nList.Text := MacroValue(nStr, [MI('$Y', sFlag_Yes), MI('$N', sFlag_No)]); 

    if FContractID = '' then
    begin
      nStr := 'Select Count(*) From %s Where C_ID=''%s''';
      nStr := Format(nStr, [sTable_SaleContract, EditID.Text]);
      //��ѯ����Ƿ����

      with FDM.QueryTemp(nStr) do
       if Fields[0].AsInteger > 0 then
       begin
         nList.Free;
         EditID.SetFocus;
         ShowMsg('�ñ�ŵĺ�ͬ�Ѿ�����', sHint); Exit;
       end;

       nSQL := MakeSQLByForm(Self, sTable_SaleContract, '', True, nil, nList);
    end else
    begin
      EditID.Text := FContractID;
      nStr := 'C_ID=''' + FContractID + '''';
      nSQL := MakeSQLByForm(Self, sTable_SaleContract, nStr, False, nil, nList);
    end;

    FDM.ADOConn.BeginTrans;
    FDM.ExecuteSQL(nSQL);

    if FContractID <> '' then
    begin
      nSQL := 'Delete From %s Where E_CID=''%s''';
      nSQL := Format(nSQL, [sTable_SContractExt, FContractID]);
      FDM.ExecuteSQL(nSQL);
    end;

    nSQL := 'Insert Into $Table(E_CID, E_Type, E_Stock, E_Value, E_Price,' +
            'E_Money) Values(''$ID'', ''%s'', ''%s'', %s, %s, %s)';
    nSQL := MacroValue(nSQL, [MI('$Table', sTable_SContractExt),
                              MI('$ID', EditID.Text)]); 
    nCount := StockList1.Items.Count - 1;

    for i:=0 to nCount do
    if SplitStr(StockList1.Items[i], nList, 6, StockList1.Delimiter) then
    begin
      if nList[2] = '0' then Continue;
      //����Ϊ0���豣��

      nStr := Format(nSQL, [nList[0], nList[1], nList[2], nList[3], nList[4]]);
      FDM.ExecuteSQL(nStr);

      if (FContractID <> '') and (nList[3] <> nList[5]) and (nList[5] <> '0') then
      begin
        nStr := 'Ʒ��[ %s ]������[ %s ] ��Ϊ[ %s ]';
        nStr := Format(nStr, [nList[1], nList[5], nList[3]]);
        FDM.WriteSysLog(sFlag_ContractItem, EditID.Text, nStr, False);
      end;
    end;

    nList.Free;
    FDM.ADOConn.CommitTrans;
    PrintSaleContractReport(EditID.Text, True);

    ModalResult := mrOK;
    ShowMsg('�����ѱ���', sHint);
  except
    nList.Free;
    FDM.ADOConn.RollbackTrans;
    ShowMsg('���ݱ���ʧ��', 'δ֪ԭ��');
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormSaleContract, TfFormSaleContract.FormID);
end.
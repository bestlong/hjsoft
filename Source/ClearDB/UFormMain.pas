{*******************************************************************************
  ����: dmzn@163.com 2010-9-19
  ����: ����Ԫ
*******************************************************************************}
unit UFormMain;

{$I Link.inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UTrayIcon, UDataModule, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, Menus, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, DB, cxDBData, ADODB,
  StdCtrls, ExtCtrls, dxStatusBar, cxGridLevel, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxClasses, cxGridCustomView, cxGrid,
  cxButtons, cxTextEdit, cxLabel, cxGroupBox, cxPC, cxMaskEdit,
  cxButtonEdit, cxCheckBox;

type
  TfFormMain = class(TForm)
    wPage: TcxPageControl;
    SheetWeek: TcxTabSheet;
    SheetSale: TcxTabSheet;
    SBar1: TdxStatusBar;
    HintPanel: TPanel;
    Image1: TImage;
    Image2: TImage;
    HintLabel: TLabel;
    cxGroupBox1: TcxGroupBox;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
    cxLabel5: TcxLabel;
    EditLocalDB: TcxTextEdit;
    EditLocalHost: TcxTextEdit;
    EditLocalPort: TcxTextEdit;
    EditLocalUser: TcxTextEdit;
    EditLocalPwd: TcxTextEdit;
    BtnConn: TcxButton;
    cxLevel1: TcxGridLevel;
    cxGrid1: TcxGrid;
    SQLQuery: TADOQuery;
    cxView1: TcxGridDBTableView;
    DataSource1: TDataSource;
    cxView1Column1: TcxGridDBColumn;
    cxView1Column2: TcxGridDBColumn;
    cxView1Column3: TcxGridDBColumn;
    cxView1Column4: TcxGridDBColumn;
    cxView1Column5: TcxGridDBColumn;
    cxGroupBox2: TcxGroupBox;
    cxLabel6: TcxLabel;
    EditCus: TcxTextEdit;
    cxGrid2: TcxGrid;
    cxLevel2: TcxGridLevel;
    cxView2: TcxGridTableView;
    PMenu1: TPopupMenu;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    cxView2Column1: TcxGridColumn;
    cxView2Column2: TcxGridColumn;
    cxView2Column3: TcxGridColumn;
    cxView2Column4: TcxGridColumn;
    cxView2Column5: TcxGridColumn;
    cxView2Column6: TcxGridColumn;
    cxView2Column7: TcxGridColumn;
    cxView2Column8: TcxGridColumn;
    cxView2Column9: TcxGridColumn;
    Check1: TcxCheckBox;
    EditDate: TcxButtonEdit;
    cxLabel7: TcxLabel;
    BtnQuery: TcxButton;
    cxButton2: TcxButton;
    cxGroupBox3: TcxGroupBox;
    BtnSelect: TcxButton;
    cxButton4: TcxButton;
    cxButton5: TcxButton;
    BtnDelete: TcxButton;
    BtnZZ: TcxButton;
    cxView2Column10: TcxGridColumn;
    cxView2Column11: TcxGridColumn;
    LabelWeek1: TcxLabel;
    cxView2Column12: TcxGridColumn;
    SheetProvide: TcxTabSheet;
    cxGroupBox4: TcxGroupBox;
    cxLabel8: TcxLabel;
    EditProvider: TcxTextEdit;
    Check2: TcxCheckBox;
    EditDate2: TcxButtonEdit;
    cxLabel9: TcxLabel;
    BtnQProvide: TcxButton;
    cxButton3: TcxButton;
    cxGroupBox5: TcxGroupBox;
    BtnPSelect: TcxButton;
    cxButton7: TcxButton;
    cxButton8: TcxButton;
    BtnPDelete: TcxButton;
    BtnPZZ: TcxButton;
    LabelWeek2: TcxLabel;
    cxGrid3: TcxGrid;
    cxView3: TcxGridTableView;
    cxGridColumn1: TcxGridColumn;
    cxGridColumn2: TcxGridColumn;
    cxGridColumn3: TcxGridColumn;
    cxGridColumn4: TcxGridColumn;
    cxGridColumn5: TcxGridColumn;
    cxGridColumn6: TcxGridColumn;
    cxGridColumn7: TcxGridColumn;
    cxGridColumn8: TcxGridColumn;
    cxLevel3: TcxGridLevel;
    PMenu2: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnConnClick(Sender: TObject);
    procedure ADOConnLocalConnectComplete(Connection: TADOConnection;
      const Error: Error; var EventStatus: TEventStatus);
    procedure ADOConnLocalDisconnect(Connection: TADOConnection;
      var EventStatus: TEventStatus);
    procedure N4Click(Sender: TObject);
    procedure PMenu1Popup(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure cxButtonEdit1PropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnQueryClick(Sender: TObject);
    procedure BtnSelectClick(Sender: TObject);
    procedure BtnDeleteClick(Sender: TObject);
    procedure BtnZZClick(Sender: TObject);
    procedure BtnQProvideClick(Sender: TObject);
    procedure BtnPSelectClick(Sender: TObject);
    procedure EditDate2PropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnPDeleteClick(Sender: TObject);
    procedure BtnPZZClick(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
  private
    { Private declarations }
    FTrayIcon: TTrayIcon;
    //״̬��
    FLastQCtrl: TObject;
    FLastPQCtrl: TObject;
    //��ѯ����
    FStart,FEnd: TDate;
    FStartP,FEndP: TDate;
    //ʱ������
    FNowWeek,FWeekName: string;
    //��ǰ����
  protected
    procedure FormLoadConfig;
    procedure FormSaveConfig;
    //������Ϣ
    procedure SetHintText(const nLabel: TLabel);
    //��ʾ��Ϣ
    procedure EnableCtrl(const nConnected: Boolean);
    //�������
    procedure LoadWeek;
    //ˢ������
    function IsValidBackupDB: Boolean;
    //�Ƿ񱸷ݿ�
  public
    { Public declarations }
  end;

var
  fFormMain: TfFormMain;

implementation

{$R *.dfm}
uses
  IniFiles, UcxChinese, ULibFun, USysConst, USysDB, ULocalFun, UFormBase,
  UFormInvoiceWeek, UFormDateFilter, UFormProvide, USysBusiness;

type
  PLadingItem = ^TLadingItem;
  TLadingItem = record
    FChecked: Boolean;
    FRecordID: string;
    FTruckID: string;
    FBillID: string;
    FBillRID: string;
    FWeek: string;
    FSaler: string;
    FCusNo: string;
    FCusName: string;
    FStock: string;
    FStockType: string;
    FTruck: string;
    FValue: Double;
    FPrice: Double;
    FTime: TDateTime;
  end;

  TLadingItems = class(TcxCustomDataSource)
  private
    FOwner: TfFormMain;
    FDataList: TList;
  protected
    procedure ClearData(const nFree: Boolean);
    //������Դ
    function GetRecordCount: Integer; override;
    function GetValue(ARecordHandle: TcxDataRecordHandle;
     AItemHandle: TcxDataItemHandle): Variant; override;
    procedure SetValue(ARecordHandle: TcxDataRecordHandle;
     AItemHandle: TcxDataItemHandle; const AValue: Variant); override;
     //��д����
  public
    constructor Create(AOwner: TfFormMain);
    destructor Destroy; override;
    //�����ͷ�
    procedure LoadLadingData;
    //��ȡ�ͻ�
    property LadingData: TList read FDataList;
    //�������
  end;

  TProvideItems = class(TcxCustomDataSource)
  private
    FOwner: TfFormMain;
    FDataList: TList;
  protected
    procedure ClearData(const nFree: Boolean);
    //������Դ
    function GetRecordCount: Integer; override;
    function GetValue(ARecordHandle: TcxDataRecordHandle;
     AItemHandle: TcxDataItemHandle): Variant; override;
    procedure SetValue(ARecordHandle: TcxDataRecordHandle;
     AItemHandle: TcxDataItemHandle; const AValue: Variant); override;
     //��д����
  public
    constructor Create(AOwner: TfFormMain);
    destructor Destroy; override;
    //�����ͷ�
    procedure LoadProvideData;
    //��ȡ�ͻ�
    property ProvideData: TList read FDataList;
    //�������
  end;

var
  gLadingData: TLadingItems = nil;
  gProvideData: TProvideItems = nil;
  //ȫ��ʹ��

//------------------------------------------------------------------------------
//Date: 2007-10-15
//Parm: ��ǩ
//Desc: ��nLabel����ʾ��ʾ��Ϣ
procedure TfFormMain.SetHintText(const nLabel: TLabel);
begin
  nLabel.Font.Color := clWhite;
  //nLabel.Font.Size := 18;
  nLabel.Font.Style := nLabel.Font.Style + [fsBold];

  nLabel.Caption := gLocalParam.FHintText;
  nLabel.Left := 8;           
  //nLabel.Top := (HintPanel.Height + nLabel.Height - 12) div 2;
end;

procedure TfFormMain.FormLoadConfig;
begin
  with gLocalParam do
  begin
    EditLocalDB.Text := FLocalDB;
    EditLocalHost.Text := FLocalHost;
    EditLocalPort.Text := IntToStr(FLocalPort);
    EditLocalUser.Text := FLocalUser;
    EditLocalPwd.Text := FLocalPwd;
  end;

  InitTableView(Name, cxView1);
  InitTableView(Name, cxView2);
  InitTableView(Name, cxView3);
  cxView2.OptionsBehavior.ImmediateEditor := True;
  TcxCustomEditProperties(cxView2Column1.Properties).ReadOnly := False;
  cxView3.OptionsBehavior.ImmediateEditor := True;
  TcxCustomEditProperties(cxGridColumn1.Properties).ReadOnly := False;
  //��ʼ����ͷ

  gLadingData := TLadingItems.Create(Self);
  cxView2.DataController.CustomDataSource := gLadingData;
  gProvideData := TProvideItems.Create(Self);
  cxView3.DataController.CustomDataSource := gProvideData;

  LoadFormConfig(Self);
  InitDateRange(Name, FStart, FEnd);
  InitDateRange(Name + '_P', FStartP, FEndP);
end;

procedure TfFormMain.FormSaveConfig;
begin
  SaveUserDefineTableView(Name, cxView1);
  SaveUserDefineTableView(Name, cxView2);
  SaveUserDefineTableView(Name, cxView3);
  //�����ͷ

  SaveFormConfig(Self);
  SaveDateRange(Name, FStart, FEnd);
  SaveDateRange(Name + '_P', FStartP, FEndP);

  AdminDBParam(False);
  gLadingData.Free;
  gProvideData.Free;
end;

procedure TfFormMain.FormCreate(Sender: TObject);
var nStr: string;
begin
  InitSystemEnvironment;
  LoadSysParameter;
  
  Application.Title := gLocalParam.FAppTitle;
  InitGlobalVariant(gPath, gPath + sConfigFile, gPath + sFormConfig);

  nStr := GetFileVersionStr(Application.ExeName);
  if nStr <> '' then
  begin
    nStr := Copy(nStr, 1, Pos('.', nStr) - 1);
    Caption := gLocalParam.FMainTitle + ' V' + nStr;
  end else Caption := gLocalParam.FMainTitle;

  FTrayIcon := TTrayIcon.Create(Self);
  FTrayIcon.Hint := gLocalParam.FAppTitle;
  FTrayIcon.Visible := True;
  //��������

  with FDM do
  begin
    SQLQuery.Connection := ADOConn;
    ADOConn.OnConnectComplete := ADOConnLocalConnectComplete;
    ADOConn.OnDisconnect := ADOConnLocalDisconnect;
  end;

  wPage.ActivePageIndex := 0;
  SetHintText(HintLabel);
  EnableCtrl(False);
  
  FormLoadConfig;
  //��������
end;

procedure TfFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  {$IFNDEF debug}
  if not QueryDlg(sCloseQuery, sHint) then
  begin
    Action := caNone; Exit;
  end;
  {$ENDIF}

  Sleep(520);
  FormSaveConfig;
end;

procedure TfFormMain.ADOConnLocalConnectComplete(
  Connection: TADOConnection; const Error: Error;
  var EventStatus: TEventStatus);
begin
  EnableCtrl(Connection.Connected);
end;

procedure TfFormMain.ADOConnLocalDisconnect(Connection: TADOConnection;
  var EventStatus: TEventStatus);
begin
  EnableCtrl(Connection.Connected);
end;

//Desc: �������ݿ�
procedure TfFormMain.BtnConnClick(Sender: TObject);
begin
  with gLocalParam do
  begin
    FLocalDB := EditLocalDB.Text;
    FLocalHost := EditLocalHost.Text;

    if IsNumber(EditLocalPort.Text, False) then
      FLocalPort := StrToInt(EditLocalPort.Text);
    FLocalUser := EditLocalUser.Text;
    FLocalPwd := EditLocalPwd.Text;
  end;

  with FDM do
  try
    ADOConn.Connected := False;
    ADOConn.ConnectionString := MakeDBConnection(gLocalParam);
    ADOConn.Connected := True;

    if not IsValidBackupDB then
      raise Exception.Create('��Ч�ı������ݿ�');
    LoadWeek;
  except
    on E:Exception do
    begin
      ADOConn.Close;
      ShowDlg(E.Message, sHint, Handle);
    end;
  end;
end;

//Desc: ���ƽ������
procedure TfFormMain.EnableCtrl(const nConnected: Boolean);
var nIdx: Integer;
begin
  for nIdx:=ComponentCount - 1 downto 0 do
  begin
    if Components[nIdx] is TcxButton then
      TcxButton(Components[nIdx]).Enabled := nConnected;
    //xxxxx

    if Components[nIdx] is TcxButtonEdit then
      TcxButtonEdit(Components[nIdx]).Properties.Buttons[0].Enabled := nConnected;
    //xxxxx
  end;

  BtnConn.Enabled := not nConnected;
end;

//------------------------------------------------------------------------------
//Desc: ˢ������
procedure TfFormMain.LoadWeek;
var nStr: string;
begin
  nStr := 'Select * From %s Order By W_ID ASC';
  nStr := Format(nStr, [sTable_InvoiceWeek]);
  FDM.QueryData(SQLQuery, nStr);

  with SQLQuery do
  if RecordCount > 0 then
  begin
    First;

    while not Eof do
    begin
      if (Date() >= FieldByName('W_Begin').AsDateTime) and
         (Date() < FieldByName('W_End').AsDateTime) then
      begin
        FNowWeek := FieldByName('W_NO').AsString;
        FWeekName := FieldByName('W_Name').AsString;
        
        LabelWeek1.Caption := Format('����:[ %s ]', [FWeekName]); 
        LabelWeek2.Caption := LabelWeek1.Caption;
        Exit;
      end;

      Next;
    end;
  end;

  FNowWeek := '';
  LabelWeek1.Caption := '����:[ �� ]';
  LabelWeek2.Caption := LabelWeek1.Caption;
end;

//Desc: �Ƿ������ݿ�
function TfFormMain.IsValidBackupDB: Boolean;
var nStr: string;
begin
  nStr := 'Select Count(*) From $T Where D_Name=''$N'' and D_Memo=''$M''';
  nStr := MacroValue(nStr, [MI('$T', sTable_SysDict), MI('$N', sFlag_SysParam),
                           MI('$M', sFlag_EnableBakdb)]);
  //xxxxx

  with FDM.QueryTemp(nStr) do
  begin
    Result := Fields[0].AsInteger < 1;
  end;
end;

//Desc: �˵�����
procedure TfFormMain.PMenu1Popup(Sender: TObject);
var nIdx: Integer;
begin
  for nIdx:=PMenu1.Items.Count - 1 downto 0 do
    PMenu1.Items[nIdx].Enabled := FDM.ADOConn.Connected;
  //xxxxx
end;

//Desc: �������
procedure TfFormMain.N4Click(Sender: TObject);
var nParam: TFormCommandParam;
begin
  nParam.FCommand := cCmd_AddData;
  CreateBaseFormItem(cFI_FormInvoiceWeek, '', @nParam);

  if (nParam.FCommand = cCmd_ModalResult) and (nParam.FParamA = mrOK) then
    LoadWeek;
  //xxxxx
end;

//Desc: �޸�����
procedure TfFormMain.N6Click(Sender: TObject);
var nParam: TFormCommandParam;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('��ѡ��Ҫ�༭�ļ�¼', sHint); Exit;
  end;

  nParam.FCommand := cCmd_EditData;
  nParam.FParamA := SQLQuery.FieldByName('W_NO').AsString;
  CreateBaseFormItem(cFI_FormInvoiceWeek, '', @nParam);

  if (nParam.FCommand = cCmd_ModalResult) and (nParam.FParamA = mrOK) then
    LoadWeek;
  //xxxxx
end;

//Desc: ɾ������
procedure TfFormMain.N8Click(Sender: TObject);
var nStr,nID: string;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('��ѡ��Ҫɾ���ļ�¼', sHint); Exit;
  end;

  nID := SQLQuery.FieldByName('W_Name').AsString;
  nStr := Format('ȷ��Ҫɾ������Ϊ[ %s ]�ļ�¼��?', [nID]);
  if not QueryDlg(nStr, sAsk) then Exit;

  nID := SQLQuery.FieldByName('W_NO').AsString;
  nStr := 'Select Count(*) From %s Where E_HYNo=''%s''';
  nStr := Format(nStr, [sTable_TruckLogExt, nID]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    if Fields[0].AsInteger > 0 then
    begin
      nStr := '���������¼�ڱ���������,ɾ������ʧ��!';
      nStr := Format(nStr, [Fields[0].AsInteger]);
      ShowDlg(nStr, sHint); Exit;
    end;
  end else
  begin
    ShowMsg('��ȡ����״̬ʧ��', sHint); Exit;
  end;

  nStr := 'Delete From %s Where W_NO=''%s''';
  nStr := Format(nStr, [sTable_InvoiceWeek, nID]);
  FDM.ExecuteSQL(nStr);

  LoadWeek;
  ShowMsg('��¼��ɾ��', sHint);
end;

//------------------------------------------------------------------------------
constructor TLadingItems.Create(AOwner: TfFormMain);
begin
  FOwner := AOwner;
  FDataList := TList.Create;
end;

destructor TLadingItems.Destroy;
begin
  ClearData(True);
  inherited;
end;

procedure TLadingItems.ClearData(const nFree: Boolean);
var nIdx: Integer;
begin
  for nIdx:=FDataList.Count - 1 downto 0 do
  begin
    Dispose(PLadingItem(FDataList[nIdx]));
    FDataList.Delete(nIdx);
  end;

  if nFree then
    FDataList.Free;
  //xxxxx
end;

//Desc: ��ȡ�������
procedure TLadingItems.LoadLadingData;
var nStr,nSQL: string;
    nItem: PLadingItem;
begin
  with FOwner,FDM do
  begin
    EditDate.Text := Format('%s �� %s', [Date2Str(FStart), Date2Str(FEnd)]);
    if not ADOConn.Connected then Exit;

    nStr := 'Select L_ID,L_Stock,L_Type,L_Custom,C_Name as L_CusName,' +
            'S_Name as L_Saler,sb.R_ID as L_RID From $SB sb '+
            ' Left Join $Cus cus On cus.C_ID=sb.L_Custom' +
            ' Left Join $SM sm On sm.S_ID=sb.L_SaleMan';
    //bill

    nStr := MacroValue(nStr, [MI('$SB', sTable_Bill),
            MI('$Cus', sTable_Customer), MI('$SM', sTable_Salesman)]);
    //xxxxx

    nSQL := 'Select te.*,sb.*,T_OutTime,iw.W_Name From $TE te ' +
            ' Left Join ($Bill) sb On sb.L_ID=te.E_Bill ' +
            ' Left Join $TL tl On tl.T_ID=te.E_TID ' +
            ' Left Join $IW iw On iw.W_NO=te.E_HyNO ';
    //xxxxx

    nSQL := MacroValue(nSQL, [MI('$TE', sTable_TruckLogExt), MI('$Bill', nStr),
            MI('$TL', sTable_TruckLog), MI('$IW', sTable_InvoiceWeek)]);
    //xxxxx

    nStr := ' Where (T_OutTime>=''%s'' And T_OutTime <''%s'')';
    nSQL := nSQL + Format(nStr, [Date2Str(FStart), Date2Str(FEnd+1)]);
    //ʱ��ɸѡ

    if not Check1.Checked then
      nSQL := nSQL + ' and (W_Name is Null) ';
    //����ɸѡ

    if FLastQCtrl = BtnQuery then
    begin
      nStr := ' and (L_Custom like ''%%%s%%'' Or L_CusName like ''%%%s%%'')';
      nSQL := nSQL + Format(nStr, [EditCus.Text, EditCus.Text]);
    end;
  end;

  ClearData(False);
  //���������
  
  with FDM.QueryTemp(nSQL) do
  if RecordCount > 0 then
  begin
    First;

    while not Eof do
    begin
      New(nItem);
      FDataList.Add(nItem);

      with nItem^ do
      begin
        FChecked := False;
        FRecordID := FieldByName('E_ID').AsString;
        FTruckID := FieldByName('E_TID').AsString;
        FBillID := FieldByName('E_Bill').AsString;
        FBillRID := FieldByName('L_RID').AsString;

        FWeek := FieldByName('W_Name').AsString;
        FSaler := FieldByName('L_Saler').AsString;
        FCusNo := FieldByName('L_Custom').AsString;
        FCusName := FieldByName('L_CusName').AsString;
        FStock := FieldByName('L_Stock').AsString;
        FStockType := FieldByName('L_Type').AsString;
        FTruck := FieldByName('E_Truck').AsString;
        FValue := FieldByName('E_Value').AsFloat;
        FPrice := FieldByName('E_Price').AsFloat;
        FTime := FieldByName('T_OutTime').AsDateTime;
      end;

      Next;
    end;
  end;
end;

function TLadingItems.GetRecordCount: Integer;
begin
  Result := FDataList.Count;
end;

function TLadingItems.GetValue(ARecordHandle: TcxDataRecordHandle;
  AItemHandle: TcxDataItemHandle): Variant;
var nColumn: Integer;
    nItem: PLadingItem;
begin
  nColumn := GetDefaultItemID(Integer(AItemHandle));
  nItem := FDataList[Integer(ARecordHandle)];

  case nColumn of
    0: Result := nItem.FChecked;
    1: Result := nItem.FRecordID;
    2: Result := nItem.FWeek;
    3: Result := nItem.FSaler;
    4: Result := nItem.FCusNo;
    5: Result := nItem.FCusName;
    6: Result := nItem.FStock;
    7: Result := nItem.FTruck;
    8: Result := nItem.FValue;
    9: Result := nItem.FPrice;
    10: Result := nItem.FValue * nItem.FPrice;
    11: Result := nItem.FTime;
  end;
end;

procedure TLadingItems.SetValue(ARecordHandle: TcxDataRecordHandle;
  AItemHandle: TcxDataItemHandle; const AValue: Variant);
var nColumn: Integer;
    nItem: PLadingItem;
begin
  nColumn := GetDefaultItemID(Integer(AItemHandle));
  nItem := FDataList[Integer(ARecordHandle)];

  case nColumn of
    0: nItem.FChecked := AValue;
  end;
end;

//------------------------------------------------------------------------------
//Desc: ʱ��ɸѡ
procedure TfFormMain.cxButtonEdit1PropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if ShowDateFilterForm(FStart, FEnd) then
  begin
    gLadingData.LoadLadingData;
    gLadingData.DataChanged;
  end;
end;

//Desc: ��ѯ
procedure TfFormMain.BtnQueryClick(Sender: TObject);
begin
  if Sender = BtnQuery then
  begin
    EditCus.Text := Trim(EditCus.Text);
    if EditCus.Text = '' then
    begin
      EditCus.SetFocus;
      ShowMsg('����д��Ч�Ŀͻ�����', sHint); Exit;
    end;
  end;

  FLastQCtrl := Sender;
  gLadingData.LoadLadingData;
  gLadingData.DataChanged;
end;

//Desc: ѡ��ǰ��ͼ������
procedure TfFormMain.BtnSelectClick(Sender: TObject);
var nItem: PLadingItem;
    i,nCount,nIdx: Integer;
begin
  nItem := nil;
  nCount := cxView2.ViewData.RowCount - 1;

  for i:=0 to nCount do
  begin
    nIdx := cxView2.ViewData.Rows[i].RecordIndex;
    nItem := gLadingData.LadingData[nIdx];

    case TComponent(Sender).Tag of
     10: nItem.FChecked := True;
     20: nItem.FChecked := False;
     30: nItem.FChecked := not nItem.FChecked;
    end;
  end;

  if Assigned(nItem) then
    gLadingData.DataChanged;
  //xxxxx
end;

//Desc: ɾ��ѡ��
procedure TfFormMain.BtnDeleteClick(Sender: TObject);
var nStr: string;
    nItem: PLadingItem;
    i,nIdx,nNum: Integer;
    nList,nTruck: TStrings;
begin
  nList := nil;
  nTruck := nil;
  with gLadingData,FDM do
  try
    nNum := 0;
    nList := TStringList.Create;
    nTruck := TStringList.Create;

    for i:=cxView2.ViewData.RowCount - 1 downto 0 do
    begin
      nIdx := cxView2.ViewData.Rows[i].RecordIndex;
      nItem := gLadingData.LadingData[nIdx];
      if (not nItem.FChecked) or (nItem.FWeek <> '') then Continue;

      nStr := 'Delete From %s Where E_ID=%s';
      nStr := Format(nStr, [sTable_TruckLogExt, nItem.FRecordID]);
      nList.AddObject(nStr, Pointer(nItem));

      Inc(nNum);
      nStr := 'Delete From %s Where L_ID=''%s''';
      nStr := Format(nStr, [sTable_Bill, nItem.FBillID]);
      nList.AddObject(nStr, nil);

      if nTruck.IndexOf(nItem.FTruckID) < 0 then
        nTruck.Add(nItem.FTruckID);
      //truck items
    end;

    if nNum < 1 then
    begin
      ShowMsg('��ѡ��Ҫɾ��������', sHint); Exit;
    end;

    nStr := 'ȷ��Ҫɾ��ѡ�е�[ %d ]�������¼��?';
    nStr := Format(nStr, [nNum]);
    if not QueryDlg(nStr, sAsk) then Exit;

    ADOConn.BeginTrans;
    try
      for nIdx:=nList.Count - 1 downto 0 do
        FDM.ExecuteSQL(nList[nIdx]);
      //xxxxx

      for nIdx:=nTruck.Count - 1 downto 0 do
      begin
        nStr := 'Delete From $TL Where T_ID=''$ID'' And ' +
              ' (1 = (Select Count(*) From $TE Where E_TID=''$ID''))';
        nStr := MacroValue(nStr, [MI('$TL', sTable_TruckLog),
                MI('$TE', sTable_TruckLogExt), MI('$ID', nTruck[nIdx])]);
        FDM.ExecuteSQL(nStr);
      end;
      
      ADOConn.CommitTrans;
    except
      on e:Exception do
      begin
        ADOConn.RollbackTrans;
        ShowDlg(e.Message, sWarn); Exit;
      end;
    end;

    for nIdx:=nList.Count - 1 downto 0 do
    begin
      nItem := Pointer(nList.Objects[nIdx]);
      if not Assigned(nItem) then Continue;

      i := FDataList.IndexOf(nItem);
      if i < 0 then Continue;

      Dispose(nItem);
      FDataList.Delete(i);
    end;

    gLadingData.DataChanged;
    //���ݱ䶯
  finally
    nList.Free;
    nTruck.Free;
  end;
end;

//Desc: ѡ������
procedure TfFormMain.BtnZZClick(Sender: TObject);
var nStr: string;
    i,nIdx: Integer;
    nList: TStrings;
    nItem: PLadingItem;
begin
  if FNowWeek = '' then
  begin
    ShowMsg('�������Ч����������', sHint); Exit;
  end;

  nList := TStringList.Create;
  with gLadingData,FDM do
  try
    for i:=cxView2.ViewData.RowCount - 1 downto 0 do
    begin
      nIdx := cxView2.ViewData.Rows[i].RecordIndex;
      nItem := gLadingData.LadingData[nIdx];
      if (not nItem.FChecked) or (nItem.FWeek <> '') then Continue;

      nStr := 'Update %s Set E_HyNO=''%s'' Where E_ID=%s';
      nStr := Format(nStr, [sTable_TruckLogExt, FNowWeek, nItem.FRecordID]);
      nList.AddObject(nStr, Pointer(nItem));
    end;

    if nList.Count < 1 then
    begin
      ShowMsg('��ѡ��Ҫ���ʵ�����', sHint); Exit;
    end;

    nStr := 'ȷ��Ҫ��ѡ�е�[ %d ]�������¼ִ�����ʲ�����?' + #32#32#13#10#13#10 +
            'ע��: �ò�����ɺ��޷�����.';
    nStr := Format(nStr, [nList.Count]);
    if not QueryDlg(nStr, sAsk) then Exit;

    ADOConn.BeginTrans;
    try
      for nIdx:=nList.Count - 1 downto 0 do
        FDM.ExecuteSQL(nList[nIdx]);
      ADOConn.CommitTrans;
    except
      on e:Exception do
      begin
        ADOConn.RollbackTrans;
        ShowDlg(e.Message, sWarn); Exit;
      end;
    end;

    for nIdx:=nList.Count - 1 downto 0 do
    begin
      nItem := Pointer(nList.Objects[nIdx]);
      nItem.FWeek := FWeekName;
    end;

    gLadingData.DataChanged;
    //���ݱ䶯
  finally
    nList.Free;
  end;
end;

//------------------------------------------------------------------------------
constructor TProvideItems.Create(AOwner: TfFormMain);
begin
  FOwner := AOwner;
  FDataList := TList.Create;
end;

destructor TProvideItems.Destroy;
begin
  ClearData(True);
  inherited;
end;

procedure TProvideItems.ClearData(const nFree: Boolean);
var nIdx: Integer;
begin
  for nIdx:=FDataList.Count - 1 downto 0 do
  begin
    Dispose(PProvideItem(FDataList[nIdx]));
    FDataList.Delete(nIdx);
  end;

  if nFree then
    FDataList.Free;
  //xxxxx
end;

procedure TProvideItems.LoadProvideData;
var nStr,nSQL: string;
    nItem: PProvideItem;
begin
  with FOwner,FDM do
  begin
    EditDate2.Text := Format('%s �� %s', [Date2Str(FStartP), Date2Str(FEndP)]);
    if not ADOConn.Connected then Exit;

    nSQL := 'Select L_ID,L_Provider,L_SaleMan,L_Mate,L_OutDate,iw.W_Name,' +
            'L_PValue,L_MValue From $PL pl ' +
            ' Left Join $IW iw On iw.W_NO=pl.L_Memo ';
    //xxxxx

    nSQL := MacroValue(nSQL, [MI('$PL', sTable_ProvideLog),
            MI('$IW', sTable_InvoiceWeek)]);
    //xxxxx

    nStr := ' Where (L_OutDate>=''%s'' And L_OutDate <''%s'')';
    nSQL := nSQL + Format(nStr, [Date2Str(FStartP), Date2Str(FEndP+1)]);
    //ʱ��ɸѡ

    if not Check2.Checked then
      nSQL := nSQL + ' and (W_Name is Null) ';
    //����ɸѡ

    if FLastQCtrl = BtnQProvide then
    begin
      nStr := ' and (L_Provider like ''%%%s%%'')';
      nSQL := nSQL + Format(nStr, [EditProvider.Text]);
    end;
  end;

  ClearData(False);
  //���������
  
  with FDM.QueryTemp(nSQL) do
  if RecordCount > 0 then
  begin
    First;

    while not Eof do
    begin
      New(nItem);
      FDataList.Add(nItem);

      with nItem^ do
      begin
        FChecked := False;
        FRecordID := FieldByName('L_ID').AsString;
        FWeek := FieldByName('W_Name').AsString;
        FSaler := FieldByName('L_SaleMan').AsString;
        FProvider := FieldByName('L_Provider').AsString;
        FMate := FieldByName('L_Mate').AsString;

        FPValue := FieldByName('L_PValue').AsFloat;
        FMValue := FieldByName('L_MValue').AsFloat;
        FWeight := FMValue - FPValue;
        FTime := FieldByName('L_OutDate').AsDateTime;
      end;

      Next;
    end;
  end;
end;

function TProvideItems.GetRecordCount: Integer;
begin
  Result := FDataList.Count;
end;

function TProvideItems.GetValue(ARecordHandle: TcxDataRecordHandle;
  AItemHandle: TcxDataItemHandle): Variant;
var nColumn: Integer;
    nItem: PProvideItem;
begin
  nColumn := GetDefaultItemID(Integer(AItemHandle));
  nItem := FDataList[Integer(ARecordHandle)];

  case nColumn of
    0: Result := nItem.FChecked;
    1: Result := nItem.FRecordID;
    2: Result := nItem.FWeek;
    3: Result := nItem.FSaler;
    4: Result := nItem.FProvider;
    5: Result := nItem.FMate;
    6: Result := nItem.FWeight;
    7: Result := nItem.FTime;
  end;
end;

procedure TProvideItems.SetValue(ARecordHandle: TcxDataRecordHandle;
  AItemHandle: TcxDataItemHandle; const AValue: Variant);
var nColumn: Integer;
    nItem: PProvideItem;
begin
  nColumn := GetDefaultItemID(Integer(AItemHandle));
  nItem := FDataList[Integer(ARecordHandle)];

  case nColumn of
    0: nItem.FChecked := AValue;
  end;
end;

//------------------------------------------------------------------------------ 
//Desc: ѡ��ʱ��
procedure TfFormMain.EditDate2PropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if ShowDateFilterForm(FStartP, FEndP) then
  begin
    gProvideData.LoadProvideData;
    gProvideData.DataChanged;
  end;
end;

//Desc: ��ѯ��Ӧ����
procedure TfFormMain.BtnQProvideClick(Sender: TObject);
begin
  if Sender = BtnQProvide then
  begin
    EditProvider.Text := Trim(EditProvider.Text);
    if EditProvider.Text = '' then
    begin
      EditProvider.SetFocus;
      ShowMsg('����д��Ч�Ĺ�Ӧ������', sHint); Exit;
    end;
  end;

  FLastPQCtrl := Sender;
  gProvideData.LoadProvideData;
  gProvideData.DataChanged;
end;

//Desc: ѡ��ǰ��ͼ
procedure TfFormMain.BtnPSelectClick(Sender: TObject);
var nItem: PProvideItem;
    i,nCount,nIdx: Integer;
begin
  nItem := nil;
  nCount := cxView3.ViewData.RowCount - 1;

  for i:=0 to nCount do
  begin
    nIdx := cxView3.ViewData.Rows[i].RecordIndex;
    nItem := gProvideData.ProvideData[nIdx];

    case TComponent(Sender).Tag of
     10: nItem.FChecked := True;
     20: nItem.FChecked := False;
     30: nItem.FChecked := not nItem.FChecked;
    end;
  end;

  if Assigned(nItem) then
    gProvideData.DataChanged;
  //xxxxx
end;

//Desc: ɾ��ѡ��
procedure TfFormMain.BtnPDeleteClick(Sender: TObject);
var nStr: string;
    nList: TStrings;
    i,nIdx: Integer;
    nItem: PProvideItem;
begin
  nList := TStringList.Create;
  with gProvideData,FDM do
  try
    for i:=cxView3.ViewData.RowCount - 1 downto 0 do
    begin
      nIdx := cxView3.ViewData.Rows[i].RecordIndex;
      nItem := gProvideData.ProvideData[nIdx];
      if (not nItem.FChecked) or (nItem.FWeek <> '') then Continue;

      nStr := 'Delete From %s Where L_ID=%s';
      nStr := Format(nStr, [sTable_ProvideLog, nItem.FRecordID]);
      nList.AddObject(nStr, Pointer(nItem));
    end;

    if nList.Count < 1 then
    begin
      ShowMsg('��ѡ��Ҫɾ��������', sHint); Exit;
    end;

    nStr := 'ȷ��Ҫɾ��ѡ�е�[ %d ]����Ӧ��¼��?';
    nStr := Format(nStr, [nList.Count]);
    if not QueryDlg(nStr, sAsk) then Exit;

    ADOConn.BeginTrans;
    try
      for nIdx:=nList.Count - 1 downto 0 do
        FDM.ExecuteSQL(nList[nIdx]);
      ADOConn.CommitTrans;
    except
      on e:Exception do
      begin
        ADOConn.RollbackTrans;
        ShowDlg(e.Message, sWarn); Exit;
      end;
    end;

    for nIdx:=nList.Count - 1 downto 0 do
    begin
      nItem := Pointer(nList.Objects[nIdx]);
      i := FDataList.IndexOf(nItem);
      if i < 0 then Continue;

      Dispose(nItem);
      FDataList.Delete(i);
    end;

    gProvideData.DataChanged;
    //���ݱ䶯
  finally
    nList.Free;
  end;
end;

//Desc: ѡ������
procedure TfFormMain.BtnPZZClick(Sender: TObject);
var nStr: string;
    i,nIdx: Integer;
    nList: TStrings;
    nItem: PProvideItem;
begin
  if FNowWeek = '' then
  begin
    ShowMsg('�������Ч����������', sHint); Exit;
  end;

  nList := TStringList.Create;
  with gProvideData,FDM do
  try
    for i:=cxView3.ViewData.RowCount - 1 downto 0 do
    begin
      nIdx := cxView3.ViewData.Rows[i].RecordIndex;
      nItem := gProvideData.ProvideData[nIdx];
      if (not nItem.FChecked) or (nItem.FWeek <> '') then Continue;

      nStr := 'Update %s Set L_Memo=''%s'' Where L_ID=%s';
      nStr := Format(nStr, [sTable_ProvideLog, FNowWeek, nItem.FRecordID]);
      nList.AddObject(nStr, Pointer(nItem));
    end;

    if nList.Count < 1 then
    begin
      ShowMsg('��ѡ��Ҫ���ʵ�����', sHint); Exit;
    end;

    nStr := 'ȷ��Ҫ��ѡ�е�[ %d ]����Ӧ��¼ִ�����ʲ�����?' + #32#32#13#10#13#10 +
            'ע��: �ò�����ɺ��޷�����.';
    nStr := Format(nStr, [nList.Count]);
    if not QueryDlg(nStr, sAsk) then Exit;

    ADOConn.BeginTrans;
    try
      for nIdx:=nList.Count - 1 downto 0 do
        FDM.ExecuteSQL(nList[nIdx]);
      ADOConn.CommitTrans;
    except
      on e:Exception do
      begin
        ADOConn.RollbackTrans;
        ShowDlg(e.Message, sWarn); Exit;
      end;
    end;

    for nIdx:=nList.Count - 1 downto 0 do
    begin
      nItem := Pointer(nList.Objects[nIdx]);
      nItem.FWeek := FWeekName;
    end;

    gProvideData.DataChanged;
    //���ݱ䶯
  finally
    nList.Free;
  end;
end;

//Desc: �޸ļ�¼
procedure TfFormMain.N3Click(Sender: TObject);
var nIdx: Integer;
    nP: PProvideItem;
begin
  if wPage.ActivePage = SheetProvide then
  begin
    if cxView3.DataController.GetSelectedCount > 0 then
    begin
      nIdx := cxView3.DataController.GetSelectedRowIndex(0);
      nIdx := cxView3.ViewData.Rows[nIdx].RecordIndex;
      nP := gProvideData.ProvideData[nIdx];

      if ShowModifyProvideForm(nP) then
        gProvideData.DataChanged;
      //���ݱ䶯
    end;
  end;
end;

//Desc: ��ӡ
procedure TfFormMain.N1Click(Sender: TObject);
var nIdx: Integer;
    nS: PLadingItem;
    nP: PProvideItem;
begin
  if wPage.ActivePage = SheetSale then
  begin
    if cxView2.DataController.GetSelectedCount > 0 then
    begin
      nIdx := cxView2.DataController.GetSelectedRowIndex(0);
      nIdx := cxView2.ViewData.Rows[nIdx].RecordIndex;
      
      nS := gLadingData.LadingData[nIdx];
      if nS.FStockType = sFlag_Dai then
           PrintBillReport(nS.FBillRID, False)
      else PrintPoundReport(nS.FRecordID, False);
    end;
  end else

  if wPage.ActivePage = SheetProvide then
  begin
    if cxView3.DataController.GetSelectedCount > 0 then
    begin
      nIdx := cxView3.DataController.GetSelectedRowIndex(0);
      nIdx := cxView3.ViewData.Rows[nIdx].RecordIndex;
      
      nP := gProvideData.ProvideData[nIdx];
      PrintProvidePoundReport(nP.FRecordID, False);
    end;
  end;
end;

end.

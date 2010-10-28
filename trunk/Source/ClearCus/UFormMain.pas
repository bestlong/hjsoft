{*******************************************************************************
  作者: dmzn@163.com 2010-9-19
  描述: 主单元
*******************************************************************************}
unit UFormMain;

{$I Link.inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UTrayIcon, Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, Menus, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxCheckBox, DB, ADODB,
  StdCtrls, ExtCtrls, dxStatusBar, cxGridLevel, cxGridCustomTableView,
  cxGridTableView, cxClasses, cxGridCustomView, cxGrid, cxTextEdit,
  cxProgressBar, cxLabel, cxButtons, cxGroupBox, cxMemo, cxRichEdit, cxPC;

type
  TfFormMain = class(TForm)
    wPage: TcxPageControl;
    Sheet2: TcxTabSheet;
    cxLookAndFeelController1: TcxLookAndFeelController;
    Shee1: TcxTabSheet;
    ADOConnLocal: TADOConnection;
    ADOQuery1: TADOQuery;
    SBar1: TdxStatusBar;
    HintPanel: TPanel;
    Image1: TImage;
    Image2: TImage;
    HintLabel: TLabel;
    cxDefaultEditStyleController1: TcxDefaultEditStyleController;
    Rich1: TcxRichEdit;
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
    BtnRead: TcxButton;
    cxGrid1Level1: TcxGridLevel;
    cxGrid1: TcxGrid;
    ADOCmd1: TADOQuery;
    cxView1: TcxGridTableView;
    cxView1Column1: TcxGridColumn;
    cxView1Column2: TcxGridColumn;
    cxView1Column3: TcxGridColumn;
    cxView1Column4: TcxGridColumn;
    cxGroupBox2: TcxGroupBox;
    BtnBegin: TcxButton;
    cxLabel6: TcxLabel;
    cxLabel7: TcxLabel;
    PBarNow: TcxProgressBar;
    cxLabel8: TcxLabel;
    cxLabel9: TcxLabel;
    PBarCus: TcxProgressBar;
    PBarTotal: TcxProgressBar;
    PMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    BtnConn: TcxButton;
    cxTabSheet1: TcxTabSheet;
    cxGroupBox3: TcxGroupBox;
    BtnInput: TcxButton;
    cxLabel11: TcxLabel;
    cxLabel12: TcxLabel;
    PBarCus2: TcxProgressBar;
    PBarTotal2: TcxProgressBar;
    cxLabel13: TcxLabel;
    Rich2: TcxRichEdit;
    cxLabel10: TcxLabel;
    LabelFile: TcxLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnReadClick(Sender: TObject);
    procedure BtnBeginClick(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure BtnConnClick(Sender: TObject);
    procedure ADOConnLocalConnectComplete(Connection: TADOConnection;
      const Error: Error; var EventStatus: TEventStatus);
    procedure ADOConnLocalDisconnect(Connection: TADOConnection;
      var EventStatus: TEventStatus);
    procedure BtnInputClick(Sender: TObject);
  private
    { Private declarations }
    FTrayIcon: TTrayIcon;
    {*状态栏图标*}
  protected
    procedure FormLoadConfig;
    procedure FormSaveConfig;
    {*配置信息*}
    procedure SetHintText(const nLabel: TLabel);
    {*提示信息*}
     procedure WriteLog(const nMsg: string; const nRich: TcxRichEdit = nil);
    {*记录日志*}
    function CutData(const nCusID: string): Boolean;
    function CombinData(const nFile: string): Boolean;
    {*数据操作*}
    procedure OnMakeInsert(const nPos: Cardinal);
    {*进度显示*}
  public
    { Public declarations }
  end;

var
  fFormMain: TfFormMain;

implementation

{$R *.dfm}
uses
  IniFiles, ULibFun, UMgrDB, USysConst, USysDB;

type
  TTableSQL = record
    FMemo: string;
    FTable: string;
    FQuery: string;
    FDelete: string;
  end;

const
  cTableSQL: array[0..14] of TTableSQL = (
    (FMemo:'合同明细'; FTable:'S_ContractExt';
     FQuery:'Select * From S_ContractExt Where E_CID In (Select C_ID From S_Contract Where C_Customer = ''$ID'')';
     FDelete:'Delete From S_ContractExt Where E_CID In (Select C_ID From S_Contract Where C_Customer = ''$ID'')'),
    (FMemo:'合同主体'; FTable:'S_Contract';
     FQuery:'Select * From S_Contract Where C_Customer = ''$ID''';
     FDelete:'Delete From S_Contract Where C_Customer = ''$ID'''),
    (FMemo:'退货明细'; FTable:'S_ReturnGoods';
     FQuery:'Select * From S_ReturnGoods Where R_ZID In (Select Z_ID From S_ZhiKa Where Z_Custom = ''$ID'')';
     FDelete:'Delete From S_ReturnGoods Where R_ZID In (Select Z_ID From S_ZhiKa Where Z_Custom = ''$ID'')'),
    (FMemo:'磁卡'; FTable:'S_ZhiKaCard';
     FQuery:'Select * From S_ZhiKaCard Where C_ZID In (Select Z_ID From S_ZhiKa Where Z_Custom = ''$ID'')';
     FDelete:'Delete From S_ZhiKaCard Where C_ZID In (Select Z_ID From S_ZhiKa Where Z_Custom = ''$ID'')'),
    (FMemo:'纸卡明细'; FTable:'S_ZhiKaDtl';
     FQuery:'Select * From S_ZhiKaDtl Where D_ZID In (Select Z_ID From S_ZhiKa Where Z_Custom = ''$ID'')';
     FDelete:'Delete From S_ZhiKaDtl Where D_ZID In (Select Z_ID From S_ZhiKa Where Z_Custom = ''$ID'')'),
    (FMemo:'纸卡'; FTable:'S_ZhiKa';
     FQuery:'Select * From S_ZhiKa Where Z_Custom = ''$ID''';
     FDelete:'Delete From S_ZhiKa Where Z_Custom = ''$ID'''),
    (FMemo:'信用记录'; FTable:'Sys_CustomerCredit';
     FQuery:'Select * From Sys_CustomerCredit Where C_CusID=''$ID''';
     FDelete:'Delete From Sys_CustomerCredit Where C_CusID=''$ID'''), 
    (FMemo:'财务收据'; FTable:'Sys_ShouJu';
     FQuery:'Select * From Sys_ShouJu Where S_Sender = ''$Name''';
     FDelete:'Delete From Sys_ShouJu Where S_Sender = ''$Name'''),
    (FMemo:'客户账户'; FTable:'Sys_CustomerAccount';
     FQuery:'Select * From Sys_CustomerAccount Where A_CID = ''$ID''';
     FDelete:'Delete From Sys_CustomerAccount Where A_CID = ''$ID'''),
    (FMemo:'出入金明细'; FTable:'Sys_CustomerInOutMoney';
     FQuery:'Select * From Sys_CustomerInOutMoney Where M_CusID = ''$ID''';
     FDelete:'Delete From Sys_CustomerInOutMoney Where M_CusID = ''$ID'''),
    (FMemo:'客户档案'; FTable:'S_Customer';
     FQuery:'Select * From S_Customer Where C_ID=''$ID''';
     FDelete:'Delete From S_Customer Where C_ID=''$ID'''),
    (FMemo:'化验单'; FTable:'S_StockHuaYan';
     FQuery:'Select * From S_StockHuaYan Where H_Custom = ''$ID''';
     FDelete:'Delete From S_StockHuaYan Where H_Custom = ''$ID'''),
    (FMemo:'车辆明细'; FTable:'Sys_TruckLog';
     FQuery:'Select * From Sys_TruckLog Where T_ID In (Select E_TID From Sys_TruckLogExt Where E_Bill In (Select L_ID From S_Bill Where L_Custom = ''$ID''))';
     FDelete:'Delete From Sys_TruckLog Where T_ID In (Select E_TID From Sys_TruckLogExt Where E_Bill In (Select L_ID From S_Bill Where L_Custom = ''$ID''))'),
    (FMemo:'提货明细'; FTable:'Sys_TruckLogExt';
     FQuery:'Select * From Sys_TruckLogExt Where E_Bill In (Select L_ID From S_Bill Where L_Custom = ''$ID'')';
     FDelete:'Delete From Sys_TruckLogExt Where E_Bill In (Select L_ID From S_Bill Where L_Custom = ''$ID'')'),
    (FMemo:'提货单'; FTable:'S_Bill';
     FQuery:'Select * From S_Bill Where L_Custom = ''$ID''';
     FDelete:'Delete From S_Bill Where L_Custom = ''$ID''')
  ); //SQL

type
  PCustomerItem = ^TCustomerItem;
  TCustomerItem = record
    FChecked: Boolean;
    FCusID: string;
    FCusName: string;
    FCusYW: string;
  end;

  TCustomerItems = class(TcxCustomDataSource)
  private
    FOwner: TfFormMain;
    FDataList: TList;
  protected
    procedure ClearData(const nFree: Boolean);
    //清理资源
    function GetRecordCount: Integer; override;
    function GetValue(ARecordHandle: TcxDataRecordHandle;
     AItemHandle: TcxDataItemHandle): Variant; override;
    procedure SetValue(ARecordHandle: TcxDataRecordHandle;
     AItemHandle: TcxDataItemHandle; const AValue: Variant); override;
     //读写数据
  public
    constructor Create(AOwner: TfFormMain);
    destructor Destroy; override;
    //创建释放
    procedure LoadCustomers;
    //读取客户
  end;

var
  gCustomers: TCustomerItems;
  //全局使用

constructor TCustomerItems.Create(AOwner: TfFormMain);
begin
  FOwner := AOwner;
  FDataList := TList.Create;
end;

destructor TCustomerItems.Destroy;
begin
  ClearData(True);
  inherited;
end;

procedure TCustomerItems.ClearData(const nFree: Boolean);
var nIdx: Integer;
begin
  for nIdx:=FDataList.Count - 1 downto 0 do
  begin
    Dispose(PCustomerItem(FDataList[nIdx]));
    FDataList.Delete(nIdx);
  end;

  if nFree then
    FDataList.Free;
  //xxxxx
end;

//Desc: 读取客户
procedure TCustomerItems.LoadCustomers;
var nStr: string;
    nItem: PCustomerItem;
begin
  nStr := 'Select C_ID,C_Name,S_Name From %s' +
          ' Left Join %s On S_ID=C_SaleMan ' +
          'Order By C_PY';
  nStr := Format(nStr, [sTable_Customer, sTable_Salesman]);

  ClearData(False);
  with FOwner do
  begin
    ADOQuery1.Close;
    ADOQuery1.SQL.Text := nStr;
    ADOQuery1.Open;

    if ADOQuery1.RecordCount < 1 then
         Exit
    else ADOQuery1.First;

    while not ADOQuery1.Eof do
    begin
      New(nItem);
      FDataList.Add(nItem);

      nItem.FChecked := False;
      nItem.FCusID := ADOQuery1.Fields[0].AsString;
      nItem.FCusName := ADOQuery1.Fields[1].AsString;
      nItem.FCusYW := ADOQuery1.Fields[2].AsString;
      ADOQuery1.Next;
    end;
  end;
end;

function TCustomerItems.GetRecordCount: Integer;
begin
  Result := FDataList.Count;
end;

function TCustomerItems.GetValue(ARecordHandle: TcxDataRecordHandle;
  AItemHandle: TcxDataItemHandle): Variant;
var nColumn: Integer;
    nItem: PCustomerItem;
begin
  nColumn := GetDefaultItemID(Integer(AItemHandle));
  nItem := FDataList[Integer(ARecordHandle)];

  case nColumn of
    0: Result := nItem.FChecked;
    1: Result := nItem.FCusYW;
    2: Result := nItem.FCusID;
    3: Result := nItem.FCusName;
  end;
end;

procedure TCustomerItems.SetValue(ARecordHandle: TcxDataRecordHandle;
  AItemHandle: TcxDataItemHandle; const AValue: Variant);
var nColumn: Integer;
    nItem: PCustomerItem;
begin
  nColumn := GetDefaultItemID(Integer(AItemHandle));
  nItem := FDataList[Integer(ARecordHandle)];

  case nColumn of
    0: nItem.FChecked := AValue;
  end;
end;

//------------------------------------------------------------------------------
//Date: 2007-10-15
//Parm: 标签
//Desc: 在nLabel上显示提示信息
procedure TfFormMain.SetHintText(const nLabel: TLabel);
begin
  nLabel.Font.Color := clWhite;
  nLabel.Font.Size := 12;
  nLabel.Font.Style := nLabel.Font.Style + [fsBold];

  nLabel.Caption := gSysParam.FHintText;
  nLabel.Left := 8;
  nLabel.Top := (HintPanel.Height + nLabel.Height - 12) div 2;
end;

procedure TfFormMain.FormLoadConfig;
begin
  with gSysParam do
  begin
    EditLocalDB.Text := FLocalDB;
    EditLocalHost.Text := FLocalHost;
    EditLocalPort.Text := IntToStr(FLocalPort);
    EditLocalUser.Text := FLocalUser;
    EditLocalPwd.Text := FLocalPwd;
  end;

  gCustomers := TCustomerItems.Create(Self);
  cxView1.DataController.CustomDataSource := gCustomers;
  LoadFormConfig(Self);
end;

procedure TfFormMain.FormSaveConfig;
begin
  AdminDBParam(False);
  SaveFormConfig(Self);
  gCustomers.Free;
end;

procedure TfFormMain.FormCreate(Sender: TObject);
var nStr: string;
begin
  InitSystemEnvironment;
  LoadSysParameter;
  
  Application.Title := gSysParam.FAppTitle;
  InitGlobalVariant(gPath, gPath + sConfigFile, gPath + sFormConfig);

  nStr := GetFileVersionStr(Application.ExeName);
  if nStr <> '' then
  begin
    nStr := Copy(nStr, 1, Pos('.', nStr) - 1);
    Caption := gSysParam.FMainTitle + ' V' + nStr;
  end else Caption := gSysParam.FMainTitle;

  wPage.ActivePageIndex := 0;
  SetHintText(HintLabel);
  FormLoadConfig;
  //载入配置
  
  FTrayIcon := TTrayIcon.Create(Self);
  FTrayIcon.Hint := gSysParam.FAppTitle;
  FTrayIcon.Visible := True;
  //任务托盘
end;

procedure TfFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  {$IFNDEF debug}
  if not QueryDlg(sCloseQuery, sHint) then
  begin
    Action := caNone; Exit;
  end;
  {$ENDIF}

  gLogManager.Free;
  Sleep(520);
  FormSaveConfig;
end;

//Desc: 快捷菜单
procedure TfFormMain.N1Click(Sender: TObject);
var i,nLen: Integer;
    nItem: PCustomerItem;
begin
  with gCustomers do
  begin
    nLen := FDataList.Count - 1;
    for i:=0 to nLen do
    begin
      nItem := FDataList[i];

      if Sender = N1 then
        nItem.FChecked := True else
      if Sender = N2 then
        nItem.FChecked := False else
      if Sender = N3 then
        nItem.FChecked := not nItem.FChecked;
    end;

    gCustomers.DataChanged;
  end;
end;

procedure TfFormMain.ADOConnLocalConnectComplete(
  Connection: TADOConnection; const Error: Error;
  var EventStatus: TEventStatus);
begin
  BtnConn.Enabled := not Connection.Connected;
end;

procedure TfFormMain.ADOConnLocalDisconnect(Connection: TADOConnection;
  var EventStatus: TEventStatus);
begin
  BtnConn.Enabled := not Connection.Connected;
end;

//Desc: Insert构建进度
procedure TfFormMain.OnMakeInsert(const nPos: Cardinal);
begin
  PBarNow.Position := nPos;
  Application.ProcessMessages;
end;

//------------------------------------------------------------------------------
//Desc: 记录日志
procedure TfFormMain.WriteLog(const nMsg: string; const nRich: TcxRichEdit);
var nStr: string;
    nTmp: TcxRichEdit;
begin
  if Assigned(nRich) then
       nTmp := nRich
  else nTmp := Rich1;

  if nTmp.Lines.Count > 200 then
    nTmp.Clear;
  nStr := Format('【%d】%s ::: %s', [nTmp.Lines.Count+1, Time2Str(Now), Trim(nMsg)]);

  nTmp.Lines.Insert(0, nStr);
  Application.ProcessMessages;
  //WriteLogFile(ClassType, nStr, '主模块');
end;

//Date: 2010-10-27
//Parm: 客户号;是否读取;标记
//Desc: 记录nCusID客户的导出标记
function OutputFlag(const nCusID: string; const nRead: Boolean;
 const nFlag: Boolean = True): Boolean;
var nIni: TIniFile;
begin
  Result := True;
  nIni := TIniFile.Create(gPath + 'CusFlag.Ini');
  try
    if nRead then
         Result := nIni.ReadBool('Output', nCusID, False)
    else nIni.WriteBool('Output', nCusID, nFlag);
  finally
    nIni.Free;
  end;
end;

//Date: 2010-10-27
//Parm: 客户号;是否读取;标记
//Desc: 记录nCusID客户的合并标记
function InputFlag(const nCusID: string; const nRead: Boolean;
 const nFlag: Boolean = True): Boolean;
var nIni: TIniFile;
begin
  Result := True;
  nIni := TIniFile.Create(gPath + 'CusFlag.Ini');
  try
    if nRead then
         Result := nIni.ReadBool('Input', nCusID, False)
    else nIni.WriteBool('Input', nCusID, nFlag);
  finally
    nIni.Free;
  end;
end;

//Desc: 连接数据库
procedure TfFormMain.BtnConnClick(Sender: TObject);
begin
  with gSysParam do
  begin
    FLocalDB := EditLocalDB.Text;
    FLocalHost := EditLocalHost.Text;

    if IsNumber(EditLocalPort.Text, False) then
      FLocalPort := StrToInt(EditLocalPort.Text);
    FLocalUser := EditLocalUser.Text;
    FLocalPwd := EditLocalPwd.Text;
  end;

  try
    ADOConnLocal.Close;
    ADOConnLocal.ConnectionString := MakeDBConnection(gSysParam);
    ADOConnLocal.Open;
  except
    on E:Exception do
    begin
      ShowDlg(E.Message, sHint, Handle);
    end;
  end;
end;

//Desc: 读取客户
procedure TfFormMain.BtnReadClick(Sender: TObject);
begin
  if not ADOConnLocal.Connected then
    BtnConnClick(nil);
  if not ADOConnLocal.Connected then Exit;

  gCustomers.LoadCustomers;
  gCustomers.DataChanged;
end;

//Desc: 开始分离
procedure TfFormMain.BtnBeginClick(Sender: TObject);
var nBool: Boolean;
    nList: TStrings;
    i,nLen: Integer;
    nItem: PCustomerItem;
begin
  nList := TStringList.Create;
  with gCustomers do
  try
    nLen := FDataList.Count - 1;
    for i:=0 to nLen do
    begin
      nItem := FDataList[i];
      if nItem.FChecked then nList.Add(nItem.FCusID + ';' + nItem.FCusName);
    end;

    if nList.Count < 1 then
    begin
      wPage.ActivePage := Sheet2;
      ShowMsg('请选择要分离的客户', sHint); Exit;
    end;

    if not QueryDlg('该操作可能需要一段时间,请耐心等候完成提示!' + #13#10 +
                    '确定要执行分离操作吗?', sAsk, Handle) then Exit;
    //xxxxx
                    
    PBarTotal.Properties.Max := nList.Count;
    PBarTotal.Position := 0;
    
    nBool := True;
    nLen := nList.Count - 1;

    for i:=0 to nLen do
    begin
      Rich1.Clear;
      nBool := CutData(nList[i]);
      if not nBool then Break;
    end;

    if nBool then
    begin
      ShowDlg('数据已成功分离', sHint);
      PBarTotal.Properties.Text := '处理完毕';
    end;
  finally
    nList.Free;
  end;
end;

//Desc: 从数据库中分离nCusID客户
function TfFormMain.CutData(const nCusID: string): Boolean;
var nList: TStrings;  
    i,nLen,nPos: Integer;
    nStr,nID,nName: string;
begin
  Result := True;
  nList := TStringList.Create;
  try
    nName := nCusID;
    nPos := Pos(';', nName);

    nID := Copy(nName, 1, nPos - 1);
    System.Delete(nName, 1, nPos);

    PBarTotal.Position := PBarTotal.Position + 1;
    PBarTotal.Properties.Text := nName;
    if OutputFlag(nID, True) then Exit;

    nStr := Format('--客户编号: %s', [nID]);
    nList.Add(nStr);
    nStr := Format('--客户名称: %s', [nName]);
    nList.Add(nStr);

    nLen := High(cTableSQL);
    PBarCus.Position := 0;
    PBarCus.Properties.Max := nLen + 1;

    for i:=Low(cTableSQL) to nLen do
    begin
      PBarCus.Position := PBarCus.Position + 1;
      PBarCus.Properties.Text := cTableSQL[i].FMemo;
      
      nList.Add('');
      nStr := Format('--[ %s ]数据', [cTableSQL[i].FMemo]);

      nList.Add(nStr);
      WriteLog(nStr);

      nStr := cTableSQL[i].FQuery;
      nStr := MacroValue(nStr, [MI('$ID', nID), MI('$Name', nName)]);

      ADOQuery1.Close;
      ADOQuery1.SQL.Text := nStr;
      ADOQuery1.Open;

      PBarNow.Position := 0;
      PBarNow.Properties.Max := ADOQuery1.RecordCount;
      MakeInsert(cTableSQL[i].FTable, ADOQuery1, nList, OnMakeInsert); 
    end;

    nStr := gPath + 'Data\' + Date2Str(Now) + '\';
    if not DirectoryExists(nStr) then
      ForceDirectories(nStr);
    //xxxxx

    nStr := nStr + nID + '.sql';
    nList.SaveToFile(nStr);

    PBarNow.Position := 0;
    PBarNow.Properties.Max := nLen + 1;

    ADOConnLocal.BeginTrans;
    try
      for i:=Low(cTableSQL) to nLen do
      begin
        PBarNow.Position := PBarNow.Position + 1;
        nStr := Format('--清理[ %s ]数据', [cTableSQL[i].FMemo]);
        WriteLog(nStr);

        nStr := cTableSQL[i].FDelete;
        nStr := MacroValue(nStr, [MI('$ID', nID), MI('$Name', nName)]);

        ADOCmd1.Close;
        ADOCmd1.SQL.Text := nStr;
        ADOCmd1.ExecSQL;
      end;

      ADOConnLocal.CommitTrans;
      //提交更改
      OutputFlag(nID, False, True);
      //导出标记开
      InputFlag(nID, False, False);
      //合并标记关
    except
      on E:Exception do
      begin
        ADOConnLocal.RollbackTrans;
        OutputFlag(nID, False, False);

        Result := False;
        WriteLog(E.Message);
        ShowDlg(E.Message, sHint, Handle);
      end;
    end;
  finally
    nList.Free;
  end;
end;

//Desc: 开始合并数据
procedure TfFormMain.BtnInputClick(Sender: TObject);
var nBool: Boolean;
    nList: TStrings;
    i,nLen: Integer;
begin
  if not ADOConnLocal.Connected then
    BtnConnClick(nil);
  if not ADOConnLocal.Connected then Exit;

  nList := TStringList.Create;
  try
    with TOpenDialog.Create(Application) do
    begin
      Title := '选择客户';
      Filter := '客户数据(*.sql)|*.sql';

      InitialDir := gPath + 'Data\';
      Options := Options + [ofAllowMultiSelect];

      if Execute then
        nList.AddStrings(Files);
      Free;
    end;

    if nList.Count < 1 then Exit;
    if not QueryDlg('该操作可能需要一段时间,请耐心等候完成提示!' + #13#10 +
                    '确定要执行合并操作吗?', sAsk, Handle) then Exit;
    //xxxxx 

    PBarTotal2.Properties.Max := nList.Count;
    PBarTotal2.Position := 0;
    
    nBool := True;
    nLen := nList.Count - 1;

    for i:=0 to nLen do
    begin
      PBarTotal2.Position := PBarTotal2.Position + 1;
      Rich2.Clear;
      
      nBool := CombinData(nList[i]);
      if not nBool then Break;
    end;

    if nBool then
    begin
      ShowDlg('数据已成功合并', sHint);
      PBarTotal2.Properties.Text := '处理完毕';
    end;
  finally
    nList.Free;
  end;
end;

//Desc: 合并nFile文件到数据库
function TfFormMain.CombinData(const nFile: string): Boolean;
var nList: TStrings;
    i,nLen: Integer;
    nStr,nID: string;
begin
  Result := True;
  nList := TStringList.Create;
  try
    LabelFile.Caption := nFile;
    Application.ProcessMessages;

    nID := ExtractFileName(nFile);
    nID := Copy(nID, 1, Pos('.', nID) - 1);

    if InputFlag(nID, True) then
    begin
      nList.Free; Exit;
    end; //已导入过

    nList.LoadFromFile(nFile);
    if nList.Count < 2 then
    begin
      nList.Free; Exit;
    end; //无效内容

    nStr := nList[1];
    System.Delete(nStr, 1, Pos(':', nStr));
    PBarTotal2.Properties.Text := Trim(nStr);

    PBarCus2.Position := 0;
    PBarCus2.Properties.Max := 0;

    nLen := nList.Count - 1;
    for i:=2 to nLen do
    begin
      nStr := Copy(nList[i], 1, Pos(' ', nList[i]) - 1);
      if CompareText(nStr, 'Insert') = 0 then
        PBarCus2.Properties.Max := PBarCus2.Properties.Max + 1;
      //xxxxx
    end;

    ADOConnLocal.BeginTrans;
    //开启事务

    for i:=2 to nLen do
    begin
      if Copy(nList[i], 1, 2) = '--' then
      begin
        WriteLog(nList[i], Rich2); Continue;
      end;

      nStr := Copy(nList[i], 1, Pos(' ', nList[i]) - 1);
      if CompareText(nStr, 'Insert') = 0 then
      begin
        PBarCus2.Position := PBarCus2.Position + 1;
        Application.ProcessMessages;

        ADOCmd1.Close;
        ADOCmd1.SQL.Text := nList[i];
        ADOCmd1.ExecSQL;
      end;
    end;

    FreeAndNil(nList);
    ADOConnLocal.CommitTrans;

    InputFlag(nID, False, True);
    //合并标记开
    OutputFlag(nID, False, False);
    //导出标记关
  except
    on E:Exception do
    begin
      nList.Free;
      Result := False;

      if ADOConnLocal.InTransaction then
        ADOConnLocal.RollbackTrans;
      //事务回滚

      WriteLog(E.Message, Rich2);
      ShowDlg(E.Message, sHint, Handle);
    end;
  end;
end;

end.

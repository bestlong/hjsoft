unit UFormMain;

{$I Link.Inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UTrayIcon, Dialogs, ComCtrls, Buttons, StdCtrls, ImgList, ExtCtrls,
  UDataModule;

type
  TfFormMain = class(TForm)
    HintPanel: TPanel;
    Image1: TImage;
    Image2: TImage;
    HintLabel: TLabel;
    wPage: TPageControl;
    SheetDebug: TTabSheet;
    SheetSetup: TTabSheet;
    SBar: TStatusBar;
    MemoLog: TMemo;
    Timer1: TTimer;
    ImageList1: TImageList;
    ImageList2: TImageList;
    ParamPage: TPageControl;
    SheetBase: TTabSheet;
    SheetReader: TTabSheet;
    GroupBox2: TGroupBox;
    BtnRun: TButton;
    BtnStop: TButton;
    CheckLogs: TCheckBox;
    GroupBox1: TGroupBox;
    CheckAutoRun: TCheckBox;
    CheckAutoMin: TCheckBox;
    GroupLocalDB: TGroupBox;
    EditSServer: TLabeledEdit;
    EditSPort: TLabeledEdit;
    EditSDB: TLabeledEdit;
    EditSUser: TLabeledEdit;
    EditSPwd: TLabeledEdit;
    EditSConn: TLabeledEdit;
    GroupBackupDB: TGroupBox;
    EditBServer: TLabeledEdit;
    EditBPort: TLabeledEdit;
    EditBDB: TLabeledEdit;
    EditBUser: TLabeledEdit;
    EditBPwd: TLabeledEdit;
    EditBConn: TLabeledEdit;
    BtnSTest: TButton;
    BtnBTest: TButton;
    BtnSaveAs: TButton;
    GroupInterval: TGroupBox;
    EditInterval: TLabeledEdit;
    Label1: TLabel;
    Label2: TLabel;
    EditTime: TDateTimePicker;
    BtnSync: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer1Timer(Sender: TObject);
    procedure BtnRunClick(Sender: TObject);
    procedure BtnSaveAsClick(Sender: TObject);
    procedure BtnSTestClick(Sender: TObject);
    procedure BtnStopClick(Sender: TObject);
    procedure BtnSyncClick(Sender: TObject);
  private
    { Private declarations }
    FTrayIcon: TTrayIcon;
    //״̬��
    procedure InitFormData;
    //��ʼ��
    procedure DoParamConfig(const nRead: Boolean);
    //��������
    procedure CtrlStatus(const nRun: Boolean);
    //���״̬
  public
    { Public declarations }
    function MakeDBConn(const nIsBack: Boolean): string;
    //��������
    procedure ShowLog(const nMsg: string);
    //��ʾ��־
  end;

var
  fFormMain: TfFormMain;

implementation

{$R *.dfm}
uses
  IniFiles, Registry, UBase64, ULibFun, UMgrCOMM, USysConst, UFormWait,
  UFormConn, UMgrDBConn;

//------------------------------------------------------------------------------
//Desc: ��nIDָ����С�ڶ�ȡnList��������Ϣ
procedure LoadListViewConfig(const nID: string; const nListView: TListView;
 const nIni: TIniFile = nil);
var nTmp: TIniFile;
    nList: TStrings;
    i,nCount: integer;
begin
  nTmp := nil;
  nList := TStringList.Create;
  try
    if Assigned(nIni) then
         nTmp := nIni
    else nTmp := TIniFile.Create(gPath + sFormConfig); 

    nList.Text := StringReplace(nTmp.ReadString(nID, nListView.Name + '_Cols',
                                ''), ';', #13, [rfReplaceAll]);
    if nList.Count <> nListView.Columns.Count then Exit;

    nCount := nListView.Columns.Count - 1;
    for i:=0 to nCount do
     if IsNumber(nList[i], False) then
      nListView.Columns[i].Width := StrToInt(nList[i]);
    //xxxxx
  finally
    nList.Free;
    if not Assigned(nIni) then FreeAndNil(nTmp);
  end;
end;

//Desc: ��nList����Ϣ����nIDָ����С��
procedure SaveListViewConfig(const nID: string; const nListView: TListView;
 const nIni: TIniFile = nil);
var nStr: string;
    nTmp: TIniFile;
    i,nCount: integer;
begin
  nTmp := nil;
  try
    if Assigned(nIni) then
         nTmp := nIni
    else nTmp := TIniFile.Create(gPath + sFormConfig);

    nStr := '';
    nCount := nListView.Columns.Count - 1;

    for i:=0 to nCount do
    begin
      nStr := nStr + IntToStr(nListView.Columns[i].Width);
      if i <> nCount then nStr := nStr + ';';
    end;

    nTmp.WriteString(nID, nListView.Name + '_Cols', nStr);
  finally
    if not Assigned(nIni) then FreeAndNil(nTmp);
  end;
end;

//Desc: ��ʼ������
procedure TfFormMain.InitFormData;
begin
  wPage.ActivePage := SheetSetup;
  ParamPage.ActivePage := SheetBase;
end;

procedure TfFormMain.FormCreate(Sender: TObject);
var nStr: string;
begin
  Randomize;
  ShortDateFormat := 'YYYY-MM-DD';

  gDebugLog := ShowLog;
  gPath := ExtractFilePath(Application.ExeName);

  with gSysParam do
  begin
    FAppTitle := '����ͬ��';
    FMainTitle := FAppTitle;
  end;

  Application.Title := gSysParam.FAppTitle;
  InitGlobalVariant(gPath, gPath + sConfigFile, gPath + sFormConfig, gPath + sDBConfig);

  nStr := GetFileVersionStr(Application.ExeName);
  if nStr <> '' then
  begin
    nStr := Copy(nStr, 1, Pos('.', nStr) - 1);
    Caption := gSysParam.FMainTitle + ' V' + nStr;
  end else Caption := gSysParam.FMainTitle;

  FTrayIcon := TTrayIcon.Create(Self);
  FTrayIcon.Hint := gSysParam.FAppTitle;
  FTrayIcon.Visible := True;
  //ϵͳ����

  InitFormData;
  //��ʼ��
  DoParamConfig(True);
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

  if BtnStop.Enabled then
  begin
    Action := caNone;
    ShowMsg('����ֹͣ����', sHint); Exit;
  end;
  //stop service 

  DoParamConfig(False);
  //��������
end;

//------------------------------------------------------------------------------
//Desc: ״̬��ʱ��
procedure TfFormMain.Timer1Timer(Sender: TObject);
begin
  SBar.Panels[0].Text := FormatDateTime('����:��yyyy-mm-dd��', Now);
  SBar.Panels[1].Text := FormatDateTime('ʱ��:��hh:mm:ss��', Now);
end;

//Desc: ��ʾ���Լ�¼
procedure TfFormMain.ShowLog(const nMsg: string);
var nStr: string;
begin
  if CheckLogs.Checked then
  begin
    if MemoLog.Lines.Count > 200 then
      MemoLog.Clear;
    //clear logs

    nStr := Format('��%s��::: %s', [DateTime2Str(Now), nMsg]);
    MemoLog.Lines.Add(nStr);
  end;
end;

//Desc: �������õĶ�ȡ�뱣��
procedure TfFormMain.DoParamConfig(const nRead: Boolean);
var nStr: string;
    nIni: TIniFile;
    nReg: TRegistry;
begin
  nIni := TIniFile.Create(gPath + sConfigFile);
  nReg := TRegistry.Create;
  try
    nReg.RootKey := HKEY_CURRENT_USER;
    nReg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', True);
    //registry

    if nRead then
    begin
      CheckAutoRun.Checked := nReg.ValueExists('DBSync');
      nStr := 'Setup';
      CheckAutoMin.Checked := nIni.ReadBool(nStr, 'AutoMin', False);
      EditInterval.Text := nIni.ReadString(nStr, 'Interval', '20');
      EditTime.Time := nIni.ReadTime(nStr, 'Time', Time());

      nStr := 'LocalDB';
      EditSServer.Text := nIni.ReadString(nStr, 'Server', '127.0.0.1');
      EditSPort.Text := nIni.ReadString(nStr, 'Port', '1433');
      EditSDB.Text := nIni.ReadString(nStr, 'DBName', '');
      EditSUser.Text := nIni.ReadString(nStr, 'User', 'sa');
      EditSPwd.Text := DecodeBase64(nIni.ReadString(nStr, 'Pwd', ''));
      EditSConn.Text := DecodeBase64(nIni.ReadString(nStr, 'Conn', ''));

      nStr := 'BackupDB';
      EditBServer.Text := nIni.ReadString(nStr, 'Server', '127.0.0.1');
      EditBPort.Text := nIni.ReadString(nStr, 'Port', '1433');
      EditBDB.Text := nIni.ReadString(nStr, 'DBName', '');
      EditBUser.Text := nIni.ReadString(nStr, 'User', 'sa');
      EditBPwd.Text := DecodeBase64(nIni.ReadString(nStr, 'Pwd', ''));
      EditBConn.Text := DecodeBase64(nIni.ReadString(nStr, 'Conn', ''));

      if CheckAutoMin.Checked then
      begin
        //if EditFile.Text <> '' then
        begin
          BtnRun.Click;
          WindowState := wsMinimized;
          FTrayIcon.Minimize;
        end;
      end;
    end else
    begin
      nStr := 'Setup';
      nIni.WriteBool(nStr, 'AutoMin', CheckAutoMin.Checked);
      nIni.WriteInteger(nStr, 'Interval', StrToInt(EditInterval.Text));
      nIni.WriteTime(nStr, 'Time', EditTime.Time);

      nStr := 'LocalDB';
      nIni.WriteString(nStr, 'Server', EditSServer.Text);
      nIni.WriteString(nStr, 'Port', EditSPort.Text);
      nIni.WriteString(nStr, 'DBName', EditSDB.Text);
      nIni.WriteString(nStr, 'User', EditSUser.Text);
      nIni.WriteString(nStr, 'Pwd', EncodeBase64(EditSPwd.Text));
      nIni.WriteString(nStr, 'Conn', EncodeBase64(EditSConn.Text));

      nStr := 'BackupDB';
      nIni.WriteString(nStr, 'Server', EditBServer.Text);
      nIni.WriteString(nStr, 'Port', EditBPort.Text);
      nIni.WriteString(nStr, 'DBName', EditBDB.Text);
      nIni.WriteString(nStr, 'User', EditBUser.Text);
      nIni.WriteString(nStr, 'Pwd', EncodeBase64(EditBPwd.Text));
      nIni.WriteString(nStr, 'Conn', EncodeBase64(EditBConn.Text));

      if CheckAutoRun.Checked then
        nReg.WriteString('DBSync', Application.ExeName)
      else if nReg.ValueExists('DBSync') then
        nReg.DeleteValue('DBSync');
      //xxxxx
    end;
  finally
    nReg.Free;
    nIni.Free;
  end;
end;

//------------------------------------------------------------------------------
//Desc: ���������ַ���
function TfFormMain.MakeDBConn(const nIsBack: Boolean): string;
var nParam: TDBParam;
begin
  with nParam do
  begin
    if nIsBack then
    begin
      FHost := EditBServer.Text;
      FPort := StrToInt(EditBPort.Text);
      FDB   := EditBDB.Text;
      FUser := EditBUser.Text;
      FPwd  := EditBPwd.Text;
      FConn := EditBConn.Text;
    end else
    begin
      FHost := EditSServer.Text;
      FPort := StrToInt(EditSPort.Text);
      FDB   := EditSDB.Text;
      FUser := EditSUser.Text;
      FPwd  := EditSPwd.Text;
      FConn := EditSConn.Text;
    end;
  end;

  Result := TDBConnManager.MakeDBConnection(nParam);
end;

//Desc: ���Ӳ���
procedure TfFormMain.BtnSTestClick(Sender: TObject);
begin
  with FDM.ADOConn do
  try
    ShowWaitForm(Self, '�����������ݿ�');
    Sleep(320);
    
    Connected := False;
    ConnectionString := MakeDBConn(Sender = BtnBTest);
    Connected := True;

    CloseWaitForm;
    ShowMsg('���Գɹ�', sHint);
  except
    CloseWaitForm;
    ShowMsg('��������,����ʧ��', sHint);
  end;
end;

//Desc: ���ݿ��������
procedure TfFormMain.BtnSaveAsClick(Sender: TObject);
var nStr,nTmp: string;
    nIni: TIniFile;
begin
  with TSaveDialog.Create(Application) do
  begin
    Title := '����';
    DefaultExt := '.ini';
    Filter := '��������(*.ini)|*.ini';
    Options := Options + [ofOverwritePrompt];

    if Execute then nStr := FileName else nStr := '';
    Free;
  end;

  nIni := nil;
  if nStr <> '' then
  try
    nTmp := EditBConn.Text;
    nTmp := StringReplace(nTmp, '$DBName', sConn_DB, [rfReplaceAll, rfIgnoreCase]);
    nTmp := StringReplace(nTmp, '$Host', sConn_Host, [rfReplaceAll, rfIgnoreCase]);
    nTmp := StringReplace(nTmp, '$User', sConn_User, [rfReplaceAll, rfIgnoreCase]);
    nTmp := StringReplace(nTmp, '$Pwd', sConn_Pwd, [rfReplaceAll, rfIgnoreCase]);
    nTmp := StringReplace(nTmp, '$Port', sConn_Port, [rfReplaceAll, rfIgnoreCase]);

    nIni := TIniFile.Create(nStr);
    nStr := '����';
    nIni.WriteString(sConn_Sec_DBConnRes, nStr, nTmp);
    nIni.WriteString(sConn_Sec_DBConn, sConn_Key_DBName, nStr);
    nIni.WriteString(sConn_Sec_DBConn, sConn_Key_DBList, nStr);

    nIni.WriteString(sConn_Sec_DBConn, sConn_Key_User, EditBUser.Text);
    nIni.WriteString(sConn_Sec_DBConn, sConn_Key_DBPwd, EncodeBase64(EditBPwd.Text));
    nIni.WriteString(sConn_Sec_DBConn, sConn_Key_DBCatalog, EditBDB.Text);

    nIni.WriteString(sConn_Sec_DBConn, sConn_Key_DBSource, EditBServer.Text);
    nIni.WriteString(sConn_Sec_DBConn, sConn_Key_DBPort, EditBPort.Text);
    ShowMsg('�������', sHint);
  finally
    nIni.Free;
  end;
end;

//Desc: ��������״̬�������
procedure TfFormMain.CtrlStatus(const nRun: Boolean);
begin
  BtnRun.Enabled := not nRun;
  BtnStop.Enabled := nRun;
  GroupInterval.Enabled := not nRun;
  GroupLocalDB.Enabled := not nRun;
  GroupBackupDB.Enabled := not nRun;
end;

//Desc: ����
procedure TfFormMain.BtnRunClick(Sender: TObject);
var nStr: string;
begin
  if BtnRun.Enabled then
  begin
    if FDM.StartService(nStr) then
         CtrlStatus(True)
    else ShowMsg(nStr, sHint);
  end;
end;

//Desc: ֹͣ
procedure TfFormMain.BtnStopClick(Sender: TObject);
begin
  ShowWaitForm(Self, '����ֹͣ����');
  try
    Sleep(230);
    FDM.StopService;
    CtrlStatus(False);
  finally
    CloseWaitForm;
  end;
end;

//Desc: ����ǿ��ͬ��
procedure TfFormMain.BtnSyncClick(Sender: TObject);
var nStr: string;
    nIni: TIniFile;
begin
  nStr := '�ò�����ǿ��ϵͳͬ���������ݵ����ݿ�,�Ƿ����?' + #13#10 +
          'ע��: ʵʱͬ����������Ӱ��.';
  if not QueryDlg(nStr, sAsk) then Exit;

  nIni := TIniFile.Create(gPath + sConfigFile);
  try
    nIni.WriteDate('Syncer', 'LastTime', Date() - 1);
    //�޸�ͬ������
  finally
    nIni.Free;
  end;

  EditTime.Time := Time();
  BtnRun.Click;
end;

end.

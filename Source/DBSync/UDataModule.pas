{*******************************************************************************
  ����: dmzn@163.com 2009-5-20
  ����: ���ݿ����ӡ�������� 
*******************************************************************************}
unit UDataModule;

{$I Link.Inc}
interface

uses
  Windows, Graphics, SysUtils, Classes, DB, ADODB, UWaitItem;

type
  TFDM = class;
  TDBSyncer = class(TThread)
  private
    FOwner: TFDM;
    //ӵ����
    FHintMsg: string;
    //��ʾ��Ϣ
    FLastSync: Cardinal;
    FInterval: Word;
    //ʵʱͬ��
    FLastTime: TDateTime;
    FTime: TDateTime;
    //��ʱͬ��
    FList: TStrings;
    //�б����
    FWaiter: TWaitObject;
    //�ȴ�����
  protected
    function DoSyncInterval: Boolean;
    function DoSyncTime: Boolean;
    procedure DoExecute;
    procedure Execute; override;
    //ִ���߳�
    function CheckDBConnection: Boolean;
    //�������
    procedure ShowRunLog(const nMsg: string);
    procedure DoShowRunLog;
    //��ʾ��־
    procedure DoLastSyncStatus(const nRead: Boolean);
    //��дͬ��״̬
    procedure DoEnableBackupDB(const nEnable: Boolean);
    //���ÿ�״̬
  public
    constructor Create(AOwner: TFDM);
    destructor Destroy; override;
    //�����ͷ�
    procedure StopMe;
    //ֹͣ�߳�
  end;

  TFDM = class(TDataModule)
    ADOConn: TADOConnection;
    SqlQuery: TADOQuery;
    Command: TADOQuery;
    Query_bak: TADOQuery;
    Conn_bak: TADOConnection;
    Cmd_bak: TADOQuery;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    FSyncer: TDBSyncer;
    //ͬ���߳�
  public
    { Public declarations }
    function StartService(var nHint: string): Boolean;
    procedure StopService;
    //��ͣ����
  end;

var
  FDM: TFDM;

implementation

{$R *.dfm}

uses
  IniFiles, ULibFun, UFormMain, USysConst, USysDB, UMgrDB;

type
  TSyncType = (stInterval, stTime);
  //ʵʱ,��ʱ

  TDBItem = record
    FTable: string;      //����
    FType: TSyncType;    //ͬ������
    FWhere: string;      //��ѯ����
    FKeyField: string;   //���ֶ�����
    FKeyValue: string;   //���ֶ����ֵ
    FKeyValueTmp: string;//����ʱֵ
  end;

var
  gTables: array of TDBitem;
  //��ͬ����

//Desc: ���ͬ����
procedure AddSyncTable(const nTable: string; const nType: TSyncType;
 const nWhere: string = ''; const nField: string = '');
var nLen: Integer;
begin
  nLen := Length(gTables);
  SetLength(gTables, nLen + 1);

  with gTables[nLen] do
  begin
    FTable := nTable;
    FType := nType;
    FWhere := nWhere;
    FKeyField := nField;
    FKeyValue := '-1';
  end;
end;

//Desc: ��ʼ����ͬ����
procedure InitSyncTables;
begin
  AddSyncTable(sTable_Salesman, stTime);
  AddSyncTable(sTable_Customer, stTime);
  AddSyncTable(sTable_SaleContract, stTime);
  AddSyncTable(sTable_SContractExt, stTime);

  AddSyncTable(sTable_ZhiKa, stInterval, 'R_ID>%s', 'R_ID');
  AddSyncTable(sTable_ZhiKaCard, stInterval, 'R_ID>%s', 'R_ID');
  AddSyncTable(sTable_Bill, stInterval, 'R_ID>%s', 'R_ID');
  AddSyncTable(sTable_TruckLog, stInterval, 'R_ID>%s', 'R_ID');
  AddSyncTable(sTable_TruckLogExt, stInterval, 'E_ID>%s', 'E_ID');

  AddSyncTable(sTable_Provider, stTime);
  AddSyncTable(sTable_Materails, stTime);
  AddSyncTable(sTable_ProvideCard, stTime);
  AddSyncTable(sTable_ProvideLog, stInterval, 'L_ID>%s', 'L_ID');
end;

//------------------------------------------------------------------------------
constructor TDBSyncer.Create(AOwner: TFDM);
begin
  inherited Create(False);
  FreeOnTerminate := False;
  FOwner := AOwner;
  
  FList := TStringList.Create;
  FWaiter := TWaitObject.Create;
  FWaiter.Interval := 1 * 1000;

  FInterval := StrToInt(fFormMain.EditInterval.Text);
  FTime := Str2Time(Time2Str(fFormMain.EditTime.Time));
end;

destructor TDBSyncer.Destroy;
begin
  FWaiter.Free;
  FList.Free;
  inherited;
end;

procedure TDBSyncer.StopMe;
begin
  Terminate;
  FWaiter.Wakeup;
  WaitFor;
  Free;
end;

procedure TDBSyncer.DoShowRunLog;
begin
  fFormMain.ShowLog(FHintMsg);
end;

procedure TDBSyncer.ShowRunLog(const nMsg: string);
begin
  FHintMsg := nMsg;
  Synchronize(DoShowRunLog);
end;

procedure TDBSyncer.DoLastSyncStatus(const nRead: Boolean);
var nIni: TIniFile;
    nIdx: Integer;
begin
  nIni := TIniFile.Create(gPath + sConfigFile);
  try
    if nRead then
    begin
      FLastTime := nIni.ReadDateTime('Syncer', 'LastTime', Date() - 1);

      for nIdx:=Low(gTables) to High(gTables) do
      with gTables[nIdx] do
      begin
        if FType = stInterval then
          FKeyValue := nIni.ReadString('Syncer', FTable, '-1');
        //xxxxx
      end;
    end else
    begin
      nIni.WriteDateTime('Syncer', 'LastTime', FLastTime);

      for nIdx:=Low(gTables) to High(gTables) do
      with gTables[nIdx] do
      begin
        if FType = stInterval then
         nIni.WriteString('Syncer', FTable, FKeyValue);
        //xxxxx
      end;
    end;
  finally
    nIni.Free;
  end;
end;

procedure TDBSyncer.Execute;
begin
  try
    DoLastSyncStatus(True);
    //��ȡͬ��״̬
    DoEnableBackupDB(True);
    //���ñ������ݿ�

    FLastSync := GetTickCount;
    DoExecute;
    //�����߳�

    DoLastSyncStatus(False);
    //��дͬ��״̬
    DoEnableBackupDB(False);
    //�رձ������ݿ�
  except
    on e:Exception do
    begin
      ShowRunLog(e.Message);
    end;
  end;
end;

//Desc: �����̲߳���
procedure TDBSyncer.DoExecute;
begin
  while not Terminated do
  try
    FWaiter.EnterWait;
    if Terminated then Break;

    if GetTickCount - FLastSync >= FInterval * 1000 then
    begin
      if DoSyncInterval then
        DoLastSyncStatus(False);
      FLastSync := GetTickCount;
    end;

    if (Time() >= FTime) and (FLastTime <> Date()) then
    begin
      if DoSyncTime then
      begin
        FLastTime := Date();
        DoLastSyncStatus(False);
      end;
    end;
  except
    on e:Exception do
    begin
      ShowRunLog(e.Message);
    end;
  end;
end;

//Desc: ������ݿ�����
function TDBSyncer.CheckDBConnection: Boolean;
begin
  with FOwner do
  try
    if not ADOConn.Connected then
      ADOConn.Connected := True;
    //xxxxx

    if not Conn_bak.Connected then
      Conn_bak.Connected := True;
    //xxxxx

    Result := ADOConn.Connected and Conn_bak.Connected;
    if not Result then
      raise Exception.Create('���ݿ������쳣');
    //xxxxx
  except
    on e:Exception do
    begin
      Result := False;
      ShowRunLog(e.Message);
    end;
  end;
end;

//Desc: ��ͣ���ݷ�����
procedure TDBSyncer.DoEnableBackupDB(const nEnable: Boolean);
var nStr,nSQL: string;
begin
  if CheckDBConnection then
  begin
    if nEnable then
         nStr := sFlag_Yes
    else nStr := sFlag_No;

    nSQL := 'Update $T Set D_Value=''$V'' ' +
            'Where D_Name=''$Name'' and D_Memo=''$M''';
    nSQL := MacroValue(nSQL, [MI('$T', sTable_SysDict), MI('$V', nStr),
            MI('$Name', sFlag_SysParam), MI('$M', sFlag_EnableBakdb)]);
    //xxxxx

    with FOwner do
    begin
      Command.Close;
      Command.SQL.Text := nSQL;
      Command.ExecSQL;
    end;
  end;
end;

//Desc: ִ��ʵʱͬ��
function TDBSyncer.DoSyncInterval: Boolean;
var nStr: string;
    nIdx: Integer;
begin
  Result := False;
  if not CheckDBConnection then Exit;

  FList.Clear;
  ShowRunLog('ʵʱͬ����ʼ�ռ�����.');

  for nIdx:=Low(gTables) to High(gTables) do
  with gTables[nIdx],FOwner do
  begin
    if Terminated then Exit;
    if FType <> stInterval then Continue;

    FKeyValueTmp := '';
    nStr := 'Select * From %s Where %s Order By %s DESC';
    nStr := Format(nStr, [FTable, Format(FWhere, [FKeyValue]), FKeyField]);

    SqlQuery.Close;
    SqlQuery.SQL.Text := nStr;
    SqlQuery.Open;

    if SqlQuery.RecordCount > 0 then
    begin
      SqlQuery.First;
      FKeyValueTmp := SqlQuery.FieldByName(FKeyField).AsString;
      DB_MakeInsertSQL(FTable, SqlQuery, FList);
    end;
  end;

  nStr := 'ʵʱͬ����ʼ��������,��[ %d ]��.';
  nStr := Format(nStr, [FList.Count]);
  ShowRunLog(nStr);

  if FList.Count > 0 then
  with FOwner do
  begin
    Conn_bak.BeginTrans;
    try
      for nIdx:=FList.Count - 1 downto 0 do
      begin
        if Terminated then
          raise Exception.Create(sServiceStop);
        //xxxxx
        
        Cmd_bak.Close;
        Cmd_bak.SQL.Text := FList[nIdx];
        Cmd_bak.ExecSQL;
      end;

      Conn_bak.CommitTrans;
      Result := True;

      for nIdx:=Low(gTables) to High(gTables) do
       with gTables[nIdx] do
        if (FType = stInterval) and (FKeyValueTmp <> '') then
         FKeyValue := FKeyValueTmp;
      //������Чֵ
    except
      on e:Exception do
      begin
        Conn_bak.RollbackTrans;
        ShowRunLog(e.Message);
      end;
    end;
  end;

  FList.Clear;
  ShowRunLog('ʵʱͬ�����.');
end;

//Desc: ִ�ж�ʱͬ��
function TDBSyncer.DoSyncTime: Boolean;
var nStr: string;
    nIdx: Integer;
begin
  Result := False;
  if not CheckDBConnection then Exit;

  FList.Clear;
  ShowRunLog('��ʱͬ����ʼ�ռ�����.');

  for nIdx:=Low(gTables) to High(gTables) do
  with gTables[nIdx],FOwner do
  begin
    if Terminated then Exit;
    if FType <> stTime then Continue;

    nStr := 'Select * From %s';
    nStr := Format(nStr, [FTable]);

    SqlQuery.Close;
    SqlQuery.SQL.Text := nStr;
    SqlQuery.Open;

    if SqlQuery.RecordCount > 0 then
      DB_MakeInsertSQL(FTable, SqlQuery, FList);
    //xxxxx
  end;
                
  if FList.Count < 1 then
  begin
    Result := True; Exit;
  end; //no data need sync

  nStr := '��ʱͬ����ʼ��������,��[ %d ]��.';
  nStr := Format(nStr, [FList.Count]);
  ShowRunLog(nStr);

  with FOwner do
  begin
    Conn_bak.BeginTrans;
    try
      for nIdx:=Low(gTables) to High(gTables) do
      begin
        if Terminated then
          raise Exception.Create(sServiceStop);
        //xxxxx

        nStr := 'Delete From %s';
        nStr := Format(nStr, [gTables[nIdx].FTable]);

        Cmd_bak.Close;
        Cmd_bak.SQL.Text := nStr;
        Cmd_bak.ExecSQL;
      end;

      for nIdx:=FList.Count - 1 downto 0 do
      begin
        if Terminated then
          raise Exception.Create(sServiceStop);
        //xxxxx

        Cmd_bak.Close;
        Cmd_bak.SQL.Text := FList[nIdx];
        Cmd_bak.ExecSQL;
      end;

      Conn_bak.CommitTrans;
      Result := True;
    except
      on e:Exception do
      begin
        Conn_bak.RollbackTrans;
        ShowRunLog(e.Message);
      end;
    end;
  end;

  FList.Clear;
  ShowRunLog('��ʱͬ�����.');
end;

//------------------------------------------------------------------------------
//Desc: ģ�鴴��
procedure TFDM.DataModuleCreate(Sender: TObject);
begin
  InitSyncTables;
end;

//Desc: ��������
function TFDM.StartService(var nHint: string): Boolean;
begin
  Result := False;
  if Assigned(FSyncer) then
  begin
    nHint := '�����߼�����';
    Exit;
  end;

  try
    ADOConn.Connected := False;
    ADOConn.ConnectionString :=  fFormMain.MakeDBConn(False);
    ADOConn.Connected := True;
  except
    on e:Exception do
    begin
      fFormMain.ShowLog(e.Message);
      nHint := '����������ʧ��';
      Exit;
    end;
  end;

  try
    Conn_bak.Connected := False;
    Conn_bak.ConnectionString :=  fFormMain.MakeDBConn(True);
    Conn_bak.Connected := True;
  except
    on e:Exception do
    begin
      fFormMain.ShowLog(e.Message);
      nHint := '���ӱ��ݿ�ʧ��';
      Exit;
    end;
  end;

  FSyncer := TDBSyncer.Create(Self);
  Result := True;
end;

//Desc: ֹͣ����
procedure TFDM.StopService;
begin
  if Assigned(FSyncer) then
  begin
    FSyncer.StopMe;
    FSyncer := nil;
  end;

  ADOConn.Connected := False;
  Conn_bak.Connected := False;
end;

end.

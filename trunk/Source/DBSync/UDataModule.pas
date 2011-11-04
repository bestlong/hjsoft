{*******************************************************************************
  作者: dmzn@163.com 2009-5-20
  描述: 数据库连接、操作相关 
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
    //拥有者
    FHintMsg: string;
    //提示信息
    FLastSync: Cardinal;
    FInterval: Word;
    //实时同步
    FLastTime: TDateTime;
    FTime: TDateTime;
    //定时同步
    FList: TStrings;
    //列表对象
    FWaiter: TWaitObject;
    //等待对象
  protected
    function DoSyncInterval: Boolean;
    function DoSyncTime: Boolean;
    procedure DoExecute;
    procedure Execute; override;
    //执行线程
    function CheckDBConnection: Boolean;
    //检查连接
    procedure ShowRunLog(const nMsg: string);
    procedure DoShowRunLog;
    //显示日志
    procedure DoLastSyncStatus(const nRead: Boolean);
    //读写同步状态
    procedure DoEnableBackupDB(const nEnable: Boolean);
    //备用库状态
  public
    constructor Create(AOwner: TFDM);
    destructor Destroy; override;
    //创建释放
    procedure StopMe;
    //停止线程
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
    //同步线程
  public
    { Public declarations }
    function StartService(var nHint: string): Boolean;
    procedure StopService;
    //起停服务
  end;

var
  FDM: TFDM;

implementation

{$R *.dfm}

uses
  IniFiles, ULibFun, UFormMain, USysConst, USysDB, UMgrDB;

type
  TSyncType = (stInterval, stTime);
  //实时,定时

  TDBItem = record
    FTable: string;      //表名
    FType: TSyncType;    //同步类型
    FWhere: string;      //查询条件
    FKeyField: string;   //主字段名称
    FKeyValue: string;   //主字段最后值
    FKeyValueTmp: string;//逐渐临时值
  end;

var
  gTables: array of TDBitem;
  //待同步表

//Desc: 添加同步表
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

//Desc: 初始化待同步表
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
    //读取同步状态
    DoEnableBackupDB(True);
    //启用备份数据库

    FLastSync := GetTickCount;
    DoExecute;
    //核心线程

    DoLastSyncStatus(False);
    //重写同步状态
    DoEnableBackupDB(False);
    //关闭备用数据库
  except
    on e:Exception do
    begin
      ShowRunLog(e.Message);
    end;
  end;
end;

//Desc: 核心线程部分
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

//Desc: 检查数据库连接
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
      raise Exception.Create('数据库连接异常');
    //xxxxx
  except
    on e:Exception do
    begin
      Result := False;
      ShowRunLog(e.Message);
    end;
  end;
end;

//Desc: 起停备份服务器
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

//Desc: 执行实时同步
function TDBSyncer.DoSyncInterval: Boolean;
var nStr: string;
    nIdx: Integer;
begin
  Result := False;
  if not CheckDBConnection then Exit;

  FList.Clear;
  ShowRunLog('实时同步开始收集数据.');

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

  nStr := '实时同步开始复制数据,共[ %d ]条.';
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
      //更新有效值
    except
      on e:Exception do
      begin
        Conn_bak.RollbackTrans;
        ShowRunLog(e.Message);
      end;
    end;
  end;

  FList.Clear;
  ShowRunLog('实时同步完毕.');
end;

//Desc: 执行定时同步
function TDBSyncer.DoSyncTime: Boolean;
var nStr: string;
    nIdx: Integer;
begin
  Result := False;
  if not CheckDBConnection then Exit;

  FList.Clear;
  ShowRunLog('定时同步开始收集数据.');

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

  nStr := '定时同步开始复制数据,共[ %d ]条.';
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
  ShowRunLog('定时同步完毕.');
end;

//------------------------------------------------------------------------------
//Desc: 模块创建
procedure TFDM.DataModuleCreate(Sender: TObject);
begin
  InitSyncTables;
end;

//Desc: 启动服务
function TFDM.StartService(var nHint: string): Boolean;
begin
  Result := False;
  if Assigned(FSyncer) then
  begin
    nHint := '服务逻辑错误';
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
      nHint := '连接生产库失败';
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
      nHint := '连接备份库失败';
      Exit;
    end;
  end;

  FSyncer := TDBSyncer.Create(Self);
  Result := True;
end;

//Desc: 停止服务
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

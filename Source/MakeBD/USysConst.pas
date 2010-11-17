{*******************************************************************************
  作者: dmzn@163.com 2010-9-19
  描述: 常量定义
*******************************************************************************}
unit USysConst;

interface

uses
  SysUtils, Classes, ComCtrls, Forms, IniFiles, UBase64, UMgrLog;

type
  TSysParam = record
    FProgID     : string;                            //程序标识
    FAppTitle   : string;                            //程序标题栏提示
    FMainTitle  : string;                            //主窗体标题
    FHintText   : string;                            //提示文本
    FCopyRight  : string;                            //主窗体提示内容

    FLocalDB    : string;
    FLocalHost  : string;
    FLocalPort  : Integer;
    FLocalUser  : string;
    FLocalPwd   : string;
    FLocalConn  : string;                            //数据库配置
  end;
  //系统参数

//------------------------------------------------------------------------------
var
  gPath: string;                                     //程序所在路径
  gSysParam:TSysParam;                               //程序环境参数
  gLogManager: TLogManager = nil;                    //日志管理器

//------------------------------------------------------------------------------
procedure InitSystemEnvironment;
//初始化
procedure LoadSysParameter(const nIni: TIniFile = nil);
//读取配置
procedure AdminDBParam(const nRead: Boolean; nIni: TIniFile = nil);
//数据库参数
function MakeDBConnection(const nParam: TSysParam): string;
//数据库连接
procedure WriteLogFile(const nModle: TObjectClass; const nEvent: string;
 const nDesc: string = '');
//写日志文件

//------------------------------------------------------------------------------
ResourceString
  sProgID             = 'DMZN';                      //默认标识
  sAppTitle           = 'DMZN';                      //程序标题
  sMainCaption        = 'DMZN';                      //主窗口标题

  sHint               = '提示';                      //对话框标题
  sWarn               = '警告';                      //==
  sAsk                = '询问';                      //询问对话框
  sError              = '未知错误';                  //错误对话框
  
  sLogDir             = 'Logs\';                     //日志目录
  sLogExt             = '.log';                      //日志扩展名
  sLogField           = #9;                          //记录分隔符

  sConfigFile         = 'Config.Ini';                //主配置文件
  sConfigSec          = 'Config';                    //主配置小节
  sVerifyCode         = ';Verify:';                  //校验码标记
  sFormConfig         = 'FormInfo.ini';              //窗体配置

  sInvalidConfig      = '配置文件无效或已经损坏';    //配置文件无效
  sCloseQuery         = '确定要退出程序吗?';         //主窗口退出

implementation

//---------------------------------- 配置运行环境 ------------------------------
//Date: 2007-01-09
//Desc: 初始化运行环境
procedure InitSystemEnvironment;
begin
  Randomize;
  ShortDateFormat := 'YYYY-MM-DD';
  gPath := ExtractFilePath(Application.ExeName);
end;

//Date: 2007-09-13
//Desc: 载入系统配置参数
procedure LoadSysParameter(const nIni: TIniFile = nil);
var nTmp: TIniFile;
begin
  if Assigned(nIni) then
       nTmp := nIni
  else nTmp := TIniFile.Create(gPath + sConfigFile);

  try
    with gSysParam, nTmp do
    begin
      FProgID := ReadString(sConfigSec, 'ProgID', sProgID);
      //程序标识决定以下所有参数
      FAppTitle := ReadString(FProgID, 'AppTitle', sAppTitle);
      FMainTitle := ReadString(FProgID, 'MainTitle', sMainCaption);
      FHintText := ReadString(FProgID, 'HintText', '');
      FCopyRight := ReadString(FProgID, 'CopyRight', '');

      AdminDBParam(True, nIni);
      //数据库
    end;
  finally
    if not Assigned(nIni) then nTmp.Free;
  end;
end;

//Desc: 读写数据库参数
procedure AdminDBParam(const nRead: Boolean; nIni: TIniFile);
var nTmp: TIniFile;
begin
  if Assigned(nIni) then
       nTmp := nIni
  else nTmp := TIniFile.Create(gPath + sConfigFile);

  try
    with gSysParam, nTmp do
    begin
      if nRead then
      begin
        FLocalDB    := ReadString(FProgID, 'LocalDB', '');
        FLocalHost  := ReadString(FProgID, 'LocalHost', '');
        FLocalPort  := ReadInteger(FProgID, 'LocalPort', 4043);
        FLocalUser  := ReadString(FProgID, 'LocalUser', '');
        FLocalPwd   := DecodeBase64(ReadString(FProgID, 'LocalPwd', ''));
        FLocalConn  := ReadString(FProgID, 'LocalConnStr', '');
      end else
      begin
        WriteString(FProgID, 'LocalDB', FLocalDB);
        WriteString(FProgID, 'LocalHost', FLocalHost);
        WriteInteger(FProgID, 'LocalPort', FLocalPort);
        WriteString(FProgID, 'LocalUser', FLocalUser);
        WriteString(FProgID, 'LocalPwd', EncodeBase64(FLocalPwd));
      end;
    end;
  finally
    if not Assigned(nIni) then nTmp.Free;
  end;
end;

//Desc: 生成数据库连接
function MakeDBConnection(const nParam: TSysParam): string;
begin
  with nParam do
  begin
    Result := FLocalConn;
    Result := StringReplace(Result, '$DBName', FLocalDB, [rfReplaceAll, rfIgnoreCase]);
    Result := StringReplace(Result, '$Host', FLocalHost, [rfReplaceAll, rfIgnoreCase]);
    Result := StringReplace(Result, '$User', FLocalUser, [rfReplaceAll, rfIgnoreCase]);
    Result := StringReplace(Result, '$Pwd', FLocalPwd, [rfReplaceAll, rfIgnoreCase]);
    Result := StringReplace(Result, '$Port', IntToStr(FLocalPort), [rfReplaceAll, rfIgnoreCase]);
  end;
end;

//------------------------------------------------------------------------------
//Date: 2010-8-8
//Parm: 模块对象;对象描述;事件
//Desc: 将nEvent事件写入文件
procedure WriteLogFile(const nModle: TObjectClass; const nEvent,nDesc: string);
var nItem: PLogItem;
begin
  nItem := gLogManager.NewLogItem;
  nItem.FWriter.FOjbect := nModle;
  if nDesc = '' then
       nItem.FWriter.FDesc := nModle.ClassName
  else nItem.FWriter.FDesc := nDesc; 

  nItem.FLogTag := [ltWriteFile];
  nItem.FEvent := nEvent;
  gLogManager.AddNewLog(nItem);
end;

//Desc: 写日志文件
procedure WriteLog(const nThread: TLogThread; const nLogs: TList);
var nStr: string;
    nFile: TextFile;
    nItem: PLogItem;
    i,nCount: integer;
begin
  nStr := gPath + sLogDir;
  if not DirectoryExists(nStr) then CreateDir(nStr);
  nStr := nStr + DateToStr(Now) + sLogExt;

  AssignFile(nFile, nStr);
  if FileExists(nStr) then
       Append(nFile)
  else Rewrite(nFile);

  try
    nCount := nLogs.Count - 1;
    for i:=0 to nCount do
    begin
      if nThread.Terminated then Exit;
      nItem := nLogs[i];

      nStr := DateTimeToStr(nItem.FTime) + sLogField +       //时间
              nItem.FWriter.FOjbect.ClassName + sLogField +  //类名
              nItem.FWriter.FDesc + sLogField +              //描述
              nItem.FEvent;                                  //事件
      WriteLn(nFile, nStr);
    end;
  finally
    CloseFile(nFile);
  end;
end;

initialization
  gLogManager := TLogManager.Create;
  gLogManager.WriteProcedure := WriteLog;
end.

{*******************************************************************************
  ����: dmzn@163.com 2010-9-19
  ����: ��������
*******************************************************************************}
unit USysConst;

interface

uses
  SysUtils, Classes, ComCtrls, Forms, IniFiles, UBase64, UMgrLog;

type
  TSysParam = record
    FProgID     : string;                            //�����ʶ
    FAppTitle   : string;                            //�����������ʾ
    FMainTitle  : string;                            //���������
    FHintText   : string;                            //��ʾ�ı�
    FCopyRight  : string;                            //��������ʾ����

    FLocalDB    : string;
    FLocalHost  : string;
    FLocalPort  : Integer;
    FLocalUser  : string;
    FLocalPwd   : string;
    FLocalConn  : string;                            //���ݿ�����
  end;
  //ϵͳ����

//------------------------------------------------------------------------------
var
  gPath: string;                                     //��������·��
  gSysParam:TSysParam;                               //���򻷾�����
  gLogManager: TLogManager = nil;                    //��־������

//------------------------------------------------------------------------------
procedure InitSystemEnvironment;
//��ʼ��
procedure LoadSysParameter(const nIni: TIniFile = nil);
//��ȡ����
procedure AdminDBParam(const nRead: Boolean; nIni: TIniFile = nil);
//���ݿ����
function MakeDBConnection(const nParam: TSysParam): string;
//���ݿ�����
procedure WriteLogFile(const nModle: TObjectClass; const nEvent: string;
 const nDesc: string = '');
//д��־�ļ�

//------------------------------------------------------------------------------
ResourceString
  sProgID             = 'DMZN';                      //Ĭ�ϱ�ʶ
  sAppTitle           = 'DMZN';                      //�������
  sMainCaption        = 'DMZN';                      //�����ڱ���

  sHint               = '��ʾ';                      //�Ի������
  sWarn               = '����';                      //==
  sAsk                = 'ѯ��';                      //ѯ�ʶԻ���
  sError              = 'δ֪����';                  //����Ի���
  
  sLogDir             = 'Logs\';                     //��־Ŀ¼
  sLogExt             = '.log';                      //��־��չ��
  sLogField           = #9;                          //��¼�ָ���

  sConfigFile         = 'Config.Ini';                //�������ļ�
  sConfigSec          = 'Config';                    //������С��
  sVerifyCode         = ';Verify:';                  //У������
  sFormConfig         = 'FormInfo.ini';              //��������

  sInvalidConfig      = '�����ļ���Ч���Ѿ���';    //�����ļ���Ч
  sCloseQuery         = 'ȷ��Ҫ�˳�������?';         //�������˳�

implementation

//---------------------------------- �������л��� ------------------------------
//Date: 2007-01-09
//Desc: ��ʼ�����л���
procedure InitSystemEnvironment;
begin
  Randomize;
  ShortDateFormat := 'YYYY-MM-DD';
  gPath := ExtractFilePath(Application.ExeName);
end;

//Date: 2007-09-13
//Desc: ����ϵͳ���ò���
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
      //�����ʶ�����������в���
      FAppTitle := ReadString(FProgID, 'AppTitle', sAppTitle);
      FMainTitle := ReadString(FProgID, 'MainTitle', sMainCaption);
      FHintText := ReadString(FProgID, 'HintText', '');
      FCopyRight := ReadString(FProgID, 'CopyRight', '');

      AdminDBParam(True, nIni);
      //���ݿ�
    end;
  finally
    if not Assigned(nIni) then nTmp.Free;
  end;
end;

//Desc: ��д���ݿ����
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

//Desc: �������ݿ�����
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
//Parm: ģ�����;��������;�¼�
//Desc: ��nEvent�¼�д���ļ�
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

//Desc: д��־�ļ�
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

      nStr := DateTimeToStr(nItem.FTime) + sLogField +       //ʱ��
              nItem.FWriter.FOjbect.ClassName + sLogField +  //����
              nItem.FWriter.FDesc + sLogField +              //����
              nItem.FEvent;                                  //�¼�
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

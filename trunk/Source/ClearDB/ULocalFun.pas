{*******************************************************************************
  ����: dmzn@163.com 2010-9-19
  ����: ���غ�������
*******************************************************************************}
unit ULocalFun;

interface

uses
  SysUtils, Classes, Forms, IniFiles, UBase64, ULibFun, USysConst,
  cxGridTableView, cxTextEdit, cxEdit;

type
  TLocalParam = record
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
  gLocalParam:TLocalParam;                              //���򻷾�����

//------------------------------------------------------------------------------
procedure InitSystemEnvironment;
//��ʼ��
procedure LoadSysParameter(const nIni: TIniFile = nil);
//��ȡ����
procedure AdminDBParam(const nRead: Boolean; nIni: TIniFile = nil);
//���ݿ����
function MakeDBConnection(const nParam: TLocalParam): string;
//���ݿ�����

procedure InitTableView(const nID: string; const nView: TcxGridTableView;
  const nIni: TIniFile = nil; const nViewID: string = '');
procedure SaveUserDefineTableView(const nID: string; const nView: TcxGridTableView;
  const nIni: TIniFile = nil; const nViewID: string = '');
//��ͷ����

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
    with gLocalParam, nTmp do
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
    with gLocalParam, nTmp do
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
function MakeDBConnection(const nParam: TLocalParam): string;
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
procedure UserDefineViewWidth(const nWidth: string; const nView: TcxGridTableView);
var nList: TStrings;
    i,nCount: integer;
begin
  nList := TStringList.Create;
  try
    nList.Text := StringReplace(nWidth, ';', #13, [rfReplaceAll]);
    if nList.Count <> nView.ColumnCount then Exit;

    nCount := nView.ColumnCount - 1;
    for i:=0 to nCount do
     if IsNumber(nList[i], False) then
       nView.Columns[i].Width := StrToInt(nList[i]);
    //xxxxx
  finally
    nList.Free;
  end;
end;

procedure InitTableViewStyle(const nView: TcxGridTableView);
var i,nCount: integer;
begin
  nView.OptionsData.Deleting := False;
  nView.OptionsData.Editing := True;
  nView.OptionsBehavior.ImmediateEditor := False;

  nView.OptionsView.Indicator := True;
  nView.OptionsCustomize.ColumnsQuickCustomization := True;

  nCount := nView.ColumnCount - 1;
  for i:=0 to nCount do
  begin
    if not Assigned(nView.Columns[i].Properties) then
      nView.Columns[i].PropertiesClass := TcxTextEditProperties;
    //xxxxx

    if nView.Columns[i].Properties is TcxCustomEditProperties then
      TcxCustomEditProperties(nView.Columns[i].Properties).ReadOnly := True;
    //����ֻ��
  end;
end;

procedure UserDefineViewIndex(const nIndex: string; const nView: TcxGridTableView);
var nList: TStrings;
    i,nCount,nIdx: integer;
begin
  nList := TStringList.Create;
  try
    nList.Text := StringReplace(nIndex, ';', #13, [rfReplaceAll]);
    if nList.Count <> nView.ColumnCount then Exit;
    nCount := nList.Count - 1;

    for i:=0 to nCount do
    begin
      nIdx := nList.IndexOf(IntToStr(nView.Columns[i].Tag));
      if nIdx > -1 then nView.Columns[i].Index := nIdx;
    end;
  finally
    nList.Free;
  end;
end;

procedure InitTableView(const nID: string; const nView: TcxGridTableView;
  const nIni: TIniFile = nil; const nViewID: string = '');
var nStr: string;
    nTmp: TIniFile;
begin
  if Assigned(nIni) then
       nTmp := nIni
  else nTmp := TIniFile.Create(gPath + sFormConfig);

  try
    InitTableViewStyle(nView);
    nStr := nTmp.ReadString(nID, 'GridWidth_' + nView.Name + nViewID, '');
    if nStr <> '' then UserDefineViewWidth(nStr, nView);
  finally
    if not Assigned(nIni) then nTmp.Free;
  end;
end;

procedure SaveUserDefineTableView(const nID: string; const nView: TcxGridTableView;
  const nIni: TIniFile = nil; const nViewID: string = '');
var nStr: string;
    nTmp: TIniFile;
    i,nCount: integer;
begin
  nCount := nView.ColumnCount - 1;
  if nCount < 0 then Exit;

  if Assigned(nIni) then
       nTmp := nIni
  else nTmp := TIniFile.Create(gPath + sFormConfig);
  try
    nStr := '';
    for i:=0 to nCount do
    begin
      nStr := nStr + IntToStr(nView.Columns[i].Width);
      if i <> nCount then nStr := nStr + ';';
    end;

    nTmp.WriteString(nID, 'GridWidth_' + nView.Name + nViewID, nStr);
  finally
    if not Assigned(nIni) then nTmp.Free;
  end;
end;

end.

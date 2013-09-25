{*******************************************************************************
  ����: dmzn@163.com 2013-07-06
  ����: system key update main
*******************************************************************************}
unit UFormUpdate;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, ADODB;

type
  TfFormMain = class(TForm)
    BtnOK: TButton;
    Label1: TLabel;
    ADOConn1: TADOConnection;
    Query1: TADOQuery;
    procedure BtnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    function ExecSQL(const nSQL: string): Integer;
  public
    { Public declarations }
  end;

var
  fFormMain: TfFormMain;

implementation

{$R *.dfm}

uses
  ULibFun, UFormConn, USysDB;

const
  {$DEFINE Stock}
  sValidDate          = '2013-10-10';
  sValidMD5           = '0c4a0ae8c70b6c94e2d8b0af4021dd60';
  //���ڽ���

  sValidNum           = '6';
  sValidNumMD5        = '956b761ea903a5e0540a8905c443db27';

  sValidName          = '����';
  sValidNameMD5       = '';

  sConfigFile         = 'Config.Ini';                //�������ļ�
  sFormConfig         = 'FormInfo.ini';              //��������
  sDBConfig           = 'DBConn.ini';                //��������

  {$IFDEF stock}
  cEnableDate         = True;
  cEnableNum          = False;
  cEnableName         = False;
  {$ENDIF}

  {$IFDEF js}
  cEnableDate         = True;
  cEnableNum          = True;
  cEnableName         = True;
  {$ENDIF}
  
var
  gPath: string;                                     //��������·��

procedure TfFormMain.FormCreate(Sender: TObject);
begin
  Randomize;
  ShortDateFormat := 'YYYY-MM-DD';
  gPath := ExtractFilePath(Application.ExeName);

  InitGlobalVariant(gPath, gPath + sConfigFile,
                           gPath + sFormConfig, gPath + sDBConfig);
  //xxxxx
end;

//Desc: ����nConnStr�Ƿ���Ч
function ConnCallBack(const nConnStr: string): Boolean;
begin
  with fFormMain do
  begin
    ADOConn1.Close;
    ADOConn1.ConnectionString := nConnStr;
    ADOConn1.Open;
    Result := ADOConn1.Connected;
  end;
end;

function TfFormMain.ExecSQL(const nSQL: string): Integer;
begin
  Query1.Close;
  Query1.SQL.Text := nSQL;
  Result := Query1.ExecSQL;
end;

procedure TfFormMain.BtnOKClick(Sender: TObject);
var nStr: string;
begin
  BtnOK.Enabled := False;
  try
    Application.ProcessMessages;
    if not ShowConnectDBSetupForm(ConnCallBack) then Exit;

    ADOConn1.Close;
    ADOConn1.ConnectionString := BuildConnectDBStr();
    ADOConn1.Open;

    if cEnableDate then
    begin
      nStr := 'Update %s Set D_Value=''%s'',D_ParamB=''%s'' ' +
              'Where D_Name=''%s'' And D_Memo=''%s''';
      nStr := Format(nStr, [sTable_SysDict, sValidDate, sValidMD5,
              'SysParam', 'SysValidDate']);
      ExecSQL(nStr);
    end;

    if cEnableNum then
    begin
      nStr := 'Update %s Set D_Value=''%s'',D_ParamB=''%s'' ' +
              'Where D_Name=''%s'' And D_Memo=''%s''';
      nStr := Format(nStr, [sTable_SysDict, sValidNum, sValidNumMD5,
              'SysParam', 'JSTunnelNum']);
      ExecSQL(nStr);
    end;

    if cEnableName then
    begin
      nStr := 'Update %s Set D_Value=''%s'' ' +
              'Where D_Name=''%s'' And D_Memo=''%s''';
      nStr := Format(nStr, [sTable_SysDict, sValidName,
              'SysParam', 'SysKeyName']);
      //xxxxx
    end;
    
    ExecSQL(nStr);
    ShowMsg('�������', '��ʾ');
  finally
    BtnOK.Enabled := True;
  end;
end;

end.

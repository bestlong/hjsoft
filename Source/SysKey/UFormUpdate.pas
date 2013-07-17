{*******************************************************************************
  作者: dmzn@163.com 2013-07-06
  描述: system key update main
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
  sValidDate          = '2014-10-08';
  sValidMD5           = '8ba042042c9b26027b77a8420df89ee4';
  //日期矫正

  sValidNum           = '4';
  sValidNumMD5        = '75b72485e91d3bcb95062c1e6c6ee0e7';

  sValidName          = '蒙西';
  sValidNameMD5       = '';

  sConfigFile         = 'Config.Ini';                //主配置文件
  sFormConfig         = 'FormInfo.ini';              //窗体配置
  sDBConfig           = 'DBConn.ini';                //数据连接

var
  gPath: string;                                     //程序所在路径

procedure TfFormMain.FormCreate(Sender: TObject);
begin
  Randomize;
  ShortDateFormat := 'YYYY-MM-DD';
  gPath := ExtractFilePath(Application.ExeName);

  InitGlobalVariant(gPath, gPath + sConfigFile,
                           gPath + sFormConfig, gPath + sDBConfig);
  //xxxxx
end;

//Desc: 测试nConnStr是否有效
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

    nStr := 'Update %s Set D_Value=''%s'',D_ParamB=''%s'' ' +
            'Where D_Name=''%s'' And D_Memo=''%s''';
    nStr := Format(nStr, [sTable_SysDict, sValidDate, sValidMD5,
            'SysParam', 'SysValidDate']);
    ExecSQL(nStr);

    nStr := 'Update %s Set D_Value=''%s'',D_ParamB=''%s'' ' +
            'Where D_Name=''%s'' And D_Memo=''%s''';
    nStr := Format(nStr, [sTable_SysDict, sValidNum, sValidNumMD5,
            'SysParam', 'JSTunnelNum']);
    ExecSQL(nStr);

    nStr := 'Update %s Set D_Value=''%s'' ' +
            'Where D_Name=''%s'' And D_Memo=''%s''';
    nStr := Format(nStr, [sTable_SysDict, sValidName,
            'SysParam', 'SysKeyName']);
    //xxxxx
    
    ExecSQL(nStr);
    ShowMsg('更新完毕', '提示');
  finally
    BtnOK.Enabled := True;
  end;
end;

end.

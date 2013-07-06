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
  sValidDate          = '2013-09-20';
  sValidMD5           = '0c6c11c11a3da15b1ae0e3fbd96c5545';
  //���ڽ���

  sConfigFile         = 'Config.Ini';                //�������ļ�
  sFormConfig         = 'FormInfo.ini';              //��������
  sDBConfig           = 'DBConn.ini';                //��������

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
    //xxxxx

    Query1.Close;
    Query1.SQL.Text := nStr;
    Query1.ExecSQL;
    ShowMsg('�������', '��ʾ');
  finally
    BtnOK.Enabled := True;
  end;
end;

end.

unit UFormMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TfFormMain = class(TForm)
    wPage: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label1: TLabel;
    EditDS: TEdit;
    BtnGetDS: TButton;
    Label2: TLabel;
    MemoDS: TMemo;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    EditSys: TComboBox;
    Label4: TLabel;
    BtnGetTime: TButton;
    Label5: TLabel;
    MemoTime: TMemo;
    EditTime: TDateTimePicker;
    Label6: TLabel;
    EditKey: TEdit;
    TabSheet3: TTabSheet;
    Label7: TLabel;
    Label8: TLabel;
    EditText: TEdit;
    BtnGetTxt: TButton;
    MemoText: TMemo;
    procedure BtnGetDSClick(Sender: TObject);
    procedure BtnGetTimeClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure EditSysChange(Sender: TObject);
    procedure BtnGetTxtClick(Sender: TObject);
  private
    { Private declarations }
    function GetPrefix: string;
    //前缀
  public
    { Public declarations }
  end;

var
  fFormMain: TfFormMain;

implementation

{$R *.dfm}
uses
  ULibFun, ZnMD5, ZnCRC;

procedure TfFormMain.FormCreate(Sender: TObject);
begin
  EditTime.Date := Date();
  wPage.ActivePageIndex := 0;
  EditSys.ItemIndex := 0;
end;

//Desc: 获取不同配置对象的前缀
function TfFormMain.GetPrefix: string;
begin
  Result := 'dmzn_';

  case EditSys.ItemIndex of
    0: Result := 'dmzn_stock_';
    1: Result := 'dmzn_js_' + EditKey.Text + '_';
  end;
end;

//Desc: 系统切换
procedure TfFormMain.EditSysChange(Sender: TObject);
begin
  case EditSys.ItemIndex of
    0:
     begin
       EditKey.Text := '';
       EditKey.ReadOnly := True;
     end;
    1:
     begin
       EditKey.ReadOnly := False;
     end;
  end;
end;

//Desc: 获取道数
procedure TfFormMain.BtnGetDSClick(Sender: TObject);
var nStr: string;
begin
  EditDS.Text := Trim(EditDS.Text);
  if not IsNumber(EditDS.Text, False) then
  begin
    EditDS.SetFocus;
    ShowDlg('请输入有效的数值', ''); Exit;
  end;

  nStr := GetPrefix + EditDS.Text;
  MemoDS.Text := MD5Print(MD5String(nStr));
end;

//Desc: 获取到期时间
procedure TfFormMain.BtnGetTimeClick(Sender: TObject);
var nStr: string;
begin
  nStr := GetPrefix + Date2Str(EditTime.Date);
  MemoTime.Text := MD5Print(MD5String(nStr));
end;

//Desc: 获取文本
procedure TfFormMain.BtnGetTxtClick(Sender: TObject);
var nStr: string;
begin
  nStr := Trim(EditText.Text);
  if nStr = '' then
  begin
    EditText.SetFocus;
    ShowDlg('请输入有效的内容', ''); Exit;
  end;

  MemoText.Text := MD5Print(MD5String(nStr));
end;

end.

{*******************************************************************************
  作者: dmzn@163.com 2011-4-16
  描述: 倒计时窗口
*******************************************************************************}
unit UFormDTimer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfFormDTimer = class(TForm)
    Timer1: TTimer;
    LabelHint: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormPaint(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
    FMousePos: TPoint;
    //鼠标位置
    FCounter: Word;
    //计数对象
    FBackFormImage: TBitmap;
    //背景窗体内容
    procedure LabelAutoPositon;
    //调整位置
    procedure FillBackFormClient(const nForm: TForm);
    //覆盖背景
    procedure ExitDTimer(const nOK: Boolean);
    //终止计时
  public
    { Public declarations }
  end;

function ShowDTimer(const nMain: TForm; const nSecond: Word): Boolean;

implementation

{$R *.dfm}

function ShowDTimer(const nMain: TForm; const nSecond: Word): Boolean;
begin
  with TfFormDTimer.Create(Application) do
  try
    FCounter := nSecond;
    FillBackFormClient(nMain);
    Result := ShowModal = mrOk;
  finally
    Free;
  end;
end;

procedure TfFormDTimer.FormCreate(Sender: TObject);
begin
  DoubleBuffered := True;
  FBackFormImage := TBitmap.Create;

  LabelHint.Font.Size := 200;
  LabelHint.Font.Color := clRed;
end;

procedure TfFormDTimer.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  FBackFormImage.Free;
end;

//------------------------------------------------------------------------------
procedure TfFormDTimer.LabelAutoPositon;
begin
  LabelHint.Left := Trunc((ClientWidth - LabelHint.Width) / 2);
  LabelHint.Top := Trunc((ClientHeight - LabelHint.Height) / 2);
end;

procedure TfFormDTimer.FillBackFormClient(const nForm: TForm);
var nR: TRect;
    nCanvas: TCanvas;
begin
  ClientWidth := nForm.ClientWidth;
  ClientHeight := nForm.ClientHeight;

  LabelHint.Caption := IntToStr(FCounter);
  LabelAutoPositon;

  FMousePos := Mouse.CursorPos;
  nR.TopLeft := nForm.ClientToScreen(Point(0, 0));
  
  Top := nR.Top;
  Left := nR.Left;
                
  nCanvas := TCanvas.Create;
  try
    FBackFormImage.Width := ClientWidth;
    FBackFormImage.Height := ClientHeight;

    nCanvas.Handle := GetDC(0);
    nR.BottomRight := Point(nR.Left + ClientWidth, nR.Top + ClientHeight);
    FBackFormImage.Canvas.CopyRect(Rect(0, 0, ClientWidth, ClientHeight), nCanvas, nR);
  finally
    nCanvas.Free;
  end;
end;

procedure TfFormDTimer.FormPaint(Sender: TObject);
begin
  Canvas.Draw(0, 0, FBackFormImage);
end;

procedure TfFormDTimer.ExitDTimer(const nOK: Boolean);
begin
  Sleep(320);
  if nOK then ModalResult := mrOk else Close;
end;

procedure TfFormDTimer.FormMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if (Mouse.CursorPos.X <> FMousePos.X) or
     (Mouse.CursorPos.Y <> FMousePos.Y) then ExitDTimer(False);
end;

procedure TfFormDTimer.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Key := 0;
  ExitDTimer(False);
end;

procedure TfFormDTimer.Timer1Timer(Sender: TObject);
begin
  Dec(FCounter);
  LabelHint.Caption := IntToStr(FCounter);
  LabelAutoPositon;
  
  if FCounter = 0 then
  begin
    Timer1.Enabled := False;
    ExitDTimer(True);
  end;
end;

end.

object fFormDTimer: TfFormDTimer
  Left = 351
  Top = 206
  BorderStyle = bsNone
  ClientHeight = 409
  ClientWidth = 603
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  WindowState = wsMaximized
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnMouseMove = FormMouseMove
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 12
  object LabelHint: TLabel
    Left = 262
    Top = 168
    Width = 18
    Height = 12
    Caption = 'xxx'
    Transparent = True
    OnMouseMove = FormMouseMove
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 166
    Top = 66
  end
end

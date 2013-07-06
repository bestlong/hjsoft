object fFormMain: TfFormMain
  Left = 429
  Top = 493
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Key'
  ClientHeight = 125
  ClientWidth = 305
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 15
  object Label1: TLabel
    Left = 10
    Top = 24
    Width = 234
    Height = 15
    Caption = #35831#28857#20987#8220#21319#32423#8221#25353#38062#26356#26032#31995#32479'Key'#65306
  end
  object BtnOK: TButton
    Left = 110
    Top = 76
    Width = 75
    Height = 25
    Caption = #21319#32423
    TabOrder = 0
    OnClick = BtnOKClick
  end
  object ADOConn1: TADOConnection
    Left = 14
    Top = 66
  end
  object Query1: TADOQuery
    Connection = ADOConn1
    Parameters = <>
    Left = 42
    Top = 66
  end
end

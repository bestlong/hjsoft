object fFormMain: TfFormMain
  Left = 777
  Top = 510
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #21442#25968#38145
  ClientHeight = 240
  ClientWidth = 300
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object wPage: TPageControl
    Left = 0
    Top = 0
    Width = 300
    Height = 173
    ActivePage = TabSheet3
    Align = alClient
    Style = tsFlatButtons
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = #35013#36710#36947#25968
      DesignSize = (
        292
        143)
      object Label1: TLabel
        Left = 8
        Top = 15
        Width = 102
        Height = 12
        Caption = #35831#36755#20837#26377#25928#30340#36947#25968':'
      end
      object Label2: TLabel
        Left = 8
        Top = 65
        Width = 30
        Height = 12
        Caption = #32467#26524':'
      end
      object EditDS: TEdit
        Left = 8
        Top = 32
        Width = 215
        Height = 20
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
      end
      object BtnGetDS: TButton
        Left = 232
        Top = 30
        Width = 55
        Height = 22
        Anchors = [akTop, akRight]
        Caption = #33719#21462
        TabOrder = 1
        OnClick = BtnGetDSClick
      end
      object MemoDS: TMemo
        Left = 8
        Top = 82
        Width = 279
        Height = 57
        Anchors = [akLeft, akTop, akRight, akBottom]
        TabOrder = 2
      end
    end
    object TabSheet2: TTabSheet
      Caption = #26377#25928#26102#38388
      ImageIndex = 1
      DesignSize = (
        292
        143)
      object Label4: TLabel
        Left = 8
        Top = 15
        Width = 102
        Height = 12
        Caption = #35831#36755#20837#26377#25928#30340#26085#26399':'
      end
      object Label5: TLabel
        Left = 8
        Top = 65
        Width = 30
        Height = 12
        Caption = #32467#26524':'
      end
      object BtnGetTime: TButton
        Left = 232
        Top = 30
        Width = 55
        Height = 22
        Anchors = [akTop, akRight]
        Caption = #33719#21462
        TabOrder = 1
        OnClick = BtnGetTimeClick
      end
      object MemoTime: TMemo
        Left = 8
        Top = 82
        Width = 279
        Height = 57
        Anchors = [akLeft, akTop, akRight, akBottom]
        TabOrder = 2
      end
      object EditTime: TDateTimePicker
        Left = 8
        Top = 32
        Width = 215
        Height = 20
        Anchors = [akLeft, akTop, akRight]
        Date = 40653.545050266210000000
        Time = 40653.545050266210000000
        DateMode = dmUpDown
        TabOrder = 0
      end
    end
    object TabSheet3: TTabSheet
      Caption = #24120#35268'MD5'
      ImageIndex = 2
      DesignSize = (
        292
        143)
      object Label7: TLabel
        Left = 8
        Top = 15
        Width = 102
        Height = 12
        Caption = #35831#36755#20837#24453#36816#31639#20869#23481':'
      end
      object Label8: TLabel
        Left = 8
        Top = 65
        Width = 30
        Height = 12
        Caption = #32467#26524':'
      end
      object EditText: TEdit
        Left = 8
        Top = 32
        Width = 215
        Height = 20
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
      end
      object BtnGetTxt: TButton
        Left = 232
        Top = 30
        Width = 55
        Height = 22
        Anchors = [akTop, akRight]
        Caption = #33719#21462
        TabOrder = 1
        OnClick = BtnGetTxtClick
      end
      object MemoText: TMemo
        Left = 8
        Top = 82
        Width = 279
        Height = 57
        Anchors = [akLeft, akTop, akRight, akBottom]
        TabOrder = 2
      end
    end
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 173
    Width = 300
    Height = 67
    Align = alBottom
    TabOrder = 1
    object Label3: TLabel
      Left = 12
      Top = 16
      Width = 72
      Height = 12
      Caption = #8251'.'#37197#32622#23545#35937':'
    end
    object Label6: TLabel
      Left = 12
      Top = 42
      Width = 72
      Height = 12
      Caption = #8251'.'#23545#35937#35782#21035':'
    end
    object EditSys: TComboBox
      Left = 87
      Top = 13
      Width = 155
      Height = 20
      Style = csDropDownList
      ItemHeight = 12
      TabOrder = 0
      OnChange = EditSysChange
      Items.Strings = (
        '1.'#27700#27877#38144#21806#31995#32479
        '2.'#35013#36710#35745#25968#31995#32479)
    end
    object EditKey: TEdit
      Left = 87
      Top = 38
      Width = 155
      Height = 20
      TabOrder = 1
    end
  end
end

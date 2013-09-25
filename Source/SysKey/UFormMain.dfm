object fFormMain: TfFormMain
  Left = 777
  Top = 510
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #21442#25968#38145
  ClientHeight = 300
  ClientWidth = 375
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = #23435#20307
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 15
  object wPage: TPageControl
    Left = 0
    Top = 0
    Width = 375
    Height = 216
    ActivePage = TabSheet3
    Align = alClient
    Style = tsFlatButtons
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = #35013#36710#36947#25968
      DesignSize = (
        367
        183)
      object Label1: TLabel
        Left = 10
        Top = 19
        Width = 128
        Height = 15
        Caption = #35831#36755#20837#26377#25928#30340#36947#25968':'
      end
      object Label2: TLabel
        Left = 10
        Top = 81
        Width = 38
        Height = 15
        Caption = #32467#26524':'
      end
      object EditDS: TEdit
        Left = 10
        Top = 40
        Width = 269
        Height = 20
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
      end
      object BtnGetDS: TButton
        Left = 290
        Top = 38
        Width = 69
        Height = 27
        Anchors = [akTop, akRight]
        Caption = #33719#21462
        TabOrder = 1
        OnClick = BtnGetDSClick
      end
      object MemoDS: TMemo
        Left = 10
        Top = 103
        Width = 349
        Height = 71
        Anchors = [akLeft, akTop, akRight, akBottom]
        TabOrder = 2
      end
    end
    object TabSheet2: TTabSheet
      Caption = #26377#25928#26102#38388
      ImageIndex = 1
      DesignSize = (
        367
        183)
      object Label4: TLabel
        Left = 10
        Top = 19
        Width = 128
        Height = 15
        Caption = #35831#36755#20837#26377#25928#30340#26085#26399':'
      end
      object Label5: TLabel
        Left = 10
        Top = 81
        Width = 38
        Height = 15
        Caption = #32467#26524':'
      end
      object BtnGetTime: TButton
        Left = 290
        Top = 38
        Width = 69
        Height = 27
        Anchors = [akTop, akRight]
        Caption = #33719#21462
        TabOrder = 1
        OnClick = BtnGetTimeClick
      end
      object MemoTime: TMemo
        Left = 10
        Top = 103
        Width = 349
        Height = 71
        Anchors = [akLeft, akTop, akRight, akBottom]
        TabOrder = 2
      end
      object EditTime: TDateTimePicker
        Left = 10
        Top = 40
        Width = 269
        Height = 23
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
        367
        183)
      object Label7: TLabel
        Left = 10
        Top = 19
        Width = 128
        Height = 15
        Caption = #35831#36755#20837#24453#36816#31639#20869#23481':'
      end
      object Label8: TLabel
        Left = 10
        Top = 81
        Width = 38
        Height = 15
        Caption = #32467#26524':'
      end
      object EditText: TEdit
        Left = 10
        Top = 40
        Width = 269
        Height = 23
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
      end
      object BtnGetTxt: TButton
        Left = 290
        Top = 38
        Width = 69
        Height = 27
        Anchors = [akTop, akRight]
        Caption = #33719#21462
        TabOrder = 1
        OnClick = BtnGetTxtClick
      end
      object MemoText: TMemo
        Left = 10
        Top = 103
        Width = 349
        Height = 71
        Anchors = [akLeft, akTop, akRight, akBottom]
        TabOrder = 2
      end
    end
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 216
    Width = 375
    Height = 84
    Align = alBottom
    TabOrder = 1
    object Label3: TLabel
      Left = 15
      Top = 20
      Width = 91
      Height = 15
      Caption = #8251'.'#37197#32622#23545#35937':'
    end
    object Label6: TLabel
      Left = 15
      Top = 53
      Width = 91
      Height = 15
      Caption = #8251'.'#23545#35937#35782#21035':'
    end
    object EditSys: TComboBox
      Left = 109
      Top = 16
      Width = 194
      Height = 23
      Style = csDropDownList
      ItemHeight = 15
      TabOrder = 0
      OnChange = EditSysChange
      Items.Strings = (
        '1.'#27700#27877#38144#21806#31995#32479
        '2.'#35013#36710#35745#25968#31995#32479)
    end
    object EditKey: TEdit
      Left = 109
      Top = 48
      Width = 194
      Height = 23
      TabOrder = 1
    end
  end
end

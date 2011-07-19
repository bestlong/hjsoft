object fFormWeight: TfFormWeight
  Left = 297
  Top = 189
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  ClientHeight = 244
  ClientWidth = 311
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object dxLayoutControl1: TdxLayoutControl
    Left = 0
    Top = 0
    Width = 311
    Height = 244
    Align = alClient
    TabOrder = 0
    TabStop = False
    AutoContentSizes = [acsWidth, acsHeight]
    LookAndFeel = FDM.dxLayoutWeb1
    object BtnExit: TButton
      Left = 235
      Top = 211
      Width = 65
      Height = 22
      Caption = #21462#28040
      ModalResult = 2
      TabOrder = 5
    end
    object BtnOK: TButton
      Left = 165
      Top = 211
      Width = 65
      Height = 22
      Caption = #30830#23450
      TabOrder = 4
      OnClick = BtnOKClick
    end
    object EditPort: TcxComboBox
      Left = 81
      Top = 36
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.DropDownRows = 15
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      Properties.ItemHeight = 18
      Properties.OnChange = EditPortPropertiesChange
      TabOrder = 0
      Width = 200
    end
    object EditType: TcxComboBox
      Left = 81
      Top = 86
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.DropDownRows = 15
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      Properties.ItemHeight = 18
      Properties.OnChange = EditPortPropertiesChange
      TabOrder = 2
      Width = 121
    end
    object LabelValue: TcxLabel
      Left = 23
      Top = 143
      Align = alClient
      AutoSize = False
      Caption = '0'
      ParentFont = False
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -32
      Style.Font.Name = #23435#20307
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
      Properties.Alignment.Horz = taCenter
      Properties.Alignment.Vert = taVCenter
      Transparent = True
      Height = 50
      Width = 258
      AnchorX = 152
      AnchorY = 168
    end
    object EditBote: TcxComboBox
      Left = 81
      Top = 61
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.DropDownRows = 15
      Properties.ItemHeight = 18
      Properties.Items.Strings = (
        '300'
        '600'
        '1200'
        '1800'
        '2400'
        '4800'
        '7200'
        '9600'
        '14400'
        '19200'
        '38400')
      Properties.ReadOnly = False
      Properties.OnChange = EditPortPropertiesChange
      TabOrder = 1
      Width = 121
    end
    object dxLayoutControl1Group_Root: TdxLayoutGroup
      ShowCaption = False
      Hidden = True
      ShowBorder = False
      object dxGroup1: TdxLayoutGroup
        Caption = #22320#30917#20449#24687
        object dxLayoutControl1Item1: TdxLayoutItem
          Caption = #36830#25509#31471#21475':'
          Control = EditPort
          ControlOptions.ShowBorder = False
        end
        object dxLayoutControl1Item4: TdxLayoutItem
          Caption = #20256#36755#36895#29575':'
          Control = EditBote
          ControlOptions.ShowBorder = False
        end
        object dxLayoutControl1Item2: TdxLayoutItem
          Caption = #22320#30917#22411#21495':'
          Control = EditType
          ControlOptions.ShowBorder = False
        end
      end
      object dxGroup2: TdxLayoutGroup
        AutoAligns = [aaHorizontal]
        AlignVert = avClient
        object dxLayoutControl1Item3: TdxLayoutItem
          AutoAligns = [aaHorizontal]
          AlignVert = avClient
          Caption = 'cxLabel1'
          ShowCaption = False
          Control = LabelValue
          ControlOptions.ShowBorder = False
        end
      end
      object dxLayoutControl1Group1: TdxLayoutGroup
        AutoAligns = [aaHorizontal]
        AlignVert = avBottom
        ShowCaption = False
        Hidden = True
        LayoutDirection = ldHorizontal
        ShowBorder = False
        object dxLayoutControl1Item8: TdxLayoutItem
          AutoAligns = [aaVertical]
          AlignHorz = ahRight
          Caption = 'Button2'
          ShowCaption = False
          Control = BtnOK
          ControlOptions.ShowBorder = False
        end
        object dxLayoutControl1Item7: TdxLayoutItem
          AutoAligns = []
          AlignHorz = ahRight
          AlignVert = avBottom
          Caption = 'Button1'
          ShowCaption = False
          Control = BtnExit
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
  object comWeight: TComm
    CommName = 'COM1'
    BaudRate = 2400
    ParityCheck = False
    Outx_CtsFlow = False
    Outx_DsrFlow = False
    DtrControl = DtrEnable
    DsrSensitivity = False
    TxContinueOnXoff = True
    Outx_XonXoffFlow = True
    Inx_XonXoffFlow = True
    ReplaceWhenParityError = False
    IgnoreNullChar = False
    RtsControl = RtsEnable
    XonLimit = 500
    XoffLimit = 500
    ByteSize = _8
    Parity = None
    StopBits = _1
    XonChar = #17
    XoffChar = #19
    ReplacedChar = #0
    ReadIntervalTimeout = 3
    ReadTotalTimeoutMultiplier = 0
    ReadTotalTimeoutConstant = 0
    WriteTotalTimeoutMultiplier = 0
    WriteTotalTimeoutConstant = 0
    OnReceiveData = comWeightReceiveData
    Left = 14
    Top = 138
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 1500
    OnTimer = Timer1Timer
    Left = 42
    Top = 138
  end
end

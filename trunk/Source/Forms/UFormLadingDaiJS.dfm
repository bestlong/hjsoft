inherited fFormLadingDaiJiShu: TfFormLadingDaiJiShu
  Left = 238
  Top = 143
  Width = 655
  Height = 425
  BorderIcons = [biSystemMenu, biMinimize]
  Constraints.MaxHeight = 525
  Constraints.MinHeight = 425
  Constraints.MinWidth = 655
  OldCreateOrder = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 12
  object dxLayoutControl1: TdxLayoutControl
    Left = 0
    Top = 0
    Width = 647
    Height = 391
    Align = alClient
    TabOrder = 0
    TabStop = False
    AutoContentSizes = [acsWidth, acsHeight]
    AutoControlAlignment = False
    LookAndFeel = FDM.dxLayoutWeb1
    object BtnRefresh: TButton
      Left = 554
      Top = 36
      Width = 70
      Height = 22
      Caption = #21047#26032#21015#34920
      TabOrder = 1
      OnClick = BtnRefreshClick
    end
    object BtnSetup: TButton
      Left = 23
      Top = 36
      Width = 70
      Height = 22
      Caption = #26632#21488#21442#25968
      TabOrder = 0
      OnClick = BtnSetupClick
    end
    object ListTruck: TcxListView
      Left = 23
      Top = 63
      Width = 601
      Height = 182
      Columns = <
        item
          Caption = #29366#24577
        end
        item
          Caption = #26632#21488#20301#32622
        end
        item
          Caption = #36710#29260#21495
        end
        item
          Caption = #27700#27877#21517#31216
        end
        item
          Caption = #25552#36135#37327'('#21544')'
        end
        item
          Alignment = taCenter
          Caption = #25552#36135#34955#25968
        end
        item
          Alignment = taCenter
          Caption = #34917#24046#34955#25968
        end
        item
          Alignment = taCenter
          Caption = #24050#35013'/'#21097#20313
        end>
      HideSelection = False
      ParentFont = False
      PopupMenu = PMenu1
      ReadOnly = True
      RowSelect = True
      SmallImages = ImageList1
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -15
      Style.Font.Name = #23435#20307
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
      TabOrder = 2
      ViewStyle = vsReport
      OnClick = ListTruckClick
    end
    object EditTruck: TcxTextEdit
      Left = 299
      Top = 320
      ParentFont = False
      Properties.ReadOnly = True
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -16
      Style.Font.Name = #23435#20307
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
      TabOrder = 5
      Width = 325
    end
    object EditValue: TcxTextEdit
      Left = 299
      Top = 349
      ParentFont = False
      Properties.OnChange = EditValuePropertiesChange
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -16
      Style.Font.Name = #23435#20307
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
      TabOrder = 6
      Width = 92
    end
    object EditDS: TcxButtonEdit
      Left = 454
      Top = 349
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditDSPropertiesButtonClick
      Properties.OnChange = EditDSPropertiesChange
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -16
      Style.Font.Name = #23435#20307
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
      TabOrder = 7
      Width = 92
    end
    object BtnStart: TButton
      Left = 551
      Top = 349
      Width = 72
      Height = 22
      Caption = #24320#22987#35745#25968
      TabOrder = 8
      OnClick = BtnStartClick
    end
    object EditZTLine: TcxTextEdit
      Left = 299
      Top = 291
      ParentFont = False
      Properties.ReadOnly = True
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -16
      Style.Font.Name = #23435#20307
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
      TabOrder = 4
      Width = 325
    end
    object Radio1: TcxRadioGroup
      Left = 23
      Top = 291
      Caption = #26632#21488#20301#32622
      ParentFont = False
      Properties.Items = <>
      Properties.OnEditValueChanged = Radio1PropertiesEditValueChanged
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -13
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 3
      Height = 82
      Width = 220
    end
    object dxLayoutControl1Group_Root: TdxLayoutGroup
      ShowCaption = False
      Hidden = True
      ShowBorder = False
      object dxGroup1: TdxLayoutGroup
        AutoAligns = [aaHorizontal]
        AlignVert = avClient
        Caption = #26632#21488#36710#36742#21015#34920
        object dxLayoutControl1Group2: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayoutControl1Item4: TdxLayoutItem
            AutoAligns = [aaVertical]
            Caption = 'New Item'
            ShowCaption = False
            Control = BtnSetup
            ControlOptions.ShowBorder = False
          end
          object dxLayoutControl1Item2: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahRight
            ShowCaption = False
            Control = BtnRefresh
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayoutControl1Item5: TdxLayoutItem
          AutoAligns = [aaHorizontal]
          AlignVert = avClient
          Caption = 'cxListView1'
          ShowCaption = False
          Control = ListTruck
          ControlOptions.ShowBorder = False
        end
      end
      object dxGroup2: TdxLayoutGroup
        AutoAligns = [aaHorizontal]
        AlignVert = avBottom
        Caption = #35745#25968#22120
        LayoutDirection = ldHorizontal
        object dxLayoutControl1Item6: TdxLayoutItem
          AutoAligns = [aaVertical]
          AlignHorz = ahClient
          Caption = 'cxRadioGroup1'
          ShowCaption = False
          Control = Radio1
          ControlOptions.ShowBorder = False
        end
        object dxLayoutControl1Group3: TdxLayoutGroup
          AutoAligns = [aaVertical]
          AlignHorz = ahRight
          ShowCaption = False
          Hidden = True
          ShowBorder = False
          object dxLayoutControl1Item11: TdxLayoutItem
            AutoAligns = [aaVertical]
            Caption = #35013#36710#32447':'
            Control = EditZTLine
            ControlOptions.ShowBorder = False
          end
          object dxLayoutControl1Item7: TdxLayoutItem
            AutoAligns = [aaVertical]
            Caption = #36710#29260#21495':'
            Control = EditTruck
            ControlOptions.ShowBorder = False
          end
          object dxLayoutControl1Group1: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayoutControl1Item8: TdxLayoutItem
              Caption = #25552#36135#37327':'
              Control = EditValue
              ControlOptions.ShowBorder = False
            end
            object dxLayoutControl1Item9: TdxLayoutItem
              Caption = #25552#36135#34955#25968':'
              Control = EditDS
              ControlOptions.ShowBorder = False
            end
            object dxLayoutControl1Item10: TdxLayoutItem
              Caption = 'Button1'
              ShowCaption = False
              Control = BtnStart
              ControlOptions.ShowBorder = False
            end
          end
        end
      end
    end
  end
  object ImageList1: TImageList
    Height = 18
    Width = 18
    Left = 32
    Top = 90
    Bitmap = {
      494C010101000400040012001200FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000480000001200000001002000000000004014
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000CCCCCC005858
      58005F5F5F00B3B3B300585858005F5F5F00DEDEDE0000000000000000000000
      0000CCCCCC00585858005F5F5F00DEDEDE000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000434343006363
      63006B6B6B002F2F2F006E6E6E005B5B5B005F5F5F0000000000000000000000
      000043434300636363005B5B5B005F5F5F000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000002F4355002D4254002B40
      5200293F5100273D5000253C4F00243B4D00223A4C0021394B0020384B00513A
      2900503928004F3727004E3626004D3525000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000457FB70094BFDE008FBC
      DC008BB9DA0086B5D90082B2D7007EB0D6007AADD40077AAD30074A8D300A966
      3100ECD4BF00EBD2BC00EAD1B9009B5523000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000004D85BD009AC3E10078AF
      D60072ABD3006DA7D10067A3CF00629FCD005C9BCB005798CA0079ACD400AE6C
      3500EDD8C400E1BB9A00EBD4BE009F5A27000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000548AC200A0C9E30081B5
      D9007BB1D70076ADD50070A9D2006AA5D00064A1CE005F9DCC007EB0D600B372
      3A00EFDCCA00EEDAC800FFF6EF00A4602C000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000005B8FC800DDB37B00D099
      5300CE935000CB8D4C00C8874900C4804500C27A4200BF743E00CB8E6600B878
      3F00EED3BB00FFF2E700FFF6F000A96631000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000006193CC00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00BC7D
      4300EFD7C100EED5BE00E2BFA200B37643000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000006797D000B1D5E80097C5
      E10093C2E0008EBEDE0089BBDC0084B7DA007EB3D80078AFD60091BDDD00C082
      4600BD7F4400BA7B4100B7784000E0C6B0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000006C9BD400B5D7EA00B2D6
      E900B0D3E800ACD1E700A9CFE500A5CCE400A0C9E3009CC5E10098C2E0003675
      AD00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000007EA8DB006C9BD4006999
      D2006596CF006093CC005B8FC800558BC3005087BF004A83BB00447EB600729E
      C700000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000048000000120000000100010000000000D80000000000000000000000
      000000000000000000000000FFFFFF00FFFFC0000000000000000000FFFFC000
      0000000000000000FFFFC0000000000000000000FFFFC0000000000000000000
      C070C0000000000000000000C070C00000000000000000008000C00000000000
      000000008000C00000000000000000008000C00000000000000000008000C000
      00000000000000008000C00000000000000000008000C0000000000000000000
      8000C0000000000000000000800FC0000000000000000000800FC00000000000
      00000000FFFFC0000000000000000000FFFFC0000000000000000000FFFFC000
      000000000000000000000000000000000000000000000000000000000000}
  end
  object PMenu1: TPopupMenu
    AutoHotkeys = maManual
    Left = 60
    Top = 90
    object N1: TMenuItem
      Caption = #37325#32622#35745#25968#22120
      OnClick = N1Click
    end
  end
end

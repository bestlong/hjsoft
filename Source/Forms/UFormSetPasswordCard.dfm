inherited fFormSetPasswordCard: TfFormSetPasswordCard
  Left = 830
  Top = 178
  ClientHeight = 295
  ClientWidth = 329
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 329
    Height = 295
    inherited BtnOK: TButton
      Left = 183
      Top = 262
      Caption = #30830#23450
      TabOrder = 9
    end
    inherited BtnExit: TButton
      Left = 253
      Top = 262
      TabOrder = 10
    end
    object EditNew: TcxTextEdit [2]
      Left = 81
      Top = 36
      ParentFont = False
      Properties.EchoMode = eemPassword
      Properties.MaxLength = 16
      Properties.PasswordChar = '*'
      TabOrder = 0
      Width = 105
    end
    object EditNext: TcxTextEdit [3]
      Left = 81
      Top = 61
      ParentFont = False
      Properties.EchoMode = eemPassword
      Properties.MaxLength = 16
      Properties.PasswordChar = '*'
      TabOrder = 1
      Width = 121
    end
    object EditMax: TcxTextEdit [4]
      Left = 81
      Top = 150
      ParentFont = False
      TabOrder = 3
      Width = 82
    end
    object EditTime: TcxTextEdit [5]
      Left = 226
      Top = 150
      ParentFont = False
      TabOrder = 4
      Width = 125
    end
    object cxLabel1: TcxLabel [6]
      Left = 23
      Top = 175
      Caption = #25552#31034':"'#38480#24320#27425#25968'"'#20026'0'#26102#34920#31034#19981#38480#21046#35813#21345#24320#25552#36135#21333'.'
      ParentFont = False
      Transparent = True
    end
    object cxLabel2: TcxLabel [7]
      Left = 23
      Top = 196
      AutoSize = False
      ParentFont = False
      Properties.LineOptions.Alignment = cxllaBottom
      Properties.LineOptions.Visible = True
      Transparent = True
      Height = 8
      Width = 322
    end
    object EditTruck: TcxTextEdit [8]
      Left = 81
      Top = 209
      ParentFont = False
      Properties.MaxLength = 15
      TabOrder = 7
      Width = 121
    end
    object cxLabel3: TcxLabel [9]
      Left = 23
      Top = 234
      Caption = #25552#31034':'#24403#25552#36135#21333#36710#36742#20026#35813#36710#29260#21495#26102#35813#30913#21345#21487#36827#21378#25552#36135'.'
      ParentFont = False
      Transparent = True
    end
    object Check1: TcxCheckBox [10]
      Left = 23
      Top = 124
      Caption = #35813#30913#21345#19981#33021#24320#25552#36135#21333','#20165#29992#20110#21496#26426#36827#21378#25552#36135'.'
      ParentFont = False
      TabOrder = 2
      Transparent = True
      Width = 150
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        Caption = #23494#30721#35774#32622
        object dxLayout1Item3: TdxLayoutItem
          Caption = #36755#20837#23494#30721':'
          Control = EditNew
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item4: TdxLayoutItem
          AutoAligns = [aaVertical]
          AlignHorz = ahClient
          Caption = #20877#36755#19968#27425':'
          Control = EditNext
          ControlOptions.ShowBorder = False
        end
      end
      object dxGroup2: TdxLayoutGroup [1]
        AutoAligns = [aaHorizontal]
        AlignVert = avBottom
        Caption = #25552#36135#35774#32622
        object dxLayout1Group2: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          ShowBorder = False
          object dxLayout1Item8: TdxLayoutItem
            Caption = 'cxCheckBox1'
            ShowCaption = False
            Control = Check1
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Group3: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayout1Item5: TdxLayoutItem
              Caption = #38480#24320#27425#25968':'
              Control = EditMax
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item6: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahClient
              Caption = #24050#24320#27425#25968':'
              Control = EditTime
              ControlOptions.ShowBorder = False
            end
          end
        end
        object dxLayout1Item7: TdxLayoutItem
          AutoAligns = [aaVertical]
          AlignHorz = ahClient
          Caption = 'cxLabel1'
          ShowCaption = False
          Control = cxLabel1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item9: TdxLayoutItem
          Caption = 'cxLabel2'
          ShowCaption = False
          Control = cxLabel2
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item10: TdxLayoutItem
          Caption = #25552#36135#36710#36742':'
          Control = EditTruck
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item11: TdxLayoutItem
          Caption = 'cxLabel3'
          ShowCaption = False
          Control = cxLabel3
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end

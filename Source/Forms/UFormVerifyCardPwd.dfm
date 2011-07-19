inherited fFormVerifyCardPwd: TfFormVerifyCardPwd
  Left = 334
  Top = 253
  ClientHeight = 310
  ClientWidth = 426
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 426
    Height = 310
    inherited BtnOK: TButton
      Left = 280
      Top = 277
      Caption = #30830#23450
      TabOrder = 7
    end
    inherited BtnExit: TButton
      Left = 350
      Top = 277
      TabOrder = 8
    end
    object EditCard: TcxTextEdit [2]
      Left = 81
      Top = 36
      ParentFont = False
      TabOrder = 0
      OnKeyPress = EditPwdKeyPress
      Width = 115
    end
    object EditPwd: TcxTextEdit [3]
      Left = 81
      Top = 61
      ParentFont = False
      Properties.EchoMode = eemPassword
      Properties.PasswordChar = '*'
      TabOrder = 1
      OnKeyPress = EditPwdKeyPress
      Width = 125
    end
    object ListMsg: TcxListBox [4]
      Left = 23
      Top = 185
      Width = 271
      Height = 75
      ItemHeight = 18
      ListStyle = lbOwnerDrawFixed
      ParentFont = False
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 6
      OnExit = ListMsgExit
    end
    object EditTruck: TcxTextEdit [5]
      Left = 269
      Top = 61
      ParentFont = False
      Properties.MaxLength = 15
      TabOrder = 2
      OnExit = EditTruckExit
      OnKeyPress = EditPwdKeyPress
      Width = 121
    end
    object EditBCard: TcxTextEdit [6]
      Left = 81
      Top = 122
      ParentFont = False
      TabOrder = 5
      OnExit = EditBCardExit
      OnKeyPress = EditPwdKeyPress
      Width = 115
    end
    object cxLabel1: TcxLabel [7]
      Left = 23
      Top = 86
      AutoSize = False
      ParentFont = False
      Properties.LineOptions.Alignment = cxllaBottom
      Properties.LineOptions.Visible = True
      Transparent = True
      Height = 10
      Width = 380
    end
    object cxLabel2: TcxLabel [8]
      Left = 23
      Top = 101
      Caption = #8251'.'#33509#25552#36135#26102#38656#20351#29992#20854#23427#30913#21345','#35831#23558#27491#30830#30340#21345#21495#22635#20889#22312#19979#38754':'
      ParentFont = False
      Transparent = True
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        Caption = #39564#35777#20449#24687
        object dxLayout1Item3: TdxLayoutItem
          Caption = #24320#21333#30913#21345':'
          Control = EditCard
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Group2: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          ShowBorder = False
          object dxLayout1Group4: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayout1Item4: TdxLayoutItem
              AutoAligns = [aaVertical]
              Caption = #25552#36135#23494#30721':'
              Control = EditPwd
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item5: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahClient
              Caption = #25552#36135#36710#36742':'
              Control = EditTruck
              ControlOptions.ShowBorder = False
            end
          end
          object dxLayout1Item8: TdxLayoutItem
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
          object dxLayout1Item7: TdxLayoutItem
            Caption = #25552#36135#30913#21345':'
            Control = EditBCard
            ControlOptions.ShowBorder = False
          end
        end
      end
      object dxGroup2: TdxLayoutGroup [1]
        AutoAligns = [aaHorizontal]
        AlignVert = avClient
        Caption = #25552#31034#20449#24687
        object dxLayout1Item6: TdxLayoutItem
          AutoAligns = [aaHorizontal]
          AlignVert = avClient
          Caption = 'cxListBox1'
          ShowCaption = False
          Control = ListMsg
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end

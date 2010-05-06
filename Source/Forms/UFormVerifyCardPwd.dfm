inherited fFormVerifyCardPwd: TfFormVerifyCardPwd
  Left = 289
  Top = 306
  ClientHeight = 266
  ClientWidth = 352
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 352
    Height = 266
    AutoContentSizes = [acsWidth]
    inherited BtnOK: TButton
      Left = 206
      Top = 230
      Caption = #30830#23450
      TabOrder = 4
    end
    inherited BtnExit: TButton
      Left = 276
      Top = 230
      TabOrder = 5
    end
    object EditCard: TcxTextEdit [2]
      Left = 81
      Top = 36
      ParentFont = False
      TabOrder = 0
      OnKeyPress = EditPwdKeyPress
      Width = 121
    end
    object EditPwd: TcxTextEdit [3]
      Left = 81
      Top = 61
      ParentFont = False
      Properties.EchoMode = eemPassword
      Properties.PasswordChar = '*'
      TabOrder = 1
      OnKeyPress = EditPwdKeyPress
      Width = 121
    end
    object ListMsg: TcxListBox [4]
      Left = 23
      Top = 143
      Width = 271
      Height = 75
      ItemHeight = 16
      ListStyle = lbOwnerDrawFixed
      ParentFont = False
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 3
      OnExit = ListMsgExit
    end
    object EditTruck: TcxTextEdit [5]
      Left = 81
      Top = 86
      ParentFont = False
      Properties.MaxLength = 15
      TabOrder = 2
      OnKeyPress = EditPwdKeyPress
      Width = 121
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        Caption = #39564#35777#20449#24687
        object dxLayout1Group3: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          ShowBorder = False
          object dxLayout1Item3: TdxLayoutItem
            Caption = #30913#21345#32534#21495':'
            Control = EditCard
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item4: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #25552#36135#23494#30721':'
            Control = EditPwd
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Item5: TdxLayoutItem
          Caption = #25552#36135#36710#36742':'
          Control = EditTruck
          ControlOptions.ShowBorder = False
        end
      end
      object dxGroup2: TdxLayoutGroup [1]
        Caption = #25552#31034#20449#24687
        object dxLayout1Item6: TdxLayoutItem
          Caption = 'cxListBox1'
          ShowCaption = False
          Control = ListMsg
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end

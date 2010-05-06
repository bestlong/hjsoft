inherited fFormVerifyCard: TfFormVerifyCard
  Left = 289
  Top = 306
  ClientHeight = 214
  ClientWidth = 351
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 351
    Height = 214
    AutoContentSizes = [acsWidth]
    inherited BtnOK: TButton
      Left = 205
      Top = 180
      Caption = #30830#23450
      TabOrder = 2
    end
    inherited BtnExit: TButton
      Left = 275
      Top = 180
      TabOrder = 3
    end
    object EditCard: TcxTextEdit [2]
      Left = 81
      Top = 36
      ParentFont = False
      TabOrder = 0
      OnKeyPress = EditPwdKeyPress
      Width = 121
    end
    object ListMsg: TcxListBox [3]
      Left = 23
      Top = 93
      Width = 271
      Height = 75
      ItemHeight = 16
      ListStyle = lbOwnerDrawFixed
      ParentFont = False
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 1
      OnExit = ListMsgExit
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        Caption = #39564#35777#20449#24687
        object dxLayout1Item3: TdxLayoutItem
          Caption = #30913#21345#32534#21495':'
          Control = EditCard
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

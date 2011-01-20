inherited fFrameCusAccount: TfFrameCusAccount
  Width = 788
  Height = 407
  inherited ToolBar1: TToolBar
    Width = 788
    ButtonWidth = 79
    inherited BtnAdd: TToolButton
      Visible = False
    end
    inherited BtnEdit: TToolButton
      Left = 79
      Visible = False
    end
    inherited BtnDel: TToolButton
      Left = 158
      Visible = False
    end
    inherited S1: TToolButton
      Left = 237
      Visible = False
    end
    inherited BtnRefresh: TToolButton
      Left = 245
      Caption = '    '#21047#26032'    '
    end
    inherited S2: TToolButton
      Left = 324
    end
    inherited BtnPrint: TToolButton
      Left = 332
    end
    inherited BtnPreview: TToolButton
      Left = 411
    end
    inherited BtnExport: TToolButton
      Left = 490
    end
    inherited S3: TToolButton
      Left = 569
    end
    inherited BtnExit: TToolButton
      Left = 577
    end
  end
  inherited cxGrid1: TcxGrid
    Top = 202
    Width = 788
    Height = 205
    inherited cxView1: TcxGridDBTableView
      PopupMenu = PMenu1
    end
  end
  inherited dxLayout1: TdxLayoutControl
    Width = 788
    Height = 135
    object cxTextEdit3: TcxTextEdit [0]
      Left = 81
      Top = 93
      Hint = 'T.A_CID'
      ParentFont = False
      TabOrder = 3
      Width = 115
    end
    object EditDate: TcxButtonEdit [1]
      Left = 472
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      Properties.OnButtonClick = EditDatePropertiesButtonClick
      TabOrder = 2
      Width = 175
    end
    object cxTextEdit4: TcxTextEdit [2]
      Left = 259
      Top = 93
      Hint = 'T.C_Name'
      ParentFont = False
      TabOrder = 4
      Width = 150
    end
    object EditCustomer: TcxButtonEdit [3]
      Left = 259
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditIDPropertiesButtonClick
      TabOrder = 1
      OnKeyPress = OnCtrlKeyPress
      Width = 150
    end
    object cxTextEdit5: TcxTextEdit [4]
      Left = 710
      Top = 93
      Hint = 'T.C_Bank'
      ParentFont = False
      TabOrder = 6
      Width = 100
    end
    object cxTextEdit1: TcxTextEdit [5]
      Left = 472
      Top = 93
      Hint = 'T.C_Account'
      ParentFont = False
      TabOrder = 5
      Width = 175
    end
    object EditID: TcxButtonEdit [6]
      Left = 81
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditIDPropertiesButtonClick
      TabOrder = 0
      OnKeyPress = OnCtrlKeyPress
      Width = 115
    end
    inherited dxGroup1: TdxLayoutGroup
      inherited GroupSearch1: TdxLayoutGroup
        object dxLayout1Item2: TdxLayoutItem
          Caption = #23458#25143#32534#21495':'
          Control = EditID
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item8: TdxLayoutItem
          Caption = #23458#25143#21517#31216':'
          Control = EditCustomer
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item6: TdxLayoutItem
          Caption = #26085#26399#31579#36873':'
          Control = EditDate
          ControlOptions.ShowBorder = False
        end
      end
      inherited GroupDetail1: TdxLayoutGroup
        object dxLayout1Item5: TdxLayoutItem
          Caption = #23458#25143#32534#21495':'
          Control = cxTextEdit3
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item7: TdxLayoutItem
          Caption = #23458#25143#21517#31216':'
          Control = cxTextEdit4
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item1: TdxLayoutItem
          Caption = #38134#34892#36134#25143':'
          Control = cxTextEdit1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item10: TdxLayoutItem
          AutoAligns = [aaVertical]
          AlignHorz = ahClient
          Caption = #24320#25143#38134#34892':'
          Control = cxTextEdit5
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
  inherited cxSplitter1: TcxSplitter
    Top = 194
    Width = 788
  end
  inherited TitlePanel1: TZnBitmapPanel
    Width = 788
    inherited TitleBar: TcxLabel
      Caption = #23458#25143#36164#37329#36134#25143#26597#35810
      Style.IsFontAssigned = True
      Width = 788
      AnchorX = 394
      AnchorY = 11
    end
  end
  inherited SQLQuery: TADOQuery
    Left = 8
    Top = 248
  end
  inherited DataSource1: TDataSource
    Left = 36
    Top = 248
  end
  object PMenu1: TPopupMenu
    AutoHotkeys = maManual
    Left = 8
    Top = 276
    object N1: TMenuItem
      Tag = 10
      Caption = #38750#27491#24335#23458#25143
      OnClick = N3Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object N3: TMenuItem
      Tag = 20
      Caption = #26597#35810#20840#37096
      OnClick = N3Click
    end
  end
end

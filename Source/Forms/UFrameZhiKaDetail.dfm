inherited fFrameZhiKaDetail: TfFrameZhiKaDetail
  Width = 686
  inherited ToolBar1: TToolBar
    Width = 686
    ButtonWidth = 79
    inherited BtnAdd: TToolButton
      Caption = #21150#29702
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
    Width = 686
    Height = 165
    LevelTabs.Slants.Kind = skCutCorner
    inherited cxView1: TcxGridDBTableView
      PopupMenu = PMenu1
    end
    inherited cxLevel1: TcxGridLevel
      Caption = #24050#21150#29702
    end
  end
  inherited dxLayout1: TdxLayoutControl
    Width = 686
    Height = 135
    object cxTextEdit1: TcxTextEdit [0]
      Left = 81
      Top = 93
      Hint = 'T.Z_ID'
      ParentFont = False
      TabOrder = 3
      Width = 115
    end
    object EditCus: TcxButtonEdit [1]
      Left = 259
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditZKPropertiesButtonClick
      TabOrder = 1
      OnKeyPress = OnCtrlKeyPress
      Width = 115
    end
    object EditZK: TcxButtonEdit [2]
      Left = 81
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditZKPropertiesButtonClick
      TabOrder = 0
      OnKeyPress = OnCtrlKeyPress
      Width = 115
    end
    object EditDate: TcxButtonEdit [3]
      Left = 437
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
      Width = 185
    end
    object cxTextEdit4: TcxTextEdit [4]
      Left = 259
      Top = 93
      Hint = 'T.D_Stock'
      ParentFont = False
      TabOrder = 4
      Width = 115
    end
    object cxTextEdit2: TcxTextEdit [5]
      Left = 600
      Top = 93
      Hint = 'T.C_Name'
      ParentFont = False
      TabOrder = 6
      Width = 121
    end
    object cxTextEdit3: TcxTextEdit [6]
      Left = 437
      Top = 93
      Hint = 'T.D_Value'
      ParentFont = False
      TabOrder = 5
      Width = 100
    end
    inherited dxGroup1: TdxLayoutGroup
      inherited GroupSearch1: TdxLayoutGroup
        object dxLayout1Item3: TdxLayoutItem
          Caption = #32440#21345#32534#21495':'
          Control = EditZK
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item2: TdxLayoutItem
          Caption = #23458#25143#21517#31216':'
          Control = EditCus
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item6: TdxLayoutItem
          Caption = #26085#26399#31579#36873':'
          Control = EditDate
          ControlOptions.ShowBorder = False
        end
      end
      inherited GroupDetail1: TdxLayoutGroup
        object dxLayout1Item1: TdxLayoutItem
          Caption = #32440#21345#32534#21495':'
          Control = cxTextEdit1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item7: TdxLayoutItem
          Caption = #27700#27877#21697#31181':'
          Control = cxTextEdit4
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item5: TdxLayoutItem
          Caption = #21150#29702#21544#25968':'
          Control = cxTextEdit3
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item4: TdxLayoutItem
          AutoAligns = [aaVertical]
          AlignHorz = ahClient
          Caption = #23458#25143#21517#31216':'
          Control = cxTextEdit2
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
  inherited cxSplitter1: TcxSplitter
    Top = 194
    Width = 686
  end
  inherited TitlePanel1: TZnBitmapPanel
    Width = 686
    inherited TitleBar: TcxLabel
      Caption = #32440#21345#26126#32454#26597#35810
      Style.IsFontAssigned = True
      Width = 686
      AnchorX = 343
      AnchorY = 11
    end
  end
  inherited SQLQuery: TADOQuery
    Left = 2
    Top = 242
  end
  inherited DataSource1: TDataSource
    Left = 30
    Top = 242
  end
  object PMenu1: TPopupMenu
    AutoHotkeys = maManual
    Left = 2
    Top = 270
    object N1: TMenuItem
      Tag = 10
      Caption = #26080#25928#32440#21345
      OnClick = N1Click
    end
    object N2: TMenuItem
      Tag = 20
      Caption = #26597#35810#20840#37096
      OnClick = N1Click
    end
  end
end

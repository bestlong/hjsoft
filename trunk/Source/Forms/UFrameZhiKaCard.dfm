inherited fFrameZhiKaCard: TfFrameZhiKaCard
  Width = 686
  inherited ToolBar1: TToolBar
    Width = 686
    ButtonWidth = 79
    inherited BtnAdd: TToolButton
      Caption = #21150#29702
      OnClick = BtnAddClick
    end
    inherited BtnEdit: TToolButton
      Left = 79
      Visible = False
    end
    inherited BtnDel: TToolButton
      Left = 158
      OnClick = BtnDelClick
    end
    inherited S1: TToolButton
      Left = 237
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
    RootLevelOptions.DetailTabsPosition = dtpTop
    OnActiveTabChanged = cxGrid1ActiveTabChanged
    inherited cxView1: TcxGridDBTableView
      PopupMenu = PMenu1
      OnDblClick = cxView2DblClick
    end
    object cxView2: TcxGridDBTableView [1]
      PopupMenu = PMenu2
      OnDblClick = cxView2DblClick
      NavigatorButtons.ConfirmDelete = False
      DataController.DataSource = DataSource2
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
    end
    inherited cxLevel1: TcxGridLevel
      Caption = #24050#21150#29702
    end
    object cxLevel2: TcxGridLevel
      Caption = #26410#21150#29702
      GridView = cxView2
    end
  end
  inherited dxLayout1: TdxLayoutControl
    Width = 686
    Height = 135
    object cxTextEdit1: TcxTextEdit [0]
      Left = -28
      Top = 93
      Hint = 'T.C_Card'
      ParentFont = False
      TabOrder = 4
      Width = 100
    end
    object EditCus: TcxButtonEdit [1]
      Left = 298
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditTruckPropertiesButtonClick
      TabOrder = 2
      OnKeyPress = OnCtrlKeyPress
      Width = 100
    end
    object EditCard: TcxButtonEdit [2]
      Left = -28
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditTruckPropertiesButtonClick
      TabOrder = 0
      OnKeyPress = OnCtrlKeyPress
      Width = 100
    end
    object EditDate: TcxButtonEdit [3]
      Left = 461
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      Properties.OnButtonClick = EditDatePropertiesButtonClick
      TabOrder = 3
      Width = 185
    end
    object cxTextEdit4: TcxTextEdit [4]
      Left = 135
      Top = 93
      Hint = 'T.C_ZID'
      ParentFont = False
      TabOrder = 5
      Width = 100
    end
    object cxTextEdit2: TcxTextEdit [5]
      Left = 298
      Top = 93
      Hint = 'T.C_Name'
      ParentFont = False
      TabOrder = 6
      Width = 121
    end
    object EditZK: TcxButtonEdit [6]
      Left = 135
      Top = 36
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditTruckPropertiesButtonClick
      TabOrder = 1
      OnKeyPress = OnCtrlKeyPress
      Width = 100
    end
    inherited dxGroup1: TdxLayoutGroup
      inherited GroupSearch1: TdxLayoutGroup
        object dxLayout1Item3: TdxLayoutItem
          Caption = #30913#21345#32534#21495':'
          Control = EditCard
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item5: TdxLayoutItem
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
          Caption = #30913#21345#32534#21495':'
          Control = cxTextEdit1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item7: TdxLayoutItem
          Caption = #32440#21345#32534#21495':'
          Control = cxTextEdit4
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item4: TdxLayoutItem
          AutoAligns = [aaVertical]
          AlignHorz = ahClient
          Caption = #23458#25143#20449#24687':'
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
      Caption = #21150#29702#30913#21345#35760#24405
      Style.IsFontAssigned = True
      Width = 686
      AnchorX = 343
      AnchorY = 11
    end
  end
  inherited SQLQuery: TADOQuery
    Left = 2
    Top = 262
  end
  inherited DataSource1: TDataSource
    Left = 30
    Top = 262
  end
  object PMenu1: TPopupMenu
    AutoHotkeys = maManual
    OnPopup = PMenu1Popup
    Left = 2
    Top = 318
    object N1: TMenuItem
      Caption = #26597#35810#36873#39033
      object N5: TMenuItem
        Caption = #26080#25928#30913#21345
        OnClick = N5Click
      end
      object N8: TMenuItem
        Caption = #20923#32467#30913#21345
        OnClick = N8Click
      end
      object N6: TMenuItem
        Caption = #26597#35810#20840#37096
        OnClick = N6Click
      end
    end
    object N7: TMenuItem
      Caption = '-'
    end
    object N9: TMenuItem
      Caption = #25346#22833#30913#21345
      OnClick = N9Click
    end
    object N10: TMenuItem
      Caption = #35299#38500#25346#22833
      OnClick = N10Click
    end
    object N11: TMenuItem
      Caption = #34917#21150#30913#21345
      OnClick = N11Click
    end
    object N12: TMenuItem
      Caption = #27880#38144#30913#21345
      OnClick = N12Click
    end
    object N13: TMenuItem
      Caption = '-'
    end
    object N14: TMenuItem
      Caption = #20923#32467#30913#21345
      OnClick = N14Click
    end
    object N15: TMenuItem
      Caption = #35299#38500#20923#32467
      OnClick = N15Click
    end
    object N16: TMenuItem
      Caption = '-'
    end
    object N17: TMenuItem
      Caption = #22791#27880#20449#24687
      OnClick = N17Click
    end
  end
  object DataSource2: TDataSource
    DataSet = SQLNo1
    Left = 30
    Top = 290
  end
  object SQLNo1: TADOQuery
    Connection = FDM.ADOConn
    Parameters = <>
    Left = 2
    Top = 290
  end
  object PMenu2: TPopupMenu
    AutoHotkeys = maManual
    Left = 30
    Top = 318
    object N2: TMenuItem
      Caption = #21150#29702#30913#21345
      OnClick = N2Click
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object N4: TMenuItem
      Caption = #26597#35810#20840#37096
      OnClick = N4Click
    end
  end
end

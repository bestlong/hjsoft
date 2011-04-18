inherited fFrameTruckQuery: TfFrameTruckQuery
  Width = 686
  inherited ToolBar1: TToolBar
    Width = 686
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
    Top = 217
    Width = 686
    Height = 150
    inherited cxView1: TcxGridDBTableView
      PopupMenu = PMenu1
    end
  end
  inherited dxLayout1: TdxLayoutControl
    Width = 686
    Height = 150
    object cxTextEdit1: TcxTextEdit [0]
      Left = 81
      Top = 93
      Hint = 'T.E_Truck'
      ParentFont = False
      TabOrder = 5
      Width = 100
    end
    object EditTruck: TcxButtonEdit [1]
      Left = 81
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
    object EditCard: TcxButtonEdit [2]
      Left = 244
      Top = 36
      ParentFont = False
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
    object cxTextEdit2: TcxTextEdit [3]
      Left = 244
      Top = 93
      Hint = 'T.E_Card'
      ParentFont = False
      TabOrder = 6
      Width = 100
    end
    object cxTextEdit3: TcxTextEdit [4]
      Left = 407
      Top = 93
      Hint = 'T.C_Name'
      ParentFont = False
      TabOrder = 7
      Width = 100
    end
    object EditDate: TcxButtonEdit [5]
      Left = 721
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      Properties.OnButtonClick = EditDatePropertiesButtonClick
      TabOrder = 4
      Width = 185
    end
    object cxTextEdit4: TcxTextEdit [6]
      Left = 558
      Top = 93
      Hint = 'T.S_Name'
      ParentFont = False
      TabOrder = 8
      Width = 100
    end
    object EditCustomer: TcxButtonEdit [7]
      Left = 407
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
    object EditSaleMan: TcxButtonEdit [8]
      Left = 558
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditTruckPropertiesButtonClick
      TabOrder = 3
      OnKeyPress = OnCtrlKeyPress
      Width = 100
    end
    object cxTextEdit5: TcxTextEdit [9]
      Left = 721
      Top = 93
      Hint = 'T.Z_Project'
      ParentFont = False
      TabOrder = 9
      Width = 181
    end
    inherited dxGroup1: TdxLayoutGroup
      inherited GroupSearch1: TdxLayoutGroup
        object dxLayout1Item2: TdxLayoutItem
          Caption = #36710#29260#21495#30721':'
          Control = EditTruck
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item3: TdxLayoutItem
          Caption = #30913#21345#32534#21495':'
          Control = EditCard
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item8: TdxLayoutItem
          Caption = #23458#25143#21517#31216':'
          Control = EditCustomer
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item9: TdxLayoutItem
          Caption = #19994#21153#21592':'
          Control = EditSaleMan
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
          Caption = #36710#29260#21495#30721':'
          Control = cxTextEdit1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item4: TdxLayoutItem
          Caption = #30913#21345#32534#21495':'
          Control = cxTextEdit2
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item5: TdxLayoutItem
          Caption = #23458#25143#21517#31216':'
          Control = cxTextEdit3
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item7: TdxLayoutItem
          Caption = #19994#21153#21592':'
          Control = cxTextEdit4
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item10: TdxLayoutItem
          Caption = #39033#30446#21517#31216':'
          Control = cxTextEdit5
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
  inherited cxSplitter1: TcxSplitter
    Top = 209
    Width = 686
  end
  inherited TitlePanel1: TZnBitmapPanel
    Width = 686
    inherited TitleBar: TcxLabel
      Caption = #20986#20837#36710#36742#26597#35810
      Style.IsFontAssigned = True
      Width = 686
      AnchorX = 343
      AnchorY = 11
    end
  end
  inherited SQLQuery: TADOQuery
    Left = 10
    Top = 252
  end
  inherited DataSource1: TDataSource
    Left = 38
    Top = 252
  end
  object PMenu1: TPopupMenu
    AutoHotkeys = maManual
    Left = 10
    Top = 280
    object N4: TMenuItem
      Tag = 10
      Caption = #26174#31034#20840#37096
      OnClick = N1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object N3: TMenuItem
      Tag = 20
      Caption = #26410#20986#21378#36710#36742
      OnClick = N1Click
    end
    object N1: TMenuItem
      Tag = 30
      Caption = #24050#20986#21378#36710#36742
      OnClick = N1Click
    end
  end
end

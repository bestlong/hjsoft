inherited fFrameLadingSan: TfFrameLadingSan
  Width = 803
  Height = 368
  inherited ToolBar1: TToolBar
    Width = 803
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
    Width = 803
    Height = 166
    inherited cxView1: TcxGridDBTableView
      PopupMenu = PMenu1
    end
  end
  inherited dxLayout1: TdxLayoutControl
    Width = 803
    Height = 135
    object cxTextEdit1: TcxTextEdit [0]
      Left = 81
      Top = 93
      Hint = 'T.E_Truck'
      ParentFont = False
      TabOrder = 3
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
      TabOrder = 4
      Width = 100
    end
    object EditDate: TcxButtonEdit [4]
      Left = 407
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
    object cxTextEdit4: TcxTextEdit [5]
      Left = 407
      Top = 93
      Hint = 'T.Z_CusName'
      ParentFont = False
      TabOrder = 5
      Width = 185
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
        object dxLayout1Item7: TdxLayoutItem
          Caption = #23458#25143#21517#31216':'
          Control = cxTextEdit4
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
  inherited cxSplitter1: TcxSplitter
    Top = 194
    Width = 803
  end
  inherited TitlePanel1: TZnBitmapPanel
    Width = 803
    inherited TitleBar: TcxLabel
      Caption = #25918#28784#35760#24405#26597#35810
      Style.IsFontAssigned = True
      Width = 803
      AnchorX = 402
      AnchorY = 11
    end
  end
  inherited SQLQuery: TADOQuery
    Top = 234
  end
  inherited DataSource1: TDataSource
    Top = 234
  end
  object PMenu1: TPopupMenu
    AutoHotkeys = maManual
    Left = 6
    Top = 262
    object N1: TMenuItem
      Caption = #20462#25913#32534#21495
      OnClick = N1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object N3: TMenuItem
      Caption = #26597#35810#36873#39033
      object N4: TMenuItem
        Tag = 10
        Caption = #20132#25509#29677#26597#35810
        OnClick = N5Click
      end
      object N5: TMenuItem
        Tag = 20
        Caption = #24050#20986#21378#26597#35810
        OnClick = N5Click
      end
    end
  end
end

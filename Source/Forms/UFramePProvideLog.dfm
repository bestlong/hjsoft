inherited fFrameProvideLog: TfFrameProvideLog
  Width = 975
  Height = 387
  inherited ToolBar1: TToolBar
    Width = 975
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
    Width = 975
    Height = 185
    inherited cxView1: TcxGridDBTableView
      PopupMenu = PMenu1
    end
  end
  inherited dxLayout1: TdxLayoutControl
    Width = 975
    Height = 135
    object cxTextEdit1: TcxTextEdit [0]
      Left = 81
      Top = 94
      Hint = 'T.L_Truck'
      ParentFont = False
      TabOrder = 5
      Width = 105
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
      Width = 105
    end
    object EditProvider: TcxButtonEdit [2]
      Left = 237
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
      Width = 105
    end
    object cxTextEdit2: TcxTextEdit [3]
      Left = 549
      Top = 94
      Hint = 'T.L_Provider'
      ParentFont = False
      TabOrder = 8
      Width = 195
    end
    object cxTextEdit3: TcxTextEdit [4]
      Left = 237
      Top = 94
      Hint = 'T.L_Mate'
      ParentFont = False
      TabOrder = 6
      Width = 105
    end
    object EditDate: TcxButtonEdit [5]
      Left = 561
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
    object cxTextEdit4: TcxTextEdit [6]
      Left = 393
      Top = 94
      Hint = 'T.L_JValue'
      ParentFont = False
      TabOrder = 7
      Width = 105
    end
    object EditMate: TcxButtonEdit [7]
      Left = 393
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
      Width = 105
    end
    object Check1: TcxCheckBox [8]
      Left = 751
      Top = 36
      Caption = #25353#20986#21378#26102#38388#26597#35810
      ParentFont = False
      TabOrder = 4
      Transparent = True
      Width = 121
    end
    inherited dxGroup1: TdxLayoutGroup
      inherited GroupSearch1: TdxLayoutGroup
        object dxLayout1Item2: TdxLayoutItem
          Caption = #36710#29260#21495#30721':'
          Control = EditTruck
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item3: TdxLayoutItem
          Caption = #20379#24212#21830':'
          Control = EditProvider
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item8: TdxLayoutItem
          Caption = #21407#26448#26009':'
          Control = EditMate
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item6: TdxLayoutItem
          Caption = #26085#26399#31579#36873':'
          Control = EditDate
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item9: TdxLayoutItem
          Caption = 'cxCheckBox1'
          ShowCaption = False
          Control = Check1
          ControlOptions.ShowBorder = False
        end
      end
      inherited GroupDetail1: TdxLayoutGroup
        object dxLayout1Item1: TdxLayoutItem
          Caption = #36710#29260#21495#30721':'
          Control = cxTextEdit1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item5: TdxLayoutItem
          Caption = #21407#26448#26009':'
          Control = cxTextEdit3
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item7: TdxLayoutItem
          Caption = #20928#37325#37327':'
          Control = cxTextEdit4
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item4: TdxLayoutItem
          Caption = #20379#24212#21830':'
          Control = cxTextEdit2
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
  inherited cxSplitter1: TcxSplitter
    Top = 194
    Width = 975
  end
  inherited TitlePanel1: TZnBitmapPanel
    Width = 975
    inherited TitleBar: TcxLabel
      Caption = #21407#26448#26009#20379#24212#35760#24405
      Style.IsFontAssigned = True
      Width = 975
      AnchorX = 488
      AnchorY = 11
    end
  end
  inherited SQLQuery: TADOQuery
    Left = 2
    Top = 234
  end
  inherited DataSource1: TDataSource
    Left = 30
    Top = 234
  end
  object PMenu1: TPopupMenu
    AutoHotkeys = maManual
    Left = 2
    Top = 262
    object N1: TMenuItem
      Caption = #25171#21360#30917#21333
      OnClick = N1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object N4: TMenuItem
      Caption = #20379#24212#39564#25910
      OnClick = N4Click
    end
    object N3: TMenuItem
      Caption = #21024#38500#26126#32454
      OnClick = N3Click
    end
    object N5: TMenuItem
      Caption = #20854#23427#36873#39033
      object N6: TMenuItem
        Caption = #20132#25509#29677#26597#35810
        OnClick = N6Click
      end
      object N7: TMenuItem
        Caption = '-'
      end
      object N8: TMenuItem
        Caption = #27966#36710#21333#26597#35810
        OnClick = N8Click
      end
      object N9: TMenuItem
        Caption = #20462#25913#27966#36710#21333
        OnClick = N9Click
      end
    end
  end
end

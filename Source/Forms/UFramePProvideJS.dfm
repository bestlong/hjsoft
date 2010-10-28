inherited fFrameProvideJS: TfFrameProvideJS
  Width = 840
  Height = 386
  inherited ToolBar1: TToolBar
    Width = 840
    inherited BtnAdd: TToolButton
      Caption = #26680#31639
      ImageIndex = 19
      OnClick = BtnAddClick
    end
    inherited BtnEdit: TToolButton
      Caption = #32467#31639
      ImageIndex = 17
      OnClick = BtnEditClick
    end
    inherited BtnDel: TToolButton
      Visible = False
    end
  end
  inherited cxGrid1: TcxGrid
    Top = 202
    Width = 840
    Height = 184
    inherited cxView1: TcxGridDBTableView
      PopupMenu = PMenu1
      OnDblClick = cxView1DblClick
      OptionsSelection.MultiSelect = True
    end
  end
  inherited dxLayout1: TdxLayoutControl
    Width = 840
    Height = 135
    object cxTextEdit1: TcxTextEdit [0]
      Left = 234
      Top = 93
      Hint = 'T.L_Truck'
      ParentFont = False
      TabOrder = 5
      Width = 90
    end
    object EditTruck: TcxButtonEdit [1]
      Left = 249
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
    object EditLID: TcxButtonEdit [2]
      Left = 405
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
    object cxTextEdit2: TcxTextEdit [3]
      Left = 81
      Top = 93
      Hint = 'T.L_PaiNum'
      ParentFont = False
      TabOrder = 4
      Width = 90
    end
    object cxTextEdit3: TcxTextEdit [4]
      Left = 375
      Top = 93
      Hint = 'T.L_Mate'
      ParentFont = False
      TabOrder = 6
      Width = 90
    end
    object EditDate: TcxButtonEdit [5]
      Left = 573
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
      Left = 516
      Top = 93
      Hint = 'T.L_JValue'
      ParentFont = False
      TabOrder = 7
      Width = 90
    end
    object EditPNum: TcxButtonEdit [7]
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
    object cxTextEdit5: TcxTextEdit [8]
      Left = 669
      Top = 93
      Hint = 'T.L_Money'
      ParentFont = False
      TabOrder = 8
      Width = 90
    end
    inherited dxGroup1: TdxLayoutGroup
      inherited GroupSearch1: TdxLayoutGroup
        object dxLayout1Item8: TdxLayoutItem
          Caption = #27966#36710#21333#21495':'
          Control = EditPNum
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item2: TdxLayoutItem
          Caption = #36710#29260#21495#30721':'
          Control = EditTruck
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item3: TdxLayoutItem
          Caption = #30917#21333#21495':'
          Control = EditLID
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item6: TdxLayoutItem
          Caption = #26085#26399#31579#36873':'
          Control = EditDate
          ControlOptions.ShowBorder = False
        end
      end
      inherited GroupDetail1: TdxLayoutGroup
        object dxLayout1Item4: TdxLayoutItem
          Caption = #27966#36710#21333#21495':'
          Control = cxTextEdit2
          ControlOptions.ShowBorder = False
        end
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
        object dxLayout1Item9: TdxLayoutItem
          Caption = #32467#31639#37329#39069':'
          Control = cxTextEdit5
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
  inherited cxSplitter1: TcxSplitter
    Top = 194
    Width = 840
  end
  inherited TitlePanel1: TZnBitmapPanel
    Width = 840
    inherited TitleBar: TcxLabel
      Caption = #20379#24212#32467#31639#31649#29702
      Style.IsFontAssigned = True
      Width = 840
      AnchorX = 420
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
    OnPopup = PMenu1Popup
    Left = 2
    Top = 262
    object N1: TMenuItem
      Caption = #25171#21360#32467#31639#21333
      OnClick = N1Click
    end
    object N9: TMenuItem
      Caption = #25209#37327#32467#31639#21333
      object N10: TMenuItem
        Caption = #36880#26465#25171#21360
        OnClick = N10Click
      end
      object N11: TMenuItem
        Caption = #21512#35745#25171#21360
        OnClick = N10Click
      end
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object N3: TMenuItem
      Caption = #26597#35810#26410#26680#31639
      object N6: TMenuItem
        Tag = 20
        Caption = #25351#23450#26102#38388
        OnClick = N6Click
      end
      object N5: TMenuItem
        Tag = 10
        Caption = #26597#35810#20840#37096
        OnClick = N6Click
      end
    end
    object N4: TMenuItem
      Caption = #26597#35810#26410#32467#31639
      object N8: TMenuItem
        Tag = 20
        Caption = #25351#23450#26102#38388
        OnClick = N8Click
      end
      object N7: TMenuItem
        Tag = 10
        Caption = #26597#35810#20840#37096
        OnClick = N8Click
      end
    end
  end
end

inherited fFrameLadingDaiJS: TfFrameLadingDaiJS
  Width = 723
  inherited ToolBar1: TToolBar
    Width = 723
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
    Width = 723
    Height = 165
  end
  inherited dxLayout1: TdxLayoutControl
    Width = 723
    Height = 135
    object cxTextEdit1: TcxTextEdit [0]
      Left = 35
      Top = 93
      Hint = 'T.J_Truck'
      ParentFont = False
      TabOrder = 2
      Width = 112
    end
    object EditTruck: TcxButtonEdit [1]
      Left = 35
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
      Width = 112
    end
    object cxTextEdit2: TcxTextEdit [2]
      Left = 418
      Top = 93
      Hint = 'T.J_Stock'
      ParentFont = False
      TabOrder = 4
      Width = 100
    end
    object EditDate: TcxButtonEdit [3]
      Left = 210
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      Properties.OnButtonClick = EditDatePropertiesButtonClick
      TabOrder = 1
      Width = 172
    end
    object cxTextEdit4: TcxTextEdit [4]
      Left = 210
      Top = 93
      Hint = 'T.J_Date'
      ParentFont = False
      TabOrder = 3
      Width = 145
    end
    object cxTextEdit3: TcxTextEdit [5]
      Left = 593
      Top = 93
      Hint = 'T.J_Value'
      ParentFont = False
      TabOrder = 5
      Width = 100
    end
    inherited dxGroup1: TdxLayoutGroup
      inherited GroupSearch1: TdxLayoutGroup
        object dxLayout1Item2: TdxLayoutItem
          Caption = #36710#29260#21495#30721':'
          Control = EditTruck
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
        object dxLayout1Item7: TdxLayoutItem
          Caption = #25552#36135#26102#38388':'
          Control = cxTextEdit4
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item4: TdxLayoutItem
          Caption = #27700#27877#21697#31181':'
          Control = cxTextEdit2
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item5: TdxLayoutItem
          Caption = #25552#36135#37327'('#21544'):'
          Control = cxTextEdit3
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
  inherited cxSplitter1: TcxSplitter
    Top = 194
    Width = 723
  end
  inherited TitlePanel1: TZnBitmapPanel
    Width = 723
    inherited TitleBar: TcxLabel
      Caption = #26632#21488#35013#36710#35745#25968#26597#35810
      Style.IsFontAssigned = True
      Width = 723
      AnchorX = 362
      AnchorY = 11
    end
  end
  inherited SQLQuery: TADOQuery
    Left = 8
    Top = 236
  end
  inherited DataSource1: TDataSource
    Left = 36
    Top = 236
  end
end

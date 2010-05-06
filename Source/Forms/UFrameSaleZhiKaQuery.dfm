inherited fFrameSaleZhiKaQuery: TfFrameSaleZhiKaQuery
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
    Top = 209
    Width = 686
    Height = 158
  end
  inherited dxLayout1: TdxLayoutControl
    Width = 686
    Height = 142
    object EditDate: TcxButtonEdit [0]
      Left = 567
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
    object EditCustomer: TcxButtonEdit [1]
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
    object EditCard: TcxButtonEdit [2]
      Left = 399
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
    object EditSMan: TcxButtonEdit [3]
      Left = 243
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
    object cxTextEdit1: TcxTextEdit [4]
      Left = 81
      Top = 93
      Hint = 'T.C_Name'
      TabOrder = 4
      Width = 135
    end
    object cxTextEdit2: TcxTextEdit [5]
      Left = 279
      Top = 93
      Hint = 'T.Z_Project'
      TabOrder = 5
      Width = 125
    end
    object cxTextEdit3: TcxTextEdit [6]
      Left = 467
      Top = 93
      Hint = 'T.L_Stock'
      TabOrder = 6
      Width = 105
    end
    object cxTextEdit4: TcxTextEdit [7]
      Left = 647
      Top = 93
      Hint = 'T.L_AllValue'
      TabOrder = 7
      Width = 100
    end
    inherited dxGroup1: TdxLayoutGroup
      inherited GroupSearch1: TdxLayoutGroup
        object dxLayout1Item8: TdxLayoutItem
          Caption = #23458#25143#21517#31216':'
          Control = EditCustomer
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item1: TdxLayoutItem
          Caption = #19994#21153#21592' :'
          Control = EditSMan
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item9: TdxLayoutItem
          Caption = #30913#21345#21495':'
          Control = EditCard
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item6: TdxLayoutItem
          Caption = #25552#36135#26085#26399':'
          Control = EditDate
          ControlOptions.ShowBorder = False
        end
      end
      inherited GroupDetail1: TdxLayoutGroup
        object dxLayout1Item2: TdxLayoutItem
          Caption = #23458#25143#21517#31216':'
          Control = cxTextEdit1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item3: TdxLayoutItem
          Caption = #39033#30446#21517#31216':'
          Control = cxTextEdit2
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item4: TdxLayoutItem
          Caption = #27700#27877#21517#31216':'
          Control = cxTextEdit3
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item5: TdxLayoutItem
          Caption = #25552#36135#37327'('#21544'):'
          Control = cxTextEdit4
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
  inherited cxSplitter1: TcxSplitter
    Top = 201
    Width = 686
  end
  inherited TitlePanel1: TZnBitmapPanel
    Width = 686
    inherited TitleBar: TcxLabel
      Caption = #29992#25143#25552#36135#36827#24230#26597#35810
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
end

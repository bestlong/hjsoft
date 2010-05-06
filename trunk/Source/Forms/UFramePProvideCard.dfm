inherited fFrameProvideCard: TfFrameProvideCard
  Width = 746
  Height = 420
  inherited ToolBar1: TToolBar
    Width = 746
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
    Width = 746
    Height = 218
    inherited cxView1: TcxGridDBTableView
      PopupMenu = PMenu1
    end
  end
  inherited dxLayout1: TdxLayoutControl
    Width = 746
    Height = 135
    object cxTextEdit1: TcxTextEdit [0]
      Left = 247
      Top = 93
      Hint = 'T.P_Provider'
      TabOrder = 4
      Width = 115
    end
    object EditName: TcxButtonEdit [1]
      Left = 247
      Top = 36
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditNamePropertiesButtonClick
      TabOrder = 1
      OnKeyPress = OnCtrlKeyPress
      Width = 115
    end
    object cxTextEdit2: TcxTextEdit [2]
      Left = 597
      Top = 93
      Hint = 'T.P_Memo'
      TabOrder = 6
      Width = 274
    end
    object EditCard: TcxButtonEdit [3]
      Left = 81
      Top = 36
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditNamePropertiesButtonClick
      TabOrder = 0
      OnKeyPress = OnCtrlKeyPress
      Width = 115
    end
    object cxTextEdit4: TcxTextEdit [4]
      Left = 81
      Top = 93
      Hint = 'T.P_Card'
      TabOrder = 3
      Width = 115
    end
    object EditMate: TcxButtonEdit [5]
      Left = 413
      Top = 36
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditNamePropertiesButtonClick
      TabOrder = 2
      OnKeyPress = OnCtrlKeyPress
      Width = 121
    end
    object cxTextEdit3: TcxTextEdit [6]
      Left = 413
      Top = 93
      Hint = 'T.P_Mate'
      TabOrder = 5
      Width = 121
    end
    inherited dxGroup1: TdxLayoutGroup
      inherited GroupSearch1: TdxLayoutGroup
        object dxLayout1Item5: TdxLayoutItem
          Caption = #30913#21345#32534#21495':'
          Control = EditCard
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item2: TdxLayoutItem
          Caption = #20379#24212#21830':'
          Control = EditName
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item3: TdxLayoutItem
          Caption = #21407#26448#26009':'
          Control = EditMate
          ControlOptions.ShowBorder = False
        end
      end
      inherited GroupDetail1: TdxLayoutGroup
        object dxLayout1Item6: TdxLayoutItem
          Caption = #30913#21345#32534#21495':'
          Control = cxTextEdit4
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item1: TdxLayoutItem
          Caption = #20379#24212#21830':'
          Control = cxTextEdit1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item7: TdxLayoutItem
          Caption = #21407#26448#26009':'
          Control = cxTextEdit3
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item4: TdxLayoutItem
          AutoAligns = [aaVertical]
          AlignHorz = ahClient
          Caption = #22791#27880#20449#24687':'
          Control = cxTextEdit2
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
  inherited cxSplitter1: TcxSplitter
    Top = 194
    Width = 746
  end
  inherited TitlePanel1: TZnBitmapPanel
    Width = 746
    inherited TitleBar: TcxLabel
      Caption = #20379#24212#30913#21345#31649#29702
      Style.IsFontAssigned = True
      Width = 746
      AnchorX = 373
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
      Tag = 10
      Caption = #30913#21345#25346#22833
      OnClick = N2Click
    end
    object N2: TMenuItem
      Tag = 20
      Caption = #35299#38500#25346#22833
      OnClick = N2Click
    end
  end
end

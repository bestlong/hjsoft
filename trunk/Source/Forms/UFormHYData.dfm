inherited fFormHYData: TfFormHYData
  Left = 323
  Top = 208
  Width = 467
  Height = 376
  BorderStyle = bsSizeable
  Constraints.MinHeight = 325
  Constraints.MinWidth = 460
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 459
    Height = 342
    AutoContentSizes = [acsWidth, acsHeight]
    inherited BtnOK: TButton
      Left = 313
      Top = 309
      Caption = #30830#23450
      TabOrder = 8
    end
    inherited BtnExit: TButton
      Left = 383
      Top = 309
      TabOrder = 9
    end
    object EditTruck: TcxTextEdit [2]
      Left = 81
      Top = 136
      ParentFont = False
      Properties.MaxLength = 100
      TabOrder = 5
      Width = 147
    end
    object EditValue: TcxTextEdit [3]
      Left = 303
      Top = 136
      ParentFont = False
      Properties.MaxLength = 100
      TabOrder = 6
      Width = 403
    end
    object EditSMan: TcxComboBox [4]
      Left = 81
      Top = 36
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.IncrementalSearch = False
      Properties.ItemHeight = 18
      Properties.MaxLength = 35
      Properties.OnEditValueChanged = EditSManPropertiesEditValueChanged
      TabOrder = 0
      Width = 121
    end
    object EditCustom: TcxComboBox [5]
      Left = 81
      Top = 61
      ParentFont = False
      Properties.DropDownRows = 20
      Properties.IncrementalSearch = False
      Properties.ItemHeight = 18
      Properties.OnEditValueChanged = EditCustomPropertiesEditValueChanged
      TabOrder = 1
      OnKeyPress = EditCustomKeyPress
      Width = 121
    end
    object EditNo: TcxButtonEdit [6]
      Left = 303
      Top = 111
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditNoPropertiesButtonClick
      TabOrder = 4
      OnKeyPress = OnCtrlKeyPress
      Width = 121
    end
    object EditDate: TcxDateEdit [7]
      Left = 81
      Top = 111
      ParentFont = False
      Properties.Kind = ckDateTime
      TabOrder = 3
      Width = 147
    end
    object ListBill: TcxListView [8]
      Left = 23
      Top = 193
      Width = 418
      Height = 189
      Columns = <
        item
          Caption = #27700#27877#32534#21495
          Width = 65
        end
        item
          Caption = #27700#27877#21517#31216
          Width = 75
        end
        item
          Alignment = taCenter
          Caption = #25552#36135#36710#36742
          Width = 75
        end
        item
          Alignment = taCenter
          Caption = #25552#36135#37327'('#21544')'
          Width = 75
        end
        item
          Caption = #25552#36135#26085#26399
          Width = 75
        end>
      HideSelection = False
      MultiSelect = True
      ParentFont = False
      PopupMenu = PMenu1
      ReadOnly = True
      RowSelect = True
      SmallImages = FDM.ImageBar
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 7
      ViewStyle = vsReport
      OnDblClick = ListBillDblClick
      OnSelectItem = ListBillSelectItem
    end
    object EditName: TcxTextEdit [9]
      Left = 81
      Top = 86
      ParentFont = False
      Properties.MaxLength = 80
      TabOrder = 2
      Width = 121
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxLayout1Item13: TdxLayoutItem
          AutoAligns = [aaVertical]
          AlignHorz = ahClient
          Caption = #19994' '#21153' '#21592':'
          Control = EditSMan
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item3: TdxLayoutItem
          Caption = #23458#25143#21517#31216':'
          Control = EditCustom
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item9: TdxLayoutItem
          Caption = #24320#21333#23458#25143':'
          Control = EditName
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Group4: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item5: TdxLayoutItem
            Caption = #25552#36135#26085#26399':'
            Control = EditDate
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item4: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #27700#27877#32534#21495':'
            Control = EditNo
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Group2: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item7: TdxLayoutItem
            Caption = #25552#36135#36710#36742':'
            Control = EditTruck
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item8: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #25552#36135#37327'('#21544'):'
            Control = EditValue
            ControlOptions.ShowBorder = False
          end
        end
      end
      object dxGroup2: TdxLayoutGroup [1]
        AutoAligns = [aaHorizontal]
        AlignVert = avClient
        Caption = #25552#36135#20449#24687
        object dxLayout1Item6: TdxLayoutItem
          AutoAligns = [aaHorizontal]
          AlignVert = avClient
          Caption = 'cxListView1'
          ShowCaption = False
          Control = ListBill
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
  object PMenu1: TPopupMenu
    AutoHotkeys = maManual
    Left = 26
    Top = 214
    object N1: TMenuItem
      Caption = #26597#35810#26410#24320
      Checked = True
      GroupIndex = 1
      RadioItem = True
      OnClick = N1Click
    end
    object N2: TMenuItem
      Caption = #26597#35810#24050#24320
      GroupIndex = 1
      RadioItem = True
      OnClick = N1Click
    end
    object N3: TMenuItem
      Caption = '-'
      GroupIndex = 1
    end
    object N4: TMenuItem
      Caption = #26631#35760#26410#24320
      GroupIndex = 1
      OnClick = N4Click
    end
    object N5: TMenuItem
      Caption = #26631#35760#24050#24320
      GroupIndex = 1
      OnClick = N4Click
    end
  end
end

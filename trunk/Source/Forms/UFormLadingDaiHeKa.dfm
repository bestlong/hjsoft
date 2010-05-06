inherited fFormDaiHeKa: TfFormDaiHeKa
  Left = 351
  Top = 203
  ClientHeight = 412
  ClientWidth = 411
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 411
    Height = 412
    AutoContentSizes = [acsWidth]
    inherited BtnOK: TButton
      Left = 265
      Top = 375
      TabOrder = 7
    end
    inherited BtnExit: TButton
      Left = 335
      Top = 375
      TabOrder = 8
    end
    object ListInfo: TcxMCListBox [2]
      Left = 23
      Top = 36
      Width = 365
      Height = 115
      HeaderSections = <
        item
          Text = #20449#24687#39033
          Width = 85
        end
        item
          AutoSize = True
          Text = #20449#24687#20869#23481
          Width = 276
        end>
      ParentFont = False
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 0
    end
    object ListBill: TcxListView [3]
      Left = 23
      Top = 263
      Width = 365
      Height = 100
      Columns = <
        item
          Caption = #25552#36135#21333#21495
          Width = 70
        end
        item
          Caption = #21697#31181#21517#31216
          Width = 100
        end
        item
          Caption = #25552#36135#37327'('#21544')'
          Width = 80
        end
        item
          Caption = #27700#27877#32534#21495
          Width = 80
        end>
      ParentFont = False
      ReadOnly = True
      RowSelect = True
      SmallImages = FDM.ImageBar
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 6
      ViewStyle = vsReport
    end
    object EditCard: TcxButtonEdit [4]
      Left = 81
      Top = 156
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditCardPropertiesButtonClick
      TabOrder = 1
      OnKeyPress = OnCtrlKeyPress
      Width = 121
    end
    object EditNo: TcxTextEdit [5]
      Left = 81
      Top = 238
      ParentFont = False
      Properties.ReadOnly = False
      TabOrder = 3
      OnExit = EditNoExit
      Width = 121
    end
    object BtnAdd: TButton [6]
      Left = 283
      Top = 238
      Width = 50
      Height = 20
      Caption = #28155#21152
      TabOrder = 4
      OnClick = BtnAddClick
    end
    object BtnDel: TButton [7]
      Left = 338
      Top = 238
      Width = 50
      Height = 20
      Caption = #21024#38500
      TabOrder = 5
      OnClick = BtnDelClick
    end
    object EditBill: TcxComboBox [8]
      Left = 81
      Top = 213
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.ItemHeight = 18
      Properties.OnChange = EditBillPropertiesChange
      TabOrder = 2
      Width = 121
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        Caption = #32440#21345#20449#24687
        object dxLayout1Item7: TdxLayoutItem
          Control = ListInfo
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item4: TdxLayoutItem
          Caption = #30913#21345#32534#21495':'
          Control = EditCard
          ControlOptions.ShowBorder = False
        end
      end
      object dxGroup2: TdxLayoutGroup [1]
        Caption = #21512#21345#26126#32454
        object dxLayout1Item10: TdxLayoutItem
          Caption = #25552#36135#21333#21495':'
          Control = EditBill
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Group3: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item5: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #27700#27877#32534#21495':'
            Control = EditNo
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item8: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahRight
            Caption = 'Button1'
            ShowCaption = False
            Control = BtnAdd
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item9: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahRight
            Caption = 'Button2'
            ShowCaption = False
            Control = BtnDel
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Item3: TdxLayoutItem
          Caption = 'New Item'
          ShowCaption = False
          Control = ListBill
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end

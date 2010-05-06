inherited fFormLadingDai: TfFormLadingDai
  Left = 278
  Top = 178
  ClientHeight = 406
  ClientWidth = 416
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 416
    Height = 406
    AutoContentSizes = [acsWidth]
    inherited BtnOK: TButton
      Left = 270
      Top = 370
      TabOrder = 6
    end
    inherited BtnExit: TButton
      Left = 340
      Top = 370
      TabOrder = 7
    end
    object ListInfo: TcxMCListBox [2]
      Left = 23
      Top = 36
      Width = 374
      Height = 110
      HeaderSections = <
        item
          Text = #20449#24687#39033
          Width = 74
        end
        item
          AutoSize = True
          Text = #20449#24687#20869#23481
          Width = 296
        end>
      ParentFont = False
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 0
    end
    object ListTruck: TcxListView [3]
      Left = 23
      Top = 233
      Width = 375
      Height = 125
      Checkboxes = True
      Columns = <
        item
          Caption = #25552#36135#21333#21495
          Width = 80
        end
        item
          Caption = #36710#29260#21495#30721
          Width = 80
        end
        item
          Caption = #27700#27877#21517#31216
          Width = 100
        end
        item
          Caption = #27700#27877#32534#21495
          Width = 80
        end>
      ParentFont = False
      ReadOnly = True
      RowSelect = True
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 5
      ViewStyle = vsReport
      OnClick = ListTruckClick
      OnDblClick = ListTruckDblClick
      OnSelectItem = ListTruckSelectItem
    end
    object EditZK: TcxTextEdit [4]
      Left = 81
      Top = 151
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 1
      Width = 115
    end
    object EditCard: TcxTextEdit [5]
      Left = 259
      Top = 151
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 2
      Width = 121
    end
    object EditStock: TcxTextEdit [6]
      Left = 81
      Top = 208
      ParentFont = False
      TabOrder = 3
      Width = 115
    end
    object EditNo: TcxTextEdit [7]
      Left = 259
      Top = 208
      ParentFont = False
      Properties.MaxLength = 15
      TabOrder = 4
      OnExit = EditNoExit
      Width = 121
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        Caption = #32440#21345#20449#24687
        object dxLayout1Item3: TdxLayoutItem
          Caption = 'cxMCListBox1'
          ShowCaption = False
          Control = ListInfo
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Group2: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item4: TdxLayoutItem
            Caption = #32440#21345#32534#21495':'
            Control = EditZK
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item6: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #30913#21345#32534#21495':'
            Control = EditCard
            ControlOptions.ShowBorder = False
          end
        end
      end
      object dxGroup2: TdxLayoutGroup [1]
        Caption = #36710#36742#21015#34920
        object dxLayout1Group3: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item5: TdxLayoutItem
            Caption = #27700#27877#21517#31216':'
            Control = EditStock
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item8: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #27700#27877#32534#21495':'
            Control = EditNo
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Item7: TdxLayoutItem
          Caption = 'cxListView1'
          ShowCaption = False
          Control = ListTruck
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end

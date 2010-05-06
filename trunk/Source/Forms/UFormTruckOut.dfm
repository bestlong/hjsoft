inherited fFormTruckOut: TfFormTruckOut
  Left = 278
  Top = 178
  ClientHeight = 406
  ClientWidth = 422
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 422
    Height = 406
    AutoContentSizes = [acsWidth]
    inherited BtnOK: TButton
      Left = 276
      Top = 370
      TabOrder = 5
    end
    inherited BtnExit: TButton
      Left = 346
      Top = 370
      TabOrder = 6
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
      Width = 378
      Height = 125
      Checkboxes = True
      Columns = <
        item
          Caption = #25552#36135#21333#21495
          Width = 80
        end
        item
          Caption = #27700#27877#21517#31216
          Width = 100
        end
        item
          Caption = #36710#29260#21495#30721
          Width = 80
        end
        item
          Alignment = taCenter
          Caption = #21150#29702#37327'('#21544')'
          Width = 80
        end>
      HideSelection = False
      ParentFont = False
      ReadOnly = True
      RowSelect = True
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 4
      ViewStyle = vsReport
    end
    object EditZK: TcxTextEdit [4]
      Left = 81
      Top = 151
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 1
      Width = 110
    end
    object EditCard: TcxTextEdit [5]
      Left = 254
      Top = 151
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 2
      Width = 121
    end
    object EditTruck: TcxComboBox [6]
      Left = 81
      Top = 208
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.ItemHeight = 18
      Properties.OnChange = EditTruckPropertiesChange
      TabOrder = 3
      Width = 110
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
        object dxLayout1Item8: TdxLayoutItem
          Caption = #36710#29260#21495#30721':'
          Control = EditTruck
          ControlOptions.ShowBorder = False
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

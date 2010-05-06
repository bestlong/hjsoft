inherited fFormTruckIn: TfFormTruckIn
  Left = 460
  Top = 186
  ClientHeight = 395
  ClientWidth = 404
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 404
    Height = 395
    AutoContentSizes = [acsWidth]
    inherited BtnOK: TButton
      Left = 258
      Top = 360
      Caption = #30830#23450
      TabOrder = 7
    end
    inherited BtnExit: TButton
      Left = 328
      Top = 360
      TabOrder = 8
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
      Width = 350
      Height = 115
      Checkboxes = True
      Columns = <
        item
          Caption = #25552#36135#21333#21495
          Width = 80
        end
        item
          Caption = #25552#36135#36710#36742
          Width = 80
        end
        item
          Caption = #27700#27877#31867#22411
          Width = 80
        end
        item
          Alignment = taCenter
          Caption = #25552#36135#37327'('#21544')'
          Width = 100
        end>
      ParentFont = False
      ReadOnly = True
      RowSelect = True
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 6
      ViewStyle = vsReport
      OnAdvancedCustomDrawItem = ListTruckAdvancedCustomDrawItem
      OnClick = ListTruckClick
    end
    object EditTruck: TcxComboBox [4]
      Left = 81
      Top = 208
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.ItemHeight = 18
      Properties.OnChange = EditTruckPropertiesChange
      TabOrder = 3
      Width = 121
    end
    object EditCID: TcxTextEdit [5]
      Left = 81
      Top = 151
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 1
      Width = 120
    end
    object EditZID: TcxTextEdit [6]
      Left = 264
      Top = 151
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 2
      Width = 105
    end
    object Radio1: TcxRadioButton [7]
      Left = 232
      Top = 208
      Width = 72
      Height = 20
      Caption = #34955#35013#27700#27877
      ParentColor = False
      TabOrder = 4
      OnClick = Radio1Click
    end
    object Radio2: TcxRadioButton [8]
      Left = 309
      Top = 208
      Width = 72
      Height = 20
      Caption = #25955#35013#27700#27877
      ParentColor = False
      TabOrder = 5
      OnClick = Radio1Click
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
          object dxLayout1Item5: TdxLayoutItem
            Caption = #30913#21345#32534#21495':'
            Control = EditCID
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item6: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #32440#21345#32534#21495':'
            Control = EditZID
            ControlOptions.ShowBorder = False
          end
        end
      end
      object dxGroup2: TdxLayoutGroup [1]
        Caption = #36827#21378#36710#36742
        object dxLayout1Group4: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item4: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #36710#36742#21015#34920':'
            Control = EditTruck
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item9: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahRight
            Caption = 'cxRadioButton1'
            ShowCaption = False
            Control = Radio1
            ControlOptions.AutoColor = True
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item10: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahRight
            Caption = 'cxRadioButton2'
            ShowCaption = False
            Control = Radio2
            ControlOptions.AutoColor = True
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

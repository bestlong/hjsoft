inherited fFormPBangFangM: TfFormPBangFangM
  Left = 320
  Top = 228
  ClientHeight = 423
  ClientWidth = 399
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 399
    Height = 423
    AutoControlAlignment = False
    inherited BtnOK: TButton
      Left = 253
      Top = 390
      TabOrder = 11
    end
    inherited BtnExit: TButton
      Left = 323
      Top = 390
      TabOrder = 12
    end
    object EditValue: TcxButtonEdit [2]
      Left = 227
      Top = 201
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      Properties.OnButtonClick = EditValuePropertiesButtonClick
      TabOrder = 8
      Text = '0'
      Width = 121
    end
    object EditTruck: TcxComboBox [3]
      Left = 69
      Top = 201
      ParentFont = False
      Properties.ItemHeight = 18
      Properties.OnEditValueChanged = EditTruckPropertiesEditValueChanged
      TabOrder = 7
      OnDblClick = EditTruckPropertiesEditValueChanged
      Width = 95
    end
    object BtnGet: TButton [4]
      Left = 331
      Top = 201
      Width = 45
      Height = 22
      Caption = #35835#21462#30917
      TabOrder = 9
      OnClick = BtnGetClick
    end
    object EditMate: TcxComboBox [5]
      Left = 69
      Top = 61
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.DropDownRows = 16
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      Properties.ItemHeight = 18
      Properties.MaxLength = 30
      TabOrder = 1
      Width = 115
    end
    object EditSM: TcxComboBox [6]
      Left = 235
      Top = 61
      ParentFont = False
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      Properties.ItemHeight = 18
      Properties.MaxLength = 32
      TabOrder = 2
      Width = 129
    end
    object EditPNum: TcxTextEdit [7]
      Left = 69
      Top = 101
      ParentFont = False
      Properties.MaxLength = 15
      TabOrder = 4
      Width = 115
    end
    object cxLabel1: TcxLabel [8]
      Left = 23
      Top = 86
      AutoSize = False
      ParentFont = False
      Properties.LineOptions.Alignment = cxllaBottom
      Properties.LineOptions.Visible = True
      Transparent = True
      Height = 10
      Width = 341
    end
    object EditPTime: TcxDateEdit [9]
      Left = 235
      Top = 101
      ParentFont = False
      Properties.SaveTime = False
      TabOrder = 5
      Width = 129
    end
    object EditMemo: TcxMemo [10]
      Left = 69
      Top = 126
      ParentFont = False
      Properties.MaxLength = 50
      Properties.ScrollBars = ssVertical
      Style.Edges = [bBottom]
      TabOrder = 6
      Height = 32
      Width = 307
    end
    object EditProvider: TcxLookupComboBox [11]
      Left = 69
      Top = 36
      ParentFont = False
      Properties.DropDownListStyle = lsEditList
      Properties.DropDownRows = 20
      Properties.DropDownSizeable = True
      Properties.ListColumns = <>
      TabOrder = 0
      Width = 145
    end
    object ListTruck: TcxMCListBox [12]
      Left = 23
      Top = 228
      Width = 353
      Height = 150
      HeaderSections = <
        item
          Text = #36710#29260#21495
          Width = 74
        end
        item
          Text = #21407#26448#26009
        end
        item
          Text = #20379#24212#21830
        end
        item
          Text = #19994#21153#21592
        end>
      ParentFont = False
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 10
      OnClick = ListTruckClick
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxLayout1Group2: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          ShowBorder = False
          object dxLayout1Group4: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            ShowBorder = False
            object dxLayout1Item13: TdxLayoutItem
              Caption = #20379#24212#21830':'
              Control = EditProvider
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Group6: TdxLayoutGroup
              ShowCaption = False
              Hidden = True
              LayoutDirection = ldHorizontal
              ShowBorder = False
              object dxLayout1Item3: TdxLayoutItem
                Caption = #21407#26448#26009':'
                Control = EditMate
                ControlOptions.ShowBorder = False
              end
              object dxLayout1Item4: TdxLayoutItem
                AutoAligns = [aaVertical]
                AlignHorz = ahClient
                Caption = #19994#21153#21592':'
                Control = EditSM
                ControlOptions.ShowBorder = False
              end
            end
          end
          object dxLayout1Item10: TdxLayoutItem
            ShowCaption = False
            Control = cxLabel1
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Group5: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayout1Item6: TdxLayoutItem
              Caption = #27966#36710#21333':'
              Control = EditPNum
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item11: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahClient
              Caption = #26102'  '#38388':'
              Control = EditPTime
              ControlOptions.ShowBorder = False
            end
          end
        end
        object dxLayout1Item12: TdxLayoutItem
          AutoAligns = []
          AlignHorz = ahClient
          AlignVert = avClient
          Caption = #22791'  '#27880':'
          Control = EditMemo
          ControlOptions.ShowBorder = False
        end
      end
      object dxGroup2: TdxLayoutGroup [1]
        AutoAligns = [aaHorizontal]
        AlignVert = avBottom
        Caption = #36710#36742#21015#34920
        object dxLayout1Group3: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item8: TdxLayoutItem
            Caption = #36710#29260#21495':'
            Control = EditTruck
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item9: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #27611#37325'('#21544'):'
            Control = EditValue
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item5: TdxLayoutItem
            Caption = 'Button1'
            ShowCaption = False
            Control = BtnGet
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Item7: TdxLayoutItem
          AutoAligns = [aaHorizontal]
          AlignVert = avClient
          Control = ListTruck
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end

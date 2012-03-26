inherited fFormBangFang: TfFormBangFang
  Left = 589
  Top = 225
  ClientHeight = 388
  ClientWidth = 387
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 387
    Height = 388
    AutoControlAlignment = False
    inherited BtnOK: TButton
      Left = 241
      Top = 355
      Caption = #30830#23450
      TabOrder = 12
    end
    inherited BtnExit: TButton
      Left = 311
      Top = 355
      TabOrder = 13
    end
    object EditMemo: TcxMemo [2]
      Left = 69
      Top = 126
      ParentFont = False
      Properties.MaxLength = 50
      Properties.ScrollBars = ssVertical
      Style.Edges = [bBottom]
      TabOrder = 6
      Height = 45
      Width = 304
    end
    object EditProvider: TcxComboBox [3]
      Left = 69
      Top = 36
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.DropDownRows = 16
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      Properties.ItemHeight = 18
      Properties.MaxLength = 80
      TabOrder = 0
      Width = 121
    end
    object EditMate: TcxComboBox [4]
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
    object EditTruck: TcxComboBox [5]
      Left = 69
      Top = 215
      ParentFont = False
      Properties.DropDownRows = 16
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      Properties.ItemHeight = 18
      Properties.MaxLength = 15
      Properties.OnEditValueChanged = EditTruckPropertiesEditValueChanged
      TabOrder = 7
      Width = 100
    end
    object BtnGet: TButton [6]
      Left = 319
      Top = 215
      Width = 45
      Height = 20
      Caption = #35835#30917
      TabOrder = 9
      OnClick = BtnGetClick
    end
    object EditValue: TcxButtonEdit [7]
      Left = 220
      Top = 215
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditValuePropertiesButtonClick
      TabOrder = 8
      Width = 121
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
      Width = 353
    end
    object EditPNum: TcxTextEdit [9]
      Left = 69
      Top = 101
      ParentFont = False
      Properties.MaxLength = 15
      TabOrder = 4
      Width = 115
    end
    object EditPTime: TcxDateEdit [10]
      Left = 235
      Top = 101
      ParentFont = False
      Properties.SaveTime = False
      TabOrder = 5
      Width = 121
    end
    object EditSM: TcxComboBox [11]
      Left = 235
      Top = 61
      ParentFont = False
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      Properties.ItemHeight = 18
      Properties.MaxLength = 32
      TabOrder = 2
      Width = 121
    end
    object ListTruck: TcxMCListBox [12]
      Left = 23
      Top = 240
      Width = 121
      Height = 97
      HeaderSections = <
        item
          Text = #36710#29260#21495
          Width = 74
        end
        item
          Text = #21407#26448#26009
        end
        item
          Text = #19994#21153#21592
        end
        item
          Text = #20379#24212#21830
        end>
      ParentFont = False
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 10
      OnClick = ListTruckClick
    end
    object Check1: TcxCheckBox [13]
      Left = 11
      Top = 355
      Caption = #26356#26032#36710#36742#39044#32622#30382#37325
      ParentFont = False
      TabOrder = 11
      Transparent = True
      Width = 127
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxLayout1Item3: TdxLayoutItem
          Caption = #20379#24212#21830':'
          Control = EditProvider
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Group3: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          ShowBorder = False
          object dxLayout1Group5: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayout1Item4: TdxLayoutItem
              Caption = #21407#26448#26009':'
              Control = EditMate
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item10: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahClient
              Caption = #19994#21153#21592':'
              Control = EditSM
              ControlOptions.ShowBorder = False
            end
          end
          object dxLayout1Item7: TdxLayoutItem
            Caption = 'cxLabel1'
            ShowCaption = False
            Control = cxLabel1
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Group2: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item8: TdxLayoutItem
            Caption = #27966#36710#21333':'
            Control = EditPNum
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item9: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #26102'  '#38388':'
            Control = EditPTime
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Item12: TdxLayoutItem
          AutoAligns = [aaHorizontal]
          AlignVert = avClient
          Caption = #22791'  '#27880':'
          Control = EditMemo
          ControlOptions.ShowBorder = False
        end
      end
      object dxLayout1Group6: TdxLayoutGroup [1]
        AutoAligns = [aaHorizontal]
        AlignVert = avClient
        Caption = #36710#36742#31216#37325
        object dxLayout1Group7: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item13: TdxLayoutItem
            Caption = #36710#29260#21495':'
            Control = EditTruck
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item6: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #30917'  '#37325':'
            Control = EditValue
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item5: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahRight
            Caption = 'Button1'
            ShowCaption = False
            Control = BtnGet
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Item11: TdxLayoutItem
          AutoAligns = [aaHorizontal]
          AlignVert = avClient
          Caption = 'cxMCListBox1'
          ShowCaption = False
          Control = ListTruck
          ControlOptions.ShowBorder = False
        end
      end
      inherited dxLayout1Group1: TdxLayoutGroup
        object dxLayout1Item14: TdxLayoutItem [0]
          Caption = 'cxCheckBox1'
          ShowCaption = False
          Control = Check1
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end

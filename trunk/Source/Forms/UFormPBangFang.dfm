inherited fFormBangFang: TfFormBangFang
  Left = 467
  Top = 263
  ClientHeight = 240
  ClientWidth = 399
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 399
    Height = 240
    AutoControlAlignment = False
    inherited BtnOK: TButton
      Left = 253
      Top = 207
      Caption = #30830#23450
      TabOrder = 10
    end
    inherited BtnExit: TButton
      Left = 323
      Top = 207
      TabOrder = 11
    end
    object EditMemo: TcxMemo [2]
      Left = 69
      Top = 151
      ParentFont = False
      Properties.MaxLength = 50
      Properties.ScrollBars = ssVertical
      Style.Edges = [bBottom]
      TabOrder = 9
      Height = 55
      Width = 274
    end
    object EditProvider: TcxComboBox [3]
      Left = 69
      Top = 36
      ParentFont = False
      Properties.DropDownRows = 16
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
      Properties.DropDownRows = 16
      Properties.IncrementalSearch = False
      Properties.ItemHeight = 18
      Properties.MaxLength = 30
      TabOrder = 1
      Width = 112
    end
    object EditTruck: TcxComboBox [5]
      Left = 69
      Top = 101
      ParentFont = False
      Properties.DropDownRows = 16
      Properties.IncrementalSearch = False
      Properties.ItemHeight = 18
      Properties.MaxLength = 15
      TabOrder = 4
      Width = 112
    end
    object BtnGet: TButton [6]
      Left = 331
      Top = 101
      Width = 45
      Height = 20
      Caption = #35835#30917
      TabOrder = 6
      OnClick = BtnGetClick
    end
    object EditValue: TcxButtonEdit [7]
      Left = 232
      Top = 101
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditValuePropertiesButtonClick
      TabOrder = 5
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
      Top = 126
      ParentFont = False
      Properties.MaxLength = 15
      TabOrder = 7
      Width = 112
    end
    object EditPTime: TcxDateEdit [10]
      Left = 232
      Top = 126
      ParentFont = False
      Properties.SaveTime = False
      TabOrder = 8
      Width = 121
    end
    object EditSM: TcxComboBox [11]
      Left = 232
      Top = 61
      Properties.ItemHeight = 18
      Properties.MaxLength = 32
      TabOrder = 2
      Width = 121
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
        object dxLayout1Group4: TdxLayoutGroup
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
    end
  end
end

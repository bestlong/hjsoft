inherited fFormBangFang: TfFormBangFang
  Left = 252
  Top = 208
  ClientHeight = 213
  ClientWidth = 395
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 395
    Height = 213
    AutoContentSizes = [acsWidth]
    AutoControlAlignment = False
    inherited BtnOK: TButton
      Left = 249
      Top = 178
      Caption = #30830#23450
      TabOrder = 6
    end
    inherited BtnExit: TButton
      Left = 319
      Top = 178
      TabOrder = 7
    end
    object EditMemo: TcxMemo [2]
      Left = 69
      Top = 111
      ParentFont = False
      Properties.MaxLength = 50
      Properties.ScrollBars = ssVertical
      Style.Edges = [bBottom]
      TabOrder = 5
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
      Width = 121
    end
    object EditTruck: TcxComboBox [5]
      Left = 69
      Top = 86
      ParentFont = False
      Properties.DropDownRows = 16
      Properties.IncrementalSearch = False
      Properties.ItemHeight = 18
      Properties.MaxLength = 15
      TabOrder = 2
      Width = 112
    end
    object BtnGet: TButton [6]
      Left = 327
      Top = 86
      Width = 45
      Height = 20
      Caption = #35835#30917
      TabOrder = 4
      OnClick = BtnGetClick
    end
    object EditValue: TcxButtonEdit [7]
      Left = 220
      Top = 86
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditValuePropertiesButtonClick
      TabOrder = 3
      Width = 121
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxLayout1Item3: TdxLayoutItem
          Caption = #20379#24212#21830':'
          Control = EditProvider
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item4: TdxLayoutItem
          Caption = #21407#26448#26009':'
          Control = EditMate
          ControlOptions.ShowBorder = False
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
            Caption = #30917#37325':'
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
        object dxLayout1Item12: TdxLayoutItem
          Caption = #22791'  '#27880':'
          Control = EditMemo
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end

inherited fFormProvideJS_P: TfFormProvideJS_P
  Left = 313
  Top = 292
  ClientHeight = 215
  ClientWidth = 365
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 365
    Height = 215
    AutoContentSizes = [acsWidth, acsHeight]
    AutoControlAlignment = False
    inherited BtnOK: TButton
      Left = 219
      Top = 182
      Caption = #32467#31639
      TabOrder = 4
    end
    inherited BtnExit: TButton
      Left = 289
      Top = 182
      TabOrder = 5
    end
    object EditMate: TcxTextEdit [2]
      Left = 81
      Top = 86
      ParentFont = False
      Properties.MaxLength = 0
      Properties.ReadOnly = True
      TabOrder = 2
      Width = 110
    end
    object EditProvider: TcxTextEdit [3]
      Left = 81
      Top = 36
      ParentFont = False
      Properties.MaxLength = 80
      Properties.ReadOnly = False
      TabOrder = 0
      Width = 110
    end
    object EditMemo: TcxMemo [4]
      Left = 81
      Top = 111
      ParentFont = False
      Properties.MaxLength = 0
      Properties.ReadOnly = True
      Properties.ScrollBars = ssVertical
      Style.Edges = [bBottom]
      TabOrder = 3
      Height = 58
      Width = 282
    end
    object EditTruck: TcxTextEdit [5]
      Left = 81
      Top = 61
      ParentFont = False
      Properties.MaxLength = 80
      Properties.ReadOnly = False
      TabOrder = 1
      Width = 121
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        AutoAligns = [aaHorizontal]
        AlignVert = avClient
        object dxLayout1Group2: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          ShowBorder = False
          object dxLayout1Item9: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #20379' '#24212' '#21830':'
            Control = EditProvider
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item4: TdxLayoutItem
            Caption = #36710' '#29260' '#21495':'
            Control = EditTruck
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Item8: TdxLayoutItem
          AutoAligns = [aaVertical]
          AlignHorz = ahClient
          Caption = #21407' '#26448' '#26009':'
          Control = EditMate
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item12: TdxLayoutItem
          AutoAligns = [aaHorizontal]
          AlignVert = avClient
          Caption = #32467#31639#26126#32454':'
          Control = EditMemo
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end

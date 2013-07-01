inherited fFormProvide: TfFormProvide
  Left = 332
  Top = 501
  Caption = #20379#24212#35760#24405' - '#20462#25913
  ClientHeight = 215
  ClientWidth = 478
  PixelsPerInch = 120
  TextHeight = 15
  inherited dxLayout1: TdxLayoutControl
    Width = 478
    Height = 215
    inherited BtnOK: TButton
      Left = 296
      Top = 173
      TabOrder = 3
    end
    inherited BtnExit: TButton
      Left = 383
      Top = 173
      TabOrder = 4
    end
    object EditProvider: TcxTextEdit [2]
      Left = 81
      Top = 45
      ParentFont = False
      TabOrder = 0
      Width = 151
    end
    object EditMate: TcxTextEdit [3]
      Left = 81
      Top = 73
      ParentFont = False
      TabOrder = 1
      Width = 151
    end
    object EditWeight: TcxTextEdit [4]
      Left = 81
      Top = 101
      ParentFont = False
      TabOrder = 2
      Width = 151
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
        object dxLayout1Item5: TdxLayoutItem
          Caption = #20928#37325'(t):'
          Control = EditWeight
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end

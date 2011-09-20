inherited fFormBillPrice: TfFormBillPrice
  Left = 640
  Top = 361
  Width = 333
  Height = 363
  BorderStyle = bsSizeable
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 325
    Height = 329
    AutoControlAlignment = False
    inherited BtnOK: TButton
      Left = 179
      Top = 296
      TabOrder = 7
    end
    inherited BtnExit: TButton
      Left = 249
      Top = 296
      TabOrder = 8
    end
    object ListInfo: TcxMCListBox [2]
      Left = 23
      Top = 36
      Width = 358
      Height = 110
      HeaderSections = <
        item
          Text = #20449#24687#39033
          Width = 74
        end
        item
          AutoSize = True
          Text = #20449#24687#20869#23481
          Width = 280
        end>
      ParentFont = False
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 0
    end
    object EditBill: TcxTextEdit [3]
      Left = 69
      Top = 239
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 3
      Width = 92
    end
    object EditOPrice: TcxTextEdit [4]
      Left = 69
      Top = 264
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 92
    end
    object EditNPrice: TcxTextEdit [5]
      Left = 212
      Top = 264
      ParentFont = False
      TabOrder = 6
      Width = 121
    end
    object EditZK: TcxTextEdit [6]
      Left = 81
      Top = 182
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 2
      Width = 121
    end
    object EditValue: TcxTextEdit [7]
      Left = 212
      Top = 239
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 4
      Width = 121
    end
    object EditZID: TcxTextEdit [8]
      Left = 81
      Top = 157
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 1
      Width = 121
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        Caption = #32440#21345#20449#24687
        object dxLayout1Item3: TdxLayoutItem
          AutoAligns = [aaHorizontal]
          AlignVert = avClient
          Control = ListInfo
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item9: TdxLayoutItem
          Caption = #32440#21345#32534#21495':'
          Control = EditZID
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item5: TdxLayoutItem
          Caption = #32440#21345#29366#24577':'
          Control = EditZK
          ControlOptions.ShowBorder = False
        end
      end
      object Group2: TdxLayoutGroup [1]
        Caption = #25552#36135#21333#20215'('#20803'/'#21544')'
        object dxLayout1Group3: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item4: TdxLayoutItem
            AutoAligns = [aaVertical]
            Caption = #25552#36135#21333':'
            Control = EditBill
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item8: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #25552#36135#37327':'
            Control = EditValue
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Group2: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item6: TdxLayoutItem
            Caption = #21407#21333#20215':'
            Control = EditOPrice
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item7: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #26032#21333#20215':'
            Control = EditNPrice
            ControlOptions.ShowBorder = False
          end
        end
      end
      inherited dxLayout1Group1: TdxLayoutGroup
        inherited dxLayout1Item1: TdxLayoutItem
          AutoAligns = []
          AlignVert = avBottom
        end
      end
    end
  end
end

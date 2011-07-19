inherited fFormBadPound: TfFormBadPound
  Left = 348
  Top = 346
  ClientHeight = 214
  ClientWidth = 368
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 368
    Height = 214
    AutoControlAlignment = False
    inherited BtnOK: TButton
      Left = 222
      Top = 181
      Caption = #25171#21360
      TabOrder = 8
    end
    inherited BtnExit: TButton
      Left = 292
      Top = 181
      TabOrder = 9
    end
    object EditCus: TcxTextEdit [2]
      Left = 81
      Top = 36
      Hint = 'T.C_Name'
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 0
      Width = 100
    end
    object EditStock: TcxTextEdit [3]
      Left = 239
      Top = 106
      Hint = 'T.L_Stock'
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 121
    end
    object EditTruck: TcxTextEdit [4]
      Left = 81
      Top = 106
      Hint = 'T.L_TruckNo'
      Properties.ReadOnly = True
      TabOrder = 4
      Width = 95
    end
    object cxLabel1: TcxLabel [5]
      Left = 23
      Top = 86
      AutoSize = False
      ParentFont = False
      Properties.LineOptions.Alignment = cxllaBottom
      Properties.LineOptions.Visible = True
      Transparent = True
      Height = 15
      Width = 361
    end
    object EditZK: TcxTextEdit [6]
      Left = 81
      Top = 61
      Hint = 'T.E_ZID'
      Properties.ReadOnly = True
      TabOrder = 1
      Width = 95
    end
    object EditTH: TcxTextEdit [7]
      Left = 239
      Top = 61
      Hint = 'T.E_Bill'
      Properties.ReadOnly = True
      TabOrder = 2
      Width = 121
    end
    object EditP: TcxTextEdit [8]
      Left = 81
      Top = 131
      Hint = 'T.T_BFPValue'
      TabOrder = 6
      Width = 95
    end
    object EditM: TcxTextEdit [9]
      Left = 239
      Top = 131
      Hint = 'T.T_BFMValue'
      TabOrder = 7
      Width = 121
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxLayout1Item13: TdxLayoutItem
          Caption = #23458#25143#21517#31216':'
          Control = EditCus
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Group3: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item6: TdxLayoutItem
            Caption = #32440#21345#32534#21495':'
            Control = EditZK
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item7: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #25552#36135#21333#21495':'
            Control = EditTH
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Item5: TdxLayoutItem
          Caption = 'cxLabel1'
          ShowCaption = False
          Control = cxLabel1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Group2: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item4: TdxLayoutItem
            Caption = #36710#29260#21495#30721':'
            Control = EditTruck
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item3: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #27700#27877#21697#31181':'
            Control = EditStock
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Group4: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item8: TdxLayoutItem
            Caption = #30382#37325'('#21544'):'
            Control = EditP
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item9: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #27611#37325'('#21544'):'
            Control = EditM
            ControlOptions.ShowBorder = False
          end
        end
      end
    end
  end
end

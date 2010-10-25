inherited fFormProvideJS2: TfFormProvideJS2
  Left = 313
  Top = 292
  ClientHeight = 243
  ClientWidth = 394
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 394
    Height = 243
    AutoContentSizes = [acsWidth]
    AutoControlAlignment = False
    inherited BtnOK: TButton
      Left = 248
      Top = 210
      Caption = #30830#23450
      TabOrder = 9
    end
    inherited BtnExit: TButton
      Left = 318
      Top = 210
      TabOrder = 10
    end
    object EditMate: TcxTextEdit [2]
      Left = 81
      Top = 61
      ParentFont = False
      Properties.MaxLength = 0
      Properties.ReadOnly = True
      TabOrder = 1
      Width = 110
    end
    object EditWeight: TcxTextEdit [3]
      Left = 81
      Top = 86
      ParentFont = False
      Properties.MaxLength = 0
      Properties.ReadOnly = True
      TabOrder = 3
      Width = 110
    end
    object EditMoney: TcxTextEdit [4]
      Left = 81
      Top = 128
      Hint = 'T.L_Money'
      ParentFont = False
      Properties.MaxLength = 50
      TabOrder = 6
      Text = '0'
      Width = 110
    end
    object EditMemo: TcxMemo [5]
      Left = 81
      Top = 153
      Hint = 'T.L_Memo'
      ParentFont = False
      Properties.MaxLength = 50
      Properties.ScrollBars = ssVertical
      Style.Edges = [bBottom]
      TabOrder = 8
      Height = 45
      Width = 273
    end
    object EditYF: TcxTextEdit [6]
      Left = 254
      Top = 128
      Hint = 'T.L_YunFei'
      ParentFont = False
      TabOrder = 7
      Text = '0'
      Width = 121
    end
    object EditTruck: TcxTextEdit [7]
      Left = 254
      Top = 61
      ParentFont = False
      Properties.MaxLength = 0
      Properties.ReadOnly = True
      TabOrder = 2
      Width = 115
    end
    object cxLabel2: TcxLabel [8]
      Left = 23
      Top = 111
      AutoSize = False
      ParentFont = False
      Properties.LineOptions.Alignment = cxllaBottom
      Properties.LineOptions.Visible = True
      Transparent = True
      Height = 12
      Width = 358
    end
    object EditPrice: TcxTextEdit [9]
      Left = 254
      Top = 86
      Hint = 'T.L_Price'
      ParentFont = False
      Properties.OnEditValueChanged = EditPricePropertiesEditValueChanged
      TabOrder = 4
      Width = 121
    end
    object EditTime: TcxTextEdit [10]
      Left = 81
      Top = 36
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 0
      Width = 121
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxLayout1Group8: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          ShowBorder = False
          object dxLayout1Item4: TdxLayoutItem
            Caption = #26680#31639#26102#38388':'
            Control = EditTime
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Group4: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayout1Item8: TdxLayoutItem
              AutoAligns = [aaVertical]
              Caption = #21407' '#26448' '#26009':'
              Control = EditMate
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item5: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahClient
              Caption = #36710' '#29260' '#21495':'
              Control = EditTruck
              ControlOptions.ShowBorder = False
            end
          end
        end
        object dxLayout1Group3: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          ShowBorder = False
          object dxLayout1Group5: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            ShowBorder = False
            object dxLayout1Group7: TdxLayoutGroup
              ShowCaption = False
              Hidden = True
              LayoutDirection = ldHorizontal
              ShowBorder = False
              object dxLayout1Item9: TdxLayoutItem
                AutoAligns = [aaVertical]
                Caption = #20928#37325'('#21544'):'
                Control = EditWeight
                ControlOptions.ShowBorder = False
              end
              object dxLayout1Item10: TdxLayoutItem
                AutoAligns = [aaVertical]
                AlignHorz = ahClient
                Caption = #21333#20215'('#20803'):'
                Control = EditPrice
                ControlOptions.ShowBorder = False
              end
            end
            object dxLayout1Item6: TdxLayoutItem
              Caption = 'cxLabel2'
              ShowCaption = False
              Control = cxLabel2
              ControlOptions.ShowBorder = False
            end
          end
          object dxLayout1Group2: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayout1Item11: TdxLayoutItem
              AutoAligns = [aaVertical]
              Caption = #32467#31639#37329#39069':'
              Control = EditMoney
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item3: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahClient
              Caption = #36816#36153'('#20803'):'
              Control = EditYF
              ControlOptions.ShowBorder = False
            end
          end
          object dxLayout1Item12: TdxLayoutItem
            Caption = #22791#27880#20449#24687':'
            Control = EditMemo
            ControlOptions.ShowBorder = False
          end
        end
      end
    end
  end
end

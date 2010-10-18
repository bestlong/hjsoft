inherited fFormProvideJS: TfFormProvideJS
  Left = 313
  Top = 292
  ClientHeight = 251
  ClientWidth = 404
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 404
    Height = 251
    AutoContentSizes = [acsWidth]
    AutoControlAlignment = False
    inherited BtnOK: TButton
      Left = 258
      Top = 210
      Caption = #30830#23450
      TabOrder = 9
    end
    inherited BtnExit: TButton
      Left = 328
      Top = 210
      TabOrder = 10
    end
    object Edit1: TcxTextEdit [2]
      Left = 69
      Top = 36
      Hint = 'T.L_Provider'
      ParentFont = False
      Properties.MaxLength = 0
      Properties.ReadOnly = True
      TabOrder = 0
      Width = 403
    end
    object Edit2: TcxTextEdit [3]
      Left = 69
      Top = 61
      Hint = 'T.L_Mate'
      ParentFont = False
      Properties.MaxLength = 0
      Properties.ReadOnly = True
      TabOrder = 1
      Width = 120
    end
    object EditWeight: TcxTextEdit [4]
      Left = 252
      Top = 86
      ParentFont = False
      Properties.MaxLength = 0
      Properties.ReadOnly = True
      TabOrder = 4
      Width = 100
    end
    object EditMoney: TcxTextEdit [5]
      Left = 81
      Top = 128
      Hint = 'T.L_Money'
      ParentFont = False
      Properties.MaxLength = 50
      TabOrder = 6
      Text = '0'
      Width = 108
    end
    object EditMemo: TcxMemo [6]
      Left = 81
      Top = 153
      Hint = 'T.L_Memo'
      ParentFont = False
      Properties.MaxLength = 50
      Properties.ScrollBars = ssVertical
      Style.Edges = [bBottom]
      TabOrder = 8
      Height = 45
      Width = 403
    end
    object EditYF: TcxTextEdit [7]
      Left = 252
      Top = 128
      Hint = 'T.L_YunFei'
      TabOrder = 7
      Text = '0'
      Width = 121
    end
    object cxTextEdit2: TcxTextEdit [8]
      Left = 240
      Top = 61
      Hint = 'T.L_PaiNum'
      Properties.MaxLength = 0
      Properties.ReadOnly = True
      TabOrder = 2
      Width = 121
    end
    object Edit3: TcxTextEdit [9]
      Left = 69
      Top = 86
      Hint = 'T.L_Truck'
      Properties.MaxLength = 0
      Properties.ReadOnly = True
      TabOrder = 3
      Width = 120
    end
    object cxLabel2: TcxLabel [10]
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
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxLayout1Item7: TdxLayoutItem
          Caption = #20379#24212#21830':'
          Control = Edit1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Group3: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          ShowBorder = False
          object dxLayout1Group6: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayout1Item8: TdxLayoutItem
              Caption = #21407#26448#26009':'
              Control = Edit2
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item4: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahClient
              Caption = #27966#36710#21333':'
              Control = cxTextEdit2
              ControlOptions.ShowBorder = False
            end
          end
          object dxLayout1Group4: TdxLayoutGroup
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
                object dxLayout1Item5: TdxLayoutItem
                  Caption = #36710#29260#21495':'
                  Control = Edit3
                  ControlOptions.ShowBorder = False
                end
                object dxLayout1Item9: TdxLayoutItem
                  AutoAligns = [aaVertical]
                  AlignHorz = ahClient
                  Caption = #20928#37325'('#21544'):'
                  Control = EditWeight
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
end

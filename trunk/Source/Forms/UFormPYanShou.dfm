inherited fFormYanShou: TfFormYanShou
  Left = 316
  Top = 224
  ClientHeight = 249
  ClientWidth = 448
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 448
    Height = 249
    AutoContentSizes = [acsWidth]
    AutoControlAlignment = False
    inherited BtnOK: TButton
      Left = 302
      Top = 213
      Caption = #30830#23450
      TabOrder = 10
    end
    inherited BtnExit: TButton
      Left = 372
      Top = 213
      TabOrder = 11
    end
    object EditDate: TcxDateEdit [2]
      Left = 81
      Top = 36
      ParentFont = False
      Properties.Kind = ckDateTime
      TabOrder = 0
      Width = 166
    end
    object EditMan: TcxTextEdit [3]
      Left = 298
      Top = 36
      ParentFont = False
      Properties.MaxLength = 32
      Properties.ReadOnly = True
      TabOrder = 1
      Width = 174
    end
    object cxLabel2: TcxLabel [4]
      Left = 23
      Top = 61
      AutoSize = False
      ParentFont = False
      Properties.Alignment.Vert = taBottomJustify
      Properties.LineOptions.Alignment = cxllaBottom
      Properties.LineOptions.Visible = True
      Transparent = True
      Height = 15
      Width = 461
      AnchorY = 76
    end
    object EditName: TcxTextEdit [5]
      Left = 69
      Top = 81
      Hint = 'T.S_Sender'
      ParentFont = False
      Properties.MaxLength = 100
      Properties.ReadOnly = True
      TabOrder = 3
      Width = 403
    end
    object EditMate: TcxTextEdit [6]
      Left = 69
      Top = 106
      ParentFont = False
      Properties.MaxLength = 100
      Properties.ReadOnly = True
      TabOrder = 4
      Width = 403
    end
    object EditValue: TcxTextEdit [7]
      Left = 69
      Top = 131
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 124
    end
    object cxLabel1: TcxLabel [8]
      Left = 198
      Top = 131
      AutoSize = False
      Caption = #21544
      ParentFont = False
      Properties.Alignment.Vert = taVCenter
      Transparent = True
      Height = 20
      Width = 26
      AnchorY = 141
    end
    object EditKC: TcxTextEdit [9]
      Left = 275
      Top = 131
      ParentFont = False
      Properties.MaxLength = 50
      TabOrder = 7
      Width = 209
    end
    object EditMemo: TcxMemo [10]
      Left = 81
      Top = 156
      ParentFont = False
      Properties.MaxLength = 50
      Properties.ScrollBars = ssVertical
      Style.Edges = [bBottom]
      TabOrder = 9
      Height = 45
      Width = 403
    end
    object cxLabel3: TcxLabel [11]
      Left = 399
      Top = 131
      AutoSize = False
      Caption = #21544
      ParentFont = False
      Properties.Alignment.Vert = taVCenter
      Transparent = True
      Height = 20
      Width = 26
      AnchorY = 141
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxLayout1Group2: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item3: TdxLayoutItem
            Caption = #39564#25910#26102#38388':'
            Control = EditDate
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item4: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #39564#25910#20154':'
            Control = EditMan
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Item5: TdxLayoutItem
          ShowCaption = False
          Control = cxLabel2
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item7: TdxLayoutItem
          Caption = #20379#24212#21830':'
          Control = EditName
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Group3: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          ShowBorder = False
          object dxLayout1Item8: TdxLayoutItem
            Caption = #21407#26448#26009':'
            Control = EditMate
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Group4: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            ShowBorder = False
            object dxLayout1Group5: TdxLayoutGroup
              ShowCaption = False
              Hidden = True
              LayoutDirection = ldHorizontal
              ShowBorder = False
              object dxLayout1Item9: TdxLayoutItem
                Caption = #20379#24212#37327':'
                Control = EditValue
                ControlOptions.ShowBorder = False
              end
              object dxLayout1Item10: TdxLayoutItem
                ShowCaption = False
                Control = cxLabel1
                ControlOptions.ShowBorder = False
              end
              object dxLayout1Item11: TdxLayoutItem
                AutoAligns = [aaVertical]
                AlignHorz = ahClient
                Caption = #25187#38500#37327':'
                Control = EditKC
                ControlOptions.ShowBorder = False
              end
              object dxLayout1Item6: TdxLayoutItem
                ShowCaption = False
                Control = cxLabel3
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

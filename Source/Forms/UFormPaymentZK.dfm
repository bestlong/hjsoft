inherited fFormPaymentZK: TfFormPaymentZK
  Left = 244
  Top = 161
  ClientHeight = 431
  ClientWidth = 416
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 416
    Height = 431
    AutoContentSizes = [acsWidth, acsHeight]
    inherited BtnOK: TButton
      Left = 270
      Top = 398
      TabOrder = 11
    end
    inherited BtnExit: TButton
      Left = 340
      Top = 398
      TabOrder = 12
    end
    object EditType: TcxComboBox [2]
      Left = 81
      Top = 290
      ParentFont = False
      Properties.IncrementalSearch = False
      Properties.ItemHeight = 18
      Properties.MaxLength = 20
      TabOrder = 5
      Width = 112
    end
    object EditMoney: TcxTextEdit [3]
      Left = 256
      Top = 290
      ParentFont = False
      Properties.OnEditValueChanged = EditMoneyPropertiesEditValueChanged
      TabOrder = 6
      Text = '0'
      Width = 80
    end
    object EditDesc: TcxMemo [4]
      Left = 81
      Top = 340
      ParentFont = False
      Properties.MaxLength = 200
      Properties.ScrollBars = ssVertical
      TabOrder = 10
      Height = 65
      Width = 313
    end
    object cxLabel2: TcxLabel [5]
      Left = 368
      Top = 290
      AutoSize = False
      Caption = #20803
      ParentFont = False
      Properties.Alignment.Horz = taLeftJustify
      Properties.Alignment.Vert = taVCenter
      Transparent = True
      Height = 20
      Width = 25
      AnchorY = 300
    end
    object ListInfo: TcxMCListBox [6]
      Left = 23
      Top = 36
      Width = 427
      Height = 110
      HeaderSections = <
        item
          Text = #20449#24687#39033
          Width = 85
        end
        item
          AutoSize = True
          Text = #20449#24687#20869#23481
          Width = 338
        end>
      ParentFont = False
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 0
    end
    object EditSC: TcxTextEdit [7]
      Left = 81
      Top = 233
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 4
      Width = 112
    end
    object EditZK: TcxTextEdit [8]
      Left = 81
      Top = 151
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 1
      Width = 112
    end
    object EditCard: TcxTextEdit [9]
      Left = 256
      Top = 151
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 2
      Width = 121
    end
    object EditXT: TcxTextEdit [10]
      Left = 81
      Top = 208
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 3
      Width = 121
    end
    object EditZKMoney: TcxTextEdit [11]
      Left = 81
      Top = 315
      ParentFont = False
      Properties.OnEditValueChanged = EditZKMoneyPropertiesEditValueChanged
      TabOrder = 8
      Text = '0'
      Width = 112
    end
    object cxLabel1: TcxLabel [12]
      Left = 198
      Top = 315
      Caption = #27880':'#22686#21152#32440#21345#30340#38480#25552#37329#39069'.'
      ParentFont = False
      Transparent = True
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        Caption = #32440#21345#20449#24687
        object dxLayout1Item7: TdxLayoutItem
          Control = ListInfo
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Group2: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item9: TdxLayoutItem
            Caption = #32440#21345#32534#21495':'
            Control = EditZK
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item10: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #30913#21345#32534#21495':'
            Control = EditCard
            ControlOptions.ShowBorder = False
          end
        end
      end
      object dxGroup3: TdxLayoutGroup [1]
        Caption = #32440#21345#29366#24577
        object dxLayout1Item8: TdxLayoutItem
          Caption = #38480#21046#25552#36135':'
          Control = EditXT
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item12: TdxLayoutItem
          Caption = #25552#36135#26102#38271':'
          Control = EditSC
          ControlOptions.ShowBorder = False
        end
      end
      object dxGroup2: TdxLayoutGroup [2]
        AutoAligns = [aaHorizontal]
        AlignVert = avClient
        Caption = #36135#27454#22238#25910
        object dxLayout1Group3: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          ShowBorder = False
          object dxLayout1Group4: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayout1Item3: TdxLayoutItem
              Caption = #20184#27454#26041#24335':'
              Control = EditType
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item4: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahClient
              Caption = #32564#32435#37329#39069':'
              Control = EditMoney
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item6: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahRight
              ShowCaption = False
              Control = cxLabel2
              ControlOptions.ShowBorder = False
            end
          end
          object dxLayout1Group5: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayout1Item11: TdxLayoutItem
              Caption = #32440#21345#37329#39069':'
              Control = EditZKMoney
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item13: TdxLayoutItem
              Caption = 'cxLabel1'
              ShowCaption = False
              Control = cxLabel1
              ControlOptions.ShowBorder = False
            end
          end
        end
        object dxLayout1Item5: TdxLayoutItem
          AutoAligns = [aaHorizontal]
          AlignVert = avClient
          Caption = #22791#27880#20449#24687':'
          Control = EditDesc
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end

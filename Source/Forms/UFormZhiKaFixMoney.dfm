inherited fFormZhiKaFixMoney: TfFormZhiKaFixMoney
  Left = 280
  Top = 161
  ClientHeight = 383
  ClientWidth = 390
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 390
    Height = 383
    AutoContentSizes = [acsWidth]
    AutoControlAlignment = False
    inherited BtnOK: TButton
      Left = 244
      Top = 348
      Caption = #30830#23450
      TabOrder = 8
    end
    inherited BtnExit: TButton
      Left = 314
      Top = 348
      TabOrder = 9
    end
    object ListInfo: TcxMCListBox [2]
      Left = 23
      Top = 36
      Width = 374
      Height = 110
      HeaderSections = <
        item
          Text = #20449#24687#39033
          Width = 74
        end
        item
          AutoSize = True
          Text = #20449#24687#20869#23481
          Width = 296
        end>
      ParentFont = False
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 0
    end
    object EditZK: TcxTextEdit [3]
      Left = 81
      Top = 151
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 1
      Width = 105
    end
    object EditOut: TcxTextEdit [4]
      Left = 249
      Top = 208
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 3
      Text = '0'
      Width = 121
    end
    object EditIn: TcxTextEdit [5]
      Left = 81
      Top = 208
      ParentFont = False
      Properties.MaxLength = 15
      Properties.ReadOnly = True
      TabOrder = 2
      Text = '0'
      Width = 105
    end
    object EditFreeze: TcxTextEdit [6]
      Left = 81
      Top = 233
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 4
      Text = '0'
      Width = 105
    end
    object EditValid: TcxTextEdit [7]
      Left = 249
      Top = 233
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 5
      Text = '0'
      Width = 121
    end
    object EditMoney: TcxTextEdit [8]
      Left = 81
      Top = 290
      ParentFont = False
      TabOrder = 6
      Width = 121
    end
    object Check1: TcxCheckBox [9]
      Left = 23
      Top = 315
      Caption = #38480#21046#35813#32440#21345#30340#21487#25552#36135#37327'.'
      ParentFont = False
      TabOrder = 7
      Transparent = True
      Width = 121
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        Caption = #32440#21345#20449#24687
        object dxLayout1Item3: TdxLayoutItem
          Control = ListInfo
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item5: TdxLayoutItem
          Caption = #32440#21345#32534#21495':'
          Control = EditZK
          ControlOptions.ShowBorder = False
        end
      end
      object dxGroup2: TdxLayoutGroup [1]
        Caption = #36134#25143#20449#24687
        object dxLayout1Group5: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item9: TdxLayoutItem
            Caption = #20837#37329#24635#39069':'
            Control = EditIn
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item8: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #20986#37329#24635#39069':'
            Control = EditOut
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Group4: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item7: TdxLayoutItem
            Caption = #20923#32467#37329#39069':'
            Control = EditFreeze
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item10: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #21487#29992#37329#39069':'
            Control = EditValid
            ControlOptions.ShowBorder = False
          end
        end
      end
      object dxGroup3: TdxLayoutGroup [2]
        Caption = #21487#25552#36135#37329#39069
        object dxLayout1Item4: TdxLayoutItem
          AutoAligns = [aaVertical]
          AlignHorz = ahClient
          Caption = #37329#39069'('#20803'):'
          Control = EditMoney
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item11: TdxLayoutItem
          AutoAligns = [aaVertical]
          AlignHorz = ahClient
          Caption = 'cxCheckBox1'
          ShowCaption = False
          Control = Check1
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end

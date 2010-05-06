inherited fFormZhiKaInfo: TfFormZhiKaInfo
  Left = 280
  Top = 161
  ClientHeight = 435
  ClientWidth = 418
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 418
    Height = 435
    AutoContentSizes = [acsWidth]
    AutoControlAlignment = False
    inherited BtnOK: TButton
      Left = 272
      Top = 402
      TabOrder = 9
    end
    inherited BtnExit: TButton
      Left = 342
      Top = 402
      Caption = #20851#38381
      TabOrder = 10
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
      Width = 120
    end
    object EditCard: TcxTextEdit [4]
      Left = 264
      Top = 151
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 2
      Width = 105
    end
    object ListTruck: TcxListView [5]
      Left = 23
      Top = 290
      Width = 355
      Height = 100
      Columns = <
        item
          Caption = #36710#29260#21495#30721
          Width = 70
        end
        item
          Caption = #24403#21069#29366#24577
          Width = 100
        end
        item
          Caption = #36827#21378#26102#38388
        end>
      ParentFont = False
      ReadOnly = True
      RowSelect = True
      SmallImages = FDM.ImageBar
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 7
      ViewStyle = vsReport
    end
    object EditOut: TcxTextEdit [6]
      Left = 264
      Top = 208
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 4
      Text = '0'
      Width = 121
    end
    object EditIn: TcxTextEdit [7]
      Left = 81
      Top = 208
      ParentFont = False
      Properties.MaxLength = 15
      Properties.ReadOnly = True
      TabOrder = 3
      Text = '0'
      Width = 120
    end
    object EditFreeze: TcxTextEdit [8]
      Left = 81
      Top = 233
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 5
      Text = '0'
      Width = 120
    end
    object EditValid: TcxTextEdit [9]
      Left = 264
      Top = 233
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 6
      Text = '0'
      Width = 121
    end
    object BtnMore: TButton [10]
      Left = 11
      Top = 402
      Width = 55
      Height = 22
      Caption = #26356#22810'...'
      TabOrder = 8
      OnClick = BtnMoreClick
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        Caption = #32440#21345#20449#24687
        object dxLayout1Item3: TdxLayoutItem
          Control = ListInfo
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Group2: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item5: TdxLayoutItem
            Caption = #32440#21345#32534#21495':'
            Control = EditZK
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item6: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #30913#21345#32534#21495':'
            Control = EditCard
            ControlOptions.ShowBorder = False
          end
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
        Caption = #25552#36135#36710#36742
        object dxLayout1Item4: TdxLayoutItem
          Caption = 'New Item'
          ShowCaption = False
          Control = ListTruck
          ControlOptions.ShowBorder = False
        end
      end
      inherited dxLayout1Group1: TdxLayoutGroup
        object dxLayout1Item11: TdxLayoutItem [0]
          Caption = 'Button1'
          ShowCaption = False
          Control = BtnMore
          ControlOptions.ShowBorder = False
        end
        inherited dxLayout1Item1: TdxLayoutItem
          Visible = False
        end
      end
    end
  end
end

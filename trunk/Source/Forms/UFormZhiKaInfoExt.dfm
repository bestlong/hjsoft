inherited fFormZhiKaInfoExt: TfFormZhiKaInfoExt
  Left = 586
  Top = 222
  ClientHeight = 402
  ClientWidth = 381
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 381
    Height = 402
    AutoContentSizes = [acsWidth, acsHeight]
    AutoControlAlignment = False
    inherited BtnOK: TButton
      Left = 235
      Top = 369
      TabOrder = 7
    end
    inherited BtnExit: TButton
      Left = 305
      Top = 369
      Caption = #20851#38381
      TabOrder = 8
    end
    object ListCard: TcxListView [2]
      Left = 23
      Top = 255
      Width = 341
      Height = 95
      Columns = <
        item
          Caption = #30913#21345#32534#21495
          Width = 70
        end
        item
          Caption = #24403#21069#29366#24577
          Width = 100
        end
        item
          Caption = #26159#21542#20923#32467
          Width = 80
        end>
      ParentFont = False
      ReadOnly = True
      RowSelect = True
      SmallImages = FDM.ImageBar
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 5
      ViewStyle = vsReport
    end
    object ListStock: TcxListView [3]
      Left = 23
      Top = 36
      Width = 323
      Height = 100
      Columns = <
        item
          Caption = #27700#27877#21517#31216
          Width = 70
        end
        item
          Caption = #21333#20215'('#20803'/'#21544')'
          Width = 100
        end
        item
          Caption = #21487#25552#36135#37327'('#21544')'
          Width = 95
        end>
      ParentFont = False
      ReadOnly = True
      RowSelect = True
      SmallImages = FDM.ImageBar
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 0
      ViewStyle = vsReport
    end
    object EditOut: TcxTextEdit [4]
      Left = 256
      Top = 173
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 2
      Text = '0'
      Width = 121
    end
    object BtnMore: TButton [5]
      Left = 11
      Top = 369
      Width = 55
      Height = 22
      Caption = #26356#22810'...'
      TabOrder = 6
      OnClick = BtnMoreClick
    end
    object EditIn: TcxTextEdit [6]
      Left = 81
      Top = 173
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 1
      Text = '0'
      Width = 112
    end
    object EditValid: TcxTextEdit [7]
      Left = 256
      Top = 198
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 4
      Text = '0'
      Width = 121
    end
    object EditFreeze: TcxTextEdit [8]
      Left = 81
      Top = 198
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 3
      Text = '0'
      Width = 112
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        Caption = #21697#31181#21015#34920' '#27880':'#21487#25552#36135#37327'='#21487#29992#37329#247#21333#20215
        object dxLayout1Item5: TdxLayoutItem
          Control = ListStock
          ControlOptions.ShowBorder = False
        end
      end
      object dxGroup3: TdxLayoutGroup [1]
        Caption = #24080#25143#20449#24687
        object dxLayout1Group4: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item7: TdxLayoutItem
            AutoAligns = [aaVertical]
            Caption = #20837#37329#24635#39069':'
            Control = EditIn
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item3: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #20986#37329#24635#39069':'
            Control = EditOut
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Group3: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item9: TdxLayoutItem
            Caption = #20923#32467#37329#39069':'
            Control = EditFreeze
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item8: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #21487#29992#37329#39069':'
            Control = EditValid
            ControlOptions.ShowBorder = False
          end
        end
      end
      object dxGroup2: TdxLayoutGroup [2]
        AutoAligns = [aaHorizontal]
        AlignVert = avClient
        Caption = #30913#21345#21015#34920
        object dxLayout1Item4: TdxLayoutItem
          AutoAligns = [aaHorizontal]
          AlignVert = avClient
          Caption = 'New Item'
          ShowCaption = False
          Control = ListCard
          ControlOptions.ShowBorder = False
        end
      end
      inherited dxLayout1Group1: TdxLayoutGroup
        object dxLayout1Item6: TdxLayoutItem [0]
          Caption = 'New Item'
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

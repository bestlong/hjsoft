inherited fFormZhiKaInfoExt2: TfFormZhiKaInfoExt2
  Left = 321
  Top = 195
  Width = 535
  Height = 333
  BorderStyle = bsSizeable
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 527
    Height = 299
    AutoContentSizes = [acsWidth, acsHeight]
    AutoControlAlignment = False
    inherited BtnOK: TButton
      Left = 381
      Top = 266
      TabOrder = 1
    end
    inherited BtnExit: TButton
      Left = 451
      Top = 266
      Caption = #20851#38381
      TabOrder = 2
    end
    object ListBill: TcxListView [2]
      Left = 23
      Top = 36
      Width = 323
      Height = 100
      Columns = <
        item
          Caption = #25552#36135#21333#21495
          Width = 70
        end
        item
          Caption = #27700#27877#21517#31216
        end
        item
          Alignment = taCenter
          Caption = #21333#20215'('#20803'/'#21544')'
          Width = 100
        end
        item
          Alignment = taCenter
          Caption = #21150#29702#37327'('#21544')'
          Width = 80
        end
        item
          Alignment = taCenter
          Caption = #36710#29260#21495#30721
        end
        item
          Alignment = taCenter
          Caption = #24403#21069#29366#24577
        end>
      ParentFont = False
      ReadOnly = True
      RowSelect = True
      SmallImages = FDM.ImageBar
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 0
      ViewStyle = vsReport
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        AutoAligns = [aaHorizontal]
        AlignVert = avClient
        Caption = #25552#36135#21015#34920
        object dxLayout1Item5: TdxLayoutItem
          AutoAligns = [aaHorizontal]
          AlignVert = avClient
          Control = ListBill
          ControlOptions.ShowBorder = False
        end
      end
      inherited dxLayout1Group1: TdxLayoutGroup
        inherited dxLayout1Item1: TdxLayoutItem
          Visible = False
        end
      end
    end
  end
end

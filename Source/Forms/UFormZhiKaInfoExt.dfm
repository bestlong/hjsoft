inherited fFormZhiKaInfoExt: TfFormZhiKaInfoExt
  Left = 321
  Top = 195
  ClientHeight = 396
  ClientWidth = 387
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 387
    Height = 396
    AutoContentSizes = [acsWidth]
    AutoControlAlignment = False
    inherited BtnOK: TButton
      Left = 241
      Top = 362
      TabOrder = 5
    end
    inherited BtnExit: TButton
      Left = 311
      Top = 362
      Caption = #20851#38381
      TabOrder = 6
    end
    object ListCard: TcxListView [2]
      Left = 23
      Top = 173
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
      TabOrder = 1
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
          Caption = #21150#29702#37327'('#21544')'
          Width = 80
        end>
      ParentFont = False
      ReadOnly = True
      RowSelect = True
      SmallImages = FDM.ImageBar
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 0
      ViewStyle = vsReport
    end
    object EditSC: TcxTextEdit [4]
      Left = 81
      Top = 330
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 3
      Width = 121
    end
    object BtnMore: TButton [5]
      Left = 11
      Top = 362
      Width = 55
      Height = 22
      Caption = #26356#22810'...'
      TabOrder = 4
      OnClick = BtnMoreClick
    end
    object EditXT: TcxTextEdit [6]
      Left = 81
      Top = 305
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 2
      Width = 121
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        Caption = #21697#31181#21015#34920
        object dxLayout1Item5: TdxLayoutItem
          Control = ListStock
          ControlOptions.ShowBorder = False
        end
      end
      object dxGroup2: TdxLayoutGroup [1]
        Caption = #30913#21345#21015#34920
        object dxLayout1Item4: TdxLayoutItem
          Caption = 'New Item'
          ShowCaption = False
          Control = ListCard
          ControlOptions.ShowBorder = False
        end
      end
      object dxGroup3: TdxLayoutGroup [2]
        Caption = #20854#23427#20449#24687
        object dxLayout1Item7: TdxLayoutItem
          Caption = #38480#21046#25552#36135':'
          Control = EditXT
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item3: TdxLayoutItem
          Caption = #25552#36135#26102#38271':'
          Control = EditSC
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

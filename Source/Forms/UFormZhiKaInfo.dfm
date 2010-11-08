inherited fFormZhiKaInfo: TfFormZhiKaInfo
  Left = 280
  Top = 161
  ClientHeight = 437
  ClientWidth = 410
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 410
    Height = 437
    AutoContentSizes = [acsWidth, acsHeight]
    AutoControlAlignment = False
    inherited BtnOK: TButton
      Left = 264
      Top = 404
      TabOrder = 7
    end
    inherited BtnExit: TButton
      Left = 334
      Top = 404
      Caption = #20851#38381
      TabOrder = 8
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
      TabOrder = 5
      ViewStyle = vsReport
    end
    object EditSC: TcxTextEdit [6]
      Left = 81
      Top = 233
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 4
      Width = 121
    end
    object EditXT: TcxTextEdit [7]
      Left = 81
      Top = 208
      ParentFont = False
      Properties.MaxLength = 15
      Properties.ReadOnly = True
      TabOrder = 3
      Width = 120
    end
    object BtnMore: TButton [8]
      Left = 11
      Top = 404
      Width = 55
      Height = 22
      Caption = #26356#22810'...'
      TabOrder = 6
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
        Caption = #32440#21345#29366#24577
        object dxLayout1Item9: TdxLayoutItem
          Caption = #38480#21046#25552#36135':'
          Control = EditXT
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item8: TdxLayoutItem
          AutoAligns = [aaVertical]
          AlignHorz = ahClient
          Caption = #25552#36135#26102#38271':'
          Control = EditSC
          ControlOptions.ShowBorder = False
        end
      end
      object dxGroup3: TdxLayoutGroup [2]
        AutoAligns = [aaHorizontal]
        AlignVert = avClient
        Caption = #25552#36135#36710#36742
        object dxLayout1Item4: TdxLayoutItem
          AutoAligns = [aaHorizontal]
          AlignVert = avClient
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

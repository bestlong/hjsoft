inherited fFormSanHeKa: TfFormSanHeKa
  Left = 404
  Top = 174
  ClientHeight = 412
  ClientWidth = 411
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 411
    Height = 412
    AutoContentSizes = [acsWidth]
    inherited BtnOK: TButton
      Left = 265
      Top = 375
      Caption = #30830#23450
      TabOrder = 7
    end
    inherited BtnExit: TButton
      Left = 335
      Top = 375
      TabOrder = 8
    end
    object ListInfo: TcxMCListBox [2]
      Left = 23
      Top = 36
      Width = 365
      Height = 115
      HeaderSections = <
        item
          Text = #20449#24687#39033
          Width = 85
        end
        item
          AutoSize = True
          Text = #20449#24687#20869#23481
          Width = 276
        end>
      ParentFont = False
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 0
    end
    object ListBill: TcxListView [3]
      Left = 23
      Top = 263
      Width = 365
      Height = 100
      Columns = <
        item
          Caption = #32440#21345#32534#21495
          Width = 80
        end
        item
          Caption = #21697#31181#21517#31216
          Width = 100
        end
        item
          Caption = #21333#20215'('#20803'/'#21544')'
          Width = 80
        end
        item
          Caption = #21512#21345#37327'('#21544')'
          Width = 80
        end>
      ParentFont = False
      ReadOnly = True
      RowSelect = True
      SmallImages = FDM.ImageBar
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 6
      ViewStyle = vsReport
    end
    object EditCard: TcxButtonEdit [4]
      Left = 81
      Top = 156
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditCardPropertiesButtonClick
      TabOrder = 1
      OnKeyPress = OnCtrlKeyPress
      Width = 121
    end
    object EditValue: TcxTextEdit [5]
      Left = 81
      Top = 238
      ParentFont = False
      Properties.ReadOnly = False
      TabOrder = 3
      Width = 121
    end
    object BtnAdd: TButton [6]
      Left = 283
      Top = 238
      Width = 50
      Height = 20
      Caption = #28155#21152
      TabOrder = 4
      OnClick = BtnAddClick
    end
    object BtnDel: TButton [7]
      Left = 338
      Top = 238
      Width = 50
      Height = 20
      Caption = #21024#38500
      TabOrder = 5
      OnClick = BtnDelClick
    end
    object EditStock: TcxTextEdit [8]
      Left = 81
      Top = 213
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 2
      Width = 121
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        Caption = #32440#21345#20449#24687
        object dxLayout1Item7: TdxLayoutItem
          Control = ListInfo
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item4: TdxLayoutItem
          Caption = #30913#21345#32534#21495':'
          Control = EditCard
          ControlOptions.ShowBorder = False
        end
      end
      object dxGroup2: TdxLayoutGroup [1]
        Caption = #21512#21345#26126#32454
        object dxLayout1Group3: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          ShowBorder = False
          object dxLayout1Item6: TdxLayoutItem
            Caption = #27700#27877#20449#24687':'
            Control = EditStock
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Group4: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayout1Item5: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahClient
              Caption = #21512#21345#21544#25968':'
              Control = EditValue
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item8: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahRight
              Caption = 'Button1'
              ShowCaption = False
              Control = BtnAdd
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item9: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahRight
              Caption = 'Button2'
              ShowCaption = False
              Control = BtnDel
              ControlOptions.ShowBorder = False
            end
          end
        end
        object dxLayout1Item3: TdxLayoutItem
          Caption = 'New Item'
          ShowCaption = False
          Control = ListBill
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end

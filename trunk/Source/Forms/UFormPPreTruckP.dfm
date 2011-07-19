inherited fFormPPreTruckP: TfFormPPreTruckP
  Left = 570
  Top = 274
  ClientHeight = 244
  ClientWidth = 379
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 379
    Height = 244
    AutoControlAlignment = False
    inherited BtnOK: TButton
      Left = 233
      Top = 211
      Caption = #30830#23450
      TabOrder = 6
    end
    inherited BtnExit: TButton
      Left = 303
      Top = 211
      TabOrder = 7
    end
    object EditCard: TcxTextEdit [2]
      Left = 69
      Top = 36
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 0
      Width = 282
    end
    object EditTruck: TcxTextEdit [3]
      Left = 69
      Top = 61
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 1
      Width = 95
    end
    object EditValue: TcxButtonEdit [4]
      Left = 203
      Top = 61
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditValuePropertiesButtonClick
      TabOrder = 2
      Width = 98
    end
    object BtnGet: TButton [5]
      Left = 311
      Top = 61
      Width = 45
      Height = 20
      Caption = #35835#30917
      TabOrder = 3
      OnClick = BtnGetClick
    end
    object cxLabel1: TcxLabel [6]
      Left = 23
      Top = 86
      AutoSize = False
      ParentFont = False
      Properties.Alignment.Vert = taBottomJustify
      Properties.LineOptions.Alignment = cxllaBottom
      Properties.LineOptions.Visible = True
      Transparent = True
      Height = 7
      Width = 333
      AnchorY = 93
    end
    object ListTruck: TcxMCListBox [7]
      Left = 23
      Top = 98
      Width = 328
      Height = 88
      HeaderSections = <
        item
          AutoSize = True
          Text = #36710#36742#21015#34920
          Width = 324
        end>
      ParentFont = False
      PopupMenu = PMenu1
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 5
      OnClick = ListTruckClick
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxLayout1Item3: TdxLayoutItem
          Caption = #30913#21345#21495':'
          Control = EditCard
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Group2: TdxLayoutGroup
          AutoAligns = [aaHorizontal]
          AlignVert = avClient
          ShowCaption = False
          Hidden = True
          ShowBorder = False
          object dxLayout1Group3: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayout1Item4: TdxLayoutItem
              Caption = #36710#29260#21495':'
              Control = EditTruck
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item5: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahClient
              Caption = #30382#37325':'
              Control = EditValue
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item6: TdxLayoutItem
              ShowCaption = False
              Control = BtnGet
              ControlOptions.ShowBorder = False
            end
          end
          object dxLayout1Item7: TdxLayoutItem
            ShowCaption = False
            Control = cxLabel1
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item8: TdxLayoutItem
            AutoAligns = [aaHorizontal]
            AlignVert = avClient
            Control = ListTruck
            ControlOptions.ShowBorder = False
          end
        end
      end
    end
  end
  object PMenu1: TPopupMenu
    AutoHotkeys = maManual
    OnPopup = PMenu1Popup
    Left = 30
    Top = 122
    object N1: TMenuItem
      Caption = #21462#28040#39044#32622
      OnClick = N1Click
    end
    object N2: TMenuItem
      Caption = #20840#37096#21462#28040
      OnClick = N1Click
    end
  end
end

inherited fFormCustomerCredit: TfFormCustomerCredit
  Left = 301
  Top = 288
  ClientHeight = 209
  ClientWidth = 397
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 397
    Height = 209
    AutoContentSizes = [acsWidth]
    inherited BtnOK: TButton
      Left = 251
      Top = 173
      Caption = #30830#23450
      TabOrder = 5
    end
    inherited BtnExit: TButton
      Left = 321
      Top = 173
      TabOrder = 6
    end
    object EditSaleMan: TcxComboBox [2]
      Left = 81
      Top = 36
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.DropDownRows = 20
      Properties.ImmediateDropDown = False
      Properties.ItemHeight = 18
      Properties.OnChange = EditSaleManPropertiesChange
      TabOrder = 0
      Width = 301
    end
    object EditCus: TcxComboBox [3]
      Left = 81
      Top = 61
      ParentFont = False
      Properties.DropDownRows = 20
      Properties.ImmediateDropDown = False
      Properties.ItemHeight = 18
      Properties.MaxLength = 35
      TabOrder = 1
      OnKeyPress = EditCusKeyPress
      Width = 301
    end
    object EditCredit: TcxTextEdit [4]
      Left = 81
      Top = 86
      ParentFont = False
      Properties.ReadOnly = False
      TabOrder = 2
      Text = '0'
      Width = 85
    end
    object cxLabel1: TcxLabel [5]
      Left = 171
      Top = 86
      AutoSize = False
      Caption = #20803' '#22791#27880':'#37329#39069#20026#36127#34920#31034#20943#23567#20449#29992#39069#24230'.'
      ParentFont = False
      Properties.Alignment.Vert = taVCenter
      Transparent = True
      Height = 20
      Width = 204
      AnchorY = 96
    end
    object EditMemo: TcxMemo [6]
      Left = 81
      Top = 111
      ParentFont = False
      Properties.MaxLength = 50
      Properties.ScrollBars = ssVertical
      Style.Edges = [bBottom]
      TabOrder = 4
      Height = 50
      Width = 301
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxLayout1Item3: TdxLayoutItem
          Caption = #19994#21153#20154#21592':'
          Control = EditSaleMan
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Group2: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          ShowBorder = False
          object dxLayout1Item4: TdxLayoutItem
            Caption = #23458#25143#21015#34920':'
            Control = EditCus
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Group3: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            ShowBorder = False
            object dxLayout1Group4: TdxLayoutGroup
              ShowCaption = False
              Hidden = True
              LayoutDirection = ldHorizontal
              ShowBorder = False
              object dxLayout1Item5: TdxLayoutItem
                Caption = #20449#29992#37329#39069':'
                Control = EditCredit
                ControlOptions.ShowBorder = False
              end
              object dxLayout1Item6: TdxLayoutItem
                AutoAligns = [aaVertical]
                AlignHorz = ahClient
                ShowCaption = False
                Control = cxLabel1
                ControlOptions.ShowBorder = False
              end
            end
            object dxLayout1Item7: TdxLayoutItem
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

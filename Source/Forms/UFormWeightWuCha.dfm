inherited fFormWeightWuCha: TfFormWeightWuCha
  ClientHeight = 175
  ClientWidth = 350
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 350
    Height = 175
    AutoContentSizes = [acsWidth]
    inherited BtnOK: TButton
      Left = 204
      Top = 141
      TabOrder = 8
    end
    inherited BtnExit: TButton
      Left = 274
      Top = 141
      TabOrder = 9
    end
    object Radio1: TcxRadioButton [2]
      Left = 23
      Top = 36
      Width = 70
      Height = 17
      Caption = #22266#23450#20540'.'
      Checked = True
      ParentColor = False
      TabOrder = 0
      TabStop = True
    end
    object Radio2: TcxRadioButton [3]
      Left = 23
      Top = 85
      Width = 70
      Height = 17
      Caption = #28014#21160#20540'.'
      ParentColor = False
      TabOrder = 4
    end
    object cxLabel2: TcxLabel [4]
      Left = 23
      Top = 107
      AutoSize = False
      Caption = #20928#37325#35823#24046#22312
      ParentFont = False
      Transparent = True
      Height = 22
      Width = 64
    end
    object EditVal1: TcxTextEdit [5]
      Left = 178
      Top = 58
      ParentFont = False
      TabOrder = 2
      Text = '0'
      Width = 65
    end
    object cxLabel1: TcxLabel [6]
      Left = 23
      Top = 58
      AutoSize = False
      Caption = #20928#37325#35823#24046#22312#25552#36135#37327#19978#19979#28014#21160
      ParentFont = False
      Transparent = True
      Height = 22
      Width = 150
    end
    object cxLabel4: TcxLabel [7]
      Left = 248
      Top = 58
      AutoSize = False
      Caption = #20844#26020'.'
      ParentFont = False
      Transparent = True
      Height = 22
      Width = 150
    end
    object EditVal2: TcxTextEdit [8]
      Left = 92
      Top = 107
      ParentFont = False
      TabOrder = 6
      Text = '0'
      Width = 65
    end
    object cxLabel3: TcxLabel [9]
      Left = 162
      Top = 107
      AutoSize = False
      Caption = #20844#26020'/'#21544#19978#19979#28014#21160'.'
      ParentFont = False
      Transparent = True
      Height = 22
      Width = 161
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxLayout1Item3: TdxLayoutItem
          Caption = 'cxRadioButton1'
          ShowCaption = False
          Control = Radio1
          ControlOptions.AutoColor = True
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Group4: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item7: TdxLayoutItem
            AutoAligns = [aaVertical]
            ShowCaption = False
            Control = cxLabel1
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item5: TdxLayoutItem
            AutoAligns = [aaVertical]
            Control = EditVal1
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item8: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            ShowCaption = False
            Control = cxLabel4
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Group3: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          ShowBorder = False
          object dxLayout1Item4: TdxLayoutItem
            AutoAligns = [aaVertical]
            Caption = 'cxRadioButton2'
            ShowCaption = False
            Control = Radio2
            ControlOptions.AutoColor = True
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Group2: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayout1Item6: TdxLayoutItem
              Caption = 'cxLabel2'
              ShowCaption = False
              Control = cxLabel2
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item9: TdxLayoutItem
              Control = EditVal2
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item11: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahClient
              ShowCaption = False
              Control = cxLabel3
              ControlOptions.ShowBorder = False
            end
          end
        end
      end
    end
  end
end

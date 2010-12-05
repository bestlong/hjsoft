object fFormZTParam: TfFormZTParam
  Left = 385
  Top = 234
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  ClientHeight = 381
  ClientWidth = 397
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 12
  object dxLayoutControl1: TdxLayoutControl
    Left = 0
    Top = 0
    Width = 397
    Height = 381
    Align = alClient
    TabOrder = 0
    TabStop = False
    AutoContentSizes = [acsWidth, acsHeight]
    AutoControlAlignment = False
    LookAndFeel = FDM.dxLayoutWeb1
    object EditDesc: TcxTextEdit
      Left = 213
      Top = 36
      ParentFont = False
      Properties.MaxLength = 50
      TabOrder = 1
      Width = 120
    end
    object EditWeight: TcxTextEdit
      Left = 57
      Top = 238
      ParentFont = False
      TabOrder = 8
      Width = 121
    end
    object BtnExit: TButton
      Left = 321
      Top = 348
      Width = 65
      Height = 22
      Caption = #21462#28040
      ModalResult = 2
      TabOrder = 13
    end
    object BtnOK: TButton
      Left = 251
      Top = 348
      Width = 65
      Height = 22
      Caption = #20445#23384
      TabOrder = 12
      OnClick = BtnOKClick
    end
    object PortList1: TcxComboBox
      Left = 57
      Top = 36
      ParentFont = False
      Properties.IncrementalSearch = False
      Properties.ItemHeight = 18
      TabOrder = 0
      Width = 105
    end
    object cxLabel1: TcxLabel
      Left = 304
      Top = 238
      Caption = #20844#26020'(Kg)/'#34955
      ParentFont = False
      Transparent = True
    end
    object EditStock: TcxCheckComboBox
      Left = 81
      Top = 295
      ParentFont = False
      Properties.EmptySelectionText = #31354
      Properties.DropDownRows = 15
      Properties.EditValueFormat = cvfStatesString
      Properties.Items = <>
      TabOrder = 10
      Width = 121
    end
    object cxLabel2: TcxLabel
      Left = 23
      Top = 320
      Caption = #25552#31034': '#22312#21015#34920#20013#34987#36873#20013#30340#21697#31181#23558#19981#22312#35745#25968#31649#29702#20013#26174#31034'.'
      ParentFont = False
      Transparent = True
    end
    object ListTunnel: TcxMCListBox
      Left = 23
      Top = 115
      Width = 121
      Height = 97
      HeaderSections = <
        item
          Text = #35013#36710#32447
          Width = 80
        end
        item
          Alignment = taCenter
          Text = #31471#21475
          Width = 65
        end
        item
          Alignment = taCenter
          Text = #30828#20214#32534#21495
          Width = 65
        end
        item
          Alignment = taCenter
          Text = #27599#21253#24310#36831
          Width = 65
        end>
      ParentFont = False
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 6
      OnClick = ListTunnelClick
    end
    object cxLabel3: TcxLabel
      Left = 23
      Top = 221
      AutoSize = False
      ParentFont = False
      Properties.LineOptions.Alignment = cxllaBottom
      Properties.LineOptions.Visible = True
      Transparent = True
      Height = 12
      Width = 10
    end
    object EditNum: TcxTextEdit
      Left = 57
      Top = 61
      TabOrder = 2
      Width = 120
    end
    object EditDelay: TcxTextEdit
      Left = 57
      Top = 88
      TabOrder = 4
      Width = 121
    end
    object BtnDel: TcxButton
      Left = 309
      Top = 88
      Width = 65
      Height = 22
      Caption = #21024#38500
      TabOrder = 5
      OnClick = BtnDelClick
    end
    object BtnAdd: TcxButton
      Left = 309
      Top = 61
      Width = 65
      Height = 22
      Caption = #28155#21152
      TabOrder = 3
      OnClick = BtnAddClick
    end
    object dxLayoutControl1Group_Root: TdxLayoutGroup
      ShowCaption = False
      Hidden = True
      ShowBorder = False
      object dxLayoutControl1Group1: TdxLayoutGroup
        AutoAligns = [aaHorizontal]
        AlignVert = avClient
        Caption = #26632#21488#21442#25968
        object dxLayoutControl1Group5: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayoutControl1Item9: TdxLayoutItem
            AutoAligns = [aaVertical]
            Caption = #31471#21475':'
            Control = PortList1
            ControlOptions.ShowBorder = False
          end
          object dxLayoutControl1Item1: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #35013#36710#32447':'
            Control = EditDesc
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayoutControl1Group6: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          ShowBorder = False
          object dxLayoutControl1Group8: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayoutControl1Item11: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahClient
              Caption = #32534#21495':'
              Control = EditNum
              ControlOptions.ShowBorder = False
            end
            object dxLayoutControl1Item14: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahRight
              Caption = 'cxButton2'
              ShowCaption = False
              Control = BtnAdd
              ControlOptions.ShowBorder = False
            end
          end
          object dxLayoutControl1Group7: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayoutControl1Item12: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahClient
              Caption = #24310#36831':'
              Control = EditDelay
              ControlOptions.ShowBorder = False
            end
            object dxLayoutControl1Item13: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahRight
              Caption = 'cxButton1'
              ShowCaption = False
              Control = BtnDel
              ControlOptions.ShowBorder = False
            end
          end
        end
        object dxLayoutControl1Item6: TdxLayoutItem
          AutoAligns = [aaHorizontal]
          AlignVert = avClient
          Caption = 'cxMCListBox1'
          ShowCaption = False
          Control = ListTunnel
          ControlOptions.ShowBorder = False
        end
        object dxLayoutControl1Item10: TdxLayoutItem
          Caption = 'cxLabel3'
          ShowCaption = False
          Control = cxLabel3
          ControlOptions.ShowBorder = False
        end
        object dxLayoutControl1Group3: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayoutControl1Item2: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #34955#37325':'
            Control = EditWeight
            ControlOptions.ShowBorder = False
          end
          object dxLayoutControl1Item3: TdxLayoutItem
            Caption = 'cxLabel1'
            ShowCaption = False
            Control = cxLabel1
            ControlOptions.ShowBorder = False
          end
        end
      end
      object dxLayoutControl1Group4: TdxLayoutGroup
        AutoAligns = [aaHorizontal]
        AlignVert = avBottom
        Caption = #21697#31181#31579#36873
        object dxLayoutControl1Item4: TdxLayoutItem
          Caption = #21697#31181#21015#34920':'
          Control = EditStock
          ControlOptions.ShowBorder = False
        end
        object dxLayoutControl1Item5: TdxLayoutItem
          Caption = 'cxLabel2'
          ShowCaption = False
          Control = cxLabel2
          ControlOptions.ShowBorder = False
        end
      end
      object dxLayoutControl1Group2: TdxLayoutGroup
        AutoAligns = [aaHorizontal]
        AlignVert = avBottom
        ShowCaption = False
        Hidden = True
        LayoutDirection = ldHorizontal
        ShowBorder = False
        object dxLayoutControl1Item8: TdxLayoutItem
          AutoAligns = [aaVertical]
          AlignHorz = ahRight
          Caption = 'Button2'
          ShowCaption = False
          Control = BtnOK
          ControlOptions.ShowBorder = False
        end
        object dxLayoutControl1Item7: TdxLayoutItem
          AutoAligns = []
          AlignHorz = ahRight
          AlignVert = avBottom
          Caption = 'Button1'
          ShowCaption = False
          Control = BtnExit
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end

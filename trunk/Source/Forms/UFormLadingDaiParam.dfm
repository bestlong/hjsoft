object fFormZTParam: TfFormZTParam
  Left = 478
  Top = 300
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  ClientHeight = 233
  ClientWidth = 338
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
    Width = 338
    Height = 233
    Align = alClient
    TabOrder = 0
    TabStop = False
    LookAndFeel = FDM.dxLayoutWeb1
    object EditDesc: TcxTextEdit
      Left = 81
      Top = 61
      ParentFont = False
      Properties.MaxLength = 50
      Properties.OnChange = EditDescPropertiesChange
      TabOrder = 1
      Width = 209
    end
    object EditWeight: TcxTextEdit
      Left = 81
      Top = 86
      ParentFont = False
      TabOrder = 2
      Width = 121
    end
    object BtnExit: TButton
      Left = 256
      Top = 196
      Width = 65
      Height = 22
      Caption = #21462#28040
      ModalResult = 2
      TabOrder = 7
    end
    object BtnOK: TButton
      Left = 186
      Top = 196
      Width = 65
      Height = 22
      Caption = #20445#23384
      TabOrder = 6
      OnClick = BtnOKClick
    end
    object PortList1: TcxComboBox
      Left = 81
      Top = 36
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.IncrementalSearch = False
      Properties.ItemHeight = 18
      Properties.OnChange = PortList1PropertiesChange
      TabOrder = 0
      Width = 121
    end
    object cxLabel1: TcxLabel
      Left = 239
      Top = 86
      Caption = #20844#26020'(Kg)/'#34955
      ParentFont = False
      Transparent = True
    end
    object EditStock: TcxCheckComboBox
      Left = 81
      Top = 143
      ParentFont = False
      Properties.EmptySelectionText = #31354
      Properties.DropDownRows = 15
      Properties.EditValueFormat = cvfStatesString
      Properties.Items = <>
      TabOrder = 4
      Width = 121
    end
    object cxLabel2: TcxLabel
      Left = 23
      Top = 168
      Caption = #25552#31034': '#22312#21015#34920#20013#34987#36873#20013#30340#21697#31181#23558#19981#22312#35745#25968#31649#29702#20013#26174#31034'.'
      ParentFont = False
      Transparent = True
    end
    object dxLayoutControl1Group_Root: TdxLayoutGroup
      ShowCaption = False
      Hidden = True
      ShowBorder = False
      object dxLayoutControl1Group1: TdxLayoutGroup
        Caption = #26632#21488#21442#25968
        object dxLayoutControl1Item9: TdxLayoutItem
          Caption = #31471#21475':'
          Control = PortList1
          ControlOptions.ShowBorder = False
        end
        object dxLayoutControl1Item1: TdxLayoutItem
          Caption = #25551#36848':'
          Control = EditDesc
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

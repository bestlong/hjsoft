inherited fFormZhiKaCard: TfFormZhiKaCard
  Left = 278
  Top = 178
  ClientHeight = 416
  ClientWidth = 420
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 420
    Height = 416
    AutoContentSizes = [acsWidth]
    inherited BtnOK: TButton
      Left = 274
      Top = 381
      TabOrder = 5
    end
    inherited BtnExit: TButton
      Left = 344
      Top = 381
      TabOrder = 6
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
    object Check1: TcxCheckBox [3]
      Left = 23
      Top = 176
      Caption = #20849#29992#23494#30721': '#25152#26377#30913#21345#20351#29992#32479#19968#30340#23494#30721','#21508#30913#21345#21333#29420#23494#30721#23558#34987#24573#30053'.'
      ParentFont = False
      TabOrder = 2
      Transparent = True
      Width = 121
    end
    object ListCard: TcxListView [4]
      Left = 23
      Top = 259
      Width = 357
      Height = 110
      Checkboxes = True
      Columns = <
        item
          Caption = #30913#21345#32534#21495
          Width = 80
        end
        item
          Caption = #30913#21345#29366#24577
          Width = 80
        end
        item
          Caption = #21333#29420#23494#30721
          Width = 100
        end>
      ParentFont = False
      ReadOnly = True
      RowSelect = True
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 4
      ViewStyle = vsReport
      OnClick = ListCardClick
      OnDblClick = ListCardDblClick
    end
    object EditPwd: TcxButtonEdit [5]
      Left = 81
      Top = 151
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.EchoMode = eemPassword
      Properties.PasswordChar = '*'
      Properties.ReadOnly = True
      Properties.OnButtonClick = EditIDPropertiesButtonClick
      TabOrder = 1
      OnKeyPress = EditCardKeyPress
      Width = 121
    end
    object EditCard: TcxButtonEdit [6]
      Left = 81
      Top = 234
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = cxButtonEdit1PropertiesButtonClick
      TabOrder = 3
      OnKeyPress = EditCardKeyPress
      Width = 121
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        Caption = #32440#21345#20449#24687
        object dxLayout1Item3: TdxLayoutItem
          Caption = 'cxMCListBox1'
          ShowCaption = False
          Control = ListInfo
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item4: TdxLayoutItem
          Caption = #32440#21345#23494#30721':'
          Control = EditPwd
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item6: TdxLayoutItem
          Caption = 'cxCheckBox1'
          ShowCaption = False
          Control = Check1
          ControlOptions.ShowBorder = False
        end
      end
      object dxGroup2: TdxLayoutGroup [1]
        Caption = #30913#21345#21015#34920
        object dxLayout1Item5: TdxLayoutItem
          Caption = #30913#21345#32534#21495':'
          Control = EditCard
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item7: TdxLayoutItem
          Caption = 'cxListView1'
          ShowCaption = False
          Control = ListCard
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end

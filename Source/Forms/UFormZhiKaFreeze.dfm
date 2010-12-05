inherited fFormZKFreeze: TfFormZKFreeze
  Left = 553
  Top = 331
  ClientHeight = 148
  ClientWidth = 308
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 308
    Height = 148
    AutoContentSizes = [acsWidth, acsHeight]
    inherited BtnOK: TButton
      Left = 162
      Top = 115
      TabOrder = 3
    end
    inherited BtnExit: TButton
      Left = 232
      Top = 115
      TabOrder = 4
    end
    object EditStock: TcxComboBox [2]
      Left = 81
      Top = 36
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.IncrementalSearch = False
      Properties.ItemHeight = 18
      Properties.MaxLength = 35
      TabOrder = 0
      Width = 121
    end
    object Radio1: TcxRadioButton [3]
      Left = 23
      Top = 61
      Width = 113
      Height = 17
      Caption = #20923#32467#21253#21547#35813#27700#27877#30340#25152#26377#32440#21345'.'
      Checked = True
      ParentColor = False
      TabOrder = 1
      TabStop = True
    end
    object Radio2: TcxRadioButton [4]
      Left = 23
      Top = 83
      Width = 113
      Height = 17
      Caption = #35299#38500#20923#32467#21253#21547#35813#27700#27877#30340#32440#21345'.'
      ParentColor = False
      TabOrder = 2
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        AutoAligns = [aaHorizontal]
        AlignVert = avClient
        Caption = #36873#39033
        object dxLayout1Item13: TdxLayoutItem
          AutoAligns = [aaVertical]
          AlignHorz = ahClient
          Caption = #27700#27877#31867#22411':'
          Control = EditStock
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item3: TdxLayoutItem
          Caption = 'cxRadioButton1'
          ShowCaption = False
          Control = Radio1
          ControlOptions.AutoColor = True
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item4: TdxLayoutItem
          Caption = 'cxRadioButton2'
          ShowCaption = False
          Control = Radio2
          ControlOptions.AutoColor = True
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end

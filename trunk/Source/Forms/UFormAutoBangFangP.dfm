inherited fFormAutoBFP: TfFormAutoBFP
  ClientHeight = 181
  ClientWidth = 318
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 318
    Height = 181
    AutoContentSizes = [acsWidth]
    inherited BtnOK: TButton
      Left = 172
      Top = 141
      TabOrder = 4
    end
    inherited BtnExit: TButton
      Left = 242
      Top = 141
      TabOrder = 5
    end
    object Radio1: TcxRadioButton [2]
      Left = 23
      Top = 36
      Width = 113
      Height = 17
      Caption = #33258#21160#31216#37327#30382#37325
      Checked = True
      ParentColor = False
      TabOrder = 0
      TabStop = True
    end
    object Radio2: TcxRadioButton [3]
      Left = 23
      Top = 85
      Width = 113
      Height = 17
      Caption = #20851#38381#33258#21160#31216#37325
      ParentColor = False
      TabOrder = 2
    end
    object cxLabel1: TcxLabel [4]
      Left = 23
      Top = 58
      AutoSize = False
      Caption = #31995#32479#20250#23545'24'#23567#26102#20197#20869#31216#37327#36807#30382#37325#30340#36710#36742#33258#21160#38500#30382'.'
      ParentFont = False
      Transparent = True
      Height = 22
      Width = 272
    end
    object cxLabel2: TcxLabel [5]
      Left = 23
      Top = 107
      AutoSize = False
      Caption = #25152#26377#36710#36742#38656#35201#21040#30917#25151#31216#37327#30382#37325'.'
      ParentFont = False
      Transparent = True
      Height = 22
      Width = 272
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
        object dxLayout1Item5: TdxLayoutItem
          Caption = 'cxLabel1'
          ShowCaption = False
          Control = cxLabel1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item4: TdxLayoutItem
          Caption = 'cxRadioButton2'
          ShowCaption = False
          Control = Radio2
          ControlOptions.AutoColor = True
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item6: TdxLayoutItem
          Caption = 'cxLabel2'
          ShowCaption = False
          Control = cxLabel2
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end

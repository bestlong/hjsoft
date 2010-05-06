inherited fFormZhiKaParam: TfFormZhiKaParam
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
      Caption = #31995#32479#33258#21160#23457#26680
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
      Caption = #20154#24037#25163#21160#23457#26680
      ParentColor = False
      TabOrder = 2
    end
    object cxLabel1: TcxLabel [4]
      Left = 23
      Top = 58
      AutoSize = False
      Caption = #32440#21345#33258#21160#23457#26680','#21150#29702#32440#21345#21518#21487#30452#25509#25552#36135'.'
      ParentFont = False
      Transparent = True
      Height = 22
      Width = 272
    end
    object cxLabel2: TcxLabel [5]
      Left = 23
      Top = 107
      AutoSize = False
      Caption = #32440#21345#38656#35201#20154#24037#23457#26680#21518','#25165#21487#20197#24320#21333#25552#36135'.'
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

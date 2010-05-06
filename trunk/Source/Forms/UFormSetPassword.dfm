inherited fFormSetPassword: TfFormSetPassword
  ClientHeight = 129
  ClientWidth = 255
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 255
    Height = 129
    AutoContentSizes = [acsWidth]
    inherited BtnOK: TButton
      Left = 109
      Top = 93
      Caption = #30830#23450
      TabOrder = 2
    end
    inherited BtnExit: TButton
      Left = 179
      Top = 93
      TabOrder = 3
    end
    object EditNew: TcxTextEdit [2]
      Left = 81
      Top = 36
      Properties.EchoMode = eemPassword
      Properties.MaxLength = 16
      Properties.PasswordChar = '*'
      TabOrder = 0
      OnKeyPress = EditNewKeyPress
      Width = 121
    end
    object EditNext: TcxTextEdit [3]
      Left = 81
      Top = 61
      Properties.EchoMode = eemPassword
      Properties.MaxLength = 16
      Properties.PasswordChar = '*'
      TabOrder = 1
      OnKeyPress = EditNewKeyPress
      Width = 121
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        Caption = #23494#30721#35774#32622
        object dxLayout1Item3: TdxLayoutItem
          Caption = #36755#20837#23494#30721':'
          Control = EditNew
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item4: TdxLayoutItem
          Caption = #20877#36755#19968#27425':'
          Control = EditNext
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end

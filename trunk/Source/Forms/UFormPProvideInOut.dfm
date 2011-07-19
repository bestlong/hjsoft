inherited fFormPProvideInOut: TfFormPProvideInOut
  Left = 470
  Top = 326
  Width = 370
  Height = 403
  BorderStyle = bsSizeable
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 362
    Height = 369
    AutoControlAlignment = False
    AutoControlTabOrders = False
    inherited BtnOK: TButton
      Left = 216
      Top = 336
      TabOrder = 1
    end
    inherited BtnExit: TButton
      Left = 286
      Top = 336
      TabOrder = 2
    end
    object ListTrucks: TcxMCListBox [2]
      Left = 23
      Top = 36
      Width = 341
      Height = 105
      HeaderSections = <
        item
          Text = #36710#29260#21495
          Width = 70
        end
        item
          Text = #20379#24212#21830
          Width = 105
        end
        item
          AutoSize = True
          Text = #21407#26448#26009
          Width = 162
        end>
      ItemHeight = 20
      ParentFont = False
      Style.BorderStyle = cbsOffice11
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 0
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        Caption = #20379#24212#26126#32454
        object dxLayout1Item4: TdxLayoutItem
          AutoAligns = [aaHorizontal]
          AlignVert = avClient
          Control = ListTrucks
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end

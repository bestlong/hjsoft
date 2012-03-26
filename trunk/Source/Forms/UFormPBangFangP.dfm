inherited fFormPBangFangP: TfFormPBangFangP
  Left = 312
  Top = 190
  ClientHeight = 298
  ClientWidth = 431
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 431
    Height = 298
    AutoControlAlignment = False
    inherited BtnOK: TButton
      Left = 285
      Top = 265
      TabOrder = 12
    end
    inherited BtnExit: TButton
      Left = 355
      Top = 265
      TabOrder = 13
    end
    object EditValue: TcxButtonEdit [2]
      Left = 234
      Top = 208
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      Properties.OnButtonClick = EditValuePropertiesButtonClick
      Properties.OnEditValueChanged = EditKZPropertiesEditValueChanged
      TabOrder = 9
      Text = '0'
      Width = 121
    end
    object BtnGet: TButton [3]
      Left = 360
      Top = 208
      Width = 45
      Height = 22
      Caption = #35835#21462#30917
      TabOrder = 11
      OnClick = BtnGetClick
    end
    object EditPNum: TcxTextEdit [4]
      Left = 69
      Top = 101
      ParentFont = False
      Properties.MaxLength = 15
      TabOrder = 4
      Width = 115
    end
    object cxLabel1: TcxLabel [5]
      Left = 23
      Top = 86
      AutoSize = False
      ParentFont = False
      Properties.LineOptions.Alignment = cxllaBottom
      Properties.LineOptions.Visible = True
      Transparent = True
      Height = 10
      Width = 341
    end
    object EditPTime: TcxDateEdit [6]
      Left = 235
      Top = 101
      ParentFont = False
      Properties.SaveTime = False
      TabOrder = 5
      Width = 129
    end
    object EditMemo: TcxMemo [7]
      Left = 69
      Top = 126
      ParentFont = False
      Properties.MaxLength = 50
      Properties.ScrollBars = ssVertical
      Style.Edges = [bBottom]
      TabOrder = 6
      Height = 32
      Width = 307
    end
    object EditProvider: TcxTextEdit [8]
      Left = 69
      Top = 36
      Properties.ReadOnly = True
      TabOrder = 0
      Width = 121
    end
    object EditMate: TcxTextEdit [9]
      Left = 69
      Top = 61
      Properties.ReadOnly = True
      TabOrder = 1
      Width = 115
    end
    object EditSM: TcxTextEdit [10]
      Left = 235
      Top = 61
      Properties.ReadOnly = True
      TabOrder = 2
      Width = 121
    end
    object EditKZ: TcxTextEdit [11]
      Left = 81
      Top = 233
      Properties.OnEditValueChanged = EditKZPropertiesEditValueChanged
      TabOrder = 8
      Text = '0'
      Width = 90
    end
    object EditMValue: TcxTextEdit [12]
      Left = 81
      Top = 208
      Properties.ReadOnly = True
      TabOrder = 7
      Text = '0'
      Width = 90
    end
    object EditWeight: TcxTextEdit [13]
      Left = 234
      Top = 233
      Properties.ReadOnly = True
      TabOrder = 10
      Text = '0'
      Width = 121
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxLayout1Item13: TdxLayoutItem
          Caption = #20379#24212#21830':'
          Control = EditProvider
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Group2: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          ShowBorder = False
          object dxLayout1Group4: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayout1Item14: TdxLayoutItem
              Caption = #21407#26448#26009':'
              Control = EditMate
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item15: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahClient
              Caption = #19994#21153#21592':'
              Control = EditSM
              ControlOptions.ShowBorder = False
            end
          end
          object dxLayout1Item10: TdxLayoutItem
            ShowCaption = False
            Control = cxLabel1
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Group5: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayout1Item6: TdxLayoutItem
              Caption = #27966#36710#21333':'
              Control = EditPNum
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item11: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahClient
              Caption = #26102'  '#38388':'
              Control = EditPTime
              ControlOptions.ShowBorder = False
            end
          end
        end
        object dxLayout1Item12: TdxLayoutItem
          AutoAligns = []
          AlignHorz = ahClient
          AlignVert = avClient
          Caption = #22791'  '#27880':'
          Control = EditMemo
          ControlOptions.ShowBorder = False
        end
      end
      object dxGroup2: TdxLayoutGroup [1]
        AutoAligns = [aaHorizontal]
        AlignVert = avBottom
        Caption = #36710#36742#20449#24687
        LayoutDirection = ldHorizontal
        object dxLayout1Group7: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          ShowBorder = False
          object dxLayout1Item4: TdxLayoutItem
            Caption = #27611#37325'('#21544'):'
            Control = EditMValue
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item3: TdxLayoutItem
            Caption = #25187#26434'('#21544'):'
            Control = EditKZ
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Group3: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          ShowBorder = False
          object dxLayout1Item9: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #30382#37325'('#21544'):'
            Control = EditValue
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item7: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #20928#37325'('#21544'):'
            Control = EditWeight
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Item5: TdxLayoutItem
          Caption = 'Button1'
          ShowCaption = False
          Control = BtnGet
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end

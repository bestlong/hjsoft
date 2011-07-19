inherited fFormProvideCard: TfFormProvideCard
  Left = 428
  Top = 379
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  ClientHeight = 204
  ClientWidth = 357
  OldCreateOrder = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 12
  object dxLayoutControl1: TdxLayoutControl
    Left = 0
    Top = 0
    Width = 357
    Height = 204
    Align = alClient
    TabOrder = 0
    TabStop = False
    AutoContentSizes = [acsWidth, acsHeight]
    LookAndFeel = FDM.dxLayoutWeb1
    object EditCard: TcxTextEdit
      Left = 69
      Top = 36
      Hint = 'T.P_Card'
      ParentFont = False
      Properties.MaxLength = 30
      TabOrder = 0
      OnKeyDown = FormKeyDown
      Width = 102
    end
    object EditMemo: TcxMemo
      Left = 69
      Top = 111
      Hint = 'T.P_Memo'
      ParentFont = False
      Properties.MaxLength = 50
      Properties.ScrollBars = ssVertical
      Style.Edges = [bBottom]
      TabOrder = 5
      Height = 50
      Width = 368
    end
    object BtnOK: TButton
      Left = 201
      Top = 171
      Width = 70
      Height = 22
      Caption = #30830#23450
      TabOrder = 6
      OnClick = BtnOKClick
    end
    object BtnExit: TButton
      Left = 276
      Top = 171
      Width = 70
      Height = 22
      Caption = #21462#28040
      TabOrder = 7
      OnClick = BtnExitClick
    end
    object EditOwner: TcxTextEdit
      Left = 222
      Top = 36
      Hint = 'T.P_Owner'
      ParentFont = False
      Properties.MaxLength = 32
      TabOrder = 1
      OnKeyDown = FormKeyDown
      Width = 159
    end
    object EditProvider: TcxComboBox
      Left = 69
      Top = 61
      Hint = 'T.P_Provider'
      ParentFont = False
      Properties.IncrementalSearch = False
      Properties.ItemHeight = 18
      Properties.MaxLength = 80
      TabOrder = 2
      Width = 121
    end
    object EditMate: TcxComboBox
      Left = 69
      Top = 86
      Hint = 'T.P_Mate'
      ParentFont = False
      Properties.IncrementalSearch = False
      Properties.ItemHeight = 18
      Properties.MaxLength = 30
      TabOrder = 3
      Width = 102
    end
    object cxTextEdit1: TcxTextEdit
      Left = 222
      Top = 86
      Hint = 'T.P_SaleMan'
      ParentFont = False
      Properties.MaxLength = 32
      TabOrder = 4
      Width = 121
    end
    object dxLayoutControl1Group_Root: TdxLayoutGroup
      ShowCaption = False
      Hidden = True
      ShowBorder = False
      object dxLayoutControl1Group1: TdxLayoutGroup
        AutoAligns = [aaHorizontal]
        AlignVert = avClient
        Caption = #22522#26412#20449#24687
        object dxLayoutControl1Group2: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          ShowBorder = False
          object dxLayoutControl1Group6: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            ShowBorder = False
            object dxLayoutControl1Group7: TdxLayoutGroup
              ShowCaption = False
              Hidden = True
              LayoutDirection = ldHorizontal
              ShowBorder = False
              object dxLayoutControl1Item2: TdxLayoutItem
                AutoAligns = [aaVertical]
                Caption = #30913#21345#21495':'
                Control = EditCard
                ControlOptions.ShowBorder = False
              end
              object dxLayoutControl1Item14: TdxLayoutItem
                AutoAligns = [aaVertical]
                AlignHorz = ahClient
                Caption = #25345#26377#20154':'
                Control = EditOwner
                ControlOptions.ShowBorder = False
              end
            end
            object dxLayoutControl1Item1: TdxLayoutItem
              Caption = #20379#24212#21830':'
              Control = EditProvider
              ControlOptions.ShowBorder = False
            end
          end
          object dxLayoutControl1Group4: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayoutControl1Item3: TdxLayoutItem
              Caption = #21407#26448#26009':'
              Control = EditMate
              ControlOptions.ShowBorder = False
            end
            object dxLayoutControl1Item5: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahClient
              Caption = #19994#21153#21592':'
              Control = cxTextEdit1
              ControlOptions.ShowBorder = False
            end
          end
        end
        object dxLayoutControl1Item4: TdxLayoutItem
          AutoAligns = [aaHorizontal]
          AlignVert = avClient
          Caption = #22791'  '#27880':'
          Control = EditMemo
          ControlOptions.ShowBorder = False
        end
      end
      object dxLayoutControl1Group5: TdxLayoutGroup
        AutoAligns = [aaHorizontal]
        AlignVert = avBottom
        ShowCaption = False
        Hidden = True
        LayoutDirection = ldHorizontal
        ShowBorder = False
        object dxLayoutControl1Item10: TdxLayoutItem
          AutoAligns = [aaVertical]
          AlignHorz = ahRight
          Caption = 'Button3'
          ShowCaption = False
          Control = BtnOK
          ControlOptions.ShowBorder = False
        end
        object dxLayoutControl1Item11: TdxLayoutItem
          AutoAligns = [aaVertical]
          AlignHorz = ahRight
          Caption = 'Button4'
          ShowCaption = False
          Control = BtnExit
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end

object fFormFilteCus: TfFormFilteCus
  Left = 571
  Top = 587
  Width = 511
  Height = 405
  BorderIcons = [biSystemMenu, biMinimize]
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object cxGrid1: TcxGrid
    Left = 0
    Top = 0
    Width = 503
    Height = 336
    Align = alClient
    TabOrder = 0
    object cxView1: TcxGridTableView
      NavigatorButtons.ConfirmDelete = False
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      object cxView1Column1: TcxGridColumn
        Caption = #36873#20013
        PropertiesClassName = 'TcxCheckBoxProperties'
        HeaderAlignmentHorz = taCenter
        Width = 67
      end
      object cxView1Column4: TcxGridColumn
        Caption = #19994#21153#20154#21592
        Options.Editing = False
        Width = 100
      end
      object cxView1Column2: TcxGridColumn
        Caption = #23458#25143#32534#21495
        Options.Editing = False
        Width = 100
      end
      object cxView1Column3: TcxGridColumn
        Caption = #23458#25143#21517#31216
        Options.Editing = False
        Width = 259
      end
    end
    object cxLevel1: TcxGridLevel
      GridView = cxView1
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 336
    Width = 503
    Height = 35
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      503
      35)
    object BtnCheck: TButton
      Left = 5
      Top = 8
      Width = 40
      Height = 18
      Caption = #20840#36873
      TabOrder = 0
      OnClick = BtnCheckClick
    end
    object BtnUnCheck: TButton
      Left = 46
      Top = 8
      Width = 40
      Height = 18
      Caption = #20840#21462#28040
      TabOrder = 1
      OnClick = BtnCheckClick
    end
    object BtnDCheck: TButton
      Left = 87
      Top = 8
      Width = 40
      Height = 18
      Caption = #21453#36873
      TabOrder = 2
      OnClick = BtnCheckClick
    end
    object Button4: TButton
      Left = 423
      Top = 6
      Width = 65
      Height = 22
      Anchors = [akTop, akRight]
      Caption = #21462#28040
      ModalResult = 2
      TabOrder = 3
    end
    object BtnOK: TButton
      Left = 360
      Top = 6
      Width = 65
      Height = 22
      Anchors = [akTop, akRight]
      Caption = #30830#23450
      TabOrder = 4
      OnClick = BtnOKClick
    end
  end
end

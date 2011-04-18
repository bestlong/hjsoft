{*******************************************************************************
  ����: dmzn@163.com 2009-6-12
  ����: ԭ�Ϲ�Ӧ�ſ�
*******************************************************************************}
unit UFormPProvideCard;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UDataModule, UFormBase, cxGraphics, dxLayoutControl, StdCtrls,
  cxMaskEdit, cxDropDownEdit, cxMCListBox, cxMemo, cxContainer, cxEdit,
  cxTextEdit, cxControls, cxLookAndFeels, cxLookAndFeelPainters;

type
  TfFormProvideCard = class(TBaseForm)
    dxLayoutControl1Group_Root: TdxLayoutGroup;
    dxLayoutControl1: TdxLayoutControl;
    dxLayoutControl1Group1: TdxLayoutGroup;
    EditCard: TcxTextEdit;
    dxLayoutControl1Item2: TdxLayoutItem;
    EditMemo: TcxMemo;
    dxLayoutControl1Item4: TdxLayoutItem;
    BtnOK: TButton;
    dxLayoutControl1Item10: TdxLayoutItem;
    BtnExit: TButton;
    dxLayoutControl1Item11: TdxLayoutItem;
    dxLayoutControl1Group5: TdxLayoutGroup;
    EditOwner: TcxTextEdit;
    dxLayoutControl1Item14: TdxLayoutItem;
    EditProvider: TcxComboBox;
    dxLayoutControl1Item1: TdxLayoutItem;
    EditMate: TcxComboBox;
    dxLayoutControl1Item3: TdxLayoutItem;
    dxLayoutControl1Group2: TdxLayoutGroup;
    cxTextEdit1: TcxTextEdit;
    dxLayoutControl1Item5: TdxLayoutItem;
    dxLayoutControl1Group6: TdxLayoutGroup;
    dxLayoutControl1Group4: TdxLayoutGroup;
    dxLayoutControl1Group7: TdxLayoutGroup;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnExitClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BtnOKClick(Sender: TObject);
  private
    { Private declarations }
    FRecordID: string;
    //��¼���
    procedure InitFormData(const nID: string);
    //��������
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  IniFiles, ULibFun, UMgrControl, UFormCtrl, UAdjustForm, USysGrid,
  USysDB, USysConst;

class function TfFormProvideCard.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  if Assigned(nParam) then
       nP := nParam
  else Exit;

  with TfFormProvideCard.Create(Application) do
  try
    if nP.FCommand = cCmd_AddData then
    begin
      Caption := '��Ӧ�ſ� - ����';
      FRecordID := '';
    end else
    begin
      Caption := '��Ӧ�ſ� - �޸�';
      FRecordID := nP.FParamA;
    end;

    InitFormData(FRecordID);
    nP.FCommand := cCmd_ModalResult;
    nP.FParamA := ShowModal;
  finally
    Free;
  end;
end;

class function TfFormProvideCard.FormID: integer;
begin
  Result := cFI_FormProvideCard;
end;

//------------------------------------------------------------------------------
procedure TfFormProvideCard.FormCreate(Sender: TObject);
begin
  LoadFormConfig(Self);
  ResetHintAllForm(Self, 'T', sTable_ProvideCard);
end;

procedure TfFormProvideCard.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveFormConfig(Self);
end;

procedure TfFormProvideCard.BtnExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfFormProvideCard.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if Key = VK_ESCAPE then
  begin
    Key := 0; Close;
  end;
end;

//------------------------------------------------------------------------------
//Desc: ��ʼ������
procedure TfFormProvideCard.InitFormData(const nID: string);
var nStr: string;
begin
  nStr := 'Select P_Name From %s Order By P_Name ASC';
  nStr := Format(nStr, [sTable_Provider]);
  FDM.FillStringsData(EditProvider.Properties.Items, nStr, -1);

  nStr := 'Select M_Name From %s Order By M_Name ASC';
  nStr := Format(nStr, [sTable_Materails]);
  FDM.FillStringsData(EditMate.Properties.Items, nStr, -1);

  if nID <> '' then
  begin
    nStr := 'Select * From %s Where P_ID=%s';
    nStr := Format(nStr, [sTable_ProvideCard, nID]);
    LoadDataToCtrl(FDM.QueryTemp(nStr), Self);
  end;
end;

//Desc: ����
procedure TfFormProvideCard.BtnOKClick(Sender: TObject);
var nStr: string;
    nList: TStrings;
begin
  EditCard.Text := Trim(EditCard.Text);
  if EditCard.Text = '' then
  begin
    EditCard.SetFocus;
    ShowMsg('����д��Ч�ſ���', sHint); Exit;
  end;

  nStr := 'Select Count(*) From $T Where P_Card=''$C''';
  if FRecordID <> '' then
    nStr := nStr + ' And P_ID<>$I';
  //xxxxx
  
  nStr := MacroValue(nStr, [MI('$T', sTable_ProvideCard), MI('$C', EditCard.Text),
          MI('$I', FRecordID)]);
  //xxxxx

  with FDM.QueryTemp(nStr) do
  if Fields[0].AsInteger > 0 then
  begin
    EditCard.SetFocus;
    ShowMsg('�ÿ�����ʹ����', sHint); Exit;
  end;

  nList := TStringList.Create;
  try
    nList.Add(Format('P_Man=''%s''', [gSysParam.FUserID]));
    nList.Add(Format('P_Date=%s', [FDM.SQLServerNow]));

    if FRecordID = '' then
    begin
      nList.Add(Format('P_Status=''%s''', [sFlag_CardUsed]));
      nStr := MakeSQLByForm(Self, sTable_ProvideCard, '', True, nil, nList);
    end else
    begin
      nStr := Format('P_ID=%s', [FRecordID]);
      nStr := MakeSQLByForm(Self, sTable_ProvideCard, nStr, False, nil, nList);
    end;

    FDM.ExecuteSQL(nStr);
    ModalResult := mrOk;
  finally
    nList.Free;
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormProvideCard, TfFormProvideCard.FormID);
end.

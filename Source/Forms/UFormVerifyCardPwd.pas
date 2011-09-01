{*******************************************************************************
  ����: dmzn@163.com 2010-3-15
  ����: ʹ�ÿ���������֤��Ч��
*******************************************************************************}
unit UFormVerifyCardPwd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, dxLayoutControl, StdCtrls, cxControls, cxMemo,
  cxContainer, cxEdit, cxTextEdit, cxListBox, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, cxLabel;

type
  TfFormVerifyCardPwd = class(TfFormNormal)
    EditCard: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    EditPwd: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    dxGroup2: TdxLayoutGroup;
    ListMsg: TcxListBox;
    dxLayout1Item6: TdxLayoutItem;
    EditTruck: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    EditBCard: TcxTextEdit;
    dxLayout1Item7: TdxLayoutItem;
    dxLayout1Group2: TdxLayoutGroup;
    cxLabel1: TcxLabel;
    dxLayout1Item8: TdxLayoutItem;
    dxLayout1Group4: TdxLayoutGroup;
    cxLabel2: TcxLabel;
    dxLayout1Item9: TdxLayoutItem;
    procedure BtnOKClick(Sender: TObject);
    procedure EditPwdKeyPress(Sender: TObject; var Key: Char);
    procedure ListMsgExit(Sender: TObject);
    procedure EditTruckExit(Sender: TObject);
    procedure EditBCardExit(Sender: TObject);
  private
    { Private declarations }
    FCardNo: string;
    //�ſ����
    FZhiKa: string;
    //ֽ�����
    FCusID: string;
    //�ͻ����
    FTruck: string;
    //�������
    procedure SaveTruckNo;
    //���泵��
    function IsValidBillCard(var nHint: string): Boolean;
    //��֤�����
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl, UDataModule, UFormBase, USysConst, USysDB, USysBusiness;

class function TfFormVerifyCardPwd.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  if Assigned(nParam) then
       nP := nParam
  else Exit;

  with TfFormVerifyCardPwd.Create(Application) do
  begin
    Caption := '�����֤';
    EditCard.Text := nP.FParamB;
    EditPwd.Text := nP.FParamC;
    EditTruck.Text := nP.FParamD;

    if EditCard.Text <> '' then ActiveControl := EditPwd;
    if EditPwd.Text <> '' then ActiveControl := EditTruck;

    nP.FCommand := cCmd_ModalResult;
    nP.FParamA := ShowModal;
    if nP.FParamA = mrOk then;
    begin
      nP.FParamB := FCardNo;
      nP.FParamC := FZhiKa;
      nP.FParamD := FTruck;
    end;
    Free;
  end;
end;

class function TfFormVerifyCardPwd.FormID: integer;
begin
  Result := cFI_FormVerifyCardPwd;
end;

procedure TfFormVerifyCardPwd.EditPwdKeyPress(Sender: TObject; var Key: Char);
var nP: TFormCommandParam;
begin
  if Key = #13 then
  begin
    Key := #0;
    if Sender = EditCard then EditTruck.SetFocus else
    if Sender = EditTruck then EditPwd.SetFocus else
    if Sender = EditPwd then BtnOK.SetFocus else
    if Sender = EditBCard then BtnOK.SetFocus;
  end else

  if Key = #32 then
  begin
    Key := #0;
    nP.FParamA := EditTruck.Text;
    CreateBaseFormItem(cFI_FormGetTruck, '', @nP);

    if (nP.FCommand = cCmd_ModalResult) and(nP.FParamA = mrOk) then
      EditTruck.Text := nP.FParamB;
    EditTruck.SelectAll;
  end;
end;

//Desc: ��ȡ������Ӧ�Ĵſ���
procedure TfFormVerifyCardPwd.EditTruckExit(Sender: TObject);
var nStr: string;
begin
  EditTruck.Text := Trim(EditTruck.Text);
  if Length(EditTruck.Text) < 3 then Exit;

  if EditTruck.Text = FTruck then Exit;
  EditBCard.Text := Trim(EditBCard.Text);
  if EditBCard.Text <> '' then Exit;

  nStr := 'Select C_Card From %s Where C_TruckNo=''%s''';
  nStr := Format(nStr, [sTable_ZhiKaCard, EditTruck.Text]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    EditBCard.Text := Fields[0].AsString;
    EditBCard.SetFocus;
    FTruck := EditTruck.Text;
  end;
end;

//Desc: ��ȡ�ſ���Ӧ�ĳ���
procedure TfFormVerifyCardPwd.EditBCardExit(Sender: TObject);
var nStr: string;
begin
  EditBCard.Text := Trim(EditBCard.Text);
  if (EditBCard.Text = '') or (EditBCard.Text = FCardNo) then Exit;

  EditTruck.Text := Trim(EditTruck.Text);
  if EditTruck.Text <> '' then Exit;

  nStr := 'Select C_TruckNo From %s Where C_Card=''%s''';
  nStr := Format(nStr, [sTable_ZhiKaCard, EditBCard.Text]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    EditTruck.Text := Fields[0].AsString;
    EditTruck.SetFocus;
    FCardNo := EditBCard.Text;
  end;
end;

procedure TfFormVerifyCardPwd.ListMsgExit(Sender: TObject);
begin
  ListMsg.ItemIndex := -1;
end;

//Desc: ���泵�ƺ�
procedure TfFormVerifyCardPwd.SaveTruckNo;
var nStr,nTruck: string;
begin
  nTruck := Trim(EditTruck.Text);
  nStr := 'Select Count(*) From %s Where T_Truck=''%s''';

  nStr := Format(nStr, [sTable_Truck, nTruck]);
  if FDM.QueryTemp(nStr).Fields[0].AsInteger > 0 then Exit;

  nStr := 'Insert Into %s(T_Truck, T_PY) Values(''%s'', ''%s'')';
  nStr := Format(nStr, [sTable_Truck, nTruck, GetPinYinOfStr(nTruck)]);
  FDM.ExecuteSQL(nStr);
end;

//Desc: ��֤����ſ��Ƿ���Ч,������
function TfFormVerifyCardPwd.IsValidBillCard(var nHint: string): Boolean;
var nStr,nZK: string;
begin
  nHint := '';
  Result := False;

  nStr := 'Select * From %s Where C_Card=''%s''';
  nStr := Format(nStr, [sTable_ZhiKaCard, EditBCard.Text]);

  with FDM.QueryTemp(nStr) do
  begin
    if RecordCount < 1 then
    begin
      nHint := '����ſ���Ч.'; Exit;
    end;

    nStr := FieldByName('C_IsFreeze').AsString;
    if nStr = sFlag_Yes then
      nHint := '����ſ��Ѿ�����.' + #13#10;
    //xxxxx

    nStr := FieldByName('C_Status').AsString;
    if nStr = sFlag_CardLoss then
      nHint := nHint + '����ſ��Ѿ���ʧ.' + #13#10;
    //xxxxx

    if FieldByName('C_OnlyLade').AsString <> sFlag_Yes then
      nHint := nHint + '����ſ�����˾����.' + #13#10;
    //xxxxx

    nZK := FieldByName('C_ZID').AsString;
    if nZK <> FZhiKa then
    begin
      if IsCardHasNoOKBill(EditBCard.Text) then
        nHint := nHint + '����ſ�����δ�����ƾ֤.' + #13#10;
      //xxxxx
    end;

    nHint := Trim(nHint);
    Result := nHint = '';
    if (not Result) or (FZhiKa = nZK) then Exit;

    nStr := 'Update %s Set C_ZID=''%s'',C_Status=''%s'',C_OwnerID=''%s'',' +
            'C_BillTime=C_MaxTime Where C_Card=''%s''';
    nStr := Format(nStr, [sTable_ZhiKaCard, FZhiKa, sFlag_CardUsed, FCusID,
            EditBCard.Text]);
    FDM.ExecuteSQL(nStr);
  end;
end;

//Desc: ��֤
procedure TfFormVerifyCardPwd.BtnOKClick(Sender: TObject);
var nStr: string;
    nP: TFunctionParam;
begin
  FCardNo := Trim(EditCard.Text);
  if FCardNo = '' then
  begin
    EditCard.SetFocus;
    ShowMsg('��������Ч�Ĵſ���', sHint); Exit;
  end;

  FTruck := Trim(EditTruck.Text);
  if Length(FTruck) < 3 then
  begin
    EditTruck.SetFocus;
    ShowMsg('���ƺų���Ӧ����3λ', sHint); Exit;
  end;

  if IsCardCanBill(EditCard.Text, EditPwd.Text, nStr, @nP) then
  begin
    FZhiKa := nP.FParamA;
    FCusID := nP.FParamB;
  end else
  begin
    EditPwd.SetFocus;
    ListMsg.Items.Text := AdjustHintToRead(nStr);
    ShowMsg('��֤ʧ��,������', sHint); Exit;
  end;

  EditBCard.Text := Trim(EditBCard.Text);
  if EditBCard.Text <> '' then
  begin
    if EditBCard.Text = EditCard.Text then
    begin
      EditBCard.SetFocus;
      ShowMsg('����ſ���Ч', sHint); Exit;
    end;

    if not IsValidBillCard(nStr) then
    begin
      EditBCard.SetFocus;
      ListMsg.Items.Text := AdjustHintToRead(nStr);
      ShowMsg('��֤ʧ��,������', sHint); Exit;
    end else FCardNo := EditBCard.Text;
  end;

  SaveTruckNo;
  ModalResult := mrOk;
end;

initialization
  gControlManager.RegCtrl(TfFormVerifyCardPwd, TfFormVerifyCardPwd.FormID);
end.

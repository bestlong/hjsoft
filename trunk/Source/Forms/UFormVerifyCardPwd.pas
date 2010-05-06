{*******************************************************************************
  ����: dmzn@163.com 2010-3-15
  ����: ʹ�ÿ���������֤��Ч��
*******************************************************************************}
unit UFormVerifyCardPwd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, dxLayoutControl, StdCtrls, cxControls, cxMemo,
  cxContainer, cxEdit, cxTextEdit, cxListBox;

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
    dxLayout1Group3: TdxLayoutGroup;
    procedure BtnOKClick(Sender: TObject);
    procedure EditPwdKeyPress(Sender: TObject; var Key: Char);
    procedure ListMsgExit(Sender: TObject);
  private
    { Private declarations }
    FCardNo: string;
    //�ſ����
    FZhiKa: string;
    //ֽ�����
    FTruck: string;
    //�������
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl, UFormBase, USysConst, USysBusiness;

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
begin
  if Key = #13 then
  begin
    Key := #0;
    if Sender = EditCard then EditPwd.SetFocus else
    if Sender = EditPwd then EditTruck.SetFocus else
    if Sender = EditTruck then BtnOKClick(nil);
  end;
end;

procedure TfFormVerifyCardPwd.ListMsgExit(Sender: TObject);
begin
  ListMsg.ItemIndex := -1;
end;

//Desc: ��֤
procedure TfFormVerifyCardPwd.BtnOKClick(Sender: TObject);
var nStr: string;
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

  if IsCardCanBill(EditCard.Text, EditPwd.Text, nStr) then
  begin
    FZhiKa := nStr;
    ModalResult := mrOk;
  end else
  begin
    EditPwd.SelectAll;
    ListMsg.Items.Text := AdjustHintToRead(nStr);
    ShowMsg('��֤ʧ��,������', sHint);
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormVerifyCardPwd, TfFormVerifyCardPwd.FormID);
end.

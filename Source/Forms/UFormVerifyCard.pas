{*******************************************************************************
  ����: dmzn@163.com 2010-3-15
  ����: ʹ�ÿ���������֤��Ч��
*******************************************************************************}
unit UFormVerifyCard;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, dxLayoutControl, StdCtrls, cxControls, cxMemo,
  cxContainer, cxEdit, cxTextEdit, cxListBox, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters;

type
  TfFormVerifyCard = class(TfFormNormal)
    EditCard: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    dxGroup2: TdxLayoutGroup;
    ListMsg: TcxListBox;
    dxLayout1Item6: TdxLayoutItem;
    procedure BtnOKClick(Sender: TObject);
    procedure EditPwdKeyPress(Sender: TObject; var Key: Char);
    procedure ListMsgExit(Sender: TObject);
  private
    { Private declarations }
    FZhiKa: string;
    //ֽ�����
    FCardNo: string;
    //�ſ����
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl, UFormBase, UForminputbox, USysConst, USysDB,
  USysBusiness;

class function TfFormVerifyCard.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nStr,nHint: string;
    nP: PFormCommandParam;
begin
  Result := nil;
  if Assigned(nParam) then
       nP := nParam
  else Exit;

  nP.FCommand := cCmd_ModalResult;
  nStr := nP.FParamA;
  nP.FParamA := mrCancel;

  while True do
  begin
    if nStr = '' then
     if not ShowInputBox('��������Ч�Ĵſ���:', '�ſ���֤', nStr) then Break;
    //xxxxx

    nStr := Trim(nStr);
    if nStr = '' then Continue;
    nHint := '';

    if IsCardValidProvide(nStr, nHint) then
    begin
      nP.FParamA := mrOk;
      nP.FParamB := nStr;
      nP.FParamC := '';
      nP.FParamE := sFlag_Provide; Break;
    end;

    if nHint <> '' then
    begin
      nStr := '';
      ShowDlg(AdjustHintToRead(nHint), sWarn); Continue;
    end;

    if IsCardCanUsing(nStr, nHint, nP.FParamE = sFlag_Yes) then
    begin
      nP.FParamA := mrOk;
      nP.FParamB := nStr;
      nP.FParamC := nHint;
      nP.FParamE := sFlag_Sale; Break;
    end else
    begin
      nStr := '';
      ShowDlg(AdjustHintToRead(nHint), sWarn);
    end;
  end;
end;

class function TfFormVerifyCard.FormID: integer;
begin
  Result := cFI_FormVerifyCard;
end;

procedure TfFormVerifyCard.EditPwdKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    if Sender = EditCard then BtnOKClick(nil);
  end;
end;

procedure TfFormVerifyCard.ListMsgExit(Sender: TObject);
begin
  ListMsg.ItemIndex := -1;
end;

//Desc: ��֤
procedure TfFormVerifyCard.BtnOKClick(Sender: TObject);
var nStr: string;
begin
  FCardNo := Trim(EditCard.Text);
  if FCardNo = '' then
  begin
    EditCard.SetFocus;
    ShowMsg('��������Ч�Ĵſ���', sHint); Exit;
  end;

  if IsCardCanUsing(EditCard.Text, nStr) then
  begin
    FZhiKa := nStr;
    ModalResult := mrOk;
  end else
  begin
    EditCard.SelectAll;
    ListMsg.Items.Text := AdjustHintToRead(nStr);
    ShowMsg('��֤ʧ��,������', sHint);
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormVerifyCard, TfFormVerifyCard.FormID);
end.

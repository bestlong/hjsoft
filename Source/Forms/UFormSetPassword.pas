{*******************************************************************************
  作者: dmzn@163.com 2010-3-14
  描述: 密码设置窗口
*******************************************************************************}
unit UFormSetPassword;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, cxContainer, cxEdit, cxTextEdit, dxLayoutControl,
  StdCtrls, cxControls, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters;

type
  TfFormSetPassword = class(TfFormNormal)
    EditNew: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    EditNext: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    procedure BtnOKClick(Sender: TObject);
    procedure EditNewKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}

uses
  ULibFun, UMgrControl, UFormBase, USysConst;

class function TfFormSetPassword.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  if Assigned(nParam) then
       nP := nParam
  else Exit;

  with TfFormSetPassword.Create(Application) do
  begin
    Caption := '密码';
    nP.FCommand := cCmd_ModalResult;
    nP.FParamA := ShowModal;

    if nP.FParamA = mrOK then
      nP.FParamB := EditNew.Text;
    Free;
  end;
end;

class function TfFormSetPassword.FormID: integer;
begin
  Result := cFI_FormSetPassword;
end;

procedure TfFormSetPassword.EditNewKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    if Sender = EditNew then EditNext.SetFocus;
    if Sender = EditNext then BtnOKClick(nil);
  end else

  if not (Key in ['0'..'9', Char(VK_BACK)]) then
    Key := #0;
  //xxxxx
end;

//Desc: 设置密码
procedure TfFormSetPassword.BtnOKClick(Sender: TObject);
begin
  EditNew.Text := Trim(EditNew.Text);
  EditNext.Text := Trim(EditNext.Text);

  if EditNew.Text = '' then
  begin
    EditNew.SetFocus;
    ShowMsg('请输入有效的密码', sHint); Exit;
  end;

  if EditNew.Text <> EditNext.Text then
  begin
    EditNew.SetFocus;
    ShowMsg('请输入有效的密码', '密码不同'); Exit;
  end;

  ModalResult := mrOk;
end;

initialization
  gControlManager.RegCtrl(TfFormSetPassword, TfFormSetPassword.FormID);
end.

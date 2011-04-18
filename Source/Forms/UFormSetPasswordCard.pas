{*******************************************************************************
  ����: dmzn@163.com 2011-02-18
  ����: �ſ��������ô���
*******************************************************************************}
unit UFormSetPasswordCard;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, cxContainer, cxEdit, cxTextEdit, dxLayoutControl,
  StdCtrls, cxControls, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters,
  cxLabel, cxCheckBox;

type
  TfFormSetPasswordCard = class(TfFormNormal)
    EditNew: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    EditNext: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    dxGroup2: TdxLayoutGroup;
    EditMax: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    EditTime: TcxTextEdit;
    dxLayout1Item6: TdxLayoutItem;
    cxLabel1: TcxLabel;
    dxLayout1Item7: TdxLayoutItem;
    dxLayout1Group2: TdxLayoutGroup;
    cxLabel2: TcxLabel;
    dxLayout1Item9: TdxLayoutItem;
    EditTruck: TcxTextEdit;
    dxLayout1Item10: TdxLayoutItem;
    cxLabel3: TcxLabel;
    dxLayout1Item11: TdxLayoutItem;
    Check1: TcxCheckBox;
    dxLayout1Item8: TdxLayoutItem;
    dxLayout1Group3: TdxLayoutGroup;
    procedure BtnOKClick(Sender: TObject);
    procedure EditNewKeyPress(Sender: TObject; var Key: Char);
  protected
    { Protected declarations }
    FCardNo: string;
    //�ſ���
    FNeedSave: Boolean;
    //�豣��
    function OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean; override;
    //��֤����
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}

uses
  ULibFun, UMgrControl, UFormBase, USysConst, USysDB, UFormCtrl, UDataModule,
  UFormInputbox;

//Desc: ��ȡ�¿�
function GetNewCard(var nP: PFormCommandParam): Boolean;
var nStr: string;
begin
  nStr := '';
  Result := False;

  while True do
  begin
    if not ShowInputBox('��������Ч�Ĵſ���:', '�ſ�', nStr, 32) then Exit;
    nStr := Trim(nStr);
    if nStr <> '' then Break;
  end;

  New(nP);
  Result := True;
  
  nP.FCommand := cCmd_EditData;
  nP.FParamA := nStr;
  nP.FParamE := sFlag_Yes + sFlag_Yes;

  nStr := 'Select * From %s Where C_Card=''%s''';
  nStr := Format(nStr, [sTable_ZhiKaCard, nP.FParamA]);

  with FDM.QueryTemp(nStr) do
  begin
    if RecordCount > 0 then
    begin
      nP.FParamB := CombinStr([FieldByName('C_Password').AsString,
                    FieldByName('C_TruckNo').AsString,
                    IntToStr(FieldByName('C_MaxTime').AsInteger),
                    IntToStr(FieldByName('C_BillTime').AsInteger),
                    FieldByName('C_OnlyLade').AsString], #9);
      //pwd + truck + max + bill + lade
    end else
    begin
      nP.FParamB := CombinStr(['', '', '1', '1', sFlag_Yes], #9);
    end;
  end;
end;

class function TfFormSetPasswordCard.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nStr: string;
    nList: TStrings;
    nP: PFormCommandParam;
    nForm: TfFormSetPasswordCard;
begin
  Result := nil;
  nP := nil;
  nForm := nil;
  nList := nil;
  try
    if Assigned(nParam) then
         nP := nParam
    else GetNewCard(nP);

    if (not Assigned(nP)) or (nP.FCommand <> cCmd_EditData) then Exit;
    //invalid param
    nList := TStringList.Create;
    if not SplitStr(nP.FParamB, nList, 5, #9) then Exit;

    nForm := TfFormSetPasswordCard.Create(Application);
    with nForm do
    begin
      FCardNo := nP.FParamA;
      Caption := '�ſ� - ' + FCardNo;

      EditNew.Text := nList[0];
      EditNext.Text := nList[0];
      EditTruck.Text := nList[1];
      EditMax.Text := nList[2];
      EditTime.Text := nList[3];

      nStr := nP.FParamE;
      FNeedSave := (Length(nStr) > 0) and (nStr[1] = sFlag_Yes);
      EditNew.Properties.ReadOnly := (Length(nStr) > 1) and (nStr[2] = sFlag_Yes);
      EditNext.Properties.ReadOnly := EditNew.Properties.ReadOnly;

      if EditNew.Properties.ReadOnly then
           ActiveControl := EditTruck
      else ActiveControl := EditNew;

      Check1.Checked := nList[4] = sFlag_Yes;
      //no bill

      nP.FCommand := cCmd_ModalResult;
      nP.FParamA := ShowModal;
      //for result
      if nP.FParamA = mrOK then
      begin
        if Check1.Checked then
             nStr := sFlag_Yes
        else nStr := sFlag_No;

        nP.FParamB := CombinStr([EditNew.Text, EditTruck.Text, EditMax.Text,
                      EditTime.Text, nStr], #9);
        //xxxxx
      end;
    end;
  finally
    if Assigned(nList) then
      nList.Free;
    //xxxxx

    if (not Assigned(nParam)) and Assigned(nP) then
      Dispose(nP);
    if Assigned(nForm) then nForm.Free;
  end;
end;

class function TfFormSetPasswordCard.FormID: integer;
begin
  Result := cFI_FormSetCardPwd;
end;

procedure TfFormSetPasswordCard.EditNewKeyPress(Sender: TObject;
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

//------------------------------------------------------------------------------
function TfFormSetPasswordCard.OnVerifyCtrl(Sender: TObject;
  var nHint: string): Boolean;
begin
  Result := True;

  if Sender = EditNew then
  begin
    EditNew.Text := Trim(EditNew.Text);
    Result := EditNew.Text = EditNext.Text;
    nHint := '�������벻һ��';
  end else

  if Sender = EditMax then
  begin
    Result := IsNumber(EditMax.Text, False) and (StrToInt(EditMax.Text) >= 0);
    nHint := '����д��Ч����ֵ';
  end else

  if Sender = EditTime then
  begin
    Result := IsNumber(EditTime.Text, False) and (StrToInt(EditTime.Text) >= 0);
    nHint := '����д��Ч����ֵ';
  end else

  if Sender = EditTruck then
  begin
    EditTruck.Text := Trim(EditTruck.Text);
    Result := (EditTruck.Text = '') or (Length(EditTruck.Text) > 2);
    nHint := '��Ч����Ӧ3λ����';
  end;
end;

//Desc: ȷ��
procedure TfFormSetPasswordCard.BtnOKClick(Sender: TObject);
var nStr,nFlag: string;
begin
  if not IsDataValid then Exit;

  if FNeedSave then
  try
    FDM.ADOConn.BeginTrans;
    //start trans

    if EditTruck.Text <> '' then
    begin
      nStr := 'Update %s Set C_TruckNo='''' Where C_TruckNo=''%s''';
      nStr := Format(nStr, [sTable_ZhiKaCard, EditTruck.Text]);
      FDM.ExecuteSQL(nStr);
    end;

    if Check1.Checked then
         nFlag := sFlag_Yes
    else nFlag := sFlag_No;

    nStr := 'Update %s Set C_Password=''%s'',C_TruckNo=''%s'', C_MaxTime=%s,' +
            'C_BillTime=%s,C_OnlyLade=''%s'' Where C_Card=''%s''';
    nStr := Format(nStr, [sTable_ZhiKaCard, EditNew.Text, EditTruck.Text,
            EditMax.Text, EditTime.Text, nFlag, FCardNo]);
    //xxxxx

    if FDM.ExecuteSQL(nStr) < 1 then
    begin
      nStr := MakeSQLByStr([Format('C_Card=''%s''', [FCardNo]),
              Format('C_Password=''%s''', [EditNew.Text]),
              Format('C_Status=''%s''', [sFlag_CardIdle]),
              Format('C_IsFreeze=''%s''', [sFlag_No]),
              Format('C_TruckNo=''%s''', [EditTruck.Text]),
              Format('C_BillTime=%s', [EditTime.Text]),
              Format('C_MaxTime=%s', [EditMax.Text]),
              Format('C_OnlyLade=''%s''', [nFlag]),
              Format('C_Man=''%s''', [gSysParam.FUserID]),
              Format('C_Date=%s', [FDM.SQLServerNow])], sTable_ZhiKaCard, '', True);
      FDM.ExecuteSQL(nStr);
    end;

    FDM.ADOConn.CommitTrans;
    ShowMsg('����ɹ�', sHint);
  except
    if FDM.ADOConn.InTransaction then
      FDM.ADOConn.RollbackTrans;
    ShowMsg('��������ʧ��', sHint); Exit;
  end;

  ModalResult := mrOk;
end;

initialization
  gControlManager.RegCtrl(TfFormSetPasswordCard, TfFormSetPasswordCard.FormID);
end.

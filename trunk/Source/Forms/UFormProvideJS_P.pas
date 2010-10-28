{*******************************************************************************
  ����: dmzn@163.com 2010-10-20
  ����: ������Ӧ����
*******************************************************************************}
unit UFormProvideJS_P;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, dxLayoutControl, StdCtrls, cxControls, cxMemo,
  cxButtonEdit, cxLabel, cxTextEdit, cxContainer, cxEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters;

type
  TfFormProvideJS_P = class(TfFormNormal)
    dxLayout1Item8: TdxLayoutItem;
    EditMate: TcxTextEdit;
    dxLayout1Item9: TdxLayoutItem;
    EditProvider: TcxTextEdit;
    dxLayout1Item12: TdxLayoutItem;
    EditMemo: TcxMemo;
    EditTruck: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    dxLayout1Group2: TdxLayoutGroup;
    procedure BtnOKClick(Sender: TObject);
  private
    { Private declarations }
    FList: TStrings;
    //��¼�б�
    procedure InitFormData(const nID: string);
    //��������
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
    function OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean; override;
  end;

implementation

{$R *.dfm}
uses
  IniFiles, ULibFun, UFormBase, UMgrControl, USysDB, USysConst, USysBusiness,
  UDataModule;

class function TfFormProvideJS_P.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nY,nM: Double;
    nP: PFormCommandParam;
begin
  Result := nil;
  if Assigned(nParam) then
       nP := nParam
  else Exit;

  with TfFormProvideJS_P.Create(Application) do
  begin
    Caption := '��������';
    FList := TStrings(TObject(Integer(nP.FParamA)));
    EditMate.Text := nP.FParamB;
    EditTruck.Text := nP.FParamC;

    nM := nP.FParamD;
    nY := nP.FParamE;
    EditMemo.Text := Format('*.�˷�: %.2f��' + #13#10 +
                            '*.����: %.2f��' + #13#10 +
                            '*.�ϼ�: %.2f��', [nY, nM, nM + nY]);
    //xxxxx

    InitFormData('');
    nP.FCommand := cCmd_ModalResult;
    nP.FParamA := ShowModal;
    Free;
  end;
end;

class function TfFormProvideJS_P.FormID: integer;
begin
  Result := cFI_FormProvideJS_P;
end;

procedure TfFormProvideJS_P.InitFormData(const nID: string);
begin
  EditProvider.Text := '�ϼ�';
  ActiveControl := EditProvider;
end;

//------------------------------------------------------------------------------
//Desc: ��֤����
function TfFormProvideJS_P.OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean;
begin
  Result := True;

  if Sender = EditProvider then
  begin
    EditProvider.Text := Trim(EditProvider.Text);
    Result := EditProvider.Text <> '';
    nHint := '��Ӧ�̲�����Ϊ��';
  end else

  if Sender = EditTruck then
  begin
    EditTruck.Text := Trim(EditTruck.Text);
    Result := EditTruck.Text <> '';
    nHint := '���ƺŲ�����Ϊ��';
  end;
end;

//Desc: ����
procedure TfFormProvideJS_P.BtnOKClick(Sender: TObject);
var i,nLen: Integer;
    nStr,nSQL,nDate,nFlag: string;
begin
  nStr := Format('���ν������[ %d ]�Ű���,Ҫ������?', [FList.Count]);
  if not QueryDlg(nStr, sAsk, Handle) then Exit;

  FDM.ADOConn.BeginTrans;
  try
    nDate := DateTime2Str(FDM.ServerNow);
    nFlag := StringReplace(FloatToStr(Str2DateTime(nDate)), '.', '0', []);

    nSQL := 'Update %s Set L_Flag=''%s'',L_JSer=''%s'',L_JSDate=''%s'',' +
            'L_JProvider=''%s'',L_JTruck=''%s'' Where L_ID=$ID';
    nSQL := Format(nSQL, [sTable_ProvideLog, nFlag, gSysParam.FUserID,
            nDate, EditProvider.Text, EditTruck.Text]);
    //xxxxx

    nLen := FList.Count - 1;
    for i:=0 to nLen do
    begin
      nStr := MacroValue(nSQL, [MI('$ID',FList[i])]);
      FDM.ExecuteSQL(nStr);
    end;

    FDM.ADOConn.CommitTrans;
  except
    FDM.ADOConn.RollbackTrans;
    ShowMsg('��������ʧ��', sHint); Exit;
  end;

  PrintProvideJSReport('', nFlag, True);
  ModalResult := mrOk;
end;

initialization
  gControlManager.RegCtrl(TfFormProvideJS_P, TfFormProvideJS_P.FormID);
end.

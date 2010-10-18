{*******************************************************************************
  ����: dmzn@163.com 2010-10-16
  ����: ��Ӧ����
*******************************************************************************}
unit UFormProvideJS;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, dxLayoutControl, StdCtrls, cxControls, cxMemo,
  cxButtonEdit, cxLabel, cxTextEdit, cxContainer, cxEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters;

type
  TfFormProvideJS = class(TfFormNormal)
    dxLayout1Item7: TdxLayoutItem;
    Edit1: TcxTextEdit;
    dxLayout1Item8: TdxLayoutItem;
    Edit2: TcxTextEdit;
    dxLayout1Item9: TdxLayoutItem;
    EditWeight: TcxTextEdit;
    dxLayout1Item11: TdxLayoutItem;
    EditMoney: TcxTextEdit;
    dxLayout1Item12: TdxLayoutItem;
    EditMemo: TcxMemo;
    dxLayout1Group3: TdxLayoutGroup;
    dxLayout1Group4: TdxLayoutGroup;
    dxLayout1Group5: TdxLayoutGroup;
    EditYF: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    dxLayout1Group2: TdxLayoutGroup;
    cxTextEdit2: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    dxLayout1Group6: TdxLayoutGroup;
    Edit3: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    cxLabel2: TcxLabel;
    dxLayout1Item6: TdxLayoutItem;
    dxLayout1Group7: TdxLayoutGroup;
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
    function OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean; override;
  end;

implementation

{$R *.dfm}
uses
  IniFiles, ULibFun, UFormCtrl, UFormBase, UMgrControl, USysDB, USysConst,
  USysBusiness, UDataModule;

class function TfFormProvideJS.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  if Assigned(nParam) then
       nP := nParam
  else Exit;

  with TfFormProvideJS.Create(Application) do
  begin
    FRecordID := nP.FParamA;
    Caption := '�������';

    InitFormData(FRecordID);
    nP.FCommand := cCmd_ModalResult;
    nP.FParamA := ShowModal;
    Free;
  end;
end;

class function TfFormProvideJS.FormID: integer;
begin
  Result := cFI_FormProvideHS;
end;

procedure TfFormProvideJS.InitFormData(const nID: string);
var nStr: string;
begin
  nStr := 'Select * From %s Where L_ID=%s';
  nStr := Format(nStr, [sTable_ProvideLog, nID]);

  with FDM.QueryTemp(nStr) do
  begin
    BtnOK.Enabled := RecordCount > 0;
    if not BtnOK.Enabled then
    begin
      ShowMsg('��¼����Ч', sHint); Exit;
    end;

    LoadDataToCtrl(FDM.SqlTemp, Self, '');
    EditWeight.Text := Format('%.2f', [FieldByName('L_MValue').AsFloat -
      FieldByName('L_PValue').AsFloat - FieldByName('L_YValue').AsFloat]);
    ActiveControl := EditMoney;
  end;
end;

//------------------------------------------------------------------------------
//Desc: ��֤����
function TfFormProvideJS.OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean;
begin
  Result := True;

  if Sender = EditMoney then
  begin
    Result := IsNumber(EditMoney.Text, True);
    nHint := '����д��ȷ�Ľ�����';
  end else

  if Sender = EditYF then
  begin
    Result := IsNumber(EditYF.Text, True);
    nHint := '����д��ȷ���˷�';
  end else
end;

//Desc: ����
procedure TfFormProvideJS.BtnOKClick(Sender: TObject);
var nStr: string;
begin
  if not IsDataValid then Exit;

  nStr := 'Update %s Set L_Money=%s,L_YunFei=%s,L_HSer=''%s'',L_HSDate=%s,' +
          'L_Memo=''%s'' Where L_ID=%s';
  nStr := Format(nStr, [sTable_ProvideLog, EditMoney.Text, EditYF.Text,
          gSysParam.FUserID, FDM.SQLServerNow, EditMemo.Text, FRecordID]);
  //xxxxx
  
  FDM.ExecuteSQL(nStr);
  ModalResult := mrOk;
end;

initialization
  gControlManager.RegCtrl(TfFormProvideJS, TfFormProvideJS.FormID);
end.

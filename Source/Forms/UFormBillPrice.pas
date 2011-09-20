{*******************************************************************************
  ����: dmzn@163.com 2010-4-13
  ����: �޸�������������
*******************************************************************************}
unit UFormBillPrice;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, cxContainer, cxEdit, cxTextEdit, cxMemo,
  dxLayoutControl, StdCtrls, cxControls, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, cxMCListBox;

type
  TfFormBillPrice = class(TfFormNormal)
    dxLayout1Item3: TdxLayoutItem;
    ListInfo: TcxMCListBox;
    dxLayout1Item4: TdxLayoutItem;
    EditBill: TcxTextEdit;
    Group2: TdxLayoutGroup;
    EditOPrice: TcxTextEdit;
    dxLayout1Item6: TdxLayoutItem;
    EditNPrice: TcxTextEdit;
    dxLayout1Item7: TdxLayoutItem;
    dxLayout1Group2: TdxLayoutGroup;
    EditZK: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    EditValue: TcxTextEdit;
    dxLayout1Item8: TdxLayoutItem;
    dxLayout1Group3: TdxLayoutGroup;
    EditZID: TcxTextEdit;
    dxLayout1Item9: TdxLayoutItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  protected
    { Protected declarations }
    procedure InitFormData(const nID: string);
    //��������
    function OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean; override;
    procedure GetSaveSQLList(const nList: TStrings); override;
    procedure AfterSaveData(var nDefault: Boolean); override;
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
  ULibFun, UMgrControl, UFormBase, UDataModule, USysDB, USysConst, USysGrid,
  USysBusiness;

type
  TBillInfo = record
    FZhiKa: string;
    FMoney: Double;
    FOnlyMon: Boolean;

    FBillID: string;
    FCustom: string;
    FValue: Double;
    FPrice: Double;
    FZKMoney: Boolean;
  end;

var
  gBill: TBillInfo;
  //ȫ��ʹ��

//------------------------------------------------------------------------------
class function TfFormBillPrice.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nStr: string;
    nP: PFormCommandParam;
begin
  Result := nil;
  if not gSysParam.FIsAdmin then
  begin
    ShowMsg('�ù�����Ҫ����ԱȨ��', sHint); Exit;
  end;

  if Assigned(nParam) then
  begin
    nP := nParam;
    if nP.FCommand <> cCmd_EditData then Exit;
  end else Exit;

  gBill.FBillID := nP.FParamA;
  nP.FCommand := cCmd_ModalResult;
  nP.FParamA := mrCancel;

  nStr := 'Select * From %s Where L_ID=''%s''';
  nStr := Format(nStr, [sTable_Bill, gBill.FBillID]);

  with FDM.QueryTemp(nStr),gBill do
  if RecordCount = 1 then
  begin
    if FieldByName('L_IsDone').AsString <> sFlag_Yes then
    begin
      ShowMsg('δ���ƾ֤��ֱ��ɾ��', sHint); Exit;
    end;

    FCustom := FieldByName('L_Custom').AsString;
    FValue := FieldByName('L_Value').AsFloat;
    FPrice := FieldByName('L_Price').AsFloat;
    FZKMoney := FieldByName('L_ZKMoney').AsString = sFlag_Yes;

    FZhiKa := FieldByName('L_ZID').AsString;
    FMoney := GetValidMoneyByZK(FZhiKa, FOnlyMon);
    FMoney := Float2Float(FMoney, cPrecision, False);
  end else
  begin
    ShowMsg('��Ч���������', sHint); Exit;
  end;

  with TfFormBillPrice.Create(Application) do
  try
    Caption := '��������';
    InitFormData('');
    nP.FParamA := ShowModal;
  finally
    Free;
  end;
end;

class function TfFormBillPrice.FormID: integer;
begin
  Result := cFI_FormEditPrice;
end;

procedure TfFormBillPrice.FormCreate(Sender: TObject);
begin
  inherited;
  LoadFormConfig(Self);
  LoadMCListBoxConfig(Name, ListInfo);
end;

procedure TfFormBillPrice.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  SaveFormConfig(Self);
  SaveMCListBoxConfig(Name, ListInfo);
end;

//------------------------------------------------------------------------------
procedure TfFormBillPrice.InitFormData(const nID: string);
var nStr: string;
begin
  with gBill do
  begin
    EditBill.Text := FBillID;
    EditValue.Text := FloatToStr(FValue);
    EditOPrice.Text := FloatToStr(FPrice);
                               
    if FOnlyMon then
         nStr := '����ֽ��'
    else nStr := '��ֽͨ��';

    EditZID.Text := FZhiKa;
    EditZK.Text := Format('%s ���ý��:[ %.2f ]Ԫ', [nStr, FMoney]);
    EditNPrice.Text := EditOPrice.Text;

    if nID <> sFlag_No then
      LoadZhiKaInfo(FZhiKa, ListInfo, nStr);
    ActiveControl := EditNPrice;
  end;
end;

//Desc: ��֤����
function TfFormBillPrice.OnVerifyCtrl(Sender: TObject;
  var nHint: string): Boolean;
var nVal: Double;
begin
  Result := Sender <> EditNPrice;
  if Result then Exit;

  nHint := '��������Ч�Ľ��';
  Result := IsNumber(EditNPrice.Text, True);
  if not Result then Exit;

  nVal := StrToFloat(EditNPrice.Text);
  nVal := Float2Float(nVal, cPrecision, True);
  EditNPrice.Text := FloatToStr(nVal);

  with gBill do
  begin
    nHint := '�������µ���';
    Result := nVal <> FPrice;
    if not Result then Exit;

    nVal := GetValidMoneyByZK(FZhiKa, FOnlyMon);
    nVal := Float2Float(nVal, cPrecision, False);

    if nVal <> FMoney then
    begin
      FMoney := nVal;
      InitFormData(sFlag_No);
    end; //money has changed

    nVal := StrToFloat(EditNPrice.Text);
    if nVal > FPrice then
    begin
      nVal := Float2Float(FValue * nVal, cPrecision, True) -
              Float2Float(FValue * FPrice, cPrecision, True);
      //�ʽ���

      Result := nVal <= FMoney;
      if Result then Exit;

      nHint := '�¼۸��޷���Ч,ԭ������: ' + #13#10#13#10 +
               '��.��������: %.2f Ԫ' + #13#10 +
               '��.��ǰ����: %.2f Ԫ' + #13#10 +
               '��.�ʽ���: %.2f Ԫ' + #13#10#13#10 +
               '���¼۸���Ч,�п��ܵ��¿ͻ��˻�Ƿ��.��������ֹ! ';
      //xxxxx
      
      nHint := Format(nHint, [nVal, FMoney, nVal - FMoney]);
      ShowDlg(nHint, sHint, Handle);
      nHint := '';
    end;
  end;
end;

//Desc: �������
procedure TfFormBillPrice.GetSaveSQLList(const nList: TStrings);
var nStr: string;
    nVal: Double; 
begin
  with gBill do
  begin
    nStr := 'Update %s Set L_Price=%s Where L_ID=''%s''';
    nStr := Format(nStr, [sTable_Bill, EditNPrice.Text, FBillID]);
    nList.Add(nStr);

    nStr := 'Update %s Set E_Price=%s Where E_Bill=''%s''';
    nStr := Format(nStr, [sTable_TruckLogExt, EditNPrice.Text, FBillID]);
    nList.Add(nStr);

    nVal := StrToFloat(EditNPrice.Text);
    nVal := Float2Float(FValue * nVal, cPrecision, True) -
            Float2Float(FValue * FPrice, cPrecision, True);
    //�ʽ���

    nStr := 'Update %s Set A_OutMoney=A_OutMoney+(%s) Where A_CID=''%s''';
    nStr := Format(nStr, [sTable_CusAccount, FloatToStr(nVal), FCustom]);
    nList.Add(nStr);

    if FZKMoney and FOnlyMon then
    begin
      nStr := 'Update %s Set Z_FixedMoney=Z_FixedMoney-(%s) Where Z_ID=''%s''';
      nStr := Format(nStr, [sTable_ZhiKa, FloatToStr(nVal), FZhiKa]);
      nList.Add(nStr);
    end; //������
  end;
end;

//Desc: д������־
procedure TfFormBillPrice.AfterSaveData(var nDefault: Boolean);
var nStr: string;
begin
  nStr := '�ѳ������ƾ֤���۵���[ %s -> %s ]';
  nStr := Format(nStr, [FloatToStr(gBill.FPrice), EditNPrice.Text]);
  FDM.WriteSysLog(sFlag_CommonItem, gBill.FBillID, nStr);
end;

initialization
  gControlManager.RegCtrl(TfFormBillPrice, TfFormBillPrice.FormID);
end.

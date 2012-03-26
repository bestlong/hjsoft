{*******************************************************************************
  ����: dmzn@163.com 2011-01-24
  ����: ԭ�Ϲ�Ӧ����Ԥ��Ƥ��
*******************************************************************************}
unit UFormPPreTruckP;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxMCListBox, cxLabel,
  cxMaskEdit, cxButtonEdit, cxTextEdit, dxLayoutControl, StdCtrls, Menus;

type
  TfFormPPreTruckP = class(TfFormNormal)
    dxLayout1Item3: TdxLayoutItem;
    EditCard: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    EditTruck: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    EditValue: TcxButtonEdit;
    dxLayout1Item6: TdxLayoutItem;
    BtnGet: TButton;
    dxLayout1Item7: TdxLayoutItem;
    cxLabel1: TcxLabel;
    dxLayout1Item8: TdxLayoutItem;
    ListTruck: TcxMCListBox;
    dxLayout1Group2: TdxLayoutGroup;
    dxLayout1Group3: TdxLayoutGroup;
    PMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    procedure ListTruckClick(Sender: TObject);
    procedure EditValuePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnGetClick(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure PMenu1Popup(Sender: TObject);
  protected
    { Protected declarations }
    FTruckP: Double;
    //��ЧƤ��
    procedure InitFormData;
    //��������
    function OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean; override;
    {*��֤����*}
    procedure GetSaveSQLList(const nList: TStrings); override;
    {*дSQL�б�*}
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UFormCtrl, UMgrControl, UForminputbox, UFormWeight, UDataModule,
  USysDB, USysConst, USysPopedom, USysBusiness;

class function TfFormPPreTruckP.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nStr,nCard: string;
begin
  Result := nil;
  nCard := '';

  while True do
  begin
    if not ShowInputBox('��������Ч�Ĵſ���:', 'Ԥ��Ƥ��', nCard) then Exit;
    nCard := Trim(nCard);
    if nCard = '' then Continue;

    nStr := 'Select DISTINCT P_Owner From $Mate,$Card ' +
            'Where P_Card=''$CD'' And M_Name=P_Mate And M_PrePValue=''$Yes'' ' +
            'Order By P_Owner ASC';
    nStr := MacroValue(nStr, [MI('$Mate', sTable_Materails), MI('$CD', nCard),
            MI('$Card', sTable_ProvideCard), MI('$Yes', sFlag_Yes)]);
    //xxxxx

    with FDM.QueryTemp(nStr) do
    if RecordCount > 0 then
         Break
    else ShowMsg('û����ҪԤ��Ƥ�صĳ���', sHint);
  end;

  with TfFormPPreTruckP.Create(Application) do
  begin
    Caption := 'Ԥ��Ƥ��';
    EditCard.Text := nCard;
    PopedomItem := nPopedom;

    InitFormData;
    ShowModal;
    Free;
  end;
end;

class function TfFormPPreTruckP.FormID: integer;
begin
  Result := cFI_FormProvidePreP;
end;

//------------------------------------------------------------------------------
//Desc: ��������
procedure TfFormPPreTruckP.InitFormData;
begin
  ActiveControl := BtnGet;
  ListTruck.Clear;

  with FDM.SqlTemp do
  begin
    First;

    while not Eof do
    begin
      ListTruck.Items.Add(Fields[0].AsString);
      Next;
    end;
  end;

  ListTruck.ItemIndex := 0;
  EditTruck.Text := ListTruck.Items[0];
  
  EditValue.Text := '0';
  EditValue.Properties.ReadOnly := True; 
end;

//Desc: ѡ����
procedure TfFormPPreTruckP.ListTruckClick(Sender: TObject);
begin
  if ListTruck.ItemIndex > -1 then
    EditTruck.Text := ListTruck.Items[ListTruck.ItemIndex];
  //xxxxx
end;

//Desc: �������
procedure TfFormPPreTruckP.EditValuePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
var nStr: string;
begin
  if not gPopedomManager.HasPopedom(PopedomItem, sPopedom_Edit) then Exit;
  //�޸�Ȩ�޿���

  if EditValue.Properties.ReadOnly then
       nStr := '�Ƿ�Ҫ�ֶ��������?'
  else nStr := '�Ƿ�Ҫ�Զ���ȡ����?';

  if QueryDlg(nStr, sAsk, Handle) then
    EditValue.Properties.ReadOnly := not EditValue.Properties.ReadOnly;
  //xxxxx
end;

//Desc: ����
procedure TfFormPPreTruckP.BtnGetClick(Sender: TObject);
begin
  Visible := False;
  try
    EditValue.Text := ShowBangFangWeightForm(PopedomItem);
  finally
    Visible := True;
  end;

  if IsNumber(EditValue.Text, False) and (StrToFloat(EditValue.Text) > 0) then
       ActiveControl := BtnOK
  else ActiveControl := BtnGet;
end;

//Desc: ��֤������Ч��
function TfFormPPreTruckP.OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean;
var nStr: string;
    nVal: Double;
begin
  Result := True;

  if Sender = EditValue then
  begin
    Result := IsNumber(EditValue.Text, True) and
              (StrToFloat(EditValue.Text) > 0);
    //xxxxx

    nHint := 'Ƥ��Ϊ>0����ֵ';
    if not Result then Exit;

    nVal := StrToFloat(EditValue.Text);
    FTruckP := GetProvicePreTruckP(EditTruck.Text, nVal);

    if nVal < FTruckP then
    begin
      nStr := '���ƺ�[ %s ]������γ���Ƥ����Ϣ����:' + #13#10#13#10 +
              '��.�ϴ�: %.2f ��' + #13#10 +
              '��.����: %.2f ��' + #13#10 +
              '��.���: %.2f ����' + #13#10#13#10 +
              '���ݾ���ԭ��,ϵͳ�����ýϴ��Ƥ����Ϊ������Ƥ��Чֵ. ' + #13#10 +
              'Ҫ������?';
      //xxxxx

      nStr := Format(nStr, [EditTruck.Text, FTruckP, nVal, (FTruckP-nVal) * 1000]);
      Result := QueryDlg(nStr, sAsk, Handle);
      nHint := '';
    end;
  end;
end;

//Desc: �������
procedure TfFormPPreTruckP.GetSaveSQLList(const nList: TStrings);
begin
  MakePrePValue(EditTruck.Text, FTruckP, nList);
end;

//------------------------------------------------------------------------------
//Desc: �˵�����
procedure TfFormPPreTruckP.PMenu1Popup(Sender: TObject);
begin
  N1.Enabled := ListTruck.ItemIndex > -1;
end;

//Desc: Ԥ��ȡ��
procedure TfFormPPreTruckP.N1Click(Sender: TObject);
var nStr: string;
begin
  nStr := '�ò��������������Ԥ��Ƥ��,Ҫ������?';
  if not QueryDlg(nStr, sAsk, Handle) then Exit;

  if Sender = N1 then
  begin
    nStr := 'Update $TB Set P_PrePValue=0,P_PrePTime=$PT,P_PrePMan=''$PM'' ' +
            'Where P_Owner=''$PO''';
  end else
  begin
    nStr := 'Update $TB Set P_PrePValue=0,P_PrePTime=$PT,P_PrePMan=''$PM'' ' +
            'Where P_Owner In (Select P_Owner From $TB Where P_Card=''$CD'')';
  end;

  nStr := MacroValue(nStr, [MI('$TB', sTable_ProvideCard),
          MI('$PT', FDM.SQLServerNow), MI('$PM', gSysParam.FUserID),
          MI('$CD', EditCard.Text), MI('$PO', EditTruck.Text)]);
  //xxxxx

  FDM.ExecuteSQL(nStr);
  ShowMsg('�������', sHint);
end;
initialization
  gControlManager.RegCtrl(TfFormPPreTruckP, TfFormPPreTruckP.FormID);
end.

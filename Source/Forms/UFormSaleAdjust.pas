{*******************************************************************************
  ����: dmzn@163.com 2010-3-17
  ����: ���۵���

  ��ע:
  *.�������ڽ�һ���Ѿ���ɵ�������������,����������ͻ�.
  *.����ԭ��: ��ͬƷ��,�ɲ�ͬ����,�����������û�,���������ڷ�������.
  *.����:�׵���20�ָ���,��׷�����Ϊ��,��Ϊ��,����Ӱ����ý��.
*******************************************************************************}
unit UFormSaleAdjust;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, cxGraphics, cxLabel, cxMemo, cxTextEdit,
  cxContainer, cxEdit, cxMaskEdit, cxDropDownEdit, dxLayoutControl,
  StdCtrls, cxControls, cxButtonEdit, cxMCListBox, ComCtrls, cxListView,
  cxLookAndFeels, cxLookAndFeelPainters;

type
  TfFormSaleAdjust = class(TfFormNormal)
    dxGroup2: TdxLayoutGroup;
    dxLayout1Item7: TdxLayoutItem;
    ListInfo: TcxMCListBox;
    ListDtl: TcxListView;
    dxLayout1Item3: TdxLayoutItem;
    EditCard: TcxButtonEdit;
    dxLayout1Item4: TdxLayoutItem;
    EditInfo: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    EditValue: TcxTextEdit;
    dxLayout1Item6: TdxLayoutItem;
    BtnAdd: TButton;
    dxLayout1Item8: TdxLayoutItem;
    BtnDel: TButton;
    dxLayout1Item9: TdxLayoutItem;
    dxLayout1Group2: TdxLayoutGroup;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EditCardPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
  protected
    { Private declarations }
    function OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean; override;
    procedure GetSaveSQLList(const nList: TStrings); override;
    //���෽��
    procedure InitFormData;
    //��������
    procedure LoadAdjustDetail;
    //������ϸ
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  DB, IniFiles, ULibFun, UFormBase, UMgrControl, UAdjustForm, UDataModule, 
  USysDB, USysConst, USysGrid, USysBusiness, UForminputbox;

type
  TCommonInfo = record
    FZhiKa: string;
    FSaleMan: string;
    FCusID: string;
    FCusName: string;
    FType: string;
    FStock: string;
    FLadID: string;
    FLadDate: string;

    FPrice: Double;
    FValue: Double;
    FSurplus: Double;
    FIsFix: Boolean;
  end;

  TAdjustItem = record
    FZhiKa: string;
    FSaleMan: string;
    FCusID: string;
    FCusName: string;
    FStock: string;
    FPrice: Double;
    FValue: Double;
    FMoney: Double;
    FIsFix: Boolean;
    FSelect: Boolean;
  end;

var
  gInfo: TCommonInfo;
  gActive: TAdjustItem;
  gItems: array of TAdjustItem;
  //ȫ��ʹ��

//------------------------------------------------------------------------------
class function TfFormSaleAdjust.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nStr,nSQL: string;
begin
  Result := nil;
  while True do
  begin
    if nStr = '' then
     if not ShowInputBox('��������������������:', '���۵���', nStr) then Exit;
    //xxxxx

    nSQL := 'Select b.*,C_Name From %s b ' +
            ' Left Join %s cus on cus.C_ID=b.L_Custom ' +
            'Where L_ID=''%s'' and L_IsDone=''%s''';
    nSQL := Format(nSQL, [sTable_Bill, sTable_Customer, nStr, sFlag_Yes]);

    with FDM.QueryTemp(nSQL),gInfo do
    if RecordCount = 1 then
    begin
      FZhiKa := FieldByName('L_ZID').AsString;
      FSaleMan := FieldByName('L_SaleMan').AsString;
      FCusID := FieldByName('L_Custom').AsString;
      FCusName := FieldByName('C_Name').AsString;

      FType := FieldByName('L_Type').AsString;
      FStock := FieldByName('L_Stock').AsString;
      FPrice := FieldByName('L_Price').AsFloat;
      FValue := FieldByName('L_Value').AsFloat;

      FLadID := FieldByName('L_ID').AsString;
      FLadDate := DateTime2Str(FieldByName('L_OKDate').AsDateTime);
      FIsFix := FieldByName('L_ZKMoney').AsString = sFlag_Yes; Break;
    end else
    begin
      nStr := '';
      ShowMsg('����������Ч', '������');
    end;
  end;

  with TfFormSaleAdjust.Create(Application) do
  begin
    Caption := '���۵���';
    InitFormData;
    ShowModal;
    Free;
  end;
end;

class function TfFormSaleAdjust.FormID: integer;
begin
  Result := cFI_FormSaleAdjust;
end;

procedure TfFormSaleAdjust.FormCreate(Sender: TObject);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadFormConfig(Self, nIni);
    LoadMCListBoxConfig(Name, ListInfo, nIni);
    LoadcxListViewConfig(Name, ListDtl, nIni);
  finally
    nIni.Free;
  end;
end;

procedure TfFormSaleAdjust.FormClose(Sender: TObject;
  var Action: TCloseAction);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveFormConfig(Self, nIni);
    SaveMCListBoxConfig(Name, ListInfo, nIni);
    SavecxListViewConfig(Name, ListDtl, nIni);
  finally
    nIni.Free;
  end;
end;

//------------------------------------------------------------------------------
//Desc: ��ʼ������
procedure TfFormSaleAdjust.InitFormData;
var nStr: string;
begin
  ListInfo.Clear;
  SetLength(gItems, 0);
  BtnAdd.Enabled := False;
  ActiveControl := EditCard;

  with ListInfo,gInfo do
  begin
    Items.Add('ֽ�����:' + Delimiter + FZhiKa);
    Items.Add('�ͻ�����:' + Delimiter + FCusName + ' ');
    Items.Add('ˮ������:' + Delimiter + FStock);

    Items.Add('�������:' + Delimiter + FLadID);
    nStr := '��������:' + Delimiter + Format('%.2f x %.2f', [FPrice, FValue]);
    Items.Add(nStr);
    Items.Add('���ʱ��:' + Delimiter + FLadDate);
  end;
end;

//Desc: ��ȡ�ſ���Ϣ
procedure TfFormSaleAdjust.EditCardPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
var nStr: string;
begin
  EditInfo.Clear;
  EditValue.Clear;
  BtnAdd.Enabled := False;

  EditCard.Text := Trim(EditCard.Text);
  if EditCard.Text = '' then Exit;

  if not IsCardCanUsing(EditCard.Text, nStr, True) then
  begin
    nStr := '�ôſ���ʱ�޷����ڵ���,��������:' + #13#10#13#10 +
            AdjustHintToRead(nStr);
    ShowDlg(nStr, sHint, Handle); Exit;
  end;

  nStr := 'Select zk.*,zd.*,C_Name from $ZK zk ' +
          ' Left Join $Cus cus on cus.C_ID=zk.Z_Custom' +
          ' Left Join $ZC zc on zc.C_ZID=zk.Z_ID' +
          ' Left Join $ZD zd on zd.D_ZID=zk.Z_ID ' +
          'Where D_Type=''$Type'' and D_Stock=''$Stock'' and C_Card=''$Card''';
  nStr := MacroValue(nStr, [MI('$ZK', sTable_ZhiKa),
          MI('$ZC', sTable_ZhiKaCard), MI('$Cus', sTable_Customer),
          MI('$ZD', sTable_ZhiKaDtl), MI('$Type', gInfo.FType),
          MI('$Stock', gInfo.FStock), MI('$Card', EditCard.Text)]);
  //xxxxx

  with FDM.QueryTemp(nStr),gActive do
  if RecordCount = 1 then
  begin
    FZhiKa := FieldByName('Z_ID').AsString;
    FSaleMan := FieldByName('Z_SaleMan').AsString;
    FCusID := FieldByName('Z_Custom').AsString;
    FCusName := FieldByName('C_Name').AsString;
    FStock := FieldByName('D_Stock').AsString;
    FPrice := FieldByName('D_Price').AsFloat;

    FMoney := GetValidMoneyByZK(FZhiKa, FIsFix);
    if FPrice > 0 then
         FValue := Float2Float(FMoney / FPrice, cPrecision, False)
    else FValue := 0;

    EditInfo.Text := Format('�ͻ�: %s ����: %.2f', [FCusName, FPrice]);
    EditValue.Text := Format('%.2f', [FValue]);
    
    EditValue.SetFocus;
    BtnAdd.Enabled := True;
  end else
  begin
    nStr := Format('�ÿ���û�� %s ��ˮ��Ʒ��', [gInfo.FStock]);
    ShowDlg(nStr, sHint, Handle);
  end;
end;

//Desc: ���������ϸ
procedure TfFormSaleAdjust.LoadAdjustDetail;
var i,nIdx: Integer;
begin
  nIdx := ListDtl.ItemIndex;
  ListDtl.Items.BeginUpdate;
  try
    ListDtl.Items.Clear;
    ListDtl.SmallImages := FDM.ImageBar;

    for i:=Low(gItems) to High(gItems) do
    if gItems[i].FSelect then
    with ListDtl.Items.Add do
    begin
      Caption := gItems[i].FCusName;
      SubItems.Add(gItems[i].FStock);
      SubItems.Add(Format('%.2f', [gItems[i].FPrice]));
      SubItems.Add(Format('%.2f', [gItems[i].FValue]));

      Data := Pointer(i);
      ImageIndex := cItemIconIndex;
    end;               
  finally
    if nIdx < ListDtl.Items.Count then
      ListDtl.ItemIndex := nIdx;
    ListDtl.Items.EndUpdate;
  end;
end;

//Desc: ���
procedure TfFormSaleAdjust.BtnAddClick(Sender: TObject);
var nVal: Double;
    nInt: Integer;
begin
  if (not IsNumber(EditValue.Text, True)) or (StrToFloat(EditValue.Text) <= 0) then
  begin
    EditValue.SetFocus;
    ShowMsg('��������ȷ�ĵ�����', sHint); Exit;
  end;

  for nInt:=Low(gItems) to High(gItems) do
  if gItems[nInt].FSelect and (gItems[nInt].FZhiKa = gActive.FZhiKa) then
  begin
    EditCard.SetFocus;
    ShowMsg('�ÿ������б���', sHint); Exit;
  end;

  nVal := StrToFloat(EditValue.Text);
  if FloatRelation(nVal * gActive.FPrice, gActive.FMoney, rtGreater, cPrecision) then
  begin
    EditValue.SetFocus;
    ShowMsg('�ѳ����ɵ�����', sHint); Exit;
  end;

  nInt := Length(gItems);
  SetLength(gItems, nInt + 1);

  with gItems[nInt] do
  begin
    FZhiKa := gActive.FZhiKa;
    FSaleMan := gActive.FSaleMan;
    FCusID := gActive.FCusID;
    FCusName := gActive.FCusName;
    FStock := gActive.FStock;
    FPrice := gActive.FPrice;
    FValue := nVal;
    FMoney := gActive.FMoney;
    FIsFix := gActive.FIsFix;

    FSelect := True;
    LoadAdjustDetail;
    BtnAdd.Enabled := False;
  end;
end;

//Desc: ɾ��ѡ����
procedure TfFormSaleAdjust.BtnDelClick(Sender: TObject);
var nInt: Integer;
begin
  if ListDtl.ItemIndex > -1 then
  begin
    nInt := Integer(ListDtl.Items[ListDtl.ItemIndex].Data);
    gItems[nInt].FSelect := False;
    LoadAdjustDetail;
  end;
end;

function TfFormSaleAdjust.OnVerifyCtrl(Sender: TObject;
  var nHint: string): Boolean;
var nVal: Double;
    nIdx: Integer;
begin
  Result := True;
  if Sender <> EditCard then Exit;

  Result := ListDtl.Items.Count > 0;
  nHint := '������ӵ�����ϸ';
  if not Result then Exit;

  nVal := 0;
  for nIdx:=Low(gItems) to High(gItems) do
  with gItems[nIdx] do
  begin
    if not FSelect then Continue;
    Result := FMoney = GetValidMoneyByZK(FZhiKa, FIsFix);

    if not Result then
    begin
      nHint := Format('�ͻ�[ %s ]���ʽ��ѷ����䶯,������������ֹ!!' + #13#10 +
               '���˳�������.', [FCusName]);
      ShowDlg(nHint, sHint, Handle);
      nHint := ''; Exit;
    end else nVal := nVal + FValue;
  end;

  gInfo.FSurplus := gInfo.FValue - nVal;
  Result := gInfo.FSurplus >= 0;

  if not Result then
  begin
    nHint := '�����������������,��������: ' + #13#10#13#10 +
             '*.�����: %.2f��' + #13#10 +
             '*.������: %.2f��' + #13#10#13#10 +
             '������ %.2f ��,��������ٴ�ִ�иղŵĲ���.';
    nHint := Format(nHint, [gInfo.FValue, nVal, -gInfo.FSurplus]);

    ShowDlg(nHint, sHint, Handle);
    nHint := ''; Exit;
  end;

  nHint := 'ȷ��Ҫִ�����ϵĵ���������?';
  Result := QueryDlg(nHint, sAsk, Handle);
  nHint := '';
end;

//Desc: ����SQL
procedure TfFormSaleAdjust.GetSaveSQLList(const nList: TStrings);
var nVal: Double;
    nIdx: Integer;
    nStr,nSQL: string;
begin
  nVal := gInfo.FPrice * (gInfo.FValue - gInfo.FSurplus);
  nVal := Float2Float(nVal, cPrecision, True);

  nStr := 'Update %s Set A_Compensation=A_Compensation-%.2f ' +
          'Where A_CID=''%s''';
  nStr := Format(nStr, [sTable_CusAccount, nVal, gInfo.FCusID]);
  nList.Add(nStr);

  if gInfo.FIsFix then
  begin
    nStr := 'Update %s Set Z_FixedMoney=Z_FixedMoney+%.2f' +
            'Where Z_ID=''%s'' and Z_OnlyMoney=''%s''';
    nStr := Format(nStr, [sTable_ZhiKa, nVal, gInfo.FZhiKa, sFlag_Yes]);
    nList.Add(nStr);
  end;

  nSQL := 'Insert Into $IM(M_SaleMan,M_CusID,M_CusName,M_Type,M_Payment,' +
          'M_Money,M_Date,M_Man,M_Memo) Values(''$SM'',''$CID'',''$CN'',' +
          '''$Type'',''$Pay'',$Mon,$Date,''$Man'',''$Memo'')';
  nSQL := MacroValue(nSQL, [MI('$IM', sTable_InOutMoney), MI('$Pay', '�ֽ�'),
          MI('$Type', sFlag_MoneyFanHuan), MI('$Man', gSysParam.FUserID)]);
  //xxxxx

  with gInfo do
  begin
    nStr := Format('�����: %s, ����: %.2f x %.2f', [FLadID, FPrice, FValue - FSurplus]);
    if FIsFix then
      nStr := nStr + Format(', ֽ�� %s ���������', [FZhiKa]);
    //xxxxx

    nStr := MacroValue(nSQL, [MI('$SM', FSaleMan), MI('$CID', FCusID),
            MI('$CN', FCusName), MI('$Mon', Format('%.2f', [-nVal])),
            MI('$Date', FDM.SQLServerNow), MI('$Memo', nStr)]);
    nList.Add(nStr);
  end;

  for nIdx:=Low(gItems) to High(gItems) do
  with gItems[nIdx] do
  begin
    if not FSelect then Continue;
    nVal := FPrice * FValue;
    nVal := Float2Float(nVal, cPrecision, True);

    nStr := 'Update %s Set A_Compensation=A_Compensation+%.2f ' +
            'Where A_CID=''%s''';
    nStr := Format(nStr, [sTable_CusAccount, nVal, FCusID]);
    nList.Add(nStr);

    if FIsFix then
    begin
      nStr := 'Update %s Set Z_FixedMoney=Z_FixedMoney-%.2f' +
              'Where Z_ID=''%s'' and Z_OnlyMoney=''%s''';
      nStr := Format(nStr, [sTable_ZhiKa, nVal, FZhiKa, sFlag_Yes]);
      nList.Add(nStr);
    end;

    nStr := Format('�����: %s, ����: %.2f x %.2f', [gInfo.FLadID, FPrice, FValue]);
    if FIsFix then
      nStr := nStr + Format(', ֽ�� %s ���������', [FZhiKa]);
    //xxxxx

    nStr := MacroValue(nSQL, [MI('$SM', FSaleMan), MI('$CID', FCusID),
            MI('$CN', FCusName), MI('$Mon', Format('%.2f', [nVal])),
            MI('$Date', FDM.SQLServerNow), MI('$Memo', nStr)]);
    nList.Add(nStr);
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormSaleAdjust, TfFormSaleAdjust.FormID);
end.

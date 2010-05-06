{*******************************************************************************
  ����: dmzn@163.com 2010-3-17
  ����: ��װ�Ͽ�
*******************************************************************************}
unit UFormLadingDaiHeKa;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, cxGraphics, cxLabel, cxMemo, cxTextEdit,
  cxContainer, cxEdit, cxMaskEdit, cxDropDownEdit, dxLayoutControl,
  StdCtrls, cxControls, cxButtonEdit, cxMCListBox, ComCtrls, cxListView;

type
  TfFormDaiHeKa = class(TfFormNormal)
    dxGroup2: TdxLayoutGroup;
    dxLayout1Item7: TdxLayoutItem;
    ListInfo: TcxMCListBox;
    ListBill: TcxListView;
    dxLayout1Item3: TdxLayoutItem;
    EditCard: TcxButtonEdit;
    dxLayout1Item4: TdxLayoutItem;
    EditNo: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    BtnAdd: TButton;
    dxLayout1Item8: TdxLayoutItem;
    BtnDel: TButton;
    dxLayout1Item9: TdxLayoutItem;
    EditBill: TcxComboBox;
    dxLayout1Item10: TdxLayoutItem;
    dxLayout1Group3: TdxLayoutGroup;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EditCardPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure EditBillPropertiesChange(Sender: TObject);
    procedure EditNoExit(Sender: TObject);
  protected
    { Private declarations }
    function OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean; override;
    procedure GetSaveSQLList(const nList: TStrings); override;
    //���෽��
    procedure InitFormData;
    //��������
    procedure LoadBillList;
    //�Ͽ��б�
    procedure ReleaeInnerData;
    //��Ƕ����
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
    FTruckID: string;
    FTruckNo: string;
    FCardNo: string;
  end;

  PHKItem = ^THKItem;
  THKItem = record
    FZhiKa: string;
    FLadID: string;
    FStock: string;
    FStockNo: string;
    FPrice: Double;
    FValue: Double;
    FSelect: Boolean;
  end;

var
  gInfo: TCommonInfo;
  gItems: array of THKItem;
  //ȫ��ʹ��

//------------------------------------------------------------------------------
class function TfFormDaiHeKa.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  if Assigned(nParam) then
       nP := nParam
  else Exit;

  with gInfo do
  begin
    FTruckID := nP.FParamA;
    FTruckNo := nP.FParamB;
    FCardNo := nP.FParamC;
  end;

  with TfFormDaiHeKa.Create(Application) do
  begin
    Caption := '��װ�Ͽ� - ����: ' + gInfo.FTruckNo;
    InitFormData;

    nP.FCommand := cCmd_ModalResult;
    nP.FParamA := ShowModal;
    Free;
  end;
end;

class function TfFormDaiHeKa.FormID: integer;
begin
  Result := cFI_FormDaiHeKa;
end;

procedure TfFormDaiHeKa.FormCreate(Sender: TObject);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadFormConfig(Self, nIni);
    LoadMCListBoxConfig(Name, ListInfo, nIni);
    LoadcxListViewConfig(Name, ListBill, nIni);
  finally
    nIni.Free;
  end;
end;

procedure TfFormDaiHeKa.FormClose(Sender: TObject;
  var Action: TCloseAction);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveFormConfig(Self, nIni);
    SaveMCListBoxConfig(Name, ListInfo, nIni);
    SavecxListViewConfig(Name, ListBill, nIni);
  finally
    nIni.Free;
  end;

  ReleaeInnerData;
end;

//------------------------------------------------------------------------------
//Desc: ��ʼ������
procedure TfFormDaiHeKa.InitFormData;
begin
  SetLength(gItems, 0);
  BtnAdd.Enabled := False;
  ActiveControl := EditCard;
end;

//Desc: ����Ͽ��б�
procedure TfFormDaiHeKa.LoadBillList;
var i,nIdx: Integer;
begin
  nIdx := ListBill.ItemIndex;
  ListBill.Items.BeginUpdate;
  try
    ListBill.Items.Clear;
    ListBill.SmallImages := FDM.ImageBar;

    for i:=Low(gItems) to High(gItems) do
    if gItems[i].FSelect then
    with ListBill.Items.Add do
    begin
      Caption := gItems[i].FLadID;
      SubItems.Add(gItems[i].FStock);
      SubItems.Add(Format('%.2f', [gItems[i].FValue]));
      SubItems.Add(gItems[i].FStockNo);

      Data := Pointer(i);
      ImageIndex := cItemIconIndex;
    end;               
  finally
    if nIdx < ListBill.Items.Count then
      ListBill.ItemIndex := nIdx;
    ListBill.Items.EndUpdate;
  end;
end;

//Desc: �ͷ���Ƕ����
procedure TfFormDaiHeKa.ReleaeInnerData;
var nP: PHKItem;
    nIdx: Integer;
begin
  for nIdx:=EditBill.Properties.Items.Count - 1 downto 0 do
  begin
    nP := Pointer(EditBill.Properties.Items.Objects[nIdx]);
    Dispose(nP);
    EditBill.Properties.Items.Delete(nIdx);
  end;
end;

//Desc: ��ȡ�ſ���Ϣ
procedure TfFormDaiHeKa.EditCardPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
var nStr: string;
    nData: PHKItem;
begin
  EditNo.Clear;
  ListInfo.Clear;
  BtnAdd.Enabled := False;

  ReleaeInnerData;
  EditCard.Text := Trim(EditCard.Text);
  if EditCard.Text = '' then Exit;

  if not IsCardCanUsing(EditCard.Text, nStr, True) then
  begin
    nStr := '�ôſ���ʱ�޷����ںϿ�,��������:' + #13#10#13#10 +
            AdjustHintToRead(nStr);
    ShowDlg(nStr, sHint, Handle); Exit;
  end;

  nStr := 'Select b.* from $Bill b ' +
          ' Left Join $TE te on te.E_Bill=b.L_ID ' +
          'Where L_Card=''$Card'' and L_TruckNo=''$Tuck'' and ' +
          ' (E_Bill Is Null) and L_Type=''$Dai''';
  nStr := MacroValue(nStr, [MI('$Bill', sTable_Bill),
          MI('$TE', sTable_TruckLogExt), MI('$Card', EditCard.Text),
          MI('$Tuck', gInfo.FTruckNo), MI('$Dai', sFlag_Dai)]);
  //xxxxx

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    First;

    while not Eof do
    with EditBill.Properties do
    begin
      New(nData);
      with nData^ do
      begin
        FZhiKa := FieldByName('L_ZID').AsString;
        FLadID := FieldByName('L_ID').AsString;
        FStock := FieldByName('L_Stock').AsString;
        FStockNo := GetNoByStock(FStock);
        FPrice := FieldByName('L_Price').AsFloat;
        FValue := FieldByName('L_Value').AsFloat;

        nStr := '%s:%s �����:%s��';
        nStr := Format(nStr, [FLadID, FStock, Format('%.2f',[FValue])]);
      end;

      Items.AddObject(nStr, TObject(nData));
      nStr := nData.FZhiKa;
      Next;
    end;

    if LoadZhiKaInfo(nStr, ListInfo, nStr) <> nil then
    begin
      EditBill.SetFocus;
      BtnAdd.Enabled := True;
    end else ShowMsg(nStr, sHint);
  end else
  begin
    nStr := Format('�ÿ���û�г���Ϊ %s �Ĵ�װ�����.', [gInfo.FTruckNo]);
    ShowDlg(nStr, sHint, Handle);
  end;
end;

//Desc: ���
procedure TfFormDaiHeKa.BtnAddClick(Sender: TObject);
var nInt: Integer;
    nData: PHKItem;
begin
  if EditBill.ItemIndex < 0 then
  begin
    EditBill.SetFocus;
    ShowMsg('��ѡ��Ҫ�Ͽ������', sHint); Exit;
  end;

  nData := Pointer(EditBill.Properties.Items.Objects[EditBill.ItemIndex]);
  //��Ƕ����

  for nInt:=Low(gItems) to High(gItems) do
  if gItems[nInt].FSelect and (gItems[nInt].FLadID = nData.FLadID) then
  begin
    EditBill.SetFocus;
    ShowMsg('������������б���', sHint); Exit;
  end;

  nInt := Length(gItems);
  SetLength(gItems, nInt + 1);

  with gItems[nInt] do
  begin
    FZhiKa := nData.FZhiKa;
    FStock := nData.FStock;
    FStockNo := EditNo.Text;
    
    FLadID := nData.FLadID;
    FPrice := nData.FPrice;
    FValue := nData.FValue;

    FSelect := True;
    LoadBillList;
  end;
end;

//Desc: ɾ��ѡ����
procedure TfFormDaiHeKa.BtnDelClick(Sender: TObject);
var nInt: Integer;
begin
  if ListBill.ItemIndex > -1 then
  begin
    nInt := Integer(ListBill.Items[ListBill.ItemIndex].Data);
    gItems[nInt].FSelect := False;
    LoadBillList;
  end;
end;

//Desc: ���������
procedure TfFormDaiHeKa.EditBillPropertiesChange(Sender: TObject);
var nP: PHKItem;
begin
  if EditBill.ItemIndex > -1 then
  begin
    nP := Pointer(EditBill.Properties.Items.Objects[EditBill.ItemIndex]);
    EditNo.Text := nP.FStockNo;
  end;
end;

//Desc: ͬ��ˮ����
procedure TfFormDaiHeKa.EditNoExit(Sender: TObject);
var nP: PHKItem;
begin
  EditNo.Text := Trim(EditNo.Text);
  if EditNo.Text = '' then Exit;

  if EditBill.ItemIndex > -1 then
  begin
    nP := Pointer(EditBill.Properties.Items.Objects[EditBill.ItemIndex]);
    nP.FStockNo := EditNo.Text;
    SetStockNo(nP.FStock, EditNo.Text);
  end;
end;

function TfFormDaiHeKa.OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean;
begin
  Result := True;
  if Sender = EditCard then
  begin
    Result := ListBill.Items.Count > 0;
    nHint := '������ӺϿ���ϸ';
  end;
end;

//Desc: �Ͽ�SQL
procedure TfFormDaiHeKa.GetSaveSQLList(const nList: TStrings);
var nIdx: Integer;
    nStr,nSQL: string;
begin
  nSQL := 'Insert Into $TE(E_TID,E_Truck,E_ZID,E_Bill,E_Price,E_Value,' +
          'E_Card,E_StockNo,E_IsHK) Values(''$TID'',''$Truck'',''$ZID'',' +
          '''$Bill'',$Price,$Val,''$Card'',''$NO'',''$Yes'')';
  nSQL := MacroValue(nSQL, [MI('$TE', sTable_TruckLogExt),
          MI('$TID', gInfo.FTruckID), MI('$Truck', gInfo.FTruckNo),
          MI('$Card', gInfo.FCardNo), MI('$Yes', sFlag_Yes)]);
  //xxxxx

  for nIdx:=Low(gItems) to High(gItems) do
  with gItems[nIdx] do
  begin
    if not FSelect then Continue;

    nStr := MacroValue(nSQL, [MI('$ZID', FZhiKa), MI('$Bill', FLadID),
            MI('$Price', Format('%.2f', [FPrice])),
            MI('$Val', Format('%.2f', [FValue])), MI('$NO', FStockNo)]);
    nList.Add(nStr);
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormDaiHeKa, TfFormDaiHeKa.FormID);
end.

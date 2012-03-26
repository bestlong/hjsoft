{*******************************************************************************
  ����: dmzn@163.com 2010-3-14
  ����: ��Ӧ��������ë��
*******************************************************************************}
unit UFormPBangFangM;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFormNormal, USysBusiness, ComCtrls, cxGraphics, cxDropDownEdit,
  cxMaskEdit, cxButtonEdit, cxEdit, cxTextEdit, cxListView, cxContainer,
  cxMCListBox, dxLayoutControl, StdCtrls, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxLookupEdit, cxDBLookupEdit, cxDBLookupComboBox,
  cxMemo, cxCalendar, cxLabel;

type
  TfFormPBangFangM = class(TfFormNormal)
    dxGroup2: TdxLayoutGroup;
    EditValue: TcxButtonEdit;
    dxLayout1Item9: TdxLayoutItem;
    EditTruck: TcxComboBox;
    dxLayout1Item8: TdxLayoutItem;
    BtnGet: TButton;
    dxLayout1Item5: TdxLayoutItem;
    dxLayout1Item3: TdxLayoutItem;
    EditMate: TcxComboBox;
    dxLayout1Item4: TdxLayoutItem;
    EditSM: TcxComboBox;
    dxLayout1Item6: TdxLayoutItem;
    EditPNum: TcxTextEdit;
    dxLayout1Item10: TdxLayoutItem;
    cxLabel1: TcxLabel;
    dxLayout1Item11: TdxLayoutItem;
    EditPTime: TcxDateEdit;
    dxLayout1Item12: TdxLayoutItem;
    EditMemo: TcxMemo;
    dxLayout1Group2: TdxLayoutGroup;
    dxLayout1Group5: TdxLayoutGroup;
    dxLayout1Group4: TdxLayoutGroup;
    EditProvider: TcxLookupComboBox;
    dxLayout1Item13: TdxLayoutItem;
    dxLayout1Group6: TdxLayoutGroup;
    dxLayout1Item7: TdxLayoutItem;
    ListTruck: TcxMCListBox;
    dxLayout1Group3: TdxLayoutGroup;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ListTruckClick(Sender: TObject);
    procedure EditValuePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnGetClick(Sender: TObject);
    procedure EditTruckPropertiesEditValueChanged(Sender: TObject);
  protected
    { Protected declarations }
    procedure InitFormData(const nID: string);
    //��������
    procedure LoadLastTruckProvice(const nTruck: string);
    //�ϴι�Ӧ
    function OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean; override;
    procedure GetSaveSQLList(const nList: TStrings); override;
    procedure AfterSaveData(var nDefault: Boolean); override;
    //���෽��
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
    //���ຯ��
  end;

implementation

{$R *.dfm}
uses
  IniFiles, DB, ULibFun, UMgrControl, USysPopedom, USysGrid, USysDB, USysConst,
  UFormCtrl, UDataModule, UFrameBase, UFormWeight, UFormInputbox,
  UMgrLookupAdapter;

type
  TCommonInfo = record
    FRecord: string[20];      //��¼��
    FProvider: string[80];    //��Ӧ��
    FMate: string[30];        //ԭ����
    FSaleMan: string[32];     //ҵ��Ա

    FPrice: Double;           //����
    FUnit: string[20];        //��λ
    FCardNo: string[30];      //�ſ���
    FTruckNo: string[15];     //���ƺ�
    FStatus: string[2];       //״̬(Ƥ,ë)

    FPreValue: Double;        //Ԥ��Ƥ��
    FPreMan: string[32];      //Ԥ����
    FPreTime: TDateTime;      //Ԥ��ʱ��

    FPaiNum: string[15];      //�ɳ���
    FPaiTime: TDateTime;      //ʱ��
    FMemo: string[50];        //��ע
  end;

  TCardItem = record
    FProvider: string;    //��Ӧ��
    FMate: string;        //ԭ����
    FSaleMan: string;     //ҵ��Ա
    FTruck: string;       //���ƺ�

    FPreValue: Double;    //Ԥ��Ƥ��
    FPreMan: string;      //Ԥ����
    FPreTime: TDateTime;  //Ԥ��ʱ��
  end;

var
  gInfo: TCommonInfo;
  gCardItems: array of TCardItem;
  //ȫ��ʹ��

//------------------------------------------------------------------------------
class function TfFormPBangFangM.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nStr: string;
    nID: Integer;
    nInfo: TDynamicStrArray;
begin
  Result := nil;
  nStr := '';
  SetLength(gCardItems, 0);
             
  while nStr = '' do
  begin
    if ShowInputBox('�����복�ƺŻ�ſ���:', '����', nStr) then
         nStr := Trim(nStr)
    else Exit;
  end;

  with gInfo do
  begin
    FillChar(gInfo, SizeOf(gInfo), #0);
    FTruckNo := nStr;
    FStatus := sFlag_TruckBFM;
    FPaiNum := '';
    FPaiTime := Date();
  end;

  nID := GetProvideLog(nStr, nInfo);
  if nID >= 0 then
  begin
    with gInfo do
    begin
      FRecord := IntToStr(nID);
      FTruckNo := nInfo[0];
      FProvider := nInfo[1];
      FMate := nInfo[2];
      FSaleMan := nInfo[3];

      FPaiNum := nInfo[4];
      FPaiTime := Str2Date(nInfo[5]);

      FMemo := nInfo[6];
      FCardNo := nInfo[7];
      FStatus := nInfo[8];

      if FStatus <> sFlag_TruckBFM then
      begin
        nStr := '�ó�ë���Ѵ���,��ϸ��Ϣ����: ' + #13#10#13#10 +
                '��¼���: %s' + #13#10 +
                '���ƺ���: %s' + #13#10 +
                '�� Ӧ ��: %s' + #13#10 +
                'ԭ �� ��: %s' + #13#10#13#10 +
                '�ó�����δ�����ļ�¼,���ȴ���.';
        nStr := Format(nStr, [FRecord, FTruckNo, FProvider, FMate]);

        ShowDlg(nStr, sAsk);
        Exit;
      end;
    end;
  end else //�Ƿ��ڳ�
  begin
    if not IsProvideTruckAutoIO(1) then
    begin
      ShowDlg('��Ӧ��������������ˢ������.', sHint); Exit;
    end;
  end;  

  if (nID < 0) or (gInfo.FStatus = sFlag_TruckBFM) then
  begin
    gInfo.FCardNo := nStr;
    nStr := 'Select * From %s Where P_Card=''%s'' ' +
            'And P_Status=''%s'' Order By P_Owner';
    nStr := Format(nStr, [sTable_ProvideCard, gInfo.FCardNo, sFlag_CardUsed]);

    with FDM.QueryTemp(nStr) do
    if RecordCount > 0 then
    begin
      SetLength(gCardItems, RecordCount);
      nID := 0;
      First;

      while not Eof do
      with gCardItems[nID] do
      begin
        FProvider := FieldByName('P_Provider').AsString;
        FMate := FieldByName('P_Mate').AsString;
        FTruck := FieldByName('P_Owner').AsString;
        FSaleMan := FieldByName('P_SaleMan').AsString;

        FPreValue := FieldByName('P_PrePValue').AsFloat;
        FPreMan := FieldByName('P_PrePMan').AsString;
        FPreTime := FieldByName('P_PrePTime').AsDateTime;

        Next; Inc(nID);
      end;
    end else gInfo.FCardNo := '';
  end; //card valid

  with TfFormPBangFangM.Create(Application) do
  begin
    Caption := '����ë��';
    PopedomItem := nPopedom;

    InitFormData('');
    ShowModal;
    Free;
  end;
end;

class function TfFormPBangFangM.FormID: integer;
begin
  Result := cFI_FormProvideBF;
end;

procedure TfFormPBangFangM.FormCreate(Sender: TObject);
var nInt: Integer;
    nIni: TIniFile;
begin
  if not Assigned(gLookupComboBoxAdapter) then
    gLookupComboBoxAdapter := TLookupComboBoxAdapter.Create(FDM.ADOConn);
  //xxxxx

  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadFormConfig(Self, nIni);
    LoadMCListBoxConfig(Name, ListTruck, nIni);

    nInt := nIni.ReadInteger(Name, 'DropWidth', 0);
    if nInt > 0 then EditProvider.Properties.DropDownWidth := nInt;
  finally
    nIni.Free;
  end;
end;

procedure TfFormPBangFangM.FormClose(Sender: TObject;
  var Action: TCloseAction);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveFormConfig(Self, nIni);
    SaveMCListBoxConfig(Name, ListTruck, nIni);
    nIni.WriteInteger(Name, 'DropWidth', EditProvider.Properties.DropDownWidth);
  finally
    nIni.Free;
  end;

  gLookupComboBoxAdapter.DeleteGroup(Name);
end;

//------------------------------------------------------------------------------
//Desc: ��ʼ������
procedure TfFormPBangFangM.InitFormData(const nID: string);
var nIdx: Integer;
    nStr,nTmp: string;
    nDStr: TDynamicStrArray;
    nItem: TLookupComboBoxItem; 
begin
  ActiveControl := BtnGet;
  EditValue.Text := '0';
  EditValue.Properties.ReadOnly := True;

  with gInfo do
  begin
    EditMemo.Text := FMemo;
    EditPNum.Text := FPaiNum;
    EditPTime.Date := FPaiTime;
  end;

  if Length(gCardItems) > 0 then
  begin
    for nIdx:=Low(gCardItems) to High(gCardItems) do
    with gCardItems[nIdx] do
    begin
      with EditProvider.Properties do
       if Items.IndexOf(FProvider) < 0 then Items.Add(FProvider);
      with EditMate.Properties do
       if Items.IndexOf(FMate) < 0 then Items.Add(FMate);
      with EditSM.Properties do
       if Items.IndexOf(FSaleMan) < 0 then Items.Add(FSaleMan);
      with EditTruck.Properties do
       if Items.IndexOf(FTruck) < 0 then Items.Add(FTruck);

      with ListTruck do
      begin
        nStr := CombinStr([FTruck + ' ', FMate + ' ', FProvider + ' ',
                           FSaleMan + ' '], Delimiter);
        Items.Add(nStr);

        if FTruck = gInfo.FTruckNo then
          ListTruck.ItemIndex := Items.Count - 1;
        //init default
      end;
    end;

    if ListTruck.ItemIndex < 0 then
      ListTruck.ItemIndex := 0;
    ListTruckClick(nil);
  end else

  if gInfo.FCardNo = '' then
  begin
    if not Assigned(EditProvider.Properties.ListSource) then
    begin
      nStr := 'Select P_PY,P_Name From %s Order By P_Name ASC';
      nStr := Format(nStr, [sTable_Provider]);

      nTmp := Name + 'Pro';
      SetLength(nDStr, 1);
      nDStr[0] := 'P_PY';

      nItem := gLookupComboBoxAdapter.MakeItem(Name, nTmp, nStr, 'P_Name', 1,
               [MI('P_PY', '��д'), MI('P_Name', '����')], nDStr);
      gLookupComboBoxAdapter.AddItem(nItem);
      gLookupComboBoxAdapter.BindItem(nTmp, EditProvider);
    end;

    nStr := 'Select M_Name From %s Order By M_Name ASC';
    nStr := Format(nStr, [sTable_Materails]);
    FDM.FillStringsData(EditMate.Properties.Items, nStr, -1);

    EditSM.Clear;
    EditTruck.Clear;

    nStr := 'Select DISTINCT L_Truck,L_SaleMan From %s Order By L_Truck ASC';
    nStr := Format(nStr, [sTable_ProvideLog]);

    with FDM.QueryTemp(nStr) do
    if RecordCount > 0 then
    begin
      First;

      while not Eof do
      begin
        nStr := Fields[0].AsString;
        if EditTruck.Properties.Items.IndexOf(nStr) < 0 then
          EditTruck.Properties.Items.Add(nStr);
        //xxxxx

        nStr := Trim(Fields[1].AsString);
        if (nStr <> '') and (EditSM.Properties.Items.IndexOf(nStr) < 0) then
          EditSM.Properties.Items.Add(nStr);
        //xxxxx

        Next;
      end;
    end;
  end;    
               
  if Length(gCardItems) < 1 then
  with gInfo do
  begin
    EditProvider.Text := FProvider;
    EditMate.Text := FMate;
    EditSM.Text := FSaleMan;

    nIdx := EditTruck.Properties.Items.IndexOf(FTruckNo);
    if nIdx > -1 then EditTruck.ItemIndex := nIdx;

    if EditTruck.ItemIndex < 0 then
    begin
      for nIdx:=0 to EditTruck.Properties.Items.Count - 1 do
      if Pos(FTruckNo, EditTruck.Properties.Items[nIdx]) > 0 then
      begin
        EditTruck.ItemIndex := nIdx; Break;
      end;
    end;

    if EditTruck.ItemIndex < 0 then
      EditTruck.Text := FTruckNo;
    //xxxxx

    if (FProvider = '') and (gInfo.FRecord = '') then
      LoadLastTruckProvice(FTruckNo);
    //try load default
  end;
end;

//Desc: ����nTuck���ϴι�Ӧ����
procedure TfFormPBangFangM.LoadLastTruckProvice(const nTruck: string);
var nStr: string;
    nIdx: Integer;

    //��ǰ��¼�����Ƿ����
    function ItemExists: Boolean;
    var i: Integer;
    begin
      Result := False;

      for i:=Low(gCardItems) to High(gCardItems) do
      with FDM.SqlTemp,gCardItems[i] do
      begin
        if (FProvider = Fields[0].AsString) and (FMate = Fields[1].AsString) and
           (FSaleMan = Fields[2].AsString) then
        begin
          Result := True; Break;
        end;
      end;
    end;
begin
  ListTruck.Clear;
  SetLength(gCardItems, 0);

  nStr := 'Select Distinct Top 10 L_Provider,L_Mate,L_SaleMan,L_Truck From %s ' +
          'Where L_Truck Like ''%%%s%%'' Order By L_Truck ASC';
  nStr := Format(nStr, [sTable_ProvideLog, nTruck]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    SetLength(gCardItems, RecordCount);
    nIdx := 0;
    First;

    while not Eof do
    begin
      if not ItemExists then
      begin
        FillChar(gCardItems[nIdx], SizeOf(TCardItem), #0);
        //default all field

        with gCardItems[nIdx],ListTruck do
        begin
          FProvider := Fields[0].AsString;
          FMate := Fields[1].AsString;
          FSaleMan := Fields[2].AsString;
          FTruck := Fields[3].AsString;

          nStr := CombinStr([FTruck + ' ', FMate + ' ', FProvider + ' ',
                             FSaleMan + ' '], Delimiter);
          Items.Add(nStr);
        end;

        Inc(nIdx);
      end;

      Next;
    end;

    ListTruck.ItemIndex := 0;
    ListTruckClick(nil);
  end;
end;

//Desc: �л�����
procedure TfFormPBangFangM.EditTruckPropertiesEditValueChanged(
  Sender: TObject);
begin
  if EditTruck.IsFocused and (EditTruck.ItemIndex > -1) and
     (gInfo.FRecord = '') and (gInfo.FCardNo = '') then
    LoadLastTruckProvice(EditTruck.Text);
  //xxxxx
end;

//Desc: ѡ����
procedure TfFormPBangFangM.ListTruckClick(Sender: TObject);
begin
  if ListTruck.ItemIndex > -1 then
  with gCardItems[ListTruck.ItemIndex] do
  begin
    EditProvider.Text := FProvider;
    EditMate.Text := FMate;
    EditSM.Text := FSaleMan;
    EditTruck.Text := FTruck;
  end;
end;

//Desc: �Ӵ�����
procedure TfFormPBangFangM.EditValuePropertiesButtonClick(Sender: TObject;
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
procedure TfFormPBangFangM.BtnGetClick(Sender: TObject);
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

function TfFormPBangFangM.OnVerifyCtrl(Sender: TObject;
  var nHint: string): Boolean;
var nStr: string;
    nInt: Integer;
begin
  Result := True;
  if Sender = EditProvider then
  begin
    Result := Trim(EditProvider.Text) <> '';
    nHint := '����д��Ч�Ĺ�Ӧ��';
  end else

  if Sender = EditMate then
  begin
    Result := Trim(EditMate.Text) <> '';
    nHint := '����д��Ч��ԭ����';
    if not Result then Exit;

    nStr := 'Select *,%s As M_Now From %s Where M_Name=''%s''';
    nStr := Format(nStr, [FDM.SQLServerNow, sTable_Materails, EditMate.Text]);

    with FDM.QueryTemp(nStr) do
    if RecordCount = 1 then
    begin
      gInfo.FPrice := FieldByName('M_Price').AsFloat;
      gInfo.FUnit := FieldByName('M_Unit').AsString;

      gInfo.FPreValue := 0;
      if ListTruck.ItemIndex < 0 then Exit;
      if FieldByName('M_PrePValue').AsString <> sFlag_Yes then Exit;

      with gCardItems[ListTruck.ItemIndex] do
      if FPreValue > 0 then
      begin
        nInt := Trunc(FieldByName('M_Now').AsFloat - FPreTime);
        if nInt < FieldByName('M_PrePTime').AsInteger then
        begin
          gInfo.FPreValue := FPreValue;
          gInfo.FPreMan := FPreMan;
          gInfo.FPreTime := FPreTime;
        end else
        begin
          nStr := 'ע��: �ó�����Ԥ��Ƥ���ѹ���,���֪˾������ǰ����Ƥ��!';
          ShowDlg(nStr, sWarn, Handle);
        end;
      end;
    end else
    begin
      Result := False;
      nHint := '��Ч��ԭ��������';
    end;
  end else

  if Sender = EditTruck then
  begin
    Result := Trim(EditTruck.Text) <> '';
    nHint := '����д��Ч�ĳ��ƺ�';
  end else

  if Sender = EditValue then
  begin
    Result := IsNumber(EditValue.Text, True) and (StrToFloat(EditValue.Text) > 0);
    nHint := '����Ϊ�������ֵ';
  end;
end;

//Desc: ����SQL
procedure TfFormPBangFangM.GetSaveSQLList(const nList: TStrings);
var nStr: string;
    nTmp: TStrings;
begin
  nTmp := TStringList.Create;
  try
    nTmp.Add(Format('L_Provider=''%s''', [EditProvider.Text]));
    nTmp.Add(Format('L_SaleMan=''%s''', [EditSM.Text]));
    nTmp.Add(Format('L_Mate=''%s''', [EditMate.Text]));
    nTmp.Add(Format('L_Unit=''%s''', [gInfo.FUnit]));
    nTmp.Add(Format('L_Truck=''%s''', [EditTruck.Text]));
    nTmp.Add(Format('L_MValue=%s', [EditValue.Text]));
    nTmp.Add(Format('L_MMan=''%s''', [gSysParam.FUserID]));
    nTmp.Add(Format('L_MDate=%s', [FDM.SQLServerNow]));
    nTmp.Add('L_PrintNum=0');
    nTmp.Add(Format('L_PaiNum=''%s''', [EditPNum.Text]));
    nTmp.Add(Format('L_PaiTime=''%s''', [Date2Str(EditPTime.Date)]));
    nTmp.Add(Format('L_Memo=''%s''', [EditMemo.Text]));

    if gInfo.FPreValue > 0 then
    begin
      nTmp.Add(Format('L_PValue=%s', [FloatToStr(gInfo.FPreValue)]));
      nTmp.Add(Format('L_PMan=''%s''', [gInfo.FPreMan]));
      nTmp.Add(Format('L_PDate=''%s''', [DateTime2Str(gInfo.FPreTime)]));

      nTmp.Add(Format('L_Price=%.2f', [gInfo.FPrice]));
      if IsProvideTruckAutoIO(2) then
      begin
        nTmp.Add(SF('L_Card', ''));
        nTmp.Add(SF('L_Status', sFlag_TruckOut));
        nTmp.Add(SF('L_NextStatus', ''));
        nTmp.Add(SF('L_OutMan', gSysParam.FUserID));
        nTmp.Add(SF('L_OutDate', FDM.SQLServerNow, sfVal));
      end else //auto out
      begin
        nTmp.Add(SF('L_Status', sFlag_TruckBFP));
        nTmp.Add(SF('L_NextStatus', sFlag_TruckOut));
      end;
    end else
    begin
      nTmp.Add(Format('L_Card=''%s''', [gInfo.FCardNo]));
      nTmp.Add(SF('L_Status', sFlag_TruckBFM));
      nTmp.Add(SF('L_NextStatus', sFlag_TruckBFP));

      if IsProvideTruckAutoIO(1) then
      begin
        nTmp.Add(SF('L_InMan', gSysParam.FUserID));
        nTmp.Add(SF('L_InDate', FDM.SQLServerNow, sfVal));
      end; //auto in
    end;

    if gInfo.FRecord = '' then
         nStr := MakeSQLByCtrl(nil, sTable_ProvideLog, '', True, nil, nTmp)
    else nStr := MakeSQLByCtrl(nil, sTable_ProvideLog,
                 'L_ID=' + gInfo.FRecord, False, nil, nTmp);
    nList.Add(nStr);
  finally
    nTmp.Free;
  end;
end;

procedure TfFormPBangFangM.AfterSaveData(var nDefault: Boolean);
begin
  if (gInfo.FStatus = sFlag_TruckBFM) and (gInfo.FPreValue > 0) then
  begin
    gInfo.FStatus := sFlag_TruckBFP;
    if gInfo.FRecord = '' then
      gInfo.FRecord := IntToStr(FDM.GetFieldMax(sTable_ProvideLog, 'L_ID'));
    //get record
  end;

  if gInfo.FStatus = sFlag_TruckBFP then
    PrintProvidePoundReport(gInfo.FRecord, True);
  BroadcastFrameCommand(Self, cCmd_RefreshData);
end;

initialization
  gControlManager.RegCtrl(TfFormPBangFangM, TfFormPBangFangM.FormID);
end.

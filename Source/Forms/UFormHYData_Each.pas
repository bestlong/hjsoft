{*******************************************************************************
  ����: dmzn@163.com 2010-3-16
  ����: �泵�����鵥
*******************************************************************************}
unit UFormHYData_Each;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, dxLayoutControl, StdCtrls, cxControls, cxMemo,
  cxButtonEdit, cxLabel, cxTextEdit, cxContainer, cxEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, cxGraphics, ComCtrls, cxListView, Menus,
  cxLookAndFeels, cxLookAndFeelPainters, cxMCListBox;

type
  THYTruckItem = record
    FTruckID: string;             //�������
    FTruckNo: string;             //���ƺ�
    FStockNo: string;             //ˮ����
    FStockNum: Double;            //�����
    FLadTime: TDateTime;          //���ʱ��
    FLadingID: array of string;   //�������
    FTruckEID: array of string;   //������ϸ
  end;

  TfFormHYData_Each = class(TfFormNormal)
    dxLayout1Item3: TdxLayoutItem;
    InfoList1: TcxMCListBox;
    dxLayout1Item4: TdxLayoutItem;
    EditCard: TcxButtonEdit;
    dxLayout1Item6: TdxLayoutItem;
    EditZID: TcxButtonEdit;
    dxLayout1Item8: TdxLayoutItem;
    TruckList1: TcxMCListBox;
    dxLayout1Item9: TdxLayoutItem;
    ParamList1: TcxMCListBox;
    dxLayout1Group4: TdxLayoutGroup;
    dxLayout1Group5: TdxLayoutGroup;
    dxLayout1Item10: TdxLayoutItem;
    EditLading: TcxTextEdit;
    dxLayout1Item11: TdxLayoutItem;
    EditLDate: TcxDateEdit;
    dxLayout1Item12: TdxLayoutItem;
    EditRDate: TcxDateEdit;
    dxLayout1Item13: TdxLayoutItem;
    EditReporter: TcxTextEdit;
    dxLayout1Item14: TdxLayoutItem;
    EditStockNo: TcxButtonEdit;
    dxLayout1Item15: TdxLayoutItem;
    EditItem: TcxTextEdit;
    dxLayout1Item16: TdxLayoutItem;
    EditValue: TcxTextEdit;
    cxLabel1: TcxLabel;
    dxLayout1Item5: TdxLayoutItem;
    dxLayout1Group2: TdxLayoutGroup;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EditCardPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure EditZIDPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure TruckList1Click(Sender: TObject);
    procedure ParamList1Click(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
  protected
    { Protected declarations }
    FZhiKa,FTruck: string;
    //Ĭ�ϲ���
    FTrucks: array of THYTruckItem;
    //�������
    function OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean; override;
    //��֤����
    procedure InitFormData(const nZK,nTruck: string);
    //��������
    procedure LoadZhiKaData(const nZK,nTruck: string);
    //��ȡֽ��
    function LoadStockRecord(const nID: string): Boolean;
    //�����¼
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  IniFiles, ULibFun, UFormCtrl, UAdjustForm, UFormBase, UMgrControl, USysGrid,
  USysDB, USysConst, USysBusiness, UDataModule, UFormInputbox;

class function TfFormHYData_Each.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  if Assigned(nParam) then
  begin
    nP := nParam;
    if nP.FCommand <> cCmd_AddData then Exit;
  end else nP := nil;

  with TfFormHYData_Each.Create(Application) do
  try
    Caption := '�����鵥';
    if Assigned(nP) then
    begin
      InitFormData(nP.FParamA, nP.FParamB);
      nP.FCommand := cCmd_ModalResult;
      nP.FParamA := ShowModal;
    end else
    begin
      InitFormData('', '');
      ShowModal;
    end;
  finally
    Free;
  end;
end;

class function TfFormHYData_Each.FormID: integer;
begin
  Result := cFI_FormStockHY_Each;
end;

procedure TfFormHYData_Each.FormCreate(Sender: TObject);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadFormConfig(Self, nIni);
    LoadMCListBoxConfig(Name, InfoList1, nIni);
    LoadMCListBoxConfig(Name, TruckList1, nIni);
    LoadMCListBoxConfig(Name, ParamList1, nIni);
  finally
    nIni.Free;
  end;
end;

procedure TfFormHYData_Each.FormClose(Sender: TObject;
  var Action: TCloseAction);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveFormConfig(Self, nIni);
    SaveMCListBoxConfig(Name, InfoList1, nIni);
    SaveMCListBoxConfig(Name, TruckList1, nIni);
    SaveMCListBoxConfig(Name, ParamList1, nIni);
  finally
    nIni.Free;
  end;
end;

//------------------------------------------------------------------------------
//Desc: ��ʼ������
procedure TfFormHYData_Each.InitFormData(const nZK,nTruck: string);
begin
  EditLDate.Date := Now;
  EditRDate.Date := Now;
  
  dxGroup1.AlignHorz := ahClient;
  EditReporter.Text := gSysParam.FUserID;

  if (nZK = '') and (nTruck = '') then
       ActiveControl := EditCard
  else LoadZhiKaData(nZK, nTruck);
end;

//Date: 2011-1-16
//Parm: ֽ����;������¼
//Desc: �����ʶΪnZK��ֽ����Ϣ
procedure TfFormHYData_Each.LoadZhiKaData(const nZK,nTruck: string);
var nStr,nTmp,nTID: string;
    nIdx,nLen: integer;
begin
  FZhiKa := nZK;
  EditZID.Text := FZhiKa;

  if not Assigned(LoadZhiKaInfo(nZK, InfoList1, nStr)) then
  begin
    ShowMsg(nStr, sHint); Exit;
  end;

  TruckList1.Clear;
  SetLength(FTrucks, 0);

  nStr := 'Select te.*,T_BFMTime,T_Truck From $TE te ' +
          ' Left Join $TL tl On tl.T_ID=te.E_TID ';
  //xxxxx

  if nTruck = '' then
       nTmp := 'E_TID In (Select E_TID From $TE Where (E_ZID=''$ZID''))'
  else nTmp := 'E_TID=''$TID''';

  nStr := nStr + ' Where ' + nTmp +
          ' And (T_BFMTime is Not Null And E_HyID Is Null And ' +
          'E_HyNo Is Null) Order By T_BFMTime,T_Truck';
  //xxxxx

  nStr := MacroValue(nStr, [MI('$TE', sTable_TruckLogExt), MI('$ZID', nZK),
          MI('$TL', sTable_TruckLog), MI('$TID', nTruck),
          MI('$Bill', sTable_Bill)]);
  //xxxxx

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    First;

    while not Eof do
    begin
      nStr := FieldByName('T_Truck').AsString;
      nTmp := FieldByName('E_StockNo').AsString;
      nTID := FieldByName('E_TID').AsString;

      nLen := High(FTrucks);
      for nIdx:=Low(FTrucks) to nLen do
      if (FTrucks[nIdx].FTruckID = nTID) and
         (CompareText(FTrucks[nIdx].FTruckNo, nStr) = 0) and
         (CompareText(FTrucks[nIdx].FStockNo, nTmp) = 0) then
      begin
        FTrucks[nIdx].FStockNum := FTrucks[nIdx].FStockNum +
                                   FieldByName('E_Value').AsFloat;
        //�ϼ������
        
        if FieldByName('T_BFMTime').AsDateTime > FTrucks[nIdx].FLadTime then
          FTrucks[nIdx].FLadTime := FieldByName('T_BFMTime').AsDateTime;
        //ʹ���������ʱ��

        nLen := Length(FTrucks[nIdx].FTruckEID);
        SetLength(FTrucks[nIdx].FTruckEID, nLen + 1);
        FTrucks[nIdx].FTruckEID[nLen] := FieldByName('E_ID').AsString;

        nLen := Length(FTrucks[nIdx].FLadingID);
        SetLength(FTrucks[nIdx].FLadingID, nLen + 1);
        FTrucks[nIdx].FLadingID[nLen] := FieldByName('E_Bill').AsString;

        nLen := MaxInt; Next;
        Break;
      end;

      if nLen = MaxInt then Continue;
      //ͬ��ͬƷ�ֺ϶�

      nLen := Length(FTrucks);
      SetLength(FTrucks, nLen + 1);

      FTrucks[nLen].FTruckID := nTID;
      FTrucks[nLen].FTruckNo := nStr;
      FTrucks[nLen].FStockNo := nTmp;
      FTrucks[nLen].FStockNum := FieldByName('E_Value').AsFloat;
      FTrucks[nLen].FLadTime := FieldByName('T_BFMTime').AsDateTime;

      SetLength(FTrucks[nLen].FTruckEID, 1);
      FTrucks[nLen].FTruckEID[0] := FieldByName('E_ID').AsString;

      SetLength(FTrucks[nLen].FLadingID, 1);
      FTrucks[nLen].FLadingID[0] := FieldByName('E_Bill').AsString;
      Next;
    end;

    nLen := High(FTrucks);
    for nIdx:=Low(FTrucks) to nLen do
    begin
      FTrucks[nIdx].FStockNum := Float2Float(FTrucks[nIdx].FStockNum,
        cPrecision, False);
      //adjust float data
      
      nStr := CombinStr([FTrucks[nIdx].FTruckNo,
              FTrucks[nIdx].FStockNo + ' ',
              Format('%.2f', [FTrucks[nIdx].FStockNum]),
              DateTime2Str(FTrucks[nIdx].FLadTime)], TruckList1.Delimiter);
      TruckList1.Items.Add(nStr);
    end;
  end;
end;

procedure TfFormHYData_Each.EditCardPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
var nStr: string;
begin
  EditCard.Text := Trim(EditCard.Text);
  if EditCard.Text = '' then
  begin
    EditCard.SetFocus;
    ShowMsg('����д�ſ���', sHint); Exit;
  end;
  
  EditZID.Clear;
  InfoList1.Clear;
  TruckList1.Clear;

  nStr := 'Select C_ZID From %s Where C_Card=''%s''';
  nStr := Format(nStr, [sTable_ZhiKaCard, EditCard.Text]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
       LoadZhiKaData(Fields[0].AsString, '')
  else ShowMsg('��Ч�Ĵſ���', sHint);
end;

procedure TfFormHYData_Each.EditZIDPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
var nStr: string;
begin
  EditZID.Text := Trim(EditZID.Text);
  if EditZID.Text = '' then
  begin
    EditZID.SetFocus;
    ShowMsg('������ֽ����', sHint); Exit;
  end;

  EditCard.Clear;
  InfoList1.Clear;
  TruckList1.Clear;

  nStr := 'Select Count(*) From %s Where Z_ID=''%s''';
  nStr := Format(nStr, [sTable_ZhiKa, EditZID.Text]);

  with FDM.QueryTemp(nStr) do
  if Fields[0].AsInteger > 0 then
       LoadZhiKaData(EditZID.Text, '')
  else ShowMsg('��Ч��ֽ����', sHint);
end;

//Desc: ѡ���¼
procedure TfFormHYData_Each.TruckList1Click(Sender: TObject);
var nStr: string;
    nIdx: Integer;
begin
  EditStockNo.Clear;
  ParamList1.Clear;

  if TruckList1.ItemIndex > -1 then
  with FTrucks[TruckList1.ItemIndex] do
  begin
    EditStockNo.Text := FStockNo;
    EditStockNo.Properties.ReadOnly := True;

    nStr := '';
    for nIdx:=Low(FLadingID) to High(FLadingID) do
     if nStr = '' then
          nStr := FLadingID[nIdx]
     else nStr := nStr + ',' + FLadingID[nIdx];
    EditLading.Text := nStr;

    LoadStockRecord(FStockNo);
    EditLDate.Date := FLadTime;
  end;
end;

//Desc: ����ˮ����ΪnID�ļ����¼
function TfFormHYData_Each.LoadStockRecord(const nID: string): Boolean;
var nStr: string;
begin
  Result := False;
  ParamList1.Clear;

  nStr := 'Select Top 1 * From %s Where R_serialNo=''%s'' Order By R_ID DESC';
  nStr := Format(nStr, [sTable_StockRecord, nID]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    Result := True;
    First;

    nStr := '����þ' + ParamList1.Delimiter + FieldByName('R_MgO').AsString + ' ';
    ParamList1.Items.Add(nStr);

    nStr := '��������' + ParamList1.Delimiter + FieldByName('R_SO3').AsString + ' ';
    ParamList1.Items.Add(nStr);

    nStr := '��ʧ��' + ParamList1.Delimiter + FieldByName('R_ShaoShi').AsString + ' ';
    ParamList1.Items.Add(nStr);

    nStr := '������' + ParamList1.Delimiter + FieldByName('R_CL').AsString + ' ';
    ParamList1.Items.Add(nStr);

    nStr := 'ϸ��' + ParamList1.Delimiter + FieldByName('R_XiDu').AsString + ' ';
    ParamList1.Items.Add(nStr);

    nStr := '���' + ParamList1.Delimiter + FieldByName('R_ChouDu').AsString + ' ';
    ParamList1.Items.Add(nStr);

    nStr := '���' + ParamList1.Delimiter + FieldByName('R_Jian').AsString + ' ';
    ParamList1.Items.Add(nStr);

    nStr := '������' + ParamList1.Delimiter + FieldByName('R_BuRong').AsString + ' ';
    ParamList1.Items.Add(nStr);
    
    nStr := '�ȱ����' + ParamList1.Delimiter + FieldByName('R_BiBiao').AsString + ' ';
    ParamList1.Items.Add(nStr);

    nStr := '����ʱ��' + ParamList1.Delimiter + FieldByName('R_ChuNing').AsString + ' ';
    ParamList1.Items.Add(nStr);

    nStr := '����ʱ��' + ParamList1.Delimiter + FieldByName('R_ZhongNing').AsString + ' ';
    ParamList1.Items.Add(nStr);

    nStr := '������' + ParamList1.Delimiter + FieldByName('R_AnDing').AsString + ' ';
    ParamList1.Items.Add(nStr);

    nStr := '-' + ParamList1.Delimiter + '-';
    ParamList1.Items.Add(nStr);

    nStr := '����1(3D)' + ParamList1.Delimiter + FieldByName('R_3DZhe1').AsString + ' ';
    ParamList1.Items.Add(nStr);
    nStr := '����2(3D)' + ParamList1.Delimiter + FieldByName('R_3DZhe2').AsString + ' ';
    ParamList1.Items.Add(nStr);
    nStr := '����3(3D)' + ParamList1.Delimiter + FieldByName('R_3DZhe3').AsString + ' ';
    ParamList1.Items.Add(nStr);

    nStr := '-' + ParamList1.Delimiter + '-';
    ParamList1.Items.Add(nStr);
    
    nStr := '����1(28D)' + ParamList1.Delimiter + FieldByName('R_28Zhe1').AsString + ' ';
    ParamList1.Items.Add(nStr);
    nStr := '����2(28D)' + ParamList1.Delimiter + FieldByName('R_28Zhe2').AsString + ' ';
    ParamList1.Items.Add(nStr);
    nStr := '����3(28D)' + ParamList1.Delimiter + FieldByName('R_28Zhe3').AsString + ' ';
    ParamList1.Items.Add(nStr);

    nStr := '-' + ParamList1.Delimiter + '-';
    ParamList1.Items.Add(nStr);

    nStr := '��ѹ1(3D)' + ParamList1.Delimiter + FieldByName('R_3DYa1').AsString + ' ';
    ParamList1.Items.Add(nStr);
    nStr := '��ѹ2(3D)' + ParamList1.Delimiter + FieldByName('R_3DYa2').AsString + ' ';
    ParamList1.Items.Add(nStr);
    nStr := '��ѹ3(3D)' + ParamList1.Delimiter + FieldByName('R_3DYa3').AsString + ' ';
    ParamList1.Items.Add(nStr);
    nStr := '��ѹ4(3D)' + ParamList1.Delimiter + FieldByName('R_3DYa4').AsString + ' ';
    ParamList1.Items.Add(nStr);
    nStr := '��ѹ5(3D)' + ParamList1.Delimiter + FieldByName('R_3DYa5').AsString + ' ';
    ParamList1.Items.Add(nStr);
    nStr := '��ѹ6(3D)' + ParamList1.Delimiter + FieldByName('R_3DYa6').AsString + ' ';
    ParamList1.Items.Add(nStr);

    nStr := '-' + ParamList1.Delimiter + '-';
    ParamList1.Items.Add(nStr);
    
    nStr := '��ѹ1(28D)' + ParamList1.Delimiter + FieldByName('R_28Ya1').AsString + ' ';
    ParamList1.Items.Add(nStr);
    nStr := '��ѹ2(28D)' + ParamList1.Delimiter + FieldByName('R_28Ya2').AsString + ' ';
    ParamList1.Items.Add(nStr);
    nStr := '��ѹ3(28D)' + ParamList1.Delimiter + FieldByName('R_28Ya3').AsString + ' ';
    ParamList1.Items.Add(nStr);
    nStr := '��ѹ4(28D)' + ParamList1.Delimiter + FieldByName('R_28Ya4').AsString + ' ';
    ParamList1.Items.Add(nStr);
    nStr := '��ѹ5(28D)' + ParamList1.Delimiter + FieldByName('R_28Ya5').AsString + ' ';
    ParamList1.Items.Add(nStr);
    nStr := '��ѹ6(28D)' + ParamList1.Delimiter + FieldByName('R_28Ya6').AsString + ' ';
    ParamList1.Items.Add(nStr);
  end;
end;

//Desc: �����Ŀ
procedure TfFormHYData_Each.ParamList1Click(Sender: TObject);
var nStr: string;
    nPos: integer;
begin
  if ParamList1.ItemIndex > -1 then
  begin
    nStr := ParamList1.Items[ParamList1.ItemIndex];
    nPos := Pos(ParamList1.Delimiter, nStr);

    EditItem.Text := Copy(nStr, 1, nPos - 1);
    System.Delete(nStr, 1, nPos);
    EditValue.Text := nStr;
  end;
end;

function TfFormHYData_Each.OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean;
var nStr: string;
begin
  Result := True;

  if Sender = TruckList1 then
  begin
    Result := TruckList1.ItemIndex > -1;
    nHint := '��ѡ���������';
  end else

  if Sender = EditRDate then
  begin
    Result := EditRDate.Date >= EditLDate.Date;
    nHint := '��������Ӧ�����������';
  end else

  if Sender = EditReporter then
  begin
    EditReporter.Text := Trim(EditReporter.Text);
    Result := EditReporter.Text <> '';
    nHint := '����д��Ч�ı�����';
  end else

  if Sender = EditStockNo then
  begin
    nStr := 'Select Count(*) From %s Where R_serialNo=''%s''';
    nStr := Format(nStr, [sTable_StockRecord, EditStockNo.Text]);

    with FDM.QueryTemp(nStr) do
    begin
      Result := (RecordCount > 0) and (Fields[0].AsInteger > 0);
      nHint := '��Ч��ˮ����';
    end;
  end;
end;

//Desc: ����
procedure TfFormHYData_Each.BtnOKClick(Sender: TObject);
var nStr,nID: string;
    nIdx: Integer;
begin
  if not IsDataValid then Exit;

  FDM.ADOConn.BeginTrans;
  with FTrucks[TruckList1.ItemIndex] do
  try
    nStr := 'Insert Into $HY(H_SerialNo,H_Truck,H_Value,H_BillDate,H_EachTruck,' +
            'H_ReportDate,H_Reporter) Values(''$NO'',''$Truck'',$Val,''$BD'',' +
            '''$Yes'',''$RD'',''$RM'')';
    //xxxxx

    nStr := MacroValue(nStr, [MI('$Truck', FTruckNo), MI('$Yes', sFlag_Yes),
            MI('$NO', EditStockNo.Text), MI('$HY', sTable_StockHuaYan),
            MI('$Val', FloatToStr(FStockNum)), MI('$BD', DateTime2Str(EditLDate.Date)),
            MI('$RD', DateTime2Str(EditRDate.Date)), MI('$RM', EditReporter.Text)]);
    //xxxxx

    FDM.ExecuteSQL(nStr);
    nIdx := FDM.GetFieldMax(sTable_StockHuaYan, 'H_ID');
    nID := FDM.GetSerialID2('HY', sTable_StockHuaYan, 'H_ID', 'H_No', nIdx);

    nStr := 'Update %s Set H_No=''%s'' Where H_ID=%d';
    nStr := Format(nStr, [sTable_StockHuaYan, nID, nIdx]);
    FDM.ExecuteSQL(nStr);

    for nIdx:=Low(FTruckEID) to High(FTruckEID) do
    begin
      nStr := 'Update %s Set E_HYNo=''%s'',E_HyID=27 Where E_ID=%s';
      nStr := Format(nStr, [sTable_TruckLogExt, nID, FTruckEID[nIdx]]);
      FDM.ExecuteSQL(nStr);
    end;

    FDM.ADOConn.CommitTrans;
    //xxxxx
  except
    FDM.ADOConn.RollbackTrans;
    ShowMsg('���鵥����ʧ��', sHint); Exit;
  end;

  nStr := Format('''%s''', [nID]);
  PrintHuaYanReport_Each(nStr, True);
  PrintHeGeReport_Each(nStr, True);

  ModalResult := mrOk;
  ShowMsg('���鵥�ѳɹ�����', sHint);   
end;

initialization
  gControlManager.RegCtrl(TfFormHYData_Each, TfFormHYData_Each.FormID);
end.

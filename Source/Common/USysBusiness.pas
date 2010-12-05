{*******************************************************************************
  ����: dmzn@163.com 2010-3-8
  ����: ϵͳҵ����
*******************************************************************************}
unit USysBusiness;

interface

uses
  Windows, Classes, Controls, SysUtils, ULibFun, UAdjustForm, UFormCtrl, DB,
  UDataModule, UDataReport, cxMCListBox, UForminputbox, UFormDateFilter,
  USysConst, USysDB, ZnMD5;

type
  PLadingTruckItem = ^TLadingTruckItem;
  TLadingTruckItem = record
    FRecord: string;         //�����¼
    FBill: string;           //�����
    FTruckID: string;        //����
    FTruckNo: string;        //����
    FZhiKa: string;          //ֽ��
    FSaleMan: string;        //ҵ��Ա
    FSaleName: string;       //����
    FCusID: string;          //�ͻ�
    FCusName: string;        //����
    FCardNo: string;         //�ſ���
    FLading: string;         //�����ʽ
    FStockType: string;      //����
    FStockName: string;      //Ʒ��
    FStockNo: string;        //���
    FPrice: Double;          //����
    FValue: Double;          //�����
    FMoney: Double;          //���ý�
    FZKMoney: Boolean;       //�Ƿ�����
    FSelect: Boolean;        //��ѡ��
    FIsLading: Boolean;      //�����
    FIsCombine: Boolean;     //�ɺϲ�
  end;

  TDynamicTruckArray = array of TLadingTruckItem;
  //�������

//------------------------------------------------------------------------------
function AdjustHintToRead(const nHint: string): string;
//������ʾ����
function IsZhiKaNeedVerify: Boolean;
//ֽ���Ƿ���Ҫ���
function DeleteZhiKa(const nZID: string): Boolean;
//ɾ��ָ��ֽ��
function LoadZhiKaInfo(const nZID: string; const nList: TcxMCListBox;
 var nHint: string): TDataset;
//����ֽ��
function GetValidMoneyByZK(const nZK: string; var nFixed: Boolean): Double;
//��ȡ���ý��

function LoadSysDictItem(const nItem: string; const nList: TStrings): TDataSet;
//��ȡϵͳ�ֵ���
function LoadSaleMan(const nList: TStrings; const nWhere: string = ''): Boolean;
//��ȡҵ��Ա�б�
function LoadCustomer(const nList: TStrings; const nWhere: string = ''): Boolean;
//��ȡ�ͻ��б�
function LoadCustomerInfo(const nCID: string; const nList: TcxMCListBox;
 var nHint: string): TDataSet;
//����ͻ���Ϣ
function GetCustomerValidMoney(const nCID: string;
 const nLimit: Boolean = True): Double;
//�ͻ����ý��
function SaveXuNiCustomer(const nName,nSaleMan: string): string;
//����ʱ�ͻ�

function CardStatusToStr(const nStatus: string): string;
//��״̬ת����
function IsCardCanUsed(const nCID: string; var nHint: string): Boolean;
//���Ƿ����
function IsCardHasTruckIn(const nCID: string): Boolean;
//�����ڳ�����
function IsCardHasBill(const nCID: string): Boolean;
//���������
function ChangeNewCard(const nCID,nNew: string): Boolean;
//�����¿�
function IsCardCanBill(const nCID,nPwd: string; var nHint: string): Boolean;
//���������
function IsCardCanUsing(const nCID: string; var nHint: string;
 const nExtent: Boolean = False): Boolean;
//��������п���

function DeleteBill(const nBill: string; var nHint: string): Boolean;
//ɾ�������
function ChangeLadingTruckNo(const nBill: string; var nHint: string): Boolean;
//�޸���������ƺ�

function IsBangFangAutoP_24H: Boolean;
//�Ƿ��Զ���Ƥ
function AutoBangFangP_24h(const nTruckID,nTruckNo: string): Boolean;
//�Զ���Ƥ��
function GetNetWeight(const nTruckID: string; var nWeight: Double;
 const nIsM: Boolean = True): Double;
//��ȡ����
function MakeTruckBFP(const nTruck: TLadingTruckItem; const nVal: Double): Boolean;
function MakeTruckBFM(const nTruck: TLadingTruckItem; const nVal: Double): Boolean;
//��������
function GetWeightWuCha(var nIsFixed: Boolean): Double; overload;
function GetWeightWuCha(const nValue: Double): Double; overload;
//�������
function SaveSanHKData(const nHKList: TList): Boolean;
//����Ͽ���

function GetNoByStock(const nStock: string): string;
procedure SetStockNo(const nStock,nNo: string);
//����ˮ����
function GetHYMaxValue: Double;
function GetHYValueByStockNo(const nNo: string): Double;
//��ȡ�ѿ���

function TruckStatusToStr(const nStatus: string): string;
//����״̬ת����
function LoadLadingTruckItems(const nCard,nNow,nNext: string;
 var nTruck: TDynamicTruckArray; var nHint: string;
 const nMustBe: Boolean = True): Boolean;
//������������б�
function LoadBillTruckItems(const nCard: string; var nTruck: TDynamicTruckArray;
 var nHint: string; const nTruckNo: string = ''): Boolean;
//����δ��������б�
procedure CopyTruckItem(const nFrom: TLadingTruckItem; var nDest: TLadingTruckItem);
procedure CombinTruckItems(var nFrom,nDest: TDynamicTruckArray);
//�ϲ������б�

function IsTruckAutoIn: Boolean;
//�Ƿ��Զ�����
function IsTruckAutoOut: Boolean;
//�Ƿ��Զ�����
function IsTruckSongHuo(const nTruck: TLadingTruckItem): Boolean;
//�Ƿ��ͻ�
function MakeSongHuoTruckOut(const nTruck: TLadingTruckItem): Boolean;
//���������ͻ�״̬
procedure MakeTrucksIn(const nTrucks: TDynamicTruckArray);
procedure MakeTrucksOut(const nTrucks: TDynamicTruckArray; const nTID: string = '');
//����������
function IsTruckIn(const nTruckNo: string): Boolean;
//�����Ƿ����

function GetJSTunnelCount: Integer;
//��ȡ��Ȩ����
function UpdateJSTunnelCount(const nOld,nNew: string): Boolean;
//������Ȩ����
function GetJiaoBanTime(var nStart,nEnd: TDateTime; nParam: PChar = nil): Boolean;
//����ʱ��
function GetProvideLog(const nID: string; var nInfo: TDynamicStrArray): Integer;
//��ȡ��Ӧ��¼��

//------------------------------------------------------------------------------
function PrintZhiKaReport(const nZID: string; const nAsk: Boolean): Boolean;
//��ӡֽ��
function PrintShouJuReport(const nSID: string; const nAsk: Boolean): Boolean;
//��ӡ�վ�
function PrintBillReport(const nBill: string; const nAsk: Boolean): Boolean;
//��ӡ�����
function PrintBillZhiKaReport(const nBill,nZK: string; const nAsk: Boolean): Boolean;
//��ӡ�������ֽ��
function PrintPoundReport(const nLadID: string; const nAsk: Boolean): Boolean;
//��ӡ����
function PrintProvidePoundReport(const nPID: string; const nAsk: Boolean): Boolean;
//��Ӧ����
function PrintProvideJSReport(const nPID,nFlag: string; const nHJ: Boolean): Boolean;
//��Ӧ���㵥
function PrintHuaYanReport(const nHID: string; const nAsk: Boolean): Boolean;
function PrintHeGeReport(const nHID: string; const nAsk: Boolean): Boolean;
//���鵥,�ϸ�֤

implementation

type
  TStockNo = record
    FStock: string;
    FNo: string;
  end;

var
  gStockNo: array of TStockNo;
  //Ʒ�ֱ��

//Desc: ��ȡnStock��ˮ����
function GetNoByStock(const nStock: string): string;
var nIdx: integer;
begin
  Result := '';
  for nIdx:=Low(gStockNo) to High(gStockNo) do
   if gStockNo[nIdx].FStock = nStock then
    Result := gStockNo[nIdx].FNo;
  //xxxxx
end;

//Desc: ����nStock�ı��ΪnNo
procedure SetStockNo(const nStock,nNo: string);
var nIdx: integer;
begin
  for nIdx:=Low(gStockNo) to High(gStockNo) do
  if gStockNo[nIdx].FStock = nStock then
  begin
    gStockNo[nIdx].FNo := nNo; Exit;
  end;

  nIdx := Length(gStockNo);
  SetLength(gStockNo, nIdx + 1);
    
  gStockNo[nIdx].FStock := nStock;
  gStockNo[nIdx].FNo := nNo;
end;

//Desc: ÿ���������
function GetHYMaxValue: Double;
var nStr: string;
begin
  nStr := 'Select D_Value From %s Where D_Name=''%s'' and D_Memo=''%s''';
  nStr := Format(nStr, [sTable_SysDict, sFlag_SysParam, sFlag_HYValue]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
       Result := Fields[0].AsFloat
  else Result := 0;
end;

//Desc: ��ȡnNoˮ���ŵ��ѿ���
function GetHYValueByStockNo(const nNo: string): Double;
var nStr: string;
begin
  nStr := 'Select R_SerialNo,Sum(H_Value) From %s ' +
          ' Left Join %s on H_SerialNo= R_SerialNo ' +
          'Where R_SerialNo=''%s'' Group By R_SerialNo';
  nStr := Format(nStr, [sTable_StockRecord, sTable_StockHuaYan, nNo]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
       Result := Fields[1].AsFloat
  else Result := -1;
end;

//------------------------------------------------------------------------------
//Desc: ����nHintΪ�׶��ĸ�ʽ
function AdjustHintToRead(const nHint: string): string;
var nIdx: Integer;
    nList: TStrings;
begin
  nList := TStringList.Create;
  try
    nList.Text := nHint;
    for nIdx:=0 to nList.Count - 1 do
      nList[nIdx] := '��.' + nList[nIdx];
    Result := nList.Text;
  finally
    nList.Free;
  end;
end;

//Desc: ֽ���Ƿ���Ҫ���
function IsZhiKaNeedVerify: Boolean;
var nStr: string;
begin
  nStr := 'Select D_Value From $T Where D_Name=''$N'' and D_Memo=''$M''';
  nStr := MacroValue(nStr, [MI('$T', sTable_SysDict), MI('$N', sFlag_SysParam),
                           MI('$M', sFlag_ZhiKaVerify)]);
  //xxxxx

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
       Result := Fields[0].AsString = sFlag_Yes
  else Result := False;
end;

//Desc: ɾ�����ΪnZID��ֽ��
function DeleteZhiKa(const nZID: string): Boolean;
var nStr: string;
    nBool: Boolean;
begin
  nBool := FDM.ADOConn.InTransaction;
  if not nBool then FDM.ADOConn.BeginTrans;
  try
    nStr := 'Delete From %s Where Z_ID=''%s''';
    nStr := Format(nStr, [sTable_ZhiKa, nZID]);
    Result := FDM.ExecuteSQL(nStr) > 0;

    nStr := 'Delete From %s Where D_ZID=''%s''';
    nStr := Format(nStr, [sTable_ZhiKaDtl, nZID]);
    FDM.ExecuteSQL(nStr);

    nStr := 'Update $ZC Set C_Status=''$ZX'' ' +
            'Where C_ZID=''$ZID'' And C_Status=''$Used''';
    nStr := MacroValue(nStr, [MI('$ZC', sTable_ZhiKaCard), MI('$ZID', nZID),
            MI('$ZX', sFlag_CardInvalid), MI('$Used', sFlag_CardUsed)]);
    FDM.ExecuteSQL(nStr);

    nStr := 'Update %s Set M_ZID=M_ZID+''_d'' Where M_ZID=''%s''';
    nStr := Format(nStr, [sTable_InOutMoney, nZID]);
    FDM.ExecuteSQL(nStr);

    if not nBool then
      FDM.ADOConn.CommitTrans;
    //commit if need
  except
    Result := False;
    if not nBool then FDM.ADOConn.RollbackTrans;
  end;
end;

//Desc: ����nZID����Ϣ��nList��,�����ز�ѯ���ݼ�
function LoadZhiKaInfo(const nZID: string; const nList: TcxMCListBox;
 var nHint: string): TDataset;
var nStr: string;
begin
  nStr := 'Select zk.*,sm.S_Name,cus.C_Name From $ZK zk ' +
          ' Left Join $SM sm On sm.S_ID=zk.Z_SaleMan ' +
          ' Left Join $Cus cus On cus.C_ID=zk.Z_Custom ' +
          'Where Z_ID=''$ID''';
  //xxxxx

  nStr := MacroValue(nStr, [MI('$ZK', sTable_ZhiKa),
             MI('$Con', sTable_SaleContract), MI('$SM', sTable_Salesman),
             MI('$Cus', sTable_Customer), MI('$ID', nZID)]);
  //xxxxx

  nList.Clear;
  Result := FDM.QueryTemp(nStr);

  if Result.RecordCount = 1 then
  with nList.Items,Result do
  begin
    Add('ֽ�����:' + nList.Delimiter + FieldByName('Z_ID').AsString);
    Add('ҵ����Ա:' + nList.Delimiter + FieldByName('S_Name').AsString);
    Add('�ͻ�����:' + nList.Delimiter + FieldByName('C_Name').AsString + ' ');
    Add('��Ŀ����:' + nList.Delimiter + FieldByName('Z_Project').AsString + ' ');
    
    nStr := DateTime2Str(FieldByName('Z_Date').AsDateTime);
    Add('�쿨ʱ��:' + nList.Delimiter + nStr);
  end else
  begin
    Result := nil;
    nHint := 'ֽ������Ч';
  end;
end;

//Date: 2010-3-30
//Parm: ֽ����;�Ƿ�̶����ý�
//Desc: ��ȡnZKֽ���ĵ�ǰ���ý��
function GetValidMoneyByZK(const nZK: string; var nFixed: Boolean): Double;
var nStr: string;
    nVal: Double;
begin
  nStr := 'Select ca.*,Z_OnlyMoney,Z_FixedMoney From $ZK,$CA ca ' +
          'Where Z_ID=''$ZID'' and A_CID=Z_Custom';
  nStr := MacroValue(nStr, [MI('$ZK', sTable_ZhiKa), MI('$ZID', nZK),
          MI('$CA', sTable_CusAccount)]);
  //xxxxx

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    nFixed := FieldByName('Z_OnlyMoney').AsString = sFlag_Yes;
    Result := FieldByName('Z_FixedMoney').AsFloat;

    nVal := FieldByName('A_InMoney').AsFloat -
            FieldByName('A_OutMoney').AsFloat -
            FieldByName('A_Compensation').AsFloat -
            FieldByName('A_FreezeMoney').AsFloat +
            FieldByName('A_CreditLimit').AsFloat;
    nVal := Float2PInt(nVal, cPrecision) / cPrecision;

    if nFixed then
    begin
      if Result > nVal then
        Result := nVal;
      //enough money
    end else Result := nVal;
  end else
  begin
    Result := 0;
    nFixed := False;
  end;
end;

//------------------------------------------------------------------------------
//Date: 2010-4-13
//Parm: �ֵ���;�б�
//Desc: ��SysDict�ж�ȡnItem�������,����nList��
function LoadSysDictItem(const nItem: string; const nList: TStrings): TDataSet;
var nStr: string;
begin
  nList.Clear;
  nStr := MacroValue(sQuery_SysDict, [MI('$Table', sTable_SysDict),
                                      MI('$Name', nItem)]);
  Result := FDM.QueryTemp(nStr);

  if Result.RecordCount > 0 then
  with Result do
  begin
    First;

    while not Eof do
    begin
      nList.Add(FieldByName('D_Value').AsString);
      Next;
    end;
  end else Result := nil;
end;

//Desc: ��ȡҵ��Ա�б�nList��,������������
function LoadSaleMan(const nList: TStrings; const nWhere: string = ''): Boolean;
var nStr,nW: string;
begin
  if nWhere = '' then
       nW := ''
  else nW := Format(' And (%s)', [nWhere]);

  nStr := 'S_ID=Select S_ID,S_PY,S_Name From %s ' +
          'Where IsNull(S_InValid, '''')<>''%s'' %s Order By S_PY';
  nStr := Format(nStr, [sTable_Salesman, sFlag_Yes, nW]);

  AdjustStringsItem(nList, True);
  FDM.FillStringsData(nList, nStr, -1, '.', DSA(['S_ID']));
  
  AdjustStringsItem(nList, False);
  Result := nList.Count > 0;
end;

//Desc: ��ȡ�ͻ��б�nList��,������������
function LoadCustomer(const nList: TStrings; const nWhere: string = ''): Boolean;
var nStr,nW: string;
begin
  if nWhere = '' then
       nW := ''
  else nW := Format(' And (%s)', [nWhere]);

  nStr := 'C_ID=Select C_ID,C_Name From %s ' +
          'Where IsNull(C_XuNi, '''')<>''%s'' %s Order By C_PY';
  nStr := Format(nStr, [sTable_Customer, sFlag_Yes, nW]);

  AdjustStringsItem(nList, True);
  FDM.FillStringsData(nList, nStr, -1, '.');

  AdjustStringsItem(nList, False);
  Result := nList.Count > 0;
end;

//Desc: ����nCID�ͻ�����Ϣ��nList��,���������ݼ�
function LoadCustomerInfo(const nCID: string; const nList: TcxMCListBox;
 var nHint: string): TDataSet;
var nStr: string;
begin
  nStr := 'Select cus.*,S_Name as C_SaleName From $Cus cus ' +
          ' Left Join $SM sm On sm.S_ID=cus.C_SaleMan ' +
          'Where C_ID=''$ID''';
  nStr := MacroValue(nStr, [MI('$Cus', sTable_Customer), MI('$ID', nCID),
          MI('$SM', sTable_Salesman)]);
  //xxxxx

  nList.Clear;
  Result := FDM.QueryTemp(nStr);

  if Result.RecordCount > 0 then
  with nList.Items,Result do
  begin
    Add('�ͻ����:' + nList.Delimiter + FieldByName('C_ID').AsString);
    Add('�ͻ�����:' + nList.Delimiter + FieldByName('C_Name').AsString + ' ');
    Add('��ҵ����:' + nList.Delimiter + FieldByName('C_FaRen').AsString + ' ');
    Add('��ϵ��ʽ:' + nList.Delimiter + FieldByName('C_Phone').AsString + ' ');
    Add('����ҵ��Ա:' + nList.Delimiter + FieldByName('C_SaleName').AsString);
  end else
  begin
    Result := nil;
    nHint := '�ͻ���Ϣ�Ѷ�ʧ';
  end;
end;

//Desc: ����nSaleMan���µ�nNameΪ��ʱ�ͻ�,���ؿͻ���
function SaveXuNiCustomer(const nName,nSaleMan: string): string;
var nID: Integer;
    nStr: string;
    nBool: Boolean;
begin
  nStr := 'Select C_ID From %s ' +
          'Where C_XuNi=''%s'' And C_SaleMan=''%s'' And C_Name=''%s''';
  nStr := Format(nStr, [sTable_Customer, sFlag_Yes, nSaleMan, nName]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    Result := Fields[0].AsString;
    Exit;
  end;

  nBool := FDM.ADOConn.InTransaction;
  if not nBool then FDM.ADOConn.BeginTrans;
  try
    nStr := 'Insert Into %s(C_Name,C_PY,C_SaleMan,C_XuNi) ' +
            'Values(''%s'',''%s'',''%s'', ''%s'')';
    nStr := Format(nStr, [sTable_Customer, nName, GetPinYinOfStr(nName),
            nSaleMan, sFlag_Yes]);
    FDM.ExecuteSQL(nStr);

    nID := FDM.GetFieldMax(sTable_Customer, 'R_ID');
    Result := FDM.GetSerialID2('KH', sTable_Customer, 'R_ID', 'C_ID', nID);

    nStr := 'Update %s Set C_ID=''%s'' Where R_ID=%d';
    nStr := Format(nStr, [sTable_Customer, Result, nID]);
    FDM.ExecuteSQL(nStr);

    nStr := 'Insert Into %s(A_CID,A_Date) Values(''%s'', %s)';
    nStr := Format(nStr, [sTable_CusAccount, Result, FDM.SQLServerNow]);
    FDM.ExecuteSQL(nStr);

    if not nBool then
      FDM.ADOConn.CommitTrans;
    //commit if need
  except
    Result := '';
    if not nBool then FDM.ADOConn.RollbackTrans;
  end;
end;

//Desc: ��ȡnCID�û��Ŀ��ý��,�������ö�򾻶�
function GetCustomerValidMoney(const nCID: string; const nLimit: Boolean): Double;
var nStr: string;
    nVal: Double;
begin
  Result := 0;
  nStr := 'Select * From %s Where A_CID=''%s''';
  nStr := Format(nStr, [sTable_CusAccount, nCID]);

  with FDM.QueryTemp(nStr) do
  if RecordCount = 1 then
  begin
    nVal := FieldByName('A_InMoney').AsFloat -
            FieldByName('A_OutMoney').AsFloat -
            FieldByName('A_Compensation').AsFloat -
            FieldByName('A_FreezeMoney').AsFloat;
    //xxxxx

    if nLimit then
      nVal := nVal + FieldByName('A_CreditLimit').AsFloat;
    Result := Float2PInt(nVal, cPrecision) / cPrecision;
  end;
end;

//------------------------------------------------------------------------------
//Desc: ��nStatusתΪ�ɶ�����
function CardStatusToStr(const nStatus: string): string;
begin
  if nStatus = sFlag_CardIdle then Result := '����' else
  if nStatus = sFlag_CardUsed then Result := '����' else
  if nStatus = sFlag_CardLoss then Result := '��ʧ' else
  if nStatus = sFlag_CardInvalid then Result := 'ע��' else Result := 'δ֪';
end;

//Desc: ��֤nCID�Ƿ����ڳ�����
function IsCardHasTruckIn(const nCID: string): Boolean;
var nStr: string;
begin
  nStr := 'Select Count(*) From %s,%s ' +
          'Where E_Card=''%s'' and E_TID=T_ID And T_Status<>''%s''';
  nStr := Format(nStr, [sTable_TruckLog, sTable_TruckLogExt, nCID, sFlag_TruckOut]);
  Result := FDM.QueryTemp(nStr).Fields[0].AsInteger > 0;
end;

//Desc: ��֤nCID�Ƿ����ѿ���δ��������
function IsCardHasBill(const nCID: string): Boolean;
var nStr: string;
begin
  nStr := 'Select Count(*) From %s ' +
          ' Left Join %s On E_Bill=L_ID ' +
          'Where L_Card=''%s'' And E_Bill Is Null';
  nStr := Format(nStr, [sTable_Bill, sTable_TruckLogExt, nCID]);
  Result := FDM.QueryTemp(nStr).Fields[0].AsInteger > 0;
end;

//Desc: ��֤nCID�Ƿ���Ա�ʹ��
function IsCardCanUsed(const nCID: string; var nHint: string): Boolean;
var nStr,nName: string;
begin
  nHint := '';
  Result := True;

  nStr := 'Select zc.*,C_Name From %s zc ' +
          ' Left Join %s cus on cus.C_ID=zc.C_OwnerID ' +
          'Where C_Card=''%s''';
  nStr := Format(nStr, [sTable_ZhiKaCard, sTable_Customer, nCID]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    nStr := FieldByName('C_IsFreeze').AsString;
    if nStr = sFlag_Yes then nHint := '�ÿ��Ѷ���';

    nStr := FieldByName('C_Status').AsString;
    if nStr = sFlag_CardLoss then nHint := '�ÿ��ѹ�ʧ';

    Result := nHint = '';
    if not Result then Exit;
    nName := FieldByName('C_Name').AsString;

    if Result then
    begin
      Result :=  not IsCardHasTruckIn(nCID);
      nHint := '�ÿ���δ��������';
    end;

    if Result then
    begin
      Result := not IsCardHasBill(nCID);
      nHint := '�ÿ��ϻ��������';
    end;

    if Result and (nStr = sFlag_CardUsed) then
    begin
      nStr := Format('�ͻ�[ %s ]����ʹ�øÿ�,�Ƿ���ע��?', [nName]);
      Result := QueryDlg(nStr, sAsk);
      nHint := '�쿨����ȡ��';
    end;
  end else Exit;
end;

//Desc: ��nNew�滻nCID�ɿ�
function ChangeNewCard(const nCID,nNew: string): Boolean;
var nStr: string;
    nBool: Boolean;
begin
  nBool := FDM.ADOConn.InTransaction;
  if not nBool then FDM.ADOConn.BeginTrans;
  try
    nStr := 'Update %s Set C_Card=''%s'' Where C_Card=''%s''';
    nStr := Format(nStr, [sTable_ZhiKaCard, nNew, nCID]);
    FDM.ExecuteSQL(nStr);

    nStr := 'Update %s Set L_Card=''%s'' Where L_Card=''%s''';
    nStr := Format(nStr, [sTable_Bill, nNew, nCID]);
    FDM.ExecuteSQL(nStr);

    nStr := 'Update %s Set E_Card=''%s'' Where E_Card=''%s''';
    nStr := Format(nStr, [sTable_TruckLogExt, nNew, nCID]);
    FDM.ExecuteSQL(nStr);

    Result := True;
    if not nBool then FDM.ADOConn.CommitTrans;
  except
    Result := False;
    if not nBool then FDM.ADOConn.RollbackTrans;
  end;
end;

//Date: 2010-3-15
//Parm: �ſ���;����;��ʾ��Ϣ
//Desc: ��֤nCID�Ƿ�������
function IsCardCanBill(const nCID,nPwd: string; var nHint: string): Boolean;
var nStr: string;
    nDT: TDateTime;
begin
  nHint := '';
  Result := False;
  
  nStr := 'Select *,$Now as S_Now From $ZC zc ' +
          ' Left Join $ZK zk On zk.Z_ID=zc.C_ZID ' +
          'Where C_Card=''$Card''';
  nStr := MacroValue(nStr, [MI('$ZC', sTable_ZhiKaCard), MI('$Card', nCID),
          MI('$ZK', sTable_ZhiKa), MI('$Now', FDM.SQLServerNow)]);
  //xxxxx

  with FDM.QuerySQL(nStr) do
  if RecordCount = 1 then
  begin
    nDT := FieldByName('Z_ValidDays').AsDateTime;
    nDT := nDT - FieldByName('S_Now').AsDateTime;

    if nDT <= 0 then
      nHint := Format('ֽ���ѹ���[ %d ]��.' + #13#10, [Trunc(-nDT)]);
    //xxxxx

    if FieldByName('Z_InValid').AsString = sFlag_Yes then
      nHint := nHint + 'ֽ���ѱ�����Ա����.' + #13#10;
    //xxxxx

    if FieldByName('Z_Verified').AsString <> sFlag_Yes then
      nHint := nHint + 'ֽ����δ���.' + #13#10;
    //xxxxx

    if FieldByName('Z_Freeze').AsString = sFlag_Yes then
      nHint := nHint + 'ֽ���ѱ�����Ա����.' + #13#10;
    //xxxxx

    if FieldByName('Z_OnlyPwd').AsString = sFlag_Yes then
         nStr := FieldByName('Z_Password').AsString
    else nStr := FieldByName('C_Password').AsString;

    if nStr <> nPwd then
      nHint := nHint + '�ſ�����������.' + #13#10;
    //xxxxx

    if FieldByName('C_IsFreeze').AsString = sFlag_Yes then
      nHint := nHint + '�ſ��ѱ�����Ա����.' + #13#10;
    //xxxxx

    nStr := FieldByName('C_Status').AsString;
    if nStr <> sFlag_CardUsed then
    begin
      nStr := CardStatusToStr(nStr);
      nHint := nHint + Format('�ſ�״̬Ϊ[ %s ],�޷����.', [nStr]);
    end;

    if nHint = '' then
    begin
      Result := True;
      nHint := FieldByName('C_ZID').AsString;
    end else nHint := Trim(nHint);
  end else nHint := '�ſ���Ŵ��������Ч.';
end;

//Date: 2010-3-19
//Parm: �ſ���;��ʾ;�Ƿ���֤����
//Desc: ��֤nCID��������Ƿ���Ч
function IsCardCanUsing(const nCID: string; var nHint: string;
 const nExtent: Boolean): Boolean;
var nStr: string;
    nDT: TDateTime;
begin
  nHint := '';
  Result := False;
  
  nStr := 'Select *,$Now as S_Now From $ZC zc ' +
          ' Left Join $ZK zk On zk.Z_ID=zc.C_ZID ' +
          'Where C_Card=''$Card''';
  nStr := MacroValue(nStr, [MI('$ZC', sTable_ZhiKaCard), MI('$Card', nCID),
          MI('$ZK', sTable_ZhiKa), MI('$Now', FDM.SQLServerNow)]);
  //xxxxx

  with FDM.QuerySQL(nStr) do
  if RecordCount = 1 then
  begin
    if FieldByName('C_IsFreeze').AsString = sFlag_Yes then
      nHint := '�ſ��ѱ�����Ա����.' + #13#10;
    //xxxxx

    if not nExtent then
    begin
      nHint := Trim(nHint);
      Result := nHint = '';
      
      if Result then
        nHint := FieldByName('C_ZID').AsString;
      Exit;
    end;

    nDT := FieldByName('Z_ValidDays').AsDateTime;
    nDT := nDT - FieldByName('S_Now').AsDateTime;

    if nDT <= 0 then
      nHint := nHint + Format('ֽ���ѹ���[ %d ]��.' + #13#10, [Trunc(-nDT)]);
    //xxxxx

    if FieldByName('Z_InValid').AsString = sFlag_Yes then
      nHint := nHint + 'ֽ���ѱ�����Ա����.' + #13#10;
    //xxxxx

    if FieldByName('Z_Verified').AsString <> sFlag_Yes then
      nHint := nHint + 'ֽ����δ���.' + #13#10;
    //xxxxx
    
    if FieldByName('Z_Freeze').AsString = sFlag_Yes then
      nHint := nHint + 'ֽ���ѱ�����Ա����.' + #13#10;
    //xxxxx

    nStr := FieldByName('C_Status').AsString;
    if nStr <> sFlag_CardUsed then
    begin
      nStr := CardStatusToStr(nStr);
      nHint := nHint + Format('�ſ�״̬Ϊ[ %s ],�޷����.', [nStr]);
    end;

    if nHint = '' then
    begin
      Result := True;
      nHint := FieldByName('C_ZID').AsString;
    end else nHint := Trim(nHint);
  end else nHint := '�ſ���Ŵ��������Ч.';
end;

//------------------------------------------------------------------------------
//Desc: ɾ�������
function DeleteBill(const nBill: string; var nHint: string): Boolean;
var nMon: Double;
    nBool: Boolean;
    nStr,nCusID,nTID,nZK,nZKMoney: string;
begin
  Result := False;
  nStr := 'Select * From %s Where L_ID=''%s''';
  nStr := Format(nStr, [sTable_Bill, nBill]);

  with FDM.QueryTemp(nStr) do
  if RecordCount < 1 then
  begin
    nHint := '�����������Ч'; Exit;
  end else
  begin
    if FieldByName('L_IsDone').AsString = sFlag_Yes then
    begin
      nHint := '�õ���������'; Exit;
    end;

    nZK := FieldByName('L_ZID').AsString;
    nCusID := FieldByName('L_Custom').AsString;

    nZKMoney := FieldByName('L_ZKMoney').AsString;
    nMon := FieldByName('L_Value').AsFloat * FieldByName('L_Price').AsFloat;
  end;

  nHint := ''; nTID := '';
  nStr := 'Select E_TID From %s Where E_Bill=''%s''';
  nStr := Format(nStr, [sTable_TruckLogExt, nBill]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    nStr := '�����[ %s ]�ĳ����Ѿ�����,��ɾ������ֹ���!!' + #13#10 +
            'ȷ��Ҫɾ����?';
    //xxxxx

    if QueryDlg(Format(nStr, [nBill]), sAsk) then
         nTID := Fields[0].AsString
    else Exit;
  end else
  begin
    nStr := Format('ȷ��Ҫɾ�����Ϊ[ %s ]���������', [nBill]);
    if QueryDlg(nStr, sAsk) then nTID := '' else Exit;
  end;

  nBool := FDM.ADOConn.InTransaction;
  if not nBool then FDM.ADOConn.BeginTrans;
  try
    nStr := 'Delete From %s Where L_ID=''%s''';
    nStr := Format(nStr, [sTable_Bill, nBill]);
    FDM.ExecuteSQL(nStr);

    if nTID <> '' then
    begin
      nStr := 'Delete From $TL Where T_ID=''$ID'' And ' +
              ' (1 = (Select Count(*) From $TE Where E_TID=''$ID''))';
      nStr := MacroValue(nStr, [MI('$TL', sTable_TruckLog),
              MI('$TE', sTable_TruckLogExt), MI('$ID', nTID)]);
      FDM.ExecuteSQL(nStr);

      nStr := 'Delete From %s Where E_Bill=''%s''';
      nStr := Format(nStr, [sTable_TruckLogExt, nBill]);
      FDM.ExecuteSQL(nStr);
    end;

    if nMon > 0 then //�ͷŶ�����
    begin
     nMon := Float2Float(nMon, cPrecision, True);
     //adjust float value

      nStr := 'Update %s Set A_FreezeMoney=A_FreezeMoney-%.2f Where A_CID=''%s''';
      nStr := Format(nStr, [sTable_CusAccount, nMon, nCusID]);
      FDM.ExecuteSQL(nStr);

      if nZKMoney = sFlag_Yes then
      begin
        nStr := 'Update %s Set Z_FixedMoney=Z_FixedMoney+%.2f Where Z_ID=''%s''';
        nStr := Format(nStr, [sTable_ZhiKa, nMon, nZK]);
        FDM.ExecuteSQL(nStr);
      end;
    end; 

    Result := True;
    if not nBool then FDM.ADOConn.CommitTrans;
  except
    nHint := '���ݿ����ʧ��';
    if not nBool then FDM.ADOConn.RollbackTrans;
  end;
end;

//Desc: �޸�nBill������ĳ��ƺ�
function ChangeLadingTruckNo(const nBill: string; var nHint: string): Boolean;
var nStr,nTruck: string;
begin
  nHint := '';
  Result := False;

  nStr := 'Select L_TruckNo,E_Bill From $Bill ' +
          ' Left Join $TE te On te.E_Bill=L_ID ' +
          'Where L_ID=''$ID''';
  nStr := MacroValue(nStr, [MI('$Bill', sTable_Bill),
          MI('$TE', sTable_TruckLogExt), MI('$ID', nBill)]);

  with FDM.QueryTemp(nStr) do
  if RecordCount < 1 then
  begin
    nHint := '��Ч�������'; Exit;
  end else
  begin
    if Fields[1].AsString <> '' then
    begin
      nHint := '������������ѽ���'; Exit;
    end else nTruck := Fields[0].AsString;
  end;

  nStr := nTruck;
  if ShowInputBox('�������µĳ��ƺ���:', '�޸�', nTruck, 15) and
     (nTruck <> '') and (nStr <> nTruck) then
  begin
    nStr := 'Update %s Set L_TruckNo=''%s'' Where L_ID=''%s''';
    nStr := Format(nStr, [sTable_Bill, nTruck, nBill]);
    Result := FDM.ExecuteSQL(nStr) > 0;
  end;
end;

//------------------------------------------------------------------------------
//Date: 2010-3-22
//Parm: �Ƿ�̶�ֵ
//Desc: ��ȡϵͳ�������ķ�ʽ
function GetWeightWuCha(var nIsFixed: Boolean): Double;
var nStr: string;
begin
  nStr := 'Select D_Value,D_ParamA From $T Where D_Name=''$N'' and D_Memo=''$M''';
  nStr := MacroValue(nStr, [MI('$T', sTable_SysDict), MI('$N', sFlag_SysParam),
                           MI('$M', sFlag_WuCha)]);
  //xxxxx

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    Result := Fields[1].AsFloat;
    nIsFixed := Fields[0].AsString = sFlag_Yes;
  end else
  begin
    Result := 0;
    nIsFixed := True;
  end;
end;

//Date: 2010-3-22
//Parm: ����
//Desc: ��ȡnValue�������������
function GetWeightWuCha(const nValue: Double): Double; overload;
var nBool: Boolean;
    nVal: Double;
begin
  nVal := GetWeightWuCha(nBool);
  if nBool then
       Result := nVal
  else Result := nValue * nVal;
end;

//Date: 2010-3-22
//Parm: �������;����;�Ƿ�ë��
//Desc: ��ȡnTruckID��Ӧ�ĳ�����¼�ľ���
function GetNetWeight(const nTruckID: string; var nWeight: Double;
 const nIsM: Boolean): Double;
var nStr: string;
begin
  nStr := 'Select T_BFPValue,T_BFMValue From %s Where T_ID=''%s''';
  nStr := Format(nStr, [sTable_TruckLog, nTruckID]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    if nWeight > 0 then
    begin
      if nIsM then
      begin
        Result := nWeight - Fields[0].AsFloat;
        nWeight := Fields[0].AsFloat;
      end else
      begin  
        Result := Fields[1].AsFloat - nWeight;
        nWeight := Fields[1].AsFloat;
      end;
    end else Result := Fields[1].AsFloat - Fields[0].AsFloat;
  end else Result := 0;
end;

//Date: 2010-4-4
//Parm: �Ͽ����б�
//Desc: ��nList�еĺϿ���������ݿ�
function SaveSanHKData(const nHKList: TList): Boolean;
var nStr: string;
    nVal: Double;
    nBool: Boolean;
    nList: TStrings;
    nIdx,nInt: Integer;
begin
  Result := True;
  if nHKList.Count < 1 then Exit;

  nBool := FDM.ADOConn.InTransaction;
  if not nBool then FDM.ADOConn.BeginTrans;
  nList := TStringList.Create;
  try
    for nIdx:=nHKList.Count - 1 downto 0 do
    with PLadingTruckItem(nHKList[nIdx])^ do
    begin
      nList.Clear;
      nList.Add(Format('L_ZID=''%s''', [FZhiKa]));
      nList.Add(Format('L_Custom=''%s''', [FCusID]));
      nList.Add(Format('L_SaleMan=''%s''', [FSaleMan]));
      nList.Add(Format('L_TruckNo=''%s''', [FTruckNo]));
      nList.Add(Format('L_Type=''%s''', [FStockType]));
      nList.Add(Format('L_Stock=''%s''', [FStockName]));
      nList.Add(Format('L_Value=%.2f', [FValue]));
      nList.Add(Format('L_Price=%.2f', [FPrice]));

      if FZKMoney then
           nStr := sFlag_Yes
      else nStr := sFlag_No;
      nList.Add(Format('L_ZKMoney=''%s''', [nStr]));

      nList.Add(Format('L_Card=''%s''', [FCardNo]));
      nList.Add(Format('L_Lading=''%s''', [FLading]));
      nList.Add(Format('L_Man=''%s''', [gSysParam.FUserID]));
      nList.Add(Format('L_Date=%s', [FDM.SQLServerNow]));

      nStr := MakeSQLByCtrl(nil, sTable_Bill, '', True, nil, nList);
      FDM.ExecuteSQL(nStr);

      nInt := FDM.GetFieldMax(sTable_Bill, 'R_ID');
      FBill := FDM.GetSerialID2('Th', sTable_Bill, 'R_ID', 'L_ID', nInt);

      nStr := 'Update %s Set L_ID=''%s'' Where R_ID=%d';
      nStr := Format(nStr, [sTable_Bill, FBill, nInt]);
      FDM.ExecuteSQL(nStr);

      //------------------------------------------------------------------------
      nVal := Float2Float(FPrice * FValue, cPrecision, True);
      //adjust float value

      nStr := 'Update %s Set A_FreezeMoney=A_FreezeMoney+%.2f ' +
              'Where A_CID=''%s''';
      nStr := Format(nStr, [sTable_CusAccount, nVal, FCusID]);
      FDM.ExecuteSQL(nStr);

      if FZKMoney then
      begin
        nStr := 'Update %s Set Z_FixedMoney=Z_FixedMoney-%.2f ' +
                'Where Z_ID=''%s''';
        nStr := Format(nStr, [sTable_ZhiKa, nVal, FZhiKa]);
        FDM.ExecuteSQL(nStr);
      end;

      //------------------------------------------------------------------------
      nList.Clear;
      nList.Add(Format('E_TID=''%s''', [FTruckID]));
      nList.Add(Format('E_Truck=''%s''', [FTruckNo]));
      nList.Add(Format('E_Card=''%s''', [FCardNo]));
      nList.Add(Format('E_ZID=''%s''', [FZhiKa]));
      nList.Add(Format('E_Bill=''%s''', [FBill]));
      nList.Add(Format('E_Value=%.2f', [FValue]));
      nList.Add(Format('E_Price=%.2f', [FPrice]));
      nList.Add(Format('E_StockNo=''%s''', [FStockNo]));
      nList.Add(Format('E_Used=''%s''', [sFlag_Sale]));
      nList.Add(Format('E_IsHK=''%s''', [sFlag_Yes]));

      nStr := MakeSQLByCtrl(nil, sTable_TruckLogExt, '', True, nil, nList);
      FDM.ExecuteSQL(nStr);
      FRecord := IntToStr(FDM.GetFieldMax(sTable_TruckLogExt, 'E_ID'));
    end;

    if not nBool then
      FDM.ADOConn.CommitTrans;
    //xxxxx
  except
    nList.Free;
    if not nBool then FDM.ADOConn.RollbackTrans; raise;
  end;
end;

//Desc: �Ƿ�24Сʱ�Զ���Ƥ��
function IsBangFangAutoP_24H: Boolean;
var nStr: string;
begin
  nStr := 'Select D_Value From $T Where D_Name=''$N'' and D_Memo=''$M''';
  nStr := MacroValue(nStr, [MI('$T', sTable_SysDict), MI('$N', sFlag_SysParam),
                           MI('$M', sFlag_AutoP24H)]);
  //xxxxx

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
       Result := Fields[0].AsString = sFlag_Yes
  else Result := False;
end;

//Date: 2010-3-19
//Parm: ������¼;���ƺ�
//Desc: ����24Сʱ�Զ���Ƥ��
function AutoBangFangP_24h(const nTruckID,nTruckNo: string): Boolean;
var nSQL: string;
begin
  Result := False;
  nSQL := 'Select T_BFPTime,T_BFPMan,T_BFPValue From %s ' +
          'Where T_Truck=''%s'' And T_BFPTime>=%s Order By T_BFPTime DESC';
  nSQL := Format(nSQL, [sTable_TruckLog, nTruckNo, Date2Str(FDM.ServerNow)]);

  with FDM.QueryTemp(nSQL) do
  if RecordCount > 0 then
  begin
    nSQL := 'Update $TL Set T_BFPTime=''$Time'',T_BFPValue=$Value,' +
            'T_BFPMan=''$Man'',T_Status=''$BFP'',T_NextStatus=''$ZT'' '+
            'Where T_ID=''$ID''';
    nSQL := MacroValue(nSQL, [MI('$TL', sTable_TruckLog),
            MI('$Time', FDM.SQLServerNow),
            MI('$Value', FieldByName('T_BFPValue').AsString),
            MI('$Man', FieldByName('T_BFPMan').AsString),
            MI('$BFP', sFlag_TruckBFP), MI('$ZT', sFlag_TruckZT),
            MI('$ID', nTruckID)]);
    Result := FDM.ExecuteSQL(nSQL) > 0;
  end;
end;

//Desc: nTruck�ĳ���Ƥ��ΪnVal��
function MakeTruckBFP(const nTruck: TLadingTruckItem; const nVal: Double): Boolean;
var nStr,nNext: string;
begin
  if IsTruckSongHuo(nTruck) then
  begin
    nNext := sFlag_TruckOut;
  end else
  begin
    if nTruck.FStockType = sFlag_San then
         nNext := sFlag_TruckFH
    else nNext := sFlag_TruckZT;

    nStr := 'Select D_ParamB From $Dict Where D_Name=''$Stock'' and ' +
            'D_Value=''$Name'' and D_Memo=''$Type''';
    nStr := MacroValue(nStr, [MI('$Dict', sTable_SysDict),
            MI('$Stock', sFlag_StockItem), MI('$Name', nTruck.FStockName),
            MI('$Type', nTruck.FStockType)]);
    //xxxxx

    with FDM.QueryTemp(nStr) do
    if RecordCount > 0 then
    begin
      nStr := FieldByName('D_ParamB').AsString;
      if Pos('+NF', nStr) > 0 then
        nNext := sFlag_TruckBFM;
      //not fanghui
    end;
  end;

  nStr := 'Update $TL Set T_Status=''$ST'',T_NextStatus=''$NT'',T_BFPTime=$BT,' +
          'T_BFPMan=''$BM'',T_BFPValue=$Val Where T_ID=''$TID''';
  nStr := MacroValue(nStr, [MI('$TL', sTable_TruckLog),
          MI('$BT', FDM.SQLServerNow), MI('$BM', gSysParam.FUserID),
          MI('$Val', FloatToStr(nVal)), MI('$TID', nTruck.FTruckID),
          MI('$ST', sFlag_TruckBFP), MI('$NT', nNext)]);
  Result := FDM.ExecuteSQL(nStr) > 0;
end;

//Desc: nTruck�ĳ���ë��ΪnVal��
function MakeTruckBFM(const nTruck: TLadingTruckItem; const nVal: Double): Boolean;
var nStr: string;
begin
  nStr := 'Update $TL Set T_BFMTime=$BT,T_BFMMan=''$BM'',T_BFMValue=$Val,' +
          'T_Status=''$ST'',T_NextStatus=''$NT'' Where T_ID=''$ID''';
  nStr := MacroValue(nStr, [MI('$TL', sTable_TruckLog),
          MI('$BT', FDM.SQLServerNow), MI('$BM', gSysParam.FUserID),
          MI('$Val', FloatToStr(nVal)), MI('$ID', nTruck.FTruckID),
          MI('$ST', sFlag_TruckBFM), MI('$NT', sFlag_TruckOut)]);
  Result := FDM.ExecuteSQL(nStr) > 0;
end;

//------------------------------------------------------------------------------
//Desc: ��nStatusתΪ��ʶ�������
function TruckStatusToStr(const nStatus: string): string;
begin
  if nStatus = sFlag_TruckIn then Result := '�ѽ���' else
  if nStatus = sFlag_TruckOut then Result := '�ѳ���' else
  if nStatus = sFlag_TruckBFP then Result := '��Ƥ��' else
  if nStatus = sFlag_TruckBFM then Result := '��ë��' else
  if nStatus = sFlag_TruckSH then Result := '�ͻ���' else
  if nStatus = sFlag_TruckFH then Result := '�ŻҴ�' else
  if nStatus = sFlag_TruckZT then Result := 'ջ̨' else Result := 'δ����';
end;

//Date: 2010-3-20
//Parm: �ſ�;��ǰ,��һ״̬;��ѯ���;��ʾ����;�ϸ��ѯ
//Desc: ��ѯnCard��ָ��״̬�ĳ���,����nTruck�б�
function LoadLadingTruckItems(const nCard,nNow,nNext: string;
 var nTruck: TDynamicTruckArray; var nHint: string;
 const nMustBe: Boolean = True): Boolean;
var nStr: string;
    nIdx: Integer;
    nBool: Boolean;
begin
  nStr := 'Select b.*,E_ID,E_TID,E_Card,T_Status,T_NextStatus From $TE te ' +
          ' Left Join $TL tl on tl.T_ID=te.E_TID ' +
          ' Left Join $Bill b on b.L_ID=te.E_Bill ' +
          'Where E_Card=''$Card'' and T_Status<>''$Out'' ' +
          ' Order By L_TruckNo,L_ID';
  nStr := MacroValue(nStr, [MI('$TE', sTable_TruckLogExt),
          MI('$TL', sTable_TruckLog), MI('$Bill', sTable_Bill),
          MI('$Card', nCard), MI('$Out', sFlag_TruckOut)]);
  //xxxxx

  nHint := '';
  SetLength(nTruck, 0);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    First;

    while not Eof do
    try
      if nMustBe then
           nBool := (FieldByName('T_Status').AsString <> nNow) or
                    (FieldByName('T_NextStatus').AsString <> nNext)
      else nBool := not ((FieldByName('T_Status').AsString = nNow) or
                    (FieldByName('T_NextStatus').AsString = nNext));
      //�ϸ��ѯʱ,����״̬����ͬʱ����.

      if nBool then
      begin
        nStr := '����:[ %-8s ] ״̬:[ %-6s -> %-6s ]';
        nStr := Format(nStr, [FieldByName('L_TruckNo').AsString,
                TruckStatusToStr(FieldByName('T_Status').AsString),
                TruckStatusToStr(FieldByName('T_NextStatus').AsString)]);
        //xxxxx

        if nHint = '' then
             nHint := nStr
        else nHint := nHint + #13#10 + nStr; Continue;
      end;

      nIdx := Length(nTruck);
      SetLength(nTruck, nIdx + 1);
      with nTruck[nIdx] do
      begin
        FRecord := FieldByName('E_ID').AsString;
        FCardNo := FieldByName('E_Card').AsString;

        FBill := FieldByName('L_ID').AsString;
        FZhiKa := FieldByName('L_ZID').AsString;
        FCusID := FieldByName('L_Custom').AsString;
        FSaleMan := FieldByName('L_SaleMan').AsString;
        FLading := FieldByName('L_Lading').AsString;

        FTruckID := FieldByName('E_TID').AsString;
        FTruckNo := FieldByName('L_TruckNo').AsString;
        FStockType := FieldByName('L_Type').AsString;
        FStockName := FieldByName('L_Stock').AsString;
        FStockNo := GetNoByStock(FStockName); 
        
        FValue := FieldByName('L_Value').AsFloat;
        FPrice := FieldByName('L_Price').AsFloat;
        
        FSelect := True;
        FIsLading := True;
        FIsCombine := True;
      end;
    finally
      Next;
    end;
  end;

  if Length(nTruck) < 1 then
  begin 
    if nHint = '' then
      nHint := 'û���ѽ������������';
    Result := False;
  end else Result := True;
end;

//Date: 2010-3-21
//Parm: �ſ���;��ѯ���;��ʾ����;���˳���
//Desc: ��ѯnCard��δ��������ĳ���;����nTruck��
function LoadBillTruckItems(const nCard: string; var nTruck: TDynamicTruckArray;
 var nHint: string; const nTruckNo: string = ''): Boolean;
var nStr: string;
    nIdx: Integer;
begin
  nStr := 'Select b.* From $Bill b ' +
          ' Left Join $TE te on te.E_Bill=b.L_ID ' +
          'Where L_Card=''$Card'' and (E_Bill Is Null)';
  //xxxxx

  if nTruckNo <> '' then
    nStr := nStr + ' and L_TruckNo=''$TN''';
  nStr := nStr + ' Order By L_TruckNo,L_ID';

  nStr := MacroValue(nStr, [MI('$TE', sTable_TruckLogExt), MI('$TN', nTruckNo),
          MI('$Bill', sTable_Bill), MI('$Card', nCard)]);
  //xxxxx

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    SetLength(nTruck, RecordCount);
    nIdx := 0;
    First;

    while not Eof do
    with nTruck[nIdx] do
    begin
      FBill := FieldByName('L_ID').AsString;
      FZhiKa := FieldByName('L_ZID').AsString;
      FSaleMan := FieldByName('L_SaleMan').AsString;
      FCusID := FieldByName('L_Custom').AsString;
      FLading := FieldByName('L_Lading').AsString;
      FTruckNo := FieldByName('L_TruckNo').AsString;  

      FStockType := FieldByName('L_Type').AsString;
      FStockName := FieldByName('L_Stock').AsString;
      FStockNo := GetNoByStock(FStockName);
      FCardNo := FieldByName('L_Card').AsString;

      FValue := FieldByName('L_Value').AsFloat;
      FPrice := FieldByName('L_Price').AsFloat;

      FSelect := True;
      FIsLading := False;
      FIsCombine := True;

      Inc(nIdx);
      Next;
    end;

    nHint := '';
    Result := True;
  end else
  begin
    Result := False;
    SetLength(nTruck, 0);
    nHint := 'û�иÿ���Ӧ�������';
  end;
end;

//Date: 2010-3-21
//Parm: Դ;Ŀ��
//Desc: ��nFrom���Ƶ�nDest��
procedure CopyTruckItem(const nFrom: TLadingTruckItem; var nDest: TLadingTruckItem);
begin
  with nFrom do
  begin
    nDest.FRecord    := FRecord;
    nDest.FBill      := FBill;
    nDest.FTruckID   := FTruckID;  
    nDest.FTruckNo   := FTruckNo;  
    nDest.FZhiKa     := FZhiKa;    
    nDest.FSaleMan   := FSaleMan;  
    nDest.FSaleName  := FSaleName; 
    nDest.FCusID     := FCusID;    
    nDest.FCusName   := FCusName;  
    nDest.FCardNo    := FCardNo;   
    nDest.FLading    := FLading;   
    nDest.FStockType := FStockType;
    nDest.FStockName := FStockName;
    nDest.FStockNo   := FStockNo;  
    nDest.FPrice     := FPrice;    
    nDest.FValue     := FValue;    
    nDest.FMoney     := FMoney;    
    nDest.FZKMoney   := FZKMoney;  
    nDest.FSelect    := FSelect;   
    nDest.FIsLading  := FIsLading; 
    nDest.FIsCombine := FIsCombine;
  end;
end;

//Date: 2010-3-21
//Parm: Դ;Ŀ��
//Desc: ��nFrom�ϲ���nDest��
procedure CombinTruckItems(var nFrom,nDest: TDynamicTruckArray);
var i,nIdx: Integer;
begin
  for i:=Low(nFrom) to High(nFrom) do
  if nFrom[i].FIsCombine then
  begin
    nIdx := Length(nDest);
    SetLength(nDest, nIdx + 1);
    CopyTruckItem(nFrom[i], nDest[nIdx]);
  end;
end;

//------------------------------------------------------------------------------
//Desc: �����Ƿ���Ҫ������ˢ��
function IsTruckAutoIn: Boolean;
var nStr: string;
begin
  nStr := 'Select D_Value From $T Where D_Name=''$N'' and D_Memo=''$M''';
  nStr := MacroValue(nStr, [MI('$T', sTable_SysDict), MI('$N', sFlag_SysParam),
                           MI('$M', sFlag_AutoIn)]);
  //xxxxx

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
       Result := Fields[0].AsString = sFlag_Yes
  else Result := False;
end;

//Desc: �����Ƿ��Զ�����
function IsTruckAutoOut: Boolean;
var nStr: string;
begin
  nStr := 'Select D_Value From $T Where D_Name=''$N'' and D_Memo=''$M''';
  nStr := MacroValue(nStr, [MI('$T', sTable_SysDict), MI('$N', sFlag_SysParam),
                           MI('$M', sFlag_AutoOut)]);
  //xxxxx

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
       Result := Fields[0].AsString = sFlag_Yes
  else Result := False;
end;

//Desc: �ж�nTruck�Ƿ��ͻ�����
function IsTruckSongHuo(const nTruck: TLadingTruckItem): Boolean;
begin
  Result := (nTruck.FStockType = sFlag_San) and (nTruck.FLading <> sFlag_TiHuo);
end;

//Desc: �ж�nTruck�Ƿ��ڳ���
function IsTruckIn(const nTruckNo: string): Boolean;
var nStr: string;
begin
  nStr := 'Select Count(*) From %s ' +
          'Where T_Truck=''%s'' and T_Status<>''%s''';
  nStr := Format(nStr, [sTable_TruckLog,nTruckNo, sFlag_TruckOut]);
  Result := FDM.QueryTemp(nStr).Fields[0].AsInteger > 0;
end;

//Desc: ��nTrucks��ѡ�еĳ���ִ�н�������
procedure MakeTrucksIn(const nTrucks: TDynamicTruckArray);
var nList: TStrings;
    i,nIdx,nInt: Integer;
    nBool,nAutoP: Boolean;
    nStr,nTID,nSQL,nIsHK: string;
begin
  nBool := FDM.ADOConn.InTransaction;
  if not nBool then FDM.ADOConn.BeginTrans;
  nList := TStringList.Create;
  try
    for nIdx:=Low(nTrucks) to High(nTrucks) do
     with nTrucks[nIdx] do
      if FSelect and (nList.IndexOf(FTruckNo) < 0) then
       if FStockType = sFlag_Dai then
            nList.AddObject(FTruckNo, TObject(27))
       else nList.AddObject(FTruckNo, TObject(0));
    //�����������б�

    nAutoP := IsBangFangAutoP_24H;
    //�Զ�Ƥ��

    for i:=nList.Count - 1 downto 0 do
    begin
      nSQL := 'Insert Into $TL(T_Truck,T_Status,T_NextStatus,T_InTime,' +
              'T_InMan) Values(''$TN'',''$ST'',''$NT'',$IT,''$IM'')';
      nSQL := MacroValue(nSQL, [MI('$TL', sTable_TruckLog),
              MI('$TN', nList[i]), MI('$ST', sFlag_TruckIn),
              MI('$NT', sFlag_TruckBFP), MI('$IT', FDM.SQLServerNow),
              MI('$IM', gSysParam.FUserID)]);
      FDM.ExecuteSQL(nSQL);

      nInt := FDM.GetFieldMax(sTable_TruckLog, 'R_ID');
      nTID := FDM.GetSerialID2('', sTable_TruckLog, 'R_ID', 'T_ID', nInt);

      nSQL := 'Update %s Set T_ID=''%s'' Where R_ID=%d';
      nSQL := Format(nSQL, [sTable_TruckLog, nTID, nInt]);
      FDM.ExecuteSQL(nSQL);

      if (Integer(nList.Objects[i]) = 27) and nAutoP then
        AutoBangFangP_24h(nTID, nList[i]);
      //�����Զ�Ƥ��
                        
      nStr := 'Insert Into $TE(E_TID,E_Truck,E_Card,E_ZID,E_Bill,E_Price,' +
              'E_Value,E_StockNo,E_Used,E_IsHK) Values(''$TID'',''$TN'','+
              '''$Card'',''$ZID'',''$Bill'',$Price,$Val,''$No'',''$Used'',''$HK'')';
      nStr := MacroValue(nStr, [MI('$TE', sTable_TruckLogExt), MI('$TID', nTID),
              MI('$TN', nList[i]), MI('$Used', sFlag_Sale)]);
      //xxxxx

      nIsHK := sFlag_No;
      for nIdx:=Low(nTrucks) to High(nTrucks) do
      with nTrucks[nIdx] do
      begin
        if FSelect and (CompareText(nList[i], FTruckNo) = 0) then
             FTruckID := nTID
        else Continue;

        nSQL := MacroValue(nStr, [MI('$Bill', FBill), MI('$HK', nIsHK),
                MI('$Card', FCardNo), MI('$Price', FloatToStr(FPrice)),
                MI('$ZID', FZhiKa), MI('$Val',FloatToStr(FValue)),
                MI('$No', FStockNo)]);
        //xxxxxx
        
        FDM.ExecuteSQL(nSQL);
        nIsHK := sFlag_Yes;
      end;
    end;

    if not nBool then
      FDM.ADOConn.CommitTrans;
    FreeAndNil(nList);
  except
    nList.Free;
    if not nBool then
      FDM.ADOConn.RollbackTrans;
    raise;
  end;
end;

//Date: 2010-4-19
//Parm: �����б�;������¼
//Desc: ��nTrucks��ѡ�е�,���߳�����¼ΪnTID�ĳ���ִ�г�������
procedure MakeTrucksOut(const nTrucks: TDynamicTruckArray; const nTID: string);
var nStr: string;
    nVal: Double;
    nBool: Boolean;
    nList: TStrings;
    i,nIdx: Integer;
begin
  nBool := FDM.ADOConn.InTransaction;
  if not nBool then FDM.ADOConn.BeginTrans;
  nList := TStringList.Create;
  try
    if nTID = '' then
    begin
      for nIdx:=Low(nTrucks) to High(nTrucks) do
       with nTrucks[nIdx] do
        if FSelect and (nList.IndexOf(FTruckID) < 0) then nList.Add(FTruckID);
    end else nList.Add(nTID);

    for i:=nList.Count - 1 downto 0 do
    begin
      nStr := 'Update $TL Set T_OutTime=$OT,T_OutMan=''$OM'',T_Status=''$ST'',' +
              'T_NextStatus='''' Where T_ID=''$ID''';
      nStr := MacroValue(nStr, [MI('$TL', sTable_TruckLog),
              MI('$OT', FDM.SQLServerNow), MI('$OM', gSysParam.FUserID),
              MI('$ST', sFlag_TruckOut), MI('$ID', nList[i])]);
      FDM.ExecuteSQL(nStr);

      for nIdx:=Low(nTrucks) to High(nTrucks) do
      with nTrucks[nIdx] do
      begin
        if CompareText(FTruckID, nList[i]) <> 0 then Continue;
        //������¼��ƥ��

        nStr := 'Update %s Set L_Card='''',L_IsDone=''%s'',L_OKDate=%s ' +
                'Where L_ID=''%s''';
        nStr := Format(nStr, [sTable_Bill, sFlag_Yes, FDM.SQLServerNow, FBill]);
        FDM.ExecuteSQL(nStr);

        nStr := 'Update %s Set E_Card='''' Where E_ID=%s';
        nStr := Format(nStr, [sTable_TruckLogExt, FRecord]);
        FDM.ExecuteSQL(nStr);

        nVal := Float2Float(FPrice * FValue, cPrecision, True);
        //������
        nStr := 'Update %s Set A_OutMoney=A_OutMoney+%.2f,A_FreezeMoney=' +
                'A_FreezeMoney-%.2f Where A_CID=''%s''';
        nStr := Format(nStr, [sTable_CusAccount, nVal, nVal, FCusID]);
        FDM.ExecuteSQL(nStr);
      end;
    end;

    if not nBool then
      FDM.ADOConn.CommitTrans;
    FreeAndNil(nList);
  except
    nList.Free;
    if not nBool then
      FDM.ADOConn.RollbackTrans;
    raise;
  end;
end;

//Desc: ���ͻ�����nTruckִ�г�������
function MakeSongHuoTruckOut(const nTruck: TLadingTruckItem): Boolean;
var nStr: string;
begin
  nStr := 'Update $TL Set T_OutTime=$OT,T_OutMan=''$OM'',T_Status=''$ST'',' +
          'T_NextStatus=''$NT'' Where T_ID=''$ID''';
  nStr := MacroValue(nStr, [MI('$TL', sTable_TruckLog),
          MI('$OT', FDM.SQLServerNow), MI('$OM', gSysParam.FUserID),
          MI('$ID', nTruck.FTruckID), MI('$ST', sFlag_TruckSH),
          MI('$NT', sFlag_TruckBFP)]);
  Result := FDM.ExecuteSQL(nStr) > 0;
end;

//------------------------------------------------------------------------------
//Date: 2010-11-24
//Desc: ��ȡ��Ȩ�ļ�����ͨ������
function GetJSTunnelCount: Integer;
var nStr: string;
begin
  Result := 1;
  nStr := 'Select D_Value,D_ParamB From %s Where D_Name=''%s'' and D_Memo=''%s''';
  nStr := Format(nStr, [sTable_SysDict, sFlag_SysParam, sFlag_Tunnels]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    nStr := gSysParam.FHintText + '_' + Fields[0].AsString;
    nStr := MD5Print(MD5String(nStr));

    if (nStr = Fields[1].AsString) and IsNumber(Fields[0].AsString, False) then
      Result := Fields[0].AsInteger;
    //xxxxx
  end;
end;

//Date: 2010-11-24
//Parm: ��˾������;������
//Desc: ���µ�ǰ��˾�ĵ�����Ȩ
function UpdateJSTunnelCount(const nOld,nNew: string): Boolean;
var nStr: string;
begin
  Result := False;
  nStr := 'Select D_Value,D_ParamB From %s Where D_Name=''%s'' and D_Memo=''%s''';
  nStr := Format(nStr, [sTable_SysDict, sFlag_SysParam, sFlag_Tunnels]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    nStr := nOld + '_' + Fields[0].AsString;
    nStr := MD5Print(MD5String(nStr));
    if nStr <> Fields[1].AsString then Exit;

    nStr := nNew + '_' + Fields[0].AsString;
    nStr := MD5Print(MD5String(nStr));

    nStr := Format('Update %s Set D_ParamB=''%s'' Where D_Name=''%s'' and ' +
            'D_Memo=''%s''', [sTable_SysDict, nStr, sFlag_SysParam, sFlag_Tunnels]);
    Result := FDM.ExecuteSQL(nStr) > 0;
  end;  
end;

//Date: 2010-11-5
//Parm: ��ʼʱ��;����ʱ��;�������
//Desc: ���ݷ�����ʱ��,�����ǰ�Ľ��Ӱ�ʱ������
function GetJiaoBanTime(var nStart,nEnd: TDateTime; nParam: PChar = nil): Boolean;
var nS,nE: TDate;
    nStr,nDate,nTime,nJB: string;
begin
  nStr := 'Select D_Value,%s From %s Where D_Name=''%s'' and D_Memo=''%s''';
  nStr := Format(nStr, [FDM.SQLServerNow, sTable_SysDict, sFlag_SysParam,
          sFlag_JBTime]);
  //xxxxx

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    nJB := Fields[0].AsString;
    nDate := Date2Str(Fields[1].AsDateTime);
    nTime := Time2Str(Fields[1].AsDateTime);
    //����������,ʱ��,����ʱ��

    if StrToTime(nTime) >= StrToTime(nJB) then //��һ��������
    begin
      nStr := nDate + ' ' + nJB;
      nStart := StrToDateTime(nStr);
      nEnd := nStart + 1;
    end else                                   //��һ��������
    begin
      nStr := nDate + ' ' + nJB;
      nEnd := StrToDateTime(nStr);
      nStart := nEnd - 1;
    end;

    nS := nStart;
    nE := nEnd;
    Result := ShowDateFilterForm(nS, nE, True);

    if Result then
    begin
      nStart := nS; nEnd := nE;
    end else Exit;

    //--------------------------------------------------------------------------
    if not Assigned(nParam) then Exit;
    nStr := 'Select D_Value From %s Where D_Name=''%s'' and D_Memo=''%s''';
    nStr := Format(nStr, [sTable_SysDict, sFlag_SysParam, sFlag_JBParam]);

    with FDM.QueryTemp(nStr) do
    if RecordCount > 0 then
    begin
      nStr := Fields[0].AsString;
      StrPCopy(nParam, nStr);
    end;
  end else Result := False;
end;

//Desc: ����nID�����ݷ��ع�Ӧ��¼���
function GetProvideLog(const nID: string; var nInfo: TDynamicStrArray): Integer;
var nStr,nTmp: string;
begin
  Result := -1;
  if Trim(nID) = '' then Exit;

  if Pos('+', nID) = 1 then
  begin
    nTmp := nID;
    System.Delete(nTmp, 1, 1);
    if not IsNumber(nTmp, False) then Exit;

    nStr := 'Select Count(*) from %s Where L_ID=%s';
    nStr := Format(nStr, [sTable_ProvideLog, nTmp]);

    if FDM.QueryTemp(nStr).Fields[0].AsInteger = 1 then
    begin
      Result := StrToInt(nTmp); Exit;
    end;
  end;

  nStr := 'Select Top 1 * From %s ' +
          'Where L_Card=''%s'' or L_Truck Like ''%%%s%%'' Order By L_ID DESC';
  nStr := Format(nStr, [sTable_ProvideLog, nID, nID]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    if FieldByName('L_PValue').AsFloat > 0 then Exit;
    //��Ƥ��Ч

    SetLength(nInfo, 5);
    nInfo[0] := FieldByName('L_Truck').AsString;
    nInfo[1] := FieldByName('L_Provider').AsString;
    nInfo[2] := FieldByName('L_Mate').AsString;
    nInfo[3] := FieldByName('L_PaiNum').AsString;
    nInfo[4] := FieldByName('L_PaiTime').AsString;
    Result := FieldByName('L_ID').AsInteger;
  end;
end;

//------------------------------------------------------------------------------
//Desc: ��ӡֽ��
function PrintZhiKaReport(const nZID: string; const nAsk: Boolean): Boolean;
begin
  Result := True;
end;

//Desc: ��ӡ�վ�
function PrintShouJuReport(const nSID: string; const nAsk: Boolean): Boolean;
var nStr: string;
begin
  Result := False;

  if nAsk then
  begin
    nStr := '�Ƿ�Ҫ��ӡ�վ�?';
    if not QueryDlg(nStr, sAsk) then Exit;
  end;

  nStr := 'Select * From %s Where R_ID=%s';
  nStr := Format(nStr, [sTable_SysShouJu, nSID]);
  
  if FDM.QueryTemp(nStr).RecordCount < 1 then
  begin
    nStr := 'ƾ����Ϊ[ %s ] ���վ�����Ч!!';
    nStr := Format(nStr, [nSID]);
    ShowMsg(nStr, sHint); Exit;
  end;

  nStr := gPath + sReportDir + 'ShouJu.fr3';
  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '�޷���ȷ���ر����ļ�';
    ShowMsg(nStr, sHint); Exit;
  end;

  FDR.Dataset1.DataSet := FDM.SqlTemp;
  FDR.ShowReport;
  Result := FDR.PrintSuccess;
end;

//Desc: ��ӡ�����
function PrintBillReport(const nBill: string; const nAsk: Boolean): Boolean;
var nStr: string;
    nParam: TReportParamItem;
begin
  Result := False;

  if nAsk then
  begin
    nStr := '�Ƿ�Ҫ��ӡ�����?';
    if not QueryDlg(nStr, sAsk) then Exit;
  end;

  nStr := 'Select Z_ID,Z_Project,S_Name,C_Name From $ZK zk ' +
          ' Left Join $SM sm On sm.S_ID=zk.Z_SaleMan ' +
          ' Left Join $Cus cus on cus.C_ID=zk.Z_Custom';
  //ֽ��

  nStr := 'Select * From $Bill b ' +
          ' Left Join (' + nStr + ') t On t.Z_ID=b.L_ZID ' +
          'Where R_ID In($ID)';
  //�����

  nStr := MacroValue(nStr, [MI('$SM', sTable_Salesman), MI('$ID', nBill),
          MI('$ZK', sTable_ZhiKa), MI('$Bill', sTable_Bill),
          MI('$Cus', sTable_Customer)]);
  //xxxxx

  if FDM.QueryTemp(nStr).RecordCount < 1 then
  begin
    nStr := '���Ϊ[ %s ] �ļ�¼����Ч!!';
    nStr := Format(nStr, [nBill]);
    ShowMsg(nStr, sHint); Exit;
  end;

  nStr := gPath + sReportDir + 'LadingBill.fr3';
  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '�޷���ȷ���ر����ļ�';
    ShowMsg(nStr, sHint); Exit;
  end;

  nParam.FName := 'UserName';
  nParam.FValue := gSysParam.FUserID;
  FDR.AddParamItem(nParam);

  FDR.Dataset1.DataSet := FDM.SqlTemp;
  FDR.ShowReport;
  Result := FDR.PrintSuccess;
end;

//Desc: ��ӡ�������ֽ��
function PrintBillZhiKaReport(const nBill,nZK: string; const nAsk: Boolean): Boolean;
begin
  Result := True;
end;

//Desc: ��ӡnLadID�����¼�Ĺ���
function PrintPoundReport(const nLadID: string; const nAsk: Boolean): Boolean;
var nStr,nZK,nHK: string;
begin
  if nAsk then
  begin
    Result := True;
    nStr := '�Ƿ�Ҫ��ӡ����?';
    if not QueryDlg(nStr, sAsk) then Exit;
  end else Result := False;

  nStr := 'Select Z_ID,Z_Project,S_Name,C_Name From $ZK zk ' +
          ' Left Join $SM sm On sm.S_ID=zk.Z_SaleMan' +
          ' Left Join $Cus cus On cus.C_ID=zk.Z_Custom';
  nZK := MacroValue(nStr, [MI('$ZK', sTable_ZhiKa),
         MI('$SM', sTable_Salesman), MI('$Cus', sTable_Customer)]);
  //ֽ��

  nHK := 'Select E_TID,Sum(E_Value) as E_HKValue From $TE te ' +
         'Where E_IsHK=''$Yes'' Group By E_TID';
  //xxxxx

  nStr := 'Select *,T_Value=(Case ' +
          ' When E_IsHK=''$Yes'' then E_Value ' +
          ' else T_BFMValue-T_BFPValue-IsNull(E_HKValue,0) end) From $TE te ' +
          ' Left Join $TL tl On tl.T_ID=te.E_TID ' +
          ' Left Join $Bill b On b.L_ID=te.E_Bill ' +
          ' Left Join ($ZK) zk On zk.Z_ID=te.E_ZID ' +
          ' Left Join ($HK) hk On hk.E_TID=te.E_TID ' +
          'Where te.E_ID In($ID)';
  //xxxxx

  nStr := MacroValue(nStr, [MI('$HK', nHK)]);
  nStr := MacroValue(nStr, [MI('$TE', sTable_TruckLogExt), MI('$ID', nLadID),
          MI('$TL', sTable_TruckLog), MI('$ZK', nZK), MI('$Bill', sTable_Bill),
          MI('$Yes', sFlag_Yes)]);
  //xxxxx

  if FDM.QueryTemp(nStr).RecordCount < 1 then
  begin
    nStr := '���Ϊ[ %s ] �ļ�¼����Ч!!';
    nStr := Format(nStr, [nLadID]);
    ShowDlg(nStr, sHint); Exit;
  end;

  nStr := gPath + sReportDir + 'Pound.fr3';
  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '�޷���ȷ���ر����ļ�';
    ShowMsg(nStr, sHint); Exit;
  end;

  FDR.Dataset1.DataSet := FDM.SqlTemp;
  FDR.ShowReport;
  Result := FDR.PrintSuccess;
end;

//Desc: ��Ӧ����
function PrintProvidePoundReport(const nPID: string; const nAsk: Boolean): Boolean;
var nStr: string;
begin
  if nAsk then
  begin
    Result := True;
    nStr := '�Ƿ�Ҫ��ӡ����?';
    if not QueryDlg(nStr, sAsk) then Exit;
  end else Result := False;

  nStr := 'Select * From %s Where L_ID=%s';
  nStr := Format(nStr, [sTable_ProvideLog, nPID]);

  if FDM.QueryTemp(nStr).RecordCount < 1 then
  begin
    nStr := '���Ϊ[ %s ] �ļ�¼����Ч!!';
    nStr := Format(nStr, [nPID]);
    ShowDlg(nStr, sHint); Exit;
  end;

  nStr := gPath + sReportDir + 'PPound.fr3';
  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '�޷���ȷ���ر����ļ�';
    ShowMsg(nStr, sHint); Exit;
  end;

  FDR.Dataset1.DataSet := FDM.SqlTemp;
  Result := FDR.PrintReport;
  //Result := FDR.PrintSuccess;

  if Result then
  begin
    nStr := 'Update %s Set L_PrintNum=L_PrintNum+1 Where L_ID=%s';
    nStr := Format(nStr, [sTable_ProvideLog, nPID]);
    FDM.ExecuteSQL(nStr);
  end;
end;

//Date: 2010-10-23
//Parm: ��Ӧ���;����������;����(P,��Ӧ;T,����;A,ȫ��);�Ƿ�ѯ��;�ϼƽ���
//Desc: ��ӡ��Ӧ���㵥
function DoProvideJSReport(const nPID,nFlag,nType: string; const nHJ: Boolean): Boolean;
var nStr: string;
    nParam: TReportParamItem;
begin
  Result := False;  
  if nFlag = '' then
  begin
    nStr := 'Select * From %s Where L_ID=%s';
    nStr := Format(nStr, [sTable_ProvideLog, nPID]);
  end else
  begin
    if nHJ then
    begin
      nStr := 'Select L_Flag as L_ID,'''' as L_PaiNum,L_Mate,L_JSer,L_JSDate,' +
              'L_JProvider as L_Provider, L_JTruck as L_Truck,' +
              'Sum(L_PValue) as L_PValue,Sum(L_MValue) as L_MValue,' +
              'Sum(L_YValue) as L_YValue,Sum(L_Money) as L_Money,' +
              'Sum(L_YunFei) as L_YunFei From $PL Where L_Flag=''$Flag'' ' +
              'Group By L_Mate,L_JProvider,L_JTruck,L_Flag,L_JSer,L_JSDate';
      nStr := MacroValue(nStr, [MI('$PL', sTable_ProvideLog), MI('$Flag', nFlag)]);
    end else
    begin
      nStr := 'Select * From %s Where L_Flag=''%s''';
      nStr := Format(nStr, [sTable_ProvideLog, nFlag]);
    end;
  end;

  if FDM.QueryTemp(nStr).RecordCount < 1 then
  begin
    nStr := 'δ�ҵ����������Ľ�������,��¼����Ч!!';
    ShowDlg(nStr, sHint); Exit;
  end;

  nStr := gPath + sReportDir + 'ProvideJS.fr3';
  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '�޷���ȷ���ر����ļ�';
    ShowMsg(nStr, sHint); Exit;
  end;

  FDR.ClearParamItems;
  nParam.FName := 'ReportType';
  nParam.FValue := nType;
  FDR.AddParamItem(nParam);

  FDR.Dataset1.DataSet := FDM.SqlTemp;
  FDR.ShowReport;
  Result := FDR.PrintSuccess;
end;

//Date: 2010-10-23
//Parm: ��Ӧ���;����������;�ϼƽ���
//Desc: ��Ӧ���㵥
function PrintProvideJSReport(const nPID,nFlag: string; const nHJ: Boolean): Boolean;
begin
  Result := False;
  if QueryDlg('�Ƿ��ӡ��Ӧ�̽��㵥?', sAsk) then
    Result := DoProvideJSReport(nPID, nFlag, 'P', nHJ);
  if QueryDlg('�Ƿ��ӡ�������㵥?', sAsk) then
    Result := DoProvideJSReport(nPID, nFlag, 'T', nHJ);
end;

//Desc: ��ӡ��ʶΪnHID�Ļ��鵥
function PrintHuaYanReport(const nHID: string; const nAsk: Boolean): Boolean;
var nStr,nSR: string;
begin
  if nAsk then
  begin
    Result := True;
    nStr := '�Ƿ�Ҫ��ӡ���鵥?';
    if not QueryDlg(nStr, sAsk) then Exit;
  end else Result := False;

  nSR := 'Select * From %s sr ' +
         ' Left Join %s sp on sp.P_ID=sr.R_PID';
  nSR := Format(nSR, [sTable_StockRecord, sTable_StockParam]);

  nStr := 'Select hy.*,sr.*,C_Name From $HY hy ' +
          ' Left Join $Cus cus on cus.C_ID=hy.H_Custom' +
          ' Left Join ($SR) sr on sr.R_SerialNo=H_SerialNo ' +
          'Where H_ID in ($ID)';
  //xxxxx

  nStr := MacroValue(nStr, [MI('$HY', sTable_StockHuaYan),
          MI('$Cus', sTable_Customer), MI('$SR', nSR), MI('$ID', nHID)]);
  //xxxxx

  if FDM.QueryTemp(nStr).RecordCount < 1 then
  begin
    nStr := '���Ϊ[ %s ] �Ļ��鵥��¼����Ч!!';
    nStr := Format(nStr, [nHID]);
    ShowMsg(nStr, sHint); Exit;
  end;

  nStr := FDM.SqlTemp.FieldByName('P_Stock').AsString;
  if Pos('�ͼ�', nStr) > 0 then
    nStr := gPath + sReportDir + 'HuaYan42_DJ.fr3'
  else if Pos('32', nStr) > 0 then
    nStr := gPath + sReportDir + 'HuaYan32.fr3'
  else if Pos('42', nStr) > 0 then
    nStr := gPath + sReportDir + 'HuaYan42.fr3'
  else if Pos('52', nStr) > 0 then
    nStr := gPath + sReportDir + 'HuaYan42.fr3'
  else nStr := '';

  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '�޷���ȷ���ر����ļ�';
    ShowMsg(nStr, sHint); Exit;
  end;

  FDR.Dataset1.DataSet := FDM.SqlTemp;
  FDR.ShowReport;
  Result := FDR.PrintSuccess;
end;

//Desc: ��ӡ��ʶΪnID�ĺϸ�֤
function PrintHeGeReport(const nHID: string; const nAsk: Boolean): Boolean;
var nStr,nSR: string;
begin
  if nAsk then
  begin
    Result := True;
    nStr := '�Ƿ�Ҫ��ӡ�ϸ�֤?';
    if not QueryDlg(nStr, sAsk) then Exit;
  end else Result := False;

  nSR := 'Select R_SerialNo,P_Stock,P_Name,P_QLevel From %s sr ' +
         ' Left Join %s sp on sp.P_ID=sr.R_PID';
  nSR := Format(nSR, [sTable_StockRecord, sTable_StockParam]);

  nStr := 'Select hy.*,sr.*,C_Name From $HY hy ' +
          ' Left Join $Cus cus on cus.C_ID=hy.H_Custom' +
          ' Left Join ($SR) sr on sr.R_SerialNo=H_SerialNo ' +
          'Where H_ID in ($ID)';
  //xxxxx

  nStr := MacroValue(nStr, [MI('$HY', sTable_StockHuaYan),
          MI('$Cus', sTable_Customer), MI('$SR', nSR), MI('$ID', nHID)]);
  //xxxxx

  if FDM.QueryTemp(nStr).RecordCount < 1 then
  begin
    nStr := '���Ϊ[ %s ] �Ļ��鵥��¼����Ч!!';
    nStr := Format(nStr, [nHID]);
    ShowMsg(nStr, sHint); Exit;
  end;

  nStr := gPath + sReportDir + 'HeGeZheng.fr3';
  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '�޷���ȷ���ر����ļ�';
    ShowMsg(nStr, sHint); Exit;
  end;

  FDR.Dataset1.DataSet := FDM.SqlTemp;
  FDR.ShowReport;
  Result := FDR.PrintSuccess;
end;

end.

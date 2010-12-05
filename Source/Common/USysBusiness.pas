{*******************************************************************************
  作者: dmzn@163.com 2010-3-8
  描述: 系统业务处理
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
    FRecord: string;         //提货记录
    FBill: string;           //提货单
    FTruckID: string;        //车辆
    FTruckNo: string;        //车牌
    FZhiKa: string;          //纸卡
    FSaleMan: string;        //业务员
    FSaleName: string;       //名称
    FCusID: string;          //客户
    FCusName: string;        //名称
    FCardNo: string;         //磁卡号
    FLading: string;         //提货方式
    FStockType: string;      //类型
    FStockName: string;      //品种
    FStockNo: string;        //编号
    FPrice: Double;          //单价
    FValue: Double;          //提货量
    FMoney: Double;          //可用金
    FZKMoney: Boolean;       //是否限提
    FSelect: Boolean;        //被选中
    FIsLading: Boolean;      //提货中
    FIsCombine: Boolean;     //可合并
  end;

  TDynamicTruckArray = array of TLadingTruckItem;
  //提货车辆

//------------------------------------------------------------------------------
function AdjustHintToRead(const nHint: string): string;
//调整提示内容
function IsZhiKaNeedVerify: Boolean;
//纸卡是否需要审核
function DeleteZhiKa(const nZID: string): Boolean;
//删除指定纸卡
function LoadZhiKaInfo(const nZID: string; const nList: TcxMCListBox;
 var nHint: string): TDataset;
//载入纸卡
function GetValidMoneyByZK(const nZK: string; var nFixed: Boolean): Double;
//获取可用金额

function LoadSysDictItem(const nItem: string; const nList: TStrings): TDataSet;
//读取系统字典项
function LoadSaleMan(const nList: TStrings; const nWhere: string = ''): Boolean;
//读取业务员列表
function LoadCustomer(const nList: TStrings; const nWhere: string = ''): Boolean;
//读取客户列表
function LoadCustomerInfo(const nCID: string; const nList: TcxMCListBox;
 var nHint: string): TDataSet;
//载入客户信息
function GetCustomerValidMoney(const nCID: string;
 const nLimit: Boolean = True): Double;
//客户可用金额
function SaveXuNiCustomer(const nName,nSaleMan: string): string;
//存临时客户

function CardStatusToStr(const nStatus: string): string;
//卡状态转内容
function IsCardCanUsed(const nCID: string; var nHint: string): Boolean;
//卡是否可用
function IsCardHasTruckIn(const nCID: string): Boolean;
//卡有在厂车辆
function IsCardHasBill(const nCID: string): Boolean;
//卡有提货单
function ChangeNewCard(const nCID,nNew: string): Boolean;
//补办新卡
function IsCardCanBill(const nCID,nPwd: string; var nHint: string): Boolean;
//卡可以提货
function IsCardCanUsing(const nCID: string; var nHint: string;
 const nExtent: Boolean = False): Boolean;
//卡在提货中可用

function DeleteBill(const nBill: string; var nHint: string): Boolean;
//删除提货单
function ChangeLadingTruckNo(const nBill: string; var nHint: string): Boolean;
//修改提货单车牌号

function IsBangFangAutoP_24H: Boolean;
//是否自动过皮
function AutoBangFangP_24h(const nTruckID,nTruckNo: string): Boolean;
//自动称皮重
function GetNetWeight(const nTruckID: string; var nWeight: Double;
 const nIsM: Boolean = True): Double;
//获取净重
function MakeTruckBFP(const nTruck: TLadingTruckItem; const nVal: Double): Boolean;
function MakeTruckBFM(const nTruck: TLadingTruckItem; const nVal: Double): Boolean;
//车辆称重
function GetWeightWuCha(var nIsFixed: Boolean): Double; overload;
function GetWeightWuCha(const nValue: Double): Double; overload;
//净重误差
function SaveSanHKData(const nHKList: TList): Boolean;
//保存合卡项

function GetNoByStock(const nStock: string): string;
procedure SetStockNo(const nStock,nNo: string);
//记忆水泥编号
function GetHYMaxValue: Double;
function GetHYValueByStockNo(const nNo: string): Double;
//获取已开量

function TruckStatusToStr(const nStatus: string): string;
//车辆状态转内容
function LoadLadingTruckItems(const nCard,nNow,nNext: string;
 var nTruck: TDynamicTruckArray; var nHint: string;
 const nMustBe: Boolean = True): Boolean;
//载入提货车辆列表
function LoadBillTruckItems(const nCard: string; var nTruck: TDynamicTruckArray;
 var nHint: string; const nTruckNo: string = ''): Boolean;
//载入未提货车辆列表
procedure CopyTruckItem(const nFrom: TLadingTruckItem; var nDest: TLadingTruckItem);
procedure CombinTruckItems(var nFrom,nDest: TDynamicTruckArray);
//合并车辆列表

function IsTruckAutoIn: Boolean;
//是否自动进厂
function IsTruckAutoOut: Boolean;
//是否自动出厂
function IsTruckSongHuo(const nTruck: TLadingTruckItem): Boolean;
//是否送货
function MakeSongHuoTruckOut(const nTruck: TLadingTruckItem): Boolean;
//车辆置于送货状态
procedure MakeTrucksIn(const nTrucks: TDynamicTruckArray);
procedure MakeTrucksOut(const nTrucks: TDynamicTruckArray; const nTID: string = '');
//车辆进出厂
function IsTruckIn(const nTruckNo: string): Boolean;
//车辆是否进厂

function GetJSTunnelCount: Integer;
//获取授权道数
function UpdateJSTunnelCount(const nOld,nNew: string): Boolean;
//更新授权道数
function GetJiaoBanTime(var nStart,nEnd: TDateTime; nParam: PChar = nil): Boolean;
//交班时间
function GetProvideLog(const nID: string; var nInfo: TDynamicStrArray): Integer;
//获取供应记录号

//------------------------------------------------------------------------------
function PrintZhiKaReport(const nZID: string; const nAsk: Boolean): Boolean;
//打印纸卡
function PrintShouJuReport(const nSID: string; const nAsk: Boolean): Boolean;
//打印收据
function PrintBillReport(const nBill: string; const nAsk: Boolean): Boolean;
//打印提货单
function PrintBillZhiKaReport(const nBill,nZK: string; const nAsk: Boolean): Boolean;
//打印提货单到纸卡
function PrintPoundReport(const nLadID: string; const nAsk: Boolean): Boolean;
//打印过榜单
function PrintProvidePoundReport(const nPID: string; const nAsk: Boolean): Boolean;
//供应过榜单
function PrintProvideJSReport(const nPID,nFlag: string; const nHJ: Boolean): Boolean;
//供应结算单
function PrintHuaYanReport(const nHID: string; const nAsk: Boolean): Boolean;
function PrintHeGeReport(const nHID: string; const nAsk: Boolean): Boolean;
//化验单,合格证

implementation

type
  TStockNo = record
    FStock: string;
    FNo: string;
  end;

var
  gStockNo: array of TStockNo;
  //品种编号

//Desc: 获取nStock的水泥编号
function GetNoByStock(const nStock: string): string;
var nIdx: integer;
begin
  Result := '';
  for nIdx:=Low(gStockNo) to High(gStockNo) do
   if gStockNo[nIdx].FStock = nStock then
    Result := gStockNo[nIdx].FNo;
  //xxxxx
end;

//Desc: 设置nStock的编号为nNo
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

//Desc: 每批次最大量
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

//Desc: 获取nNo水泥编号的已开量
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
//Desc: 调整nHint为易读的格式
function AdjustHintToRead(const nHint: string): string;
var nIdx: Integer;
    nList: TStrings;
begin
  nList := TStringList.Create;
  try
    nList.Text := nHint;
    for nIdx:=0 to nList.Count - 1 do
      nList[nIdx] := '※.' + nList[nIdx];
    Result := nList.Text;
  finally
    nList.Free;
  end;
end;

//Desc: 纸卡是否需要审核
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

//Desc: 删除编号为nZID的纸卡
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

//Desc: 载入nZID的信息到nList中,并返回查询数据集
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
    Add('纸卡编号:' + nList.Delimiter + FieldByName('Z_ID').AsString);
    Add('业务人员:' + nList.Delimiter + FieldByName('S_Name').AsString);
    Add('客户名称:' + nList.Delimiter + FieldByName('C_Name').AsString + ' ');
    Add('项目名称:' + nList.Delimiter + FieldByName('Z_Project').AsString + ' ');
    
    nStr := DateTime2Str(FieldByName('Z_Date').AsDateTime);
    Add('办卡时间:' + nList.Delimiter + nStr);
  end else
  begin
    Result := nil;
    nHint := '纸卡已无效';
  end;
end;

//Date: 2010-3-30
//Parm: 纸卡号;是否固定可用金
//Desc: 获取nZK纸卡的当前可用金额
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
//Parm: 字典项;列表
//Desc: 从SysDict中读取nItem项的内容,存入nList中
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

//Desc: 读取业务员列表到nList中,包含附加数据
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

//Desc: 读取客户列表到nList中,包含附加数据
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

//Desc: 载入nCID客户的信息到nList中,并返回数据集
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
    Add('客户编号:' + nList.Delimiter + FieldByName('C_ID').AsString);
    Add('客户名称:' + nList.Delimiter + FieldByName('C_Name').AsString + ' ');
    Add('企业法人:' + nList.Delimiter + FieldByName('C_FaRen').AsString + ' ');
    Add('联系方式:' + nList.Delimiter + FieldByName('C_Phone').AsString + ' ');
    Add('所属业务员:' + nList.Delimiter + FieldByName('C_SaleName').AsString);
  end else
  begin
    Result := nil;
    nHint := '客户信息已丢失';
  end;
end;

//Desc: 保存nSaleMan名下的nName为临时客户,返回客户号
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

//Desc: 获取nCID用户的可用金额,包含信用额或净额
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
//Desc: 将nStatus转为可读内容
function CardStatusToStr(const nStatus: string): string;
begin
  if nStatus = sFlag_CardIdle then Result := '空闲' else
  if nStatus = sFlag_CardUsed then Result := '正常' else
  if nStatus = sFlag_CardLoss then Result := '挂失' else
  if nStatus = sFlag_CardInvalid then Result := '注销' else Result := '未知';
end;

//Desc: 验证nCID是否有在厂车辆
function IsCardHasTruckIn(const nCID: string): Boolean;
var nStr: string;
begin
  nStr := 'Select Count(*) From %s,%s ' +
          'Where E_Card=''%s'' and E_TID=T_ID And T_Status<>''%s''';
  nStr := Format(nStr, [sTable_TruckLog, sTable_TruckLogExt, nCID, sFlag_TruckOut]);
  Result := FDM.QueryTemp(nStr).Fields[0].AsInteger > 0;
end;

//Desc: 验证nCID是否有已开但未提的提货单
function IsCardHasBill(const nCID: string): Boolean;
var nStr: string;
begin
  nStr := 'Select Count(*) From %s ' +
          ' Left Join %s On E_Bill=L_ID ' +
          'Where L_Card=''%s'' And E_Bill Is Null';
  nStr := Format(nStr, [sTable_Bill, sTable_TruckLogExt, nCID]);
  Result := FDM.QueryTemp(nStr).Fields[0].AsInteger > 0;
end;

//Desc: 验证nCID是否可以被使用
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
    if nStr = sFlag_Yes then nHint := '该卡已冻结';

    nStr := FieldByName('C_Status').AsString;
    if nStr = sFlag_CardLoss then nHint := '该卡已挂失';

    Result := nHint = '';
    if not Result then Exit;
    nName := FieldByName('C_Name').AsString;

    if Result then
    begin
      Result :=  not IsCardHasTruckIn(nCID);
      nHint := '该卡有未出厂车辆';
    end;

    if Result then
    begin
      Result := not IsCardHasBill(nCID);
      nHint := '该卡上还有提货单';
    end;

    if Result and (nStr = sFlag_CardUsed) then
    begin
      nStr := Format('客户[ %s ]正在使用该卡,是否将其注销?', [nName]);
      Result := QueryDlg(nStr, sAsk);
      nHint := '办卡操作取消';
    end;
  end else Exit;
end;

//Desc: 用nNew替换nCID旧卡
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
//Parm: 磁卡号;密码;提示信息
//Desc: 验证nCID是否可以提货
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
      nHint := Format('纸卡已过期[ %d ]天.' + #13#10, [Trunc(-nDT)]);
    //xxxxx

    if FieldByName('Z_InValid').AsString = sFlag_Yes then
      nHint := nHint + '纸卡已被管理员作废.' + #13#10;
    //xxxxx

    if FieldByName('Z_Verified').AsString <> sFlag_Yes then
      nHint := nHint + '纸卡还未审核.' + #13#10;
    //xxxxx

    if FieldByName('Z_Freeze').AsString = sFlag_Yes then
      nHint := nHint + '纸卡已被管理员冻结.' + #13#10;
    //xxxxx

    if FieldByName('Z_OnlyPwd').AsString = sFlag_Yes then
         nStr := FieldByName('Z_Password').AsString
    else nStr := FieldByName('C_Password').AsString;

    if nStr <> nPwd then
      nHint := nHint + '磁卡提货密码错误.' + #13#10;
    //xxxxx

    if FieldByName('C_IsFreeze').AsString = sFlag_Yes then
      nHint := nHint + '磁卡已被管理员冻结.' + #13#10;
    //xxxxx

    nStr := FieldByName('C_Status').AsString;
    if nStr <> sFlag_CardUsed then
    begin
      nStr := CardStatusToStr(nStr);
      nHint := nHint + Format('磁卡状态为[ %s ],无法提货.', [nStr]);
    end;

    if nHint = '' then
    begin
      Result := True;
      nHint := FieldByName('C_ZID').AsString;
    end else nHint := Trim(nHint);
  end else nHint := '磁卡编号错误或已无效.';
end;

//Date: 2010-3-19
//Parm: 磁卡号;提示;是否验证其它
//Desc: 验证nCID在提货中是否有效
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
      nHint := '磁卡已被管理员冻结.' + #13#10;
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
      nHint := nHint + Format('纸卡已过期[ %d ]天.' + #13#10, [Trunc(-nDT)]);
    //xxxxx

    if FieldByName('Z_InValid').AsString = sFlag_Yes then
      nHint := nHint + '纸卡已被管理员作废.' + #13#10;
    //xxxxx

    if FieldByName('Z_Verified').AsString <> sFlag_Yes then
      nHint := nHint + '纸卡还未审核.' + #13#10;
    //xxxxx
    
    if FieldByName('Z_Freeze').AsString = sFlag_Yes then
      nHint := nHint + '纸卡已被管理员冻结.' + #13#10;
    //xxxxx

    nStr := FieldByName('C_Status').AsString;
    if nStr <> sFlag_CardUsed then
    begin
      nStr := CardStatusToStr(nStr);
      nHint := nHint + Format('磁卡状态为[ %s ],无法提货.', [nStr]);
    end;

    if nHint = '' then
    begin
      Result := True;
      nHint := FieldByName('C_ZID').AsString;
    end else nHint := Trim(nHint);
  end else nHint := '磁卡编号错误或已无效.';
end;

//------------------------------------------------------------------------------
//Desc: 删除提货单
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
    nHint := '该提货单已无效'; Exit;
  end else
  begin
    if FieldByName('L_IsDone').AsString = sFlag_Yes then
    begin
      nHint := '该单已完成提货'; Exit;
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
    nStr := '提货单[ %s ]的车辆已经进厂,若删除会终止提货!!' + #13#10 +
            '确定要删除吗?';
    //xxxxx

    if QueryDlg(Format(nStr, [nBill]), sAsk) then
         nTID := Fields[0].AsString
    else Exit;
  end else
  begin
    nStr := Format('确定要删除编号为[ %s ]的提货单吗', [nBill]);
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

    if nMon > 0 then //释放冻结金额
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
    nHint := '数据库操作失败';
    if not nBool then FDM.ADOConn.RollbackTrans;
  end;
end;

//Desc: 修改nBill提货单的车牌号
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
    nHint := '无效的提货单'; Exit;
  end else
  begin
    if Fields[1].AsString <> '' then
    begin
      nHint := '该提货单车辆已进厂'; Exit;
    end else nTruck := Fields[0].AsString;
  end;

  nStr := nTruck;
  if ShowInputBox('请输入新的车牌号码:', '修改', nTruck, 15) and
     (nTruck <> '') and (nStr <> nTruck) then
  begin
    nStr := 'Update %s Set L_TruckNo=''%s'' Where L_ID=''%s''';
    nStr := Format(nStr, [sTable_Bill, nTruck, nBill]);
    Result := FDM.ExecuteSQL(nStr) > 0;
  end;
end;

//------------------------------------------------------------------------------
//Date: 2010-3-22
//Parm: 是否固定值
//Desc: 获取系统计算误差的方式
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
//Parm: 重量
//Desc: 获取nValue所允许的误差公斤数
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
//Parm: 车辆标记;重量;是否毛重
//Desc: 获取nTruckID对应的车辆记录的净重
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
//Parm: 合卡项列表
//Desc: 将nList中的合卡项存入数据库
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

//Desc: 是否24小时自动过皮重
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
//Parm: 车辆记录;车牌号
//Desc: 袋灰24小时自动称皮重
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

//Desc: nTruck的车辆皮重为nVal吨
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

//Desc: nTruck的车辆毛重为nVal吨
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
//Desc: 将nStatus转为可识别的内容
function TruckStatusToStr(const nStatus: string): string;
begin
  if nStatus = sFlag_TruckIn then Result := '已进厂' else
  if nStatus = sFlag_TruckOut then Result := '已出厂' else
  if nStatus = sFlag_TruckBFP then Result := '称皮重' else
  if nStatus = sFlag_TruckBFM then Result := '称毛重' else
  if nStatus = sFlag_TruckSH then Result := '送货中' else
  if nStatus = sFlag_TruckFH then Result := '放灰处' else
  if nStatus = sFlag_TruckZT then Result := '栈台' else Result := '未进厂';
end;

//Date: 2010-3-20
//Parm: 磁卡;当前,下一状态;查询结果;提示内容;严格查询
//Desc: 查询nCard中指定状态的车辆,存入nTruck列表
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
      //严格查询时,两种状态必须同时满足.

      if nBool then
      begin
        nStr := '车牌:[ %-8s ] 状态:[ %-6s -> %-6s ]';
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
      nHint := '没有已进厂的提货车辆';
    Result := False;
  end else Result := True;
end;

//Date: 2010-3-21
//Parm: 磁卡号;查询结果;提示内容;过滤车牌
//Desc: 查询nCard中未进厂提货的车辆;存入nTruck中
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
    nHint := '没有该卡对应的提货单';
  end;
end;

//Date: 2010-3-21
//Parm: 源;目标
//Desc: 将nFrom复制到nDest中
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
//Parm: 源;目标
//Desc: 将nFrom合并到nDest中
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
//Desc: 车辆是否需要在门卫刷卡
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

//Desc: 车辆是否自动出厂
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

//Desc: 判断nTruck是否送货车辆
function IsTruckSongHuo(const nTruck: TLadingTruckItem): Boolean;
begin
  Result := (nTruck.FStockType = sFlag_San) and (nTruck.FLading <> sFlag_TiHuo);
end;

//Desc: 判定nTruck是否在厂内
function IsTruckIn(const nTruckNo: string): Boolean;
var nStr: string;
begin
  nStr := 'Select Count(*) From %s ' +
          'Where T_Truck=''%s'' and T_Status<>''%s''';
  nStr := Format(nStr, [sTable_TruckLog,nTruckNo, sFlag_TruckOut]);
  Result := FDM.QueryTemp(nStr).Fields[0].AsInteger > 0;
end;

//Desc: 对nTrucks中选中的车辆执行进厂操作
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
    //待进厂车牌列表

    nAutoP := IsBangFangAutoP_24H;
    //自动皮重

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
      //袋灰自动皮重
                        
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
//Parm: 车辆列表;车辆记录
//Desc: 对nTrucks中选中的,或者车辆记录为nTID的车辆执行出厂操作
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
        //车辆记录不匹配

        nStr := 'Update %s Set L_Card='''',L_IsDone=''%s'',L_OKDate=%s ' +
                'Where L_ID=''%s''';
        nStr := Format(nStr, [sTable_Bill, sFlag_Yes, FDM.SQLServerNow, FBill]);
        FDM.ExecuteSQL(nStr);

        nStr := 'Update %s Set E_Card='''' Where E_ID=%s';
        nStr := Format(nStr, [sTable_TruckLogExt, FRecord]);
        FDM.ExecuteSQL(nStr);

        nVal := Float2Float(FPrice * FValue, cPrecision, True);
        //提货金额
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

//Desc: 对送货车辆nTruck执行出厂操作
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
//Desc: 获取授权的计数器通道数量
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
//Parm: 公司旧名称;新名称
//Desc: 更新当前公司的道数授权
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
//Parm: 开始时间;结束时间;交班参数
//Desc: 依据服务器时间,算出当前的交接班时间区间
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
    //服务器日期,时间,交班时间

    if StrToTime(nTime) >= StrToTime(nJB) then //下一交班周期
    begin
      nStr := nDate + ' ' + nJB;
      nStart := StrToDateTime(nStr);
      nEnd := nStart + 1;
    end else                                   //上一交班周期
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

//Desc: 依据nID的内容返回供应记录编号
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
    //除皮无效

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
//Desc: 打印纸卡
function PrintZhiKaReport(const nZID: string; const nAsk: Boolean): Boolean;
begin
  Result := True;
end;

//Desc: 打印收据
function PrintShouJuReport(const nSID: string; const nAsk: Boolean): Boolean;
var nStr: string;
begin
  Result := False;

  if nAsk then
  begin
    nStr := '是否要打印收据?';
    if not QueryDlg(nStr, sAsk) then Exit;
  end;

  nStr := 'Select * From %s Where R_ID=%s';
  nStr := Format(nStr, [sTable_SysShouJu, nSID]);
  
  if FDM.QueryTemp(nStr).RecordCount < 1 then
  begin
    nStr := '凭单号为[ %s ] 的收据已无效!!';
    nStr := Format(nStr, [nSID]);
    ShowMsg(nStr, sHint); Exit;
  end;

  nStr := gPath + sReportDir + 'ShouJu.fr3';
  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '无法正确加载报表文件';
    ShowMsg(nStr, sHint); Exit;
  end;

  FDR.Dataset1.DataSet := FDM.SqlTemp;
  FDR.ShowReport;
  Result := FDR.PrintSuccess;
end;

//Desc: 打印提货单
function PrintBillReport(const nBill: string; const nAsk: Boolean): Boolean;
var nStr: string;
    nParam: TReportParamItem;
begin
  Result := False;

  if nAsk then
  begin
    nStr := '是否要打印提货单?';
    if not QueryDlg(nStr, sAsk) then Exit;
  end;

  nStr := 'Select Z_ID,Z_Project,S_Name,C_Name From $ZK zk ' +
          ' Left Join $SM sm On sm.S_ID=zk.Z_SaleMan ' +
          ' Left Join $Cus cus on cus.C_ID=zk.Z_Custom';
  //纸卡

  nStr := 'Select * From $Bill b ' +
          ' Left Join (' + nStr + ') t On t.Z_ID=b.L_ZID ' +
          'Where R_ID In($ID)';
  //提货单

  nStr := MacroValue(nStr, [MI('$SM', sTable_Salesman), MI('$ID', nBill),
          MI('$ZK', sTable_ZhiKa), MI('$Bill', sTable_Bill),
          MI('$Cus', sTable_Customer)]);
  //xxxxx

  if FDM.QueryTemp(nStr).RecordCount < 1 then
  begin
    nStr := '编号为[ %s ] 的记录已无效!!';
    nStr := Format(nStr, [nBill]);
    ShowMsg(nStr, sHint); Exit;
  end;

  nStr := gPath + sReportDir + 'LadingBill.fr3';
  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '无法正确加载报表文件';
    ShowMsg(nStr, sHint); Exit;
  end;

  nParam.FName := 'UserName';
  nParam.FValue := gSysParam.FUserID;
  FDR.AddParamItem(nParam);

  FDR.Dataset1.DataSet := FDM.SqlTemp;
  FDR.ShowReport;
  Result := FDR.PrintSuccess;
end;

//Desc: 打印提货单到纸卡
function PrintBillZhiKaReport(const nBill,nZK: string; const nAsk: Boolean): Boolean;
begin
  Result := True;
end;

//Desc: 打印nLadID提货记录的过榜单
function PrintPoundReport(const nLadID: string; const nAsk: Boolean): Boolean;
var nStr,nZK,nHK: string;
begin
  if nAsk then
  begin
    Result := True;
    nStr := '是否要打印磅单?';
    if not QueryDlg(nStr, sAsk) then Exit;
  end else Result := False;

  nStr := 'Select Z_ID,Z_Project,S_Name,C_Name From $ZK zk ' +
          ' Left Join $SM sm On sm.S_ID=zk.Z_SaleMan' +
          ' Left Join $Cus cus On cus.C_ID=zk.Z_Custom';
  nZK := MacroValue(nStr, [MI('$ZK', sTable_ZhiKa),
         MI('$SM', sTable_Salesman), MI('$Cus', sTable_Customer)]);
  //纸卡

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
    nStr := '编号为[ %s ] 的记录已无效!!';
    nStr := Format(nStr, [nLadID]);
    ShowDlg(nStr, sHint); Exit;
  end;

  nStr := gPath + sReportDir + 'Pound.fr3';
  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '无法正确加载报表文件';
    ShowMsg(nStr, sHint); Exit;
  end;

  FDR.Dataset1.DataSet := FDM.SqlTemp;
  FDR.ShowReport;
  Result := FDR.PrintSuccess;
end;

//Desc: 供应过榜单
function PrintProvidePoundReport(const nPID: string; const nAsk: Boolean): Boolean;
var nStr: string;
begin
  if nAsk then
  begin
    Result := True;
    nStr := '是否要打印磅单?';
    if not QueryDlg(nStr, sAsk) then Exit;
  end else Result := False;

  nStr := 'Select * From %s Where L_ID=%s';
  nStr := Format(nStr, [sTable_ProvideLog, nPID]);

  if FDM.QueryTemp(nStr).RecordCount < 1 then
  begin
    nStr := '编号为[ %s ] 的记录已无效!!';
    nStr := Format(nStr, [nPID]);
    ShowDlg(nStr, sHint); Exit;
  end;

  nStr := gPath + sReportDir + 'PPound.fr3';
  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '无法正确加载报表文件';
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
//Parm: 供应编号;批量结算标记;类型(P,供应;T,车辆;A,全部);是否询问;合计结算
//Desc: 打印供应结算单
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
    nStr := '未找到符合条件的结算数据,记录已无效!!';
    ShowDlg(nStr, sHint); Exit;
  end;

  nStr := gPath + sReportDir + 'ProvideJS.fr3';
  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '无法正确加载报表文件';
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
//Parm: 供应编号;批量结算标记;合计结算
//Desc: 供应结算单
function PrintProvideJSReport(const nPID,nFlag: string; const nHJ: Boolean): Boolean;
begin
  Result := False;
  if QueryDlg('是否打印供应商结算单?', sAsk) then
    Result := DoProvideJSReport(nPID, nFlag, 'P', nHJ);
  if QueryDlg('是否打印车辆结算单?', sAsk) then
    Result := DoProvideJSReport(nPID, nFlag, 'T', nHJ);
end;

//Desc: 打印标识为nHID的化验单
function PrintHuaYanReport(const nHID: string; const nAsk: Boolean): Boolean;
var nStr,nSR: string;
begin
  if nAsk then
  begin
    Result := True;
    nStr := '是否要打印化验单?';
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
    nStr := '编号为[ %s ] 的化验单记录已无效!!';
    nStr := Format(nStr, [nHID]);
    ShowMsg(nStr, sHint); Exit;
  end;

  nStr := FDM.SqlTemp.FieldByName('P_Stock').AsString;
  if Pos('低碱', nStr) > 0 then
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
    nStr := '无法正确加载报表文件';
    ShowMsg(nStr, sHint); Exit;
  end;

  FDR.Dataset1.DataSet := FDM.SqlTemp;
  FDR.ShowReport;
  Result := FDR.PrintSuccess;
end;

//Desc: 打印标识为nID的合格证
function PrintHeGeReport(const nHID: string; const nAsk: Boolean): Boolean;
var nStr,nSR: string;
begin
  if nAsk then
  begin
    Result := True;
    nStr := '是否要打印合格证?';
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
    nStr := '编号为[ %s ] 的化验单记录已无效!!';
    nStr := Format(nStr, [nHID]);
    ShowMsg(nStr, sHint); Exit;
  end;

  nStr := gPath + sReportDir + 'HeGeZheng.fr3';
  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '无法正确加载报表文件';
    ShowMsg(nStr, sHint); Exit;
  end;

  FDR.Dataset1.DataSet := FDM.SqlTemp;
  FDR.ShowReport;
  Result := FDR.PrintSuccess;
end;

end.

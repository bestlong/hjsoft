{*******************************************************************************
  作者: dmzn@163.com 2008-08-07
  描述: 系统数据库常量定义

  备注:
  *.自动创建SQL语句,支持变量:$Inc,自增;$Float,浮点;$Integer=sFlag_Integer;
    $Decimal=sFlag_Decimal;$Image,二进制流
*******************************************************************************}
unit USysDB;

{$I Link.inc}
interface

uses
  SysUtils, Classes;

const
  cSysDatabaseName: array[0..4] of String = (
     'Access', 'SQL', 'MySQL', 'Oracle', 'DB2');
  //db names

type
  TSysDatabaseType = (dtAccess, dtSQLServer, dtMySQL, dtOracle, dtDB2);
  //db types

  PSysTableItem = ^TSysTableItem;
  TSysTableItem = record
    FTable: string;
    FNewSQL: string;
  end;
  //系统表项

var
  gSysTableList: TList = nil;                        //系统表数组
  gSysDBType: TSysDatabaseType = dtSQLServer;        //系统数据类型

//------------------------------------------------------------------------------
const
  //自增字段
  sField_Access_AutoInc          = 'Counter';
  sField_SQLServer_AutoInc       = 'Integer IDENTITY (1,1) PRIMARY KEY';

  //小数字段
  sField_Access_Decimal          = 'Float';
  sField_SQLServer_Decimal       = 'Decimal(15, 5)';

  //图片字段
  sField_Access_Image            = 'OLEObject';
  sField_SQLServer_Image         = 'Image';

  //日期相关
  sField_SQLServer_Now           = 'getDate()';

ResourceString     
  {*权限项*}
  sPopedom_Read       = 'A';                         //浏览
  sPopedom_Add        = 'B';                         //添加
  sPopedom_Edit       = 'C';                         //修改
  sPopedom_Delete     = 'D';                         //删除
  sPopedom_Preview    = 'E';                         //预览
  sPopedom_Print      = 'F';                         //打印
  sPopedom_Export     = 'G';                         //导出

  {*相关标记*}
  sFlag_Yes           = 'Y';                         //是
  sFlag_No            = 'N';                         //否
  sFlag_Enabled       = 'Y';                         //启用
  sFlag_Disabled      = 'N';                         //禁用

  sFlag_Integer       = 'I';                         //整数
  sFlag_Decimal       = 'D';                         //小数

  sFlag_Provide       = 'P';                         //供应
  sFlag_Sale          = 'S';                         //销售
  
  sFlag_TiHuo         = 'T';                         //自提
  sFlag_SongH         = 'S';                         //送货
  sFlag_XieH          = 'X';                         //运卸

  sFlag_TruckNone     = 'N';                         //无状态车辆
  sFlag_TruckIn       = 'I';                         //进厂车辆
  sFlag_TruckOut      = 'O';                         //出厂车辆
  sFlag_TruckBFP      = 'P';                         //磅房皮重车辆
  sFlag_TruckBFM      = 'M';                         //磅房毛重车辆
  sFlag_TruckSH       = 'S';                         //送货车辆
  sFlag_TruckFH       = 'F';                         //放灰车辆
  sFlag_TruckZT       = 'Z';                         //栈台车辆

  sFlag_CardIdle      = 'I';                         //空闲卡
  sFlag_CardUsed      = 'U';                         //使用中
  sFlag_CardLoss      = 'L';                         //挂失卡
  sFlag_CardInvalid   = 'N';                         //注销卡

  sFlag_Dai           = 'D';                         //袋装水泥
  sFlag_San           = 'S';                         //散装水泥

  sFlag_MoneyHuiKuan  = 'R';                         //回款入金
  sFlag_MoneyJiaCha   = 'C';                         //补缴价差
  sFlag_MoneyZhiKa    = 'Z';                         //纸卡回款
  sFlag_MoneyFanHuan  = 'H';                         //返还用户

  sFlag_InvNormal     = 'N';                         //正常发票
  sFlag_InvHasUsed    = 'U';                         //已用发票
  sFlag_InvInvalid    = 'V';                         //作废发票

  sFlag_SysParam      = 'SysParam';                  //系统参数
  sFlag_ZhiKaVerify   = 'ZhiKaVerify';               //纸卡审核
  sFlag_AutoP24H      = 'AutoP_24H';                 //自动称重
  sFlag_WuCha         = 'WeightWuCha';               //净重误差
  sFlag_JiaoBan       = 'JiaoBanTime';               //交班时间
  sFlag_HYValue       = 'HYMaxValue';                //化验批次量
  sFlag_AutoOut       = 'AutoO_Truck';               //自动出厂

  sFlag_CardItem      = 'CardItem';                  //磁卡信息项
  sFlag_AreaItem      = 'AreaItem';                  //区域信息项
  sFlag_CustomerItem  = 'CustomerItem';              //客户信息项
  sFlag_BankItem      = 'BankItem';                  //银行信息项
  sFlag_StockItem     = 'StockItem';                 //水泥信息项
  sFlag_ContractItem  = 'ContractItem';              //合同信息项
  sFlag_SalesmanItem  = 'SalesmanItem';              //业务员信息项
  sFlag_ZhiKaItem     = 'ZhiKaItem';                 //纸卡信息项

  sFlag_PaymentItem   = 'PaymentItem';               //付款方式信息项
  sFlag_PaymentItem2  = 'PaymentItem2';              //销售回款信息项
  sFlag_LadingItem    = 'LadingItem';                //提货方式信息项

  sFlag_ProviderItem  = 'ProviderItem';              //供应商信息项
  sFlag_MaterailsItem = 'MaterailsItem';             //原材料信息项

  {*数据表*}
  sTable_Group        = 'Sys_Group';                 //用户组
  sTable_User         = 'Sys_User';                  //用户表
  sTable_Menu         = 'Sys_Menu';                  //菜单表
  sTable_Popedom      = 'Sys_Popedom';               //权限表
  sTable_PopItem      = 'Sys_PopItem';               //权限项
  sTable_Entity       = 'Sys_Entity';                //字典实体
  sTable_DictItem     = 'Sys_DataDict';              //字典明细

  sTable_SysDict      = 'Sys_Dict';                  //系统字典
  sTable_ExtInfo      = 'Sys_ExtInfo';               //附加信息
  sTable_SysLog       = 'Sys_EventLog';              //系统日志
  sTable_BaseInfo     = 'Sys_BaseInfo';              //基础信息

  sTable_Customer     = 'S_Customer';                //客户信息
  sTable_Salesman     = 'S_Salesman';                //业务人员
  sTable_SaleContract = 'S_Contract';                //销售合同
  sTable_SContractExt = 'S_ContractExt';             //合同扩展

  sTable_ZhiKa        = 'S_ZhiKa';                   //纸卡数据
  sTable_ZhiKaDtl     = 'S_ZhiKaDtl';                //纸卡明细
  sTable_ZhiKaCard    = 'S_ZhiKaCard';               //纸卡磁卡
  sTable_Bill         = 'S_Bill';                    //提货单

  sTable_TruckJS      = 'S_TruckJS';                 //装车计数
  sTable_ReturnGoods  = 'S_ReturnGoods';             //销售退货

  sTable_StockParam   = 'S_StockParam';              //品种参数
  sTable_StockParamExt= 'S_StockParamExt';           //参数扩展
  sTable_StockRecord  = 'S_StockRecord';             //检验记录
  sTable_StockHuaYan  = 'S_StockHuaYan';             //开化验单

  sTable_CusAccount   = 'Sys_CustomerAccount';       //客户账户
  sTable_InOutMoney   = 'Sys_CustomerInOutMoney';    //资金明细
  sTable_CusCredit    = 'Sys_CustomerCredit';        //客户信用

  sTable_Invoice      = 'Sys_Invoice';               //发票列表
  sTable_InvoiceDtl   = 'Sys_InvoiceDetail';         //发票明细
  sTable_SysShouJu    = 'Sys_ShouJu';                //收据记录

  sTable_Truck        = 'Sys_Truck';                 //车辆表
  sTable_TruckLog     = 'Sys_TruckLog';              //车辆日志
  sTable_TruckLogExt  = 'Sys_TruckLogExt';           //日志扩展

  sTable_Provider     = 'P_Provider';                //供应商
  sTable_Materails    = 'P_Materails';               //原材料
  sTable_ProvideCard  = 'P_ProvideCard';             //供货磁卡
  sTable_ProvideLog   = 'P_ProvideLog';              //供应记录

  {*新建表*}
  sSQL_NewSysDict = 'Create Table $Table(D_ID $Inc, D_Name varChar(15),' +
       'D_Desc varChar(30), D_Value varChar(50), D_Memo varChar(20),' +
       'D_ParamA $Float, D_ParamB varChar(50), D_Index Integer Default 0)';
  {-----------------------------------------------------------------------------
   系统字典: SysDict
   *.D_ID: 编号
   *.D_Name: 名称
   *.D_Desc: 描述
   *.D_Value: 取值
   *.D_Memo: 相关信息
   *.D_ParamA: 浮点参数
   *.D_ParamB: 字符参数
   *.D_Index: 显示索引
  -----------------------------------------------------------------------------}
  
  sSQL_NewExtInfo = 'Create Table $Table(I_ID $Inc, I_Group varChar(20),' +
       'I_ItemID varChar(20), I_Item varChar(30), I_Info varChar(500),' +
       'I_ParamA $Float, I_ParamB varChar(50), I_Index Integer Default 0)';
  {-----------------------------------------------------------------------------
   扩展信息表: ExtInfo
   *.I_ID: 编号
   *.I_Group: 信息分组
   *.I_ItemID: 信息标识
   *.I_Item: 信息项
   *.I_Info: 信息内容
   *.I_ParamA: 浮点参数
   *.I_ParamB: 字符参数
   *.I_Memo: 备注信息
   *.I_Index: 显示索引
  -----------------------------------------------------------------------------}
  
  sSQL_NewSysLog = 'Create Table $Table(L_ID $Inc, L_Date DateTime,' +
       'L_Man varChar(32),L_Group varChar(20), L_ItemID varChar(20),' +
       'L_KeyID varChar(20), L_Event varChar(220))';
  {-----------------------------------------------------------------------------
   系统日志: SysLog
   *.L_ID: 编号
   *.L_Date: 操作日期
   *.L_Man: 操作人
   *.L_Group: 信息分组
   *.L_ItemID: 信息标识
   *.L_KeyID: 辅助标识
   *.L_Event: 事件
  -----------------------------------------------------------------------------}

  sSQL_NewBaseInfo = 'Create Table $Table(B_ID $Inc, B_Group varChar(15),' +
       'B_Text varChar(100), B_Py varChar(25), B_Memo varChar(50),' +
       'B_PID Integer, B_Index Float)';
  {-----------------------------------------------------------------------------
   基本信息表: BaseInfo
   *.B_ID: 编号
   *.B_Group: 分组
   *.B_Text: 内容
   *.B_Py: 拼音简写
   *.B_Memo: 备注信息
   *.B_PID: 上级节点
   *.B_Index: 创建顺序
  -----------------------------------------------------------------------------}

  sSQL_NewSalesMan = 'Create Table $Table(R_ID $Inc, S_ID varChar(15),' +
       'S_Name varChar(30), S_PY varChar(30), S_Phone varChar(20),' +
       'S_Area varChar(50), S_InValid Char(1), S_Memo varChar(50))';
  {-----------------------------------------------------------------------------
   业务员表: SalesMan
   *.R_ID: 记录号
   *.S_ID: 编号
   *.S_Name: 名称
   *.S_PY: 简拼
   *.S_Phone: 联系方式
   *.S_Area:所在区域
   *.S_InValid: 已无效
   *.S_Memo: 备注
  -----------------------------------------------------------------------------}

  sSQL_NewCustomer = 'Create Table $Table(R_ID $Inc, C_ID varChar(15), ' +
       'C_Name varChar(80), C_PY varChar(80), C_Addr varChar(100), ' +
       'C_FaRen varChar(50), C_LiXiRen varChar(50),' +
       'C_Phone varChar(15), C_Fax varChar(15), C_Tax varChar(32),' +
       'C_Bank varChar(35), C_Account varChar(18), C_SaleMan varChar(15),' +
       'C_Memo varChar(50), C_XuNi Char(1))';
  {-----------------------------------------------------------------------------
   客户信息表: Customer
   *.R_ID: 记录号
   *.C_ID: 编号
   *.C_Name: 名称
   *.C_PY: 拼音简写
   *.C_Addr: 地址
   *.C_FaRen: 法人
   *.C_LiXiRen: 联系人
   *.C_Phone: 电话
   *.C_Fax: 传真
   *.C_Tax: 税号
   *.C_Bank: 开户行
   *.C_Account: 帐号
   *.C_SaleMan: 业务员
   *.C_Memo: 备注信息
   *.C_XuNi: 虚拟(临时)客户
  -----------------------------------------------------------------------------}
  
  sSQL_NewCusAccount = 'Create Table $Table(A_ID $Inc, A_CID varChar(15),' +
       'A_Used Char(1), A_InMoney Decimal(15,5) Default 0,' +
       'A_OutMoney Decimal(15,5) Default 0, A_DebtMoney Decimal(15,5) Default 0,' +
       'A_Compensation Decimal(15,5) Default 0,' +
       'A_FreezeMoney Decimal(15,5) Default 0,' +
       'A_CreditLimit Decimal(15,5) Default 0, A_Date DateTime)';
  {-----------------------------------------------------------------------------
   客户账户:CustomerAccount
   *.A_ID:记录编号
   *.A_CID:客户号
   *.A_Used:用途(供应,销售)
   *.A_InMoney:入金
   *.A_OutMoney:出金
   *.A_DebtMoney:欠款
   *.A_Compensation:补偿金
   *.A_FreezeMoney:冻结资金
   *.A_CreditLimit:信用额度
   *.A_Date:创建日期

   *.水泥销售账中
     A_InMoney:客户存入账户的金额
     A_OutMoney:客户实际花费的金额
     A_DebtMoney:还未支付的金额
     A_Compensation:由于差价退还给客户的金额
     A_FreezeMoney:已办纸卡但未进厂提货的金额
     A_CreditLimit:授信给用户的最高可欠款金额

     可用余额 = 入金 + 信用额 - 出金 - 补偿金 - 已冻结
     消费总额 = 出金 + 欠款 + 已冻结
  -----------------------------------------------------------------------------}

  sSQL_NewInOutMoney = 'Create Table $Table(M_ID $Inc, M_SaleMan varChar(15),' +
       'M_CusID varChar(15), M_CusName varChar(80), ' +
       'M_Type Char(1), M_Payment varChar(20),' +
       'M_Money Decimal(15,5), M_ZID varChar(15), M_Date DateTime,' +
       'M_Man varChar(32), M_Memo varChar(200))';
  {-----------------------------------------------------------------------------
   出入金明细:CustomerInOutMoney
   *.M_ID:记录编号
   *.M_SaleMan:业务员
   *.M_CusID:客户号
   *.M_CusName:客户名
   *.M_Type:类型(补差,回款等)
   *.M_Payment:付款方式
   *.M_Money:缴纳金额
   *.M_ZID:纸卡号
   *.M_Date:操作日期
   *.M_Man:操作人
   *.M_Memo:描述

   *.水泥销售入金中
     金额 = 单价 x 数量 + 其它
  -----------------------------------------------------------------------------}

  sSQL_NewSysShouJu = 'Create Table $Table(R_ID $Inc ,S_Code varChar(15),' +
       'S_Sender varChar(100), S_Reason varChar(100), S_Money Decimal(15,5),' +
       'S_BigMoney varChar(50), S_Bank varChar(35), S_Man varChar(32),' +
       'S_Date DateTime, S_Memo varChar(50))';
  {-----------------------------------------------------------------------------
   收据明细:ShouJu
   *.R_ID:编号
   *.S_Code:记账凭单号码
   *.S_Sender:兹由(来源)
   *.S_Reason:交来(事务)
   *.S_Money:金额
   *.S_Bank:银行
   *.S_Man:出纳员
   *.S_Date:日期
   *.S_Memo:备注
  -----------------------------------------------------------------------------}

  sSQL_NewCusCredit = 'Create Table $Table(C_ID $Inc ,C_CusID varChar(15),' +
       'C_Money Decimal(15,5), C_Man varChar(32),' +
       'C_Date DateTime, C_Memo varChar(50))';
  {-----------------------------------------------------------------------------
   信用明细:CustomerCredit
   *.C_ID:编号
   *.C_CusID:客户编号
   *.C_Money:授信额
   *.C_Man:操作人
   *.C_Date:日期
   *.C_Memo:备注
  -----------------------------------------------------------------------------}

  sSQL_NewSaleContract = 'Create Table $Table(C_ID varChar(15),' +
       'C_Project varChar(100),C_SaleMan varChar(15), C_Customer varChar(15),' +
       'C_Date varChar(20), C_Area varChar(50), C_Addr varChar(50),' +
       'C_Delivery varChar(50), C_Payment varChar(20), C_Approval varChar(30),' +
       'C_ZKDays Integer, C_XuNi Char(1), C_Freeze Char(1), C_Memo varChar(50))';
  {-----------------------------------------------------------------------------
   销售合同: SalesContract
   *.C_ID: 编号
   *.C_Project: 项目名称
   *.C_SaleMan: 销售人员
   *.C_Customer: 客户
   *.C_Date: 签订时间
   *.C_Area: 所属区域
   *.C_Addr: 签订地点
   *.C_Delivery: 交货地
   *.C_Payment: 付款方式
   *.C_Approval: 批准人
   *.C_ZKDays: 纸卡有效期
   *.C_XuNi: 虚拟合同
   *.C_Freeze: 是否冻结
   *.C_Memo: 备注信息
  -----------------------------------------------------------------------------}

  sSQL_NewSContractExt = 'Create Table $Table(E_ID $Inc,' +
       'E_CID varChar(15), E_Type Char(1), E_Stock varChar(30),' +
       'E_Value Decimal(15,5), E_Price Decimal(15,5), E_Money Decimal(15,5))';
  {-----------------------------------------------------------------------------
   销售合同: SalesContract
   *.E_ID: 记录编号
   *.E_CID: 销售合同
   *.E_Type: 类型(袋,散)
   *.E_Stock: 水泥名称
   *.E_Value: 数量
   *.E_Price: 单价
   *.E_Money: 金额
  -----------------------------------------------------------------------------}

  sSQL_NewZhiKa = 'Create Table $Table(R_ID $Inc, Z_ID varChar(15),' +
       'Z_CID varChar(15), Z_Project varChar(100), Z_Custom varChar(15),' +
       'Z_SaleMan varChar(15), Z_Payment varChar(20), Z_Lading Char(1),' +
       'Z_ValidDays DateTime, Z_Password varChar(16), Z_OnlyPwd Char(1),' +
       'Z_Verified Char(1), Z_InValid Char(1), Z_Freeze Char(1),' +
       'Z_YFMoney $Float, Z_FixedMoney $Float, Z_OnlyMoney Char(1),' +
       'Z_Memo varChar(200),Z_Man varChar(32), Z_Date DateTime)';
  {-----------------------------------------------------------------------------
   纸卡办理: ZhiKa
   *.R_ID:记录编号
   *.Z_ID:纸卡号
   *.Z_CID:销售合同
   *.Z_Project:项目名称
   *.Z_Custom:客户编号
   *.Z_SaleMan:业务员
   *.Z_Payment:付款方式
   *.Z_Lading:提货方式(自提,送货)
   *.Z_ValidDays:有效期
   *.Z_Password: 密码
   *.Z_OnlyPwd: 统一密码
   *.Z_Verified:已审核
   *.Z_InValid:已无效
   *.Z_Freeze:已冻结
   *.Z_YFMoney:预付金额
   *.Z_FixedMoney:可用金
   *.Z_OnlyMoney:只使用可用金
   *.Z_Man:操作人
   *.Z_Date:创建时间
  -----------------------------------------------------------------------------}

  sSQL_NewZhiKaDtl = 'Create Table $Table(R_ID $Inc, D_ZID varChar(15),' +
       'D_Type Char(1), D_Stock varChar(30), D_Price $Float, D_Value $Float)';
  {-----------------------------------------------------------------------------
   纸卡明细:ZhiKaDtl
   *.R_ID:记录编号
   *.D_ZID:纸卡号
   *.D_Type:类型(袋,散)
   *.D_Stock:水泥名称
   *.D_Price:单价
   *.D_Value:办理量
  -----------------------------------------------------------------------------}

  sSQL_NewZhiKaCard = 'Create Table $Table(R_ID $Inc, C_ZID varChar(15),' +
       'C_Card varChar(30), C_Password varChar(16), C_OwnerID varChar(15),' +
       'C_Used Char(1), C_Status Char(1),C_IsFreeze Char(1),' +
       'C_Man varChar(32), C_Date DateTime, C_Memo varChar(50))';
  {-----------------------------------------------------------------------------
   纸卡磁卡:ZhiKaCard
   *.R_ID:记录编号
   *.C_ZID:纸卡号
   *.C_Card:卡号
   *.C_Password: 密码
   *.C_OwnerID:持有人标识
   *.C_Used:用途(供应,销售)
   *.C_Status:状态(空闲,使用,注销,挂失)   
   *.C_IsFreeze:是否冻结
   *.C_Man:办理人
   *.C_Date:办理时间
   *.C_Memo:备注信息
  -----------------------------------------------------------------------------}

  sSQL_NewBill = 'Create Table $Table(R_ID $Inc, L_ID varChar(15),' +
       'L_ZID varChar(15), L_Custom varChar(15), L_SaleMan varChar(15),' +
       'L_TruckNo varChar(15),L_Type Char(1), L_Stock varChar(30),' +
       'L_Value $Float, L_Price $Float,L_ZKMoney Char(1), L_Card varChar(32),' +
       'L_Lading Char(1),L_Man varChar(32),L_Date DateTime,L_IsDone Char(1),' +
       'L_OKDate DateTime)';
  {-----------------------------------------------------------------------------
   提货单:Bill
   *.L_ID:提货单号
   *.L_ZID:纸卡编号
   *.L_Custom:客户
   *.L_SaleMan:业务员
   *.L_TruckNo:车号
   *.L_Type:类型(袋,散)
   *.L_Stock:水泥名称
   *.L_Value:吨数
   *.L_Price:单价
   *.L_ZKMoney:扣纸卡金额
   *.L_Card:提货磁卡
   *.L_Lading:提货方式(自提,送货)
   *.L_Man:操作人
   *.L_Date:创建时间
   *.L_IsDone:完成
   *.L_OKDate:完成时间
  -----------------------------------------------------------------------------}

  sSQL_NewReturnGoods = 'Create Table $Table(R_ID $Inc, R_ZID varChar(15),' +
       'R_Value Decimal(15,5), R_Price Decimal(15,5), R_Man varChar(32),' +
       'R_Date DateTime, R_Memo varChar(50))';
  {-----------------------------------------------------------------------------
   退购:ReturnGoods
   *.R_ID:记录编号
   *.R_ZID:纸卡编号
   *.R_Value:吨数
   *.R_Price:单价
   *.R_Man:操作人
   *.R_Date:操作时间
   *.R_Memo:备注
  -----------------------------------------------------------------------------}

  sSQL_NewTruck = 'Create Table $Table(T_ID varChar(15))';
  {-----------------------------------------------------------------------------
   车辆信息:Truck
   *.T_ID:车牌
  -----------------------------------------------------------------------------}

  sSQL_NewTruckLog = 'Create Table $Table(R_ID $Inc, T_ID varChar(15),' +
       'T_Truck varChar(15),T_Status Char(1), T_NextStatus Char(1),' +
       'T_InTime DateTime, T_InMan varChar(32),' +
       'T_OutTime DateTime, T_OutMan varChar(32),' +
       'T_BFPTime DateTime, T_BFPMan varChar(32), T_BFPValue Decimal(15,5),' +
       'T_BFMTime DateTime, T_BFMMan varChar(32), T_BFMValue Decimal(15,5),' +
       'T_FHSTime DateTime, T_FHETime DateTime, T_FHLenth Integer,' +
       'T_FHMan varChar(32), T_FHValue Decimal(15,5),' +
       'T_ZTTime DateTime, T_ZTMan varChar(32),' +
       'T_ZTValue Decimal(15,5),T_ZTCount Integer, T_ZTDiff Integer,' +
       'T_YSTime DateTime, T_YSMan varChar(32), T_Acceptance Char(1),' +
       'T_AcceptMemo varChar(50), T_Deduct Decimal(15,5))';
  {-----------------------------------------------------------------------------
   车辆日志:TruckLog
   *.T_ID:记录编号
   *.T_Truck:车牌号
   *.T_Status,T_NextStatus:状态
   *.T_InTime,T_InMan:进厂时间,放行人
   *.T_OutTime,T_OutMan:出厂时间,放行人
   *.T_BFPTime,T_BFPMan,T_BFPValue:皮重时间,操作人,皮重
   *.T_BFMTime,T_BFMMan,T_BFMValue:毛重时间,操作人,毛重
   *.T_FHSTime,T_FHETime,
     T_FHLenth,T_FHMan,T_FHValue:开始时间,结束时间,时长操作人,放灰量
   *.T_ZTTime,T_ZTMan,
     T_ZTValue,T_ZTCount,T_ZTDiff:栈台时间,操作人,提货量,袋数,补差
   *.T_YSTime,T_YSMan,T_Acceptance,
     T_AcceptMemo,T_Deduct:验收时间,验收人,结果,备注,扣重
  -----------------------------------------------------------------------------}

  sSQL_NewTruckLogExt = 'Create Table $Table(E_ID $Inc, E_TID varChar(15),' +
       'E_Truck varChar(15), E_Card varChar(32), ' +
       'E_Used Char(1), E_ZID varChar(15), E_Bill varChar(15),' +
       'E_Price $Float, E_Value $Float, E_StockNo varChar(15),' +
       'E_ZTLine varChar(50), E_DaiShu Integer, E_BC Integer, E_IsHK Char(1),' +
       'E_HyID Integer)';
  {-----------------------------------------------------------------------------
   车辆日志扩展:TruckLogExt
   *.E_ID:记录编号
   *.E_TID:车辆日志
   *.E_Truck:车牌号
   *.E_Card:磁卡号
   *.E_Used:用途(供应,销售)
   *.E_ZID:纸卡号
   *.E_Bill:提货单记录
   *.E_Price:提货价格
   *.E_Value:最终有效值
   *.E_StockNo:水泥编号
   *.E_ZTLine:栈台位置
   *.E_DaiShu:提货袋数
   *.E_BC:补差袋数
   *.E_IsHK:是否合卡
   *.E_HyID:化验单
  -----------------------------------------------------------------------------}

  sSQL_NewTruckJS = 'Create Table $Table(J_ID $Inc, J_Truck varChar(15),' +
                 'J_Stock varChar(30), J_Value $Float, J_DaiShu Integer,' +
                 'J_BuCha Integer, J_Bill varChar(200), J_Date DateTime)';
  {-----------------------------------------------------------------------------
   栈台装车计数: TruckJS
   *.J_ID: 记录编号
   *.J_Truck: 车牌号
   *.J_Stock: 水泥品种
   *.J_Value: 提货量
   *.J_DaiShu: 装车袋数
   *.J_BuCha: 补差袋数
   *.J_Bill: 提货单列表
   *.J_Date: 装车日期
  -----------------------------------------------------------------------------}

  sSQL_NewStockParam = 'Create Table $Table(P_ID varChar(15), P_Stock varChar(30),' +
       'P_Type Char(1), P_Name varChar(50), P_QLevel varChar(20), P_Memo varChar(50),' +
       'P_MgO varChar(20), P_SO3 varChar(20), P_ShaoShi varChar(20),' +
       'P_CL varChar(20), P_BiBiao varChar(20), P_ChuNing varChar(20),' +
       'P_ZhongNing varChar(20), P_AnDing varChar(20), P_XiDu varChar(20),' +
       'P_Jian varChar(20), P_ChouDu varChar(20), P_BuRong varChar(20),' +
       'P_YLiGai varChar(20), P_3DZhe varChar(20), P_28Zhe varChar(20),' +
       'P_3DYa varChar(20), P_28Ya varChar(20))';
  {-----------------------------------------------------------------------------
   品种参数:StockParam
   *.P_ID:记录编号
   *.P_Stock:品名
   *.P_Type:类型(袋,散)
   *.P_Name:等级名
   *.P_QLevel:强度等级
   *.P_Memo:备注
   *.P_MgO:氧化镁
   *.P_SO3:三氧化硫
   *.P_ShaoShi:烧失量
   *.P_CL:氯离子
   *.P_BiBiao:比表面积
   *.P_ChuNing:初凝时间
   *.P_ZhongNing:终凝时间
   *.P_AnDing:安定性
   *.P_XiDu:细度
   *.P_Jian:碱含量
   *.P_ChouDu:稠度
   *.P_BuRong:不溶物
   *.P_YLiGai:游离钙
   *.P_3DZhe:3天抗折强度
   *.P_28DZhe:28抗折强度
   *.P_3DYa:3天抗压强度
   *.P_28DYa:28抗压强度
  -----------------------------------------------------------------------------}

  sSQL_NewStockRecord = 'Create Table $Table(R_ID $Inc, R_SerialNo varChar(15),' +
       'R_PID varChar(15),' +
       'R_MgO varChar(20), R_SO3 varChar(20), R_ShaoShi varChar(20),' +
       'R_CL varChar(20), R_BiBiao varChar(20), R_ChuNing varChar(20),' +
       'R_ZhongNing varChar(20), R_AnDing varChar(20), R_XiDu varChar(20),' +
       'R_Jian varChar(20), R_ChouDu varChar(20), R_BuRong varChar(20),' +
       'R_YLiGai varChar(20),' +
       'R_3DZhe1 varChar(20), R_3DZhe2 varChar(20), R_3DZhe3 varChar(20),' +
       'R_28Zhe1 varChar(20), R_28Zhe2 varChar(20), R_28Zhe3 varChar(20),' +
       'R_3DYa1 varChar(20), R_3DYa2 varChar(20), R_3DYa3 varChar(20),' +
       'R_3DYa4 varChar(20), R_3DYa5 varChar(20), R_3DYa6 varChar(20),' +
       'R_28Ya1 varChar(20), R_28Ya2 varChar(20), R_28Ya3 varChar(20),' +
       'R_28Ya4 varChar(20), R_28Ya5 varChar(20), R_28Ya6 varChar(20),' +
       'R_Date DateTime, R_Man varChar(32))';
  {-----------------------------------------------------------------------------
   检验记录:StockRecord
   *.R_ID:记录编号
   *.R_SerialNo:水泥编号
   *.R_PID:品种参数
   *.R_MgO:氧化镁
   *.R_SO3:三氧化硫
   *.R_ShaoShi:烧失量
   *.R_CL:氯离子
   *.R_BiBiao:比表面积
   *.R_ChuNing:初凝时间
   *.R_ZhongNing:终凝时间
   *.R_AnDing:安定性
   *.R_XiDu:细度
   *.R_Jian:碱含量
   *.R_ChouDu:稠度
   *.R_BuRong:不溶物
   *.R_YLiGai:游离钙
   *.R_3DZhe1:3天抗折强度1
   *.R_3DZhe2:3天抗折强度2
   *.R_3DZhe3:3天抗折强度3
   *.R_28Zhe1:28抗折强度1
   *.R_28Zhe2:28抗折强度2
   *.R_28Zhe3:28抗折强度3
   *.R_3DYa1:3天抗压强度1
   *.R_3DYa2:3天抗压强度2
   *.R_3DYa3:3天抗压强度3
   *.R_3DYa4:3天抗压强度4
   *.R_3DYa5:3天抗压强度5
   *.R_3DYa6:3天抗压强度6
   *.R_28Ya1:28抗压强度1
   *.R_28Ya2:28抗压强度2
   *.R_28Ya3:28抗压强度3
   *.R_28Ya4:28抗压强度4
   *.R_28Ya5:28抗压强度5
   *.R_28Ya6:28抗压强度6
   *.R_Date:取样日期
   *.R_Man:录入人
  -----------------------------------------------------------------------------}

  sSQL_NewStockHuaYan = 'Create Table $Table(H_ID $Inc, H_Custom varChar(15),' +
       'H_CusName varChar(80), H_SerialNo varChar(15), H_Truck varChar(15),' +
       'H_Value $Float,H_BillDate DateTime, H_ReportDate DateTime,' +
       'H_Reporter varChar(32))';
  {-----------------------------------------------------------------------------
   开化验单:StockHuaYan
   *.H_ID:记录编号
   *.H_Custom:客户编号
   *.H_CusName:客户名称
   *.H_SerialNo:水泥编号
   *.H_Truck:提货车辆
   *.H_Value:提货量
   *.H_BillDate:提货日期
   *.H_ReportDate:报告日期
   *.H_Reporter:报告人
  -----------------------------------------------------------------------------}

  sSQL_NewInvoice = 'Create Table $Table(I_ID varChar(25) PRIMARY KEY,' +
       'I_Customer varChar(50), I_SaleMan varChar(50), I_Status Char(1),' +
       'I_InMan varChar(32), I_InDate DateTime, I_OutMan varChar(32),' +
       'I_OutDate DateTime, I_Memo varChar(50))';
  {-----------------------------------------------------------------------------
   发票票据:Invoice
   *.I_ID:编号
   *.I_Customer:客户名
   *.I_SaleMan:业务员
   *.I_Status:状态
   *.I_InMan:录入人
   *.I_InDate:录入日期
   *.I_OutMan:领用人
   *.I_OutDate:领用日期
   *.I_Memo:备注
  -----------------------------------------------------------------------------}

  sSQL_NewInvoiceDtl = 'Create Table $Table(D_ID $Inc, D_Invoice varChar(25),' +
       'D_Type Char(1), D_Stock varChar(30), D_Price Decimal(15,5) Default 0,' +
       'D_Value Decimal(15,5) Default 0, D_DisCount Decimal(15,5) Default 0)';
  {-----------------------------------------------------------------------------
   发票明细:InvoiceDetail
   *.D_ID:编号
   *.D_Invoice:票号
   *.D_Type:类型(带,散)
   *.D_Stock:品种
   *.D_Price:单价
   *.D_Value:开票量
   *.D_DisCount:折扣比
  -----------------------------------------------------------------------------}

  sSQL_NewProvider = 'Create Table $Table(P_ID $Inc, P_Name varChar(80),' +
       'P_Phone varChar(20), P_Memo varChar(50))';
  {-----------------------------------------------------------------------------
   供应商: Provider
   *.P_ID: 编号
   *.P_Name: 名称
   *.P_Phone: 联系方式
   *.P_Memo: 备注
  -----------------------------------------------------------------------------}

  sSQL_NewMaterails = 'Create Table $Table(M_ID $Inc, M_Name varChar(30),' +
       'M_PY varChar(30), M_Unit varChar(20), M_Price $Float, M_Memo varChar(50))';
  {-----------------------------------------------------------------------------
   原材料: Materails
   *.M_ID: 编号
   *.M_Name: 名称
   *.M_PY: 拼音简写
   *.M_Unit: 单位
   *.M_Price: 单价
   *.M_Memo: 备注
  -----------------------------------------------------------------------------}

  sSQL_NewProvideCard = 'Create Table $Table(P_ID $Inc,' +
       'P_Provider varChar(80), P_Mate varChar(30), P_Card varChar(30),' +
       'P_Owner varChar(32), P_Man varChar(32), P_Date DateTime, ' +
       'P_Memo varChar(50), P_Status Char(1))';
  {-----------------------------------------------------------------------------
   供货磁卡: ProvideCard
   *.P_ID: 编号
   *.P_Provider: 供应商
   *.P_Mate: 原材料
   *.P_Card: 磁卡号
   *.P_Owner: 持有人
   *.P_Man: 操作人
   *.P_Date: 操作时间
   *.P_Status: 状态(冻结,无效等)
  -----------------------------------------------------------------------------}

  sSQL_NewProvideLog = 'Create Table $Table(L_ID $Inc, L_Provider varChar(80),' +
       'L_Mate varChar(30), L_Unit varChar(20), L_Truck varChar(15), ' +
       'L_PValue $Float, L_PMan varChar(32), L_PDate DateTime, ' +
       'L_MValue $Float, L_MMan varChar(32), L_MDate DateTime, ' +
       'L_YValue $Float, L_YMan varChar(32), L_YDate DateTime, ' +
       'L_Card varChar(30), L_Price $Float, L_PrintNum Integer,' +
       'L_Memo varChar(50))';
  {-----------------------------------------------------------------------------
   供货记录: ProvideLog
   *.L_ID: 编号
   *.L_Provider: 供应商
   *.L_Mate: 原材料
   *.L_Unit: 单位
   *.L_Truck: 车牌号
   *.L_PValue,L_PMan,L_PDate: 皮重,过磅员,时间
   *.L_MValue,L_MMan,L_MDate: 毛重,过磅员,时间
   *.L_YValue,L_YMan,L_YDate: 验收,验收人,时间
   *.L_Price: 单价
   *.L_Card: 磁卡号
   *.L_PrintNum: 打印次数
   *.L_Memo: 备注信息
  -----------------------------------------------------------------------------}

//------------------------------------------------------------------------------
// 数据查询
//------------------------------------------------------------------------------
  sQuery_SysDict = 'Select D_ID, D_Value, D_Memo From $Table ' +
                   'Where D_Name=''$Name'' Order By D_Index ASC';
  {-----------------------------------------------------------------------------
   从数据字典读取数据
   *.$Table:数据字典表
   *.$Name:字典项名称
  -----------------------------------------------------------------------------}

  sQuery_ExtInfo = 'Select I_ID, I_Item, I_Info From $Table Where ' +
                   'I_Group=''$Group'' and I_ItemID=''$ID'' Order By I_Index Desc';
  {-----------------------------------------------------------------------------
   从扩展信息表读取数据
   *.$Table:扩展信息表
   *.$Group:分组名称
   *.$ID:信息标识
  -----------------------------------------------------------------------------}

implementation

//------------------------------------------------------------------------------
//Desc:添加系统表项
procedure AddSysTableItem(const nTable,nNewSQL:string);
var nP: PSysTableItem;
begin
  New(nP);
  gSysTableList.Add(nP);

  nP.FTable := nTable;
  nP.FNewSQL := nNewSQL;
end;

//Desc:系统表
procedure InitSysTableList;
begin
  gSysTableList := TList.Create;

  AddSysTableItem(sTable_SysDict, sSQL_NewSysDict);
  AddSysTableItem(sTable_ExtInfo, sSQL_NewExtInfo);
  AddSysTableItem(sTable_SysLog, sSQL_NewSysLog);
  AddSysTableItem(sTable_BaseInfo, sSQL_NewBaseInfo);

  AddSysTableItem(sTable_Customer, sSQL_NewCustomer);
  AddSysTableItem(sTable_Salesman, sSQL_NewSalesMan);
  AddSysTableItem(sTable_SaleContract, sSQL_NewSaleContract);
  AddSysTableItem(sTable_SContractExt, sSQL_NewSContractExt);

  AddSysTableItem(sTable_ZhiKa, sSQL_NewZhiKa);
  AddSysTableItem(sTable_ZhiKaDtl, sSQL_NewZhiKaDtl);
  AddSysTableItem(sTable_ZhiKaCard, sSQL_NewZhiKaCard);

  AddSysTableItem(sTable_Bill, sSQL_NewBill);
  AddSysTableItem(sTable_ReturnGoods, sSQL_NewReturnGoods);

  AddSysTableItem(sTable_StockParam, sSQL_NewStockParam);
  AddSysTableItem(sTable_StockParamExt, sSQL_NewStockRecord);
  AddSysTableItem(sTable_StockRecord, sSQL_NewStockRecord);
  AddSysTableItem(sTable_StockHuaYan, sSQL_NewStockHuaYan);

  AddSysTableItem(sTable_CusAccount, sSQL_NewCusAccount);
  AddSysTableItem(sTable_InOutMoney, sSQL_NewInOutMoney);
  AddSysTableItem(sTable_CusCredit, sSQL_NewCusCredit);
  AddSysTableItem(sTable_Invoice, sSQL_NewInvoice);
  AddSysTableItem(sTable_InvoiceDtl, sSQL_NewInvoiceDtl);
  
  AddSysTableItem(sTable_SysShouJu, sSQL_NewSysShouJu);
  AddSysTableItem(sTable_Truck, sSQL_NewTruck);
  AddSysTableItem(sTable_TruckLog, sSQL_NewTruckLog);
  AddSysTableItem(sTable_TruckLogExt, sSQL_NewTruckLogExt);
  AddSysTableItem(sTable_TruckJS, sSQL_NewTruckJS);

  AddSysTableItem(sTable_Provider, sSQL_NewProvider);
  AddSysTableItem(sTable_ProvideCard, sSQL_NewProvideCard);
  AddSysTableItem(sTable_ProvideLog, sSQL_NewProvideLog);
  AddSysTableItem(sTable_Materails, sSQL_NewMaterails);
end;

//Desc:清理系统表
procedure ClearSysTableList;
var nIdx: integer;
begin
  for nIdx:= gSysTableList.Count - 1 downto 0 do
  begin
    Dispose(PSysTableItem(gSysTableList[nIdx]));
    gSysTableList.Delete(nIdx);
  end;

  FreeAndNil(gSysTableList);
end;

initialization
  InitSysTableList;
finalization
  ClearSysTableList;
end.



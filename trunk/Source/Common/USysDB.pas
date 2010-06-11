{*******************************************************************************
  ����: dmzn@163.com 2008-08-07
  ����: ϵͳ���ݿⳣ������

  ��ע:
  *.�Զ�����SQL���,֧�ֱ���:$Inc,����;$Float,����;$Integer=sFlag_Integer;
    $Decimal=sFlag_Decimal;$Image,��������
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
  //ϵͳ����

var
  gSysTableList: TList = nil;                        //ϵͳ������
  gSysDBType: TSysDatabaseType = dtSQLServer;        //ϵͳ��������

//------------------------------------------------------------------------------
const
  //�����ֶ�
  sField_Access_AutoInc          = 'Counter';
  sField_SQLServer_AutoInc       = 'Integer IDENTITY (1,1) PRIMARY KEY';

  //С���ֶ�
  sField_Access_Decimal          = 'Float';
  sField_SQLServer_Decimal       = 'Decimal(15, 5)';

  //ͼƬ�ֶ�
  sField_Access_Image            = 'OLEObject';
  sField_SQLServer_Image         = 'Image';

  //�������
  sField_SQLServer_Now           = 'getDate()';

ResourceString     
  {*Ȩ����*}
  sPopedom_Read       = 'A';                         //���
  sPopedom_Add        = 'B';                         //���
  sPopedom_Edit       = 'C';                         //�޸�
  sPopedom_Delete     = 'D';                         //ɾ��
  sPopedom_Preview    = 'E';                         //Ԥ��
  sPopedom_Print      = 'F';                         //��ӡ
  sPopedom_Export     = 'G';                         //����

  {*��ر��*}
  sFlag_Yes           = 'Y';                         //��
  sFlag_No            = 'N';                         //��
  sFlag_Enabled       = 'Y';                         //����
  sFlag_Disabled      = 'N';                         //����

  sFlag_Integer       = 'I';                         //����
  sFlag_Decimal       = 'D';                         //С��

  sFlag_Provide       = 'P';                         //��Ӧ
  sFlag_Sale          = 'S';                         //����
  
  sFlag_TiHuo         = 'T';                         //����
  sFlag_SongH         = 'S';                         //�ͻ�
  sFlag_XieH          = 'X';                         //��ж

  sFlag_TruckNone     = 'N';                         //��״̬����
  sFlag_TruckIn       = 'I';                         //��������
  sFlag_TruckOut      = 'O';                         //��������
  sFlag_TruckBFP      = 'P';                         //����Ƥ�س���
  sFlag_TruckBFM      = 'M';                         //����ë�س���
  sFlag_TruckSH       = 'S';                         //�ͻ�����
  sFlag_TruckFH       = 'F';                         //�Żҳ���
  sFlag_TruckZT       = 'Z';                         //ջ̨����

  sFlag_CardIdle      = 'I';                         //���п�
  sFlag_CardUsed      = 'U';                         //ʹ����
  sFlag_CardLoss      = 'L';                         //��ʧ��
  sFlag_CardInvalid   = 'N';                         //ע����

  sFlag_Dai           = 'D';                         //��װˮ��
  sFlag_San           = 'S';                         //ɢװˮ��

  sFlag_MoneyHuiKuan  = 'R';                         //�ؿ����
  sFlag_MoneyJiaCha   = 'C';                         //���ɼ۲�
  sFlag_MoneyZhiKa    = 'Z';                         //ֽ���ؿ�
  sFlag_MoneyFanHuan  = 'H';                         //�����û�

  sFlag_InvNormal     = 'N';                         //������Ʊ
  sFlag_InvHasUsed    = 'U';                         //���÷�Ʊ
  sFlag_InvInvalid    = 'V';                         //���Ϸ�Ʊ

  sFlag_SysParam      = 'SysParam';                  //ϵͳ����
  sFlag_ZhiKaVerify   = 'ZhiKaVerify';               //ֽ�����
  sFlag_AutoP24H      = 'AutoP_24H';                 //�Զ�����
  sFlag_WuCha         = 'WeightWuCha';               //�������
  sFlag_JiaoBan       = 'JiaoBanTime';               //����ʱ��
  sFlag_HYValue       = 'HYMaxValue';                //����������
  sFlag_AutoOut       = 'AutoO_Truck';               //�Զ�����

  sFlag_CardItem      = 'CardItem';                  //�ſ���Ϣ��
  sFlag_AreaItem      = 'AreaItem';                  //������Ϣ��
  sFlag_CustomerItem  = 'CustomerItem';              //�ͻ���Ϣ��
  sFlag_BankItem      = 'BankItem';                  //������Ϣ��
  sFlag_StockItem     = 'StockItem';                 //ˮ����Ϣ��
  sFlag_ContractItem  = 'ContractItem';              //��ͬ��Ϣ��
  sFlag_SalesmanItem  = 'SalesmanItem';              //ҵ��Ա��Ϣ��
  sFlag_ZhiKaItem     = 'ZhiKaItem';                 //ֽ����Ϣ��

  sFlag_PaymentItem   = 'PaymentItem';               //���ʽ��Ϣ��
  sFlag_PaymentItem2  = 'PaymentItem2';              //���ۻؿ���Ϣ��
  sFlag_LadingItem    = 'LadingItem';                //�����ʽ��Ϣ��

  sFlag_ProviderItem  = 'ProviderItem';              //��Ӧ����Ϣ��
  sFlag_MaterailsItem = 'MaterailsItem';             //ԭ������Ϣ��

  {*���ݱ�*}
  sTable_Group        = 'Sys_Group';                 //�û���
  sTable_User         = 'Sys_User';                  //�û���
  sTable_Menu         = 'Sys_Menu';                  //�˵���
  sTable_Popedom      = 'Sys_Popedom';               //Ȩ�ޱ�
  sTable_PopItem      = 'Sys_PopItem';               //Ȩ����
  sTable_Entity       = 'Sys_Entity';                //�ֵ�ʵ��
  sTable_DictItem     = 'Sys_DataDict';              //�ֵ���ϸ

  sTable_SysDict      = 'Sys_Dict';                  //ϵͳ�ֵ�
  sTable_ExtInfo      = 'Sys_ExtInfo';               //������Ϣ
  sTable_SysLog       = 'Sys_EventLog';              //ϵͳ��־
  sTable_BaseInfo     = 'Sys_BaseInfo';              //������Ϣ

  sTable_Customer     = 'S_Customer';                //�ͻ���Ϣ
  sTable_Salesman     = 'S_Salesman';                //ҵ����Ա
  sTable_SaleContract = 'S_Contract';                //���ۺ�ͬ
  sTable_SContractExt = 'S_ContractExt';             //��ͬ��չ

  sTable_ZhiKa        = 'S_ZhiKa';                   //ֽ������
  sTable_ZhiKaDtl     = 'S_ZhiKaDtl';                //ֽ����ϸ
  sTable_ZhiKaCard    = 'S_ZhiKaCard';               //ֽ���ſ�
  sTable_Bill         = 'S_Bill';                    //�����

  sTable_TruckJS      = 'S_TruckJS';                 //װ������
  sTable_ReturnGoods  = 'S_ReturnGoods';             //�����˻�

  sTable_StockParam   = 'S_StockParam';              //Ʒ�ֲ���
  sTable_StockParamExt= 'S_StockParamExt';           //������չ
  sTable_StockRecord  = 'S_StockRecord';             //�����¼
  sTable_StockHuaYan  = 'S_StockHuaYan';             //�����鵥

  sTable_CusAccount   = 'Sys_CustomerAccount';       //�ͻ��˻�
  sTable_InOutMoney   = 'Sys_CustomerInOutMoney';    //�ʽ���ϸ
  sTable_CusCredit    = 'Sys_CustomerCredit';        //�ͻ�����

  sTable_Invoice      = 'Sys_Invoice';               //��Ʊ�б�
  sTable_InvoiceDtl   = 'Sys_InvoiceDetail';         //��Ʊ��ϸ
  sTable_SysShouJu    = 'Sys_ShouJu';                //�վݼ�¼

  sTable_Truck        = 'Sys_Truck';                 //������
  sTable_TruckLog     = 'Sys_TruckLog';              //������־
  sTable_TruckLogExt  = 'Sys_TruckLogExt';           //��־��չ

  sTable_Provider     = 'P_Provider';                //��Ӧ��
  sTable_Materails    = 'P_Materails';               //ԭ����
  sTable_ProvideCard  = 'P_ProvideCard';             //�����ſ�
  sTable_ProvideLog   = 'P_ProvideLog';              //��Ӧ��¼

  {*�½���*}
  sSQL_NewSysDict = 'Create Table $Table(D_ID $Inc, D_Name varChar(15),' +
       'D_Desc varChar(30), D_Value varChar(50), D_Memo varChar(20),' +
       'D_ParamA $Float, D_ParamB varChar(50), D_Index Integer Default 0)';
  {-----------------------------------------------------------------------------
   ϵͳ�ֵ�: SysDict
   *.D_ID: ���
   *.D_Name: ����
   *.D_Desc: ����
   *.D_Value: ȡֵ
   *.D_Memo: �����Ϣ
   *.D_ParamA: �������
   *.D_ParamB: �ַ�����
   *.D_Index: ��ʾ����
  -----------------------------------------------------------------------------}
  
  sSQL_NewExtInfo = 'Create Table $Table(I_ID $Inc, I_Group varChar(20),' +
       'I_ItemID varChar(20), I_Item varChar(30), I_Info varChar(500),' +
       'I_ParamA $Float, I_ParamB varChar(50), I_Index Integer Default 0)';
  {-----------------------------------------------------------------------------
   ��չ��Ϣ��: ExtInfo
   *.I_ID: ���
   *.I_Group: ��Ϣ����
   *.I_ItemID: ��Ϣ��ʶ
   *.I_Item: ��Ϣ��
   *.I_Info: ��Ϣ����
   *.I_ParamA: �������
   *.I_ParamB: �ַ�����
   *.I_Memo: ��ע��Ϣ
   *.I_Index: ��ʾ����
  -----------------------------------------------------------------------------}
  
  sSQL_NewSysLog = 'Create Table $Table(L_ID $Inc, L_Date DateTime,' +
       'L_Man varChar(32),L_Group varChar(20), L_ItemID varChar(20),' +
       'L_KeyID varChar(20), L_Event varChar(220))';
  {-----------------------------------------------------------------------------
   ϵͳ��־: SysLog
   *.L_ID: ���
   *.L_Date: ��������
   *.L_Man: ������
   *.L_Group: ��Ϣ����
   *.L_ItemID: ��Ϣ��ʶ
   *.L_KeyID: ������ʶ
   *.L_Event: �¼�
  -----------------------------------------------------------------------------}

  sSQL_NewBaseInfo = 'Create Table $Table(B_ID $Inc, B_Group varChar(15),' +
       'B_Text varChar(100), B_Py varChar(25), B_Memo varChar(50),' +
       'B_PID Integer, B_Index Float)';
  {-----------------------------------------------------------------------------
   ������Ϣ��: BaseInfo
   *.B_ID: ���
   *.B_Group: ����
   *.B_Text: ����
   *.B_Py: ƴ����д
   *.B_Memo: ��ע��Ϣ
   *.B_PID: �ϼ��ڵ�
   *.B_Index: ����˳��
  -----------------------------------------------------------------------------}

  sSQL_NewSalesMan = 'Create Table $Table(R_ID $Inc, S_ID varChar(15),' +
       'S_Name varChar(30), S_PY varChar(30), S_Phone varChar(20),' +
       'S_Area varChar(50), S_InValid Char(1), S_Memo varChar(50))';
  {-----------------------------------------------------------------------------
   ҵ��Ա��: SalesMan
   *.R_ID: ��¼��
   *.S_ID: ���
   *.S_Name: ����
   *.S_PY: ��ƴ
   *.S_Phone: ��ϵ��ʽ
   *.S_Area:��������
   *.S_InValid: ����Ч
   *.S_Memo: ��ע
  -----------------------------------------------------------------------------}

  sSQL_NewCustomer = 'Create Table $Table(R_ID $Inc, C_ID varChar(15), ' +
       'C_Name varChar(80), C_PY varChar(80), C_Addr varChar(100), ' +
       'C_FaRen varChar(50), C_LiXiRen varChar(50),' +
       'C_Phone varChar(15), C_Fax varChar(15), C_Tax varChar(32),' +
       'C_Bank varChar(35), C_Account varChar(18), C_SaleMan varChar(15),' +
       'C_Memo varChar(50), C_XuNi Char(1))';
  {-----------------------------------------------------------------------------
   �ͻ���Ϣ��: Customer
   *.R_ID: ��¼��
   *.C_ID: ���
   *.C_Name: ����
   *.C_PY: ƴ����д
   *.C_Addr: ��ַ
   *.C_FaRen: ����
   *.C_LiXiRen: ��ϵ��
   *.C_Phone: �绰
   *.C_Fax: ����
   *.C_Tax: ˰��
   *.C_Bank: ������
   *.C_Account: �ʺ�
   *.C_SaleMan: ҵ��Ա
   *.C_Memo: ��ע��Ϣ
   *.C_XuNi: ����(��ʱ)�ͻ�
  -----------------------------------------------------------------------------}
  
  sSQL_NewCusAccount = 'Create Table $Table(A_ID $Inc, A_CID varChar(15),' +
       'A_Used Char(1), A_InMoney Decimal(15,5) Default 0,' +
       'A_OutMoney Decimal(15,5) Default 0, A_DebtMoney Decimal(15,5) Default 0,' +
       'A_Compensation Decimal(15,5) Default 0,' +
       'A_FreezeMoney Decimal(15,5) Default 0,' +
       'A_CreditLimit Decimal(15,5) Default 0, A_Date DateTime)';
  {-----------------------------------------------------------------------------
   �ͻ��˻�:CustomerAccount
   *.A_ID:��¼���
   *.A_CID:�ͻ���
   *.A_Used:��;(��Ӧ,����)
   *.A_InMoney:���
   *.A_OutMoney:����
   *.A_DebtMoney:Ƿ��
   *.A_Compensation:������
   *.A_FreezeMoney:�����ʽ�
   *.A_CreditLimit:���ö��
   *.A_Date:��������

   *.ˮ����������
     A_InMoney:�ͻ������˻��Ľ��
     A_OutMoney:�ͻ�ʵ�ʻ��ѵĽ��
     A_DebtMoney:��δ֧���Ľ��
     A_Compensation:���ڲ���˻����ͻ��Ľ��
     A_FreezeMoney:�Ѱ�ֽ����δ��������Ľ��
     A_CreditLimit:���Ÿ��û�����߿�Ƿ����

     ������� = ��� + ���ö� - ���� - ������ - �Ѷ���
     �����ܶ� = ���� + Ƿ�� + �Ѷ���
  -----------------------------------------------------------------------------}

  sSQL_NewInOutMoney = 'Create Table $Table(M_ID $Inc, M_SaleMan varChar(15),' +
       'M_CusID varChar(15), M_CusName varChar(80), ' +
       'M_Type Char(1), M_Payment varChar(20),' +
       'M_Money Decimal(15,5), M_ZID varChar(15), M_Date DateTime,' +
       'M_Man varChar(32), M_Memo varChar(200))';
  {-----------------------------------------------------------------------------
   �������ϸ:CustomerInOutMoney
   *.M_ID:��¼���
   *.M_SaleMan:ҵ��Ա
   *.M_CusID:�ͻ���
   *.M_CusName:�ͻ���
   *.M_Type:����(����,�ؿ��)
   *.M_Payment:���ʽ
   *.M_Money:���ɽ��
   *.M_ZID:ֽ����
   *.M_Date:��������
   *.M_Man:������
   *.M_Memo:����

   *.ˮ�����������
     ��� = ���� x ���� + ����
  -----------------------------------------------------------------------------}

  sSQL_NewSysShouJu = 'Create Table $Table(R_ID $Inc ,S_Code varChar(15),' +
       'S_Sender varChar(100), S_Reason varChar(100), S_Money Decimal(15,5),' +
       'S_BigMoney varChar(50), S_Bank varChar(35), S_Man varChar(32),' +
       'S_Date DateTime, S_Memo varChar(50))';
  {-----------------------------------------------------------------------------
   �վ���ϸ:ShouJu
   *.R_ID:���
   *.S_Code:����ƾ������
   *.S_Sender:����(��Դ)
   *.S_Reason:����(����)
   *.S_Money:���
   *.S_Bank:����
   *.S_Man:����Ա
   *.S_Date:����
   *.S_Memo:��ע
  -----------------------------------------------------------------------------}

  sSQL_NewCusCredit = 'Create Table $Table(C_ID $Inc ,C_CusID varChar(15),' +
       'C_Money Decimal(15,5), C_Man varChar(32),' +
       'C_Date DateTime, C_Memo varChar(50))';
  {-----------------------------------------------------------------------------
   ������ϸ:CustomerCredit
   *.C_ID:���
   *.C_CusID:�ͻ����
   *.C_Money:���Ŷ�
   *.C_Man:������
   *.C_Date:����
   *.C_Memo:��ע
  -----------------------------------------------------------------------------}

  sSQL_NewSaleContract = 'Create Table $Table(C_ID varChar(15),' +
       'C_Project varChar(100),C_SaleMan varChar(15), C_Customer varChar(15),' +
       'C_Date varChar(20), C_Area varChar(50), C_Addr varChar(50),' +
       'C_Delivery varChar(50), C_Payment varChar(20), C_Approval varChar(30),' +
       'C_ZKDays Integer, C_XuNi Char(1), C_Freeze Char(1), C_Memo varChar(50))';
  {-----------------------------------------------------------------------------
   ���ۺ�ͬ: SalesContract
   *.C_ID: ���
   *.C_Project: ��Ŀ����
   *.C_SaleMan: ������Ա
   *.C_Customer: �ͻ�
   *.C_Date: ǩ��ʱ��
   *.C_Area: ��������
   *.C_Addr: ǩ���ص�
   *.C_Delivery: ������
   *.C_Payment: ���ʽ
   *.C_Approval: ��׼��
   *.C_ZKDays: ֽ����Ч��
   *.C_XuNi: �����ͬ
   *.C_Freeze: �Ƿ񶳽�
   *.C_Memo: ��ע��Ϣ
  -----------------------------------------------------------------------------}

  sSQL_NewSContractExt = 'Create Table $Table(E_ID $Inc,' +
       'E_CID varChar(15), E_Type Char(1), E_Stock varChar(30),' +
       'E_Value Decimal(15,5), E_Price Decimal(15,5), E_Money Decimal(15,5))';
  {-----------------------------------------------------------------------------
   ���ۺ�ͬ: SalesContract
   *.E_ID: ��¼���
   *.E_CID: ���ۺ�ͬ
   *.E_Type: ����(��,ɢ)
   *.E_Stock: ˮ������
   *.E_Value: ����
   *.E_Price: ����
   *.E_Money: ���
  -----------------------------------------------------------------------------}

  sSQL_NewZhiKa = 'Create Table $Table(R_ID $Inc, Z_ID varChar(15),' +
       'Z_CID varChar(15), Z_Project varChar(100), Z_Custom varChar(15),' +
       'Z_SaleMan varChar(15), Z_Payment varChar(20), Z_Lading Char(1),' +
       'Z_ValidDays DateTime, Z_Password varChar(16), Z_OnlyPwd Char(1),' +
       'Z_Verified Char(1), Z_InValid Char(1), Z_Freeze Char(1),' +
       'Z_YFMoney $Float, Z_FixedMoney $Float, Z_OnlyMoney Char(1),' +
       'Z_Memo varChar(200),Z_Man varChar(32), Z_Date DateTime)';
  {-----------------------------------------------------------------------------
   ֽ������: ZhiKa
   *.R_ID:��¼���
   *.Z_ID:ֽ����
   *.Z_CID:���ۺ�ͬ
   *.Z_Project:��Ŀ����
   *.Z_Custom:�ͻ����
   *.Z_SaleMan:ҵ��Ա
   *.Z_Payment:���ʽ
   *.Z_Lading:�����ʽ(����,�ͻ�)
   *.Z_ValidDays:��Ч��
   *.Z_Password: ����
   *.Z_OnlyPwd: ͳһ����
   *.Z_Verified:�����
   *.Z_InValid:����Ч
   *.Z_Freeze:�Ѷ���
   *.Z_YFMoney:Ԥ�����
   *.Z_FixedMoney:���ý�
   *.Z_OnlyMoney:ֻʹ�ÿ��ý�
   *.Z_Man:������
   *.Z_Date:����ʱ��
  -----------------------------------------------------------------------------}

  sSQL_NewZhiKaDtl = 'Create Table $Table(R_ID $Inc, D_ZID varChar(15),' +
       'D_Type Char(1), D_Stock varChar(30), D_Price $Float, D_Value $Float)';
  {-----------------------------------------------------------------------------
   ֽ����ϸ:ZhiKaDtl
   *.R_ID:��¼���
   *.D_ZID:ֽ����
   *.D_Type:����(��,ɢ)
   *.D_Stock:ˮ������
   *.D_Price:����
   *.D_Value:������
  -----------------------------------------------------------------------------}

  sSQL_NewZhiKaCard = 'Create Table $Table(R_ID $Inc, C_ZID varChar(15),' +
       'C_Card varChar(30), C_Password varChar(16), C_OwnerID varChar(15),' +
       'C_Used Char(1), C_Status Char(1),C_IsFreeze Char(1),' +
       'C_Man varChar(32), C_Date DateTime, C_Memo varChar(50))';
  {-----------------------------------------------------------------------------
   ֽ���ſ�:ZhiKaCard
   *.R_ID:��¼���
   *.C_ZID:ֽ����
   *.C_Card:����
   *.C_Password: ����
   *.C_OwnerID:�����˱�ʶ
   *.C_Used:��;(��Ӧ,����)
   *.C_Status:״̬(����,ʹ��,ע��,��ʧ)   
   *.C_IsFreeze:�Ƿ񶳽�
   *.C_Man:������
   *.C_Date:����ʱ��
   *.C_Memo:��ע��Ϣ
  -----------------------------------------------------------------------------}

  sSQL_NewBill = 'Create Table $Table(R_ID $Inc, L_ID varChar(15),' +
       'L_ZID varChar(15), L_Custom varChar(15), L_SaleMan varChar(15),' +
       'L_TruckNo varChar(15),L_Type Char(1), L_Stock varChar(30),' +
       'L_Value $Float, L_Price $Float,L_ZKMoney Char(1), L_Card varChar(32),' +
       'L_Lading Char(1),L_Man varChar(32),L_Date DateTime,L_IsDone Char(1),' +
       'L_OKDate DateTime)';
  {-----------------------------------------------------------------------------
   �����:Bill
   *.L_ID:�������
   *.L_ZID:ֽ�����
   *.L_Custom:�ͻ�
   *.L_SaleMan:ҵ��Ա
   *.L_TruckNo:����
   *.L_Type:����(��,ɢ)
   *.L_Stock:ˮ������
   *.L_Value:����
   *.L_Price:����
   *.L_ZKMoney:��ֽ�����
   *.L_Card:����ſ�
   *.L_Lading:�����ʽ(����,�ͻ�)
   *.L_Man:������
   *.L_Date:����ʱ��
   *.L_IsDone:���
   *.L_OKDate:���ʱ��
  -----------------------------------------------------------------------------}

  sSQL_NewReturnGoods = 'Create Table $Table(R_ID $Inc, R_ZID varChar(15),' +
       'R_Value Decimal(15,5), R_Price Decimal(15,5), R_Man varChar(32),' +
       'R_Date DateTime, R_Memo varChar(50))';
  {-----------------------------------------------------------------------------
   �˹�:ReturnGoods
   *.R_ID:��¼���
   *.R_ZID:ֽ�����
   *.R_Value:����
   *.R_Price:����
   *.R_Man:������
   *.R_Date:����ʱ��
   *.R_Memo:��ע
  -----------------------------------------------------------------------------}

  sSQL_NewTruck = 'Create Table $Table(T_ID varChar(15))';
  {-----------------------------------------------------------------------------
   ������Ϣ:Truck
   *.T_ID:����
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
   ������־:TruckLog
   *.T_ID:��¼���
   *.T_Truck:���ƺ�
   *.T_Status,T_NextStatus:״̬
   *.T_InTime,T_InMan:����ʱ��,������
   *.T_OutTime,T_OutMan:����ʱ��,������
   *.T_BFPTime,T_BFPMan,T_BFPValue:Ƥ��ʱ��,������,Ƥ��
   *.T_BFMTime,T_BFMMan,T_BFMValue:ë��ʱ��,������,ë��
   *.T_FHSTime,T_FHETime,
     T_FHLenth,T_FHMan,T_FHValue:��ʼʱ��,����ʱ��,ʱ��������,�Ż���
   *.T_ZTTime,T_ZTMan,
     T_ZTValue,T_ZTCount,T_ZTDiff:ջ̨ʱ��,������,�����,����,����
   *.T_YSTime,T_YSMan,T_Acceptance,
     T_AcceptMemo,T_Deduct:����ʱ��,������,���,��ע,����
  -----------------------------------------------------------------------------}

  sSQL_NewTruckLogExt = 'Create Table $Table(E_ID $Inc, E_TID varChar(15),' +
       'E_Truck varChar(15), E_Card varChar(32), ' +
       'E_Used Char(1), E_ZID varChar(15), E_Bill varChar(15),' +
       'E_Price $Float, E_Value $Float, E_StockNo varChar(15),' +
       'E_ZTLine varChar(50), E_DaiShu Integer, E_BC Integer, E_IsHK Char(1),' +
       'E_HyID Integer)';
  {-----------------------------------------------------------------------------
   ������־��չ:TruckLogExt
   *.E_ID:��¼���
   *.E_TID:������־
   *.E_Truck:���ƺ�
   *.E_Card:�ſ���
   *.E_Used:��;(��Ӧ,����)
   *.E_ZID:ֽ����
   *.E_Bill:�������¼
   *.E_Price:����۸�
   *.E_Value:������Чֵ
   *.E_StockNo:ˮ����
   *.E_ZTLine:ջ̨λ��
   *.E_DaiShu:�������
   *.E_BC:�������
   *.E_IsHK:�Ƿ�Ͽ�
   *.E_HyID:���鵥
  -----------------------------------------------------------------------------}

  sSQL_NewTruckJS = 'Create Table $Table(J_ID $Inc, J_Truck varChar(15),' +
                 'J_Stock varChar(30), J_Value $Float, J_DaiShu Integer,' +
                 'J_BuCha Integer, J_Bill varChar(200), J_Date DateTime)';
  {-----------------------------------------------------------------------------
   ջ̨װ������: TruckJS
   *.J_ID: ��¼���
   *.J_Truck: ���ƺ�
   *.J_Stock: ˮ��Ʒ��
   *.J_Value: �����
   *.J_DaiShu: װ������
   *.J_BuCha: �������
   *.J_Bill: ������б�
   *.J_Date: װ������
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
   Ʒ�ֲ���:StockParam
   *.P_ID:��¼���
   *.P_Stock:Ʒ��
   *.P_Type:����(��,ɢ)
   *.P_Name:�ȼ���
   *.P_QLevel:ǿ�ȵȼ�
   *.P_Memo:��ע
   *.P_MgO:����þ
   *.P_SO3:��������
   *.P_ShaoShi:��ʧ��
   *.P_CL:������
   *.P_BiBiao:�ȱ����
   *.P_ChuNing:����ʱ��
   *.P_ZhongNing:����ʱ��
   *.P_AnDing:������
   *.P_XiDu:ϸ��
   *.P_Jian:���
   *.P_ChouDu:���
   *.P_BuRong:������
   *.P_YLiGai:�����
   *.P_3DZhe:3�쿹��ǿ��
   *.P_28DZhe:28����ǿ��
   *.P_3DYa:3�쿹ѹǿ��
   *.P_28DYa:28��ѹǿ��
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
   �����¼:StockRecord
   *.R_ID:��¼���
   *.R_SerialNo:ˮ����
   *.R_PID:Ʒ�ֲ���
   *.R_MgO:����þ
   *.R_SO3:��������
   *.R_ShaoShi:��ʧ��
   *.R_CL:������
   *.R_BiBiao:�ȱ����
   *.R_ChuNing:����ʱ��
   *.R_ZhongNing:����ʱ��
   *.R_AnDing:������
   *.R_XiDu:ϸ��
   *.R_Jian:���
   *.R_ChouDu:���
   *.R_BuRong:������
   *.R_YLiGai:�����
   *.R_3DZhe1:3�쿹��ǿ��1
   *.R_3DZhe2:3�쿹��ǿ��2
   *.R_3DZhe3:3�쿹��ǿ��3
   *.R_28Zhe1:28����ǿ��1
   *.R_28Zhe2:28����ǿ��2
   *.R_28Zhe3:28����ǿ��3
   *.R_3DYa1:3�쿹ѹǿ��1
   *.R_3DYa2:3�쿹ѹǿ��2
   *.R_3DYa3:3�쿹ѹǿ��3
   *.R_3DYa4:3�쿹ѹǿ��4
   *.R_3DYa5:3�쿹ѹǿ��5
   *.R_3DYa6:3�쿹ѹǿ��6
   *.R_28Ya1:28��ѹǿ��1
   *.R_28Ya2:28��ѹǿ��2
   *.R_28Ya3:28��ѹǿ��3
   *.R_28Ya4:28��ѹǿ��4
   *.R_28Ya5:28��ѹǿ��5
   *.R_28Ya6:28��ѹǿ��6
   *.R_Date:ȡ������
   *.R_Man:¼����
  -----------------------------------------------------------------------------}

  sSQL_NewStockHuaYan = 'Create Table $Table(H_ID $Inc, H_Custom varChar(15),' +
       'H_CusName varChar(80), H_SerialNo varChar(15), H_Truck varChar(15),' +
       'H_Value $Float,H_BillDate DateTime, H_ReportDate DateTime,' +
       'H_Reporter varChar(32))';
  {-----------------------------------------------------------------------------
   �����鵥:StockHuaYan
   *.H_ID:��¼���
   *.H_Custom:�ͻ����
   *.H_CusName:�ͻ�����
   *.H_SerialNo:ˮ����
   *.H_Truck:�������
   *.H_Value:�����
   *.H_BillDate:�������
   *.H_ReportDate:��������
   *.H_Reporter:������
  -----------------------------------------------------------------------------}

  sSQL_NewInvoice = 'Create Table $Table(I_ID varChar(25) PRIMARY KEY,' +
       'I_Customer varChar(50), I_SaleMan varChar(50), I_Status Char(1),' +
       'I_InMan varChar(32), I_InDate DateTime, I_OutMan varChar(32),' +
       'I_OutDate DateTime, I_Memo varChar(50))';
  {-----------------------------------------------------------------------------
   ��ƱƱ��:Invoice
   *.I_ID:���
   *.I_Customer:�ͻ���
   *.I_SaleMan:ҵ��Ա
   *.I_Status:״̬
   *.I_InMan:¼����
   *.I_InDate:¼������
   *.I_OutMan:������
   *.I_OutDate:��������
   *.I_Memo:��ע
  -----------------------------------------------------------------------------}

  sSQL_NewInvoiceDtl = 'Create Table $Table(D_ID $Inc, D_Invoice varChar(25),' +
       'D_Type Char(1), D_Stock varChar(30), D_Price Decimal(15,5) Default 0,' +
       'D_Value Decimal(15,5) Default 0, D_DisCount Decimal(15,5) Default 0)';
  {-----------------------------------------------------------------------------
   ��Ʊ��ϸ:InvoiceDetail
   *.D_ID:���
   *.D_Invoice:Ʊ��
   *.D_Type:����(��,ɢ)
   *.D_Stock:Ʒ��
   *.D_Price:����
   *.D_Value:��Ʊ��
   *.D_DisCount:�ۿ۱�
  -----------------------------------------------------------------------------}

  sSQL_NewProvider = 'Create Table $Table(P_ID $Inc, P_Name varChar(80),' +
       'P_Phone varChar(20), P_Memo varChar(50))';
  {-----------------------------------------------------------------------------
   ��Ӧ��: Provider
   *.P_ID: ���
   *.P_Name: ����
   *.P_Phone: ��ϵ��ʽ
   *.P_Memo: ��ע
  -----------------------------------------------------------------------------}

  sSQL_NewMaterails = 'Create Table $Table(M_ID $Inc, M_Name varChar(30),' +
       'M_PY varChar(30), M_Unit varChar(20), M_Price $Float, M_Memo varChar(50))';
  {-----------------------------------------------------------------------------
   ԭ����: Materails
   *.M_ID: ���
   *.M_Name: ����
   *.M_PY: ƴ����д
   *.M_Unit: ��λ
   *.M_Price: ����
   *.M_Memo: ��ע
  -----------------------------------------------------------------------------}

  sSQL_NewProvideCard = 'Create Table $Table(P_ID $Inc,' +
       'P_Provider varChar(80), P_Mate varChar(30), P_Card varChar(30),' +
       'P_Owner varChar(32), P_Man varChar(32), P_Date DateTime, ' +
       'P_Memo varChar(50), P_Status Char(1))';
  {-----------------------------------------------------------------------------
   �����ſ�: ProvideCard
   *.P_ID: ���
   *.P_Provider: ��Ӧ��
   *.P_Mate: ԭ����
   *.P_Card: �ſ���
   *.P_Owner: ������
   *.P_Man: ������
   *.P_Date: ����ʱ��
   *.P_Status: ״̬(����,��Ч��)
  -----------------------------------------------------------------------------}

  sSQL_NewProvideLog = 'Create Table $Table(L_ID $Inc, L_Provider varChar(80),' +
       'L_Mate varChar(30), L_Unit varChar(20), L_Truck varChar(15), ' +
       'L_PValue $Float, L_PMan varChar(32), L_PDate DateTime, ' +
       'L_MValue $Float, L_MMan varChar(32), L_MDate DateTime, ' +
       'L_YValue $Float, L_YMan varChar(32), L_YDate DateTime, ' +
       'L_Card varChar(30), L_Price $Float, L_PrintNum Integer,' +
       'L_Memo varChar(50))';
  {-----------------------------------------------------------------------------
   ������¼: ProvideLog
   *.L_ID: ���
   *.L_Provider: ��Ӧ��
   *.L_Mate: ԭ����
   *.L_Unit: ��λ
   *.L_Truck: ���ƺ�
   *.L_PValue,L_PMan,L_PDate: Ƥ��,����Ա,ʱ��
   *.L_MValue,L_MMan,L_MDate: ë��,����Ա,ʱ��
   *.L_YValue,L_YMan,L_YDate: ����,������,ʱ��
   *.L_Price: ����
   *.L_Card: �ſ���
   *.L_PrintNum: ��ӡ����
   *.L_Memo: ��ע��Ϣ
  -----------------------------------------------------------------------------}

//------------------------------------------------------------------------------
// ���ݲ�ѯ
//------------------------------------------------------------------------------
  sQuery_SysDict = 'Select D_ID, D_Value, D_Memo From $Table ' +
                   'Where D_Name=''$Name'' Order By D_Index ASC';
  {-----------------------------------------------------------------------------
   �������ֵ��ȡ����
   *.$Table:�����ֵ��
   *.$Name:�ֵ�������
  -----------------------------------------------------------------------------}

  sQuery_ExtInfo = 'Select I_ID, I_Item, I_Info From $Table Where ' +
                   'I_Group=''$Group'' and I_ItemID=''$ID'' Order By I_Index Desc';
  {-----------------------------------------------------------------------------
   ����չ��Ϣ���ȡ����
   *.$Table:��չ��Ϣ��
   *.$Group:��������
   *.$ID:��Ϣ��ʶ
  -----------------------------------------------------------------------------}

implementation

//------------------------------------------------------------------------------
//Desc:���ϵͳ����
procedure AddSysTableItem(const nTable,nNewSQL:string);
var nP: PSysTableItem;
begin
  New(nP);
  gSysTableList.Add(nP);

  nP.FTable := nTable;
  nP.FNewSQL := nNewSQL;
end;

//Desc:ϵͳ��
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

//Desc:����ϵͳ��
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



{*******************************************************************************
  ����: dmzn@ylsoft.com 2007-10-09
  ����: ��Ŀͨ�ó�,�������嵥Ԫ
*******************************************************************************}
unit USysConst;

interface

uses
  SysUtils, Classes, ComCtrls;

const
  cSBar_Date            = 0;                         //�����������
  cSBar_Time            = 1;                         //ʱ���������
  cSBar_User            = 2;                         //�û��������
  cRecMenuMax           = 5;                         //���ʹ�õ����������Ŀ��
  
  cPrecision            = 100;                       //���㾫��
  {-----------------------------------------------------------------------------
   ����:
   *.����Ϊ�ֵļ�����,С��ֵ�Ƚϻ����������ʱ�������,���Ի��ȷŴ�,ȥ��
     С��λ������������.�Ŵ����ɾ���ֵȷ��.
  -----------------------------------------------------------------------------}

  cShouJuIDLength       = 7;                         //�����վݱ�ʶ����
  cItemIconIndex        = 11;                        //Ĭ�ϵ�������б�ͼ��                           

const
  {*Frame ID*}
  cFI_FrameSysLog       = $0001;                     //ϵͳ��־
  cFI_FrameViewLog      = $0002;                     //������־

  cFI_FrameCustomer     = $0004;                     //�ͻ�����
  cFI_FrameSalesMan     = $0005;                     //ҵ��Ա����
  cFI_FrameSaleContract = $0006;                     //���ۺ�ͬ
  cFI_FrameZhiKa        = $0007;                     //����ֽ��
  cFI_FrameZhiKaCard    = $0008;                     //����ſ�
  cFI_FrameMakeCard     = $0012;                     //����ſ�
  cFI_FrameBill         = $0013;                     //�������
  cFI_FrameTruckQuery   = $0015;                     //������ѯ
  cFI_FrameLadingDai    = $0016;                     //��װ���
  cFI_FramePoundQuery   = $0017;                     //������ѯ
  cFI_FrameYanShouQuery = $0018;                     //���ղ�ѯ
  cFI_FrameFangHuiQuery = $0019;                     //�ŻҲ�ѯ
  cFI_FrameZhanTaiQuery = $0020;                     //ջ̨��ѯ
  cFI_FrameZhanTaiJSQuery = $0120;                   //������ѯ
  cFI_FrameTuiGouQuery  = $0021;                     //���۲�ѯ

  cFI_FrameStock        = $0022;                     //Ʒ�ֹ���
  cFI_FrameStockRecord  = $0023;                     //�����¼
  cFI_FrameStockHuaYan  = $0025;                     //�����鵥
  cFI_FrameShouJu       = $0026;                     //�վݲ�ѯ

  cFI_FrameZhiKaVerify  = $0051;                     //ֽ�����
  cFI_FramePayment      = $0052;                     //���ۻؿ�
  cFI_FramePaymentC     = $0053;                     //���ɲ��

  cFI_FrameTruckQuery2  = $0055;                     //������ѯ
  cFI_FrameCusAccountQuery = $0056;                  //�ͻ��˻�
  cFI_FrameCusInOutMoney   = $0057;                  //�������ϸ

  cFI_FrameSaleTotalQuery  = $0058;                  //�ۼƷ���
  cFI_FrameSaleDetailQuery = $0059;                  //������ϸ
  cFI_FrameSaleZhiKaQuery  = $0060;                  //�û�ҵ��

  cFI_FrameSaleInvoice  = $0061;                     //��Ʊ����
  cFI_FrameMakeInvoice  = $0062;                     //���߷�Ʊ
  cFI_FrameCusCredit    = $0063;                     //���ù���
  cFI_FrameZhiKaDetail  = $0065;                     //ֽ����ϸ

  cFI_FrameProvider     = $0102;                     //��Ӧ��
  cFI_FrameProvideCard  = $0103;                     //�ſ�
  cFI_FrameProvideLog   = $0105;                     //��Ӧ��־
  cFI_FrameMaterails    = $0106;                     //ԭ����

  cFI_FormMemo          = $1000;                     //��ע����
  cFI_FormBackup        = $1001;                     //���ݱ���
  cFI_FormRestore       = $1002;                     //���ݻָ�
  cFI_FormIncInfo       = $1003;                     //��˾��Ϣ
  cFI_FormChangePwd     = $1005;                     //�޸�����

  cFI_FormBaseInfo      = $1006;                     //������Ϣ
  cFI_FormCustomer      = $1007;                     //�ͻ�����
  cFI_FormSaleMan       = $1008;                     //ҵ��Ա
  cFI_FormSaleContract  = $1009;                     //���ۺ�ͬ
  cFI_FormZhiKa         = $1010;                     //ֽ������
  cFI_FormZhiKaParam    = $1011;                     //ֽ������
  cFI_FormZhiKaCard     = $1012;                     //ֽ���ſ�

  cFI_FormSetPassword   = $1014;                     //��������
  cFI_FormVerifyCardPwd = $1015;                     //��֤���
  cFI_FormBill          = $1016;                     //�������
  cFI_FormShouJu        = $1017;                     //���վ�
  cFI_FormZhiKaVerify   = $1018;                     //ֽ�����
  cFI_FormCusCredit     = $1019;                     //���ñ䶯
  cFI_FormPayment       = $1020;                     //���ۻؿ�
  cFI_FormTruckIn       = $1021;                     //��������
  cFI_FormTruckOut      = $1022;                     //��������
  cFI_FormVerifyCard    = $1023;                     //�ſ���֤
  cFI_FormAutoBFP       = $1024;                     //�Զ���Ƥ
  cFI_FormBangFangP     = $1025;                     //����Ƥ��
  cFI_FormBangFangM     = $1026;                     //����ë��
  cFI_FormLadDai        = $1027;                     //��װ���
  cFI_FormLadSan        = $1028;                     //ɢװ���
  cFI_FormJiShuQi       = $1029;                     //��������
  cFI_FormBFWuCha       = $1030;                     //�������
  cFI_FormZhiKaQuery    = $1031;                     //��Ƭ��Ϣ
  cFI_FormPayCustom     = $1032;                     //�����˹�
  cFI_FormZhiKaInfoExt1 = $1033;                     //ֽ����չ
  cFI_FormZhiKaInfoExt2 = $1034;                     //ֽ����չ
  cFI_FormZhiKaAdjust   = $1035;                     //ֽ������
  cFI_FormZhiKaFixMoney = $1036;                     //������
  cFI_FormSaleAdjust    = $1037;                     //���۵���
  cFI_FormDaiHeKa       = $1038;                     //��װ�Ͽ�
  cFI_FormSanHeKa       = $1039;                     //ɢװ�Ͽ�

  cFI_FormGetContract   = $1048;                     //ѡ���ͬ
  cFI_FormGetCustom     = $1049;                     //ѡ��ͻ�
  cFI_FormGetStockNo    = $1050;                     //ѡ����
  cFI_FormProvider      = $1051;                     //��Ӧ��
  cFI_FormMaterails     = $1052;                     //ԭ����
  cFI_FormProvideBF     = $1053;                     //����
  cFI_FormProvideYS     = $1054;                     //����
  cFI_FormProvideCard   = $1055;                     //��Ӧ�ſ�

  cFI_FormStockParam    = $1060;                     //Ʒ�ֹ���
  cFI_FormStockHuaYan   = $1061;                     //�����鵥

  {*Command*}
  cCmd_RefreshData      = $0002;                     //ˢ������
  cCmd_ViewSysLog       = $0003;                     //ϵͳ��־

  cCmd_ModalResult      = $1001;                     //Modal����
  cCmd_FormClose        = $1002;                     //�رմ���
  cCmd_AddData          = $1003;                     //�������
  cCmd_EditData         = $1005;                     //�޸�����
  cCmd_ViewData         = $1006;                     //�鿴����

type
  TSysParam = record
    FProgID     : string;                            //�����ʶ
    FAppTitle   : string;                            //�����������ʾ
    FMainTitle  : string;                            //���������
    FHintText   : string;                            //��ʾ�ı�
    FCopyRight  : string;                            //��������ʾ����

    FUserID     : string;                            //�û���ʶ
    FUserName   : string;                            //��ǰ�û�
    FUserPwd    : string;                            //�û�����
    FGroupID    : string;                            //������
    FIsAdmin    : Boolean;                           //�Ƿ����Ա
    FIsNormal   : Boolean;                           //�ʻ��Ƿ�����

    FRecMenuMax : integer;                           //����������
    FIconFile   : string;                            //ͼ�������ļ�
  end;
  //ϵͳ����

  TModuleItemType = (mtFrame, mtForm);
  //ģ������

  PMenuModuleItem = ^TMenuModuleItem;
  TMenuModuleItem = record
    FMenuID: string;                                 //�˵�����
    FModule: integer;                                //ģ���ʶ
    FItemType: TModuleItemType;                      //ģ������
  end;

//------------------------------------------------------------------------------
var
  gPath: string;                                     //��������·��
  gSysParam:TSysParam;                               //���򻷾�����
  gStatusBar: TStatusBar;                            //ȫ��ʹ��״̬��
  gMenuModule: TList = nil;                          //�˵�ģ��ӳ���

//------------------------------------------------------------------------------
ResourceString
  sProgID             = 'DMZN';                      //Ĭ�ϱ�ʶ
  sAppTitle           = 'DMZN';                      //�������
  sMainCaption        = 'DMZN';                      //�����ڱ���

  sHint               = '��ʾ';                      //�Ի������
  sWarn               = '����';                      //==
  sAsk                = 'ѯ��';                      //ѯ�ʶԻ���
  sError              = 'δ֪����';                  //����Ի���

  sDate               = '����:��%s��';               //����������
  sTime               = 'ʱ��:��%s��';               //������ʱ��
  sUser               = '�û�:��%s��';               //�������û�

  sLogDir             = 'Logs\';                     //��־Ŀ¼
  sLogExt             = '.log';                      //��־��չ��
  sLogField           = #9;                          //��¼�ָ���

  sImageDir           = 'Images\';                   //ͼƬĿ¼
  sReportDir          = 'Report\';                   //����Ŀ¼
  sBackupDir          = 'Backup\';                   //����Ŀ¼
  sBackupFile         = 'Bacup.idx';                 //��������

  sConfigFile         = 'Config.Ini';                //�������ļ�
  sConfigSec          = 'Config';                    //������С��
  sVerifyCode         = ';Verify:';                  //У������

  sFormConfig         = 'FormInfo.ini';              //��������
  sSetupSec           = 'Setup';                     //����С��
  sDBConfig           = 'DBConn.ini';                //��������

  sExportExt          = '.txt';                      //����Ĭ����չ��
  sExportFilter       = '�ı�(*.txt)|*.txt|�����ļ�(*.*)|*.*';
                                                     //������������ 

  sInvalidConfig      = '�����ļ���Ч���Ѿ���';    //�����ļ���Ч
  sCloseQuery         = 'ȷ��Ҫ�˳�������?';         //�������˳�
  
implementation

//------------------------------------------------------------------------------
//Desc: ��Ӳ˵�ģ��ӳ����
procedure AddMenuModuleItem(const nMenu: string; const nModule: Integer;
 const nType: TModuleItemType = mtFrame);
var nItem: PMenuModuleItem;
begin
  New(nItem);
  gMenuModule.Add(nItem);

  nItem.FMenuID := nMenu;
  nItem.FModule := nModule;
  nItem.FItemType := nType;
end;

//Desc: �˵�ģ��ӳ���
procedure InitMenuModuleList;
begin
  gMenuModule := TList.Create;

  AddMenuModuleItem('MAIN_A01', cFI_FormIncInfo, mtForm);
  AddMenuModuleItem('MAIN_A02', cFI_FrameSysLog);
  AddMenuModuleItem('MAIN_A03', cFI_FormBackup, mtForm);
  AddMenuModuleItem('MAIN_A04', cFI_FormRestore, mtForm);
  AddMenuModuleItem('MAIN_A05', cFI_FormChangePwd, mtForm);
  AddMenuModuleItem('MAIN_A06_1', cFI_FormZhiKaParam, mtForm);
  AddMenuModuleItem('MAIN_A06_2', cFI_FrameZhiKaCard);
  AddMenuModuleItem('MAIN_A06_3', cFI_FormAutoBFP, mtForm);
  AddMenuModuleItem('MAIN_A06_4', cFI_FormBFWuCha, mtForm);

  AddMenuModuleItem('MAIN_B01', cFI_FormBaseInfo, mtForm);
  AddMenuModuleItem('MAIN_B02', cFI_FrameCustomer);
  AddMenuModuleItem('MAIN_B03', cFI_FrameSalesMan);
  AddMenuModuleItem('MAIN_B04', cFI_FrameSaleContract);

  AddMenuModuleItem('MAIN_C01', cFI_FrameZhiKaVerify);
  AddMenuModuleItem('MAIN_C02', cFI_FramePayment);
  AddMenuModuleItem('MAIN_C03', cFI_FrameCusCredit);
  AddMenuModuleItem('MAIN_C07', cFI_FrameShouJu);

  AddMenuModuleItem('MAIN_D01', cFI_FormZhiKa, mtForm);
  AddMenuModuleItem('MAIN_D02', cFI_FormZhiKaCard, mtForm);
  AddMenuModuleItem('MAIN_D03', cFI_FormBill, mtForm);
  AddMenuModuleItem('MAIN_D04', cFI_FormPayCustom, mtForm);
  AddMenuModuleItem('MAIN_D05', cFI_FrameZhiKa);
  AddMenuModuleItem('MAIN_D06', cFI_FrameBill);
  AddMenuModuleItem('MAIN_D07', cFI_FrameTuiGouQuery);
  AddMenuModuleItem('MAIN_D08', cFI_FormSaleAdjust, mtForm);

  AddMenuModuleItem('MAIN_E01', cFI_FormBangFangP, mtForm);
  AddMenuModuleItem('MAIN_E02', cFI_FormBangFangM, mtForm);
  AddMenuModuleItem('MAIN_E03', cFI_FramePoundQuery);

  AddMenuModuleItem('MAIN_F01', cFI_FormLadDai, mtForm);
  AddMenuModuleItem('MAIN_F02', cFI_FormJiShuQi, mtForm);
  AddMenuModuleItem('MAIN_F03', cFI_FrameZhanTaiQuery);
  AddMenuModuleItem('MAIN_F04', cFI_FrameZhanTaiJSQuery);

  AddMenuModuleItem('MAIN_G01', cFI_FormLadSan, mtForm);
  AddMenuModuleItem('MAIN_G02', cFI_FrameFangHuiQuery);

  AddMenuModuleItem('MAIN_K01', cFI_FrameStock);
  AddMenuModuleItem('MAIN_K02', cFI_FrameStockRecord);
  AddMenuModuleItem('MAIN_K03', cFI_FrameStockHuaYan);
  AddMenuModuleItem('MAIN_K04', cFI_FormStockHuaYan, mtForm);

  AddMenuModuleItem('MAIN_L01', cFI_FrameTruckQuery2);
  AddMenuModuleItem('MAIN_L02', cFI_FrameCusAccountQuery);
  AddMenuModuleItem('MAIN_L03', cFI_FrameCusInOutMoney);
  AddMenuModuleItem('MAIN_L04', cFI_FormZhiKaQuery, mtForm);
  AddMenuModuleItem('MAIN_L05', cFI_FrameSaleZhiKaQuery);
  AddMenuModuleItem('MAIN_L06', cFI_FrameSaleDetailQuery);
  AddMenuModuleItem('MAIN_L07', cFI_FrameSaleTotalQuery);
  AddMenuModuleItem('MAIN_L08', cFI_FrameZhiKaDetail);

  AddMenuModuleItem('MAIN_H01', cFI_FormTruckIn, mtForm);
  AddMenuModuleItem('MAIN_H02', cFI_FormTruckOut, mtForm);
  AddMenuModuleItem('MAIN_H03', cFI_FrameTruckQuery);

  AddMenuModuleItem('MAIN_M01', cFI_FrameProvider);
  AddMenuModuleItem('MAIN_M02', cFI_FrameMaterails);
  AddMenuModuleItem('MAIN_M03', cFI_FrameProvideCard);
  AddMenuModuleItem('MAIN_M04', cFI_FrameProvideLog);
  AddMenuModuleItem('MAIN_M05', cFI_FormProvideBF, mtForm);
  AddMenuModuleItem('MAIN_M06', cFI_FormProvideYS, mtForm);
end;

//Desc: ����ģ���б�
procedure ClearMenuModuleList;
var nIdx: integer;
begin
  for nIdx:=gMenuModule.Count - 1 downto 0 do
  begin
    Dispose(PMenuModuleItem(gMenuModule[nIdx]));
    gMenuModule.Delete(nIdx);
  end;

  FreeAndNil(gMenuModule);
end;

initialization
  InitMenuModuleList;
finalization
  ClearMenuModuleList;
end.



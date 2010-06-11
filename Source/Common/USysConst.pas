{*******************************************************************************
  作者: dmzn@ylsoft.com 2007-10-09
  描述: 项目通用常,变量定义单元
*******************************************************************************}
unit USysConst;

interface

uses
  SysUtils, Classes, ComCtrls;

const
  cSBar_Date            = 0;                         //日期面板索引
  cSBar_Time            = 1;                         //时间面板索引
  cSBar_User            = 2;                         //用户面板索引
  cRecMenuMax           = 5;                         //最近使用导航区最大条目数
  
  cPrecision            = 100;                       //计算精度
  {-----------------------------------------------------------------------------
   描述:
   *.重量为吨的计算中,小数值比较或者相减运算时会有误差,所以会先放大,去掉
     小数位后按照整数计算.放大倍数由精度值确定.
  -----------------------------------------------------------------------------}

  cShouJuIDLength       = 7;                         //财务收据标识长度
  cItemIconIndex        = 11;                        //默认的提货单列表图标                           

const
  {*Frame ID*}
  cFI_FrameSysLog       = $0001;                     //系统日志
  cFI_FrameViewLog      = $0002;                     //本地日志

  cFI_FrameCustomer     = $0004;                     //客户管理
  cFI_FrameSalesMan     = $0005;                     //业务员管理
  cFI_FrameSaleContract = $0006;                     //销售合同
  cFI_FrameZhiKa        = $0007;                     //办理纸卡
  cFI_FrameZhiKaCard    = $0008;                     //办理磁卡
  cFI_FrameMakeCard     = $0012;                     //办理磁卡
  cFI_FrameBill         = $0013;                     //开提货单
  cFI_FrameTruckQuery   = $0015;                     //车辆查询
  cFI_FrameLadingDai    = $0016;                     //袋装提货
  cFI_FramePoundQuery   = $0017;                     //磅房查询
  cFI_FrameYanShouQuery = $0018;                     //验收查询
  cFI_FrameFangHuiQuery = $0019;                     //放灰查询
  cFI_FrameZhanTaiQuery = $0020;                     //栈台查询
  cFI_FrameZhanTaiJSQuery = $0120;                   //计数查询
  cFI_FrameTuiGouQuery  = $0021;                     //销售查询

  cFI_FrameStock        = $0022;                     //品种管理
  cFI_FrameStockRecord  = $0023;                     //检验记录
  cFI_FrameStockHuaYan  = $0025;                     //开化验单
  cFI_FrameShouJu       = $0026;                     //收据查询

  cFI_FrameZhiKaVerify  = $0051;                     //纸卡审核
  cFI_FramePayment      = $0052;                     //销售回款
  cFI_FramePaymentC     = $0053;                     //补缴差价

  cFI_FrameTruckQuery2  = $0055;                     //车辆查询
  cFI_FrameCusAccountQuery = $0056;                  //客户账户
  cFI_FrameCusInOutMoney   = $0057;                  //出入金明细

  cFI_FrameSaleTotalQuery  = $0058;                  //累计发货
  cFI_FrameSaleDetailQuery = $0059;                  //发货明细
  cFI_FrameSaleZhiKaQuery  = $0060;                  //用户业务

  cFI_FrameSaleInvoice  = $0061;                     //发票管理
  cFI_FrameMakeInvoice  = $0062;                     //开具发票
  cFI_FrameCusCredit    = $0063;                     //信用管理
  cFI_FrameZhiKaDetail  = $0065;                     //纸卡明细

  cFI_FrameProvider     = $0102;                     //供应商
  cFI_FrameProvideCard  = $0103;                     //磁卡
  cFI_FrameProvideLog   = $0105;                     //供应日志
  cFI_FrameMaterails    = $0106;                     //原材料

  cFI_FormMemo          = $1000;                     //备注窗口
  cFI_FormBackup        = $1001;                     //数据备份
  cFI_FormRestore       = $1002;                     //数据恢复
  cFI_FormIncInfo       = $1003;                     //公司信息
  cFI_FormChangePwd     = $1005;                     //修改密码

  cFI_FormBaseInfo      = $1006;                     //基本信息
  cFI_FormCustomer      = $1007;                     //客户资料
  cFI_FormSaleMan       = $1008;                     //业务员
  cFI_FormSaleContract  = $1009;                     //销售合同
  cFI_FormZhiKa         = $1010;                     //纸卡办理
  cFI_FormZhiKaParam    = $1011;                     //纸卡参数
  cFI_FormZhiKaCard     = $1012;                     //纸卡磁卡

  cFI_FormSetPassword   = $1014;                     //设置密码
  cFI_FormVerifyCardPwd = $1015;                     //验证身份
  cFI_FormBill          = $1016;                     //开提货单
  cFI_FormShouJu        = $1017;                     //开收据
  cFI_FormZhiKaVerify   = $1018;                     //纸卡审核
  cFI_FormCusCredit     = $1019;                     //信用变动
  cFI_FormPayment       = $1020;                     //销售回款
  cFI_FormTruckIn       = $1021;                     //车辆进厂
  cFI_FormTruckOut      = $1022;                     //车辆出厂
  cFI_FormVerifyCard    = $1023;                     //磁卡验证
  cFI_FormAutoBFP       = $1024;                     //自动过皮
  cFI_FormBangFangP     = $1025;                     //称量皮重
  cFI_FormBangFangM     = $1026;                     //称量毛重
  cFI_FormLadDai        = $1027;                     //袋装提货
  cFI_FormLadSan        = $1028;                     //散装提货
  cFI_FormJiShuQi       = $1029;                     //计数管理
  cFI_FormBFWuCha       = $1030;                     //净重误差
  cFI_FormZhiKaQuery    = $1031;                     //卡片信息
  cFI_FormPayCustom     = $1032;                     //销售退购
  cFI_FormZhiKaInfoExt1 = $1033;                     //纸卡扩展
  cFI_FormZhiKaInfoExt2 = $1034;                     //纸卡扩展
  cFI_FormZhiKaAdjust   = $1035;                     //纸卡调整
  cFI_FormZhiKaFixMoney = $1036;                     //限提金额
  cFI_FormSaleAdjust    = $1037;                     //销售调剂
  cFI_FormDaiHeKa       = $1038;                     //袋装合卡
  cFI_FormSanHeKa       = $1039;                     //散装合卡

  cFI_FormGetContract   = $1048;                     //选择合同
  cFI_FormGetCustom     = $1049;                     //选择客户
  cFI_FormGetStockNo    = $1050;                     //选择编号
  cFI_FormProvider      = $1051;                     //供应商
  cFI_FormMaterails     = $1052;                     //原材料
  cFI_FormProvideBF     = $1053;                     //过磅
  cFI_FormProvideYS     = $1054;                     //验收
  cFI_FormProvideCard   = $1055;                     //供应磁卡

  cFI_FormStockParam    = $1060;                     //品种管理
  cFI_FormStockHuaYan   = $1061;                     //开化验单

  {*Command*}
  cCmd_RefreshData      = $0002;                     //刷新数据
  cCmd_ViewSysLog       = $0003;                     //系统日志

  cCmd_ModalResult      = $1001;                     //Modal窗体
  cCmd_FormClose        = $1002;                     //关闭窗口
  cCmd_AddData          = $1003;                     //添加数据
  cCmd_EditData         = $1005;                     //修改数据
  cCmd_ViewData         = $1006;                     //查看数据

type
  TSysParam = record
    FProgID     : string;                            //程序标识
    FAppTitle   : string;                            //程序标题栏提示
    FMainTitle  : string;                            //主窗体标题
    FHintText   : string;                            //提示文本
    FCopyRight  : string;                            //主窗体提示内容

    FUserID     : string;                            //用户标识
    FUserName   : string;                            //当前用户
    FUserPwd    : string;                            //用户口令
    FGroupID    : string;                            //所在组
    FIsAdmin    : Boolean;                           //是否管理员
    FIsNormal   : Boolean;                           //帐户是否正常

    FRecMenuMax : integer;                           //导航栏个数
    FIconFile   : string;                            //图标配置文件
  end;
  //系统参数

  TModuleItemType = (mtFrame, mtForm);
  //模块类型

  PMenuModuleItem = ^TMenuModuleItem;
  TMenuModuleItem = record
    FMenuID: string;                                 //菜单名称
    FModule: integer;                                //模块标识
    FItemType: TModuleItemType;                      //模块类型
  end;

//------------------------------------------------------------------------------
var
  gPath: string;                                     //程序所在路径
  gSysParam:TSysParam;                               //程序环境参数
  gStatusBar: TStatusBar;                            //全局使用状态栏
  gMenuModule: TList = nil;                          //菜单模块映射表

//------------------------------------------------------------------------------
ResourceString
  sProgID             = 'DMZN';                      //默认标识
  sAppTitle           = 'DMZN';                      //程序标题
  sMainCaption        = 'DMZN';                      //主窗口标题

  sHint               = '提示';                      //对话框标题
  sWarn               = '警告';                      //==
  sAsk                = '询问';                      //询问对话框
  sError              = '未知错误';                  //错误对话框

  sDate               = '日期:【%s】';               //任务栏日期
  sTime               = '时间:【%s】';               //任务栏时间
  sUser               = '用户:【%s】';               //任务栏用户

  sLogDir             = 'Logs\';                     //日志目录
  sLogExt             = '.log';                      //日志扩展名
  sLogField           = #9;                          //记录分隔符

  sImageDir           = 'Images\';                   //图片目录
  sReportDir          = 'Report\';                   //报表目录
  sBackupDir          = 'Backup\';                   //备份目录
  sBackupFile         = 'Bacup.idx';                 //备份索引

  sConfigFile         = 'Config.Ini';                //主配置文件
  sConfigSec          = 'Config';                    //主配置小节
  sVerifyCode         = ';Verify:';                  //校验码标记

  sFormConfig         = 'FormInfo.ini';              //窗体配置
  sSetupSec           = 'Setup';                     //配置小节
  sDBConfig           = 'DBConn.ini';                //数据连接

  sExportExt          = '.txt';                      //导出默认扩展名
  sExportFilter       = '文本(*.txt)|*.txt|所有文件(*.*)|*.*';
                                                     //导出过滤条件 

  sInvalidConfig      = '配置文件无效或已经损坏';    //配置文件无效
  sCloseQuery         = '确定要退出程序吗?';         //主窗口退出
  
implementation

//------------------------------------------------------------------------------
//Desc: 添加菜单模块映射项
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

//Desc: 菜单模块映射表
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

//Desc: 清理模块列表
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



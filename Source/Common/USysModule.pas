{*******************************************************************************
  作者: dmzn@163.com 2009-6-25
  描述: 单元模块

  备注: 由于模块有自注册能力,只要Uses一下即可.
*******************************************************************************}
unit USysModule;

{$I Link.inc}
interface

uses
  UFrameLog, UFrameSysLog, UFormIncInfo, UFormBackupSQL, UFormRestoreSQL,
  UFormPassword, UFormBaseInfo, UFrameCustomer, UFormCustomer, UFrameSalesMan,
  UFormSalesMan, UFrameSaleContract, UFormZhiKaParam, UFrameZhiKa, UFormZhiKa,
  UFormGetContract, UFrameZhiKaCard, UFormZhiKaCard, UFormSetPassword,
  UFormVerifyCardPwd, UFormBill, UFrameShouJu, UFormShouJu, UFrameZhiKaVerify,
  UFrameCusInOutMoney, UFrameCusAccount, UFormZhiKaVerify, UFrameCustomerCredit,
  UFormCustomerCredit, UFramePayment, UFormPayment, UFrameBill, UFormVerifyCard,
  UFormTruckIn, UFormAutoBangFangP, UFrameTruck, UFramePound, UFrameLadingDai,
  UFrameLadingSan, UFormLadingSan, UFormLadingDai, UFormBangFangP,
  UFormBangFangM, UFormWeightWuCha, UFormTruckOut, UFrameTruckQuery,
  UFormZhiKaInfo, UFrameSaleTotalQuery, UFrameSaleDetailQuery,
  UFrameBillQuery, UFormZhiKaInfoExt, UFramePayCustom, UFormPayCustom,
  UFormZhiKaAdjust, UFormZhiKaFixMoney, UFrameZhiKaDetail, UFormSaleAdjust,
  UFormLadingDaiHeKa, UFormLadingSanHeKa, UFormBadPound,
  UFrameHYStock, UFrameHYRecord, UFormMemo, UFormZhiKaInfoExt2, UFrameHYData,
  UFormGetCustom, UFormHYData, UFormGetStockNo, UFrameLadingDaiJS,
  UFormGetTruck, UFormPaymentZK, UFormZhiKaFreeze, UFormZhiKaPrice,
  UFrameInvoiceWeek, UFormInvoiceWeek, UFrameInvoice, UFormInvoice,
  UFrameInvoiceZZ, UFormInvoiceGetWeek, UFormInvoiceZZAll, UFormInvoiceZZCus,
  UFrameInvoiceK, UFormInvoicesView, UFrameInvoiceDtl, UFormInvoiceAdjust,
  UFormSetPasswordCard, UFormBillPrice,
  {$IFDEF MultiJS}UFormLadingDaiJS_M,{$ELSE}UFormLadingDaiJS,{$ENDIF}
  {$IFDEF HYEachTruck}UFrameHYData_Each, UFormHYData_Each,{$ENDIF}
  //----------------------------------------------------------------------------
  UFormPProvider, UFramePProvider, UFormProvideJS, UFramePProvideJS,
  UFormProvideHS_P, UFormProvideJS_P, UFormPMaterails, UFramePMaterails,
  UFormPProvideCard, UFramePProvideCard, UFramePProvideLog, UFormPYanShou,
  UFormPPreTruckP, UFormPProvideInOut,
  {$IFDEF ProvideSplitPM}
  UFormPBangFangM, UFormPBangFangP
  {$ELSE}
  UFormPBangFang
  {$ENDIF};

procedure InitSystemObject;
procedure RunSystemObject;
procedure FreeSystemObject;

implementation

uses
  SysUtils, USysLoger, USysConst;

//Desc: 初始化系统对象
procedure InitSystemObject;
begin
  if not Assigned(gSysLoger) then
    gSysLoger := TSysLoger.Create(gPath + sLogDir);
  //system loger
end;

//Desc: 运行系统对象
procedure RunSystemObject;
begin

end;

//Desc: 释放系统对象
procedure FreeSystemObject;
begin
  FreeAndNil(gSysLoger);
end;

end.

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
  UFormLadingDaiHeKa, UFormLadingSanHeKa, UFramePProvider, UFormPProvider,
  UFormPMaterails, UFramePMaterails, UFramePProvideCard, UFormPProvideCard,
  UFramePProvideLog, UFormPYanShou, UFormPBangFang,
  {$IFDEF MultiJS}UFormLadingDaiJS_M,{$ELSE}UFormLadingDaiJS,{$ENDIF}
  UFrameHYStock, UFrameHYRecord, UFormMemo, UFormZhiKaInfoExt2, UFrameHYData,
  UFormGetCustom, UFormHYData, UFormGetStockNo, UFrameLadingDaiJS,
  UFormProvideJS, UFramePProvideJS, UFormProvideHS_P, UFormProvideJS_P,
  UFormGetTruck, UFormPaymentZK, UFormZhiKaFreeze, UFormZhiKaPrice;

implementation

end.

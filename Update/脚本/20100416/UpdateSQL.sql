Drop Table S_StockHuaYan;
--删除化验单表
ALTER Table S_ZhiKaCard Add C_Man varChar(32);
ALTER Table S_ZhiKaCard Add C_Date DateTime;
--磁卡表添加操作人
ALTER Table Sys_ShouJu Add S_Bank varChar(35);
--收据添加银行
ALTER Table S_ZhiKa Add Z_ValidDays2 DateTime;
Update S_ZhiKa Set Z_ValidDays2=Z_ValidDays+Z_Date;
ALTER Table S_ZhiKa Drop Column Z_ValidDays;
sp_RENAME 'S_ZhiKa.Z_ValidDays2','Z_ValidDays','COLUMN';
--纸卡修改Z_ValidDays,由整形变为日期型,同时更新数据
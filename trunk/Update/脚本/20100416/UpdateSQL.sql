Drop Table S_StockHuaYan;
--ɾ�����鵥��
ALTER Table S_ZhiKaCard Add C_Man varChar(32);
ALTER Table S_ZhiKaCard Add C_Date DateTime;
--�ſ�����Ӳ�����
ALTER Table Sys_ShouJu Add S_Bank varChar(35);
--�վ��������
ALTER Table S_ZhiKa Add Z_ValidDays2 DateTime;
Update S_ZhiKa Set Z_ValidDays2=Z_ValidDays+Z_Date;
ALTER Table S_ZhiKa Drop Column Z_ValidDays;
sp_RENAME 'S_ZhiKa.Z_ValidDays2','Z_ValidDays','COLUMN';
--ֽ���޸�Z_ValidDays,�����α�Ϊ������,ͬʱ��������
--����: dmzn@163.com 2010-12-08
--����: ϵͳ�ֵ��У���ű�,�������ô�����������ϵͳ�����л���.

-------------------------------------------------------------------------------------------------------------------------
--ɾ�����в���
Delete From Sys_Dict Where D_Name='SysParam'

--ֽ����˲���
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo) Values('SysParam','ֽ����˲���','Y','ZhiKaVerify')

--��װ24Сʱ�Զ���Ƥ
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo) Values('SysParam','��װ�Զ�����','N','AutoP_24H')

--�������
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA) Values('SysParam','�������','N','WeightWuCha',10)

--���Ӱ�ʱ��
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo) Values('SysParam','���Ӱ�ʱ��','08:00','JiaoBanTime')

--���Ӱ����
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo) Values('SysParam','���Ӱ����','-BP,+BM','JiaoBanParam')

--���鵥�����
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo) Values('SysParam','���鵥�����','600','HYMaxValue')

--�Զ�����
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo) Values('SysParam','�����Զ�����','Y','AutoI_Truck')

--�Զ�����
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo) Values('SysParam','�����Զ�����','Y','AutoO_Truck')

--�����޸�ֽ��������
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo) Values('SysParam','�ؿ�������','Y','ZKMoneyModify')

--��ӡֽ��
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo) Values('SysParam','��ӡֽ��','N','PrintZK')

--�������ʱ�Ե���
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo) Values('SysParam','����ʱ�Ե���','Y','Bill_Price')

--�����鵥ʱ֧��ˢ��
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo) Values('SysParam','���鵥ˢ��','N','HYData_Card')

--�ؿ�ʱ�������
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo) Values('SysParam','�ؿ�ʱ������','Y','Pay_Credit')

--�������������
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamB) Values('SysParam','�����������','+ST,+SC','Bill_Single','ST,��������;SC,��������')

--����������
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamB) Values('SysParam','����������','6','JSTunnelNum', '1be866d2965b3074e5615d6576fdc8d4')

-------------------------------------------------------------------------------------------------------------------------
--�ֹ�������ѯ
Update Sys_Menu Set M_Title='������ѯ',M_Flag='',M_NewOrder=3 Where M_MenuID='K03' and M_ProgID='HJSOFT' and M_Entity='MAIN'

--�ֹ������鵥
Update Sys_Menu Set M_Title='�����鵥',M_Flag='',M_NewOrder=4 Where M_MenuID='K04' and M_ProgID='HJSOFT' and M_Entity='MAIN'

--�泵����
Update Sys_Menu Set M_NewOrder=-1 Where M_MenuID='K05' and M_ProgID='HJSOFT' and M_Entity='MAIN'

--���泵������ѯ
Update Sys_Menu Set M_NewOrder=-1 Where M_MenuID='K06' and M_ProgID='HJSOFT' and M_Entity='MAIN'
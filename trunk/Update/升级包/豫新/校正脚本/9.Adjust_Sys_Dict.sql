--����: dmzn@163.com 2011-01-15
--����: ϵͳ�ֵ��У���ű�,�����������ԥ������ϵͳ�����л���.

-------------------------------------------------------------------------------------------------------------------------
----ɾ�����в���
Delete From Sys_Dict Where D_Name='SysParam'

--ֽ����˲���
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo) Values('SysParam','ֽ����˲���','Y','ZhiKaVerify')

--��װ24Сʱ�Զ���Ƥ
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo) Values('SysParam','��װ�Զ�����','N','AutoP_24H')

--��װֱ��ջ̨���
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo) Values('SysParam','��װֱ�����','Y','ViaLadingDai')

--�������
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA) Values('SysParam','�������','N','WeightWuCha',10)

--���Ӱ�ʱ��
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo) Values('SysParam','���Ӱ�ʱ��','08:00','JiaoBanTime')

--���Ӱ����
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo) Values('SysParam','���Ӱ����','-BP,-BM','JiaoBanParam')

--���鵥�����
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo) Values('SysParam','���鵥�����','600','HYMaxValue')

--�Զ�����
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo) Values('SysParam','�����Զ�����','Y','AutoI_Truck')

--�Զ�����
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo) Values('SysParam','�����Զ�����','Y','AutoO_Truck')

--�����޸�ֽ��������
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo) Values('SysParam','�ؿ�������','N','ZKMoneyModify')

--��ӡֽ��
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo) Values('SysParam','��ӡֽ��','N','PrintZK')

--�������ʱ�Ե���
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo) Values('SysParam','����ʱ�Ե���','N','Bill_Price')

--�����鵥ʱ֧��ˢ��
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo) Values('SysParam','���鵥ˢ��','N','HYData_Card')

--�ؿ�ʱ�������
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo) Values('SysParam','�ؿ�ʱ������','Y','Pay_Credit')

--�������������
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamB) Values('SysParam','�����������','-ST,+SC','Bill_Single','ST,��������;SC,��������')

--ԭ�Ϲ�ӦԤ��Ƥ�ع���
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamB) Values('SysParam','ԭ��Ԥ��Ƥ��','-JZ','ProPreTruckP','JZ,����ԭ��')

--ԭ�Ϲ�Ӧ�ſ�ѡ��
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamB) Values('SysParam','��Ӧ�ſ�ѡ��','-SY','ProCardOpt','SY,������ԭ��')

--ԭ�Ϲ�Ӧ����ѡ��
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamB) Values('SysParam','ԭ������ѡ��','+IN,+OUT','ProDoorOpt','IN,�Զ�����;OUT,�Զ�����')

--����������
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamB) Values('SysParam','����������','6','JSTunnelNum', '956b761ea903a5e0540a8905c443db27')

--ϵͳ��Ч��
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamB) Values('SysParam','ϵͳ��Ч��','2014-03-30','SysValidDate', '98f0d45689b2a0e531dc9dd7ff20dd5b')

-------------------------------------------------------------------------------------------------------------------------
----ɾ������������
Delete From Sys_Dict Where D_Name='BankItem'

--���������
Insert Into Sys_Dict(D_Name,D_Desc,D_Value) Values('BankItem', '������Ϣ��','�ֽ�')
Insert Into Sys_Dict(D_Name,D_Desc,D_Value) Values('BankItem', '������Ϣ��','ת��')
Insert Into Sys_Dict(D_Name,D_Desc,D_Value) Values('BankItem', '������Ϣ��','֧Ʊ')
Insert Into Sys_Dict(D_Name,D_Desc,D_Value) Values('BankItem', '������Ϣ��','�й���������')
Insert Into Sys_Dict(D_Name,D_Desc,D_Value) Values('BankItem', '������Ϣ��','�й�ũҵ����')
Insert Into Sys_Dict(D_Name,D_Desc,D_Value) Values('BankItem', '������Ϣ��','�й���������')
Insert Into Sys_Dict(D_Name,D_Desc,D_Value) Values('BankItem', '������Ϣ��','�й�����')
Insert Into Sys_Dict(D_Name,D_Desc,D_Value) Values('BankItem', '������Ϣ��','��������')
Insert Into Sys_Dict(D_Name,D_Desc,D_Value) Values('BankItem', '������Ϣ��','����ʵҵ����')
Insert Into Sys_Dict(D_Name,D_Desc,D_Value) Values('BankItem', '������Ϣ��','�й���������')
Insert Into Sys_Dict(D_Name,D_Desc,D_Value) Values('BankItem', '������Ϣ��','ũ����ҵ����')

-------------------------------------------------------------------------------------------------------------------------
--�ֹ�������ѯ
Update Sys_Menu Set M_Title='�ֹ�����',M_Flag='NB',M_NewOrder=3 Where M_MenuID='K03' and M_ProgID='HJSOFT' and M_Entity='MAIN'

--�ֹ������鵥
Update Sys_Menu Set M_NewOrder=-1 Where M_MenuID='K04' and M_ProgID='HJSOFT' and M_Entity='MAIN'

--�泵����
Update Sys_Menu Set M_Title='�����鵥',M_Flag='',M_NewOrder=5 Where M_MenuID='K05' and M_ProgID='HJSOFT' and M_Entity='MAIN'

--�泵������ѯ
Update Sys_Menu Set M_Title='������ѯ',M_Flag='',M_NewOrder=3 Where M_MenuID='K06' and M_ProgID='HJSOFT' and M_Entity='MAIN'

-------------------------------------------------------------------------------------------------------------------------
--ɾ��Ʒ�ֲ���
Delete From Sys_Dict Where D_Name='StockItem'

--����µ�ˮ��Ʒ��
insert   Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA,D_ParamB,D_Index)   values( 'StockItem'       ,    'ˮ������'                           ,    'ɢװ_����32.5'                                          ,    'S'                    ,    NULL              ,    '-NF'                                                ,    0           )
insert   Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA,D_ParamB,D_Index)   values( 'StockItem'       ,    'ˮ������'                           ,    '��װ_����32.5'                                          ,    'D'                    ,    NULL              ,    NULL                                                 ,    0           )
insert   Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA,D_ParamB,D_Index)   values( 'StockItem'       ,    'ˮ������'                           ,    'ɢװ_��ͨ42.5'                                          ,    'S'                    ,    NULL              ,    '-NF'                                                ,    0           )
insert   Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA,D_ParamB,D_Index)   values( 'StockItem'       ,    'ˮ������'                           ,    '��װ_��ͨ42.5'                                          ,    'D'                    ,    NULL              ,    NULL                                                 ,    0           )
insert   Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA,D_ParamB,D_Index)   values( 'StockItem'       ,    'ˮ������'                           ,    'ɢװ_75��������'                                        ,    'S'                    ,    NULL              ,    '-NF'                                                ,    0           )
insert   Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA,D_ParamB,D_Index)   values( 'StockItem'       ,    'ˮ������'                           ,    'ɢװ_95��������'                                        ,    'S'                    ,    NULL              ,    '-NF'                                                ,    0           )
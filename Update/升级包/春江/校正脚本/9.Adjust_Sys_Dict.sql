--����: dmzn@163.com 2010-12-08
--����: ϵͳ�ֵ��У���ű�,�������ô�����������ϵͳ�����л���.

-------------------------------------------------------------------------------------------------------------------------
--ɾ�����в���
Delete From Sys_Dict Where D_Name='SysParam'

--���ñ������ݿ�
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo) Values('SysParam','ʹ�ñ��ÿ�','N','Uses_BackDB')

--ֽ����˲���
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo) Values('SysParam','ֽ����˲���','Y','ZhiKaVerify')

--��װ24Сʱ�Զ���Ƥ
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo) Values('SysParam','��װ�Զ�����','N','AutoP_24H')

--�������
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA) Values('SysParam','�������','N','WeightWuCha',10)

--���Ӱ�ʱ��
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo) Values('SysParam','���Ӱ�ʱ��','07:00','JiaoBanTime')

--���Ӱ����
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo) Values('SysParam','���Ӱ����','-BP,+BM','JiaoBanParam')

--���鵥�����
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo) Values('SysParam','���鵥�����','1200','HYMaxValue')

--�Զ�����
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo) Values('SysParam','�����Զ�����','N','AutoI_Truck')

--�Զ�����
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo) Values('SysParam','�����Զ�����','Y','AutoO_Truck')

--�����޸�ֽ��������
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo) Values('SysParam','�ؿ�������','Y','ZKMoneyModify')

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
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamB) Values('SysParam','ϵͳ��Ч��','2012-10-22','SysValidDate', 'dc5178a0269edde8b8846d9e567cf7bb')

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
insert   Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA,D_ParamB,D_Index)   values( 'StockItem'       ,    'ˮ������'                           ,    'ɢװ_����32.5'                                          ,    'S'                    ,    NULL              ,    NULL                                                 ,    0           )
insert   Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA,D_ParamB,D_Index)   values( 'StockItem'       ,    'ˮ������'                           ,    '��װ_����32.5'                                          ,    'D'                    ,    NULL              ,    NULL                                                 ,    0           )
insert   Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA,D_ParamB,D_Index)   values( 'StockItem'       ,    'ˮ������'                           ,    'ɢװ_��ͨ42.5'                                          ,    'S'                    ,    NULL              ,    NULL                                                 ,    0           )
insert   Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA,D_ParamB,D_Index)   values( 'StockItem'       ,    'ˮ������'                           ,    '��װ_��ͨ42.5'                                          ,    'D'                    ,    NULL              ,    NULL                                                 ,    0           )
insert   Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA,D_ParamB,D_Index)   values( 'StockItem'       ,    'ˮ������'                           ,    'ɢװ_��ͨ52.5'                                          ,    'S'                    ,    NULL              ,    NULL                                                 ,    0           )
insert   Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA,D_ParamB,D_Index)   values( 'StockItem'       ,    'ˮ������'                           ,    '��װ_��ͨ52.5'                                          ,    'D'                    ,    NULL              ,    NULL                                                 ,    0           )
insert   Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA,D_ParamB,D_Index)   values( 'StockItem'       ,    'ˮ������'                           ,    'ɢװ_����'                                              ,    'S'                    ,    NULL              ,    NULL                                                 ,    0           )
insert   Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA,D_ParamB,D_Index)   values( 'StockItem'       ,    'ˮ������'                           ,    'ɢװ_������'                                            ,    'S'                    ,    NULL              ,    NULL                                                 ,    0           )
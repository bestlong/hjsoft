--����: dmzn@163.com 2010-12-08
--����: ϵͳ�ֵ��У���ű�,�������ó�����ҵˮ�೧����ϵͳ�����л���.

-------------------------------------------------------------------------------------------------------------------------
--ɾ�����в���
Delete From Sys_Dict Where D_Name='SysParam'

--ֽ����˲���
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo) Values('SysParam','ֽ����˲���','N','ZhiKaVerify')

--��װ24Сʱ�Զ���Ƥ
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo) Values('SysParam','��װ�Զ�����','Y','AutoP_24H')

--�������
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA) Values('SysParam','�������','N','WeightWuCha',10)

--���Ӱ�ʱ��
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo) Values('SysParam','���Ӱ�ʱ��','08:00','JiaoBanTime')

--���Ӱ����
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo) Values('SysParam','���Ӱ����','+BP,+BM','JiaoBanParam')

--���鵥�����
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo) Values('SysParam','���鵥�����','600','HYMaxValue')

--�Զ�����
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo) Values('SysParam','�����Զ�����','Y','AutoI_Truck')

--�Զ�����
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo) Values('SysParam','�����Զ�����','N','AutoO_Truck')

--�����޸�ֽ��������
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo) Values('SysParam','�ؿ�������','Y','ZKMoneyModify')

--��ӡֽ��
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo) Values('SysParam','��ӡֽ��','Y','PrintZK')

--�������ʱ�Ե���
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo) Values('SysParam','����ʱ�Ե���','Y','Bill_Price')

--�����鵥ʱ֧��ˢ��
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo) Values('SysParam','���鵥ˢ��','Y','HYData_Card')

--�ؿ�ʱ�������
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo) Values('SysParam','�ؿ�ʱ������','Y','Pay_Credit')

--�������������
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamB) Values('SysParam','�����������','-ST,+SC','Bill_Single','ST,��������;SC,��������')

--ԭ�Ϲ�ӦԤ��Ƥ�ع���
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamB) Values('SysParam','ԭ��Ԥ��Ƥ��','+JZ','ProPreTruckP','JZ,����ԭ��')

--ԭ�Ϲ�Ӧ�ſ�ѡ��
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamB) Values('SysParam','��Ӧ�ſ�ѡ��','+SY','ProCardOpt','SY,������ԭ��')

--ԭ�Ϲ�Ӧ����ѡ��
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamB) Values('SysParam','ԭ������ѡ��','-IN,-OUT','ProDoorOpt','IN,�Զ�����;OUT,�Զ�����')

--����������
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamB) Values('SysParam','����������','3','JSTunnelNum', 'fe22bc2c8b9a3ce5693d0493fcdeec1a')

--ϵͳ��Ч��
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamB) Values('SysParam','ϵͳ��Ч��','2013-01-05','SysValidDate', '953ee6798a09f25595b196d6a369ea50')

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
--ɾ��ˮ��Ʒ��
Delete From Sys_Dict Where D_Name='StockItem'

--����µ�ˮ��Ʒ��
insert   Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA,D_ParamB,D_Index)   values( 'StockItem'       ,    'ˮ������'                           ,    'ɢװ_����32.5'                                         ,    'S'                    ,    NULL              ,    NULL                                                 ,    10          )
insert   Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA,D_ParamB,D_Index)   values( 'StockItem'       ,    'ˮ������'                           ,    '��װ_����32.5'                                         ,    'D'                    ,    NULL              ,    NULL                                                 ,    1           )
insert   Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA,D_ParamB,D_Index)   values( 'StockItem'       ,    'ˮ������'                           ,    'ɢװ_��ͨ42.5'                                         ,    'S'                    ,    NULL              ,    NULL                                                 ,    12          )
insert   Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA,D_ParamB,D_Index)   values( 'StockItem'       ,    'ˮ������'                           ,    '��װ_��ͨ42.5'                                         ,    'D'                    ,    NULL              ,    NULL                                                 ,    3           )
insert   Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA,D_ParamB,D_Index)   values( 'StockItem'       ,    'ˮ������'                           ,    'ɢװ_��ͨ52.5'                                         ,    'S'                    ,    NULL              ,    NULL                                                 ,    14          )
insert   Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA,D_ParamB,D_Index)   values( 'StockItem'       ,    'ˮ������'                           ,    '��װ_��ͨ52.5'                                         ,    'D'                    ,    NULL              ,    NULL                                                 ,    5           )
insert   Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA,D_ParamB,D_Index)   values( 'StockItem'       ,    'ˮ������'                           ,    'ɢװ_����������'                                       ,    'S'                    ,    NULL              ,    NULL                                                 ,    35          )
insert   Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA,D_ParamB,D_Index)   values( 'StockItem'       ,    'ˮ������'                           ,    '��װ_����32.5R'                                        ,    'D'                    ,    NULL              ,    NULL                                                 ,    2           )
insert   Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA,D_ParamB,D_Index)   values( 'StockItem'       ,    'ˮ������'                           ,    'ɢװ_����32.5R'                                        ,    'S'                    ,    NULL              ,    NULL                                                 ,    11          )
insert   Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA,D_ParamB,D_Index)   values( 'StockItem'       ,    'ˮ������'                           ,    '��װ_��ͨ42.5R'                                        ,    'D'                    ,    NULL              ,    NULL                                                 ,    4           )
insert   Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA,D_ParamB,D_Index)   values( 'StockItem'       ,    'ˮ������'                           ,    'ɢװ_��ͨ42.5R'                                        ,    'S'                    ,    NULL              ,    NULL                                                 ,    13          )
insert   Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA,D_ParamB,D_Index)   values( 'StockItem'       ,    'ˮ������'                           ,    'ɢװ_��������'                                         ,    'S'                    ,    NULL              ,    NULL                                                 ,    36          )
insert   Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA,D_ParamB,D_Index)   values( 'StockItem'       ,    'ˮ������'                           ,    '��װ_��Ӳ��������'                                     ,    'D'                    ,    NULL              ,    NULL                                                 ,    50          )
insert   Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA,D_ParamB,D_Index)   values( 'StockItem'       ,    'ˮ������'                           ,    '��װ_�ͼ����������'                                   ,    'D'                    ,    NULL              ,    NULL                                                 ,    51          )
insert   Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA,D_ParamB,D_Index)   values( 'StockItem'       ,    'ˮ������'                           ,    '��װ_��Ӧ����������'                                   ,    'D'                    ,    NULL              ,    NULL                                                 ,    52          )
insert   Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA,D_ParamB,D_Index)   values( 'StockItem'       ,    'ˮ������'                           ,    '��װ_����ˮ��'                                         ,    'D'                    ,    NULL              ,    NULL                                                 ,    49          )
insert   Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA,D_ParamB,D_Index)   values( 'StockItem'       ,    'ˮ������'                           ,    '��װ_�ͼ�42.5'                                         ,    'D'                    ,    NULL              ,    NULL                                                 ,    47          )
insert   Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA,D_ParamB,D_Index)   values( 'StockItem'       ,    'ˮ������'                           ,    'ɢװ_�ͼ�42.5'                                         ,    'S'                    ,    NULL              ,    NULL                                                 ,    48          )
insert   Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA,D_ParamB,D_Index)   values( 'StockItem'       ,    'ˮ������'                           ,    'ɢװ_��42.5'                                           ,    'S'                    ,    NULL              ,    NULL                                                 ,    45          )
insert   Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA,D_ParamB,D_Index)   values( 'StockItem'       ,    'ˮ������'                           ,    '��װ_��42.5'                                           ,    'D'                    ,    NULL              ,    NULL                                                 ,    46          )
insert   Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA,D_ParamB,D_Index)   values( 'StockItem'       ,    'ˮ������'                           ,    'ɢװ_����32.5(����)'                                   ,    'S'                    ,    NULL              ,    NULL                                                 ,    53          )
insert   Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA,D_ParamB,D_Index)   values( 'StockItem'       ,    'ˮ������'                           ,    '��װ_����32.5(����)'                                   ,    'D'                    ,    NULL              ,    NULL                                                 ,    54          )

insert   Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA,D_ParamB,D_Index)   values( 'StockItem'       ,    'ˮ������'                           ,    'ɢװ_����32.5'                                         ,    'S'                    ,    NULL              ,    NULL                                                 ,    55          )
insert   Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA,D_ParamB,D_Index)   values( 'StockItem'       ,    'ˮ������'                           ,    '��װ_����32.5'                                         ,    'D'                    ,    NULL              ,    NULL                                                 ,    55          )
insert   Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA,D_ParamB,D_Index)   values( 'StockItem'       ,    'ˮ������'                           ,    'ɢװ_����42.5'                                         ,    'S'                    ,    NULL              ,    NULL                                                 ,    56          )
insert   Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA,D_ParamB,D_Index)   values( 'StockItem'       ,    'ˮ������'                           ,    '��װ_����42.5'                                         ,    'D'                    ,    NULL              ,    NULL                                                 ,    56          )
insert   Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA,D_ParamB,D_Index)   values( 'StockItem'       ,    'ˮ������'                           ,    'ɢװ_����52.5'                                         ,    'S'                    ,    NULL              ,    NULL                                                 ,    57          )
insert   Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA,D_ParamB,D_Index)   values( 'StockItem'       ,    'ˮ������'                           ,    '��װ_����52.5'                                         ,    'D'                    ,    NULL              ,    NULL                                                 ,    57          )


insert   Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA,D_ParamB,D_Index)   values( 'StockItem'       ,    'ˮ������'                           ,    'ɢװ_ʯ��ʯ��'                                         ,    'S'                    ,    NULL              ,    '+NF'                                                ,    57          )
insert   Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA,D_ParamB,D_Index)   values( 'StockItem'       ,    'ˮ������'                           ,    '��װ_��I52.5'                                          ,    'D'                    ,    NULL              ,    '+NF'                                                ,    57          )
insert   Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA,D_ParamB,D_Index)   values( 'StockItem'       ,    'ˮ������'                           ,    'ɢװ_��I52.5'                                          ,    'S'                    ,    NULL              ,    '+NF'                                                ,    57          )

--作者: dmzn@163.com 2010-12-08
--描述: 系统字典表校正脚本,用于配置春江集团销售系统的运行环境.

-------------------------------------------------------------------------------------------------------------------------
--删除所有参数
Delete From Sys_Dict Where D_Name='SysParam'

--启用备用数据库
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo) Values('SysParam','使用备用库','N','Uses_BackDB')

--纸卡审核参数
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo) Values('SysParam','纸卡审核参数','Y','ZhiKaVerify')

--袋装24小时自动除皮
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo) Values('SysParam','袋装自动过磅','N','AutoP_24H')

--净重误差
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA) Values('SysParam','净重误差','N','WeightWuCha',10)

--交接班时间
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo) Values('SysParam','交接班时间','07:00','JiaoBanTime')

--交接班参数
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo) Values('SysParam','交接班参数','-BP,+BM','JiaoBanParam')

--化验单检测量
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo) Values('SysParam','化验单检测量','1200','HYMaxValue')

--自动进厂
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo) Values('SysParam','车辆自动进厂','N','AutoI_Truck')

--自动出厂
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo) Values('SysParam','车辆自动出厂','Y','AutoO_Truck')

--允许修改纸卡限提金额
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo) Values('SysParam','回款改限提金','Y','ZKMoneyModify')

--打印纸卡
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo) Values('SysParam','打印纸卡','N','PrintZK')

--开提货单时显单价
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo) Values('SysParam','开单时显单价','N','Bill_Price')

--开化验单时支持刷卡
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo) Values('SysParam','化验单刷卡','N','HYData_Card')

--回款时冲减信用
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo) Values('SysParam','回款时冲信用','Y','Pay_Credit')

--单车限制提货单
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamB) Values('SysParam','单提货单控制','-ST,+SC','Bill_Single','ST,单车单单;SC,单卡单单')

--原料供应预置皮重规则
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamB) Values('SysParam','原料预置皮重','-JZ','ProPreTruckP','JZ,就重原则')

--原料供应磁卡选项
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamB) Values('SysParam','供应磁卡选项','-SY','ProCardOpt','SY,单卡单原料')

--原料供应门卫选项
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamB) Values('SysParam','原料门卫选项','+IN,+OUT','ProDoorOpt','IN,自动进厂;OUT,自动出厂')

--计数器道数
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamB) Values('SysParam','计数器道数','6','JSTunnelNum', '956b761ea903a5e0540a8905c443db27')

--系统有效期
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamB) Values('SysParam','系统有效期','2012-10-22','SysValidDate', 'dc5178a0269edde8b8846d9e567cf7bb')

-------------------------------------------------------------------------------------------------------------------------
--手工开单查询
Update Sys_Menu Set M_Title='手工开单',M_Flag='NB',M_NewOrder=3 Where M_MenuID='K03' and M_ProgID='HJSOFT' and M_Entity='MAIN'

--手工开化验单
Update Sys_Menu Set M_NewOrder=-1 Where M_MenuID='K04' and M_ProgID='HJSOFT' and M_Entity='MAIN'

--随车开单
Update Sys_Menu Set M_Title='开化验单',M_Flag='',M_NewOrder=5 Where M_MenuID='K05' and M_ProgID='HJSOFT' and M_Entity='MAIN'

--随车开单查询
Update Sys_Menu Set M_Title='开单查询',M_Flag='',M_NewOrder=3 Where M_MenuID='K06' and M_ProgID='HJSOFT' and M_Entity='MAIN'


-------------------------------------------------------------------------------------------------------------------------
--删除品种参数
Delete From Sys_Dict Where D_Name='StockItem'

--添加新的水泥品种
insert   Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA,D_ParamB,D_Index)   values( 'StockItem'       ,    '水泥类型'                           ,    '散装_复合32.5'                                          ,    'S'                    ,    NULL              ,    NULL                                                 ,    0           )
insert   Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA,D_ParamB,D_Index)   values( 'StockItem'       ,    '水泥类型'                           ,    '袋装_复合32.5'                                          ,    'D'                    ,    NULL              ,    NULL                                                 ,    0           )
insert   Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA,D_ParamB,D_Index)   values( 'StockItem'       ,    '水泥类型'                           ,    '散装_普通42.5'                                          ,    'S'                    ,    NULL              ,    NULL                                                 ,    0           )
insert   Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA,D_ParamB,D_Index)   values( 'StockItem'       ,    '水泥类型'                           ,    '袋装_普通42.5'                                          ,    'D'                    ,    NULL              ,    NULL                                                 ,    0           )
insert   Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA,D_ParamB,D_Index)   values( 'StockItem'       ,    '水泥类型'                           ,    '散装_普通52.5'                                          ,    'S'                    ,    NULL              ,    NULL                                                 ,    0           )
insert   Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA,D_ParamB,D_Index)   values( 'StockItem'       ,    '水泥类型'                           ,    '袋装_普通52.5'                                          ,    'D'                    ,    NULL              ,    NULL                                                 ,    0           )
insert   Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA,D_ParamB,D_Index)   values( 'StockItem'       ,    '水泥类型'                           ,    '散装_熟料'                                              ,    'S'                    ,    NULL              ,    NULL                                                 ,    0           )
insert   Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA,D_ParamB,D_Index)   values( 'StockItem'       ,    '水泥类型'                           ,    '散装_矿渣粉'                                            ,    'S'                    ,    NULL              ,    NULL                                                 ,    0           )
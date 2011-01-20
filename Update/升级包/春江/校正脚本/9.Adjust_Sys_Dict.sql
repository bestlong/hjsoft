--作者: dmzn@163.com 2010-12-08
--描述: 系统字典表校正脚本,用于配置春江集团销售系统的运行环境.

-------------------------------------------------------------------------------------------------------------------------
--删除所有参数
Delete From Sys_Dict Where D_Name='SysParam'

--纸卡审核参数
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo) Values('SysParam','纸卡审核参数','Y','ZhiKaVerify')

--袋装24小时自动除皮
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo) Values('SysParam','袋装自动过磅','N','AutoP_24H')

--净重误差
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamA) Values('SysParam','净重误差','N','WeightWuCha',10)

--交接班时间
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo) Values('SysParam','交接班时间','08:00','JiaoBanTime')

--交接班参数
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo) Values('SysParam','交接班参数','-BP,+BM','JiaoBanParam')

--化验单检测量
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo) Values('SysParam','化验单检测量','600','HYMaxValue')

--自动进厂
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo) Values('SysParam','车辆自动进厂','Y','AutoI_Truck')

--自动出厂
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo) Values('SysParam','车辆自动出厂','Y','AutoO_Truck')

--允许修改纸卡限提金额
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo) Values('SysParam','回款改限提金','Y','ZKMoneyModify')

--打印纸卡
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo) Values('SysParam','打印纸卡','N','PrintZK')

--开提货单时显单价
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo) Values('SysParam','开单时显单价','Y','Bill_Price')

--开化验单时支持刷卡
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo) Values('SysParam','化验单刷卡','N','HYData_Card')

--回款时冲减信用
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo) Values('SysParam','回款时冲信用','Y','Pay_Credit')

--单车限制提货单
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamB) Values('SysParam','单提货单控制','+ST,+SC','Bill_Single','ST,单车单单;SC,单卡单单')

--计数器道数
Insert Into Sys_Dict(D_Name,D_Desc,D_Value,D_Memo,D_ParamB) Values('SysParam','计数器道数','6','JSTunnelNum', '1be866d2965b3074e5615d6576fdc8d4')

-------------------------------------------------------------------------------------------------------------------------
--手工开单查询
Update Sys_Menu Set M_Title='开单查询',M_Flag='',M_NewOrder=3 Where M_MenuID='K03' and M_ProgID='HJSOFT' and M_Entity='MAIN'

--手工开化验单
Update Sys_Menu Set M_Title='开化验单',M_Flag='',M_NewOrder=4 Where M_MenuID='K04' and M_ProgID='HJSOFT' and M_Entity='MAIN'

--随车开单
Update Sys_Menu Set M_NewOrder=-1 Where M_MenuID='K05' and M_ProgID='HJSOFT' and M_Entity='MAIN'

--将随车开单查询
Update Sys_Menu Set M_NewOrder=-1 Where M_MenuID='K06' and M_ProgID='HJSOFT' and M_Entity='MAIN'
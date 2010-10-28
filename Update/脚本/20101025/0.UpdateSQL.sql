if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Sys_Truck]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Sys_Truck]
GO

CREATE TABLE [dbo].[Sys_Truck] (
	[R_ID] [int] IDENTITY (1, 1) NOT NULL ,
	[T_Truck] [varchar] (15) COLLATE Chinese_PRC_CI_AS NULL ,
	[T_PY] [varchar] (15) COLLATE Chinese_PRC_CI_AS NULL ,
	[T_Owner] [varchar] (32) COLLATE Chinese_PRC_CI_AS NULL ,
	[T_Phone] [varchar] (15) COLLATE Chinese_PRC_CI_AS NULL ,
	[T_Used] [char] (1) COLLATE Chinese_PRC_CI_AS NULL ,
	[T_Valid] [char] (1) COLLATE Chinese_PRC_CI_AS NULL 
) ON [PRIMARY]
GO
--重建车辆表

ALTER Table P_ProvideLog Add L_Flag varChar(32)
--修改供应商,供应记录表

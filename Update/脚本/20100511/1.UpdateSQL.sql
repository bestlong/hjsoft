if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[S_StockHuaYan]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[S_StockHuaYan]
GO

CREATE TABLE [dbo].[S_StockHuaYan] (
	[H_ID] [int] IDENTITY (1, 1) NOT NULL ,
	[H_Custom] [varchar] (15) COLLATE Chinese_PRC_CI_AS NULL ,
	[H_CusName] [varchar] (80) COLLATE Chinese_PRC_CI_AS NULL ,
	[H_SerialNo] [varchar] (15) COLLATE Chinese_PRC_CI_AS NULL ,
	[H_Truck] [varchar] (15) COLLATE Chinese_PRC_CI_AS NULL ,
	[H_Value] [decimal](15, 5) NULL ,
	[H_BillDate] [datetime] NULL ,
	[H_ReportDate] [datetime] NULL ,
	[H_Reporter] [varchar] (32) COLLATE Chinese_PRC_CI_AS NULL 
) ON [PRIMARY]
GO
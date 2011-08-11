---------------------------------------------------------------------------------------------
-- dmzn@163.com 2011.08.07
-- 该脚本用于调整某笔记录的单价
-- 使用方法: 修改对应的记录编号和新旧单价 
---------------------------------------------------------------------------------------------

Declare @nEID int		--记录编号
Declare @nCusID varChar(16)	--客户编号
Declare @nBill varChar(16)	--提货单号

Declare @nOPrice float		--旧单价
Declare @nNPrice float		--新单价
Declare @nValue float		--提货量

Declare @nInt int
Declare @nStr varChar(16)
--所需变量

Set @nEID=86
Set @nOPrice=12
Set @nNPrice=34

Select @nCusID=L_Custom,@nBill=L_ID,@nValue=L_Value From S_Bill,Sys_TruckLogExt Where L_ID=E_Bill And E_ID=@nEID And E_Price=@nOPrice
--获取客户号
if @nCusID is null
begin
  print '记录不存在或单价已修改!!'
  return
end

Print '客户编号: ' + @nCusID
Print '提货单号: ' + @nBill
Print '提货数量: ' + str(@nValue)

Select @nStr=L_IsDone From S_Bill Where L_ID=@nBill
if @nStr <> 'Y'
begin
  Print '该提货单还未出厂,请直接删除!!'
  return
end

Update S_Bill Set L_Price=@nNPrice Where L_ID=@nBill
--提货单

Update Sys_TruckLogExt Set E_Price=@nNPrice Where E_Bill=@nBill
--提货记录

Update Sys_CustomerAccount Set A_OutMoney=A_OutMoney-@nValue*(@nOPrice-@nNPrice) Where A_CID=@nCusID
--出金账户


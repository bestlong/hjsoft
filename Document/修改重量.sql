---------------------------------------------------------------------------------------------
-- dmzn@163.com 2011.08.07
-- 该脚本用于调整某笔记录的提货量
-- 使用方法: 修改对应的记录编号和新旧单价 
---------------------------------------------------------------------------------------------

Declare @nEID int		--记录编号
Declare @nDel char(1)		--是否删除
Declare @nCusID varChar(16)	--客户编号
Declare @nBill varChar(16)	--提货单号
Declare @nTruck varChar(16)	--车辆记录

Declare @nOValue float		--旧量
Declare @nNValue float		--新量
Declare @nPrice float		--单价

Declare @nInt int
Declare @nStr varChar(16)
--所需变量
Set @nDel='N'
--是否删除标记(危险)

Set @nEID=1
Set @nOValue=173.81
Set @nNValue=13.9

Select @nCusID=L_Custom,@nBill=L_ID,@nPrice=L_Price,@nTruck=E_TID From S_Bill,Sys_TruckLogExt Where L_ID=E_Bill And E_ID=@nEID And E_Value=@nOValue
--获取客户号
if @nCusID is null
begin
  print '记录不存在或提货量已修改!!'
  return
end

Print '客户编号: ' + @nCusID
Print '提货单号: ' + @nBill
Print '提货单价: ' + str(@nPrice)
Print '提货车辆: ' + @nTruck

Select @nStr=L_IsDone From S_Bill Where L_ID=@nBill
if @nStr <> 'Y'
begin
  Print '该提货单还未出厂,请直接删除!!'
  return
end
 
if @nDel='Y' 
begin
  Select @nInt=Count(*) From Sys_TruckLogExt Where E_TID=@nTruck
  if @nInt > 1
  begin
    Print '该脚本不能处理合卡操作!!'
    return
  end

  Set @nNValue=0
  --清理出金
  Delete From S_Bill Where L_ID=@nBill
  --删除提货单
  Delete From Sys_TruckLog Where T_ID=@nTruck
  --删除车辆记录
  Delete From Sys_TruckLogExt Where E_Bill=@nBill
  --删除进厂记录
end else 
begin  
  Update S_Bill Set L_Value=@nNValue Where L_ID=@nBill
  --提货单
  Update Sys_TruckLogExt Set E_Value=@nNValue Where E_Bill=@nBill
  --提货记录
end

Update Sys_CustomerAccount Set A_OutMoney=A_OutMoney-@nPrice*(@nOValue-@nNValue) Where A_CID=@nCusID
--出金账户

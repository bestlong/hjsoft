---------------------------------------------------------------------------------------------
-- dmzn@163.com 2011.08.07
-- �ýű����ڵ���ĳ�ʼ�¼�������
-- ʹ�÷���: �޸Ķ�Ӧ�ļ�¼��ź��¾ɵ��� 
---------------------------------------------------------------------------------------------

Declare @nEID int		--��¼���
Declare @nDel char(1)		--�Ƿ�ɾ��
Declare @nCusID varChar(16)	--�ͻ����
Declare @nBill varChar(16)	--�������
Declare @nTruck varChar(16)	--������¼

Declare @nOValue float		--����
Declare @nNValue float		--����
Declare @nPrice float		--����

Declare @nInt int
Declare @nStr varChar(16)
--�������
Set @nDel='N'
--�Ƿ�ɾ�����(Σ��)

Set @nEID=1
Set @nOValue=173.81
Set @nNValue=13.9

Select @nCusID=L_Custom,@nBill=L_ID,@nPrice=L_Price,@nTruck=E_TID From S_Bill,Sys_TruckLogExt Where L_ID=E_Bill And E_ID=@nEID And E_Value=@nOValue
--��ȡ�ͻ���
if @nCusID is null
begin
  print '��¼�����ڻ���������޸�!!'
  return
end

Print '�ͻ����: ' + @nCusID
Print '�������: ' + @nBill
Print '�������: ' + str(@nPrice)
Print '�������: ' + @nTruck

Select @nStr=L_IsDone From S_Bill Where L_ID=@nBill
if @nStr <> 'Y'
begin
  Print '���������δ����,��ֱ��ɾ��!!'
  return
end
 
if @nDel='Y' 
begin
  Select @nInt=Count(*) From Sys_TruckLogExt Where E_TID=@nTruck
  if @nInt > 1
  begin
    Print '�ýű����ܴ���Ͽ�����!!'
    return
  end

  Set @nNValue=0
  --�������
  Delete From S_Bill Where L_ID=@nBill
  --ɾ�������
  Delete From Sys_TruckLog Where T_ID=@nTruck
  --ɾ��������¼
  Delete From Sys_TruckLogExt Where E_Bill=@nBill
  --ɾ��������¼
end else 
begin  
  Update S_Bill Set L_Value=@nNValue Where L_ID=@nBill
  --�����
  Update Sys_TruckLogExt Set E_Value=@nNValue Where E_Bill=@nBill
  --�����¼
end

Update Sys_CustomerAccount Set A_OutMoney=A_OutMoney-@nPrice*(@nOValue-@nNValue) Where A_CID=@nCusID
--�����˻�

---------------------------------------------------------------------------------------------
-- dmzn@163.com 2011.08.07
-- �ýű����ڵ���ĳ�ʼ�¼�ĵ���
-- ʹ�÷���: �޸Ķ�Ӧ�ļ�¼��ź��¾ɵ��� 
---------------------------------------------------------------------------------------------

Declare @nEID int		--��¼���
Declare @nCusID varChar(16)	--�ͻ����
Declare @nBill varChar(16)	--�������

Declare @nOPrice float		--�ɵ���
Declare @nNPrice float		--�µ���
Declare @nValue float		--�����

Declare @nInt int
Declare @nStr varChar(16)
--�������

Set @nEID=86
Set @nOPrice=12
Set @nNPrice=34

Select @nCusID=L_Custom,@nBill=L_ID,@nValue=L_Value From S_Bill,Sys_TruckLogExt Where L_ID=E_Bill And E_ID=@nEID And E_Price=@nOPrice
--��ȡ�ͻ���
if @nCusID is null
begin
  print '��¼�����ڻ򵥼����޸�!!'
  return
end

Print '�ͻ����: ' + @nCusID
Print '�������: ' + @nBill
Print '�������: ' + str(@nValue)

Select @nStr=L_IsDone From S_Bill Where L_ID=@nBill
if @nStr <> 'Y'
begin
  Print '���������δ����,��ֱ��ɾ��!!'
  return
end

Update S_Bill Set L_Price=@nNPrice Where L_ID=@nBill
--�����

Update Sys_TruckLogExt Set E_Price=@nNPrice Where E_Bill=@nBill
--�����¼

Update Sys_CustomerAccount Set A_OutMoney=A_OutMoney-@nValue*(@nOPrice-@nNPrice) Where A_CID=@nCusID
--�����˻�


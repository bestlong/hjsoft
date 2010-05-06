Update Sys_CustomerAccount Set
  A_OutMoney=IsNull(
	(Select Sum(L_Value*L_Price) from Sys_TruckLogExt
  	 Left Join S_Bill b on b.L_ID=E_Bill  
  	 Left Join Sys_TruckLog tl on tl.T_ID=E_TID
	 Where T_Status='O' and L_Custom=A_CID), 0),
  A_FreezeMoney=IsNull(
	(Select Sum(L_Value*L_Price) From S_Bill
  	 Left Join (Select E_Bill,T_Status From Sys_TruckLogExt Left Join Sys_TruckLog tl on tl.T_ID=E_TID)  te on te.E_Bill=L_ID  
  	 Where (T_Status Is Null or T_Status<>'O') and L_Custom=A_CID), 0)
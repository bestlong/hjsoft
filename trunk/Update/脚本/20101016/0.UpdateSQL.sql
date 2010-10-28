ALTER Table P_Provider Add P_Saler varChar(32);
ALTER Table P_ProvideLog Add L_PaiNum varChar(15), L_PaiTime DateTime, L_Money Decimal(15, 5), L_YunFei Decimal(15, 5), L_HSer varChar(32), L_HSDate DateTime, L_JSer varChar(32), L_JSDate DateTime;
--修改供应商,供应记录表
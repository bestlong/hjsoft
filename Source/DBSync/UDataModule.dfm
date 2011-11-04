object FDM: TFDM
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Left = 432
  Top = 136
  Height = 225
  Width = 362
  object ADOConn: TADOConnection
    LoginPrompt = False
    Left = 22
    Top = 10
  end
  object SqlQuery: TADOQuery
    Connection = ADOConn
    Parameters = <>
    Left = 76
    Top = 11
  end
  object Command: TADOQuery
    Connection = ADOConn
    Parameters = <>
    Left = 128
    Top = 11
  end
  object Query_bak: TADOQuery
    Connection = Conn_bak
    Parameters = <>
    Left = 75
    Top = 70
  end
  object Conn_bak: TADOConnection
    LoginPrompt = False
    Left = 18
    Top = 70
  end
  object Cmd_bak: TADOQuery
    Connection = Conn_bak
    Parameters = <>
    Left = 130
    Top = 71
  end
end

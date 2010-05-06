  CREATE PROCEDURE   dbo.OutputData     
  @tablename   sysname      
  AS      
  declare   @column   varchar(1000)     
  declare   @columndata   varchar(1000)     
  declare   @sql   varchar(4000)     
  declare   @xtype   tinyint      
  declare   @name   sysname      
  declare   @objectId   int      
  declare   @objectname   sysname      
  declare   @ident   int      

  set   nocount   on      
  set   @objectId=object_id(@tablename)     
  if  @objectId   is   null   --   �ж϶����Ƿ����     
     begin      
      print  @tablename +  '���󲻴���'     
      return      
    end     

  set @objectname=rtrim(object_name(@objectId))     
  if @objectname is null or charindex(@objectname,@tablename)=0
    begin      
      print  @tablename +  '�����ڵ�ǰ���ݿ���'      
      return      
    end        

  if  OBJECTPROPERTY(@objectId,'IsTable')   <   >   1   --   �ж϶����Ƿ��Ǳ�     
    begin      
      print  @tablename +  '�����Ǳ�'     
      return      
    end        

  select   @ident=status&0x80   from   syscolumns   where   id=@objectid   and   status&0x80=0x80         

  if @ident is   not   null      
    print   'SET   IDENTITY_INSERT   '+ @TableName + '   ON'    


  --�����α꣬ѭ��ȡ���ݲ�����Insert���
  declare  syscolumns_cursor  cursor for   
    select   c.name,c.xtype   from   syscolumns   c     
      where   c.id=@objectid     
      order   by   c.colid    

  --���α�
  open   syscolumns_cursor     
  set  @column=''     
  set  @columndata=''     
  fetch   next   from   syscolumns_cursor   into   @name,@xtype     
  while   @@fetch_status   <> -1     
    begin      
    if   @@fetch_status   <> -2     
      begin      
      if   @xtype   not   in(189,34,35,99,98)   --timestamp���账��image,text,ntext,sql_variant ��ʱ������     
        begin      
        set   @column=@column + 
          case   when   len(@column)=0   then ''  
                 else   ','
                 end + @name     
        set   @columndata = @columndata + 
          case   when   len(@columndata)=0   then   ''   
                 else   ','','','
                 end  + 
          case   when  @xtype   in(167,175)  then   '''''''''+'+@name+'+'''''''''                --varchar,char     
                 when   @xtype   in(231,239)   then   '''N''''''+'+@name+'+'''''''''             --nvarchar,nchar     
                 when   @xtype=61   then   '''''''''+convert(char(23),'+@name+',121)+'''''''''   --datetime     
                 when   @xtype=58   then   '''''''''+convert(char(16),'+@name+',120)+'''''''''   --smalldatetime     
                  when   @xtype=36   then   '''''''''+convert(char(36),'+@name+')+'''''''''       --uniqueidentifier     
                 else   @name   
                 end      
        end      
      end      
    fetch   next   from   syscolumns_cursor   into   @name,@xtype     
    end      
  close   syscolumns_cursor     
  deallocate   syscolumns_cursor         

  set  @sql='set   nocount   on   select   ''insert   '+@tablename+'('+@column+')   values(''as   ''--'','+@columndata+','')''   from   '+@tablename        

  print   '--'+@sql     
  exec(@sql)         

  if   @ident   is   not   null      
  print  'SET   IDENTITY_INSERT   '+@TableName+'   OFF'
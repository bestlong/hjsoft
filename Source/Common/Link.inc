{.$DEFINE debug}
//调试模式

{.$DEFINE TrialVersion}
//试用版本

{$DEFINE UseReport}
//报表支持

{.$DEFINE RandomID}
//使用随机编号

{$DEFINE cxLibrary42}
//Ver4.2编译环境

{$DEFINE yx}
//待编译的系统代码

//长城
{$IFDEF cc}
  {$DEFINE HYEachTruck}
  //随车开化验单
{$ENDIF}

//春江
{$IFDEF cj}
  {$DEFINE MultiJS}
  //多道计数器支持

  {$DEFINE HYEachTruck}
  //随车开化验单

  {$DEFINE EnableBackupDB}
  //备用数据库支持
{$ENDIF}

//恒基
{$IFDEF hj}
  {$DEFINE JSVerify}
  //单道计数器支持校验

  {$DEFINE MultiJS}
  //多道计数器支持
{$ENDIF}

//永安
{$IFDEF ya}
  {$DEFINE MultiJS}
  //多道计数器支持

  {$DEFINE HYEachTruck}
  //随车开化验单

  {$DEFINE ProvideSplitPM}
  //供应皮、毛单独处理
{$ENDIF}

//豫新
{$IFDEF yx}
  {$DEFINE MultiJS}
  //多道计数器支持

  {$DEFINE HYEachTruck}
  //随车开化验单
{$ENDIF}
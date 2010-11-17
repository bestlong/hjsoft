program MakeBD;

uses
  Windows,
  Forms,
  UFormMain in 'UFormMain.pas' {fFormMain},
  USysConst in 'USysConst.pas',
  UDataReport in 'UDataReport.pas' {FDR: TDataModule};

{$R *.res}
var
  gMutexHwnd: Hwnd;
  //互斥句柄

begin
  gMutexHwnd := CreateMutex(nil, True, 'RunSoft_HJ_MakeBD');
  //创建互斥量
  if GetLastError = ERROR_ALREADY_EXISTS then
  begin
    ReleaseMutex(gMutexHwnd);
    CloseHandle(gMutexHwnd); Exit;
  end; //已有一个实例

  Application.Initialize;
  Application.CreateForm(TfFormMain, fFormMain);
  Application.CreateForm(TFDR, FDR);
  Application.Run;

  ReleaseMutex(gMutexHwnd);
  CloseHandle(gMutexHwnd);
end.

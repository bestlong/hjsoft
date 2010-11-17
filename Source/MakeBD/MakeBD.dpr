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
  //������

begin
  gMutexHwnd := CreateMutex(nil, True, 'RunSoft_HJ_MakeBD');
  //����������
  if GetLastError = ERROR_ALREADY_EXISTS then
  begin
    ReleaseMutex(gMutexHwnd);
    CloseHandle(gMutexHwnd); Exit;
  end; //����һ��ʵ��

  Application.Initialize;
  Application.CreateForm(TfFormMain, fFormMain);
  Application.CreateForm(TFDR, FDR);
  Application.Run;

  ReleaseMutex(gMutexHwnd);
  CloseHandle(gMutexHwnd);
end.

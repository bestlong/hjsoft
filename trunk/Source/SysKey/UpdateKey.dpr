program UpdateKey;

uses
  Forms,
  UFormUpdate in 'UFormUpdate.pas' {fFormMain};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'System Key';
  Application.CreateForm(TfFormMain, fFormMain);
  Application.Run;
end.

program Sincronizador;

uses
  Vcl.Forms,
  Winapi.Windows,
  Vcl.Dialogs,
  Principal in 'Principal.pas' {Form1},
  uConsultas in 'uConsultas.pas',
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

var
  MutexHandle: Cardinal;

begin
  if (OpenMutex(MUTEX_ALL_ACCESS, false, 'Sincroniador') = 0) then
    MutexHandle := CreateMutex(nil, false, 'Sincroniador')
  else begin
    MessageDlg('Sincroniador Web já está ativo!', mtInformation, [mbok],0);
    SetForegroundWindow(FindWindow('TApplication', 'Sincroniador'));
    exit;
  end;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Tag := MutexHandle;
  Application.Title := '';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

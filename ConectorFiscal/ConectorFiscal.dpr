program ConectorFiscal;

uses
  Vcl.Forms,
  Winapi.Windows,
  Vcl.Dialogs,
  uPrincipal in 'uPrincipal.pas' {Form1},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
var
  //MutexHandle: THandle;
  MutexHandle: Cardinal;
begin

  {MutexHandle := CreateMutex(nil, True, 'PortalContador');
    if (MutexHandle <> 0) and (GetLastError = ERROR_ALREADY_EXISTS) then
      begin
        ShowMessage('Já existe uma instância da aplicação em execução.');
        Halt;
      end;}
  if (OpenMutex(MUTEX_ALL_ACCESS, false, 'ConectorFiscal') = 0) then
    MutexHandle := CreateMutex(nil, false, 'ConectorFiscal')
  else begin
    MessageDlg('Conector Fiscal já está ativo!', mtInformation, [mbok],0);
    SetForegroundWindow(FindWindow('TApplication', 'ConectorFiscal'));
    exit;
  end;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Tag := MutexHandle;
  Application.CreateForm(TForm1, Form1);
  Application.Run;

  {if MutexHandle <> 0 then
    CloseHandle(MutexHandle);}
end;

end.

unit UConfigDatabase;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  System.ImageList, Vcl.ImgList, IniFiles, ShellApi;

type
  TFrmConfigDatabase = class(TForm)
    Label1: TLabel;
    EdtPath: TEdit;
    Label2: TLabel;
    EdtServer: TEdit;
    Panel2: TPanel;
    btnGravar: TSpeedButton;
    btnCancelar: TSpeedButton;
    ImageList1: TImageList;
    SpeedButton1: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmConfigDatabase: TFrmConfigDatabase;

implementation

{$R *.dfm}

uses Udados;

procedure TFrmConfigDatabase.btnCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmConfigDatabase.btnGravarClick(Sender: TObject);
var
  ArqIni: TIniFile;
begin
  ArqIni := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Banco.ini');
  if Trim(EdtPath.Text) = '' then
    EdtPath.Text := 'C:\Gestor\dados\dados.fdb';
  if Trim(EdtServer.Text) = '' then
    EdtPath.Text := 'localhost';
  try
    ArqIni.WriteString('BD', 'IP', EdtServer.Text);
    ArqIni.WriteString('BD', 'Path', EdtPath.Text);
    MessageDlg('Reinicie o sistema para que as alterações entrem em vigor', mtInformation,[mbok],0);
    Close;
  finally
    ArqIni.Free;
  end;

end;

procedure TFrmConfigDatabase.FormCreate(Sender: TObject);
var
  ArqIni: TIniFile;
begin
  ArqIni := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Banco.ini');
  try
    EdtServer.Text := ArqIni.ReadString('BD', 'IP', 'localhost');
    EdtPath.Text  := ArqIni.ReadString('BD', 'Path', 'C:\Gestor\dados\dados.fdb');
  finally
    ArqIni.Free;
  end;
end;

procedure TFrmConfigDatabase.SpeedButton1Click(Sender: TObject);
var
  ShellExecInfo: TShellExecuteInfo;
  S : string;
begin
  S := 'advfirewall firewall add rule name="Firebird 3050" dir=in action=allow protocol=TCP localport=3050';
//  ShellExecute(Application.Handle, nil, 'netsh.exe',pChar(S),nil, SW_HIDE);
  FillChar(ShellExecInfo, SizeOf(ShellExecInfo), 0);
  ShellExecInfo.cbSize := sizeof(ShellExecInfo);
  ShellExecInfo.Wnd := 0;
  ShellExecInfo.fMask := SEE_MASK_FLAG_DDEWAIT or SEE_MASK_FLAG_NO_UI;
  ShellExecInfo.lpVerb := 'runas';
  ShellExecInfo.lpFile := PChar('netsh.exe');
  ShellExecInfo.lpParameters := PChar(S);
  ShellExecInfo.nShow := SW_SHOWNORMAL;
  ShellExecuteEx(@ShellExecInfo);
end;

end.

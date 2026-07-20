unit ufrmMensagemEspera;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,  ExtCtrls, StdCtrls, JvExControls, JvLabel, Vcl.Imaging.pngimage;

type
  TfrmMENSAGEMespera = class(TForm)
    Timer1: TTimer;
    Panel1: TPanel;
    imgIcone: TImage;
    lblMensagem: TJvLabel;
    Shape1: TShape;
    Image1: TImage;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Image1Click(Sender: TObject);
  private
    WindowsList: TTaskWindowList;
    vPodeFechar: Boolean;
  public
  end;

var
  frmMENSAGEMespera: TfrmMENSAGEMespera;

procedure AbrirEspera(AOwner: TComponent; const AMensagem: string; const ATempo:Integer = 0);
procedure FecharEspera;

implementation

uses uDados, uPrincipal;

{$R *.dfm}

procedure AbrirEspera(AOwner: TComponent; const AMensagem: string; const ATempo:Integer = 0);
begin
  if frmMensagemEspera <> nil then
  begin
    if frmMensagemEspera.ShowHint then
      frmMensagemEspera.Hide;

    frmMensagemEspera.lblMensagem.Caption := AMensagem;
    frmMensagemEspera.Show;
  end
  else
  begin
    frmMensagemEspera := TfrmMensagemEspera.Create(AOwner);
    frmMensagemEspera.WindowsList := DisableTaskWindows(frmMensagemEspera.Handle);
    frmMensagemEspera.lblMensagem.Caption := AMensagem;
    frmMensagemEspera.Show;
  end;

  frmMensagemEspera.Width := 110 + (Length(Trim(AMensagem)) * 8);
  frmMensagemEspera.Update;
  frmMensagemEspera.BringToFront;
  frmMensagemEspera.Position := poOwnerFormCenter;

  Application.ProcessMessages;

  Sleep(ATempo * 1000);
end;

procedure FecharEspera;
begin
  if frmMensagemEspera <> nil then
  begin
    if frmMensagemEspera.WindowsList <> nil then
      EnableTaskWindows(frmMensagemEspera.WindowsList);
    FreeAndNil(frmMensagemEspera);
  end;
end;

procedure TfrmMENSAGEMespera.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := vPodeFechar;
end;

procedure TfrmMENSAGEMespera.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  {if (Key = VK_ESCAPE) then//and (frmMensagemEspera.lblMensagem.Caption = 'Aguardando ativação da licença') then
  begin
    vPodeFechar := true;
    dados.vCancelaLicenca := true;
  end;}
end;

procedure TfrmMENSAGEMespera.Image1Click(Sender: TObject);
begin
  {if (frmMensagemEspera.lblMensagem.Caption = 'Aguardando ativação da licença') then
   if Application.messageBox('Tem certeza de que deseja cancelar a ativação da licença?',
        'Confirmação', mb_YesNo) = mrYes then
   begin
     vPodeFechar := true;
     dados.vCancelaLicenca := true;

     if Assigned(frmPrincipal.Pipedream) then
       frmPrincipal.Pipedream.Cancela := true;
   end;}
end;

end.

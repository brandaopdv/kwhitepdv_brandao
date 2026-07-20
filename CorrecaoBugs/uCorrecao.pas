unit uCorrecao;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Phys.FBDef, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.FB, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, Vcl.StdCtrls, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FireDAC.Phys.IBBase;

type
  TForm1 = class(TForm)
    FDPhysFBDriverLink1: TFDPhysFBDriverLink;
    FDConexao: TFDConnection;
    QryCorrigir: TFDQuery;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  Try
    FDConexao.Connected := True;
  Except
    ShowMessage('Erro ao conectar na base de dados');
  End;
  Try
    QryCorrigir.SQL.Clear;
    QryCorrigir.SQL.Add('DELETE FROM LOG_TERMINAL WHERE LOGOUT_DATA IS NULL');
    QryCorrigir.ExecSQL;
  Except
    ShowMessage('Erro ao corrigir a REDE');
  End;
  FDConexao.Close;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Try
    FDConexao.Connected := True;
  Except
    ShowMessage('Erro ao conectar na base de dados');
  End;
  Try
    QryCorrigir.SQL.Clear;
    QryCorrigir.SQL.Add('UPDATE CONTAS SET DATA_ABERTURA = NULL, ID_USUARIO = NULL, LOTE = NULL, SITUACAO = ''F'' where CODIGO = 2');
    QryCorrigir.ExecSQL;
  Except
    ShowMessage('Erro ao corrigir a REDE');
  End;
  FDConexao.Close;
end;

end.

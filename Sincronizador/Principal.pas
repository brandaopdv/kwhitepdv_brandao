unit Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,  Vcl.StdCtrls,
  Vcl.ExtCtrls, FireDAC.Stan.Intf, FireDAC.Stan.Option, ClipBrd,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.Phys.FB,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,IniFiles,
  Vcl.AppEvnts, System.JSON, Vcl.ComCtrls, FireDAC.Phys.Intf,
  FireDAC.Phys.FBDef, FireDAC.DApt.Intf, FireDAC.Phys.MySQLDef,
  FireDAC.Phys.MySQL, FireDAC.Phys.IBBase, FireDAC.Comp.UI, Registry, Vcl.Menus,
  ShlObj, ActiveX, ComObj, System.ImageList, Vcl.ImgList, Vcl.Mask, Vcl.DBCtrls,
  IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    imageAcerto: TImage;
    imageErro: TImage;
    editMinutos: TEdit;
    banco: TFDConnection;
    FDQuery1: TFDQuery;
    TrayIcon1: TTrayIcon;
    ApplicationEvents1: TApplicationEvents;
    TimeGo: TTimer;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    btn_ligar: TButton;
    btnDesligar: TButton;
    TabSheet3: TTabSheet;
    Memo1: TMemo;
    FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
    pnEmail: TEdit;
    Conexao: TFDConnection;
    qryAux: TFDQuery;
    Transacao: TFDTransaction;
    WaitCursor: TFDGUIxWaitCursor;
    FBDriver: TFDPhysFBDriverLink;
    IdHTTP1: TIdHTTP;
    chkIniciarWindows: TCheckBox;
    pmMenu: TPopupMenu;
    RestaurarAplicao1: TMenuItem;
    SairdaAplicao1: TMenuItem;
    tmrIniciar: TTimer;
    chkSincVendas: TCheckBox;
    chkSincFiscal: TCheckBox;
    lb_email: TLabel;
    GroupBox2: TGroupBox;
    lb_api: TLabel;
    edt_api: TEdit;
    TabSheet5: TTabSheet;
    GroupBox3: TGroupBox;
    qryEmpresa: TFDQuery;
    qryEmpresaCODIGO: TIntegerField;
    qryEmpresaFANTASIA: TStringField;
    qryEmpresaRAZAO: TStringField;
    qryEmpresaCNPJ: TStringField;
    dsEmpresa: TDataSource;
    qryEmpresaRESPONSAVEL_EMPRESA: TStringField;
    qryEmpresaEMAIL: TStringField;
    Label5: TLabel;
    DBEdit_fantasia: TDBEdit;
    Label6: TLabel;
    DBEdit_razao: TDBEdit;
    Label7: TLabel;
    DBEdit_cnpj: TDBEdit;
    Label8: TLabel;
    DBEdit_responsavel: TDBEdit;
    Label9: TLabel;
    DBEdit_email: TDBEdit;
    Label4: TLabel;
    edt_api2: TEdit;
    chk_notificacao: TCheckBox;
    Memo_log: TMemo;
    GroupBox_log: TGroupBox;
    cxBtn_sync: TButton;
    cxButton_enviar_empresa: TButton;
    PopupMenu1: TPopupMenu;
    Copiar1: TMenuItem;
    ImageList1: TImageList;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    CheckBox1: TCheckBox;
    GroupBox1: TGroupBox;
    maskInicio: TMaskEdit;
    maskFim: TMaskEdit;
    LblPeriodo: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure TrayIcon1DblClick(Sender: TObject);
    procedure ApplicationEvents1Minimize(Sender: TObject);
    procedure TimeGoTimer(Sender: TObject);
    procedure btnDesligarClick(Sender: TObject);
    procedure btn_ligarClick(Sender: TObject);
    procedure Label3Click(Sender: TObject);
    procedure bancoError(ASender, AInitiator: TObject;
      var AException: Exception);
    procedure RestaurarAplicao1Click(Sender: TObject);
    procedure SairdaAplicao1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure tmrIniciarTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cxBtn_syncClick(Sender: TObject);
    procedure cxButton_enviar_empresaClick(Sender: TObject);
    procedure Copiar1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
     bIniciado: Boolean;
     sErro: String;

     procedure vendasTotal;
     procedure delivery;
     procedure mesas;
     procedure InsereAcerto;
     procedure abreConfig;
     procedure mensagens(mensagem:string);
     procedure salvaConfiguracoes(liga:string);
     procedure InciarComWindows(Iniciar: Boolean);
     procedure HideApplication;
     procedure ChangeStatusWindow;
     function GerarJSON(data1, data2: TDateTime): string;
     function naoVazio(valor:string):string;
     function insere_dados:boolean;
     function insere_empresa:boolean;
     function GetHandleOnTaskBar: THandle;
     procedure DoHandlerException(Sender: TObject; E: Exception);
     function ObterVersaoSO: String;
     function UsuarioLogado: string;
     procedure GravaLog(AErro: String);
  public
     procedure ShowBalloonTips(IconMessage: Integer = 0; MessageValue: string = '');
     procedure ShowApplication;
  end;
  
  vendasTotal = record
   vendasFeitas,
   vendasCanceladas,
   ticketsEmitidos,
   ticketMedio,
   vendasBalcao,
   vendasDelivery,
   vendasMesas,
   comandaVendas,
   dinheiro,
   pix, //02-01-2024
   credito,
   debito:string;
  end;

  vendasBalcao = record
   vendasFeitas,
   vendasCanceladas,
   ticketsEmitidos,
   ticketMedio,
   descontos,
   acrescimos,
   dinheiro,
   pix, //02-01-2024
   credito,
   debito:string;
  end;

  vendasDelivery = record
   vendasFeitas,
   vendasCanceladas,
   ticketsEmitidos,
   ticketMedio,
   descontos,
   taxaEntrega,
   acrescimos,
   dinheiro,
   pix, //02-01-2024
   credito,
   debito:string;
  end;

  vendasMesas = record
   vendasFeitas,
   vendasCanceladas,
   ticketsEmitidos,
   ticketMedio,
   descontos,
   Gorjetas,
   acrescimos,
   dinheiro,
   pix, //02-01-2024
   credito,
   debito:string;
  end;

  var
   json:string;
   dadosVendasTotal   : vendasTotal;
   dadosVendaBalcao   : vendasBalcao;
   dadosVendaDelivery : vendasDelivery;
   dadosVendaMesas    : vendasMesas;

var
  Form1: TForm1;
  email,
  api,
  api2,
  tempo,
  ligado,
  banco1:string;
  json_estoque_minimo:string;
  json_mais_vendidos:string;
  json_venda_garcom:string;
  json_pagamento_total:string;
  json_pagamento_mesas:string;
  json_pagamento_balcao:string;
  json_pagamento_delivery:string;  

implementation

{$R *.dfm}

uses uConsultas;

procedure TForm1.abreConfig;
var
  arquivo: tinifile;
  Cria: TStringList;
begin
  arquivo := tinifile.Create(ExtractFilePath(Application.ExeName)+'app.ini');
  try
    //email := arquivo.readString ('config','email','');
    ligado := arquivo.readString ('config','ligado','');
    tempo := arquivo.readString ('config','tempo','');
    api := arquivo.readString ('config','api','');
    api2 := arquivo.readString ('config','api2','');
    editMinutos.Text := tempo;
    //pnEmail.Text := email;
    edt_api.Text := api;
    edt_api2.Text := api2;
    chkIniciarWindows.Checked := arquivo.ReadBool('config', 'inciarwindows', False);
    chkSincVendas.Checked := arquivo.ReadBool('config', 'SincVendas', False);
    chkSincFiscal.Checked := arquivo.ReadBool('config', 'SincNFe',False);
    chk_notificacao.Checked := arquivo.ReadBool('config', 'notificacao', False);
  finally
    arquivo.free;
  end;
end;

procedure TForm1.ApplicationEvents1Minimize(Sender: TObject);
begin
  if ligado = 'S' then
  begin
    begin
      TrayIcon1.Visible := true;
      Self.Hide;
      Self.WindowState := wsMinimized;
      mensagens('Sincronizador - White PDV');
    end;
  end else
  begin
    Application.Terminate;
  end;
end;   

procedure TForm1.bancoError(ASender, AInitiator: TObject;
  var AException: Exception);
begin
  Memo_log.Lines.Add(AException.Message);
  GravaLog(AException.Message);
end;

procedure TForm1.btnDesligarClick(Sender: TObject);
begin
  salvaConfiguracoes('N');
  btnDesligar.Visible := false;
  btn_ligar.Visible := true;

  // 13-06-2024
  chkIniciarWindows.Enabled := true;
  chk_notificacao.Enabled := true;
  chkSincVendas.Enabled := true;
  chkSincFiscal.Enabled := true;
  //edt_api.Enabled := true;
  //pnEmail.Enabled := true;
end;

procedure TForm1.btn_ligarClick(Sender: TObject);
begin
  salvaConfiguracoes('S');
  btnDesligar.Visible := true;

  // 13-06-2024
  chkIniciarWindows.Enabled := false;
  chk_notificacao.Enabled := false;
  chkSincVendas.Enabled := false;
  chkSincFiscal.Enabled := false;
  //edt_api.Enabled := false;
  //pnEmail.Enabled := false;
end;

procedure TForm1.ChangeStatusWindow;
begin
  if Self.Visible Then
    SairdaAplicao1.Caption := 'Minimizar'
  else
    SairdaAplicao1.Caption := 'Sair';
  Application.ProcessMessages;
end;

procedure TForm1.Copiar1Click(Sender: TObject);
begin
  Clipboard.Clear;
  Clipboard.AsText := Memo1.Text;
  MessageDlg('LOG copiado com sucesso!', TMsgDlgType.mtInformation, [mbok],0);
end;

procedure TForm1.cxBtn_syncClick(Sender: TObject);
var
  texto: String;
begin
  try
    if strtodate(maskFim.text) < strtodate(maskInicio.text) then
    begin
      //application.messagebox('Data final não pode ser menor que a inicial',
      //  'Erro', mb_iconstop);
      MessageDlg('Data final não pode ser menor que a inicial!', TMsgDlgType.mtInformation, [mbok],0);
      maskFim.setfocus;
      exit;
    end
    else if strtodate(maskInicio.text) > date then
    begin
      //application.messagebox('Data final não pode ser maior que a data atual',
      //  'Erro', mb_iconstop);
      MessageDlg('Data final não pode ser maior que a data atual!', TMsgDlgType.mtInformation, [mbok],0);
      maskFim.setfocus;
      exit;
    end;
  except
    //application.messagebox('Intervalo de datas inválido.', 'Erro', mb_iconstop);
    MessageDlg('Intervalo de datas inválido!', TMsgDlgType.mtError, [mbok],0);
    maskInicio.setfocus;
    exit;
  end;

  cxBtn_sync.Enabled := false;
  TimeGo.Enabled := false;
  try
    vendasTotal;
    delivery;
    mesas;

    json := GerarJSON(strtodate(maskInicio.EditText), strtodate(maskFim.EditText));
    json := StringReplace(json, #9, '', [rfReplaceAll]); // 04-06-2024 - Remover caracter #9
    Memo1.Text := json;

    if insere_dados then
    begin
      InsereAcerto;
      mensagens('White PDV - Sincronizado');
    end
    else begin
      mensagens('Erro ao enviar os dados');
      Memo_log.Lines.Add('Erro ao enviar os dados');
      Memo_log.Lines.Add(sErro);
      Memo_log.Lines.Add(DateToStr(now)+' - '+TimeToStr(now));
      Memo_log.Lines.Add('');
    end;
  finally
    cxBtn_sync.Enabled := true;
    if ligado = 'S' then
      TimeGo.Enabled := true;
  end;
end;

procedure TForm1.cxButton_enviar_empresaClick(Sender: TObject);
begin
   cxButton_enviar_empresa.Enabled := false;
   TimeGo.Enabled := false;
   try
     if insere_empresa then
     begin
       Memo_log.Lines.Add(DateToStr(now)+' - '+TimeToStr(now));
       Memo_log.Lines.Add('Empresa cadastrada com sucesso');
       Memo_log.Lines.Add('A senha padrão é 123456');
       Memo_log.Lines.Add('O Admin poderá alterar no Painel Web');
       Memo_log.Lines.Add('');
     end;
     {else begin
       //Memo_log.Lines.Add('Empresa não pode ser cadastrada');
       Memo_log.Lines.Add('Erro ao cadastrar empresa');
       Memo_log.Lines.Add(DateToStr(now)+' - '+TimeToStr(now));
       Memo_log.Lines.Add('');
     end;}
   finally
     cxButton_enviar_empresa.Enabled := true;
     if ligado = 'S' then
       TimeGo.Enabled := true;
   end;
end;

{VENDAS DELIVERY}
procedure TForm1.delivery;
begin
  //Nada
end;

procedure TForm1.DoHandlerException(Sender: TObject; E: Exception);
begin
  if Assigned(E) then
  begin
    GravaLog(E.Message);
  end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  qryEmpresa.close;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  // 27-05-2024
  if not bIniciado then
  begin
    CanClose := False;

    if not CanClose then
    begin
      if Application.MessageBox('Deseja fechar o Sincronizar - PDV Kaw White?', 'Confirmação', MB_YESNO+MB_DEFBUTTON2+MB_ICONWARNING) = IDYES then
        CanClose := True;
    end;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  iArq: TIniFile;
  dia, mes, ano: Word;
begin
  bIniciado :=  False;
  Application.OnException := DoHandlerException;

  PageControl1.ActivePage := TabSheet1;

  DecodeDate(Date, ano, mes, dia);
  maskInicio.EditText := '01' + '/' + FormatFloat('00', mes) + '/' + IntToStr(ano);
  maskFim.EditText := datetostr(Date);

  //todo: Somente para debug localhost não certificado ssl
  //IdHTTP1.IOHandler := nil;

  // Banco de dados Local
  Conexao.Connected := False;
  try
    iArq := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Banco.ini');
    Conexao.Params.Values['User_Name']  := iArq.ReadString('BD', 'USER', 'SYSDBA');
    Conexao.Params.Values['Password'] := iArq.ReadString('BD', 'PASS', 'masterkey');
    Conexao.Params.Values['Port'] := iArq.ReadString('BD', 'PORT', '3050');
    Conexao.Params.Values['DriverID'] := 'FB';
    Conexao.Params.Values['Server'] := iArq.ReadString('BD', 'IP', '');
    Conexao.Params.Values['Database'] := iArq.ReadString('BD', 'Path', '');
    FBDriver.VendorLib := ExtractFilePath(Application.ExeName) + 'fbclient.dll';

    try
      Conexao.Connected := True;
    except
      on E: Exception do
      begin
        Memo_log.Lines.Add('Erro ao conectar base de dados');
        Memo_log.Lines.Add(E.Message);
        GravaLog(E.Message);
      end;
    end;
  finally
    iArq.Free;
  end;

  abreConfig;
  if ligado = 'S' then
  begin
    TrayIcon1.Visible := true;  // 05-06-2024
    bIniciado := true;
    btnDesligar.Visible := true;
    editMinutos.Enabled := false;
    ApplicationEvents1.OnMinimize(self);
    btnDesligar.Visible := True;
    editMinutos.Text := tempo;
    timeGo.Interval := (1000 * 60)* StrToInt(tempo);
    timeGo.Enabled := true;
  end
  else begin
    TrayIcon1.Visible := false;  // 05-06-2024
    btn_ligar.Visible := true;
  end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  if not bIniciado then
  begin
    bIniciado := True;
    if chkIniciarWindows.Checked then
      tmrIniciar.Enabled := True;
  end;
  qryEmpresa.Open;

  //todo: Somente se for versao = 'RFIS'
  //chkSincFiscal.Visible :=
end;

function TForm1.GerarJSON(data1, data2: TDateTime): string;
begin
  try
    topProdutos(qryAux, data1, data2);
    RelatorioVendasConcluidas(qryAux, data1, data2);
    RelatorioVendasCanceladas(qryAux, data1, data2);
    VendaUsuarios(qryAux, data1, data2);
    RelatorioVendasDiarias(qryAux);
    RelatorioVendasLucros(qryAux);
    Result :=
       '   {  '+
       '   	"notasFiscais": { '+
       '   		"TotalEnviadas": { '+
       '   			"janeiro": '+NFsTotalMes(qryAux, tmjaneiro, 'T')+', '+
       '   			"feveiro": '+NFsTotalMes(qryAux, tmfeveiro, 'T')+', '+
       '   			"marco": '+NFsTotalMes(qryAux, tmmarco, 'T')+', '+
       '   			"abril": '+NFsTotalMes(qryAux, tmabril, 'T')+', '+
       '   			"maio": '+NFsTotalMes(qryAux, tmmaio, 'T')+', '+
       '   			"junho": '+NFsTotalMes(qryAux, tmjunho, 'T')+', '+
       '   			"julho": '+NFsTotalMes(qryAux, tmjulho, 'T')+', '+
       '   			"agosto": '+NFsTotalMes(qryAux, tmagosto, 'T')+', '+
       '   			"setembro": '+NFsTotalMes(qryAux, tmsetembro, 'T')+', '+
       '   			"outubro": '+NFsTotalMes(qryAux, tmoutubro, 'T')+', '+
       '   			"novembro": '+NFsTotalMes(qryAux, tmnovembro, 'T')+', '+
       '   			"dezembro": '+NFsTotalMes(qryAux, tmdezembro, 'T')+' '+
       '   		}, '+
       '   		"TotalCanceladas": { '+
       '   			"janeiro": '+NFsTotalMes(qryAux, tmjaneiro, 'C')+', '+
       '   			"feveiro": '+NFsTotalMes(qryAux, tmfeveiro, 'C')+', '+
       '   			"marco": '+NFsTotalMes(qryAux, tmmarco, 'C')+', '+
       '   			"abril": '+NFsTotalMes(qryAux, tmabril, 'C')+', '+
       '   			"maio": '+NFsTotalMes(qryAux, tmmaio, 'C')+', '+
       '   			"junho": '+NFsTotalMes(qryAux, tmjunho, 'C')+', '+
       '   			"julho": '+NFsTotalMes(qryAux, tmjulho, 'C')+', '+
       '   			"agosto": '+NFsTotalMes(qryAux, tmagosto, 'C')+', '+
       '   			"setembro": '+NFsTotalMes(qryAux, tmsetembro, 'C')+', '+
       '   			"outubro": '+NFsTotalMes(qryAux, tmoutubro, 'C')+', '+
       '   			"novembro": '+NFsTotalMes(qryAux, tmnovembro, 'C')+', '+
       '   			"dezembro": '+NFsTotalMes(qryAux, tmdezembro, 'C')+' '+
       '   		}, '+
       '   		"TotalContigencia": { '+
       '   			"janeiro": '+NFsTotalMes(qryAux, tmjaneiro, 'O')+', '+
       '   			"feveiro": '+NFsTotalMes(qryAux, tmfeveiro, 'O')+', '+
       '   			"marco": '+NFsTotalMes(qryAux, tmmarco, 'O')+', '+
       '   			"abril": '+NFsTotalMes(qryAux, tmabril, 'O')+', '+
       '   			"maio": '+NFsTotalMes(qryAux, tmmaio, 'O')+', '+
       '   			"junho": '+NFsTotalMes(qryAux, tmjunho, 'O')+', '+
       '   			"julho": '+NFsTotalMes(qryAux, tmjulho, 'O')+', '+
       '   			"agosto": '+NFsTotalMes(qryAux, tmagosto, 'O')+', '+
       '   			"setembro": '+NFsTotalMes(qryAux, tmsetembro, 'O')+', '+
       '   			"outubro": '+NFsTotalMes(qryAux, tmoutubro, 'O')+', '+
       '   			"novembro": '+NFsTotalMes(qryAux, tmnovembro, 'O')+', '+
       '   			"dezembro": '+NFsTotalMes(qryAux, tmdezembro, 'O')+' '+
       '   		} '+
       '   	}, '+
       '   	"vendas": { '+
       '   		"canceladas": { '+
       '   			"janeiro": '+VendasTotalMes(qryAux, tmjaneiro, 'C')+', '+
       '   			"feveiro": '+VendasTotalMes(qryAux, tmfeveiro, 'C')+', '+
       '   			"marco": '+VendasTotalMes(qryAux, tmmarco, 'C')+', '+
       '   			"abril": '+VendasTotalMes(qryAux, tmabril, 'C')+', '+
       '   			"maio": '+VendasTotalMes(qryAux, tmmaio, 'C')+', '+
       '   			"junho": '+VendasTotalMes(qryAux, tmjunho, 'C')+', '+
       '   			"julho": '+VendasTotalMes(qryAux, tmjulho, 'C')+', '+
       '   			"agosto": '+VendasTotalMes(qryAux, tmagosto, 'C')+', '+
       '   			"setembro": '+VendasTotalMes(qryAux, tmsetembro, 'C')+', '+
       '   			"outubro": '+VendasTotalMes(qryAux, tmoutubro, 'C')+', '+
       '   			"novembro": '+VendasTotalMes(qryAux, tmnovembro, 'C')+', '+
       '   			"dezembro": '+VendasTotalMes(qryAux, tmdezembro, 'C')+' '+
       '   		}, '+
       '   		"concluidas": { '+
       '   			"janeiro": '+VendasTotalMes(qryAux, tmjaneiro, 'F')+', '+
       '   			"feveiro": '+VendasTotalMes(qryAux, tmfeveiro, 'F')+', '+
       '   			"marco": '+VendasTotalMes(qryAux, tmmarco, 'F')+', '+
       '   			"abril": '+VendasTotalMes(qryAux, tmabril, 'F')+', '+
       '   			"maio": '+VendasTotalMes(qryAux, tmmaio, 'F')+', '+
       '   			"junho": '+VendasTotalMes(qryAux, tmjunho, 'F')+', '+
       '   			"julho": '+VendasTotalMes(qryAux, tmjulho, 'F')+', '+
       '   			"agosto": '+VendasTotalMes(qryAux, tmagosto, 'F')+', '+
       '   			"setembro": '+VendasTotalMes(qryAux, tmsetembro, 'F')+', '+
       '   			"outubro": '+VendasTotalMes(qryAux, tmoutubro, 'F')+', '+
       '   			"novembro": '+VendasTotalMes(qryAux, tmnovembro, 'F')+', '+
       '   			"dezembro": '+VendasTotalMes(qryAux, tmdezembro, 'F')+' '+
       '   		} '+
       '   	}, '+
       '   	"f_pagamentos": { '+
       '   		"dinheiro": '+VendasFPGTotalMes(qryAux, 'D')+', '+
       '   		"credito": '+VendasFPGTotalMes(qryAux, 'C')+', '+
       '   		"debito": '+VendasFPGTotalMes(qryAux, 'E')+', '+
       '   		"pix": '+VendasFPGTotalMes(qryAux, 'P')+', '+ //02-01-2024 - I
       '   		"prazo": '+VendasFPGTotalMes(qryAux, 'V')+' '+
       '   	}, '+
       '   	"caixa": { '+
       '   		"saldo": { '+
       '   			"janeiro": '+CXSaldoMes(qryAux, tmjaneiro)+', '+
       '   			"feveiro": '+CXSaldoMes(qryAux, tmfeveiro)+', '+
       '   			"marco": '+CXSaldoMes(qryAux, tmmarco)+', '+
       '   			"abril": '+CXSaldoMes(qryAux, tmabril)+', '+
       '   			"maio": '+CXSaldoMes(qryAux, tmmaio)+', '+
       '   			"junho": '+CXSaldoMes(qryAux, tmjunho)+', '+
       '   			"julho": '+CXSaldoMes(qryAux, tmjulho)+', '+
       '   			"agosto": '+CXSaldoMes(qryAux, tmagosto)+', '+
       '   			"setembro": '+CXSaldoMes(qryAux, tmsetembro)+', '+
       '   			"outubro": '+CXSaldoMes(qryAux, tmoutubro)+', '+
       '   			"novembro": '+CXSaldoMes(qryAux, tmnovembro)+', '+
       '   			"dezembro": '+CXSaldoMes(qryAux, tmdezembro)+' '+
       '   		}, '+
       '   		"entradas": { '+
       '   			"janeiro": '+CXEntradaMes(qryAux, tmjaneiro)+', '+
       '   			"feveiro": '+CXEntradaMes(qryAux, tmfeveiro)+', '+
       '   			"marco": '+CXEntradaMes(qryAux, tmmarco)+', '+
       '   			"abril": '+CXEntradaMes(qryAux, tmabril)+', '+
       '   			"maio": '+CXEntradaMes(qryAux, tmmaio)+', '+
       '   			"junho": '+CXEntradaMes(qryAux, tmjunho)+', '+
       '   			"julho": '+CXEntradaMes(qryAux, tmjulho)+', '+
       '   			"agosto": '+CXEntradaMes(qryAux, tmagosto)+', '+
       '   			"setembro": '+CXEntradaMes(qryAux, tmsetembro)+', '+
       '   			"outubro": '+CXEntradaMes(qryAux, tmoutubro)+', '+
       '   			"novembro": '+CXEntradaMes(qryAux, tmnovembro)+', '+
       '   			"dezembro": '+CXEntradaMes(qryAux, tmdezembro)+' '+
       '   		}, '+
       '   		"saidas": { '+
       '   			"janeiro": '+CXSaidaMes(qryAux, tmjaneiro)+', '+
       '   			"feveiro": '+CXSaidaMes(qryAux, tmfeveiro)+', '+
       '   			"marco": '+CXSaidaMes(qryAux, tmmarco)+', '+
       '   			"abril": '+CXSaidaMes(qryAux, tmabril)+', '+
       '   			"maio": '+CXSaidaMes(qryAux, tmmaio)+', '+
       '   			"junho": '+CXSaidaMes(qryAux, tmjunho)+', '+
       '   			"julho": '+CXSaidaMes(qryAux, tmjulho)+', '+
       '   			"agosto": '+CXSaidaMes(qryAux, tmagosto)+', '+
       '   			"setembro": '+CXSaidaMes(qryAux, tmsetembro)+', '+
       '   			"outubro": '+CXSaidaMes(qryAux, tmoutubro)+', '+
       '   			"novembro": '+CXSaidaMes(qryAux, tmnovembro)+', '+
       '   			"dezembro": '+CXSaidaMes(qryAux, tmdezembro)+' '+
       '   		}, '+
       '   		"saldoAtual": '+CXValorAtual(qryAux, 'SALDO')+', '+
       '   		"EntradaAtual": '+CXValorAtual(qryAux, 'ENTRADA')+', '+
       '   		"SaidaAtual": '+CXValorAtual(qryAux, 'SAIDA')+' '+
       '   	}, '+
       '   	"cadastros": { '+
       '   		"produtos": "'+QtdCadastros(qryAux, 'P')+'", '+
       '   		"clientes": "'+QtdCadastros(qryAux, 'C')+'", '+
       '   		"usuarios": "'+QtdCadastros(qryAux, 'U')+'", '+
       '   		"fornecedores": "'+QtdCadastros(qryAux, 'F')+'" '+
       '   	}, '+
       '   	"contasReceber": { '+
       '   		"receber": { '+
       '   			"janeiro": '+TotalCReceber(qryAux, tmjaneiro)+', '+
       '   			"feveiro": '+TotalCReceber(qryAux, tmfeveiro)+', '+
       '   			"marco": '+TotalCReceber(qryAux, tmmarco)+', '+
       '   			"abril": '+TotalCReceber(qryAux, tmabril)+', '+
       '   			"maio": '+TotalCReceber(qryAux, tmmaio)+', '+
       '   			"junho": '+TotalCReceber(qryAux, tmjunho)+', '+
       '   			"julho": '+TotalCReceber(qryAux, tmjulho)+', '+
       '   			"agosto": '+TotalCReceber(qryAux, tmagosto)+', '+
       '   			"setembro": '+TotalCReceber(qryAux, tmsetembro)+', '+
       '   			"outubro": '+TotalCReceber(qryAux, tmoutubro)+', '+
       '   			"novembro": '+TotalCReceber(qryAux, tmnovembro)+', '+
       '   			"dezembro": '+TotalCReceber(qryAux, tmdezembro)+' '+
       '   		}, '+
       '   		"recebidas": { '+
       '   			"janeiro": '+TotalCRecebidas(qryAux, tmjaneiro)+', '+
       '   			"feveiro": '+TotalCRecebidas(qryAux, tmfeveiro)+', '+
       '   			"marco": '+TotalCRecebidas(qryAux, tmmarco)+', '+
       '   			"abril": '+TotalCRecebidas(qryAux, tmabril)+', '+
       '   			"maio": '+TotalCRecebidas(qryAux, tmmaio)+', '+
       '   			"junho": '+TotalCRecebidas(qryAux, tmjunho)+', '+
       '   			"julho": '+TotalCRecebidas(qryAux, tmjulho)+', '+
       '   			"agosto": '+TotalCRecebidas(qryAux, tmagosto)+', '+
       '   			"setembro": '+TotalCRecebidas(qryAux, tmsetembro)+', '+
       '   			"outubro": '+TotalCRecebidas(qryAux, tmoutubro)+', '+
       '   			"novembro": '+TotalCRecebidas(qryAux, tmnovembro)+', '+
       '   			"dezembro": '+TotalCRecebidas(qryAux, tmdezembro)+' '+
       '   		}, '+
       '   		"vencidasAtual": '+TotalCReceberAtual(qryAux, 'VENCIDAS')+', '+
       '   		"pendentesAtual": '+TotalCReceberAtual(qryAux, 'PENDENTES')+', '+
       '   		"pagasAtual": '+TotalCReceberAtual(qryAux, 'PAGAS')+' '+
       '   	}, '+
       '   	"contasPagar": { '+
       '   		"pagas": { '+
       '   			"janeiro": '+TotalCPagar(qryAux, tmjaneiro)+', '+
       '   			"feveiro": '+TotalCPagar(qryAux, tmfeveiro)+', '+
       '   			"marco": '+TotalCPagar(qryAux, tmmarco)+', '+
       '   			"abril": '+TotalCPagar(qryAux, tmabril)+', '+
       '   			"maio": '+TotalCPagar(qryAux, tmmaio)+', '+
       '   			"junho": '+TotalCPagar(qryAux, tmjunho)+', '+
       '   			"julho": '+TotalCPagar(qryAux, tmjulho)+', '+
       '   			"agosto": '+TotalCPagar(qryAux, tmagosto)+', '+
       '   			"setembro": '+TotalCPagar(qryAux, tmsetembro)+', '+
       '   			"outubro": '+TotalCPagar(qryAux, tmoutubro)+', '+
       '   			"novembro": '+TotalCPagar(qryAux, tmnovembro)+', '+
       '   			"dezembro": '+TotalCPagar(qryAux, tmdezembro)+' '+
       '   		}, '+
       '   		"pendendentes": { '+
       '   			"janeiro": '+TotalCPagarPendentes(qryAux, tmjaneiro)+', '+
       '   			"feveiro": '+TotalCPagarPendentes(qryAux, tmfeveiro)+', '+
       '   			"marco": '+TotalCPagarPendentes(qryAux, tmmarco)+', '+
       '   			"abril": '+TotalCPagarPendentes(qryAux, tmabril)+', '+
       '   			"maio": '+TotalCPagarPendentes(qryAux, tmmaio)+', '+
       '   			"junho": '+TotalCPagarPendentes(qryAux, tmjunho)+', '+
       '   			"julho": '+TotalCPagarPendentes(qryAux, tmjulho)+', '+
       '   			"agosto": '+TotalCPagarPendentes(qryAux, tmagosto)+', '+
       '   			"setembro": '+TotalCPagarPendentes(qryAux, tmsetembro)+', '+
       '   			"outubro": '+TotalCPagarPendentes(qryAux, tmoutubro)+', '+
       '   			"novembro": '+TotalCPagarPendentes(qryAux, tmnovembro)+', '+
       '   			"dezembro": '+TotalCPagarPendentes(qryAux, tmdezembro)+' '+
       '   		}, '+
       '   		"vencidasAtual": '+TotalCPagarAtual(qryAux, 'VENCIDAS')+', '+
       '   		"pendentesAtual": '+TotalCPagarAtual(qryAux, 'PENDENTES')+', '+
       '   		"pagasAtual": '+TotalCPagarAtual(qryAux, 'PAGAS')+' '+
       '   	}, '+
       '   	"caixasAbertos": ['+
       (*
       '{ '+
       '   			"usuario": "'+CXAberto.usuario+'", '+
       '   			"horaAbertura": "'+CXAberto.horaAbertura+'", '+
       '   			"dataAbertura": "'+CXAberto.dataAbertura+'", '+
       '   			"saldoInicial": '+CXAberto.saldoInicial+', '+
       '   			"saldoAtual": '+CXAberto.saldoAtual+', '+
       '   			"Entradas": '+CXAberto.Entradas+', '+
       '   			"saidas": '+CXAberto.saidas+', '+
       '   			"dinheiro": '+CXAberto.dinheiro+', '+
       '   			"credito": '+CXAberto.credito+', '+
       '   			"debito": '+CXAberto.debito+', '+
       '   			"cheque": '+CXAberto.cheque+', '+
       '   			"convenio": '+CXAberto.convenio+', '+
       '   			"vRefeicao": '+CXAberto.vRefeicao+', '+
       '   			"vCombustivel": '+CXAberto.vCombustivel+' '+
       '   		} '+
       *)
       ListaCaixasAbertos +
       ' '+
       '   	], '+
       '   	"topProdutos": [{ '+
       '   			"produto": "'+TProdutos.produto01+'", '+
       '   			"quantidade": "'+TProdutos.quantidade01+'" '+
       '   		}, '+
       '   		{ '+
       '   			"produto": "'+TProdutos.produto02+'", '+
       '   			"quantidade": "'+TProdutos.quantidade02+'" '+
       '   		}, '+
       '       { '+
       '   			"produto": "'+TProdutos.produto03+'", '+
       '   			"quantidade": "'+TProdutos.quantidade03+'" '+
       '   		}, '+
       '       { '+
       '   			"produto": "'+TProdutos.produto04+'", '+
       '   			"quantidade": "'+TProdutos.quantidade04+'" '+
       '   		}, '+
       '       { '+
       '   			"produto": "'+TProdutos.produto05+'", '+
       '   			"quantidade": "'+TProdutos.quantidade05+'" '+
       '   		}, '+
       '       { '+
       '   			"produto": "'+TProdutos.produto06+'", '+
       '   			"quantidade": "'+TProdutos.quantidade06+'" '+
       '   		}, '+
       '       { '+
       '   			"produto": "'+TProdutos.produto07+'", '+
       '   			"quantidade": "'+TProdutos.quantidade07+'" '+
       '   		}, '+
       '       { '+
       '   			"produto": "'+TProdutos.produto08+'", '+
       '   			"quantidade": "'+TProdutos.quantidade08+'" '+
       '   		}, '+
       '       { '+
       '   			"produto": "'+TProdutos.produto09+'", '+
       '   			"quantidade": "'+TProdutos.quantidade09+'" '+
       '   		}, '+
       '       { '+
       '   			"produto": "'+TProdutos.produto10+'", '+
       '   			"quantidade": "'+TProdutos.quantidade10+'" '+
       '   		} '+
       '     '+
       '   	], '+
       '   	"lucrosPresumidos": { '+
       '   		"ganhos": { '+
       '   			"janeiro": '+LucrosPresumidosGanhos(qryAux, tmjaneiro)+', '+
       '   			"feveiro": '+LucrosPresumidosGanhos(qryAux, tmfeveiro)+', '+
       '   			"marco": '+LucrosPresumidosGanhos(qryAux, tmmarco)+', '+
       '   			"abril": '+LucrosPresumidosGanhos(qryAux, tmabril)+', '+
       '   			"maio": '+LucrosPresumidosGanhos(qryAux, tmmaio)+', '+
       '   			"junho": '+LucrosPresumidosGanhos(qryAux, tmjunho)+', '+
       '   			"julho": '+LucrosPresumidosGanhos(qryAux, tmjulho)+', '+
       '   			"agosto": '+LucrosPresumidosGanhos(qryAux, tmagosto)+', '+
       '   			"setembro": '+LucrosPresumidosGanhos(qryAux, tmsetembro)+', '+
       '   			"outubro": '+LucrosPresumidosGanhos(qryAux, tmoutubro)+', '+
       '   			"novembro": '+LucrosPresumidosGanhos(qryAux, tmnovembro)+', '+
       '   			"dezembro": '+LucrosPresumidosGanhos(qryAux, tmdezembro)+' '+
       '   		}, '+
       '   		"perdidos": { '+
       '   			"janeiro": 0, '+
       '   			"feveiro": 0, '+
       '   			"marco": 0, '+
       '   			"abril": 0, '+
       '   			"maio": 0, '+
       '   			"junho": 0, '+
       '   			"julho": 0, '+
       '   			"agosto": 0, '+
       '   			"setembro": 0, '+
       '   			"outubro": 0, '+
       '   			"novembro": 0, '+
       '   			"dezembro": 0 '+
       '   		}, '+
       '   		"relatorioVendas": { '+
       '   			"concluidas": { '+
       '   				"valorVendas": '+VConcluidas.valorVendas+', '+
       '   				"quantidadeVendas": '+VConcluidas.quantidadeVendas+', '+
       '   				"totalDescontos": '+VConcluidas.totalDescontos+', '+
       '   				"totalLucros": '+VConcluidas.totalLucros+', '+
       //'   				"TicketMedio": 0, '+
       '   				"TicketMedio": '+VConcluidas.TicketMedio+', '+
       // todo: Calcular tempo médio atendimento
       // Dividir o tempo total de atendimento pelo número de atendimentos
       '   				"TempoMedioAtendimento": "00:00:00", '+
       '   				"QuantidadeProdutosVendidos": '+VConcluidas.QuantidadeProdutosVendidos+' '+
       '   			}, '+
       '   			"canceladas": { '+
       '   				"valorVendas": '+VCanceladas.valorVendas+', '+
       '   				"LurosPerdidos": '+VCanceladas.LurosPerdidos+', '+
       '   				"QuantidadeProdutosPerdidos": '+VCanceladas.QuantidadeProdutosPerdidos+', '+
       '   				"QuantidadeVendasPerdidas": '+VCanceladas.QuantidadeVendasPerdidas+' '+
       '   			}, '+
       '			    "diario":{'+
       '				  "vendasDia": '+vRelDiario.VendasDiarias+','+
       '				  "lucroDia": '+vRelDiario.LucroDiario+''+
       '			  },'+
       '   			"vendasUsuarios": [{ '+
       '   					"usuario": "'+VUsuarios.usuario+'", '+
       '   					"totalVendas": "'+VUsuarios.totalVendas+'", '+
       '   					"comissoes": "'+VUsuarios.comissoes+'", '+
       '   					"quantidadeVendas": '+VUsuarios.quantidadeVendas+', '+
       '   					"quantidadeProdutos": '+VUsuarios.quantidadeProdutos+', '+
       '   					"tempoAtendimento": "00:00:00" '+
       '   				} '+
       ' '+
       '   			] '+
       '   		} '+
       '   	} '+
       '   } ';
    qryAux.Close;
  except
    on E: Exception do
    begin
      //Memo_log.Lines.Add('Erro ao gerar JSON - '+FormatDateTime('dd/mm/yyyy hh:mm:ss', Now));
      Memo_log.Lines.Add(DateToStr(now)+' - '+TimeToStr(now));
      Memo_log.Lines.Add('Erro ao gerar dados');
      Memo_log.Lines.Add(E.Message);
      Memo_log.Lines.Add('');
      GravaLog(E.Message);
    end;
  end;
end;

function TForm1.GetHandleOnTaskBar: THandle;
begin
  {$IFDEF COMPILER11_UP}
  if Application.MainFormOnTaskBar And Assigned(Application.MainForm) Then
    Result := Application.MainForm.Handle
  else
  {$ENDIF COMPILER11_UP}
    Result := Application.Handle;
end;

procedure TForm1.GravaLog(AErro: String);
var
  NomeDoLog: String;
  Arquivo: TextFile;
begin
  ForceDirectories(ExtractFileDir(ParamStr(0)) +'\Log');
  NomeDoLog := ExtractFileDir(ParamStr(0)) +'\Log' + StringReplace(DateToStr(Date), '/', '', [rfReplaceAll]) + '.log';
  AssignFile(Arquivo, NomeDoLog);

  if FileExists(NomeDoLog) then
    Append(Arquivo)
  else
    ReWrite(Arquivo);
  try
    Writeln(Arquivo, DateTimeToStr(Now) + ' - ' +  AErro);
  finally
    CloseFile(Arquivo);
  end;
end;

procedure TForm1.HideApplication;
begin
  TrayIcon1.Visible := True;
  Application.ShowMainForm := False;
  If Self <> Nil Then
    Self.Visible := False;
  Application.Minimize;
  ShowWindow(GetHandleOnTaskBar, SW_HIDE);
  ChangeStatusWindow;
end;

procedure TForm1.InciarComWindows(Iniciar: Boolean);
var
  Reg: TRegistry;
  S: string;
  Win10: Boolean;
  MyObject : IUnknown;
  MySLink : IShellLink;
  MyPFile : IPersistFile;
  Directory : String;
  WFileName : WideString;
  FileName,
  Parameters,
  InitialDir: string;
begin
  try
    if Copy(ObterVersaoSO, 1, 10) = 'Windows 10' then
      Win10 := true
    else
      Win10 := false;
    if Win10 then
    begin
      Directory :=  'C:\Users\'+UsuarioLogado+'\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\';
        //'%AppData%\Microsoft\Windows\Start Menu\Programs\Startup\';
      WFileName := Directory + '' + 'SincPDVKawWhite' + '.lnk';
      if not Iniciar then
      begin
        if FileExists(WFileName) then
          DeleteFile(WFileName);
      end
      else if Iniciar then
      begin
        if not FileExists(WFileName) then
        begin
          FileName := ExtractFilePath(Application.ExeName) + ExtractFileName(Application.exename);
          Parameters:= '';
          InitialDir:= ExtractFilePath(Application.ExeName);

          MyObject := CreateComObject(CLSID_ShellLink);
          MySLink := MyObject as IShellLink;
          MyPFile := MyObject as IPersistFile;
          with MySLink do
            begin
              SetArguments(PChar(Parameters));
              SetPath(PChar(FileName));
              SetWorkingDirectory(PChar(InitialDir));
            end;
          MyPFile.Save(PWChar(WFileName), False);
        end;
      end;

      // 02-01-2024
      GravaLog('0-SincPDVKawWhite');
    end
    else
    begin
      try
        Reg := TRegistry.Create(KEY_WRITE or KEY_WOW64_64KEY or KEY_WOW64_32KEY); // 02-01-2024 - KEY_WOW64_32KEY

        if Reg<>nil then
          GravaLog('1-SincPDVKawWhite');

        S := ExtractFileDir(Application.ExeName)+'\'+ExtractFileName(ParamStr(0));//ExtractFileName(Application.ExeName);

        // 02-01-2024
        Reg.Rootkey := HKEY_LOCAL_MACHINE;
        //Reg.RootKey := HKEY_CURRENT_USER;

        if Reg.Openkey('Software\Microsoft\Windows\CurrentVersion\Run', true) then // 02-01-2024 - false
          GravaLog('2-SincPDVKawWhite');

        if Iniciar then
        begin
          Reg.WriteString('SincPDVKawWhite', S);
          GravaLog('3-SincPDVKawWhite');
        end
        else begin
          Reg.DeleteValue('SincPDVKawWhite');
          GravaLog('4-SincPDVKawWhite');
        end;
      finally
        Reg.closekey;
        Reg.Free;
        GravaLog('5-SincPDVKawWhite');
      end;
    end;
  except
    on E: Exception do
    begin
      GravaLog(E.Message);
    end;
  end;
end;

procedure TForm1.InsereAcerto;
begin
  Memo_log.Lines.Add(DateToStr(now)+' - '+TimeToStr(now));
  Memo_log.Lines.Add('Sincronização realizada com sucesso');
  Memo_log.Lines.Add('');
end;

function TForm1.insere_dados: boolean;
var
  dados: TStringList;
  retorno: String;
begin
  dados := TStringList.Create;
  try
    dados.Add('email='+DBEdit_email.Text); //pnEmail.Text
    dados.Add('json='+Memo1.Text);

    IdHTTP1.Request.Accept := 'text/html, image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, */*';
    IdHTTP1.Request.UserAgent := 'Mozilla/4.0';

    retorno := IdHTTP1.Post(trim(edt_api.text), dados);
    retorno := Trim(retorno);
    if retorno = '1' then
      Result := True
    else begin
      Result := False;
      sErro := IdHTTP1.ResponseText;
    end;
  except
    on E: Exception do
    begin
      Result := false;
      Memo_log.Lines.Add(DateToStr(now)+' - '+TimeToStr(now));
      //Memo_log.Lines.Add('Falha ao atualizar JSON - '+FormatDateTime('dd/mm/yyyy hh:mm:ss', Now));
      Memo_log.Lines.Add('Falha ao atualizar dados');
      Memo_log.Lines.Add(E.Message);
      Memo_log.Lines.Add('');
      //showmessage(E.message);
      GravaLog(E.Message);
    end;
  end;
end;

function TForm1.insere_empresa: boolean;
var
  dados:TStringList;
  retorno,erro:string;
begin
  dados := TStringList.Create;
  try
    dados.Add('CNPJ='+trim(DBEdit_cnpj.Text));
    dados.Add('razao_social='+trim(DBEdit_razao.Text));
    dados.Add('fantasia='+trim(DBEdit_fantasia.Text));
    dados.Add('proprietario='+trim(DBEdit_responsavel.Text));
    dados.Add('email='+trim(DBEdit_email.Text));
    dados.Add('pass='+'123456');
    //dados.Add('json='+Memo1.Text);

    IdHTTP1.Request.Accept := 'text/html, image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, */*';
    IdHTTP1.Request.UserAgent := 'Mozilla/4.0';

    retorno := IdHTTP1.Post(edt_api2.text, dados);
    retorno := trim(retorno);
    if retorno = '1' then
      Result := true
    else begin
      Result := false;
      sErro := IdHTTP1.Response.ResponseText;
    end;

    // 06-06-2024 - Verificar retorno de duplicidade de cadastro
    if retorno = '-1' then
    begin
      erro := 'E-mail ou CNPJ já existente';
      Memo_log.Lines.Add(DateToStr(now)+' - '+TimeToStr(now));
      Memo_log.Lines.Add('Erro ao cadastrar a empresa');
      Memo_log.Lines.Add(erro);
      Memo_log.Lines.Add('');
      GravaLog(erro);
    end;
  except
    on E: Exception do
    begin
      Result := false;
      erro := E.Message;
      Memo_log.Lines.Add(DateToStr(now)+' - '+TimeToStr(now));
      //Memo_log.Lines.Add('Erro ao cadastrar a empresa - '+FormatDateTime('dd/mm/yyyy hh:mm:ss', Now));
      Memo_log.Lines.Add('Erro ao cadastrar a empresa');
      Memo_log.Lines.Add(erro);
      Memo_log.Lines.Add('');
      //showmessage(E.message);
      GravaLog(erro);
    end;
  end;
end;

procedure TForm1.Label3Click(Sender: TObject);
begin
  insere_dados;
end;

{VENDAS TOTAL}
procedure TForm1.mensagens(mensagem: string);
begin
  // 05-06-2024
  //if chk_notificacao.Checked then
  //  TrayIcon1.Visible := True;
  if chk_notificacao.Checked then
  begin
    TrayIcon1.BalloonHint := mensagem;
    TrayIcon1.ShowBalloonHint;
  end;
end;   

// VENDAS MESAS//
procedure TForm1.mesas;
begin
  //Nada
end; 

function TForm1.naoVazio(valor:string): string;
begin
  if valor = '' then
  begin
    Result := '0';
  end;

  if valor = '0' then
  begin
   Result := '0';
  end;

  if (valor <> '0') and (valor <> '') then
  begin
    Result :=  valor;
  end;
end;

function TForm1.ObterVersaoSO: String;
var
  vNome,
  vVersao,
  vCurrentBuild: String;
  Reg: TRegistry;
begin
  Reg := TRegistry.Create; // Criando um Registro na Memória
  Reg.Access := KEY_READ; // Colocando nosso Registro em modo Leitura
  Reg.RootKey := HKEY_LOCAL_MACHINE; // Definindo a Raiz

  //Abrindo a chave desejada
  Reg.OpenKey('\SOFTWARE\Microsoft\Windows NT\CurrentVersion\', true);

  // Obtendo os parâmetros desejados
  vNome := Reg.ReadString('ProductName');
  vVersao := Reg.ReadString('CurrentVersion');
  vCurrentBuild := Reg.ReadString('CurrentBuild');
  Result := vNome;
end;

procedure TForm1.RestaurarAplicao1Click(Sender: TObject);
begin
  ShowApplication;
end;

procedure TForm1.SairdaAplicao1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.salvaConfiguracoes(liga: string);
var
  arquivo: tinifile;
begin
  arquivo := tinifile.Create(ExtractFilePath(Application.ExeName) + 'app.ini');
  try
    arquivo.WriteString('config','ligado', liga);
    arquivo.WriteString('config','tempo', editMinutos.Text);
    //arquivo.WriteString('config','email', pnEmail.Text);
    arquivo.WriteString('config','api', edt_api.Text);
    arquivo.WriteString('config','api2', edt_api2.Text);
    arquivo.WriteBool('config','inciarwindows', chkIniciarWindows.Checked);
    arquivo.WriteBool('config','SincVendas', chkSincVendas.Checked);
    arquivo.WriteBool('config','SincNFe', chkSincFiscal.Checked);
    arquivo.WriteBool('config','notificacao', chk_notificacao.Checked);

    InciarComWindows(chkIniciarWindows.Checked);

    //ShowMessage('tudo certo, abra novamente para salvar a configurações!!');
    {MessageDlg('Reinicie a aplicação para efetivar as alterações!',TMsgDlgType.mtInformation,[mbok],0);
    Form1.Close;}
    MessageDlg('Dados gravados com sucesso!'+#13+#10+'Aguarde o Sicronizador Web ser reiniciado para efetivar as configurações', TMsgDlgType.mtInformation,[mbok],0);
    if Application.Tag <> 0 then
    begin
      ReleaseMutex(Application.Tag);
      CloseHandle(Application.Tag);
    end;

    Application.Terminate;
    WinExec('Sincronizador.exe', 0);
  finally
    arquivo.free;
  end;
end;

procedure TForm1.ShowApplication;
begin
  TrayIcon1.Visible := False;
  Application.ShowMainForm := True;
  if Self <> nil Then
  begin
    Self.Visible := True;
    Self.WindowState := WsNormal;
  end;
  ShowWindow(GetHandleOnTaskBar, SW_SHOW);
  ChangeStatusWindow;
end;

procedure TForm1.ShowBalloonTips(IconMessage: Integer; MessageValue: string);
begin
  case IconMessage of
    0: TrayIcon1.BalloonFlags := BfInfo;
    1: TrayIcon1.BalloonFlags := BfWarning;
    2: TrayIcon1.BalloonFlags := BfError;
  else
    TrayIcon1.BalloonFlags := BfInfo;
  end;

  TrayIcon1.BalloonTitle := 'PDV Kaw White';
  TrayIcon1.BalloonHint := MessageValue;
  TrayIcon1.ShowBalloonHint;
  Application.ProcessMessages;
end;

procedure TForm1.TimeGoTimer(Sender: TObject);
begin
  timeGo.Enabled := false;
  cxBtn_sync.Enabled := false;
  btnDesligar.Enabled := false;
  try
    vendasTotal;
    delivery;
    mesas;

    json := GerarJSON(strtodate(maskInicio.EditText), strtodate(maskFim.EditText));
    json := StringReplace(json, #9, '', [rfReplaceAll]); // 04-06-2024 - Remover caracter #9
    Memo1.Text := json;

    if insere_dados then
    begin
      InsereAcerto;
      mensagens('White PDV - Sincronizado');
    end
    else
    begin
      mensagens('Erro ao sincronizar');
    end;
  finally
    timeGo.Enabled := true;
    cxBtn_sync.Enabled := true;
    btnDesligar.Enabled := true;
  end;
end;

procedure TForm1.tmrIniciarTimer(Sender: TObject);
begin
  tmrIniciar.Enabled := False;
  bIniciado := True;
  // Iniciar
  ligado := 'S';
  btnDesligar.Visible := true;
  editMinutos.Enabled := false;
  ApplicationEvents1.OnMinimize(self);
  btnDesligar.Visible := True;
  editMinutos.Text := tempo;
  timeGo.Interval := (1000 * 60)* StrToInt(tempo);
  timeGo.Enabled := True;
end;

procedure TForm1.TrayIcon1DblClick(Sender: TObject);
begin
  TrayIcon1.Visible := False;
  Show;
  WindowState := wsNormal;
  Application.BringToFront;
end;

function TForm1.UsuarioLogado: string;
var
  nsize: Cardinal;
  UserName: string;
begin
  nsize := 25;
  SetLength(UserName,nsize);
  if GetUserName(PChar(UserName), nsize) then
  begin
    SetLength(UserName,nsize-1);
    Result := UserName;
  end;
end;

procedure TForm1.vendasTotal;
begin
  //Nada
end;

end.

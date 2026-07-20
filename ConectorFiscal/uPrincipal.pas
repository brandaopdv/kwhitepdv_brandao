unit uPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, System.IniFiles, System.DateUtils,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.ExtCtrls, Vcl.AppEvnts,
  Vcl.StdCtrls, Comobj, System.IOUtils, IdHashSHA, FileCtrl, ActiveX,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteDef, FireDAC.Stan.Intf,
  FireDAC.Phys, FireDAC.Phys.SQLite, uFileUploadXML, Log, Vcl.WinXCtrls,
  FireDAC.Stan.Param, Vcl.ComCtrls, Vcl.Buttons, System.ImageList,
  Vcl.ImgList,  Registry, ShlObj, ShellApi, Vcl.Imaging.pngimage, Vcl.Clipbrd,
  IdMessage, IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL,
  IdSSLOpenSSL, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdExplicitTLSClientServerBase, IdMessageClient, IdSMTPBase, IdSMTP,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client,
  FireDAC.Comp.UI, FireDAC.Phys.IBBase, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet, Vcl.Mask;

const
  sKey = 'J@5vK_1yK$Z6+9'; // Se alterar esta chave, deve alterar no Admin PHP/Laravel
  sExisteEmpresa = 'Não existe empresa cadastrada!';
  sCnpjEmpresa = 'Empresa requer CNPJ cadastrado!';

type
  TForm1 = class(TForm)
    TrayIcon1: TTrayIcon;
    PopupMenu1: TPopupMenu;
    Sair1: TMenuItem;
    ApplicationEvents1: TApplicationEvents;
    btn_nfe_xml: TButton;
    btn_nfce_xml: TButton;
    btn_cte_xml: TButton;
    btn_mdfe_xml: TButton;
    btn_nfe_cancel: TButton;
    btn_nfce_cancel: TButton;
    btn_cte_cancel: TButton;
    btn_cte_carta: TButton;
    btn_nfe_inutili: TButton;
    btn_cte_inutili: TButton;
    Timer1: TTimer;
    btn_nfce_inutili: TButton;
    btn_cte_eventos: TButton;
    btn_nfe_entrada: TButton;
    GroupBox1: TGroupBox;
    Memo1: TMemo;
    PageControl1: TPageControl;
    tabNFe: TTabSheet;
    Label1: TLabel;
    SpeedButton4: TSpeedButton;
    Label5: TLabel;
    SpeedButton5: TSpeedButton;
    Label9: TLabel;
    SpeedButton6: TSpeedButton;
    Label13: TLabel;
    SpeedButton7: TSpeedButton;
    nfenfce_upload_xml_1: TEdit;
    events_upload_nfenfce_xml_1: TEdit;
    inutilization_upload_nfenfce_xml_1: TEdit;
    nfe_upload_xml_1: TEdit;
    tabNFCe: TTabSheet;
    Label2: TLabel;
    Label6: TLabel;
    Label11: TLabel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    nfenfce_upload_xml_2: TEdit;
    events_upload_nfenfce_xml_2: TEdit;
    inutilization_upload_nfenfce_xml_2: TEdit;
    TabSheet3: TTabSheet;
    Label3: TLabel;
    SpeedButton8: TSpeedButton;
    Label7: TLabel;
    SpeedButton9: TSpeedButton;
    Label10: TLabel;
    SpeedButton10: TSpeedButton;
    Label8: TLabel;
    SpeedButton11: TSpeedButton;
    Label12: TLabel;
    SpeedButton12: TSpeedButton;
    cte_upload_xml: TEdit;
    events_upload_cte_xml_1: TEdit;
    inutilization_upload_cte_xml: TEdit;
    events_upload_cte_xml_2: TEdit;
    events_upload_cte_xml_3: TEdit;
    TabSheet4: TTabSheet;
    Label4: TLabel;
    SpeedButton13: TSpeedButton;
    mdfe_upload_xml: TEdit;
    tabConfig: TTabSheet;
    chkIniciarWindows: TCheckBox;
    chk_notificacao: TCheckBox;
    cxBtn_sync: TButton;
    GroupBox3: TGroupBox;
    Label15: TLabel;
    Label16: TLabel;
    editMinutos: TEdit;
    btn_ligar: TButton;
    btnDesligar: TButton;
    ImageList1: TImageList;
    Restaurar1: TMenuItem;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    tmrIniciar: TTimer;
    PopupMenu2: TPopupMenu;
    Copiar1: TMenuItem;
    tabCFe: TTabSheet;
    Label130: TLabel;
    Label124: TLabel;
    cfe_upload_xml_2: TEdit;
    btn_cfe_xml: TSpeedButton;
    events_upload_cfe_xml_2: TEdit;
    btn_cfe_cancel: TSpeedButton;
    Conexao: TFDConnection;
    Transacao: TFDTransaction;
    FBDriver: TFDPhysFBDriverLink;
    WaitCursor: TFDGUIxWaitCursor;
    qryAux: TFDQuery;
    GroupBox2: TGroupBox;
    LblPeriodo: TLabel;
    maskInicio: TMaskEdit;
    maskFim: TMaskEdit;
    procedure TrayIcon1Click(Sender: TObject);
    procedure Sair1Click(Sender: TObject);
    procedure ApplicationEvents1Minimize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btn_nfe_xmlClick(Sender: TObject);
    procedure btn_nfce_xmlClick(Sender: TObject);
    procedure btn_cte_xmlClick(Sender: TObject);
    procedure btn_mdfe_xmlClick(Sender: TObject);
    procedure btn_nfe_cancelClick(Sender: TObject);
    procedure btn_nfce_cancelClick(Sender: TObject);
    procedure btn_cte_cancelClick(Sender: TObject);
    procedure btn_cte_cartaClick(Sender: TObject);
    procedure btn_nfe_inutiliClick(Sender: TObject);
    procedure btn_cte_inutiliClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btn_nfce_inutiliClick(Sender: TObject);
    procedure btn_cte_eventosClick(Sender: TObject);
    procedure btn_nfe_entradaClick(Sender: TObject);
    procedure btnDesligarClick(Sender: TObject);
    procedure cxBtn_syncClick(Sender: TObject);
    procedure TrayIcon1DblClick(Sender: TObject);
    procedure btn_ligarClick(Sender: TObject);
    procedure Restaurar1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure tmrIniciarTimer(Sender: TObject);
    procedure Copiar1Click(Sender: TObject);
    procedure btn_cfe_xmlClick(Sender: TObject);
    procedure btn_cfe_cancelClick(Sender: TObject);
  private
    { Private declarations }
    bIniciado: Boolean;
    FormatoBR: TFormatSettings;

    function GetPath(): String;
    procedure carregaConfiguracao;
    procedure salvaConfiguracoes(liga: String);
    procedure mensagens(mensagem: String);
    function GetHandleOnTaskBar: THandle;
    procedure ChangeStatusWindow;
    procedure OnTerminate(Sender: TObject);
    procedure DoHandlerException(Sender: TObject; E: Exception);
    procedure InciarComWindows(Iniciar: Boolean);
    function ObterVersaoSO: String;
    function UsuarioLogado: String;
    procedure GravaLog(AErro: String);
  public
    { Public declarations }
    FecharPrograma: Boolean;
    Cnpj: string;

    procedure ShowBalloonTips(IconMessage: Integer = 0; MessageValue: string = '');
    procedure HideToTrayIcon;
    procedure ShowFromTrayIcon;
    function VerificaEmpresa: Boolean;
    procedure execute;
  end;

type
  TTagsRoute = (
    tpNfeNfceUploadXml_1 = 0,
    tpNfeNfceUploadXml_2 = 0,
    tpCfeUploadXml_1 = 4,
    //tpCteUploadXml = 1,
    //tpMdfeUploadXml = 2,
    tpEventsUploadNfeNfceXml_1 = 1,
    tpEventsUploadNfeNfceXml_2 = 1,
    //tpEventsUploadCteXml_1 = 4,
    //tpEventsUploadCteXml_2 = 4,
    tpInutilizationUploadNfeNfceXml = 2,
    //tpInutilizationUploadCteXml = 6,
    tpNfeUploadXml_1 = 7);

type
  TProcessa = class(TThread)
  protected
    procedure execute; override;
  private
    procedure ProcessaPasta(xPasta: string; xTag: TTagsRoute);
    procedure ListFilesFolder(xFolder: string; xTag: TTagsRoute);
    function FileSha1(xFilename: TFileName): string;
    function CheckHashSend(Qry: TFDQuery; xHash: string; xTag: TTagsRoute): Boolean;
    procedure MarkSendFile(Qry: TFDQuery; xHash: string; xTag: TTagsRoute; xArquivo: string);
  public
    constructor Create;
    destructor Destroy; override;
  end;

var
  Form1: TForm1;
  Url: String;
  tempo,
  ligado: String;
  FRuning: Boolean = false;
  //AutoStart, HabilitaTimer: Boolean;
  ArrayTagsRoute: array [0..4] of string = (
    'api/docs/nfenfce/upload',
    //'api/docs/cte/upload',
    //'api/docs/mdfe/upload',
    'api/docs/eventos/nfenfce/upload',
    //'api/docs/eventos/cte/upload',
    'api/docs/inutilizacao/nfenfce/upload',
    //'api/docs/inutilizacao/cte/upload',
    'api/docs/nfe/upload',
    'api/docs/sat/upload'
    //'api/docs/eventos/cfe/upload' //todo: Criar rota
  );

var
  Processa: TProcessa;

const
  SELDIRHELP = 1000;

implementation

//ShellExecute(Application.HANDLE, 'open', PChar(ExtractFilePath(Application.ExeName)+'\LOG\'),nil,nil,SW_SHOWNORMAL);

{$R *.dfm}

uses Connection;

function IsValidXMLFile(const XmlFile: TFileName; Error: String): Boolean;
var
  XmlDoc: OleVariant;
begin
  XmlDoc := CreateOleObject('Msxml2.DOMDocument.6.0');
  try
    XmlDoc.Async := false;
    XmlDoc.validateOnParse := true;
    Result := (XmlDoc.Load(XmlFile)) and (XmlDoc.parseError.errorCode = 0);

    {if not Result then
      raise Exception.CreateFmt('Error Xml Data %s', [XmlDoc.parseError]);}
    if not Result then
      Error := XmlDoc.parseError;
  finally
    XmlDoc := Unassigned;
  end;
end;

procedure TForm1.ApplicationEvents1Minimize(Sender: TObject);
begin
  {Self.Hide;
  Self.WindowState := wsMinimized;

  TrayIcon1.Visible := True;
  TrayIcon1.Animate := True;}

  if ligado = 'S' then
  begin
    begin
      TrayIcon1.Visible := true;
      Self.Hide;
      Self.WindowState := wsMinimized;
      mensagens('Conector Fiscal - White PDV');
    end;
  end else
  begin
    Application.Terminate;
  end;
end;

procedure TProcessa.ListFilesFolder(xFolder: string; xTag: TTagsRoute);
var
  sr: TSearchRec;
  searchResult: Integer;
  hash, MsgError: String;
  arquivo: TFileName;
begin
  searchResult := FindFirst(xFolder + '/*.*', faAnyFile, sr);
  while searchResult = 0 do
  begin
    if sr.Name[1] <> '.' then
    begin
      if not(sr.attr and FILE_ATTRIBUTE_DIRECTORY > 0) then
      begin
        if TPath.GetExtension(sr.Name) = '.xml' then
        begin
          arquivo := xFolder + '/' + sr.Name;

           // 26-02-2025 - Não processar arquivos -NFeDFe.xml
          if Pos('-NFeDFe', arquivo) > 0 then
          begin
            searchResult := FindNext(sr);
            Continue;
          end;

          if IsValidXMLFile(arquivo, MsgError) then
          begin
            hash := FileSha1(arquivo);
            if not CheckHashSend(Form1.qryAux, hash, xTag) then
            begin
              if UploadXML(Url + ArrayTagsRoute[Integer(xTag)], sKey, arquivo, MsgError) then
              begin
                MarkSendFile(Form1.qryAux, hash, xTag, arquivo);
                TLog.GetInstance.INFO('TForm1.ListFilesFolder', 'ARQUIVO: ' + arquivo + ' ENVIADO');

                form1.Memo1.Lines.Add(DateToStr(now)+' - '+TimeToStr(now) + ' - ARQUIVO: ' + arquivo + ' ENVIADO');
                form1.Memo1.Lines.Add('');
              end
              else begin
                TLog.GetInstance.ERRO('TForm1.ListFilesFolder', 'ARQUIVO: ' + arquivo + ' ERRO: ' + MsgError);

                form1.Memo1.Lines.Add(DateToStr(now)+' - '+TimeToStr(now) + ' - ARQUIVO: ' + arquivo + ' ERRO: ' + MsgError);
                form1.Memo1.Lines.Add('');
              end;
            end;
          end
          else
          begin
            TLog.GetInstance.ERRO('TForm1.ListFilesFolder', 'ARQUIVO: ' + arquivo + ' XML INVÁLIDO: ' + MsgError);

            form1.Memo1.Lines.Add(DateToStr(now)+' - '+TimeToStr(now) + ' - ARQUIVO: ' + arquivo + ' XML INVÁLIDO: ' + MsgError);
            form1.Memo1.Lines.Add('');
          end;
        end;
      end
      else
      begin
        ListFilesFolder(xFolder + '/' + sr.Name, xTag)
      end;
    end;
    searchResult := FindNext(sr);
  end;
  FindClose(sr);
end;

procedure TProcessa.MarkSendFile(Qry: TFDQuery; xHash: string; xTag: TTagsRoute; xArquivo: string);
{var
  con: TConnection;}
begin
  //con := TConnection.Create(false);
  //try
    Qry.Close;
    Qry.SQL.Clear;
    Qry.SQL.Text := 'insert into XML_ARQUIVO (path, hash, arquivo) values (:path, :hash, :arquivo)';
    Qry.ParamByName('path').AsString := ArrayTagsRoute[Integer(xTag)];
    Qry.ParamByName('hash').AsString := xHash;
    Qry.ParamByName('arquivo').AsString := xArquivo;
    Qry.ExecSQL;
  //finally
  //  con.Disponse;
  //end;
end;

procedure TForm1.OnTerminate(Sender: TObject);
begin
  FRuning := false;
  //Form1.ActivityIndicator1.Animate := false;
  CoUninitialize;

  if ligado = 'S' then
    Timer1.Enabled := True;
  //else
  //  Timer1.Enabled := false; // 25-02-2025

  //cxBtn_sync.Enabled := true;
  //GroupBox3.Enabled := true;
  {btn_ligar.Enabled := true;
  btnDesligar.Enabled := false;}

  // 25-02-2025
  GroupBox3.Enabled := true;
  if not cxBtn_sync.Enabled then
    cxBtn_sync.Enabled := true;
  tabNFCe.Enabled := true;
  tabNFe.Enabled := true;
  tabCFe.Enabled := true;
end;

procedure TForm1.Restaurar1Click(Sender: TObject);
begin
  ShowFromTrayIcon;
end;

procedure TForm1.btn_nfe_inutiliClick(Sender: TObject);
begin
  inutilization_upload_nfenfce_xml_1.Text := getPath();
end;

procedure TForm1.btn_cte_inutiliClick(Sender: TObject);
begin
  //inutilization_upload_cte_xml.Text := getPath();
end;

procedure TForm1.btn_nfce_inutiliClick(Sender: TObject);
begin
  inutilization_upload_nfenfce_xml_2.Text := getPath();
end;

procedure TForm1.btn_cte_eventosClick(Sender: TObject);
begin
  //events_upload_cte_xml_3.Text := getPath();
end;

procedure TForm1.btn_nfe_entradaClick(Sender: TObject);
begin
  nfe_upload_xml_1.Text := getPath();
end;

{procedure TForm1.Button1Click(Sender: TObject);
begin
  execute;
end;}

// Apagar arquivos de LOG
(*procedure TForm1.Button2Click(Sender: TObject);
var
  SR: TSearchRec;
  I: integer;
begin
  I := FindFirst(ExtractFilePath(Application.ExeName)+'\LOG\*.*', faAnyFile, SR);
    while I = 0 do begin
      if (SR.Attr and faDirectory) <> faDirectory then
      if not DeleteFile(ExtractFilePath(Application.ExeName)+'\LOG\' + SR.Name) then
        ShowMessage('Não consegui excluir ...\Portal Contador\LOG\' + SR.Name);
        I := FindNext(SR);
    end;
    memo1.Clear;
end;*)

procedure TForm1.btn_nfe_xmlClick(Sender: TObject);
begin
  nfenfce_upload_xml_1.Text := getPath();
end;

procedure TForm1.btn_nfce_xmlClick(Sender: TObject);
begin
  nfenfce_upload_xml_2.Text := getPath();
end;

procedure TForm1.btn_cte_xmlClick(Sender: TObject);
begin
  //cte_upload_xml.Text := getPath();
end;

procedure TForm1.btn_ligarClick(Sender: TObject);
begin
  VerificaEmpresa;
  salvaConfiguracoes('S');
  btnDesligar.Visible := true;
  editMinutos.Enabled := false;
  chkIniciarWindows.Enabled := false;
  chk_notificacao.Enabled := false;
  cxBtn_sync.Enabled := false;
end;

procedure TForm1.btn_mdfe_xmlClick(Sender: TObject);
begin
  //mdfe_upload_xml.Text := getPath();
end;

procedure TForm1.btn_nfe_cancelClick(Sender: TObject);
begin
  events_upload_nfenfce_xml_1.Text := getPath();
end;

procedure TForm1.btn_nfce_cancelClick(Sender: TObject);
begin
  events_upload_nfenfce_xml_2.Text := getPath();
end;

procedure TForm1.btnDesligarClick(Sender: TObject);
begin
  if Application.MessageBox('Tem certeza que deseja desligar o sincronismo de arquivos XML?', 'Confirmação', MB_YESNO+MB_DEFBUTTON2+MB_ICONWARNING) = IDNO then
    exit;

  salvaConfiguracoes('N');
  btnDesligar.Visible := false;
  btn_ligar.Visible := true;
  editMinutos.Enabled := true;
  chkIniciarWindows.Enabled := true;
  chk_notificacao.Enabled := true;
  cxBtn_sync.Enabled := true;
  tabNFCe.Enabled := true;
  tabNFe.Enabled := true;
  tabCFe.Enabled := true;
end;

procedure TForm1.btn_cfe_cancelClick(Sender: TObject);
begin
  events_upload_cfe_xml_2.Text := getPath();
end;

procedure TForm1.btn_cfe_xmlClick(Sender: TObject);
begin
  cfe_upload_xml_2.Text := getPath();
end;

procedure TForm1.btn_cte_cancelClick(Sender: TObject);
begin
  //events_upload_cte_xml_1.Text := getPath();
end;

procedure TForm1.btn_cte_cartaClick(Sender: TObject);
begin
  //events_upload_cte_xml_2.Text := getPath();
end;

procedure TForm1.carregaConfiguracao;
var
  Ini: TIniFile;
  IniFile: String;
begin
  //IniFile := ChangeFileExt(Application.ExeName, '.ini');
  //Ini := TIniFile.Create(IniFile);
  Ini := tinifile.Create(ExtractFilePath(Application.ExeName) + 'fiscal.ini');
  try
    nfenfce_upload_xml_1.Text := Ini.ReadString('DATA', 'nfenfce_upload_xml_1', '');
    nfenfce_upload_xml_2.Text := Ini.ReadString('DATA', 'nfenfce_upload_xml_2', '');
    //cte_upload_xml.Text := Ini.ReadString('DATA', 'cte_upload_xml', '');
    //mdfe_upload_xml.Text := Ini.ReadString('DATA', 'mdfe_upload_xml', '');
    events_upload_nfenfce_xml_1.Text := Ini.ReadString('DATA', 'events_upload_nfenfce_xml_1', '');
    events_upload_nfenfce_xml_2.Text := Ini.ReadString('DATA', 'events_upload_nfenfce_xml_2', '');
    //events_upload_cte_xml_1.Text := Ini.ReadString('DATA', 'events_upload_cte_xml_1', '');
    //events_upload_cte_xml_2.Text := Ini.ReadString('DATA', 'events_upload_cte_xml_2', '');
    //events_upload_cte_xml_3.Text := Ini.ReadString('DATA', 'events_upload_cte_xml_3', '');
    inutilization_upload_nfenfce_xml_1.Text := Ini.ReadString('DATA', 'inutilization_upload_nfenfce_xml_1', '');
    inutilization_upload_nfenfce_xml_2.Text := Ini.ReadString('DATA', 'inutilization_upload_nfenfce_xml_2', '');
    //inutilization_upload_cte_xml.Text := Ini.ReadString('DATA', 'inutilization_upload_cte_xml', '');
    //nfe_upload_xml_1.Text := Ini.ReadString('DATA', 'nfe_upload_xml_1', '');
    cfe_upload_xml_2.Text := Ini.ReadString('DATA', 'cfe_upload_xml_2', '');
    events_upload_cfe_xml_2.Text := Ini.ReadString('DATA', 'events_upload_cfe_xml_2', '');

    Url := Ini.ReadString('WEBSERVICE', 'Url', '');
    //Edit1.text := Ini.ReadString('WEBSERVICE', 'Url', '');
    ligado := Ini.readString ('config','ligado','');
    tempo := Ini.readString ('config','tempo','');
    editMinutos.Text := tempo;
    chkIniciarWindows.Checked :=  Ini.ReadBool('config','inciarwindows',False);
    chk_notificacao.Checked := Ini.ReadBool('config', 'notificacao', False);
  finally
    Ini.Free;
  end;
end;

procedure TForm1.ChangeStatusWindow;
begin
  if Self.Visible Then
    Sair1.Caption := 'Minimizar'
  else
    Sair1.Caption := 'Sair';
  Application.ProcessMessages;
end;

procedure TForm1.Copiar1Click(Sender: TObject);
begin
  Clipboard.Clear;
  Clipboard.AsText := Memo1.Text;
  MessageDlg('LOG copiado com sucesso!', TMsgDlgType.mtInformation, [mbok],0);
end;

procedure TForm1.cxBtn_syncClick(Sender: TObject);
begin
  VerificaEmpresa;

  //Memo1.Clear;
  //Memo1.Lines.Add(DateToStr(now)+' - '+TimeToStr(now) + ' - Iniciando');
  //Memo1.Lines.Add('');
  GroupBox3.Enabled := false;
  cxBtn_sync.Enabled := false;
  tabNFCe.Enabled := false;
  tabNFe.Enabled := false;
  tabCFe.Enabled := false;
  //try
    execute;
  //finally
    //Timer1.Enabled := false;
    //cxBtn_sync.Enabled := true;
    //btnDesligar.Enabled := false;

    //if ligado = 'S' then
    //  TimeGo.Enabled := true;
  //end;
end;

procedure TForm1.DoHandlerException(Sender: TObject; E: Exception);
begin
  if Assigned(e) then
  begin
    TLog.GetInstance.ERRO('DoHandlerException', 'ERRO: ' + e.ToString);

    {form1.Memo1.Lines.Add('Error: ' + e.ToString);
    form1.Memo1.Lines.Add(DateToStr(now)+' - '+TimeToStr(now));}
    form1.Memo1.Lines.Add(DateToStr(now)+' - '+TimeToStr(now) + 'ERRO: ' + e.ToString);
    form1.Memo1.Lines.Add('');
  end;
end;

procedure TForm1.execute;
begin
  if not VerificaEmpresa then
    exit;

  if not FRuning then
  begin
    Processa := TProcessa.Create;
    Processa.OnTerminate := OnTerminate;
    Processa.FreeOnTerminate := True;
    Processa.Start;
  end
  else
  begin
    //ShowMessage('Já está executando.');
    MessageDlg('Conector Fiscal já está ativo!', TMsgDlgType.mtInformation, [mbOK],0);
  end;
end;

function TProcessa.CheckHashSend(Qry: TFDQuery; xHash: string; xTag: TTagsRoute): Boolean;
//var
  //con: TConnection;
begin
  //con := TConnection.Create(false);
  //try
    Qry.Close;
    Qry.SQL.Clear;
    Qry.SQL.Text := 'select 1 from XML_ARQUIVO where trim(path) = :path and trim(hash) = :hash';
    Qry.ParamByName('path').AsString := ArrayTagsRoute[Integer(xTag)];
    Qry.ParamByName('hash').AsString := xHash;
    Qry.Open;

    if Qry.RecordCount > 0 then
      Result := True
    else
      Result := false;
  //finally
  //  con.Disponse;
  //end;
end;

function TProcessa.FileSha1(xFilename: TFileName): string;
var
  pSHA: TIdHashSHA1;
  pStream: TFileStream;
begin
  pSHA := TIdHashSHA1.Create;
  pStream := TFileStream.Create(xFilename, fmOpenRead or fmShareDenyWrite);
  try
    Result := pSHA.HashStreamAsHex(pStream);
  finally
    pStream.Free;
    pSHA.Free;
  end;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  {CanClose := FecharPrograma;
  if not(CanClose) then
  begin
    HideToTrayIcon;
  end;}
  if not FecharPrograma then
  begin
    CanClose := false;

    if FRuning then
    begin
      FRuning := false;
      //aguarde a sincronização de dados
      Application.MessageBox('ATENÇÂO! Por favor, aguarde finalizar a sincronização de dados', 'Informação', MB_OK + MB_ICONWARNING);
      exit;
    end;

    if not CanClose then
    begin
      if Application.MessageBox('ATENÇÂO! Tem certeza que deseja fechar o Conector Fiscal?'+ #13+#10+#13+#10+
          'Não será possível sincronizar arquivos XML no terminal.', 'Confirmação', MB_YESNO+MB_DEFBUTTON2+MB_ICONWARNING) = IDYES then
        CanClose := True;
    end;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  Ini: TIniFile;
  IniFile: string;
begin
  bIniciado :=  False;
  Application.OnException := DoHandlerException;

  //tabNFe.TabVisible := False;
  PageControl1.ActivePage := tabConfig;

  FormatoBR := TFormatSettings.Create;
  FormatoBR.DecimalSeparator := ',';
  FormatoBR.ThousandSeparator := '.';
  FormatoBR.CurrencyDecimals := 2;
  FormatoBR.DateSeparator := '/';
  FormatoBR.TimeSeparator := ':';
  FormatoBR.ShortDateFormat := 'dd/mm/yyyy';
  FormatoBR.LongDateFormat := 'dd/mm/yyyy';
  FormatoBR.TimeAMString := 'AM';
  FormatoBR.TimePMString := 'PM';
  FormatoBR.ShortTimeFormat := 'hh:nn';
  FormatoBR.LongTimeFormat := 'hh:nn';
  System.SysUtils.FormatSettings := FormatoBR;

  TLog.GetInstance.INFO('TForm1.FormCreate', 'INICIANDO');

  Memo1.Clear;
  Memo1.Lines.Add(DateToStr(now)+' - '+TimeToStr(now) + ' - Iniciando');
  Memo1.Lines.Add('');

  //HideToTrayIcon;

  //IniFile := ChangeFileExt(Application.ExeName, '.ini');
  //Ini := TIniFile.Create(IniFile);
  (*Ini := tinifile.Create(ExtractFilePath(Application.ExeName) + 'fiscal.ini');
  try
    TConnection.DriverID := Ini.ReadString('BANCO', 'DRIVERID', '');
    TConnection.Server := Ini.ReadString('BANCO', 'SERVER', '');
    TConnection.Port := Ini.ReadString('BANCO', 'PORT', '');
    TConnection.Database := Ini.ReadString('BANCO', 'DATABASE', '');
    TConnection.User_Name := Ini.ReadString('BANCO', 'USER', '');
    TConnection.Password := Ini.ReadString('BANCO', 'PASSWORD', '');
  finally
    Ini.Free;
  end;*)

  // 16-02-2025 - Banco de dados Local
  Conexao.Connected := False;
  try
    Ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Banco.ini');
    Conexao.Params.Values['User_Name']  := Ini.ReadString('BD', 'USER', 'SYSDBA');
    Conexao.Params.Values['Password'] := Ini.ReadString('BD', 'PASS', 'masterkey');
    Conexao.Params.Values['Port'] := Ini.ReadString('BD', 'PORT', '3050');
    Conexao.Params.Values['DriverID'] := 'FB';
    Conexao.Params.Values['Server'] := Ini.ReadString('BD', 'IP', '');
    Conexao.Params.Values['Database'] := Ini.ReadString('BD', 'Path', '');
    FBDriver.VendorLib := ExtractFilePath(Application.ExeName) + 'fbclient.dll';

    try
      Conexao.Connected := True;
    except
      on E: Exception do
      begin
        TLog.GetInstance.ERRO('TForm1.FormCreate', 'ERRO: ' + e.ToString);

        {Memo1.Lines.Add('Erro ao conectar base de dados');
        Memo1.Lines.Add(E.Message);
        //GravaLog(E.Message);}
        form1.Memo1.Lines.Add(DateToStr(now)+' - '+TimeToStr(now) + 'ERRO: ' + e.ToString);
        form1.Memo1.Lines.Add('');
      end;
    end;
  finally
    Ini.Free;
  end;

  carregaConfiguracao();
  if ligado = 'S' then
  begin
    TrayIcon1.Visible := true;
    GroupBox2.Enabled := false;
    cxBtn_sync.Enabled := false;
    tabNFCe.Enabled := false;
    tabNFe.Enabled := false;
    tabCFe.Enabled := false;
    btnDesligar.Visible := true;
    editMinutos.Enabled := false;
    ApplicationEvents1.OnMinimize(self);
    btnDesligar.Visible := True;
    editMinutos.Text := tempo;
    Timer1.Interval := (1000 * 60)* StrToInt(tempo);
    execute();
  end
  else begin
    GroupBox2.Enabled := true;
    TrayIcon1.Visible := false;
    btn_ligar.Visible := true;
    btnDesligar.Visible := false;
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

function TForm1.GetPath: string;
var
  Dir: string;
  Folders: TStringList;
  SearchRec: TSearchRec;
begin
  Dir := ExtractFileDir(Application.ExeName);
  Folders := TStringList.Create;
  try
    if Win32MajorVersion >= 6 then
      with TFileOpenDialog.Create(nil) do
      try
        Title := 'Selecione pasta';
        Options := [fdoPickFolders, fdoPathMustExist, fdoForceFileSystem];
        OkButtonLabel := 'Selecione';
        DefaultFolder := Dir;
        FileName := Dir;
        if Execute then
          Result := FileName;
      finally
        Free;
      end
    else
    begin
      if SelectDirectory(Dir, [sdAllowCreate, sdPerformCreate, sdPrompt], SELDIRHELP) then
        Result := Dir;
    end;

    if DirectoryExists(Result) then
    begin
      if FindFirst(Result + '\*', faDirectory, SearchRec) = 0 then
      begin
        repeat
          if (SearchRec.Name <> '.') and (SearchRec.Name <> '..') then
            Folders.Add(Result + '\' + SearchRec.Name);
        until FindNext(SearchRec) <> 0;
        FindClose(SearchRec);
      end;
    end;
  finally
    Folders.Free;
  end;
end;

procedure TForm1.HideToTrayIcon;
begin
  Self.Hide();
  Self.WindowState := wsMinimized;
  TrayIcon1.Visible := True;
end;

procedure TForm1.Sair1Click(Sender: TObject);
begin
  //Application.Terminate;
  Close;
end;

procedure TForm1.salvaConfiguracoes(liga: String);
var
  Ini: TIniFile;
  IniFile: string;
begin
  //IniFile := ChangeFileExt(Application.ExeName, '.ini');
  //Ini := TIniFile.Create(IniFile);
  Ini := tinifile.Create(ExtractFilePath(Application.ExeName) + 'fiscal.ini');
  try
    Ini.WriteString('DATA', 'nfenfce_upload_xml_1', nfenfce_upload_xml_1.Text);
    Ini.WriteString('DATA', 'nfenfce_upload_xml_2', nfenfce_upload_xml_2.Text);
    //Ini.WriteString('DATA', 'cte_upload_xml', cte_upload_xml.Text);
    //Ini.WriteString('DATA', 'mdfe_upload_xml', mdfe_upload_xml.Text);
    Ini.WriteString('DATA', 'events_upload_nfenfce_xml_1', events_upload_nfenfce_xml_1.Text);
    Ini.WriteString('DATA', 'events_upload_nfenfce_xml_2', events_upload_nfenfce_xml_2.Text);
    //Ini.WriteString('DATA', 'events_upload_cte_xml_1', events_upload_cte_xml_1.Text);
    //Ini.WriteString('DATA', 'events_upload_cte_xml_2', events_upload_cte_xml_2.Text);
    Ini.WriteString('DATA', 'inutilization_upload_nfenfce_xml_1', inutilization_upload_nfenfce_xml_1.Text);
    Ini.WriteString('DATA', 'inutilization_upload_nfenfce_xml_2', inutilization_upload_nfenfce_xml_2.Text);
    //Ini.WriteString('DATA', 'inutilization_upload_cte_xml', inutilization_upload_cte_xml.Text);
    //Ini.WriteString('DATA', 'nfe_upload_xml_1', nfe_upload_xml_1.Text);
    Ini.WriteString('DATA', 'cfe_upload_xml_2', cfe_upload_xml_2.Text);
    Ini.WriteString('DATA', 'events_upload_cfe_xml_2', events_upload_cfe_xml_2.Text);

    //Ini.WriteString('WEBSERVICE', 'Url', edit1.Text);
    Ini.WriteString('config','ligado', liga);
    Ini.WriteString('config','tempo', editMinutos.Text);
    Ini.WriteBool('config','inciarwindows',chkIniciarWindows.Checked);
    Ini.WriteBool('config','notificacao', chk_notificacao.Checked);

    InciarComWindows(chkIniciarWindows.Checked);

    FecharPrograma := true;

    //todo: Implementar MUTEX e reiniciar automático
    {MessageDlg('Reinicie a aplicação para efetivar as alterações!',TMsgDlgType.mtInformation,[mbok],0);
    Form1.Close;}
    MessageDlg('Dados gravados com sucesso!'+#13+#10+#13+#10+'Aguarde o Conector Fiscal ser reiniciado para efetivar as configurações', TMsgDlgType.mtInformation,[mbok],0);
    if Application.Tag <> 0 then
    begin
      ReleaseMutex(Application.Tag);
      CloseHandle(Application.Tag);
    end;

    Application.Terminate;
    WinExec('ConectorFiscal.exe', 0);
  finally
    Ini.Free;
  end;
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

  TrayIcon1.BalloonTitle := 'Conector Fiscal - White PDV';
  TrayIcon1.BalloonHint := MessageValue;
  TrayIcon1.ShowBalloonHint;
  Application.ProcessMessages;
end;

procedure TForm1.ShowFromTrayIcon;
begin
  {TrayIcon1.Visible := false;
  Show;
  WindowState := wsNormal;
  Application.BringToFront;}

  TrayIcon1.Visible := False;
  Application.ShowMainForm := True;
  if Self <> nil Then
  begin
    Self.Visible := True;
    Self.WindowState := wsNormal;
  end;
  ShowWindow(GetHandleOnTaskBar, SW_SHOW);
  ChangeStatusWindow;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  if not FRuning then
  begin
    Processa := TProcessa.Create;
    Processa.OnTerminate := OnTerminate;
    Processa.FreeOnTerminate := True;
    Processa.Start;
  end;
end;

procedure TForm1.tmrIniciarTimer(Sender: TObject);
begin
  tmrIniciar.Enabled := False;
  bIniciado := True;
  // Iniciar
  ligado := 'S';
  cxBtn_sync.Enabled := false;
  btnDesligar.Visible := true;
  editMinutos.Enabled := false;
  editMinutos.Text := tempo;
  Timer1.Interval := (1000 * 60)* StrToInt(tempo);
  ApplicationEvents1.OnMinimize(self);
end;

procedure TForm1.TrayIcon1Click(Sender: TObject);
begin
  ShowFromTrayIcon;
end;

procedure TForm1.TrayIcon1DblClick(Sender: TObject);
begin
  TrayIcon1.Visible := False;
  Show;
  WindowState := wsNormal;
  Application.BringToFront;
end;

{ TProcessa }

constructor TProcessa.Create;
begin
  inherited Create(True);
end;

destructor TProcessa.Destroy;
begin
  inherited;
end;

procedure TProcessa.execute;
var
  Ini: TIniFile;
  IniFile: string;
begin
  inherited;

  CoInitialize(nil);
  FRuning := true;

  TThread.Synchronize(TThread.CurrentThread,
  procedure
  begin
    //Form1.ActivityIndicator1.Animate := True;
    form1.Timer1.Enabled := false;
    //form1.cxBtn_sync.Enabled := true;
    //form1.btnDesligar.Enabled := false;
  end);

  //IniFile := ChangeFileExt(Application.ExeName, '.ini');
  //Ini := TIniFile.Create(IniFile);
  Ini := tinifile.Create(ExtractFilePath(Application.ExeName) + 'fiscal.ini');
  try
    ProcessaPasta(Ini.ReadString('DATA', 'nfenfce_upload_xml_1', ''), tpNfeNfceUploadXml_1);
    ProcessaPasta(Ini.ReadString('DATA', 'nfenfce_upload_xml_2', ''), tpNfeNfceUploadXml_2);
    ProcessaPasta(Ini.ReadString('DATA', 'events_upload_nfenfce_xml_1', ''), tpEventsUploadNfeNfceXml_1);
    ProcessaPasta(Ini.ReadString('DATA', 'events_upload_nfenfce_xml_2', ''), tpEventsUploadNfeNfceXml_2);
    ProcessaPasta(Ini.ReadString('DATA', 'inutilization_upload_nfenfce_xml_1', ''), tpInutilizationUploadNfeNfceXml);
    ProcessaPasta(Ini.ReadString('DATA', 'inutilization_upload_nfenfce_xml_2', ''), tpInutilizationUploadNfeNfceXml);

    //ProcessaPasta(Ini.ReadString('DATA', 'cte_upload_xml', ''), tpCteUploadXml);
    //ProcessaPasta(Ini.ReadString('DATA', 'mdfe_upload_xml', ''), tpMdfeUploadXml);
    //ProcessaPasta(Ini.ReadString('DATA', 'events_upload_cte_xml_1', ''), tpEventsUploadCteXml_1);
    //ProcessaPasta(Ini.ReadString('DATA', 'events_upload_cte_xml_2', ''), tpEventsUploadCteXml_2);
    //ProcessaPasta(Ini.ReadString('DATA', 'events_upload_cte_xml_3', ''), tpEventsUploadCteXml_2);
    //ProcessaPasta(Ini.ReadString('DATA', 'inutilization_upload_cte_xml', ''), tpInutilizationUploadCteXml);
    //ProcessaPasta(Ini.ReadString('DATA', 'nfe_upload_xml_1', ''), tpNfeUploadXml_1); // NFe entrada (Fornecedores)

    //todo: CFe venda verificar o tipo de aplicativo
    //ProcessaPasta(Ini.ReadString('DATA', 'cfe_upload_xml_2', ''), tpCfeUploadXml_1);
    //todo: CFe cancelamento
    //ProcessaPasta(Ini.ReadString('DATA', 'events_upload_cfe_xml_1', ''), tpEventsUploadCfeXml_1);
  finally
    Ini.Free;
  end;
end;

procedure TProcessa.ProcessaPasta(xPasta: string; xTag: TTagsRoute);
begin
  try
    TLog.GetInstance.INFO('TProcessa.ProcessaPasta', 'PROCESSANDO:' + xPasta);

    if DirectoryExists(xPasta) then
    begin
      TLog.GetInstance.INFO('TProcessa.ProcessaPasta', 'PASTA: ' + xPasta);
      ListFilesFolder(xPasta, xTag);

      form1.Memo1.Lines.Add(DateToStr(now)+' - '+TimeToStr(now) + ' - Processando: ' + xPasta);
      form1.Memo1.Lines.Add('');
      form1.mensagens('Sincronizado');
      //Sleep(4000); // Teste
    end
    else
    begin
      TLog.GetInstance.ERRO('TProcessa.ProcessaPasta', 'PASTA: ' + xPasta + ' - NÃO EXISTE.');

      form1.Memo1.Lines.Add(DateToStr(now)+' - '+TimeToStr(now) + ' - Pasta inválida ou não configurada.');
      form1.Memo1.Lines.Add('');
    end;
  except
    on e: Exception do
    begin
      TLog.GetInstance.ERRO('TProcessa.ProcessaPasta', 'ERRO: ' + e.ToString);

      form1.Memo1.Lines.Add('Error: ' + e.ToString);
      form1.Memo1.Lines.Add(DateToStr(now)+' - '+TimeToStr(now));
      form1.Memo1.Lines.Add('');
      form1.mensagens('Conector Fiscal - Erro ao sincronizar');
    end;
  end;
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
      Win10 := False;
    if Win10 then
      begin
        Directory :=  'C:\Users\'+UsuarioLogado+'\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\';
          //'%AppData%\Microsoft\Windows\Start Menu\Programs\Startup\';
        WFileName := Directory + '' + 'SincWhiteFiscal' + '.lnk';
        if not Iniciar then
        begin
          if FileExists(WFileName) then
            DeleteFile(WFileName);
        end
        else if Iniciar then
        begin
          if not FileExists(WFileName) then
          begin
            FileName  :=  ExtractFilePath(Application.ExeName)+
                          ExtractFileName(Application.exename);
            Parameters:=  '';
            InitialDir:=  ExtractFilePath(Application.ExeName);

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

        // 12-03-2025
        if ParamStr(1) = '/debug' then
          GravaLog('0-SincWhiteFiscal');
      end
    else
    begin
      try
        //Reg := TRegistry.Create(KEY_WRITE OR KEY_WOW64_64KEY);
        Reg := TRegistry.Create(KEY_WRITE or KEY_WOW64_64KEY or KEY_WOW64_32KEY); // 02-01-2024 - KEY_WOW64_32KEY

        if Reg<>nil then
         if ParamStr(1) = '/debug' then
           GravaLog('1-SincPDVKawWhite');

        //S := ExtractFileDir(Application.ExeName)+'\'+
        //  ExtractFileName(Application.ExeName);
        S := ExtractFileDir(Application.ExeName)+'\'+ExtractFileName(ParamStr(0));//ExtractFileName(Application.ExeName);

        Reg.rootkey := HKEY_LOCAL_MACHINE;

        {Reg.Openkey('SOFTWARE\MICROSOFT\WINDOWS\CURRENTVERSION\RUN', false);
        if Iniciar then
          Reg.WriteString('WhiteFiscal', S)
        else
          Reg.DeleteValue('WhiteFiscal');}

         if Reg.Openkey('Software\Microsoft\Windows\CurrentVersion\Run', true) then // 02-01-2024 - false
           if ParamStr(1) = '/debug' then
             GravaLog('2-SincWhiteFiscal');

         if Iniciar then
          begin
            Reg.WriteString('SincWhiteFiscal', S);
            if ParamStr(1) = '/debug' then
              GravaLog('3-SincWhiteFiscal');
          end
          else begin
            Reg.DeleteValue('SincWhiteFiscal');
            if ParamStr(1) = '/debug' then
              GravaLog('4-SincWhiteFiscal');
          end;

      finally
        Reg.closekey;
        Reg.Free;
        if ParamStr(1) = '/debug' then
          GravaLog('5-SincWhiteFiscal');
      end;
    end;
  except
    on E: Exception do
    begin
      GravaLog(E.Message);
    end;
  end;
end;

procedure TForm1.mensagens(mensagem: String);
begin
  //if chk_notificacao.Checked then
  //  TrayIcon1.Visible := True;
  if chk_notificacao.Checked then
  begin
    TrayIcon1.BalloonHint := mensagem;
    TrayIcon1.ShowBalloonHint;
  end;
end;

function TForm1.ObterVersaoSO: String;
var
  vNome,
  vVersao,
  vCurrentBuild: String;
  Reg: TRegistry;
begin
  Reg := TRegistry.Create; //Criando um Registro na Memória
  Reg.Access := KEY_READ; //Colocando nosso Registro em modo Leitura
  Reg.RootKey := HKEY_LOCAL_MACHINE; //Definindo a Raiz

  //Abrindo a chave desejada
  Reg.OpenKey('\SOFTWARE\Microsoft\Windows NT\CurrentVersion\', true);

  //Obtendo os Parâmetros desejados
  vNome := Reg.ReadString('ProductName');
  vVersao := Reg.ReadString('CurrentVersion');
  vCurrentBuild := Reg.ReadString('CurrentBuild');

  Result  :=  vNome;
end;

function TForm1.UsuarioLogado: String;
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

function TForm1.VerificaEmpresa: Boolean;
begin
  // 29-03-2025 - Verificar se tem empresa cadastrada
  Result := false;
  try
    qryAux.Close;
    qryAux.SQL.Text := 'select cnpj from empresa'; //todo: Verificar qual empresa está ativa
    qryAux.Open;
    if not qryAux.IsEmpty then
    begin
      // Verifica se é pessoa juridica
      if Length(qryAux.FieldByName('cnpj').AsString)<>14 then
      begin
        form1.Memo1.Lines.Add(DateToStr(now)+' - '+TimeToStr(now) + ' - Error: ' + sCnpjEmpresa);
        GravaLog(sCnpjEmpresa);
        //raise Exception.Create(sCnpjEmpresa);
      end
      else begin
        Cnpj := qryAux.FieldByName('cnpj').AsString;
        Result := true;
      end;
    end
    else
    begin
      form1.Memo1.Lines.Add(DateToStr(now)+' - '+TimeToStr(now) + ' - Error: ' + sExisteEmpresa);
      GravaLog(sExisteEmpresa);
      //raise Exception.Create(sExisteEmpresa);
    end;
  except
    on E: Exception do
    begin
      form1.Memo1.Lines.Add(DateToStr(now)+' - '+TimeToStr(now) + ' - Error: ' + e.ToString);
      GravaLog(E.Message);
    end;
  end;
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

end.

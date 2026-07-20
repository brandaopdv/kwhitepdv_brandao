unit uDmNFe;

interface

uses
  System.SysUtils, vcl.Forms, System.Classes, ACBrNFeDANFeESCPOS,
  ACBrNFeDANFEClass, db,
  pcnConversao, pcnConversaoNFe, ACBrDFeSSL, System.Math, blcksock,
  ACBrDANFCeFortesFrA4, ACBrDANFCeFortesFr,
  ACBrPosPrinter, ACBrDFe, ACBrNFe, ACBrBase, acbrUtil,
  ACBrDFeReport, ACBrDFeDANFeReport, ACBrNFeDANFeRLClass, System.TypInfo,
  ACBrMail, vcl.Menus, ACBrIntegrador, Dialogs;

type
  TdmNFe = class(TDataModule)
    ACBrNFeDANFeRL1: TACBrNFeDANFeRL;
    ACBrNFe: TACBrNFe;
    ACBrPosPrinter1: TACBrPosPrinter;
    ACBrNFeDANFeESCPOS1: TACBrNFeDANFeESCPOS;
    ACBrNFeDANFCeFortesA41: TACBrNFeDANFCeFortesA4;
    ACBrMail1: TACBrMail;
    ACBrIntegrador1: TACBrIntegrador;
    PopupMenu1: TPopupMenu;
    ACBrNFeDANFCeFortes1: TACBrNFeDANFCeFortes;
    procedure ACBrNFeStatusChange(Sender: TObject);
    procedure ACBrMail1MailProcess(const AMail: TACBrMail;
      const aStatus: TMailStatus);
  private
    procedure AtualizaNFe(Chave, Protocolo, XML, XMLCancelmaneto, Situacao,
      Flag: String; Codigo: Integer);
    procedure AtualizaNFCe(Chave, Protocolo, XML, XMLCancelmaneto, Situacao,
      Flag: String; Codigo: Integer);
    { Private declarations }
  public
    { Public declarations }
    procedure ImpressoraA4NFe(Tipo: String);
    procedure ImpressoraBobina(Tipo: String);
    function StrToPaginaCodigo(const AValor: String): TACBrPosPaginaCodigo;
    procedure ConfiguraNFe(Tipo: String);
    procedure ImpressoraA4NFCe(Tipo: String);
    procedure VisualizarNFCe;
    function CancelaNFe(XML: string; Justificativa: String; Codigo: Integer;
      Tipo: String; Situacao: String): boolean;
    function CartaCorrecao(Chave: string; CNPJ: string; Sequencia: Integer;
      Texto: String; Tipo: String): boolean;
    function Inutilizar(Justificativa: String; CNPJ: String; Ano: String;
      Modelo: String; Serie: String; nInicial: Integer; nFinal: Integer;
      Tipo: String): boolean;
    procedure ImprimirNFe(XML: String; Situacao: String; Tipo: String;
      TRIBF, TRIBM, TRIBE: Extended);
    function RecuperaNFe(Codigo: Integer; XML: string;
      TRIB_FED, TRIB_EST, TRIB_MUN: Extended; Tipo: String): boolean;
    procedure EnviarEmal(email, Numero, XML, Cliente: string);
    function ConsultaIE(aDocumento, aUF: String): String;
  end;

var
  dmNFe: TdmNFe;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses Udados, ufrmStatus, uDMEstoque;

{$R *.dfm}

procedure TdmNFe.ACBrMail1MailProcess(const AMail: TACBrMail;
  const aStatus: TMailStatus);
begin
  Application.ProcessMessages;
end;

procedure TdmNFe.ACBrNFeStatusChange(Sender: TObject);
begin
  case ACBrNFe.Status of
    stIdle:
      begin
        if (frmStatus <> nil) then
          frmStatus.Hide;
      end;
    stNFeStatusServico:
      begin
        if (frmStatus = nil) then
          frmStatus := TfrmStatus.Create(Application);
        frmStatus.lblStatus.Caption := 'Verificando serviço...';
        frmStatus.Show;
        frmStatus.BringToFront;
      end;
    stNFeRecepcao:
      begin
        if (frmStatus = nil) then
          frmStatus := TfrmStatus.Create(Application);
        frmStatus.lblStatus.Caption := 'Enviando dados da NFe...';
        frmStatus.Show;
        frmStatus.BringToFront;
      end;
    stNfeRetRecepcao:
      begin
        if (frmStatus = nil) then
          frmStatus := TfrmStatus.Create(Application);
        frmStatus.lblStatus.Caption := 'Recebendo dados da NFe...';
        frmStatus.Show;
        frmStatus.BringToFront;
      end;
    stNfeConsulta:
      begin
        if (frmStatus = nil) then
          frmStatus := TfrmStatus.Create(Application);
        frmStatus.lblStatus.Caption := 'Consultando NFe...';
        frmStatus.Show;
        frmStatus.BringToFront;
      end;
    stNfeCancelamento:
      begin
        if (frmStatus = nil) then
          frmStatus := TfrmStatus.Create(Application);
        frmStatus.lblStatus.Caption := 'Enviando cancelamento da NFe...';
        frmStatus.Show;
        frmStatus.BringToFront;
      end;
    stNfeInutilizacao:
      begin
        if (frmStatus = nil) then
          frmStatus := TfrmStatus.Create(Application);
        frmStatus.lblStatus.Caption := 'Enviando pedido de inutilização...';
        frmStatus.Show;
        frmStatus.BringToFront;
      end;
    stNFeRecibo:
      begin
        if (frmStatus = nil) then
          frmStatus := TfrmStatus.Create(Application);
        frmStatus.lblStatus.Caption := 'Consultando Recibo de Lote...';
        frmStatus.Show;
        frmStatus.BringToFront;
      end;
    stNFeCadastro:
      begin
        if (frmStatus = nil) then
          frmStatus := TfrmStatus.Create(Application);
        frmStatus.lblStatus.Caption := 'Consultando Cadastro...';
        frmStatus.Show;
        frmStatus.BringToFront;
      end;
    stNFeEmail:
      begin
        if (frmStatus = nil) then
          frmStatus := TfrmStatus.Create(Application);
        frmStatus.lblStatus.Caption := 'Enviando E-mail...';
        frmStatus.Show;
        frmStatus.BringToFront;
      end;
    stNFeCCe:
      begin
        if (frmStatus = nil) then
          frmStatus := TfrmStatus.Create(Application);
        frmStatus.lblStatus.Caption := 'Enviando Carta de Correção...';
        frmStatus.Show;
        frmStatus.BringToFront;
      end;
    stNFeEvento:
      begin
        if (frmStatus = nil) then
          frmStatus := TfrmStatus.Create(Application);
        frmStatus.lblStatus.Caption := 'Enviando Evento...';
        frmStatus.Show;
        frmStatus.BringToFront;
      end;
  end;
  Application.ProcessMessages;
end;

procedure TdmNFe.AtualizaNFe(Chave, Protocolo, XML, XMLCancelmaneto, Situacao,
  Flag: String; Codigo: Integer);
begin
  dados.qryExecute.Close;
  dados.qryExecute.SQL.Text :=
    'UPDATE NFE_MASTER SET CHAVE=:CHAVE, PROTOCOLO=:PROTOCOLO, XML=:XML, SITUACAO=:SITUACAO, FLAG=:FLAG WHERE CODIGO=:CODIGO';
  dados.qryExecute.ParamByName('CHAVE').Value := Chave;
  dados.qryExecute.ParamByName('PROTOCOLO').Value := Protocolo;
  dados.qryExecute.ParamByName('XML').Value := XML;
  dados.qryExecute.ParamByName('SITUACAO').Value := Situacao;
  dados.qryExecute.ParamByName('FLAG').Value := Flag;
  dados.qryExecute.ParamByName('CODIGO').Value := Codigo;
  dados.qryExecute.Prepare;
  dados.qryExecute.ExecSQL;

  dados.Conexao.CommitRetaining;
end;

procedure TdmNFe.AtualizaNFCe(Chave, Protocolo, XML, XMLCancelmaneto, Situacao,
  Flag: String; Codigo: Integer);
begin
  dados.qryExecute.Close;
  dados.qryExecute.SQL.Text :=
    'UPDATE NFCE_MASTER SET CHAVE=:CHAVE, PROTOCOLO=:PROTOCOLO, XML=:XML, SITUACAO=:SITUACAO, FLAG=:FLAG WHERE CODIGO=:CODIGO';
  dados.qryExecute.ParamByName('CHAVE').Value := Chave;
  dados.qryExecute.ParamByName('PROTOCOLO').Value := Protocolo;
  dados.qryExecute.ParamByName('XML').Value := XML;
  dados.qryExecute.ParamByName('SITUACAO').Value := Situacao;
  dados.qryExecute.ParamByName('FLAG').Value := Flag;
  dados.qryExecute.ParamByName('CODIGO').Value := Codigo;
  dados.qryExecute.Prepare;
  dados.qryExecute.ExecSQL;

  dados.Conexao.CommitRetaining;
end;

function TdmNFe.RecuperaNFe(Codigo: Integer; XML: string;
  TRIB_FED, TRIB_EST, TRIB_MUN: Extended; Tipo: String): boolean;
begin
  Result := False;
  dmNFe.ConfiguraNFe(Tipo);
  dmNFe.ImpressoraA4NFe('NFE');

  ACBrNFe.NotasFiscais.Clear;
  ACBrNFe.NotasFiscais.LoadFromString(XML);
  ACBrNFe.Consultar;

  if ACBrNFe.WebServices.Consulta.cStat = 100 then
  begin
    if Tipo = 'NFe' then
    begin
      AtualizaNFe(copy(dmNFe.ACBrNFe.NotasFiscais.Items[0].NFe.infNFe.id, 4,
        100), dmNFe.ACBrNFe.NotasFiscais.Items[0].NFe.procNFe.nProt,
        dmNFe.ACBrNFe.NotasFiscais.Items[0].XMLAssinado, '', '2', 'N', Codigo);
      Result := true;
    end;

    if Tipo = 'NFCe' then
    begin
      AtualizaNFCe(copy(dmNFe.ACBrNFe.NotasFiscais.Items[0].NFe.infNFe.id, 4,
        100), dmNFe.ACBrNFe.NotasFiscais.Items[0].NFe.procNFe.nProt,
        dmNFe.ACBrNFe.NotasFiscais.Items[0].XMLAssinado, '', 'T', 'N', Codigo);
      Result := true;
    end;

    ACBrNFe.NotasFiscais.GravarXML();

    ACBrNFe.DANFE.vTribFed := TRIB_FED;
    ACBrNFe.DANFE.vTribEst := TRIB_EST;
    ACBrNFe.DANFE.vTribMun := TRIB_MUN;
    ACBrNFe.DANFE.PathPDF := dados.qryConfigPATHPDF.Value;

    ACBrNFe.NotasFiscais.ImprimirPDF;
  end
  else
  begin
    GravaLog('Erro -60: ' + #13 + 'Status: ' + #13 +
      IntToStr(ACBrNFe.WebServices.Consulta.cStat) + '-' +
      ACBrNFe.WebServices.Consulta.XMotivo);
    raise Exception.Create('Status: ' + #13 +
      IntToStr(ACBrNFe.WebServices.Consulta.cStat) + '-' +
      ACBrNFe.WebServices.Consulta.XMotivo);
  end;
end;

function TdmNFe.Inutilizar(Justificativa: String; CNPJ: String; Ano: String;
  Modelo: String; Serie: String; nInicial: Integer; nFinal: Integer;
  Tipo: String): boolean;
begin
  dmNFe.ConfiguraNFe(Tipo);
  Result := False;
  if length(trim(Justificativa)) < 15 then
    raise Exception.Create
      ('Justificativa de inutilização deve ter mais de 15 caracteres!');

  try
    ACBrNFe.WebServices.Inutiliza(CNPJ, Justificativa, StrToInt(Ano),
      StrToInt(Modelo), StrToInt(Serie), nInicial, nFinal);
  except
    on e: Exception do
    begin
      // 102 - Inutilização de número homologado
      // 206 - NF-e já está inutilizada na Base de dados da SEFAZ
      // 241 - Um número da faixa já foi utilizado
      // 563 - Já existe pedido de Inutilização com a mesma faixa de inutilização
      if (ACBrNFe.WebServices.Inutilizacao.cStat = 256) or
         (ACBrNFe.WebServices.Inutilizacao.cStat = 563) then
        Result := true
      else begin
        GravaLog('Erro -61: ' + ACBrNFe.WebServices.Inutilizacao.cStat.ToString +
          '|' + ACBrNFe.WebServices.Inutilizacao.XMotivo);
        raise Exception.Create(ACBrNFe.WebServices.Inutilizacao.cStat.ToString +
          '|' + ACBrNFe.WebServices.Inutilizacao.XMotivo);
      end;
    end;
  end;

  if ACBrNFe.WebServices.Inutilizacao.cStat = 102 then
    Result := true;
end;

function TdmNFe.CartaCorrecao(Chave: string; CNPJ: string; Sequencia: Integer;
  Texto: String; Tipo: String): boolean;
begin
  try
    dmNFe.ConfiguraNFe(Tipo);

    Result := False;
    ACBrNFe.EventoNFe.Evento.Clear;
    with ACBrNFe.EventoNFe.Evento.Add do
    begin
      infEvento.chNFe := Chave;
      infEvento.CNPJ := TiraPontos(CNPJ);
      if dados.qryEmpresaTIPO.Value = 'FÍSICA' then
        infEvento.CNPJ := '000' + TiraPontos(CNPJ);
      infEvento.dhEvento := now;
      infEvento.tpEvento := teCCe;
      infEvento.nSeqEvento := Sequencia;
      infEvento.detEvento.xCorrecao := Texto;
    end;
    if ACBrNFe.EnviarEvento(StrToInt('1')) then
    begin
      ACBrNFe.ImprimirEvento;
      Result := true;
    end
    else begin
      GravaLog('Erro -63: ' + ACBrNFe.WebServices.EnvEvento.XMotivo);
      raise Exception.Create(ACBrNFe.WebServices.EnvEvento.XMotivo);
    end;
  except
    on e: Exception do
    begin
      GravaLog('Erro -62: ' + E.Message + #13 + ACBrNFe.WebServices.EnvEvento.XMotivo);
      raise Exception.Create('Erro:' + sLineBreak +
        ACBrNFe.WebServices.EnvEvento.XMotivo);
    end;
  end;
end;

function TdmNFe.CancelaNFe(XML: string; Justificativa: String; Codigo: Integer;
  Tipo: String; Situacao: String): boolean;
begin
  try
    ConfiguraNFe(Tipo);

    Result := False;

    if length(Justificativa) < 15 then
      raise Exception.Create('Justificativa de cancelamento deve ter mais de 15 caracteres!');

    ACBrNFe.NotasFiscais.Clear;
    ACBrNFe.NotasFiscais.LoadFromString(XML);

    ACBrNFe.EventoNFe.Evento.Clear;
    ACBrNFe.EventoNFe.idLote := StrToInt('1');

    with ACBrNFe.EventoNFe.Evento.New do
    begin
      infEvento.dhEvento := now;
      infEvento.tpEvento := teCancelamento;
      infEvento.detEvento.xJust := Justificativa;
    end;

    ACBrNFe.EnviarEvento(StrToInt('1'));

    ACBrNFe.NotasFiscais.Clear;
    ACBrNFe.NotasFiscais.LoadFromString(XML);
    ACBrNFe.Consultar;

    // cStat = 100 (UF=PR)
    // Incluir cStat = 135 / 151 / 153
    if (ACBrNFe.WebServices.Consulta.cStat = 100) or
       (ACBrNFe.WebServices.Consulta.cStat = 101) or
       (ACBrNFe.WebServices.Consulta.cStat = 135) or
       (ACBrNFe.WebServices.Consulta.cStat = 151) or // Cancelamento de NF-e homologado fora de prazo
       (ACBrNFe.WebServices.Consulta.cStat = 155) then // Cancelamento homologado fora de prazo
    begin
      Result := true;

      if Tipo = 'NFe' then
      begin
        AtualizaNFe(copy(dmNFe.ACBrNFe.NotasFiscais.Items[0].NFe.infNFe.id, 4,
          100), dmNFe.ACBrNFe.NotasFiscais.Items[0].NFe.procNFe.nProt,
          dmNFe.ACBrNFe.NotasFiscais.Items[0].XMLAssinado,
          dmNFe.ACBrNFe.NotasFiscais.Items[0].XML, Situacao, 'N', Codigo);
      end;

      if Tipo = 'NFCe' then
      begin
        AtualizaNFCe(copy(dmNFe.ACBrNFe.NotasFiscais.Items[0].NFe.infNFe.id, 4,
          100), dmNFe.ACBrNFe.NotasFiscais.Items[0].NFe.procNFe.nProt,
          dmNFe.ACBrNFe.NotasFiscais.Items[0].XMLAssinado,
          dmNFe.ACBrNFe.NotasFiscais.Items[0].XML, Situacao, 'N', Codigo);
      end;
    end
    else begin
      GravaLog('Erro -64: ' + ACBrNFe.WebServices.EnvEvento.XMotivo);
      raise Exception.Create(ACBrNFe.WebServices.EnvEvento.XMotivo);
    end;
  except
    on e: Exception do
    begin
      GravaLog('Erro -65: ' + E.Message + sLineBreak+ ACBrNFe.WebServices.EnvEvento.XMotivo);
      raise Exception.Create('Erro:' + sLineBreak +
        ACBrNFe.WebServices.EnvEvento.XMotivo);
    end;
  end;
end;

procedure TdmNFe.ImpressoraA4NFe(Tipo: String);
begin
  ACBrNFe.DANFE := ACBrNFeDANFeRL1;
  ACBrNFe.DANFE.PathPDF := dados.qryConfigPATHPDF_NFE.Value;
  //ACBrNFeDANFeRL1.Sistema := dados.qryParametroEMPRESA.Value + ' | ' +
  //  dados.qryParametroFONE1.Value + ' ' + dados.qryParametroFONE2.Value;
  //ACBrNFeDANFeRL1.Site := dados.qryParametroSITE.Value;
  ACBrNFeDANFeRL1.Sistema := ' ';
  ACBrNFeDANFeRL1.Site := ' ';
  if FilesExists(dados.qryConfigLOGOMARCA.Value) then
    ACBrNFeDANFeRL1.Logo := dados.qryConfigLOGOMARCA.Value;
end;

procedure TdmNFe.ImpressoraA4NFCe(Tipo: String);
begin
  ACBrNFe.DANFE := ACBrNFeDANFCeFortesA41;
  ACBrNFe.DANFE.PathPDF := dados.qryConfigPATHPDF.Value;
  ACBrNFeDANFCeFortesA41.Sistema := ' ';
  ACBrNFeDANFCeFortesA41.Site := ' ';
  //ACBrNFeDANFCeFortesA41.Sistema := dados.qryParametroEMPRESA.Value + ' | ' +
  //  dados.qryParametroFONE1.Value + ' ' + dados.qryParametroFONE2.Value;
  //ACBrNFeDANFCeFortesA41.Site := dados.qryParametroSITE.Value;
  if FilesExists(dados.qryConfigLOGOMARCA.Value) then
    ACBrNFeDANFCeFortesA41.Logo := dados.qryConfigLOGOMARCA.Value;
end;

procedure TdmNFe.VisualizarNFCe;
begin
  // 01-04-2024
  ACBrNFe.DANFE := ACBrNFeDANFCeFortes1;
  ACBrNFe.DANFE.MostraPreview := true;
  ACBrNFe.DANFE.MostraStatus := false;
  ACBrNFe.DANFE.MostraSetup := false;
  ACBrNFe.DANFE.CasasDecimais.qCom := 3;
  ACBrNFe.DANFE.CasasDecimais.vUnCom := 2;

  ACBrNFeDANFCeFortes1.ImprimeTributos := trbNormal;
  ACBrNFeDANFCeFortes1.ImprimeDescAcrescItem := True;
  ACBrNFeDANFCeFortes1.ImprimeLogoLateral := (dados.cdsTerminalQRCODE_LATERAL.Value = 'S');
  ACBrNFeDANFCeFortes1.ImprimeQRCodeLateral := (dados.cdsTerminalQRCODE_LATERAL.Value = 'S');
  ACBrNFeDANFCeFortes1.ExpandeLogoMarca := false;
  ACBrNFeDANFCeFortes1.EspacoFinal := 0; //TESTE
  ACBrNFeDANFCeFortes1.LarguraBobina := dados.cdsTerminalLARGURA_BOBINA.Value;
  ACBrNFeDANFCeFortes1.MargemDireita := dados.cdsTerminalMARGEM_DIREITA.AsFloat;
  ACBrNFeDANFCeFortes1.MargemEsquerda := dados.cdsTerminalMARGEM_ESQUERDA.AsFloat;
  ACBrNFeDANFCeFortes1.MargemInferior := dados.cdsTerminalMARGEM_INFERIOR.AsFloat;
  ACBrNFeDANFCeFortes1.MargemSuperior := dados.cdsTerminalMARGEM_SUPERIOR.AsFloat;
  //ACBrNFeDANFCeFortes1.vTroco := ACBrNFe.NotasFiscais.Items[0].NFe.pag.vTroco;
  ACBrNFeDANFCeFortes1.Sistema := ' ';
  ACBrNFeDANFCeFortes1.Site := ' ';
  ACBrNFeDANFCeFortes1.Usuario := ' ';
  ACBrNFeDANFCeFortes1.Email := ' ';
  if FilesExists(dados.qryConfigLOGOMARCA.Value) then
    ACBrNFeDANFCeFortes1.Logo := dados.qryConfigLOGOMARCA.Value;
end;

function TdmNFe.StrToPaginaCodigo(const AValor: String): TACBrPosPaginaCodigo;
begin
  Result := TACBrPosPaginaCodigo
    (GetEnumValue(TypeInfo(TACBrPosPaginaCodigo), AValor));
end;

procedure TdmNFe.ImprimirNFe(XML: String; Situacao: String; Tipo: String;
  TRIBF, TRIBM, TRIBE: Extended);
var
  i: Integer;
  sError: String;
begin
  // 28-01-2025 - Verificar se existe dados no campo XMl
  if trim(XML)='' then
  begin
    sError := 'Erro XML não encontrado';
    GravaLog(sError);
    raise Exception.Create(sError);
  end;

  ACBrNFe.NotasFiscais.Clear;
  ACBrNFe.NotasFiscais.LoadFromString(XML);

  if Tipo = 'NFe' then
    ImpressoraA4NFe('NFe');

  if Tipo = 'NFCe' then
  begin
    dados.AbreTerminal;
    if dados.CdsTerminalTIPOIMPRESSORA.Value = '1' then
      dmNFe.ImpressoraA4NFCe('NFCe')
    else
      dmNFe.ImpressoraBobina('NFCe');

    dmNFe.ConfiguraNFe('NFCe');
  end;

  ACBrNFe.DANFE.Cancelada := False;

  if (Situacao = '3') or (Situacao = 'C') then
    ACBrNFe.DANFE.Cancelada := true;

  {ACBrNFe.DANFE.vTribFed := TRIBF;
  ACBrNFe.DANFE.vTribEst := TRIBE;
  ACBrNFe.DANFE.vTribMun := TRIBM;}
  ACBrNFe.DANFE.ImprimeTributos := trbNormal;
  ACBrNFe.DANFE.CasasDecimais.qCom := 3;
  ACBrNFe.DANFE.CasasDecimais.vUnCom := 2;
  ACBrNFe.DANFE.Email := ' ';
  ACBrNFe.DANFE.Usuario := ' ';
  ACBrNFe.DANFE.Sistema := ' ';
  ACBrNFe.DANFE.Site := ' ';

  if (dados.cdsTerminalTIPOIMPRESSORA.Value = '2') then
  begin
    if (trim(dados.qryConfigLOGOMARCA.Value)<>'') and (FilesExists(dados.qryConfigLOGOMARCA.Value)) then
      TACBrNFeDANFeESCPOS(dmnfe.ACBrNFe.DANFE).Logo := dados.qryConfigLOGOMARCA.Value;

    // SEFAZ/RJ - Lei 8.603 - Impressão do desconto/acréscimo por item
    // todo: Verificar quais UFs obrigam esta regra
    //if ACBrNFe.NotasFiscais.Items[0].NFe.Emit.EnderEmit.UF = 'RJ' then
      TACBrNFeDANFeESCPOS(dmnfe.ACBrNFe.DANFE).ImprimeDescAcrescItem := True;

    //TACBrNFeDANFeESCPOS(dmnfe.ACBrNFe.DANFE).ExpandeLogoMarca := True;
    TACBrNFeDANFeESCPOS(dmnfe.ACBrNFe.DANFE).ImprimeLogoLateral := (dados.cdsTerminalQRCODE_LATERAL.Value = 'S');
    TACBrNFeDANFeESCPOS(dmnfe.ACBrNFe.DANFE).ImprimeQRCodeLateral := (dados.cdsTerminalQRCODE_LATERAL.Value = 'S');
    TACBrNFeDANFeESCPOS(dmnfe.ACBrNFe.DANFE).vTroco := ACBrNFe.NotasFiscais.Items[0].NFe.pag.vTroco;
  end;

  if (ACBrNFe.NotasFiscais.Items[0].NFe.Emit.EnderEmit.UF = 'MS') and
     (ACBrNFe.NotasFiscais.Items[0].NFe.procNFe.cMsg=200) then
  begin
    ACBrNFe.NotasFiscais.Items[0].NFe.procNFe.xMsg := 'NOTA MS PREMIADA ' + ';' +
      dmnfe.ACBrNFe.NotasFiscais.Items[0].NFe.procNFe.xMsg + ';' +
      'https://www.notamspremiada.ms.gov.br';
  end;

  // todo: Se a NFCe estiver em contingência imprimir 2 vias
  if ACBrNFe.NotasFiscais[0].NFe.ide.tpEmis = TpcnTipoEmissao.teOffLine then
  begin
    i := 1;
    while i<=2 do
    begin
      if (dados.cdsTerminalTIPOIMPRESSORA.Value = '2') then
      begin
        if i = 1 then
          TACBrNFeDANFeESCPOS(dmnfe.ACBrNFe.DANFE).ViaConsumidor := True
        else
          TACBrNFeDANFeESCPOS(dmnfe.ACBrNFe.DANFE).ViaConsumidor := False;
      end;

      ACBrNFe.NotasFiscais.Imprimir;

      Application.ProcessMessages;
      //Sleep(300);
      Inc(i);
    end
  end
  else
    ACBrNFe.NotasFiscais.Imprimir;

  if (Situacao = '2') or (Situacao = 'T') then
  begin
    if dados.cdsTerminalTIPOIMPRESSORA.Value = '1' then
      ACBrNFe.NotasFiscais.ImprimirPDF;
  end;
end;

procedure TdmNFe.ConfiguraNFe(Tipo: String);
var
  Ok: Boolean;
begin
  dados.qryConfig.Close;
  dados.qryConfig.Params[0].Value := dados.qryEmpresaCODIGO.Value;
  dados.qryConfig.Open;

  dados.qryconsulta.Close;
  dados.qryconsulta.SQL.Text :=
    'select CONTINGENCIA,PORTA,MODELO,NVIAS,IMPRIME,USAGAVETA from VENDAS_TERMINAIS where NOME='
    + QuotedStr(dados.Getcomputer);
  dados.qryconsulta.Open;

  if (dados.qryConfig.IsEmpty) then
  begin
    GravaLog('Erro -66: Configure os parâmetros para emissão da NFCe!');
    raise Exception.Create('Configure os parâmetros para emissão da NFCe!');
    exit;
  end;

  with ACBrNFe.Configuracoes.Geral do // Configurações gerais
  begin
    CamposFatObrigatorios := false;
    ExibirErroSchema := true; //dados.qryConfigVISUALIZAERROSCHEMA

    // 07-10-2024 - Atualizar o XML com o protocolo de cancelamento
    // 17-02-2025 - Definido como "true"
    AtualizarXMLCancelado := true;

    // %TAGNIVEL%  : Representa o Nivel da TAG; ex: <transp><vol><lacres>
    // %TAG%       : Representa a TAG; ex: <nLacre>
    // %ID%        : Representa a ID da TAG; ex X34
    // %MSG%       : Representa a mensagem de alerta
    // %DESCRICAO% : Representa a Descrição da TAG
    // 30-03-2024
    if trim(dados.qryConfigFORMATOALERTA.AsString)='' then
      FormatoAlerta := dados.qryConfigFORMATOALERTA.Value
    else
      FormatoAlerta := 'TAG:%TAGNIVEL% ID:%ID%/%TAG%(%DESCRICAO%) - %MSG%.';

    FormaEmissao := TpcnTipoEmissao(teNormal);
    VersaoDF := TpcnVersaoDF(dados.qryConfigVERSAONFE.Value);
    ModeloDF := TpcnModeloDF(moNFe);

    if Tipo = 'NFCe' then
    begin
      ModeloDF := TpcnModeloDF(moNFCe);
      VersaoQRCode := TpcnVersaoQrCode(dados.qryConfigVERSAOQRCODE.Value);
      IdCSC := dados.qryConfigIDTOKEN.Value;
      CSC := dados.qryConfigTOKEN.Text;
    end;

    // 28-01-2024 - Configurar campos IdCSRT/CSRT
    if (not dados.qryConfigIDCSRT.IsNull) and (not dados.qryConfigCSRT.IsNull) then
    begin
      ACBrNFe.Configuracoes.RespTec.IdCSRT := dados.qryConfigIDCSRT.Value;
      ACBrNFe.Configuracoes.RespTec.CSRT := dados.qryConfigCSRT.Value;
    end;

    Salvar := False;
    SSLLib := TSSLLib(dados.qryConfigTIPO_EMISSAO.Value);
    SSLCryptLib := TSSLCryptLib(dados.qryConfigCRYPTLIB.AsInteger);
    SSLHttpLib := TSSLHttpLib(dados.qryConfigHTTPLIB.AsInteger);
    SSLXmlSignLib := TSSLXmlSignLib(dados.qryConfigXMLSIGN.AsInteger);
    ACBrNFe.SSL.SSLType := TSSLType(dados.qryconfigSSL_TIPO.AsInteger);
    Salvar := true;
  end;

  // Certificado
  if dados.qryConfigSENHACERTIFICADO.AsString <> '' then
    ACBrNFe.Configuracoes.Certificados.Senha :=
      dados.qryConfigSENHACERTIFICADO.Value;

  if trim(dados.qryConfigCAMINHO_CERTIFICADO.AsString) <> '' then
    ACBrNFe.Configuracoes.Certificados.ArquivoPFX :=
      dados.qryConfigCAMINHO_CERTIFICADO.Value
  else
  if trim(dados.qryConfigNUMEROSERIECERTFICADO.AsString) <> '' then
    ACBrNFe.Configuracoes.Certificados.NumeroSerie :=
      dados.qryConfigNUMEROSERIECERTFICADO.Value;

  // ACBrNFe.SSL.CarregarCertificado;

  with ACBrNFe.Configuracoes.WebServices do // Configura WebService
  begin
    UF := dados.qryConfigUF.AsString;
    Ambiente := StrToTpAmb(Ok, IntToStr(dados.qryConfigAMBIENTE.Value + 1));

    Visualizar := False;
    if dados.qryConfigVISUALIZAR.Value = 'S' then
      Visualizar := true;

    Salvar := False;
    //07-11-2024
    {if dados.qryConfigSALVARSOAP.Value = 'S' then
      Salvar := true;}
    if dados.qryConfigSALVARARQUIVO.Value = 'S' then
      Salvar := true;

    // Define se o tempo entre uma consulta e outra será ajustada automaticamente
    // 22-06-2025 - Alterado default para true
    AjustaAguardaConsultaRet := true; //old=false
    if dados.qryConfigAJUSTARAUTO.Value = 'S' then
      AjustaAguardaConsultaRet := true;

    // Tempo padrão que vai aguardar para consultar após enviar a NF-e
    // Define o tempo em milissegundos entre o envio e a consulta que com o retorno
    if NaoEstaVazio(dados.qryConfigAGUARDAR.AsString) then
      AguardarConsultaRet := ifThen(StrToInt(dados.qryConfigAGUARDAR.AsString) <
        1000, StrToInt(dados.qryConfigAGUARDAR.AsString) * 1000,
        StrToInt(dados.qryConfigAGUARDAR.AsString))
    else
      dados.qryConfigAGUARDAR.AsString := IntToStr(AguardarConsultaRet);

    // Define o número de tentativas de consulta
    if NaoEstaVazio(dados.qryConfigTENTATIVAS.AsString) then
      Tentativas := StrToInt(dados.qryConfigTENTATIVAS.AsString)
    else
      dados.qryConfigTENTATIVAS.AsString := IntToStr(Tentativas);

    // Define o tempo em milissegundos entre uma consulta e outra
    if NaoEstaVazio(dados.qryConfigINTERVALO.AsString) then
      IntervaloTentativas := ifThen(StrToInt(dados.qryConfigINTERVALO.AsString)
        < 1000, StrToInt(dados.qryConfigINTERVALO.AsString) * 1000,
        StrToInt(dados.qryConfigINTERVALO.AsString))
    else
      dados.qryConfigINTERVALO.AsString :=
        IntToStr(ACBrNFe.Configuracoes.WebServices.IntervaloTentativas);

    // Define o tempo em milissegundos de espera por uma resposta do webservice
    // 22-06-2025 - Criar campo para timeout do WebService
    TimeOut := 5000; //5seg

    ProxyHost := dados.qryConfigPROXY_HOST.Value;
    ProxyPort := dados.qryConfigPROXY_PORTA.Value;
    ProxyUser := dados.qryConfigPROXY_USUARIO.Value;
    ProxyPass := dados.qryConfigPROXY_SENHA.Value;
  end;

  if (dados.qryConfigTIPO_APLICATIVO.Value = 'M') and (dados.qryConfigUF.Value = 'CE') then
  begin
    ACBrIntegrador1.Timeout := 30;
    ACBrNFe.Integrador := ACBrIntegrador1;
  end
  else
    ACBrNFe.Integrador := nil;

  // Configura caminho dos arquivos
  with ACBrNFe.Configuracoes.Arquivos do
  begin
    // Salva o XML assinado, protocolado e com os eventos
    // 07-11-2024 - Comentado erro em um cliente
    //Salvar := false;
    // 17-02-2025 - Definido como "true" para criar arquivo de evento de cancelamento
    Salvar := true;

    // Define se na estrutura de pastas será criada uma com o literal NFe
    AdicionarLiteral := false;
    if dados.qryConfigLITERAL.Value = 'S' then
      AdicionarLiteral := true;

    EmissaoPathNFe := true;
    SalvarEvento := true; // Gera o arquivo do evento do cancelamento
    SepararPorMes := true; // Define se na estrutura de pastas os XML serão separados por Mês
    SepararPorCNPJ := true; // Define se na estrutura de pastas os XML serão separados por CNPJ
    SepararPorModelo := false; // Define se na estrutura de pastas os XML serão separados por Modelo

    if Tipo = 'NFe' then
    begin
      PathSalvar := dados.qryConfigPATHSALVARNFE.Value;
      PathSchemas := dados.qryConfigPATHSCHEMAS_NFE.Value;
      PathNFe := dados.qryConfigPATHENVIADA_NFE.Value;
      PathInu := dados.qryConfigPATHINUTI_NFE.Value;
      PathEvento := dados.qryConfigPATHEVENTO_NFE.Value;

      // todo: Ver se devem ser habilitadas
      // CamposFatObrigatorios
      // TagNT2018005
    end;

    if Tipo = 'NFCe' then
    begin
      PathSalvar := dados.qryConfigPATHSALVAR.Value;
      PathSchemas := dados.qryConfigPATHSCHEMAS.Value;
      PathNFe := dados.qryConfigPATHNFE.Value;
      PathInu := dados.qryConfigPATHINUTI.Value;
      PathEvento := dados.qryConfigPATHEVENTO.Value;
    end;
  end;
end;

function TdmNFe.ConsultaIE(aDocumento: String; aUF: String): String;
begin
  try
    Result := '';

    if trim(aDocumento) = '' then
      exit;
    if trim(aUF) = '' then
      exit;

    ConfiguraNFe('NFe');
    ACBrNFe.WebServices.ConsultaCadastro.Clear;
    ACBrNFe.WebServices.ConsultaCadastro.UF := aUF;

    if length(aDocumento) > 11 then
      ACBrNFe.WebServices.ConsultaCadastro.CNPJ := aDocumento
    else
      ACBrNFe.WebServices.ConsultaCadastro.CPF := aDocumento;

    if ACBrNFe.WebServices.ConsultaCadastro.Executar then
    begin
      if dados.qryPessoas.State in dsEditModes then
      begin
        if ACBrNFe.WebServices.ConsultaCadastro.RetConsCad.InfCad.Items[0]
          .xRegApur = 'NORMAL' then

          dados.qryPessoasREGIME_TRIBUTARIO.Value := 'NORMAL'
        else
          dados.qryPessoasREGIME_TRIBUTARIO.Value := 'SIMPLES';

        dados.qryPessoasIE.Value :=
          TiraPontos(ACBrNFe.WebServices.ConsultaCadastro.RetConsCad.InfCad.
          Items[0].IE);
      end;
    end;
    Result := ACBrNFe.WebServices.ConsultaCadastro.XMotivo;
  except
    // nada
  end;
end;

procedure TdmNFe.EnviarEmal(email, Numero, XML, Cliente: string);
var
  mensagem: Tstrings;
  para: string;
begin
  if trim(dados.qryEmpresaEMAIL.AsString) = '' then
    exit;

  try
    mensagem := TstringList.Create;
    mensagem.Add('Segue em anexo o arquivo XML e DANFe referente à NFCe nº ' + Numero);

    ACBrNFe.NotasFiscais.Clear;
    ACBrNFe.NotasFiscais.LoadFromString(XML);

    FEmail.GetEmail;

    ACBrMail1.FromName := Cliente;
    ACBrMail1.Host := FEmail.servidor;
    ACBrMail1.Port := FEmail.porta;
    ACBrMail1.AddAddress(LowerCase(FEmail.usuario), '');
    ACBrMail1.Username := LowerCase(FEmail.usuario);
    ACBrMail1.From := LowerCase(FEmail.usuario);
    ACBrMail1.Password := FEmail.Senha;
    ACBrMail1.DefaultCharset := TMailCharset(27);
    ACBrMail1.IDECharset := TMailCharset(15);
    ACBrMail1.IsHTML := False;

    ACBrMail1.SetSSL := False;
    ACBrMail1.SetTLS := False;

    if FEmail.SSL then
      ACBrMail1.SetSSL := true;

    if FEmail.TLS then
      ACBrMail1.SetTLS := true;

    ACBrMail1.ReadingConfirmation := true;
    ACBrMail1.UseThread := False;

    if (email = '') then
      para := LowerCase(dados.qryEmpresaEMAIL.Value)
    else
      para := LowerCase(email);

    ACBrNFe.NotasFiscais.Items[0].EnviarEmail(para, 'NFe-' + Cliente,
      mensagem, true
      // Enviar PDF junto
      , nil // Lista com emails que serÃ£o enviado cÃ³pias - TStrings
      , nil); // Lista de anexos - TStrings}

  finally
    mensagem.Free;
  end;
end;

procedure TdmNFe.ImpressoraBobina(Tipo: String);
begin
  ACBrPosPrinter1.Desativar;

  ACBrNFe.DANFE := ACBrNFeDANFeESCPOS1;
  ACBrNFe.DANFE.PathPDF := dados.qryConfigPATHPDF_NFE.Value;

  if dados.cdsTerminal.FieldByName('MODELO').Value = 'DARUMA' then
    ACBrPosPrinter1.Modelo := ppEscDaruma
  else if dados.cdsTerminal.FieldByName('MODELO').Value = 'BEMATECH' then
    ACBrPosPrinter1.Modelo := ppEscBematech
  else if dados.cdsTerminal.FieldByName('MODELO').Value = 'ELGIN' then
    ACBrPosPrinter1.Modelo := ppEscPosEpson
  else if dados.cdsTerminal.FieldByName('MODELO').Value = 'DIEBOLD' then
    ACBrPosPrinter1.Modelo := ppEscDiebold
  else if dados.cdsTerminal.FieldByName('MODELO').Value = 'EPSON' then
    ACBrPosPrinter1.Modelo := ppEscPosEpson
  else if dados.cdsTerminal.FieldByName('MODELO').Value = 'VOX' then
    ACBrPosPrinter1.Modelo := ppEscVox
  else if dados.cdsTerminal.FieldByName('MODELO').Value = 'POSSTAR' then
    ACBrPosPrinter1.Modelo := ppEscPosStar
  else if dados.cdsTerminal.FieldByName('MODELO').Value = 'JIANG' then
    ACBrPosPrinter1.Modelo := ppEscZJiang
  else if dados.cdsTerminal.FieldByName('MODELO').Value = 'GPRINTER' then
    ACBrPosPrinter1.Modelo := ppEscGPrinter
  else if dados.cdsTerminal.FieldByName('MODELO').Value = 'EPSONP2' then
    ACBrPosPrinter1.Modelo := ppEscEpsonP2
  else
    ACBrPosPrinter1.Modelo := ppTexto;
  ACBrPosPrinter1.porta := LowerCase(dados.cdsTerminal.FieldByName('PORTA').AsString);

  ACBrPosPrinter1.Device.Baud := dados.cdsTerminalVELOCIDADE.Value;
  ACBrPosPrinter1.PaginaDeCodigo := StrToPaginaCodigo(dados.cdsTerminalPAGINA_CODIGO.AsString);
  ACBrPosPrinter1.EspacoEntreLinhas := StrToIntDef(dados.cdsTerminalESPACO_ENTRE_LINHAS.Value,1);
  ACBrPosPrinter1.LinhasEntreCupons := StrtoIntDef(dados.cdsTerminalLINHAS_ENTRE_CUPOM.Value,1);

  ACBrNFeDANFeESCPOS1.LarguraBobina := dados.cdsTerminalLARGURA_BOBINA.Value;

  ACBrNFeDANFeESCPOS1.MargemDireita := dados.cdsTerminalMARGEM_DIREITA.AsFloat;
  ACBrNFeDANFeESCPOS1.MargemEsquerda := dados.cdsTerminalMARGEM_ESQUERDA.AsFloat;
  ACBrNFeDANFeESCPOS1.MargemInferior := dados.cdsTerminalMARGEM_INFERIOR.AsFloat;
  ACBrNFeDANFeESCPOS1.MargemSuperior := dados.cdsTerminalMARGEM_SUPERIOR.AsFloat;

  //ACBrNFeDANFeESCPOS1.Sistema := dados.qryParametroEMPRESA.Value + ' | ' +
  //  dados.qryParametroFONE1.Value + ' ' + dados.qryParametroFONE2.Value;

  //ACBrNFeDANFeESCPOS1.Site := dados.qryParametroSITE.Value;

  ACBrPosPrinter1.ImprimirLogo(dados.cdsTerminalL1.AsInteger, dados.cdsTerminalL2.AsInteger, dados.cdsTerminalL3.AsInteger,  dados.cdsTerminalL4.AsInteger);

  ACBrPosPrinter1.ConfigLogo.IgnorarLogo := true;
  ACBrPosPrinter1.ColunasFonteNormal :=  StrToIntDef(dados.cdsTerminalCOLUNAS.AsString, 42);
  ACBrPosPrinter1.ConfigLogo.KeyCode1 := StrToIntDef(dados.cdsTerminalL1.AsString, 32);
  ACBrPosPrinter1.ConfigLogo.KeyCode2 := StrToIntDef(dados.cdsTerminalL2.AsString, 32);
  ACBrPosPrinter1.ConfigLogo.FatorX := StrToIntDef(dados.cdsTerminalL3.AsString, 1);
  ACBrPosPrinter1.ConfigLogo.FatorY := StrToIntDef(dados.cdsTerminalL4.AsString, 1);
  ACBrNFeDANFeESCPOS1.ViaConsumidor := true;

  ACBrNFeDANFeESCPOS1.ImprimeQRCodeLateral := False;
  if (dados.cdsTerminalQRCODE_LATERAL.Value = 'S') then
    ACBrNFeDANFeESCPOS1.ImprimeQRCodeLateral := true;

  if FilesExists(dados.qryConfigLOGOMARCA.Value) then
    ACBrNFeDANFeESCPOS1.Logo := dados.qryConfigLOGOMARCA.Value;

  // 08-06-2024 - TESTE configura gaveta sinal invertido
  //dmnfe.aCBrPosPrinter1.ConfigGaveta.SinalInvertido := true;
  if dados.CdsTerminalGAVETA_SINAL_INVERTIDO.Value = 'S' then
    ACBrPosPrinter1.ConfigGaveta.SinalInvertido := true;
  //ACBrPosPrinter1.ConfigGaveta.TempoON
  //ACBrPosPrinter1.ConfigGaveta.TempoOFF

  ACBrPosPrinter1.Ativar;
end;

end.

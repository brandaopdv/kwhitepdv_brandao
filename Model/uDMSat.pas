unit uDMSat;

interface

uses
  System.SysUtils, System.Classes, ACBrSATExtratoReportClass,
  ACBrSATMFe_integrador, pcnLeitor, vcl.Dialogs, vcl.Forms,
  ACBrSATExtratoFortesFr, ACBrDFeReport, ACBrSATExtratoClass, pcnVFPe,
  ACBrSATExtratoESCPOS, ACBrSAT, ACBrBase, ACBrPosPrinter, ACBrSATClass,
  ACBrIntegrador, pcnConversao, pcnConversaoNFe, acbrutil, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TDMSat = class(TDataModule)
    ACBrPosPrinter1: TACBrPosPrinter;
    ACBrSAT1: TACBrSAT;
    ACBrSATExtratoESCPOS1: TACBrSATExtratoESCPOS;
    ACBrSATExtratoFortes1: TACBrSATExtratoFortes;
    ACBrIntegrador1: TACBrIntegrador;
    FDQuery1: TFDQuery;
    procedure ACBrSAT1GetcodigoDeAtivacao(var Chave: AnsiString);
    procedure ACBrSAT1GetsignAC(var Chave: AnsiString);
  private
    procedure DiretoriosDeArquivos;
    function PathLog: String;
    function PathApp: String;
    function GetGUID: String;

    { Private declarations }
  public
    { Public declarations }
    procedure ConfiguraSAT;
    procedure ConfiguraImpressoraSAT;
    function RecuperaUltimoCFe: Integer;
    procedure VisualizarCFe;

    procedure EnviarPagamentoPOS(aChaveAcessoValidador: String;
      aEstabelecimento: String; aSerialPOS: String; aCNPJ: String;
      aTotalIcms: Extended; aTotalVenda: Extended; aOrigem: string);

    procedure EnviarPagamentoTEF(aVenda: Integer);

    procedure EnviaPagamentoTeste(aEmitente: String; aICMSBase: Extended;
      aTotalVenda: Extended);

    function GetErroMFe(const AXML: String): String;

  end;

var
  DMSat: TDMSat;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses Udados, uDmNFe;
{$R *.dfm}

function TDMSat.PathApp: String;
begin
  Result := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)) + 'CFe');

  if not DirectoryExists(Result) then
    ForceDirectories(Result);
end;

function TDMSat.PathLog: String;
begin

  Result := IncludeTrailingPathDelimiter(PathApp + 'Log');

  if not DirectoryExists(Result) then
    ForceDirectories(Result);
end;

function TDMSat.RecuperaUltimoCFe: Integer;
begin
  Result := 0;
  // Esta função é importante quando for fazer uma transação TEF por exemplo e necessita vincular o nº cupom ao pagamento
  try
    Result := StrToIntDef(ACBrSAT1.Status.ULTIMO_CFe, 0);
  except
    on E: exception do
    begin
      GravaLog('Erro -98: ' + E.Message);
      MessageDlg('Erro ao recuperar o último CFe!' + sLineBreak + 'Entre em contato com o suporte técnico', mtError, [mbok],0);
    end;
  end;
end;

procedure TDMSat.VisualizarCFe;
begin
  // 03-04-2024
  ACBrSAT1.Extrato := ACBrSATExtratoFortes1;
  ACBrSAT1.Extrato.MostraPreview := true;
  ACBrSAT1.Extrato.MostraStatus := false;
  ACBrSAT1.Extrato.MostraSetup := false;
  ACBrSAT1.Extrato.CasasDecimais.qCom := 3;
  ACBrSAT1.Extrato.CasasDecimais.vUnCom := 2;

  ACBrSATExtratoFortes1.ImprimeDescAcrescItem := True;
  ACBrSATExtratoFortes1.ImprimeLogoLateral := (dados.cdsTerminalQRCODE_LATERAL.Value = 'S');
  ACBrSATExtratoFortes1.ImprimeQRCodeLateral := (dados.cdsTerminalQRCODE_LATERAL.Value = 'S');
  ACBrSATExtratoFortes1.ExpandeLogoMarca := false;
  ACBrSATExtratoFortes1.EspacoFinal := 0; //TESTE
  ACBrSATExtratoFortes1.LarguraBobina := dados.cdsTerminalLARGURA_BOBINA.Value;
  ACBrSATExtratoFortes1.MargemDireita := dados.cdsTerminalMARGEM_DIREITA.AsFloat;
  ACBrSATExtratoFortes1.MargemEsquerda := dados.cdsTerminalMARGEM_ESQUERDA.AsFloat;
  ACBrSATExtratoFortes1.MargemInferior := dados.cdsTerminalMARGEM_INFERIOR.AsFloat;
  ACBrSATExtratoFortes1.MargemSuperior := dados.cdsTerminalMARGEM_SUPERIOR.AsFloat;
  ACBrSATExtratoFortes1.Sistema := ' ';
  ACBrSATExtratoFortes1.Site := ' ';
  ACBrSATExtratoFortes1.Usuario := ' ';
  ACBrSATExtratoFortes1.Email := ' ';
  if FilesExists(dados.qryConfigLOGOMARCA.Value) then
    ACBrSATExtratoFortes1.Logo := dados.qryConfigLOGOMARCA.Value;
end;

function TDMSat.GetErroMFe(const AXML: String): String;
var
  LeitorXML: TLeitor;
begin
  if (pos('Erro', AXML) > 0) and (pos('Valor', AXML) > 0) then
  begin
    LeitorXML := TLeitor.Create;
    try
      LeitorXML.Arquivo := AXML;
      if LeitorXML.rExtrai(1, 'Valor') <> '' then
        Result := LeitorXML.rCampo(tcStr, 'Valor');
    finally
      LeitorXML.Free;
    end;
  end
  else
    Result := AXML;
end;

procedure TDMSat.EnviaPagamentoTeste(aEmitente: String; aICMSBase: Extended;
  aTotalVenda: Extended);
var
  PagamentoMFe: TEnviarPagamento;
  RespostaPagamentoMFe: TRespostaPagamento;
begin
  RespostaPagamentoMFe := Nil;
  PagamentoMFe := TEnviarPagamento.Create;
  try
    with PagamentoMFe do
    begin
      Clear;
      ChaveAcessoValidador := '25CFE38D-3B92-46C0-91CA-CFF751A82D3D';
      // Esta chave é Fixa, (Esta chave está definida no Manual Integrador Fiscal)
      ChaveRequisicao := '26359854-5698-1365-9856-965478231456';
      // Esta chave deve ser unica por requisição, deve-se gerar um GUID com a combinação: (Cód. Filial / Adquirinte ex:(Cielo) / ID ) - (Esta chave está definida no Manual Integrador Fiscal, para testes)
      Estabelecimento := '1';
      // Codigo do estabelecimento fornecido pela Adquirinte contratada, enquanto não estiver funcionando a integração deve informar valor fixo
      SerialPOS := InputBox('SerialPOS', 'Informe o Serial do POS',
        'ACBr-' + RandomName(8));
      // Como não existe este equipamento POS Integrado conforme previsão inicial da SEFAZ CE, está sendo informado o Numero serial do Equipamento POS, independente do Modelo utilizado. (Está gerando random para diversificar o código neste Demo )
      // Como não existe este equipamento POS Integrado conforme previsão inicial da SEFAZ CE, está sendo informado o Numero serial do Equipamento POS, independente do Modelo utilizado. (Está gerando random para diversificar o código neste Demo )
      CNPJ := aEmitente; // CNPJ do Contribuinte
      IcmsBase := aICMSBase; // Valor sujeito a legislação do ICMS
      ValorTotalVenda := aTotalVenda; // Valor total a ser cobrado
      HabilitarMultiplosPagamentos := True;
      // Opção para mais de uma forma de pagamento ou mais de um cartão
      HabilitarControleAntiFraude := False;
      // Será usado para validação de possíveis fraudes no pagamento
      CodigoMoeda := 'BRL'; // Formato da moeda
      EmitirCupomNFCE := False;
      // Usado Apenas para emissão de NFCe direto pelo equipamento POS
      OrigemPagamento := 'Mesa 1234'; // Descrição da origem do pagamento
    end;

    if ACBrSAT1.SAT is TACBrSATMFe_integrador_XML then
      RespostaPagamentoMFe := TACBrSATMFe_integrador_XML(ACBrSAT1.SAT)
        .EnviarPagamento(PagamentoMFe)
    else
      RespostaPagamentoMFe := ACBrIntegrador1.EnviarPagamento(PagamentoMFe);

    if Assigned(RespostaPagamentoMFe) then
    begin
      ShowMessage(RespostaPagamentoMFe.XML);
    end;

  finally
    PagamentoMFe.Free;
    if Assigned(RespostaPagamentoMFe) then
      RespostaPagamentoMFe.Free;
  end;
end;

procedure TDMSat.EnviarPagamentoTEF(aVenda: Integer);
var
  qryVendaTEF: TFDQuery;
  StatusPagamentoMFe: TStatusPagamento;
  RespostaStatusPagamento: TRespostaStatusPagamento;
begin

  try
    qryVendaTEF := TFDQuery.Create(self);
    qryVendaTEF.Connection := dados.Conexao;

    qryVendaTEF.Close;
    qryVendaTEF.SQL.Clear;
    qryVendaTEF.SQL.Text :=
      'SELECT * FROM VENDAS_FPG WHERE FEZ_TEF=''S'' AND VENDAS_MASTER=:VD';
    qryVendaTEF.Params[0].Value := aVenda;
    qryVendaTEF.Open;

    while not qryVendaTEF.Eof do
    begin

      try
        StatusPagamentoMFe := TStatusPagamento.Create;
        try
          with StatusPagamentoMFe do
          begin
            Clear;
            ChaveAcessoValidador := dados.qryConfigCODIGO_VINCULACAO.AsString;
            CodigoAutorizacao := qryVendaTEF.FieldByName('CODIGOAUTORIZACAO').AsString;
            Bin := qryVendaTEF.FieldByName('BIN').AsString;
            Donocartao := qryVendaTEF.FieldByName('DONOCARTAO').AsString;
            DataExpiracao := qryVendaTEF.FieldByName('DATAEXPIRACAO').AsString;
            InstituicaoFinanceira := qryVendaTEF.FieldByName('REDE').AsString;
            Parcelas := qryVendaTEF.FieldByName('PARCELAS').AsInteger;
            CodigoPagamento :=qryVendaTEF.FieldByName('CODIGOPAGAMENTO').AsString;
            ValorPagamento := qryVendaTEF.FieldByName('VALORPAGAMENTO').AsFloat;
            IDFILA := qryVendaTEF.FieldByName('ID_FILA').AsInteger;
            Tipo := qryVendaTEF.FieldByName('TIPO_TEF').AsString;
            UltimosQuatroDigitos := qryVendaTEF.FieldByName('ULTIMOSQUATRODIGITOS').AsInteger;
          end;

          if ACBrSAT1.SAT is TACBrSATMFe_integrador_XML then
            RespostaStatusPagamento := TACBrSATMFe_integrador_XML(ACBrSAT1.SAT)
              .EnviarStatusPagamento(StatusPagamentoMFe)
          else
            RespostaStatusPagamento := ACBrIntegrador1.EnviarStatusPagamento
              (StatusPagamentoMFe);

        finally
          StatusPagamentoMFe.Free;
        end;
      except
        raise Exception.Create(self.GetErroMFe(ACBrIntegrador1.ErroResposta));
      end;
      qryVendaTEF.Next;
    end;
  finally
    qryVendaTEF.Free;
  end;
end;

procedure TDMSat.EnviarPagamentoPOS(aChaveAcessoValidador: String;
  aEstabelecimento: String; aSerialPOS: String; aCNPJ: String;
  aTotalIcms: Extended; aTotalVenda: Extended; aOrigem: string);
var
  PagamentoMFe: TEnviarPagamento;
  RespostaPagamentoMFe: TRespostaPagamento;
begin
  RespostaPagamentoMFe := Nil;
  PagamentoMFe := TEnviarPagamento.Create;
  try
    with PagamentoMFe do
    begin
      Clear;
      ChaveAcessoValidador := aChaveAcessoValidador;
      ChaveRequisicao := GetGUID;
      Estabelecimento := aEstabelecimento;
      SerialPOS := aSerialPOS;
      CNPJ := aCNPJ;
      IcmsBase := aTotalIcms;
      ValorTotalVenda := aTotalVenda;
      HabilitarMultiplosPagamentos := True;
      HabilitarControleAntiFraude := False;
      CodigoMoeda := 'BRL';
      // Formato da moeda
      EmitirCupomNFCE := False;
      OrigemPagamento := 'Caixa ' + aOrigem;
      // Descrição da origem do pagamento
    end;

    if ACBrSAT1.SAT is TACBrSATMFe_integrador_XML then
      RespostaPagamentoMFe := TACBrSATMFe_integrador_XML(ACBrSAT1.SAT)
        .EnviarPagamento(PagamentoMFe)
    else
      RespostaPagamentoMFe := ACBrIntegrador1.EnviarPagamento(PagamentoMFe);

    if ACBrIntegrador1.ErroResposta <> '' then
      raise Exception.Create(self.GetErroMFe(ACBrIntegrador1.ErroResposta));

  finally
    PagamentoMFe.Free;
    if Assigned(RespostaPagamentoMFe) then
      RespostaPagamentoMFe.Free;
  end;
end;

function TDMSat.GetGUID: String;
var
  G: TGUID;
begin
  if CreateGuid(G) = S_OK then
    Result := GUIDToString(G)
  else
    Result := EmptyStr;
end;

procedure TDMSat.DiretoriosDeArquivos;
begin

  if not DirectoryExists(PathLog) then
    ForceDirectories(PathLog);

  ACBrSAT1.ArqLOG := PathLog + FormatDateTime('"SAT_"yyyymmdd".TXT"', DATE);

  //if dados.qryTerminalTIPO_SAT_DLL.Value = 'mfe_Integrador_XML' then
  if dados.qryconsulta.FieldByname('TIPO_SAT_DLL').AsString = 'mfe_Integrador_XML' then
    ACBrIntegrador1.ArqLOG := PathLog + FormatDateTime('"MFE_"yyyymmdd".TXT"', DATE);

  ACBrPosPrinter1.ArqLOG := PathLog + FormatDateTime
    ('"POSPRINTER_"yyyymmdd".TXT"', DATE);
end;

procedure TDMSat.ACBrSAT1GetcodigoDeAtivacao(var Chave: AnsiString);
begin
  Chave := AnsiString(dados.qryConfigCODIGO_ATIVACAO.AsString);
end;

procedure TDMSat.ACBrSAT1GetsignAC(var Chave: AnsiString);
begin
  // Assinatura da Software House
  if ACBrSAT1.config.ide_tpAmb = taProducao then
    Chave := AnsiString(dados.qryConfigCODIGO_VINCULACAO.AsString)
  else
    // Bematech/Tanca/Kryptus/Daruma/Elgin/Sweda/Dimep
    Chave := 'SGR-SAT SISTEMA DE GESTAO E RETAGUARDA DO SAT';
    // Elgin
    //Chave := CODIGO DE VINCULACAO AC DO MFE-CFE
end;

procedure TDMSat.ConfiguraSAT;

begin
  dados.qryconsulta.Close;
  dados.qryconsulta.SQL.Text :=
    'select CONTINGENCIA,PORTA,MODELO,NVIAS,IMPRIME,USAGAVETA,VELOCIDADE,TIPO_SAT_DLL,CAMINHO_SAT_DLL,MODELO_SAT_DLL,CFE_VERSAO from VENDAS_TERMINAIS where NOME='
    + QuotedStr(dados.Getcomputer);
  dados.qryconsulta.Open;

  DiretoriosDeArquivos;

  dados.qryConfig.Close;
  dados.qryConfig.Params[0].Value := dados.qryEmpresaCODIGO.Value;
  dados.qryConfig.Open;

  if dados.qryConfig.IsEmpty then
  begin
    GravaLog('Erro -101: Configure os parâmetros para emissão do SAT-CFe!');
    //raise Exception.Create
      //('Módulo DFe ainda não foi configurado, impossível continuar!');
      raise Exception.Create('Configure os parâmetros para emissão do SAT-CFe!');
  end;

  if not dados.qryConfig.IsEmpty then
  begin
    //if dados.qryTerminalTIPO_SAT_DLL.Value = 'satNenhum' then
    //  ACBrSAT1.Modelo := TACBrSATModelo(satNenhum);

    //if dados.qryTerminalTIPO_SAT_DLL.Value = 'satDinamico_cdecl' then
    //  ACBrSAT1.Modelo := TACBrSATModelo(satDinamico_cdecl);

    if trim(dados.qryconsulta.FieldByname('TIPO_SAT_DLL').AsString) = 'SAT' then
    begin
      if (pos('Epson', (dados.qryconsulta.FieldByname('CAMINHO_SAT_DLL').AsString))>0) then
        ACBrSAT1.Modelo := TACBrSATModelo(satDinamico_cdecl);
      if (pos('Control ID', (dados.qryconsulta.FieldByname('CAMINHO_SAT_DLL').AsString))>0) then
        ACBrSAT1.Modelo := TACBrSATModelo(satDinamico_cdecl);
      if (pos('Gertec', (dados.qryconsulta.FieldByname('CAMINHO_SAT_DLL').AsString))>0) then
        ACBrSAT1.Modelo := TACBrSATModelo(satDinamico_cdecl)
      else
        ACBrSAT1.Modelo := TACBrSATModelo(satDinamico_stdcall);
    end;

    if trim(dados.qryconsulta.FieldByname('TIPO_SAT_DLL').AsString) = 'MFE' then //'mfe_Integrador_XML'
      //ACBrSAT1.Modelo := TACBrSATModelo(mfe_Integrador_XML);
      ACBrSAT1.Modelo := TACBrSATModelo(satDinamico_stdcall); // Sem o integrador fiscal

    // Driver MFE (mfe.dll - 01.05.18)
    ACBrSAT1.NomeDLL := dados.qryconsulta.FieldByname('CAMINHO_SAT_DLL').AsString;
    if not FileExists(ACBrSAT1.NomeDLL) then
    begin
      MessageDlg('Não foi possível encontrar a dll do fabricante SAT em seu computador!' + #13 + 'Entre em contato com o suporte técnico', TMsgDlgType.mtWarning,[mbok],0);
      //exit;
    end;

    //ACBrSAT1.ArqLOG := ExtractFileDir(ParamStr(0)) +'\log\SATLOG.txt';

    if dados.qryConfigAMBIENTE.Value = 0 then
      ACBrSAT1.Config.ide_tpAmb := taProducao
    else
      ACBrSAT1.Config.ide_tpAmb := taHomologacao;

    //ACBrSAT1.Config.ide_numeroCaixa := dados.idCaixa; // retorna 0

    // CNPJ da White Sistemas E Tecnologia Ltda (Software House)
    if (ACBrSAT1.Config.ide_tpAmb=taProducao) then
    begin
      ACBrSAT1.Config.ide_CNPJ := '46204900000151'; //TiraPontos(dados.qryParametroCNPJ.AsString);
      ACBrSAT1.Config.emit_CNPJ := TiraPontos(dados.qryEmpresaCNPJ.AsString);
      ACBrSAT1.Config.emit_IE := TiraPontos(dados.qryEmpresaIE.AsString);
      ACBrSAT1.Config.emit_IM := TiraPontos(dados.qryEmpresaIM.AsString);
    end;

    ACBrSAT1.Config.emit_cRegTribISSQN := RTISSMicroempresaMunicipal;
    ACBrSAT1.Config.emit_indRatISSQN := irNao;
    //ACBrSAT1.Config.PaginaDeCodigo := 0; //65001
    //ACBrSAT1.Config.EhUTF8 := False; //True
    ACBrSAT1.Config.infCFe_versaoDadosEnt := StrToFloatDef(StringReplace(dados.qryconsulta.FieldByname('CFE_VERSAO').AsString,'.',',',[rfReplaceAll]), 0.09);

    if (ACBrSAT1.Config.ide_tpAmb=taHomologacao) and ((dados.qryConfigTIPO_APLICATIVO.AsString = 'S') or (dados.qryConfigTIPO_APLICATIVO.AsString = 'M')) then
    begin
      // Emulador usa cdecl
      case pos('S', (dados.qryconsulta.FieldByname('MODELO_SAT_DLL').AsString)) of
        1: begin
            ACBrSAT1.Modelo := TACBrSATModelo(satDinamico_cdecl);
            ACBrSAT1.Config.ide_CNPJ := '11111111111111';
            ACBrSAT1.Config.emit_IE := '111111111111';
            ACBrSAT1.Config.emit_CNPJ := '11111111111111';
          end;
      end;

      // Gertec SAT/MFE de desenvolvimento (White Sistemas)
      if ((pos('Gertec', (dados.qryconsulta.FieldByname('CAMINHO_SAT_DLL').AsString))>0) or (trim(dados.qryconsulta.FieldByname('TIPO_SAT_DLL').AsString) = 'MFE')) then
      begin
        ACBrSAT1.Config.ide_CNPJ := '16716114000172'; // CNPJ Software House
        ACBrSAT1.config.emit_CNPJ := '03654119000176'; // CNPJ Contribuinte
        ACBrSAT1.config.emit_IE := '000052619494'; // IE
      end;
    end;

    case dados.qryEmpresaCRT.AsInteger of
      1: ACBrSAT1.Config.emit_cRegTrib := RTSimplesNacional; // Simples nacional
      2: ACBrSAT1.Config.emit_cRegTrib := RTSimplesNacional; // Simples - Excesso de Sublimite da Receita Bruta
      3: ACBrSAT1.Config.emit_cRegTrib := RTRegimeNormal; // Lucro presumido/real
    end;

    ACBrSAT1.ConfigArquivos.SalvarCFe := True;
    ACBrSAT1.ConfigArquivos.SalvarCFeCanc := True;
    ACBrSAT1.ConfigArquivos.SalvarEnvio := False; // Não gerar arquivos SOAP de envio
    ACBrSAT1.ConfigArquivos.SepararPorCNPJ := True;
    ACBrSAT1.ConfigArquivos.SepararPorMes := True;

    ACBrSAT1.Config.ArqSchema := dados.qryConfigPASTA_CFE_SCHEMA.AsString;
    ACBrSAT1.ConfigArquivos.PastaCFeVenda :=
      dados.qryConfigPASTA_CFE_VENDA.AsString;
    ACBrSAT1.ConfigArquivos.PastaCFeCancelamento :=
      dados.qryConfigPASTA_CFE_CANCELAMENTO.AsString;
    ACBrSAT1.ConfigArquivos.PastaEnvio :=
      dados.qryConfigPASTA_CFE_ENVIO.AsString;

    if dados.qryconsulta.FieldByname('TIPO_SAT_DLL').AsString = 'mfe_Integrador_XML' then
    begin
      ACBrIntegrador1.PastaInput := dados.qryConfigMFE_INPUT.AsString;
      ACBrIntegrador1.PastaOutput := dados.qryConfigMFE_OUTPUT.AsString;
      //ACBrIntegrador1.PastaBackup :=
      //ACBrIntegrador1.ArqLOG := ExtractFileDir(ParamStr(0)) +'\log\MFELOG.txt';
      ACBrIntegrador1.Timeout := 30; //30 seg
      ACBrSAT1.Integrador := ACBrIntegrador1;
    end
    else
      ACBrSAT1.Integrador := nil;

    // ACBrSAT1.CFe.IdentarXML := False;
    // ACBrSAT1.CFe.TamanhoIdentacao := 1;
    ACBrSAT1.CFe.IdentarXML := True;
    ACBrSAT1.CFeCanc.IdentarXML := True;
    ACBrSAT1.CFe.TamanhoIdentacao := 3;
    ACBrSAT1.CFe.RetirarAcentos := True;
  end;

  ConfiguraImpressoraSAT;
end;

procedure TDMSat.ConfiguraImpressoraSAT;
begin
  // Configurações impressão escpos
  try
    if dados.cdsTerminalTIPOIMPRESSORA.AsString = '1' then
    begin
      ACBrSAT1.Extrato := ACBrSATExtratoFortes1;
      ACBrSATExtratoFortes1.Impressora := dados.cdsTerminalPORTA.Value;
    end
    else
    begin
      ACBrSAT1.Extrato := ACBrSATExtratoESCPOS1;
      ACBrPosPrinter1.EspacoEntreLinhas :=
        StrToIntDef(dados.cdsTerminalESPACO_ENTRE_LINHAS.Value,1);
      ACBrPosPrinter1.LinhasEntreCupons :=
        StrtoIntDef(dados.cdsTerminalLINHAS_ENTRE_CUPOM.Value,1);
      ACBrPosPrinter1.ColunasFonteNormal :=
        StrToIntDef(dados.cdsTerminalCOLUNAS.AsString, 42);
      ACBrSATExtratoESCPOS1.MargemDireita :=
        dados.cdsTerminalMARGEM_DIREITA.AsFloat;
      ACBrSATExtratoESCPOS1.MargemEsquerda :=
        dados.cdsTerminalMARGEM_ESQUERDA.AsFloat;
      ACBrSATExtratoESCPOS1.MargemInferior :=
        dados.cdsTerminalMARGEM_INFERIOR.AsFloat;
      ACBrSATExtratoESCPOS1.MargemSuperior :=
        dados.cdsTerminalMARGEM_SUPERIOR.AsFloat;
      ACBrPosPrinter1.Porta := LowerCase(dados.cdsTerminal.FieldByName('PORTA')
        .AsString);
      ACBrPosPrinter1.Device.Baud := dados.cdsTerminalVELOCIDADE.Value;
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

      // 25-09-2024
      if trim(ACBrPosPrinter1.Porta) <> '' then
        ACBrPosPrinter1.Ativar
      else
        GravaLog('Erro -170: Porta não configurada');
    end;

    //ACBrSAT1.Extrato.Sistema := dados.qryParametroEMPRESA.Value;
    ACBrSAT1.Extrato.Sistema := ' ';
    //ACBrSAT1.Extrato.ImprimeDescAcrescItem := False;
    ACBrSAT1.Extrato.ImprimeCodigoEan := True;

    // 30-03-2024
    ACBrSAT1.Extrato.ImprimeMsgOlhoNoImposto := True;
    ACBrSAT1.Extrato.ImprimeQRCode := True;
    ACBrSAT1.Extrato.ImprimeCPFNaoInformado := True;
    //ACBrSAT1.Extrato.ImprimeEmUmaLinha := True;
    ACBrSAT1.Extrato.ImprimeDescAcrescItem := True;
    //ACBrSAT1.Extrato.ImprimeLogoLateral := (dados.cdsTerminalQRCODE_LATERAL.Value = 'S');
    //ACBrSAT1.Extrato.ImprimeQRCodeLateral := (dados.cdsTerminalQRCODE_LATERAL.Value = 'S');

    if (trim(dados.qryConfigLOGOMARCA.AsString)<>'') and FilesExists(dados.qryConfigLOGOMARCA.AsString) then
      ACBrSAT1.Extrato.Logo := dados.qryConfigLOGOMARCA.AsString;
    //ACBrSAT1.Extrato.Site := dados.qryEmpresaSITE.AsString;
    //ACBrSAT1.Extrato.Email := dados.qryEmpresaEMAIL.AsString;
    ACBrSAT1.Extrato.Site := ' ';
    ACBrSAT1.Extrato.Email := ' ';
  except
    // faz nada
    on E: Exception do
      GravaLog('Erro -168: ' + E.Message);
  end;
end;

end.

{**********************************************************************}
{                                                                      }
{          Projeto: White PDV                                          }
{                                                                      }
{          Unit: PAFNFCe.pas                                           }
{                                                                      }
{          Finalidade: Classe integração PAF-NFCe (TTD 707) para SC    }
{                                                                      }
{**********************************************************************}

// Criar MENU FISCAL com as opções sem restrição de acesso:
// Identificação do PAF-NFC-e

// Registros do PAF-NFC-e
// U1 / A2 / P2 / E2 / D2 / D3 / D4 / J1 / J2
// Saídas Identificadas pelo CPF/CNPJ
// Z1 / Z2 / Z3 / Z4 / Z9
// Requisições Externas Registradas
// W1 / W2 / W3 / W4 / W5
// Controle dos DAV
// V1 / V2 / V3 / V4

unit PAFNFCe;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Dialogs, Controls, StdCtrls, Forms,
  ACBrDFe, ACBrPAF, ACBrPAFNFCe, ACBrNFe, ACBrPAFClass, ACBrEAD, ACBrPAF_D,
  ACBrPAF_A, ACBrPAF_H, ACBrPAF_P, ACBrPAF_E, ACBrPAF_R, ACBrPAF_J, ACBrPAF_U,
  ACBrPAF_V, ACBrPAF_W, ACBrPAF_Z, ACBrPAFRegistros, ACBrUtil, DateUtils;

type
  TPAFNFCe = class
  private
    FCodEmpresa: Integer;
    FVersao: String; // Versão do White PDV
    //FAmbiente: Integer; // 1-Produção / 2-Homologação
    FSerieCertificado: String; // Série do certificado digital
    FArqCertificadoPFX: String; // Arquivo certificado (PFX/P12)
    FSenhaCertificadoPFX: String;
    {FProxyHost: String;
    FProxyPorta: Integer;
    FProxyUser: String;
    FProxySenha: String;}
    FDebug: Boolean;
    FDirLOG: String; // Path onde será salvo o arquivo de LOG do componente TACBrPAFNFCe
    FErros: String;
    FArquivo: String; // Nome do arquivo XML assinado
    FXML: String; // XML assinado
    FPAF: TACBrPAF;
    FPAFNFCe: TACBrPAFNFCe;
    //FConnection: TZConnection;
    //FConsulta: TZQuery;
    //FSubConsulta: TZQuery;

    //procedure SetConnection(AValue: TZConnection);
    procedure DoGerarLog(const ALogLine: string; var Tratado: Boolean);
    function AssinarArquivoXML(sArquivo: String; ATipo: Integer): Boolean;
  public
    constructor Create;
    destructor Destroy;

    function Configurar: Boolean;

    // Arquivo eletrônico contendo todas as informações previstas no leiaute estabelecido no Arquivo I deste Anexo,
    // devendo o programa aplicativo disponibilizá-lo e assiná-lo digitalmente conforme especificado no Requisito XI deste Anexo
    function GerarRegistrosPAF(ADataIni, ADataFin: TDateTime; sFiltro: String = ''): Boolean;

    // III – “Saídas Identificadas pelo CPF/CNPJ”, que gerará arquivo eletrônico contendo as informações previstas
    // no leiaute estabelecido no Arquivo II deste Anexo, devendo o programa aplicativo disponibilizá-lo e
    // assiná-lo digitalmente conforme especificado no Requisito XI deste Anexo, com possibilidade de seleção
    // por mês e ano e também por CPF/CNPJ ou todos para os quais houve saída no mês e ano definido
    function GerarSaidasIdentCPFCNPJ(ADataIni, ADataFin: TDateTime; ACpfCnpj: String): Boolean;

    // VI - “Controle dos DAV”, que gerará arquivo eletrônico contendo as informações previstas no leiaute
    // estabelecido no Arquivo IV deste Anexo, devendo o programa aplicativo disponibilizá-lo e assiná-lo
    // digitalmente conforme especificado no Requisito XI deste Anexo
    //function GerarDAV: Boolean;

    property CodEmpresa: Integer read FCodEmpresa write FCodEmpresa;
    property Versao: String read FVersao write FVersao;
    property SerieCertificado: String read FSerieCertificado write FSerieCertificado;
    property ArqCertificadoPFX: String read FArqCertificadoPFX write FArqCertificadoPFX;
    property SenhaCertificadoPFX: String read FSenhaCertificadoPFX write FSenhaCertificadoPFX;
    {property ProxyHost: String read FProxyHost write FProxyHost;
    property ProxyPorta: Integer read FProxyPorta write FProxyPorta;
    property ProxyUser: String read FProxyUser write FProxyUser;
    property ProxySenha: String read FProxySenha write FProxySenha;}
    property Debug: Boolean read FDebug write FDebug;
    property Erros: String read FErros write FErros;
    property Arquivo: String read FArquivo write FArquivo;
    property XML: String read FXML write FXML;
    //property Connection: TZConnection read FConnection write SetConnection;
    //property Consulta: TZQuery read FConsulta;
  end;

implementation

uses
  blcksock,
  pcnConversao,
  ACBrUtil.Base,
  ACBrUtil.DateTime,
  ACBrUtil.FilesIO,
  ACBrDFeSSL,
  ACBrPAFNFCe_Comum;

{ TPAFNFCe }

constructor TPAFNFCe.Create;
begin
  FErros := '';
  try
    FCodEmpresa := 0;
    FVersao := '';
    //FAmbiente := 1; // 1-Produção
    FSerieCertificado := '';
    FArqCertificadoPFX := '';
    FSenhaCertificadoPFX := '';
    FDirLOG := '';
    {FProxyHost := '';
    FProxyPorta := 0;
    FProxyUser := '';
    FProxySenha := '';}
    FArquivo := '';
    FXML := '';
    FDebug := False;
    FErros := '';

    FPAF := TACBrPAF.Create(nil);
    FPAFNFCe := TACBrPAFNFCe.Create(nil);
    FPAFNFCe.OnGerarLog := DoGerarLog;
    //FPAFNFCe.OnTransmitError
    //FConnection := TZConnection.Create(nil);
    //FConsulta := TZQuery.Create(nil);
    //FSubConsulta := TZQuery.Create(nil);
  except
    on E: Exception do
    begin
      FErros := E.Message;
      //GravarLog(FErros);
    end;
  end;
end;

{procedure TPAFNFCe.SetConnection(AValue: TZConnection);
begin
  FConnection := AValue;
  FConsulta.Connection := FConnection;
  FSubConsulta.Connection := FConnection;
end;}

function TPAFNFCe.Configurar: Boolean;
var
  sPath: String;
begin
  Result := False;
  FErros := '';

  try
    {if not FAmbiente in [1, 2] then
    begin
      FErros := 'Ambiente inválido!';
      Exit;
    end;}

    sPath := ExtractFileDir(Application.ExeName);
    if Copy(sPath, Length(sPath), 1) = '\' then
      sPath := Copy(sPath, 1, Length(sPath)- 1);

    FPAF.Path := sPath;
    FPAF.Layout := lpPAFNFCe;
    FPAF.AssinarArquivo := True;

    FPAFNFCe.SSL.DescarregarCertificado;
    FPAFNFCe.Configuracoes.Certificados.NumeroSerie := FSerieCertificado;
    FPAFNFCe.SSL.SSLType := LT_TLSv1_2;

    with FPAFNFCe.Configuracoes.Geral do
    begin
      SSLLib := libWinCrypt;
      SSLCryptLib := cryWinCrypt;
      SSLHttpLib := httpWinHttp;
      SSLXmlSignLib := xsLibXml2;
      Salvar := True;
      ExibirErroSchema := True;
      //RetirarAcentos :=
      //FormatoAlerta :=
    end;

    {with FPAFNFCe.Configuracoes.WebServices do
    begin
      UF := 'SC';
      Ambiente := TpcnTipoAmbiente(FAmbiente);
      Visualizar := True;
      Salvar := False; // Arquivos tipo env/ret SOAP XML
      TimeOut := 90000;
      AguardarConsultaRet := 5000; // Aguarda 5 segundos antes de realizar a consulta
      Tentativas := 20; // Realiza 20 consultas antes de abortar o processo
      IntervaloTentativas := 2000; // Aguarda 2 segundos entre uma consulta e outra
      //AjustaAguardaConsult := 60;
      //ExibirErroSchema := True;
      ProxyHost := FProxyHost;
      ProxyPort := IntToStr(FProxyPorta);
      ProxyUser := FProxyUser;
      ProxyPass := FProxySenha;
    end;}

    with FPAFNFCe.Configuracoes.Arquivos do
    begin
      Salvar := False;
      SepararPorMes := True;
      AdicionarLiteral := True;
      SepararPorCNPJ := True;
      SepararPorModelo := True;
      PathSchemas := sPath + '\Schemas';

      if (Trim(FDirLOG) <> EmptyStr) and (not DirectoryExists(FDirLOG)) then
        ForceDirectories(FDirLOG);
      PathSalvar := FDirLOG;
    end;

    try
      if (FPAFNFCe.SSL.CertDataVenc - Now() < 30) then
         MessageDlg(PChar('Atenção para a data de validade do seu certificado digital.'+ Chr(13) +
                          'Vencimento: ' + DateTimeToStr(FPAFNFCe.SSL.CertDataVenc)), mtWarning, [mbOK], 0);
    except
    end;

    Result := True;
  except
    on E: Exception do
    begin
      FErros := E.Message;
      //GravarLog(FErros);
    end;
  end;
end;

function TPAFNFCe.AssinarArquivoXML(sArquivo: String; ATipo: Integer): Boolean;
begin
  Result := False;
  FErros := '';

  try
    if Trim(sArquivo) = EmptyStr then
    begin
      FErros := 'Arquivo inválido!';
      Exit;
    end;

    if (not FileExists(sArquivo)) then
    begin
      FErros := 'Arquivo não encontrado!';
      Exit;
    end;

    with FPAFNFCe.MenuFiscal do
    begin
      Inicializar;
      LoadFromFile(sArquivo); // Arquivo TXT
      NumeroArquivo := TACBrPAFNFCe_NumeroArquivo(ATipo); //0-tnroArq_Identificacao / 1-tnroArq_Registros / 2-tnroArq_SaidasIdentCPFCNPJ / 3-tnroArq_ReqExternasReg
      DataGeracaoArquivo := DateOf(Now);
      HoraGeracaoArquivo := TimeOf(Now);
      ArquiteturaBD := tarqBD_Local;
      ArquiteturaSistema := tarqSist_Local;
      GerarXML;
      SaveToFile(sArquivo + '.xml');
      FXML := XMLAssinado;
      Result := (Trim(FXML)<>'');
    end;
  except
    on E: Exception do
    begin
      FErros := E.Message;
      //GravarLog(FErros);
    end;
  end;
end;

procedure TPAFNFCe.DoGerarLog(const ALogLine: string; var Tratado: Boolean);
begin
  Tratado := True;
  //todo: Gravar LOG de erros
  if FDebug then
  begin
    //GravarLog(ALogLine);
  end;
end;

function TPAFNFCe.GerarRegistrosPAF(ADataIni, ADataFin: TDateTime; sFiltro: String): Boolean;
begin
  Result := False;
  FErros := '';

  try
    FPAF.LimparTodosRegistros;

    // Registro tipo U1 - Identificação do Estabelecimento Usuário do PAF-NFC-e
    with FPAF.PAF_U do
    begin
      LimpaRegistros;
      (*with FConsulta do
      begin
        Close;
        Sql.Clear;
        Sql.Add('Select');
        Sql.Add('C.Empresa,');
        Sql.Add('C.CnpjEmp,');
        Sql.Add('C.IE,');
        Sql.Add('C.IMEmp,');
        Sql.Add('CI.UF as UFEmp');
        Sql.Add('From Config C');
        Sql.Add('Left Join Cidades CI On C.CodCidade = CI.CodCidade');
        Sql.Add('Where C.CodEmpresa = :pCodEmpresa');
        ParamByName('pCodEmpresa').AsInteger := FCodEmpresa;
        Open;

        with RegistroU1 do
        begin
          UF := FieldByName('UfEmp').AsString; // UF do estabelecimento usuário do PAF-NFC-e
          CNPJ := FieldByName('CnpjEmp').AsString; // CNPJ do estabelecimento usuário do PAF-NFC-e
          IE := FieldByName('IE').AsString; // Inscrição Estadual do estabelecimento
          IM := FieldByName('IMEmp').AsString; // Inscrição Municipal do estabelecimento
          RAZAOSOCIAL := FieldByName('Empresa').AsString; // Razão Social do estabelecimento
        end;
        Close;
      end;*)
    end;

    // Registro tipo A2 - Total diário de meios de pagamento
    with FPAF.PAF_A do
    begin
      LimpaRegistros;

      // Deve ser criado um registro tipo A2 para cada dia de movimento (campo 02), para cada meio de pagamento (campo 03) e para cada tipo de documento (campo 04)
      (*with FConsulta do
      begin
        Close;
        Sql.Clear;
        Sql.Add('Select t.Data, t.Tipo, t.TVLRBOLETO, t.TVLRCARTAOCRED, t.TVLRCARTAODEB, t.TVLRCHEQUE, t.TVLRCREDLOJA,');
        Sql.Add('t.TVLRDINHEIRO, t.TVLROUTROS, t.TVLRPAGINST, t.TVLRTRANSFBANC');
        Sql.Add('From (');
        Sql.Add('Select ''1'' Tipo, N.DataEmi Data,');
        Sql.Add('Sum(N.VLRBOLETO) TVLRBOLETO, Sum(N.VLRCARTAOCRED) TVLRCARTAOCRED, Sum(N.VLRCARTAODEB) TVLRCARTAODEB, Sum(N.VLRCHEQUE) TVLRCHEQUE,');
        Sql.Add('Sum(N.VLRCREDLOJA) TVLRCREDLOJA, Sum(N.VLRDINHEIRO) TVLRDINHEIRO, Sum(N.VLROUTROS) TVLROUTROS, Sum(N.VLRPAGINST) TVLRPAGINST, Sum(N.VLRTRANSFBANC) TVLRTRANSFBANC');
        Sql.Add('From Nfce N');
        Sql.Add('Where N.DataEmi >= :pDataIni and N.DataEmi <= :pDataFin');
        Sql.Add('And N.CodEmpresa = :pCodEmpresa');
        Sql.Add('Group By Data, Tipo');
        Sql.Add('Union All');
        Sql.Add('Select ''2'' Tipo, N1.DataEmi Data,');
        Sql.Add('Sum(N1.VLRBOLETO) TVLRBOLETO, Sum(N1.VLRCARTAOCRED) TVLRCARTAOCRED, Sum(N1.VLRCARTAODEB) TVLRCARTAODEB, Sum(N1.VLRCHEQUE) TVLRCHEQUE,');
        Sql.Add('Sum(N1.VLRCREDLOJA) TVLRCREDLOJA, Sum(N1.VLRDINHEIRO) TVLRDINHEIRO, Sum(N1.VLROUTROS) TVLROUTROS, Sum(N1.VLRPAGINST) TVLRPAGINST, Sum(N1.VLRTRANSFBANC) TVLRTRANSFBANC');
        Sql.Add('From NfVenda N1');
        Sql.Add('Where N1.DataEmi >= :pDataIni and N1.DataEmi <= :pDataFin');
        Sql.Add('And N1.CodEmpresa = :pCodEmpresa');
        Sql.Add('Group By Data, Tipo');
        Sql.Add(') t');
        Sql.Add('Order By t.Data, t.Tipo');
        ParamByName('pDataIni').AsDate := ADataIni;
        ParamByName('pDataFin').AsDate := ADataFin;
        ParamByName('pCodEmpresa').AsInteger := FCodEmpresa;
        Open;

        while not Eof do
        begin
          with RegistroA2.New do
          begin
            // Código do tipo, com as seguintes opções:
            // 1-NFC-e
            // 2-NF-e
            // 3-Operação não tributável, identificando o CPF ou CNPJ do cliente

            // NF/NFCE que tiveram crédito na sua forma de pagamento
            //CNPJ := // CPF ou CNPJ do cliente que realizou a operação cujo código do tipo de documento é “3” (vide campo nº 04)
            //NUMDOCUMENTO := // Nº do Documento emitido quando da realização da operação não tributável, código tipo “3”, se for o caso

            // Boleto bancário
            DT := FieldByName ('Data').AsDateTime; // Data do movimento
            MEIO_PGTO := 'BOLETO BANCARIO'; // Meio de pagamento registrado nos documentos emitidos (Dinheiro, Cheque, Cartão de Crédito, Cartão de Débito, PIX, transferências de recursos, carteira digital etc.)
            TIPO_DOC := FieldByName ('Tipo').AsString;
            VL := FieldByName ('TVLRBOLETO').AsFloat; // Valor total do dia informado no campo 02 correspondente ao meio de pagamento informado no campo 03 e ao tipo de Documento informado no campo 04

            // Cartão crédito
            DT := FieldByName ('Data').AsDateTime;
            MEIO_PGTO := 'CARTAO CREDITO';
            TIPO_DOC := FieldByName ('Tipo').AsString;
            VL := FieldByName ('TVLRCARTAOCRED').AsFloat;

            // Cartão débito
            DT := FieldByName ('Data').AsDateTime;
            MEIO_PGTO := 'CARTAO DEBITO';
            TIPO_DOC := FieldByName ('Tipo').AsString;
            VL := FieldByName ('TVLRCARTAODEB').AsFloat;

            // Cheque
            DT := FieldByName ('Data').AsDateTime;
            MEIO_PGTO := 'CHEQUE';
            TIPO_DOC := FieldByName ('Tipo').AsString;
            VL := FieldByName ('TVLRCHEQUE').AsFloat;

            // Crédito loja
            DT := FieldByName ('Data').AsDateTime;
            MEIO_PGTO := 'CREDITO LOJA';
            TIPO_DOC := FieldByName ('Tipo').AsString;
            VL := FieldByName ('TVLRCREDLOJA').AsFloat;

            // Dinheiro
            DT := FieldByName ('Data').AsDateTime;
            MEIO_PGTO := 'DINHEIRO';
            TIPO_DOC := FieldByName ('Tipo').AsString;
            VL := FieldByName ('TVLRDINHEIRO').AsFloat;

            // Outros
            DT := FieldByName ('Data').AsDateTime;
            MEIO_PGTO := 'OUTROS';
            TIPO_DOC := FieldByName ('Tipo').AsString;
            VL := FieldByName ('TVLROUTROS').AsFloat;

            // Pagamento instantâneo
            DT := FieldByName ('Data').AsDateTime;
            MEIO_PGTO := 'PAGTO INSTANTANEO';
            TIPO_DOC := FieldByName ('Tipo').AsString;
            VL := FieldByName ('TVLRPAGINST').AsFloat;

            // Transf. bancária
            DT := FieldByName ('Data').AsDateTime;
            MEIO_PGTO := 'TRANSF.BANCARIA';
            TIPO_DOC := FieldByName ('Tipo').AsString;
            VL := FieldByName ('TVLRTRANSFBANC').AsFloat;
          end;
          Next;
        end;
      end;*)
    end;

    // Registro tipo P2 - Relação de mercadorias e serviços
    with FPAF.PAF_P do
    begin
      LimpaRegistros;
      RegistroP1.CNPJ := FPAF.PAF_U.RegistroU1.CNPJ;

      // Consulta produtos
      (*with FConsulta do
      begin
        Close;
        Sql.Clear;
        Sql.Add('Select P.CodPro, PE.SitTribut, PE.PerIcms,');
        Sql.Add('P.CodUn, P.CODFISCAL NCM, P.CEST, PE.PreVenda, D.DescDescPro');
        Sql.Add('From Produtos P');
        Sql.Add('Inner Join DescProd D On P.CodDescPro = D.CodDescPro');
        Sql.Add('Inner Join ProdutosEmpresa PE On P.CodPro = PE.CodPro');
        Sql.Add('Where P.CodPro > 0');
        Sql.Add('And PE.CodEmpresa = :pCodEmpresa');
        Sql.Add('Order By P.CodPro');
        ParamByName('pCodEmpresa').AsInteger := FCodEmpresa;
        Open;

        while not Eof do
        begin
          with RegistroP2.New do
          begin
            COD_MERC_SERV := IntToStr(FieldByName('CodPro').AsInteger);
            CEST := FieldByName('CEST').AsString;
            NCM := FieldByName('NCM').AsString;
            DESC_MERC_SERV := FieldByName('DescDescPro').AsString;
            UN_MED := FieldByName('CodUn').AsString;
            IAT := 'A';
            IPPT := 'T';
            // F - Substituição Tributária / T - Tributado pelo ICMS / I - Isento / N - Não Tributado
            if (FieldByName('SitTribut').AsString = 'FF') or
               (FieldByName('SitTribut').AsString = 'II') or
               (FieldByName('SitTribut').AsString = 'NN') then
            begin
              ST := Copy(FieldByName('SitTribut').AsString, 1, 1);
              ALIQ := 0;
            end
            else begin
              ST := 'T';
              ALIQ := FieldByName('PerIcms').AsFloat;
            end;

            VL_UNIT := FieldByName('PreVenda').AsFloat;
          end;
          Next;
        end;
      end;*)
    end;

    // Registro tipo E2 - Relação das Mercadorias em Estoque
    with FPAF.PAF_E do
    begin
      LimpaRegistros;
      RegistroE1.CNPJ := FPAF.PAF_U.RegistroU1.CNPJ;

      (*with FConsulta do
      begin
        Close;
        with FConsulta do
        begin
          Close;
          Sql.Clear;
          Sql.Add('Select P.CodPro, D.DescDescPro, P.CodUn, PE.Estoque, P.DataAlt, P.CodPro, P.CODFISCAL NCM, P.CEST, D.CodDescPro');
          Sql.Add('From Produtos P');
          Sql.Add('Inner Join DescProd D On P.CodDescPro = D.CodDescPro');
          Sql.Add('Inner Join ProdutosEmpresa PE On P.CodPro = PE.CodPro');
          Sql.Add('Where P.CodPro > 0');

          // Estoque parcial
          if Trim(sFiltro) <> '' then
            Sql.Add('And P.CodPro in ' + sFiltro);

          Sql.Add('And PE.CodEmpresa = :pCodEmpresa');
          Sql.Add('Order By P.CodPro');
          ParamByName('pCodEmpresa').AsInteger := FCodEmpresa;
          Open;

          while not Eof do
          begin
            with RegistroE2.New do
            begin
              COD_MERC := IntToStr(FieldByName('CodPro').AsInteger);
              CEST := FieldByName('CEST').AsString;
              NCM := FieldByName('NCM').AsString;
              DESC_MERC := FieldByName('DescDescPro').AsString;
              UN_MED := FieldByName('CodUn').AsString;
              QTDE_EST := FieldByName('Estoque').AsFloat; // Quantidade da mercadoria ou produto constante no estoque
              DATAEMISSAO := Now; // Data em que o arquivo foi solicitado
              DATAESTOQUE := FieldByName('DataAlt').AsDateTime; // Data da posição do estoque
            end;
            Next;
          end;
          Close;
        end;
      end;*)
    end;

    // Registro tipo D2 - DAV emitidos
    // Registro tipo D3 - Detalhe do DAV
    // Registro tipo D4 - Log de Alteração de Itens do DAV

    // Registro tipo J1 – NFC-e EMITIDA PELO PAF-NFC-e
    with FPAF.PAF_J do
    begin
      LimpaRegistros;
      (*with FConsulta do
      begin
        Close;
        Sql.Clear;
        Sql.Add('Select CF.CnpjEmp, N.CodNFCe, N.NumNF, N.Serie, N.DataEmi, N.ChaveNfe, N.TotalNota,');
        Sql.Add('N.TotalItens, N.Desconto, N.Contingencia, N.Status, C.NomeCli, C.CPFCli, C.CNPJCli');
        Sql.Add('From Nfce N');
        Sql.Add('Inner Join Config CF On N.CodEmpresa = CF.CodEmpresa');
        Sql.Add('Left Join Clientes C On N.CodCli = C.CodCli');
        Sql.Add('And N.Status in (-1, 1, -2, 2)'); // Emitidas / Contingência / Canceladas
        Sql.Add('And N.CodEmpresa = :pCodEmpresa');
        Sql.Add('And N.DataEmi >= :pDataIni');
        Sql.Add('And N.DataEmi <= :pDataFin');
        Sql.Add('Order By CF.CnpjEmp, N.DataEmi, N.Serie, N.NumNF');
        ParamByName('pDataIni').AsDate := ADataIni;
        ParamByName('pDataFin').AsDate := ADataFin;
        ParamByName('pCodEmpresa').AsInteger := FCodEmpresa;
        Open;

        while not Eof do
        begin
          with RegistroJ1.New do
          begin
            CNPJ := FieldByName('CnpjEmp').AsString;
            DATA_EMISSAO := FieldByName('DataEmi').AsDateTime;
            SUBTOTAL := FieldByName('TotalNota').AsFloat;
            DESC_SUBTOTAL := FieldByName('Desconto').AsFloat; // Informar ‘V” para valor monetário ou “P” para percentual
            INDICADOR_DESC := 'V';
            //ACRES_SUBTOTAL :=
            //INDICADOR_ACRES :=
            VALOR_LIQUIDO := FieldByName('TotalItens').AsFloat;
            if FieldByName('Status').AsInteger = 2 then
              INDICADOR_CANC := 'S'
            else
              INDICADOR_CANC := 'N';
            //VAL_CANC_ACRES :=
            //ORDEM_APLIC_DES_ACRES :=
            NOME_CLIENTE := FieldByName('NomeCli').AsString;
            CPFCNPJ_CLIENTE := FieldByName('CPFCli').AsString + FieldByName('CNPJCli').AsString;
            NUMERO_NOTA := IntToStr(FieldByName('NumNF').AsInteger);
            SERIE_NOTA := FieldByName('Serie').AsString;
            CHAVE_NF := FieldByName('ChaveNfe').AsString;
            TIPO_DOC := '1'; //1-NFC-e

            // Informar o tipo de emissão da NFC-e, nos termos do Manual de orientações da NFC-e – utilizar os códigos tpEmis
            if (FieldByName('Contingencia').AsString = 'S') and (FieldByName('Status').AsInteger = -2) then // Contingência off-line
              TIPOEMISSAO := '9'
            else
              TIPOEMISSAO := '1'; // Emissão normal

            // Registro tipo J2 – DETALHES DA NFC-e EMITIDAS EM CONTINGÊNCIA PELO PAF-NFC-e
            if TIPOEMISSAO = '9' then
            begin
              with RegistroJ2.New do
              begin
                with FSubConsulta do
                begin
                  Close;
                  Sql.Clear;
                  Sql.Add('Select CF.CnpjEmp, N.NumNF, N.Serie, N.DataEmi, N.ChaveNfe, NI.Item, P.CodPro, D.DescDescPro, NI.Qtd,');
                  Sql.Add('NI.PreVenda, NI.Desconto, NI.TotalItem, P.CodUn, PE.SitTribut');
                  Sql.Add('From Nfce N');
                  Sql.Add('Inner Join NFCeItens NI On N.CodNFCe = NI.CodNFCe And N.CodEmpresa = NI.CodEmpresa');
                  Sql.Add('Inner Join Config CF On N.CodEmpresa = CF.CodEmpresa');
                  Sql.Add('Inner Join Produtos P ON NI.CodPro = P.CodPro');
                  Sql.Add('Inner Join DescProd D On P.CodDescPro = D.CodDescPro');
                  Sql.Add('Inner Join ProdutosEmpresa PE On P.CodPro = PE.CodPro And PE.CodEmpresa = ' + IntToStr(FCodEmpresa));
                  Sql.Add('Where N.CodNFCe = :pCodNFCe');
                  Sql.Add('And N.CodEmpresa = :pCodEmpresa');
                  Sql.Add('Order By CF.CnpjEmp, N.DataEmi, N.Serie, N.NumNF, NI.Item');
                  ParamByName('pCodNFCe').AsInteger := FConsulta.FieldByName('CodNFCe').AsInteger;
                  ParamByName('pCodEmpresa').AsInteger := FCodEmpresa;
                  Open;

                  while not Eof do
                  begin
                    with RegistroJ2.New do
                    begin
                      CNPJ := FieldByName('CnpjEmp').AsString;
                      DATA_EMISSAO := FieldByName('DataEmi').AsDateTime;
                      NUMERO_ITEM := IntToStr(FieldByName('Item').AsInteger);
                      CODIGO_PRODUTO := IntToStr(FieldByName('CodPro').AsInteger);
                      DESCRICAO := FieldByName('DescDescPro').AsString;
                      QUANTIDADE := FieldByName('Qtd').AsFloat;
                      UNIDADE := FieldByName('CodUn').AsString;
                      VALOR_UNITARIO := FieldByName('PreVenda').AsFloat;
                      DESCONTO_ITEM := FieldByName('Desconto').AsFloat;
                      //ACRESCIMO_ITEM :=
                      VALOR_LIQUIDO := FieldByName('TotalItem').AsFloat;
                      // F - Substituição Tributária / T - Tributado pelo ICMS / I - Isento / N - Não Tributado
                      if (FieldByName('SitTribut').AsString = 'FF') or
                         (FieldByName('SitTribut').AsString = 'II') or
                         (FieldByName('SitTribut').AsString = 'NN') then
                        TOTALIZADOR_PARCIAL := Copy(FieldByName('SitTribut').AsString, 1, 1)
                      else
                        TOTALIZADOR_PARCIAL := 'T';

                      // todo: Ver configuração de casas decimais por produto
                      CASAS_DECIMAIS_QTDE := '2';
                      CASAS_DECIMAIS_VAL_UNIT := '2';
                      NUMERO_NOTA := IntToStr(FieldByName('NumNF').AsInteger);
                      SERIE_NOTA := FieldByName('Serie').AsString;
                      CHAVE_NF := FieldByName('ChaveNfe').AsString;
                      TIPO_DOC := '1'; //1-NFC-e
                    end;
                    Next;
                  end;
                end;
              end;
            end;
          end;
          Next;
        end;
      end;*)
    end;

    FArquivo := FPAF.Path + 'Arq_RegistrosPAF_' + StringReplace(DateTimeToStr(ADataIni), '/', '', [rfReplaceAll]) +'_' +
       StringReplace(DateTimeToStr(ADataFin), '/', '', [rfReplaceAll]) + '.txt';
    Result := FPAF.SaveToFile_RegistrosPAF(FArquivo);

    if Result then
      Result := AssinarArquivoXML(FArquivo, 1);
  except
    on E: Exception do
    begin
      FErros := E.Message;
      //GravarLog(FErros);
    end;
  end;
end;

function TPAFNFCe.GerarSaidasIdentCPFCNPJ(ADataIni, ADataFin: TDateTime; ACpfCnpj: String): Boolean;
begin
  Result := False;
  FErros := '';
  try
    with FPAF.PAF_Z do
    begin
      LimpaRegistros;
      (*with FConsulta do
      begin
        Close;
        Sql.Clear;
        Sql.Add('Select');
        Sql.Add('C.Empresa,');
        Sql.Add('C.CnpjEmp,');
        Sql.Add('C.IE,');
        Sql.Add('C.IMEmp,');
        Sql.Add('CI.UF as UFEmp');
        Sql.Add('From Config C');
        Sql.Add('Left Join Cidades CI On C.CodCidade = CI.CodCidade');
        Sql.Add('Where C.CodEmpresa = :pCodEmpresa');
        ParamByName('pCodEmpresa').AsInteger := FCodEmpresa;
        Open;

        // Registro tipo Z1 – Identificação do usuário do PAF-NFC-e
        with RegistroZ1 do
        begin
          CNPJ := FieldByName('CnpjEmp').AsString;
          UF := FieldByName('UfEmp').AsString;
          IE := FieldByName('IE').AsString;
          IM := FieldByName('IMEmp').AsString;
          RAZAOSOCIAL := FieldByName('Empresa').AsString;
        end;

        Close;
      end;

      // Registro tipo Z2 - Identificação da empresa desenvolvedora do PAF-NFC-e
      with RegistroZ2 do
      begin
        CNPJ := '';
        UF := 'PR';
        IE := ''; // Conforme consulta em https://dfe-portal.svrs.rs.gov.br/NFE/CCC
        IM := ''; // Conforme consulta em http://www.fazenda.pbh.gov.br/fic
        RAZAOSOCIAL := '';
      end;

      // Registro tipo Z3 - Identificação do PAF-NFC-e
      with RegistroZ3 do
      begin
        NOME := 'White PDV';
        VERSAO := FVersao;
      end;

      // Registro tipo Z4 – Totalização de vendas pelo CPF/CNPJ
      with FConsulta do
      begin
        Close;
        Sql.Clear;
        Sql.Add('Select t.DataEmi, t.CPFCli, t.CNPJCli, t.Total');
        Sql.Add('From (');
        Sql.Add('Select N.DataEmi, C.CPFCli, C.CNPJCli, Sum(N.TotalNota) As Total');
        Sql.Add('From Nfce N');
        Sql.Add('Inner Join Clientes C On N.CodCli = C.CodCli');
        Sql.Add('Where N.Status in (-1, 1, -2)'); // Emitidas / Contingência
        if Trim(ACpfCnpj) <> '' then
          Sql.Add('And C.CPFCli = ' + QuotedStr(ACpfCnpj) + ' OR C.CNPJCli = ' + QuotedStr(ACpfCnpj));
        Sql.Add('And N.CodEmpresa = :pCodEmpresa');
        Sql.Add('And N.DataEmi >= :pDataIni');
        Sql.Add('And N.DataEmi <= :pDataFin');
        Sql.Add('Group By N.DataEmi, C.CPFCli, C.CNPJCli');
        Sql.Add('Union All');
        Sql.Add('Select N.DataEmi, C.CPFCli, C.CNPJCli, Sum(N.TotalNota) As Total');
        Sql.Add('From NfVenda N');
        Sql.Add('Inner Join Clientes C On N.CodCli = C.CodCli');
        Sql.Add('Where N.Status In (-1, 1, -2)');
        if Trim(ACpfCnpj) <> '' then
          Sql.Add('And C.CPFCli = ' + QuotedStr(ACpfCnpj) + ' OR C.CNPJCli = ' + QuotedStr(ACpfCnpj));
        Sql.Add('And N.Operacao = 1'); // ???
        Sql.Add('And N.CodEmpresa = :pCodEmpresa');
        Sql.Add('And N.DataEmi >= :pDataIni');
        Sql.Add('And N.DataEmi <= :pDataFin');
        Sql.Add('Group By N.DataEmi, C.CPFCli, C.CNPJCli');
        Sql.Add(') t');
        Sql.Add('Order By t.DataEmi, t.CPFCli, t.CNPJCli');
        ParamByName('pDataIni').AsDate := ADataIni;
        ParamByName('pDataFin').AsDate := ADataFin;
        ParamByName('pCodEmpresa').AsInteger := FCodEmpresa;
        Open;

        {if IsEmpty then
        begin
          MessageDlg('Nenhuma movimentação no período informado!', mtWarning, [mbOK], 0);
          Exit;
        end;}

        while not Eof do
        begin
          with RegistroZ4.New do
          begin
            CPF_CNPJ := FieldByName('CPFCli').AsString + FieldByName('CNPJCli').AsString; // Número do CPF/CNPJ Identificado na NFC-e
            VL_TOTAL_MENSAL := FieldByName('Total').AsFloat; // Total de saídas no mês, com duas casas decimais, ao CPF/CNPJ indicado no campo 02
            VL_TOTAL_VENDAS := FieldByName('Total').AsFloat; // Total de vendas no mês, com duas casas decimais, ao CPF/CNPJ indicado no campo 02

            // todo: Verificar se existe saídas conforme descrito abaixo
            //VL_TOTAL_OUTRAS_SAIDAS := // Total de saídas diversas das vendas no mês, tais como “bonificações”, “brindes”, “prêmio” etc, com duas casas decimais, ao CPF/CNPJ indicado no campo 02
            DATA_INI := ADataIni;
            DATA_FIM := ADataFin;
          end;
          Next;
        end;
        Close;
      end;*)
    end;

    FArquivo := FPAF.Path + 'Arq_SaidasIdentCPFCNPJ_' + PadLeft(IntToStr(MonthOf(ADataIni)), 2, '0') + IntToStr(YearOf(ADataIni)) + '.txt';
    Result := FPAF.SaveToFile_Z(FArquivo);

    if Result then
      Result := AssinarArquivoXML(FArquivo, 2);
  except
    on E: Exception do
    begin
      FErros := E.Message;
      //GravarLog(FErros);
    end;
  end;
end;

destructor TPAFNFCe.Destroy;
begin
  //FConsulta.Free;
  //FSubConsulta.Free;
  //FConnection.Free;
  FPAF.Free;
  FPAFNFCe.Free;
end;

end.

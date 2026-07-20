
// Documentação
// https://docs.kiwify.com.br/api-reference/general
// https://ajuda.kiwify.com.br/pt-br/article/como-funcionam-os-webhooks-2ydtgl/
// https://kiwify.notion.site/Webhooks-pt-br-c77eb84be10c42e6bb97cd391bca9dce
// https://pipedream.com/docs/api/rest/#get-source-events

unit Pipedream;

interface

uses
  System.SysUtils, System.Types, System.Classes,
  System.DateUtils, System.JSON, System.Hash, REST.Json.Types, REST.Json,
  System.Generics.Collections, REST.Types, REST.Client,
  REST.Authenticator.OAuth, System.Net.HttpClient;

const
  sWorkspaceId = 'o_wMIoggX';
  sToken = '0wlph71rimj'; // Token Webhook Kiwify

type
  TEvent = class
    private
      FId: String; // Id do evento
    public
      constructor Create;
      destructor Destroy;

      property Id: String read FId write FId;
  end;

  TOrder = class
    private
      FId: String; // Id do evento
      FEventType: String;
      FCpfCnpj: String;
      FOrderId: String;
      FOrderStatus: String;
      FCreatedAt: String;
      FUpdatedAt: String;
      FApprovedDate: String;
      FRefundedAt: String;
      FStatus: String;
      FName: String;
      FFrequency: String;
      FSignature: String;
    public
      constructor Create;
      destructor Destroy;

      procedure Limpar;

      property Id: String read FId write FId;
      property EventType: String read FEventType write FEventType;
      property CpfCnpj: String read FCpfCnpj write FCpfCnpj;
      property OrderId: String read FOrderId write FOrderId;
      property OrderStatus: String read FOrderStatus write FOrderStatus;
      property CreatedAt: String read FCreatedAt write FCreatedAt;
      property UpdatedAt: String read FUpdatedAt write FUpdatedAt;
      property ApprovedDate: String read FApprovedDate write FApprovedDate;
      property RefundedAt: String read FRefundedAt write FRefundedAt;
      property Status: String read FStatus write FStatus;
      property Name: String read FName write FName;
      property Frequency: String read FFrequency write FFrequency;
      property Signature: String read FSignature write FSignature;
  end;

  TPipedreamRest = class
    FApiKey: String;
    FSourceId: String;
    FCpfCnpj: String;
    FEventType: String;
    FOrderId: String;
    FOrderStatus: String;
    FCreatedAt: String;
    FUpdatedAt: String;
    FApprovedDate: String;
    FRefundedAt: String;
    FStatus: String;
    FName: String;
    FFrequency: String;
    FSignature: String;
    FAccept: String;
    FAcceptEncoding: String;
    FAcceptCharset: String;
    FContentType: String;
    FJson: String;
    FProxyHost: String;
    FProxyPorta: Integer;
    FProxyUser: String;
    FProxySenha: String;
    FTentativas: Integer;
    FIntervaloTentativas: Integer;
    FUrl: String; // Base URL
    FAccessTokenEndpoint: String;
    FTimeout: Integer;
    FCodigo: Integer;
    FMotivo: String;
    FMsgErro: String;
    FDebug: Boolean;
    FREST: TRESTClient;
    FRESTReq: TRESTRequest;
    FOAuth2: TOAuth2Authenticator;
    FEvents: TObjectList<TEvent>;
    FOrders: TObjectList<TOrder>;
  public
     constructor Create;
     destructor Destroy;

     function Configurar: Boolean;

     // /users/me/sources
     function GetSources: Boolean;

     // /sources/{id}/event_summaries
     function GetEvents(AEmail: String): Boolean;

     property ApiKey: String read FApiKey write FApiKey;
     property SourceId: String read FSourceId write FSourceId;
     property CpfCnpj: String read FCpfCnpj write FCpfCnpj;
     property EventType: String read FEventType write FEventType;
     property OrderId: String read FOrderId write FOrderId;
     property OrderStatus: String read FOrderStatus write FOrderStatus;
     property CreatedAt: String read FCreatedAt write FCreatedAt;
     property UpdatedAt: String read FUpdatedAt write FUpdatedAt;
     property ApprovedDate: String read FApprovedDate write FApprovedDate;
     property RefundedAt: String read FRefundedAt write FRefundedAt;
     property Status: String read FStatus write FStatus;
     property Name: String read FName write FName;
     property Frequency: String read FFrequency write FFrequency;
     property Signature: String read FSignature write FSignature;
     property Accept: String read FAccept write FAccept;
     property ContentType: String read FContentType write FContentType;
     property Json: String read FJson;
     property Url: String read FUrl write FUrl;
     property Tentativas: Integer read FTentativas write FTentativas;
     property IntervaloTentativas: Integer read FIntervaloTentativas write FIntervaloTentativas;
     property Timeout: Integer read FTimeout write FTimeout;
     property ProxyHost: String read FProxyHost write FProxyHost;
     property ProxyPorta: Integer read FProxyPorta write FProxyPorta;
     property ProxyUser: String read FProxyUser write FProxyUser;
     property ProxySenha: String read FProxySenha write FProxySenha;
     property MsgErro: String read FMsgErro write FMsgErro;
     property Debug: Boolean read FDebug write FDebug;
     property Events: TObjectList<TEvent> read FEvents;
     property Orders: TObjectList<TOrder> read FOrders;
  end;

implementation

{ TEvent }

constructor TEvent.Create;
begin

end;

destructor TEvent.Destroy;
begin

end;

{ TOrder }

constructor TOrder.Create;
begin

end;

destructor TOrder.Destroy;
begin

end;

procedure TOrder.Limpar;
begin
  FId := '';
  FEventType := '';
  FCpfCnpj := '';
  FOrderId := '';
  FOrderStatus := '';
  FCreatedAt := '';
  FUpdatedAt := '';
  FApprovedDate := '';
  FRefundedAt := '';
  FStatus := '';
  FName := '';
  FFrequency := '';
  FSignature := '';
end;

{ TPipedreamRest }

constructor TPipedreamRest.Create;
begin
  inherited Create;

  FApiKey := '';
  FSourceId := '';
  FCpfCnpj := '';
  FEventType := '';
  FOrderId := '';
  FOrderStatus := '';
  FCreatedAt := '';
  FUpdatedAt := '';
  FApprovedDate := '';
  FRefundedAt := '';
  FStatus := '';
  FName := '';
  FFrequency := '';
  FSignature := '';
  FContentType := 'application/json';
  FAccept := 'application/json';
  FAcceptCharset := 'utf-8';
  FTentativas := 3;
  FIntervaloTentativas := 3000; // 3 seg
  FTimeout := 90000;
  FProxyHost := '';
  FProxyPorta := 0;
  FProxyUser := '';
  FProxySenha := '';

  FREST := TRESTClient.Create('');
  FREST.HandleRedirects := True;
  FREST.RaiseExceptionOn500 := False;
  FREST.Authenticator := nil;

  FOAuth2 := TOAuth2Authenticator.Create(nil);

  FRESTReq := TRESTRequest.Create(nil);
  FRESTReq.Client := FREST;
  //FRESTReq.SynchronizedEvents := False;
  FRESTReq.HandleRedirects := True;
  FRESTReq.Timeout := FTimeout;

  FOrders := TObjectList<TOrder>.Create;
  FEvents := TObjectList<TEvent>.Create;
end;

function TPipedreamRest.Configurar: Boolean;
begin
  Result := False;

  try
    FREST.ResetToDefaults;
    FREST.BaseURL := FUrl;
    FREST.ContentType := 'application/json';
    FREST.Accept := 'application/json';
    FREST.AcceptCharset := FAcceptCharset;
    FREST.FallbackCharsetEncoding := 'utf-8';
    FREST.HandleRedirects := True;

    // 17-08-2024 - Testes Error 12175
    FREST.SecureProtocols := [THTTPSecureProtocol.TLS12];

    FRESTReq.Params.Clear;
    FRESTReq.Accept := FREST.Accept;
    FRESTReq.AcceptEncoding := FREST.AcceptEncoding;
    FRESTReq.AcceptCharset := FREST.AcceptCharset;

    if FTimeout>0 then
    begin
      FRESTReq.Timeout := FTimeout;
    end;

    FOAuth2.TokenType := TOAuth2TokenType.ttBEARER;
    FOAuth2.AccessToken := FApiKey;
    FOAuth2.ResponseType := TOAuth2ResponseType.rtTOKEN;

    FREST.Authenticator := FOAuth2;

    if Trim(FProxyHost)<>'' then
    begin
      FREST.ProxyServer := FProxyHost;
      FREST.ProxyPort := FProxyPorta;
      FREST.ProxyUsername := FProxyUser;
      FREST.ProxyPassword := FProxySenha;
    end;

    Result := True;
  except
    on E: Exception do
    begin
      FMsgErro := E.ClassName+' '+E.Message;
      //GravarLog(FMsgErro);
    end;
  end;
end;

destructor TPipedreamRest.Destroy;
begin
  inherited;
  FreeAndNil(FEvents);
  FreeAndNil(FOrders);
  FreeAndNil(FREST);
  FreeAndNil(FRESTReq);
  FreeAndNil(FOAuth2);
end;

function TPipedreamRest.GetSources: Boolean;
var
  j, j1: TJSONObject;
begin
  j := TJSONObject.Create;
  j1 := TJSONObject.Create;
  try
    try
      FRESTReq.Method := TRESTRequestMethod.rmGET;
      FRESTReq.Resource := '/users/me/sources';
      FRESTReq.Params.Clear;
      FRESTReq.ClearBody;
      FRESTReq.Params.AddHeader('Authorization', 'Bearer '+ FApiKey);
      FRESTReq.Execute;

      if FRESTReq.Response.StatusCode = 200 then
      begin
        if CompareText(FRESTReq.Response.ContentType, 'application/json') = 0 then
        begin
          FJson := FRESTReq.Response.JSONValue.ToString;

          j := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(FRESTReq.Response.JSONValue.ToString), 0) as TJSONObject;

          if (j<>nil) and (j.Count>0) then
          begin

          end;
        end;
      end;
    except
      on E: Exception do
      begin
        FCodigo := FRESTReq.Response.StatusCode;
        FMotivo := FRESTReq.Response.StatusText;
        FMsgErro := FMsgErro + '  ' + FRESTReq.Response.Content + FRESTReq.Response.ErrorMessage;
        //GravarLog(FMsgErro);
      end;
    end;
  finally
    FreeAndNil(j1);
    FreeAndNil(j);
  end;
end;

function TPipedreamRest.GetEvents(AEmail: String): Boolean;
var
  j, j1, jS, jSg, j2, j3, j4, j5: TJSONObject;
  ja: TJSONArray;
  jv: TJSONValue;
  sValor, sSignature: String;
begin
  Result := False;
  FCodigo := 0;
  FMotivo := '';
  FMsgErro := '';
  FJson := '';

  if (FOrders<>nil) and (FOrders.Count>0) then
    FOrders.Clear;

  if trim(FSourceId) = '' then
  begin
    FMsgErro := 'SourceId não informado!';
    Exit;
  end;

  if trim(AEmail) = '' then
  begin
    FMsgErro := 'Email não informado!';
    Exit;
  end;

  j := TJSONObject.Create;
  try
    try
      FRESTReq.Method := TRESTRequestMethod.rmGET;
      FRESTReq.Resource := '/sources/'+FSourceId+'/event_summaries?expand=event';
      //FRESTReq.Resource := '/sources/'+FSourceId+'/event_summaries';
      FRESTReq.Params.Clear;
      FRESTReq.ClearBody;
      FRESTReq.Params.AddHeader('Authorization:', 'Bearer '+ FApiKey);
      FRESTReq.Execute;

      if FRESTReq.Response.StatusCode = 200 then
      begin
        if CompareText(FRESTReq.Response.ContentType, 'application/json') = 0 then
        begin
          j := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(FRESTReq.Response.JSONValue.ToString), 0) as TJSONObject;

          if (j<>nil) and (j.Count>0) then
          begin
            if FDebug then
            begin
              FJson := TJSON.Format(j).Replace('\/', '/');
              //GravarLog(FJson);
            end;

            ja := TJSONObject.ParseJSONValue(j.Values['data'].ToString) as TJSONArray;

            //TJSON.Format(ja).Replace('\/', '/');

            if (ja<>nil) and (ja.Count>0) then
            begin
              for jv in ja do
              begin
                j1 := TJSONObject.Create;
                jS := TJSONObject.Create;
                jSg := TJSONObject.Create;
                j2 := TJSONObject.Create;
                j3 := TJSONObject.Create;
                j4 := TJSONObject.Create;
                j5 := TJSONObject.Create;
                try
                  j1 := TJSONObject.ParseJSONValue((jv as TJSONObject).Values['event'].ToJSON) as TJSONObject;

                  if (j1<>nil) and (j1.Count>0) then
                  begin
                    if Pos('body', j1.ToJSON)>0 then
                      j2 := TJSONObject.ParseJSONValue(j1.Values['body'].ToJSON) as TJSONObject;

                    if (j2<>nil) and (j2.Count>0) then
                    begin
                      //"Customer": {}
                      if Pos('Customer', j2.ToJSON)>0 then
                      begin
                        j3 := TJSONObject.ParseJSONValue(j2.Values['Customer'].ToJSON) as TJSONObject;

                        if (j3<>nil) and (j3.Count>0) then
                        begin
                          //"email": "willfilho002@gmail.com"
                          if j3.TryGetValue('email', sValor) and (trim(sValor) = AEmail) then
                          begin
                            FOrders.Add(TOrder.Create);

                            if jv.TryGetValue('id', sValor) then
                              FOrders.Last.Id := sValor;

                            // Em cada requisição POST request você vai receber o parâmetro signature na querystring (na URL).
                            // Você pode utilizar esse parâmetro para verificar a requisição, basta usar o token do seu webhook
                            jS := TJSONObject.ParseJSONValue(j1.Values['query'].ToJSON) as TJSONObject;
                            if (jS<>nil) and (j5.Count>0) then
                             if jS.TryGetValue('signature', sValor) then
                               FSignature := sValor;
                            FOrders.Last.Signature := FSignature;

                            {jSg := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(j1.Values['body'].ToJSON),0) as TJSONObject;
                            sSignature := THashSHA1.GetHMAC(jSg.ToJSON, sToken);
                            if FSignature<>sSignature then
                            begin
                              FMsgErro := 'Incorrect signature';
                              Break;
                            end;}

                            if j3.TryGetValue('CPF', sValor) then
                              FCpfCnpj := sValor
                            else
                            if j3.TryGetValue('CNPJ', sValor) then
                              FCpfCnpj := sValor;
                            FOrders.Last.CpfCnpj := FCpfCnpj;

                            //"order_id": "a07231fd-820f-4ca9-89de-9ab018d598af"
                            if j2.TryGetValue('order_id', sValor) then
                              FOrderId := sValor;
                            FOrders.Last.OrderId := FOrderId;

                            // Se estiver recebendo o evento de Boleto gerado, o valor será billet_created
                            // Se estiver recebendo o evento de Pix gerado, o valor será pix_created
                            // Se estiver recebendo o evento de Compra recusada, o valor será order_rejected
                            // Se estiver recebendo o evento de Compra aprovada, este terá valor order_approved
                            // Se estiver recebendo o evento de Reembolso, o valor será order_refunded
                            // Se estiver recebendo o evento de Chargeback, o valor será chargeback
                            // Se estiver recebendo o evento de Assinatura cancelada, o valor será subscription_canceled
                            // Se estiver recebendo o evento de Assinatura atrasada, o valor será subscription_late
                            // Se estiver recebendo o evento de Assinatura renovada, este terá valor subscription_renewed
                            if j2.TryGetValue('webhook_event_type', sValor) then
                              FEventType := sValor;
                            FOrders.Last.EventType := FEventType;

                            // Status de pagamento
                            // paid - Pagamento aprovado
                            // waiting_payment - Boleto e pix aguardando pagamento
                            // refused - Pagamento recusado
                            // refunded - Reembolsado
                            // chargeback - Chargeback
                            if j2.TryGetValue('order_status', sValor) then
                              FOrderStatus := sValor;
                            FOrders.Last.OrderStatus := FOrderStatus;

                            //"created_at": "2024-08-05 21:53"
                            if j2.TryGetValue('created_at', sValor) then
                              FCreatedAt := sValor;
                            FOrders.Last.CreatedAt := FCreatedAt;

                            //"updated_at": "2024-08-05 22:35"
                            if j2.TryGetValue('updated_at', sValor) then
                              FUpdatedAt := sValor;
                            FOrders.Last.UpdatedAt := FUpdatedAt;

                            //"approved_date": "2024-07-30 18:28"
                            //if FEventType = 'order_approved' then
                            if j2.TryGetValue('approved_date', sValor) then
                              FApprovedDate := sValor;
                            FOrders.Last.ApprovedDate := FApprovedDate;

                            // "refunded_at": "2024-07-26 23:29"
                            if FEventType = 'order_refunded' then
                              if j2.TryGetValue('refunded_at', sValor) then
                                FRefundedAt := sValor;
                            FOrders.Last.RefundedAt := FRefundedAt;

                            //"Subscription": {}
                            j4 := TJSONObject.ParseJSONValue(j2.Values['Subscription'].ToJSON) as TJSONObject;

                            if (j4<>nil) and (j4.Count>0) then
                            begin
                              //"status": "active" / "canceled"
                              if j4.TryGetValue('status', sValor) then
                                FStatus := sValor;
                              FOrders.Last.Status := FStatus;

                              //"plan": {}
                              j5 := TJSONObject.ParseJSONValue(j4.Values['plan'].ToJSON) as TJSONObject;

                              if (j5<>nil) and (j5.Count>0) then
                              begin
                                //"name": "Gold" / "Premium" / "Fiscal" / etc..
                                if j5.TryGetValue('name', sValor) then
                                  FName := sValor;
                                FOrders.Last.Name := FName;

                                //"frequency": "monthly" (Mensal) / "quarterly" (Trimestral) / "semi-annually" (Semestral) / "annually" (Anual)
                                if j5.TryGetValue('frequency', sValor) then
                                  FFrequency := sValor;
                                FOrders.Last.Frequency := FFrequency;
                              end;
                            end;
                          end;
                        end;
                      end;
                    end;
                  end;
                finally
                  FreeAndNil(j1);
                  FreeAndNil(jS);
                  FreeAndNil(jSg);
                  FreeAndNil(j2);
                  FreeAndNil(j3);
                  FreeAndNil(j4);
                  FreeAndNil(j5);
                end;
              end;
            end;

            Result := (FOrders.Count>0)
          end;
        end;
      end
      else begin
        FCodigo := FRESTReq.Response.StatusCode;
        FMotivo := FRESTReq.Response.StatusText;
        FMsgErro := IntToStr(FRESTReq.Response.StatusCode) + '-' + FRESTReq.Response.StatusText+#13+FRESTReq.Response.ErrorMessage;
      end;
    except
      on E: Exception do
      begin
        FMsgErro := E.Message;

        if trim(FRESTReq.Response.ErrorMessage)<>'' then
        begin
          FCodigo := FRESTReq.Response.StatusCode;
          FMotivo := FRESTReq.Response.StatusText;
          FMsgErro := FMsgErro+#13+FRESTReq.Response.Content+#13+FRESTReq.Response.ErrorMessage;
        end;
      end;
    end;
  finally
    FreeAndNil(j);
  end;
end;

end.

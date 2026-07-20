
// Documentação da API de licenciamento (Swagger)
// https://planos.pdvkawwhite.com.br/api

unit LicencaAPI;

interface

uses
  System.SysUtils, System.Types, System.Classes,
  System.DateUtils, System.JSON, System.Hash, REST.Json.Types, REST.Json,
  System.Generics.Collections, REST.Types, REST.Client, REST.Authenticator.OAuth,
  System.Net.HttpClient;

type
  TTimeToExpires = class
    private
      FQuantity: Integer;
    public
      constructor Create;
      destructor Destroy;

      procedure Limpar;

      property Quantity: Integer read FQuantity write FQuantity;
  end;

  TPlan = class
    private
     FId: String;
     FPlanName: String;
     FExternalId: String;
     FExpires: TTimeToExpires;
     FLicensesCount: Integer;
    public
      constructor Create;
      destructor Destroy;

      procedure Limpar;

      property Id: String read FId write FId;
      property PlanName: String read FPlanName write FPlanName;
      property ExternalId: String read FExternalId write FExternalId;
      property Expires: TTimeToExpires read FExpires write FExpires;
      property LicensesCount: Integer read FLicensesCount write FLicensesCount;
  end;

  TLicencaRest = class
    private
      FUrl: String;
      FAccept: String;
      FAcceptEncoding: String;
      FAcceptCharset: String;
      FContentType: String;
      FProxyHost: String;
      FProxyPorta: Integer;
      FProxyUser: String;
      FProxySenha: String;
      FTentativas: Integer;
      FIntervaloTentativas: Integer;
      FHash: String;
      FUserHash: String;
      FSubscriptionId: String;
      FExpiresAt: String;
      FStatusCode: Integer;
      FStatusText: String;
      FResponseContent: String;
      FErrorMessage: String;
      FTimeout: Integer;
      FDebug: Boolean;
      FJson: String;
      FREST: TRESTClient;
      FRESTReq: TRESTRequest;
      //FOAuth2: TOAuth2Authenticator;
      FPlan: TPlan;
    public
     constructor Create;
     destructor Destroy;

     function Configurar: Boolean;
     procedure Limpar;

     function ValidateLicense(MacAddress: String; Email: String; CpfCnpj: String; DeviceName: String; IsServer: Boolean): Boolean;

     property Url: String read FUrl write FUrl;
     property Accept: String read FAccept write FAccept;
     property ContentType: String read FContentType write FContentType;
     property ProxyHost: String read FProxyHost write FProxyHost;
     property ProxyPorta: Integer read FProxyPorta write FProxyPorta;
     property ProxyUser: String read FProxyUser write FProxyUser;
     property ProxySenha: String read FProxySenha write FProxySenha;
     property Tentativas: Integer read FTentativas write FTentativas;
     property IntervaloTentativas: Integer read FIntervaloTentativas write FIntervaloTentativas;
     property Timeout: Integer read FTimeout write FTimeout;
     property Hash: String read FHash write FHash;
     property UserHash: String read FUserHash write FUserHash;
     property SubscriptionId: String read FSubscriptionId write FSubscriptionId;
     property ExpiresAt: String read FExpiresAt write FExpiresAt;
     property Plan: TPlan read FPlan write FPlan;
     property StatusCode: Integer read FStatusCode write FStatusCode;
     property StatusText: String read FStatusText write FStatusText;
     property ResponseContent: String read FResponseContent write FResponseContent;
     property ErrorMessage: String read FErrorMessage write FErrorMessage;
     property Json: String read FJson;
     property Debug: Boolean read FDebug write FDebug;
  end;

implementation

// -----------------------------------------------------------------------------
{ TTimeToExpires }
// -----------------------------------------------------------------------------
constructor TTimeToExpires.Create;
begin
  Limpar;
end;

destructor TTimeToExpires.Destroy;
begin

end;

procedure TTimeToExpires.Limpar;
begin
  FQuantity := 0;
end;

// -----------------------------------------------------------------------------
{ TPlan }
// -----------------------------------------------------------------------------
constructor TPlan.Create;
begin
  Limpar;
  FExpires := TTimeToExpires.Create;
end;

destructor TPlan.Destroy;
begin
  FExpires.Free;
end;

procedure TPlan.Limpar;
begin
  FId := '';
  FPlanName := '';
  FExternalId := '';
  FLicensesCount := 0;
end;

// -----------------------------------------------------------------------------
{ TLicencaRest }
// -----------------------------------------------------------------------------
constructor TLicencaRest.Create;
begin
  try
    FContentType := 'application/json';
    FAccept := 'application/json';
    FAcceptCharset := 'utf-8';
    //FAccessTokenEndpoint := '/oauth/token';
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

    //FOAuth2 := TOAuth2Authenticator.Create(nil);

    FRESTReq := TRESTRequest.Create(nil);
    FRESTReq.Client := FREST;
    FRESTReq.Accept := FREST.Accept;
    FRESTReq.HandleRedirects := True;
    FRESTReq.Timeout := FTimeout;

    FPlan := TPlan.Create;
  except
    on E: Exception do
    begin
      FErrorMessage := E.ClassName + ' ' + E.Message;
      //GravarLog(FErrorMessage);
    end;
  end;
end;

destructor TLicencaRest.Destroy;
begin
  try
    FreeAndNil(FREST);
    FreeAndNil(FRESTReq);
    //FreeAndNil(FOAuth2);
    FPlan.Free;
  except
    on E: Exception do
    begin
      FErrorMessage := E.ClassName + ' ' + E.Message;
      //GravarLog(FErrorMessage);
    end;
  end;
end;

function TLicencaRest.Configurar: Boolean;
begin
  Result := False;

  try
    FREST.ResetToDefaults;
    FREST.BaseURL := FUrl;
    FREST.ContentType := 'application/json';//FContentType;
    FREST.Accept := 'application/json';//FAccept;
    //FREST.Accept := FAccept;
    FREST.AcceptCharset := 'utf-8';
    //FREST.AcceptCharset := FAcceptCharset;
    FREST.FallbackCharsetEncoding := 'utf-8';
    FREST.HandleRedirects := True;

    // Error 12175
    FREST.SecureProtocols := [THTTPSecureProtocol.TLS12];

    FRESTReq.Params.Clear;

    FRESTReq.Accept := FREST.Accept;
    FRESTReq.AcceptEncoding := FREST.AcceptEncoding;
    FRESTReq.AcceptCharset := FREST.AcceptCharset;

    if FTimeout>0 then
    begin
      FRESTReq.Timeout := FTimeout;
    end;

    //todo: Autenticação
    {FOAuth2.ClientID := FClientId;
    FOAuth2.ClientSecret := FClientSecret;
    FOAuth2.TokenType := TOAuth2TokenType.ttBEARER;
    FOAuth2.AccessToken := FAccessToken;
    FOAuth2.AccessTokenEndpoint := FUrl+FAccessTokenEndpoint;
    FOAuth2.ResponseType := TOAuth2ResponseType.rtTOKEN;}

    //FREST.Authenticator := FOAuth2;

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
      FErrorMessage := E.ClassName + ' ' + E.Message;
      //GravarLog(FErrorMessage);
    end;
  end;
end;

procedure TLicencaRest.Limpar;
begin
  FHash := '';
  FUserHash := '';
  FSubscriptionId := '';
  FExpiresAt := '';
  FStatusCode := 0;
  FStatusText := '';
  FResponseContent := '';
  FErrorMessage := '';
  FJson := '';
end;

function TLicencaRest.ValidateLicense(MacAddress: String; Email: String; CpfCnpj: String; DeviceName: String; IsServer: Boolean): Boolean;
var
  j, j1, j2, j3: TJSONObject;
  sValor: String;
begin
  Result := False;
  Limpar;
  FPlan.Limpar;

  j := TJSONObject.Create;
  j1 := TJSONObject.Create;
  j2 := TJSONObject.Create;
  j3 := TJSONObject.Create;
  try
    try
      FREST.ContentType := 'application/json';
      FREST.Accept := 'application/json';
      FRESTReq.Method := TRESTRequestMethod.rmPOST;
      FRESTReq.Resource := '/api/licensing/validate-pdv-licensing';
      FRESTReq.ClearBody;
      FRESTReq.Params.Clear;

      j.AddPair(TJSONPair.Create('macAddress', TJSONString.Create(MacAddress)));
      j.AddPair(TJSONPair.Create('email', TJSONString.Create(Email)));
      j.AddPair(TJSONPair.Create('cnpj', TJSONString.Create(CpfCnpj)));
      j.AddPair(TJSONPair.Create('deviceName', TJSONString.Create(DeviceName)));
      j.AddPair(TJSONPair.Create('isServer', TJSONBool.Create(IsServer)));
      //j.AddPair(TJSONPair.Create('isServer', TJSONBool.Create(false))); // TESTE

      if (FDebug) and (j<>nil) then
        FJson := j.ToString;

      FRESTReq.Params.AddItem('body', j.ToString, TRESTRequestParameterKind.pkREQUESTBODY,[], ctAPPLICATION_JSON);
      FRESTReq.Execute;

      if FRESTReq.Response.StatusCode = 201 then // License validation successful
      begin
        if (FDebug) then
          FResponseContent := FRESTReq.Response.Content;

        if CompareText(FRESTReq.Response.ContentType, 'application/json') = 0 then
        begin
          j1 := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(FRESTReq.Response.JSONValue.ToString), 0) as TJSONObject;
          if (j1<>nil) and (j1.Count>0) then
          begin
            if j1.FindValue('hash') <> nil then
            begin
             if j1.TryGetValue('hash', sValor) then
               FHash := sValor;
            end;

            if j1.FindValue('userHash') <> nil then
            begin
             if j1.TryGetValue('userHash', sValor) then
               FUserHash := sValor;
            end;

            if j1.FindValue('subscriptionId') <> nil then
            begin
             if j1.TryGetValue('subscriptionId', sValor) then
               FSubscriptionId := sValor;
            end;

            if j1.FindValue('expiresAt') <> nil then
            begin
             if j1.TryGetValue('expiresAt', sValor) then
               FExpiresAt := sValor;
            end;

            if j1.FindValue('plan') <> nil then
            begin
              j2 := TJSONObject.ParseJSONValue(j1.Values['plan'].ToString) as TJSONObject;
              if (j2<>nil) and (j2.Count>0) then
              begin
                if j2.FindValue('planName') <> nil then
                begin
                 if j2.TryGetValue('planName', sValor) then
                   FPlan.PlanName := sValor;
                end;

                if j2.FindValue('id') <> nil then
                begin
                 if j2.TryGetValue('id', sValor) then
                   FPlan.Id := sValor;
                end;

                if j2.FindValue('externalId') <> nil then
                begin
                 if j2.TryGetValue('externalId', sValor) then
                   FPlan.ExternalId := sValor;
                end;

                if j2.FindValue('licensesCount') <> nil then
                begin
                 if j2.TryGetValue('licensesCount', sValor) then
                   FPlan.LicensesCount := StrToIntDef(sValor, 0);
                end;

                j3 := TJSONObject.ParseJSONValue(j2.Values['timeToExpires'].ToString) as TJSONObject;
                if (j3<>nil) and (j3.Count>0) then
                begin
                  if j3.FindValue('quantity') <> nil then
                  begin
                   if j3.TryGetValue('quantity', sValor) then
                     FPlan.Expires.Quantity := StrToIntDef(sValor, 0);
                  end;
                end;
              end;
            end;

            Result := True;
          end;
        end;
      end
      else begin
        Result := False;

        if (FDebug) then
          FResponseContent := FRESTReq.Response.Content;

        (*Status HTTP: 422 Unprocessable Entity
        Mensagem:  "No available licenses to assign the MAC address"
        Status HTTP: 400 Bad Request
        Mensagem: "Email and MAC address are required"
        Status HTTP: 404 Not Found
        Mensagem: "Client not found" ou "No licenses found for the customer"
        Status HTTP: 401 Unauthorized
        Mensagem: "License is not active"*)

        if CompareText(FRESTReq.Response.ContentType, 'application/json') = 0 then
        begin
          j1 := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(FRESTReq.Response.JSONValue.ToString), 0) as TJSONObject;
          if (j1<>nil) and (j1.Count>0) then
          begin
            if j1.FindValue('statusCode') <> nil then
            begin
             if j1.TryGetValue('statusCode', sValor) then
               FStatusCode := StrToIntDef(sValor, 0);
            end;

            if j1.FindValue('message') <> nil then
            begin
              if j1.TryGetValue('message', sValor) then
                FStatusText := sValor;
            end;
          end;
        end
        else begin
          FStatusCode := FRESTReq.Response.StatusCode;
          FStatusText := FRESTReq.Response.StatusText;

          if (FDebug) then
            FResponseContent := FRESTReq.Response.Content;
        end;
      end;
    except
      on E: Exception do
      begin
        Result := False;
        FStatusCode := FRESTReq.Response.StatusCode;
        FStatusText := FRESTReq.Response.StatusText;
        FErrorMessage := FRESTReq.Response.ErrorMessage;
        FErrorMessage := FErrorMessage + #13+#10 + E.ClassName + ' ' + E.Message;
        //GravarLog(FErrorMessage);

        if (FDebug) then
          FResponseContent := FRESTReq.Response.Content;
      end;
    end;
  finally
    FreeAndNil(j);
    FreeAndNil(j1);
    FreeAndNil(j2);
    FreeAndNil(j3);
  end;
end;

end.

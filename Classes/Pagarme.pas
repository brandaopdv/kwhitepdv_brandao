
// Documentação

unit Pagarme;

interface

uses
  System.SysUtils, System.Types, System.Classes,
  System.DateUtils, System.JSON, System.Hash, REST.Json.Types, REST.Json,
  System.Generics.Collections, REST.Types, REST.Client,
  REST.Authenticator.OAuth, System.Net.HttpClient;

type
  TPagarmeRest = class
    private

    public
     constructor Create;
     destructor Destroy;
  end;

implementation

{ TPagarmeRest }

constructor TPagarmeRest.Create;
begin

end;

destructor TPagarmeRest.Destroy;
begin

end;

end.

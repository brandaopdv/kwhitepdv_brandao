unit uFileUploadXML;

interface

uses System.Net.HttpClient, System.Net.Mime, System.JSON, log;

function UploadXML(Url, Key, Arquivo: String; var Error: String): Boolean;

implementation

uses
  System.SysUtils, System.Classes;

function UploadXML(Url, Key, Arquivo: String; var Error: String): Boolean;
var
  LRequest: THTTPClient;
  LFormData: TMultipartFormData;
  LResponse: TStringStream;
  vRetJson: TJsonObject;
  vRetJsonAux: TJSONValue;
  vResult: string;
begin
  Result := false;
  LRequest := THTTPClient.Create;
  LFormData := TMultipartFormData.Create();
  LResponse := TStringStream.Create;
  try
    try
      LFormData.AddField('key', Key);
      LFormData.AddFile('file', Arquivo);
      LRequest.Post(Url, LFormData, LResponse);
      vResult := LResponse.DataString;
      vRetJsonAux := TJsonObject.ParseJSONValue(vResult);
      if vRetJsonAux <> nil then
      begin
        vRetJson := vRetJsonAux as TJsonObject;
        if vRetJson.Get('msg') <> nil then
        begin
          if vRetJson.GetValue('msg').Value = '100' then
          begin
            Result := true;
          end;
        end
        else
        begin
          TLog.GetInstance.ERRO('UploadXML', vRetJson.ToJSON);
        end;
      end
      else begin
        TLog.GetInstance.ERRO('UploadXML', vResult);
      end;
    except
      on E: Exception do
      begin
        Error := e.ToString;
        TLog.GetInstance.ERRO('UploadXML', e.ToString);
      end;
    end;
  finally
    LFormData.Free;
    LResponse.Free;
    LRequest.Free;
  end;
end;

end.

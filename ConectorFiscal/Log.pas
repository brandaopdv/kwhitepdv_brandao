unit Log;

interface

uses Diretory, system.SysUtils, system.Classes;

// type
// TEnviarLog = class(TThread)
// procedure execute; override;
//
// end;

type
  TLog = class
  strict private
    class var FInstance: TLog;
    constructor create;
    procedure MakeFile;
    function getHorario: string;

  var
    Filename: string;
    arq: TextFile;

  public
    class function GetInstance(): TLog;
    procedure INFO(Classe, messagem: string);
    procedure ERRO(Classe, messagem: string);
    procedure debug(Classe, messagem: string);
  end;

implementation

{ TLog }

procedure Removerlog(xFolder: string);
var
  sr: TSearchRec;
  searchResult, contador, I: integer;
begin
  contador := 0;
  searchResult := FindFirst(xFolder + '/*.txt', faAnyFile, sr);
  while searchResult = 0 do
  begin
    if sr.Name[1] <> '.' then
    begin
      contador := contador + 1;
    end;
    searchResult := FindNext(sr);
  end;
  FindClose(sr);

  searchResult := FindFirst(xFolder + '/*.txt', faAnyFile, sr);
  for I := 0 to contador - 30 do
  begin
    if searchResult = 0 then
    begin
      DeleteFile(xFolder + '/' + sr.Name);
    end;
    searchResult := FindNext(sr);
  end;
  FindClose(sr);
end;

constructor TLog.create;
begin
  Filename := FormatDateTime('ddmmyyyyhhnnss', now()) + '.txt';
  Removerlog(TDiretory.GetInstance.getLOCALLOG)
end;

procedure TLog.debug(Classe, messagem: string);
begin
  try
    try
      AssignFile(arq, TDiretory.GetInstance.getLOCALLOG + Filename);
      MakeFile;
      Writeln(arq, getHorario + '-' + 'DEBUG-Class: ' + Classe + '-mensagem: ' +
        messagem);
    finally
      CloseFile(arq);
    end;
  except

  end;
end;

procedure TLog.ERRO(Classe, messagem: string);
begin
  try
    try
      AssignFile(arq, TDiretory.GetInstance.getLOCALLOG + Filename);
      MakeFile;
      Writeln(arq, getHorario + '-' + 'ERRO-Class: ' + Classe + '-mensagem: ' +
        messagem);
    finally
      CloseFile(arq);
    end;
  except

  end;
end;

function TLog.getHorario: string;
begin
  Result := FormatDateTime('dd/mm/yyyy hh:nn:ss', now());
end;

class function TLog.GetInstance: TLog;
begin
  if not Assigned(Self.FInstance) then
    Self.FInstance := TLog.create;
  Result := Self.FInstance;

end;

procedure TLog.INFO(Classe, messagem: string);
begin
  try
    try
      AssignFile(arq, TDiretory.GetInstance.getLOCALLOG + Filename);
      MakeFile;
      Writeln(arq, getHorario + '-' + 'INFO-Class: ' + Classe + '-mensagem: ' +
        messagem);
    finally
      CloseFile(arq);
    end;
  except

  end;
end;

procedure TLog.MakeFile;
begin
  if not FileExists(TDiretory.GetInstance.getLOCALLOG + Filename) then
  begin
    Rewrite(arq);
  end
  else
  begin
    Append(arq);
  end;
end;

{ TEnviarLog }

end.

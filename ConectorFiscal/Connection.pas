unit Connection;

interface

uses FireDAC.Comp.Client, FireDAC.Stan.def, FireDAC.DApt, FireDAC.VCLUI.Wait,
  FireDAC.UI.Intf, FireDAC.Phys.SQLite, FireDAC.Stan.Intf, FireDAC.Comp.UI,
  FireDAC.Phys, FireDAC.Phys.SQLiteDef, Data.DB, FireDAC.Stan.Async;

type
  TConnection = class(TObject)
  public
    DataSouce: TDataSource;
    Query: TFDQuery;
    procedure Disponse;
    procedure Commit;
    constructor Create(hasTransaction: boolean;
      const DataSource: boolean = false);
    procedure RoolbBack;

    class var DriverID, Server, Port, Database, User_Name, Password: string;
  private
    hasTransaction, DataSource: boolean;
    FDConnection: TFDConnection;
    Transaction: TFDTransaction;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDPhysMySQLDriverLink1: TFDPhysSQLiteDriverLink;

  end;

implementation

{ TConection }

procedure TConnection.Commit;
begin
  if hasTransaction then
    Transaction.Commit;
end;

constructor TConnection.Create(hasTransaction: boolean;
  const DataSource: boolean = false);
begin
  FDGUIxWaitCursor1 := TFDGUIxWaitCursor.Create(nil);
  FDPhysMySQLDriverLink1 := TFDPhysSQLiteDriverLink.Create(nil);
  self.hasTransaction := hasTransaction;
  self.DataSource := DataSource;
  FDConnection := TFDConnection.Create(nil);

  FDConnection.Params.Clear;

  FDConnection.Params.Add('DriverID=' + DriverID);
  FDConnection.Params.Add('Server=' + Server);
  FDConnection.Params.Add('Port=' + Port);
  FDConnection.Params.Add('Database=' + Database);
  FDConnection.Params.Add('CharacterSet=utf8');
  FDConnection.Params.Add('User_Name=' + User_Name);
  FDConnection.Params.Add('Password=' + Password);

  FDConnection.LoginPrompt := false;
  Query := TFDQuery.Create(nil);
  Query.Connection := self.FDConnection;
  if DataSource then
  begin
    DataSouce := TDataSource.Create(nil);
    DataSouce.DataSet := Query;
  end;

  if hasTransaction then
  begin
    Transaction := TFDTransaction.Create(nil);
    FDConnection.TxOptions.AutoCommit := false;
    Transaction.Connection := FDConnection;
    Query.Transaction := Transaction;
    Transaction.StartTransaction;
  end;
  FDConnection.Open();

end;

procedure TConnection.Disponse;
begin
  if hasTransaction then
  begin
    Transaction.DisposeOf;
  end;
  Query.Close;
  Query.DisposeOf;
  FDConnection.Close;
  FDConnection.DisposeOf;
  if DataSource then
  begin
    DataSouce.DisposeOf;
  end;
end;

procedure TConnection.RoolbBack;
begin
  if hasTransaction then
  begin
    Query.Close;
    Transaction.Rollback;
  end;
end;

end.

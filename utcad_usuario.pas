unit utcad_usuario;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, uTBaseDados, uT_Constante, db, variants, uTSys_GetGlobalsVars;

type

  { TCad_Usuario }
  TView_Usuario = class(TBaseView)
   private
     FUser : String;
     FPass : String;
   public
     property User : String read Fuser Write FUser;
     property Pass : String read FPass write FPass;

  end;

  TCad_Usuario = class(TBaseBusiness)
  private
    FView : TView_Usuario;
    Procedure GetSQLInsert;
    Procedure GetSQLUpdate;
  public
    procedure Inserir ; override;
    procedure Editar  ; override;
    procedure Excluir ; override;

    procedure Gravar  ; override;
    procedure SendToDb; override;
    procedure Cancelar; override;


    procedure LoadFromDb(pID : Integer); override;
    procedure LimparEntidade; override;

    property View : TView_Usuario read FView write FView;
    constructor Create;
    destructor Destroy;
  end;

implementation
uses BPF_Geral;

{ TCad_Usuario }


procedure TCad_Usuario.GetSQLInsert;
begin
  FView.SQL_Insert:= 'INSERT INTO SYS_USUARIO (ID,LOGIN,SENHA)'
                     +#13+' VALUES ( '
                     +#13+ '' + IntToStr (FView.ID) + ','
                     +#13+ '' + QuotedStr(FView.FUser) + ','
                     +#13+ '' + QuotedStr(FView.FPass) + ');';
end;

procedure TCad_Usuario.GetSQLUpdate;
begin
  FView.SQL_Update:=  'UPDATE SYS_USUARIO SET LOGIN = ' +QuotedStr(FView.FUser) + ','
                 +#13+'SENHA = ' + QuotedStr(FView.Pass) + ' where id = ' + IntToStr(FView.ID) +';';
end;

procedure TCad_Usuario.Inserir;
begin
  inherited Inserir;

  LimparEntidade;

  FView.State:= TObSt_Inserting;

  FView.ID:= TBaseDados.GetNextID(FView.Generator);
end;

procedure TCad_Usuario.Editar;
begin
  inherited Editar;

   FView.State:= TObSt_Editing;
end;

procedure TCad_Usuario.Excluir;
begin
  FView.SQL_Delete:= 'DELETE FROM SYS_USUARIO WHERE ID = ' + IntToStr(FView.ID);
  GLog.SetLog(FView);
  TBaseDados.ExecQuery(FView.SQL_Delete);
end;

procedure TCad_Usuario.Gravar;
var vLogin : Variant;
    vSenha : variant;
    vSenhaMD5 : variant;
begin
  vLogin := Null;
  vLogin := TBaseDados.GetLookup(FView.User,'LOGIN','SYS_USUARIO','ID');

  if(Length(FView.FPass) < cMinLengthPass)
    then raise TExceptionClass.Create('A senha deve possuir pelo menos ' + IntToStr(cMinLengthPass) +' Digitos');

   if (Not (VarIsNull(vLogin)) And (FView.State = TObSt_Inserting))
       then raise TExceptionValidacao.Create('Usuário já cadastrado!');

  vSenha    := TBaseDados.GetLookup(FView.User,'LOGIN','SYS_USUARIO','SENHA');
  vSenhaMD5 := TPF_Security.MD5(FView.Pass+FView.User);

  // indica que o usuáro alterou a senha!!
  if (vSenha <> vSenhaMD5)
  then FView.Pass := TPF_Security.MD5(FView.Pass+FView.User);

  case FView.State of
       TObSt_Inserting : GetSQLInsert;
       TObSt_Editing   : GetSQLUpdate;
   else raise TExceptionValidacao.Create(ErroFViewState);
  end;

end;

procedure TCad_Usuario.SendToDb;
begin
  inherited SendToDb;

  try
    case FView.State of
         TObSt_Inserting :
          begin
             GLog.SetLog(FView);
             TBaseDados.ExecQuery(FView.SQL_Insert);
          end;
         TObSt_Editing   :
          begin
            GLog.SetLog(FView);
            TBaseDados.ExecQuery(FView.SQL_Update);
          end
       else raise TExceptionValidacao.Create(ErroFViewState + ' SendToDb ');
    end;

  finally
    FView.State:= TObSt_Browse;
  end;
end;

procedure TCad_Usuario.Cancelar;
begin
  inherited Cancelar;

  FView.State:= TObSt_Browse;
  LimparEntidade;

end;

procedure TCad_Usuario.LoadFromDb(pID: Integer);
begin
TRY
  Query := TBaseDados.GetNewAbsQuery;
  Query.SQL.Clear;
  Query.SQL.Text:= 'SELECT * FROM SYS_USUARIO WHERE ID = ' + IntToStr(pID);
  Query.Open;

  with FView, Query do
  begin
    ID := FieldByName('ID').AsInteger;
    User:= FieldByName('LOGIN').AsString;
    Pass:= FieldByName('SENHA').AsString;
  end;

  Query.Close;
FINALLY
  FreeAndNil(QUERY);
END;
end;

procedure TCad_Usuario.LimparEntidade;
begin
  inherited LimparEntidade;

  FView.ID:= 0;
  FView.User:= '';
  FView.Pass:= '';
end;

constructor TCad_Usuario.Create;
begin
  FView := TView_Usuario.Create(nil);
  FView.Generator:= 'GEN_SYS_USUARIO';
  FView.TableName:= 'SYS_USUARIO';
end;

destructor TCad_Usuario.Destroy;
begin
  FreeAndNil(FView);
end;


end.


unit uTCad_Unidade;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, uTBaseDados, uT_Constante, sqldb, bPF_Geral;

type

  { TCad_Unidade }

  TView_Unidade = class(TBaseView)
    public
      DESCRICAO : String;
      SIGLA : String;
    end;

  TCad_Unidade = class(TBaseBusiness)
    private
      FView : TView_Unidade;
      procedure GetSQLInsert;
      procedure GetSQLUpdate;

    public
      procedure Inserir;
      procedure Editar;
      procedure Excluir;

      procedure Gravar;
      procedure SendToDb;
      procedure Cancelar;

      procedure LoadFromDb(pID : Integer);
      procedure LimparEntidade;
      constructor Create;
      property View : TView_Unidade read FView write FView;
  end;

implementation

{ TCad_Unidade }

procedure TCad_Unidade.GetSQLInsert;
begin
  FView.SQL_Insert:= 'INSERT INTO PRODUTO_UNIDADE (ID, DESCRICAO, SIGLA)'
                     +' VALUES ('+IntToStr(FView.ID)+','+QuotedStr(FView.DESCRICAO)+','+QuotedStr(FView.SIGLA)+');';
end;

procedure TCad_Unidade.GetSQLUpdate;
begin
  FView.SQL_Update:= 'UPDATE PRODUTO_UNIDADE SET DESCRICAO='+QuotedStr(FView.DESCRICAO)
                     +',SIGLA ='+QuotedStr(FView.SIGLA)
                     +' WHERE ID ='+IntToStr(FView.ID);
end;

procedure TCad_Unidade.Inserir;
begin
  LimparEntidade;
  FView.State:= TObSt_Inserting;
  FView.ID:= TBaseDados.GetNextID(FView.Generator);
end;

procedure TCad_Unidade.Editar;
begin
  Fview.State:=TObSt_Editing;
end;

procedure TCad_Unidade.Excluir;
begin
  FView.SQL_Delete:= 'DELETE FROM PRODUTO_UNIDADE WHERE ID ='+IntToStr(FView.ID);
  TBaseDados.ExecQuery(View.SQL_Delete);
end;

procedure TCad_Unidade.Gravar;
begin
   case FView.State of
     TObSt_Inserting : GetSQLInsert;
     TObSt_Editing : GetSQLUpdate;
   end;
end;

procedure TCad_Unidade.SendToDb;
begin
  try
   case FView.State of

     TObSt_Inserting: TBaseDados.ExecQuery(Fview.SQL_Insert);
     TObSt_Editing: TBaseDados.ExecQuery(FView.SQL_Update);
   else
     raise TExceptionValidacao.Create(ErroFViewState);
   end;
  finally
    Fview.State:= TObSt_Browse;
  end;
end;

procedure TCad_Unidade.Cancelar;
begin
  FView.State:= TObSt_Browse;
  LimparEntidade;
end;

procedure TCad_Unidade.LoadFromDb(pID: Integer);
begin
  Query := TBaseDados.GetNewAbsQuery;
  Query.SQL.Clear;
  Query.SQL.Text:= 'select * from produto_unidade where id = :id';
  Query.ParamByName('id').Value:= pID;
  Try
    Query.Open;
    with FView, Query do
    begin
      id := FieldByName('id').AsInteger;
      DESCRICAO:= FieldByName('descricao').AsString;
      SIGLA:=FieldByName('sigla').AsString;
    end;
  finally
    Query.Close;
    FreeAndNil(Query);
  end;
end;

procedure TCad_Unidade.LimparEntidade;
begin
  FView.ID:= 0;
  FView.DESCRICAO:= '';
  FView.SIGLA:= '';
end;

constructor TCad_Unidade.Create;
begin
  inherited Create;
  FView := TView_Unidade.Create(nil);
  FView.Generator:= 'gen_produto_unidade';
end;

end.


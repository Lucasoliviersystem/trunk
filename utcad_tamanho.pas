unit utcad_tamanho;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, uTBaseDados, uT_Constante, sqldb, bPF_Geral;

type

  { TCad_Tamanho }

  TView_Tamanho = class(TBaseView)
    public
      DESCRICAO : String;
  end;

  TCad_Tamanho = class(TBaseBusiness)
    private
      FView : TView_Tamanho;
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
      property View : TView_Tamanho read FView write FView;
  end;

implementation

{ TCad_Tamanho }

procedure TCad_Tamanho.GetSQLInsert;
begin
  FView.SQL_Insert:= 'INSERT INTO PRODUTO_TAMANHO (ID, DESCRICAO)'
                     +' VALUES ('+IntToStr(FView.ID)+','+QuotedStr(FView.DESCRICAO)+');';
end;

procedure TCad_Tamanho.GetSQLUpdate;
begin
  FView.SQL_Update:= 'UPDATE PRODUTO_TAMANHO SET DESCRICAO ='+QuotedStr(FView.DESCRICAO)
                     +' WHERE ID ='+IntToStr(FView.ID);
end;

procedure TCad_Tamanho.Inserir;
begin
  LimparEntidade;
  FView.State:= TObSt_Inserting;
  FView.ID:= TBaseDados.GetNextID(FView.Generator);
end;

procedure TCad_Tamanho.Editar;
begin
  Fview.State:=TObSt_Editing;
end;

procedure TCad_Tamanho.Excluir;
begin
  FView.SQL_Delete:= 'DELETE FROM PRODUTO_TAMANHO WHERE ID ='+IntToStr(FView.ID);
  TBaseDados.ExecQuery(View.SQL_Delete);
end;

procedure TCad_Tamanho.Gravar;
begin
   case FView.State of
     TObSt_Inserting : GetSQLInsert;
     TObSt_Editing : GetSQLUpdate;
   end;
end;

procedure TCad_Tamanho.SendToDb;
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

procedure TCad_Tamanho.Cancelar;
begin
  FView.State:= TObSt_Browse;
  LimparEntidade;
end;

procedure TCad_Tamanho.LoadFromDb(pID: Integer);
begin
  Query := TBaseDados.GetNewAbsQuery;
  Query.SQL.Clear;
  Query.SQL.Text:= 'select * from produto_tamanho where id = :id';
  Query.ParamByName('id').Value:= pID;
  Try
    Query.Open;
    with FView, Query do
    begin
      id := FieldByName('id').AsInteger;
      DESCRICAO:= FieldByName('descricao').AsString;
    end;
  finally
    Query.Close;
    FreeAndNil(Query);
  end;
end;

procedure TCad_Tamanho.LimparEntidade;
begin
  FView.ID:= 0;
  FView.DESCRICAO:= '';
end;

constructor TCad_Tamanho.Create;
begin
  inherited Create;
  FView := TView_Tamanho.Create(nil);
  FView.Generator:= 'gen_produto_tamanho';
end;

end.


unit utcad_cor;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, uTBaseDados, uT_Constante, sqldb, bPF_Geral;

type

  { TCad_Cor }

  TView_Cor = class(TBaseView)
    public
      DESCRICAO : String;
  end;

  TCad_Cor = class(TBaseBusiness)
    private
      FView : TView_Cor;
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
      property View : TView_Cor read FView write FView;
  end;

implementation

{ TCad_Cor }

procedure TCad_Cor.GetSQLInsert;
begin
  FView.SQL_Insert:= 'INSERT INTO PRODUTO_COR (ID, DESCRICAO)'
                     +' VALUES ('+IntToStr(FView.ID)+','+QuotedStr(FView.DESCRICAO)+');';
end;

procedure TCad_Cor.GetSQLUpdate;
begin
  FView.SQL_Update:= 'UPDATE PRODUTO_COR SET DESCRICAO ='+QuotedStr(FView.DESCRICAO)
                     +' WHERE ID ='+IntToStr(FView.ID);
end;

procedure TCad_Cor.Inserir;
begin
  LimparEntidade;
  FView.State:= TObSt_Inserting;
  FView.ID:= TBaseDados.GetNextID(FView.Generator);
end;

procedure TCad_Cor.Editar;
begin
  Fview.State:=TObSt_Editing;
end;

procedure TCad_Cor.Excluir;
begin
  FView.SQL_Delete:= 'DELETE FROM PRODUTO_COR WHERE ID ='+IntToStr(FView.ID);
  TBaseDados.ExecQuery(View.SQL_Delete);
end;

procedure TCad_Cor.Gravar;
begin
   case FView.State of
     TObSt_Inserting : GetSQLInsert;
     TObSt_Editing : GetSQLUpdate;
   end;
end;

procedure TCad_Cor.SendToDb;
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

procedure TCad_Cor.Cancelar;
begin
  FView.State:= TObSt_Browse;
  LimparEntidade;
end;

procedure TCad_Cor.LoadFromDb(pID: Integer);
begin
  Query := TBaseDados.GetNewAbsQuery;
  Query.SQL.Clear;
  Query.SQL.Text:= 'select * from produto_cor where id = :id';
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

procedure TCad_Cor.LimparEntidade;
begin
  FView.ID:= 0;
  FView.DESCRICAO:= '';
end;

constructor TCad_Cor.Create;
begin
  inherited Create;
  FView := TView_Cor.Create(nil);
  FView.Generator:= 'gen_produto_cor';
end;

end.


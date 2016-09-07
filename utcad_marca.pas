unit utcad_marca;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, uTBaseDados, uT_Constante, sqldb, bPF_Geral;

type

  { TCad_Marca }

  TView_Marca = class(TBaseView)
    public
      DESCRICAO : String;
  end;

  TCad_Marca = class(TBaseBusiness)
    private
      FView : TView_Marca;
      procedure GetSQLInsert;
      procedure GetSQLUpdate;

    public
      procedure Inserir ;
      procedure Editar  ;
      procedure Excluir ;

      procedure Gravar  ;
      procedure SendToDb;
      procedure Cancelar;

      procedure LoadFromDb(pID : Integer);
      procedure LimparEntidade;
      constructor Create;
      property View : TView_Marca read FView write FView;
  end;

implementation

{ TCad_Marca }

procedure TCad_Marca.GetSQLInsert;
begin
   FView.SQL_Insert:= 'INSERT INTO PRODUTO_MARCA (ID, DESCRICAO)'
                      +' VALUES ('+IntToStr(FView.ID)+','+QuotedStr(fview.DESCRICAO)+');';
end;

procedure TCad_Marca.GetSQLUpdate;
begin
  Fview.SQL_Update:= 'UPDATE PRODUTO_MARCA SET DESCRICAO ='+QuotedStr(FView.DESCRICAO)
                     +' WHERE ID = '+IntToStr(Fview.ID);
end;

procedure TCad_Marca.Inserir;
begin
  LimparEntidade;
  FView.State:= TObSt_Inserting;
  FView.ID:=TBaseDados.GetNextID(fview.Generator);

end;

procedure TCad_Marca.Editar;
begin
  FView.State:= TObSt_Editing;
end;

procedure TCad_Marca.Excluir;
begin
  FView.SQL_Delete:= 'DELETE FROM PRODUTO_MARCA WHERE ID = '+IntToStr(fView.ID);
  TBaseDados.ExecQuery(View.SQL_Delete);
end;

procedure TCad_Marca.Gravar;
begin
  case FView.State of

    TObSt_Inserting : GetSQLInsert;
    TObSt_Editing : GetSQLUpdate;
  end;

end;

procedure TCad_Marca.SendToDb;
begin
  try
    case FView.State of

      TObSt_Inserting: TBaseDados.ExecQuery(FView.SQL_Insert);
      TObSt_Editing: Tbasedados.ExecQuery(FView.SQL_Update);
    else
      raise TExceptionValidacao.Create(ErroFViewState);
    end;
  finally
    FView.State:=TObSt_Browse;
  end;
end;

procedure TCad_Marca.Cancelar;
begin
  FView.State:= TObSt_Browse;
  LimparEntidade;
end;

procedure TCad_Marca.LoadFromDb(pID: Integer);
begin
  Query := TBaseDados.GetNewAbsQuery;
  Query.SQL.Clear;
  Query.SQL.Text:= 'select * from produto_marca where id = :id';
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

procedure TCad_Marca.LimparEntidade;
begin
  Fview.ID:= 0;
  FView.DESCRICAO:= '';
end;

constructor TCad_Marca.Create;
begin
  inherited Create;
  FView := TView_Marca.Create(nil);
  FView.Generator:= 'gen_produto_marca';
end;

end.


unit uTCad_Produto;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, uTBaseDados, db, uT_Constante, utcad_cor, bpf_geral, utcad_marca, utcad_tamanho, uTCad_Unidade;

type

  { TCad_Produto }
  TView_Produto = class(TBaseView)
  private
     FMarca         : TCad_Marca;
     FTamanho       : TCad_Tamanho;
     FCor           : TCad_Cor;
     FUnidade       : TCad_Unidade;
  public
     FK_MARCA      : Integer;
     FK_TAMANHO    : Integer;
     FK_UNIDADE    : Integer;
     FK_COR        : INTEGER;
     REFERENCIA    : String;
     DESCRICAO     : String;
     CODIGO_BARRAS : String;
     OBSERVACAO    : String;
     CUSTO         : Extended;
     DATA_CADASTRO : TDateTime;

   property Marca   : TCad_Marca   read FMarca   write FMarca;
   property Tamanho : TCad_Tamanho read FTamanho write FTamanho;
   property Cor     : TCad_Cor     read FCor     write FCor;
   property Unidade : TCad_Unidade read FUnidade write FUnidade;
  end;

  TCad_Produto = class(TBaseBusiness)
   private
     FView: TView_Produto;
     procedure GetSQLInsert;
     procedure GetSQLUpdate;
     procedure Carregar;
   public

      procedure Inserir ; override;
      procedure Editar  ; override;
      procedure Excluir ; override;

      procedure Gravar  ; override;
      procedure SendToDb; override;
      procedure Cancelar; override;

      procedure LoadFromDb(pID : Integer); override;
      procedure LimparEntidade; override;

     property View : TView_Produto read FView write FView;
     constructor Create;
     destructor  Destroy;

  end;

implementation

{ TCad_Produto }

procedure TCad_Produto.GetSQLInsert;
begin
  with FView do
  begin
  FView.SQL_Insert:= 'INSERT INTO PRODUTO (ID, FK_MARCA, FK_TAMANHO, FK_UNIDADE, FK_COR, REFERENCIA, DESCRICAO, CODIGO_BARRAS, OBSERVACAO, CUSTO, DATA_CADASTRO)'
                     +#13+'  VALUES ('
                     +#13+'' + IntToStr(ID) +','
                     +#13+'' + IntToStr(FK_MARCA)  +','
                     +#13+'' + IntToStr(FK_TAMANHO) +','
                     +#13+'' + IntToStr(FK_UNIDADE) +','
                     +#13+'' + IntToStr(FK_COR)  +','
                     +#13+'' + QuotedStr(REFERENCIA) +','
                     +#13+'' + QuotedStr(DESCRICAO)  +','
                     +#13+'' + QuotedStr(CODIGO_BARRAS) +','
                     +#13+'' + QuotedStr(OBSERVACAO) +','
                     +#13+'' + TPF_String.GetFloat(FloatToStr(CUSTO)) +','
                     +#13+'' + QuotedStr(FormatDateTime('mm/dd/yyyy',DATA_CADASTRO))
                     +#13+');'
  end;
end;

procedure TCad_Produto.GetSQLUpdate;
begin
with FView do
begin
     SQL_Update:= 'UPDATE PRODUTO SET '
        +#13+'FK_MARCA = ' + IntToStr(FK_MARCA)  +','
        +#13+'FK_TAMANHO  = ' + IntToStr(FK_TAMANHO) +','
        +#13+'FK_UNIDADE  = ' + IntToStr(FK_UNIDADE) +','
        +#13+'FK_COR = ' + IntToStr(FK_COR)  +','
        +#13+'REFERENCIA = ' + QuotedStr(REFERENCIA) +','
        +#13+'DESCRICAO = ' + QuotedStr(DESCRICAO)  +','
        +#13+'CODIGO_BARRAS = ' + QuotedStr(CODIGO_BARRAS) +','
        +#13+'OBSERVACAO = ' + QuotedStr(OBSERVACAO) +','
        +#13+'CUSTO = ' + TPF_String.GetFloat(FloatToStr(CUSTO)) + ','
        +#13+' WHERE ID = ' + IntToStr(FView.ID);
end;

end;

procedure TCad_Produto.Carregar;
begin
  with FView  do
  begin
    Marca   .LoadFromDb(FK_MARCA);
    Tamanho .LoadFromDb(FK_TAMANHO);
    Cor     .LoadFromDb(FK_COR);
    Unidade .LoadFromDb(FK_UNIDADE);
  end;

    ;
end;

procedure TCad_Produto.Inserir;
begin
  LimparEntidade;
  FView.State:= TObSt_Inserting;
  FView.ID:= TBaseDados.GetNextID(FView.Generator);
  FView.DATA_CADASTRO:= Now;
end;

procedure TCad_Produto.Editar;
begin
  inherited Editar;
  FView.State:= TObSt_Editing;
end;

procedure TCad_Produto.Excluir;
begin
FView.SQL_Delete:='DELETE FROM PRODUTO WHERE ID = ' + IntToStr(FView.ID);
TBaseDados.ExecQuery(FView.SQL_Delete);
LimparEntidade;
end;

procedure TCad_Produto.Gravar;
begin

  case FView.State of
    TObSt_Inserting : GetSQLInsert;
    TObSt_Editing   : GetSQLUpdate;
  end;


end;

procedure TCad_Produto.SendToDb;
begin
try
case FView.State of
    TObSt_Inserting : TBaseDados.ExecQuery(FView.SQL_Insert);
    TObSt_Editing   : TBaseDados.ExecQuery(FView.SQL_Update);
  end;
finally
 FView.State:= TObSt_Browse;
end;
end;
procedure TCad_Produto.Cancelar;
begin
  FView.State:= TObSt_Browse;
  LimparEntidade;
end;

procedure TCad_Produto.LoadFromDb(pID: Integer);
begin

Query := TBaseDados.GetNewAbsQuery;
Query.SQL.Clear;
Query.SQL.Text:= 'SELECT * FROM PRODUTO WHERE ID = '+ IntToStr(pID);
Query.Open;

with Query, FView do
begin
  ID := FieldByName('id').AsInteger;
  FK_MARCA      := FieldByName('FK_MARCA').AsInteger;
  FK_TAMANHO    := FieldByName('FK_TAMANHO').AsInteger;
  FK_UNIDADE    := FieldByName('FK_UNIDADE').AsInteger;
  FK_COR        := FieldByName('FK_COR').AsInteger;
  REFERENCIA    := FieldByName('REFERENCIA').AsString;
  DESCRICAO     := FieldByName('DESCRICAO').AsString;
  CODIGO_BARRAS := FieldByName('CODIGO_BARRAS').AsString;
  OBSERVACAO    := FieldByName('OBSERVACAO').AsString;
  CUSTO         := FieldByName('CUSTO').AsFloat;
  DATA_CADASTRO := FieldByName('DATA_CADASTRO').AsDateTime;
end;

Carregar;

end;

procedure TCad_Produto.LimparEntidade;
begin
  with FView do
  begin
    ID            := 0;
    FK_MARCA      := 0;
    FK_TAMANHO    := 0;
    FK_UNIDADE    := 0;
    FK_COR        := 0;
    REFERENCIA    := '';
    DESCRICAO     := '';
    CODIGO_BARRAS := '';
    OBSERVACAO    := '';
    CUSTO         := 0;
  end;

end;

constructor TCad_Produto.Create;
begin
  FView := TView_Produto.Create(nil);
  FView.FMarca         := TCad_Marca.Create;
  FView.FTamanho       := TCad_Tamanho.Create;
  FView.FCor           := TCad_Cor.Create;
  FView.FUnidade       := TCad_Unidade.Create;

  FView.Generator:= 'GEN_PRODUTO_ID';

end;

destructor TCad_Produto.Destroy;
begin
   FreeAndnIl(FView);
end;

end.


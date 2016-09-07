unit uTCad_Cadastro;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,uTBaseDados,db, ut_Constante, bPF_Geral, sqldb;
type

  { TCad_Cadastro }

  TView_Cadastro = class(TBaseView)
  public
     RAZAO_SOCIAL : String;
     FANTASIA     : String;
     TIPO         : Integer;
     CNPJ_CPF     : String;
     INSCRICAO_RG : String;
     STATUS       : Integer;
     CHK_EMPRESA  : Integer;
     CHK_CLIENTE  : Integer;
     CHK_FORNECEDOR : Integer;
     E_MAIL         : String;
     DATA_CADASTRO  : TDate;
     OBSERVACAO     : String;
  end;

  TView_CadastroEndereco = class(TBaseView)

  public
      ENDERECO : STRING;
      BAIRRO   : STRING;
      NUMERO   : STRING;
      UF       : STRING;
      CONTATO  : STRING;
      TELEFONE : STRING;
      TELEFONE_OUTRO : STRING;
      CELULAR : STRING;
      FK_CADASTRO : INTEGER;
      CEP: STRING;
  end;

  TCad_Cadastro = class (TBaseBusiness)
  private
     FView         : TView_Cadastro;
     FViewEndereco : TView_CadastroEndereco;

     procedure GetSQLInsert;
     procedure GetSQLUpdate;
     procedure LimparEntidade;

  public
      procedure Inserir ; override;
      procedure Editar  ; override;
      procedure Excluir ; override;

      procedure Gravar  ; override;
      procedure SendToDb; override;
      procedure Cancelar; override;

      procedure LoadFromDb(pID : Integer); override;
      constructor Create;

   property View : TView_Cadastro read FView write FView;
   property ViewEndereco : TView_CadastroEndereco read FViewEndereco write FViewEndereco;
  end;

implementation

{ TCad_Cadastro }

procedure TCad_Cadastro.GetSQLInsert;
begin
   with FView do
   begin
    SQL_Insert:= 'INSERT INTO CADASTRO (ID, RAZAO_SOCIAL, FANTASIA, TIPO, CNPJ_CPF, INSCRICAO_RG, STATUS, CHK_EMPRESA, CHK_CLIENTE, CHK_FORNECEDOR, E_MAIL, DATA_CADASTRO, OBSERVACAO)'
                +#13+' VALUES ('
                +#13+ IntToStr(ID)              +','
                +#13+ QuotedStr(RAZAO_SOCIAL)              +','
                +#13+ QuotedStr(FANTASIA)                  +','
                +#13+ IntToStr(TIPO)            +','
                +#13+ QuotedStr(CNPJ_CPF)                  +','
                +#13+ QuotedStr(INSCRICAO_RG)              +','
                +#13+ IntToStr(STATUS)          +','
                +#13+ IntToStr(CHK_EMPRESA)     +','
                +#13+ IntToStr(CHK_CLIENTE)     +','
                +#13+ IntToStr(CHK_FORNECEDOR)  +','
                +#13+ QuotedStr(E_MAIL)                    +','
                +#13+ QuotedStr(FormatDateTime('mm/dd/yyyy',DATA_CADASTRO))  +','
                +#13+ QuotedStr(OBSERVACAO)
                +#13+' );';

   end;

   with FViewEndereco do
   begin
    SQL_Insert:= 'INSERT INTO CADASTRO_ENDERECO (ID, ENDERECO, BAIRRO, NUMERO, UF, CONTATO, TELEFONE, TELEFONE_OUTRO, CELULAR, FK_CADASTRO, CEP)'
                +#13+ ' VALUES ( '
                +#13+ IntToStr(ID)                +','
                +#13+ QuotedStr(ENDERECO)                    +','
                +#13+ QuotedStr(BAIRRO)                      +','
                +#13+ QuotedStr(NUMERO)                      +','
                +#13+ QuotedStr(UF)                          +','
                +#13+ QuotedStr(CONTATO)                     +','
                +#13+ QuotedStr(TELEFONE)                    +','
                +#13+ QuotedStr(TELEFONE_OUTRO)              +','
                +#13+ QuotedStr(CELULAR)                     +','
                +#13+ IntToStr(FK_CADASTRO)       +','
                +#13+ QuotedStr(CEP)                         + ');';
   end;
end;

procedure TCad_Cadastro.GetSQLUpdate;
begin

with FView do
begin
 SQL_Update:= 'UPDATE CADASTRO SET'
             +#13+ 'RAZAO_SOCIAL =' + QuotedStr(RAZAO_SOCIAL)              +','
             +#13+ 'FANTASIA =' + QuotedStr(FANTASIA)                  +','
             +#13+ 'TIPO = ' + IntToStr(TIPO)            +','
             +#13+ 'CNPJ_CPF =' + QuotedStr(CNPJ_CPF)                  +','
             +#13+ 'INSCRICAO_RG =' + QuotedStr(INSCRICAO_RG)              +','
             +#13+ 'STATUS =' + IntToStr(STATUS)          +','
             +#13+ 'CHK_EMPRESA = ' + IntToStr(CHK_EMPRESA)     +','
             +#13+ 'CHK_CLIENTE =' + IntToStr(CHK_CLIENTE)     +','
             +#13+ 'CHK_FORNECEDOR =' + IntToStr(CHK_FORNECEDOR)  +','
             +#13+ 'E_MAIL =' + QuotedStr(E_MAIL)                    +','
             +#13+ 'DATA_CADASTRO = ' + QuotedStr(FormatDateTime('mm/dd/yyyy',DATA_CADASTRO))  +','
             +#13+ 'OBSERVACAO = ' + QuotedStr(OBSERVACAO)
             +#13+ ' WHERE ID = ' + IntToStr(ID)
             +#13+' ;';

end;

with FViewEndereco do
begin
SQL_Update:= 'UPDATE CADASTRO_ENDERECO SET '
             +#13+ 'ENDERECO = ' + QuotedStr(ENDERECO)              +','
             +#13+ 'BAIRRO = ' + QuotedStr(BAIRRO)                  +','
             +#13+ 'NUMERO = ' + QuotedStr(NUMERO)                  +','
             +#13+ 'UF = ' + QuotedStr(UF)                          +','
             +#13+ 'CONTATO = ' + QuotedStr(CONTATO)                +','
             +#13+ 'TELEFONE =' + QuotedStr(TELEFONE)               +','
             +#13+ 'TELEFONE_OUTRO =' + QuotedStr(TELEFONE_OUTRO )  +','
             +#13+ 'CELULAR = ' + QuotedStr(CELULAR)                +','
             +#13+ 'CEP = ' + QuotedStr(CEP )
             +#13+ ' WHERE ID = ' + IntToStr(ID);
end;

end;

procedure TCad_Cadastro.LimparEntidade;
begin

 with FView  do
 begin
  RAZAO_SOCIAL := '';
  FANTASIA     := '';
  TIPO         := 0;
  CNPJ_CPF     := '';
  INSCRICAO_RG := '';
  STATUS       := 0;
  CHK_EMPRESA  := 0;
  CHK_CLIENTE  := 0;
  CHK_FORNECEDOR := 0;
  E_MAIL         := '';
  DATA_CADASTRO  := Now;
  OBSERVACAO     := '';
 end;

  with FViewEndereco  do
  begin
    ENDERECO := '';
    BAIRRO   := '';
    NUMERO   := '';
    UF       := '';
    CONTATO  := '';
    TELEFONE := '';
    TELEFONE_OUTRO := '';
    CELULAR := '';
    FK_CADASTRO := 0;
    CEP:= '';
  end;

end;

procedure TCad_Cadastro.Inserir;
begin
 LimparEntidade;

 FView         .State:= TObSt_Inserting;
 FViewEndereco .State:= TObSt_Inserting;

 FView.ID:= TBaseDados.GetNextID(FView.Generator);

 FViewEndereco.ID:= TBaseDados.GetNextID(FViewEndereco.Generator);

 FViewEndereco.FK_CADASTRO:= FView.ID;

 FView.DATA_CADASTRO:= now;

end;

procedure TCad_Cadastro.Editar;
begin
 FViewEndereco.State := TObSt_Editing;
 FView.State         := TObSt_Editing;
end;

procedure TCad_Cadastro.Excluir;
begin
  FView.SQL_Delete:= 'DELETE FROM CADASTRO WHERE ID = ' + IntToStr(FView.ID);
  TBaseDados.ExecQuery(FView.SQL_Delete);
end;

procedure TCad_Cadastro.Gravar;
begin
   case FView.State of
     TObSt_Inserting : GetSQLInsert;
     TObSt_Editing   : GetSQLUpdate;
   end;

end;

procedure TCad_Cadastro.SendToDb;
begin
  try
    case FView.State of
      TObSt_Editing   :
        begin
          TBaseDados.ExecQuery(FView.SQL_Update);
          TBaseDados.ExecQuery(FViewEndereco.SQL_Update);
         end;
      TObSt_Inserting :
        begin
          TBaseDados.ExecQuery(FView.SQL_Insert);
          TBaseDados.ExecQuery(FViewEndereco.SQL_Insert);
        end
      else raise TExceptionValidacao.Create(ErroFViewState);
    end;

  finally
    FViewEndereco.State := TObSt_Browse;
    FView.State         := TObSt_Browse;
  end;

end;

procedure TCad_Cadastro.Cancelar;
begin
FView.State         := TObSt_Browse;
FViewEndereco.state := TObSt_Browse;

LimparEntidade;
end;

procedure TCad_Cadastro.LoadFromDb(pID: Integer);
var vSQL : String;
begin

 vSQL := 'SELECT Cad.*,'
             + ' (Endr.ID) ENDERECO_ID,'
             + ' Endr.ENDERECO,'
             + ' Endr.BAIRRO,'
             + ' Endr.NUMERO,'
             + ' Endr.UF,'
             + ' Endr.CONTATO,'
             + ' Endr.TELEFONE,'
             + ' Endr.TELEFONE_OUTRO,'
             + ' Endr.CELULAR,'
             + ' Endr.FK_CADASTRO,'
             + ' Endr.CEP '
             +' FROM CADASTRO CAD '
             +' INNER JOIN CADASTRO_ENDERECO ENDR ON (ENDR.FK_CADASTRO = CAD.ID)'
             +' WHERE CAD.ID = ' + IntToStr(pID);

 Query:= TBaseDados.GetNewAbsQuery;
 Query.SQL.Clear;
 Query.SQL.Text:= vSQL;
 try
 Query.Open;

 with FView , Query do
 begin
  ID           := FieldByName('ID').Value;
  RAZAO_SOCIAL := FieldByName('RAZAO_SOCIAL').Value;
  FANTASIA     := FieldByName('FANTASIA').Value;
  TIPO         := FieldByName('TIPO').Value;
  CNPJ_CPF     := FieldByName('CNPJ_CPF').Value;
  INSCRICAO_RG := FieldByName('INSCRICAO_RG').Value;
  STATUS       := FieldByName('STATUS').Value;
  CHK_EMPRESA  := FieldByName('CHK_EMPRESA').Value;
  CHK_CLIENTE  := FieldByName('CHK_CLIENTE').Value;
  CHK_FORNECEDOR := FieldByName('CHK_FORNECEDOR').Value;
  E_MAIL         := FieldByName('E_MAIL').Value;
  DATA_CADASTRO  := StrToDate(FormatDateTime('dd/mm/yyyy', FieldByName('DATA_CADASTRO').AsDateTime));
  OBSERVACAO     := FieldByName('OBSERVACAO').Value;
 end;

  with FViewEndereco, Query do
  begin
    ID                := FieldByName('ENDERECO_ID').Value;
    ENDERECO          := FieldByName('ENDERECO').Value;
    BAIRRO            := FieldByName('BAIRRO').Value;
    NUMERO            := FieldByName('NUMERO').Value;
    UF                := FieldByName('UF').Value;
    CONTATO           := FieldByName('CONTATO').Value;
    TELEFONE          := FieldByName('TELEFONE').Value;
    TELEFONE_OUTRO    := FieldByName('TELEFONE_OUTRO').Value;
    CELULAR           := FieldByName('CELULAR').Value;
    FK_CADASTRO       := FieldByName('FK_CADASTRO').Value;
    CEP               := FieldByName('CEP').Value;

  end;
finally
  Query.Close;
  FreeAndNil(Query);
end;

end;

constructor TCad_Cadastro.Create;
begin
  inherited Create;

  FView := TView_Cadastro.Create(Nil);
  FViewEndereco := TView_CadastroEndereco.Create(Nil);
  FView.Generator         := 'GEN_CADASTRO_ID';
  FViewEndereco.Generator := 'GEN_CADASTRO_ENDERECO';
end;

end.


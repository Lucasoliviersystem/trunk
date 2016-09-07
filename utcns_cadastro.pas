unit utCns_cadastro;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, uTBaseDados;

Type

  { TCns_Cadastro }

  TCns_Cadastro = class (TBasePesquisa)

    private
    FID          : Integer;
    FRazaoSocial : String;
    FCNPJ        : String;

    protected
    procedure RetornaFiltro;
    procedure CreateBefore;   override;
    procedure LimparPesquisa; override;
    procedure Abrir;          override;

    public
      property ID          : Integer read FID          write FID;
      property RazaoSocial : String  read FRazaoSocial write FRazaoSocial;
      property CNPJ        : String  read FCNPJ        write FCNPJ;

  end;

implementation

{ TCns_Cadastro }

procedure TCns_Cadastro.RetornaFiltro;
var vFiltro : String;
begin

  if(FID <> 0)
  then TPF_Database.FiltraNro(vFiltro,'C.ID',FID);

  if(FRazaoSocial <> '')
  then TPF_Database.FiltraStr(vFIltro,'C.RAZAO_SOCIAL',FRazaoSocial);

  if(FCNPJ <> '')
  then TPF_Database.FiltraStr(vFIltro,'C.CNPJ_CPF',FCNPJ);

  FFiltro :=  vFiltro;

end;

procedure TCns_Cadastro.CreateBefore;
begin
  inherited CreateBefore;
  SQL_Select:= 'SELECT C.*, CEND.* FROM CADASTRO C'
               +#13+'LEFT JOIN CADASTRO_ENDERECO CEND ON (CEND.FK_CADASTRO = C.ID) where 1=1';
end;

procedure TCns_Cadastro.LimparPesquisa;
begin
  inherited;
  FRazaoSocial   := '';
  FID            := 0;
  FCNPJ          := '';
end;

procedure TCns_Cadastro.Abrir;
begin
  RetornaFiltro;
  inherited Abrir;
end;

end.


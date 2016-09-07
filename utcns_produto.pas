unit utcns_produto;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, uTBaseDados,uTCad_Produto;

type

  { TCns_Produto }

  TCns_Produto = class(TBasePesquisa)
    procedure CreateBefore; override;
    procedure CreateAfter; override;
    procedure LimparPesquisa; override;
    procedure Abrir; override;
  protected
   FProduto : TView_Produto;
  private
    procedure RetornFiltro;
  public

  end;

implementation

{ TCns_Produto }

procedure TCns_Produto.CreateBefore;
begin
  inherited CreateBefore;
  SQL_Select:= 'SELECT * FROM PRODUTO ';
  FProduto := TView_Produto.Create(Self);
end;

procedure TCns_Produto.CreateAfter;
begin
  inherited CreateAfter;
end;

procedure TCns_Produto.LimparPesquisa;
begin
  inherited LimparPesquisa;

  FProduto.ID:= 0;
  FProduto.DESCRICAO:= '';
end;

procedure TCns_Produto.Abrir;
begin
  RetornFiltro;
  inherited Abrir;
end;

procedure TCns_Produto.RetornFiltro;
var vFiltro : String;
begin
   with FProduto do
   begin
     if(ID <> 0)
     then TPF_Database.FiltraNro(vFiltro,'ID',ID);

     if DESCRICAO <> ''
     then TPF_Database.FiltraStr(vFiltro,'DESCRICAO',DESCRICAO);

   end;

  if (vFiltro <> '')
  then   FFiltro := ' where 1=1 ' + vFiltro;

end;

end.


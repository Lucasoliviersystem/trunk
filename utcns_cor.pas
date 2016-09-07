unit utcns_cor;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, uTBaseDados;

type

  { TCns_Cor }

  TCns_Cor = class (TBasePesquisa)

    private
      FID : integer;
      FDescricao : string;
    public
      procedure CreateBefore; override;
      procedure LimparPesquisa; override;
      procedure Abrir; override;
      procedure RetornaFiltro;
  end;

implementation

{ TCns_Cor }

procedure TCns_Cor.CreateBefore;
begin
  inherited CreateBefore;
  SQL_Select:= 'SELECT * FROM PRODUTO_COR where 1=1 ';
end;

procedure TCns_Cor.LimparPesquisa;
begin
  inherited;
  FID:= 0;
  FDescricao:= '';
end;

procedure TCns_Cor.Abrir;
begin
    RetornaFiltro;
    inherited Abrir;
end;

procedure TCns_Cor.RetornaFiltro;
var vFiltro : String;
begin
  if(FID <> 0)
  then TPF_Database.FiltraNro(vFiltro,'ID',FID);

  if(FDESCRICAO <> '')
  then TPF_Database.FiltraStr(vFIltro,'DESCRICAO',FDESCRICAO);

   VFILTRO:= VFILTRO + ' order by id desc ';
  FFiltro :=  vFiltro;
end;

end.


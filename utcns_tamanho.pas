unit utCNS_tamanho;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, uTBaseDados;

type

  { TCns_Tamanho }

  TCns_Tamanho = class (TBasePesquisa)

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

{ TCns_Tamanho }

procedure TCns_Tamanho.CreateBefore;
begin
  inherited CreateBefore;
  SQL_Select:= 'SELECT * FROM PRODUTO_TAMANHO where 1=1 ';
end;

procedure TCns_Tamanho.LimparPesquisa;
begin
  inherited;
  FID:= 0;
  FDescricao:= '';
end;

procedure TCns_Tamanho.Abrir;
begin
    RetornaFiltro;
    inherited Abrir;
end;

procedure TCns_Tamanho.RetornaFiltro;
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


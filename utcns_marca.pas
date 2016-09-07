unit utcns_marca;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, uTBaseDados;

Type

  { TCns_Marca }

  TCns_Marca = class (TBasePesquisa)

    private
      FID : Integer;
      FDESCRICAO : String;

    public
      procedure CreateBefore; override;
      procedure LimparPesquisa; override;
      procedure Abrir; override;
      procedure RetornaFiltro;

      property ID          : Integer read FID          write FID;
      property DESCRICAO   : String  read FDESCRICAO   write FDESCRICAO;
  end;

implementation

{ TCns_Marca }

procedure TCns_Marca.CreateBefore;
begin
  inherited CreateBefore;
  SQL_Select:= 'SELECT * FROM PRODUTO_MARCA where 1=1';
end;

procedure TCns_Marca.LimparPesquisa;
begin
  inherited;
  FID            := 0;
  FDESCRICAO     := '';
end;

procedure TCns_Marca.Abrir;
begin
  RetornaFiltro;

  inherited Abrir;
end;

procedure TCns_Marca.RetornaFiltro;
VAR VFILTRO : STRING;
begin
  if(FID <> 0)
  then TPF_Database.FiltraNro(vFiltro,'ID',FID);

  if(FDESCRICAO <> '')
  then TPF_Database.FiltraStr(vFIltro,'DESCRICAO',FDESCRICAO);

   VFILTRO:= VFILTRO + ' order by id desc ';
  FFiltro :=  vFiltro;

end;

end.


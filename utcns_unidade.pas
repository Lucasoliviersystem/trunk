unit uTCNS_Unidade;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, utbasedados;

type

  { TCns_Unidade }

  TCns_Unidade = class(TBasePesquisa)

    procedure CreateBefore; override;
  end;


implementation

{ TCns_Unidade }

procedure TCns_Unidade.CreateBefore;
begin
  inherited CreateBefore;
  SQL_Select:='SELECT * FROM PRODUTO_UNIDADE where 1=1';
end;

end.


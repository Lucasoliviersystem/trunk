unit uTCns_Usuario;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,utbasedados;

type

  { TCns_Usuario }

  TCns_Usuario = class(TBasePesquisa)

    procedure CreateBefore; override;
    procedure CreateAfter; override;
    procedure LimparPesquisa; override;
    procedure Abrir; override;
  protected
    FID : Integer;
    FLogin : String;
  private
    procedure RetornFiltro;
  public
      property ID : Integer read FID write FID;
      property Login : String read FLogin write FLogin;

  end;

implementation

{ TCns_Usuario }

procedure TCns_Usuario.CreateBefore;
begin
  inherited CreateBefore;
  SQL_Select:= 'SELECT * FROM SYS_USUARIO';
end;

procedure TCns_Usuario.CreateAfter;
begin
  inherited CreateAfter;
end;

procedure TCns_Usuario.LimparPesquisa;
begin
  inherited LimparPesquisa;
    inherited;
  FID             := 0;
  FLogin          := '';
end;

procedure TCns_Usuario.Abrir;
begin
  RetornFiltro;
  inherited Abrir;
end;

procedure TCns_Usuario.RetornFiltro;
var vFiltro : String;
begin

  if(FID <> 0)
  then TPF_Database.FiltraNro(vFiltro,'ID',FID);

  if(FLogin <> '')
  then TPF_Database.FiltraStr(vFIltro,'LOGIN',FLogin);

  if (vFiltro <> '')
  then   FFiltro := ' where 1=1 ' + vFiltro;

end;

end.


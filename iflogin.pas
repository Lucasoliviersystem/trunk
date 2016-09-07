unit ifLogin;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls;

type

  { TfLogin }

  TfLogin = class(TForm)
    Btn_Acessar: TButton;
    Btn_Cancelar: TButton;
    Button1: TButton;
    Ed_Usuario: TEdit;
    Ed_Senha: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    procedure Btn_AcessarClick(Sender: TObject);
    procedure Btn_CancelarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  fLogin: TfLogin;

implementation

uses uTBaseDados, bpf_geral, uTSys_GetGlobalsVars;

{$R *.lfm}

{ TfLogin }

procedure TfLogin.Btn_CancelarClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfLogin.FormCreate(Sender: TObject);
begin

end;

procedure TfLogin.FormDestroy(Sender: TObject);
begin
  fLogin := NIL;
end;

procedure TfLogin.Btn_AcessarClick(Sender: TObject);
begin

  if (TPF_Security.VerifyPassword(Ed_Usuario.text,Ed_Senha.text)) then
  begin
    ModalResult := mrOK;
    GDadosGerais.View.UsuarioID:= TBaseDados.GetLookup(Ed_Usuario.Text,'LOGIN','SYS_USUARIO','ID');
  end
  else
    begin
    Ed_Usuario.clear;
    Ed_Senha.Clear;
    ShowMessage('Login e/ou senha incorretos!');
    end;

  //ModalResult := mrOK;
end;

end.


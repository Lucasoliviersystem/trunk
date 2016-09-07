unit ifMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ComCtrls, StdCtrls, ExtCtrls, Buttons, ifcad_cadastro, ifcad_marca,
  ifcad_gruposubgrupo, IfCad_Unidade, ifcad_usuario, ifcad_produto,
  ifcad_tabelaPreco, ifcad_tamanho, ifpedido_tipo, ifmov_pedidovenda,
  ifmov_pedidocompra, bpf_validacao, iflogin, windows;

type

  { TFMain }

  TFMain = class(TForm)
    Btn_AjusteEstoque: TButton;
    Btn_AjusteEstoque1: TButton;
    Btn_AjusteEstoque2: TButton;
    Btn_AjusteEstoque3: TButton;
    Btn_Configuracoes: TButton;
    Btn_Cor: TButton;
    Btn_marca: TButton;
    Btn_PedidoCompra: TButton;
    Btn_PedidoVenda: TButton;
    Btn_Pessoa: TButton;
    Btn_produto: TButton;
    Btn_Tamanho: TButton;
    Btn_TipoPedido: TButton;
    Btn_Unidade: TButton;
    Btn_Usuario: TButton;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    ScrollBox1: TScrollBox;
    procedure BitBtn1Click(Sender: TObject);
    procedure Btn_ConfiguracoesClick(Sender: TObject);
    procedure Btn_PessoaClick(Sender: TObject);
    procedure Btn_TipoPedidoClick(Sender: TObject);
    procedure Btn_UsuarioClick(Sender: TObject);
    procedure Btn_CorClick(Sender: TObject);
    procedure Btn_UnidadeClick(Sender: TObject);
    procedure Btn_marcaClick(Sender: TObject);
    procedure Btn_produtoClick(Sender: TObject);
    procedure Btn_TamanhoClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure TrataErro(Sender : Tobject ; E: Exception);

  private
    { private declarations }
    FCad_Cadastro : TfCad_Cadastro;
    procedure ShowChild(MainForm : TForm; InstanceClass: TFormClass; var Reference);
    function IsChildFormExist(InstanceClass: TFormClass): Boolean;
    procedure OnCloseDefault(Sender: TObject; var CloseAction: TCloseAction);
  public
    { public declarations }
    procedure FormItemClick(Sender : TObject);
  end;

var
  FMain: TFMain;

implementation

{$R *.lfm}

{ TFMain }


procedure TFMain.TrataErro(Sender: Tobject; E: Exception);
begin
 TExceptionSystem.ShowExcept(Sender,E);
end;

procedure TFMain.ShowChild(MainForm: TForm; InstanceClass: TFormClass;
  var Reference);
var
   Instance: TForm;
 begin
   Screen.Cursor:= crHourglass;
   LockWindowUpdate(MainForm.Handle);

   //Verifica se o formulário já está aberto!
   if not IsChildFormExist(InstanceClass) then
     try

       //se não estiver, cria;
       Instance:= TForm(InstanceClass.NewInstance);
       TForm(Reference):= Instance;
       try
         Instance.Create(MainForm);
         (Instance as TForm).Visible   := True;
         (Instance as TForm).Position:= poDesktopCenter;
       except
         TForm(Reference):= nil;
         Instance.Free;
         raise;
       end;
     finally
       Screen.Cursor:= crDefault;
     end
   else
   // se estiver, traz para frente!
     with TForm(InstanceClass) do begin
       if WindowState = wsMinimized then WindowState:= wsNormal;
       BringToFront;
       Screen.Cursor:= crDefault;
       SetFocus;
     end;

   LockWindowUpdate(0);
end;

function TFMain.IsChildFormExist(InstanceClass: TFormClass): Boolean;
var
I: Integer;
begin
with (Screen) do
  for I := 0 to FormCount- 1 do
    if (Forms[i] is InstanceClass) then
    begin
      Result := True;
      Break;
    end;
Result:= False;
end;

procedure TFMain.OnCloseDefault(Sender: TObject; var CloseAction: TCloseAction);
begin

end;


procedure TFMain.FormItemClick(Sender: TObject);
var x: integer;
begin
end;

procedure TFMain.FormCreate(Sender: TObject);
begin
  Application.OnException:= @TrataErro;
end;

procedure TFMain.Btn_PessoaClick(Sender: TObject);
begin
  ShowChild(Self,TfCad_Cadastro, FCad_Cadastro);
end;

procedure TFMain.Btn_TipoPedidoClick(Sender: TObject);
begin
  ShowChild(Self, TFPedido_Tipo, FPedido_Tipo);
end;

procedure TFMain.Btn_UsuarioClick(Sender: TObject);
begin
  ShowChild(self,TFCad_Usuario, FCad_Unidade);
end;

procedure TFMain.Btn_ConfiguracoesClick(Sender: TObject);
begin
     raise TExceptionValidacao.Create('Em Desenvolvimento!');
end;

procedure TFMain.BitBtn1Click(Sender: TObject);
begin
ShowMessage(  (GetCurrentDir) );
end;

procedure TFMain.Btn_CorClick(Sender: TObject);
begin

end;

procedure TFMain.Btn_UnidadeClick(Sender: TObject);
begin
  ShowChild(Self, TFCad_Unidade, FCad_Unidade);
end;

procedure TFMain.Btn_marcaClick(Sender: TObject);
begin
  ShowChild(Self,TFCad_Marca, FCad_Marca);
end;

procedure TFMain.Btn_produtoClick(Sender: TObject);
begin
  ShowChild(Self, TFCad_Produto, FCad_Produto);
end;

procedure TFMain.Btn_TamanhoClick(Sender: TObject);
begin
  ShowChild(Self,TFCad_Tamanho, FCad_Tamanho);
end;

procedure TFMain.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
if  not (TPF_Confirmacao.SwitchChoose('Deseja Realmente sair do sistema'))
then Abort;
  CloseAction:= caFree;
end;

procedure TFMain.FormShow(Sender: TObject);
var vLogin : TfLogin;
begin
  vLogin := TfLogin.Create(Self);

  try
    vLogin.ShowModal;

    if(vLogin.ModalResult <> mrOK)
    then Application.Terminate;

    vLogin.Close;

  finally
    FreeAndNil(vLogin);
  end;
end;


procedure TFMain.MenuItem3Click(Sender: TObject);
begin
     ShowChild(Self,TfCad_Cadastro,FCad_Cadastro);
end;

procedure TFMain.MenuItem6Click(Sender: TObject);
begin
    ShowChild(Self,TFCad_Unidade, FCad_Unidade);
end;

end.


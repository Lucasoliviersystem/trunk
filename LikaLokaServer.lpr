program LikaLokaServer;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, ifMain, uTBaseDados, uTCad_Cadastro, utcad_cadastroEndereco,
  utCns_cadastro, ifLogin, runtimetypeinfocontrols, utMap_Ambiente,
  uT_Constante, uTCad_Unidade, uTCNS_Unidade, bPF_Geral, bPF_Validacao, classes,
  ifcad_marca, ifcad_tabelaPreco, ifcad_tamanho, ifcad_unidade, ifcad_produto,
  utcad_usuario, ifpedido_tipo, ifmov_pedidovenda, ifmov_pedidocompra,
uTCns_Usuario, mDMRel_Cadastros, uTMov_Pedido, uTMov_PedidoItem,
uTCad_TipoPedido, utcad_marca, utcns_marca, utcad_tamanho, utCNS_tamanho, 
ifOtr_Pesquisar, uTCns_Pesquisar, uTCad_Produto, uTOtr_SystemLog,
uTOtr_AmbienteView, uTSys_GetGlobalsVars, utCfg_loadFromIni;

{$R *.res}

begin
  //RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TFMain, FMain);
  Application.Run;
 end.


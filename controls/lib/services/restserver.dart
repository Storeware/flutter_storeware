  import '../data/odata.dart'; 
   
// gerado por:  http://localhost:8886/hello?typ=dart
// em: 27/06/2019 18:05:03
  class RestserverService extends OData { 
   
    RestserverService(String host) : super(host); 
 
//Lista os métodos disponíveis no servidor (typ=[json,js,pas,angularjs,ds,dart]; show=[all])
getHello( String typ, String show) {
   return openUrl('GET','/hello?typ=$typ&show=$show');
 } 
 
//Obtem data e hora do servidor
getDatepart( String fmt){
   return openUrl('GET','/datepart?fmt=$fmt');
 } 
 
//Obtem data do servidor
Future<String> getDate( String fmt){
   return openUrl('GET','/date?fmt=$fmt');
 } 
 
//Executa relatório WBAReport
Future<String> getRelatorio( String qr2, String params){
   return openUrl('GET','/Relatorio.get?qr2=$qr2&params=$params');
 } 
 
//Browser QR2 Files
Future<String> getQr2( String login, String param){
   return openUrl('GET','/qr2?login=$login&param=$param');
 } 
 
//Obtem de acesso habilitado para o recurso
Future<String> getAcessoHabilitado( String chave){
   return openUrl('GET','/AcessoHabilitado.Get?chave=$chave');
 } 
 
//Obtem lista de mensagens geradas pelo servidor (clear=yes)
Future<String> getMessages( String clear){
   return openUrl('GET','/messages.get?clear=$clear');
 } 
 
//Obtem data/hora do banco de dados.
Future<String> getDbNow( String fmt){
   return openUrl('GET','/DbNow.Get?fmt=$fmt');
 } 
 
//Retorna os dados da filial
Future<String> getFilial( String login, double filial){
   return openUrl('GET','/Filial.Get?login=$login&filial=$filial');
 } 
 
//Retorna as filiais de acesso do usuario
Future<String> getFilialAcesso( String usuario){
   return openUrl('GET','/FilialAcesso.Get?usuario=$usuario');
 } 
 
//Retorna os colaboradores do gerente
Future<String> getColaboradores( String login, String gerente, double filial){
   return openUrl('GET','/Colaboradores.Get?login=$login&gerente=$gerente&filial=$filial');
 } 
 
//Efetua login no sistema e retorna a {chave de acesso} a ser utilizado nas próximas chamadas
Future<String> getLogin( String usuario, String senha, double filial, String local){
   return openUrl('GET','/Login.Get?usuario=$usuario&senha=$senha&filial=$filial&local=$local');
 } 
 
//Obtem lista de pemissões do grupo do usuário
Future<String> getPermissoes( String grupo, String usuario, double filial, String arquivo){
   return openUrl('GET','/Permissoes.Get?grupo=$grupo&usuario=$usuario&filial=$filial&arquivo=$arquivo');
 } 
 
//Retorna SQL ResultSet (Parametros -> prms.type=json).
Future<String> getQueryDB( String login, String sql, String prms){
   return openUrl('GET','/QueryDB.Get?login=$login&sql=$sql&prms=$prms');
 } 
 
//Obtem sequência de documento.
Future<String> getNextId( String login, String dcto){
   return openUrl('GET','/NextId.Get?login=$login&dcto=$dcto');
 } 
 
//Obtem a configuração para o identificador
Future<String> getConfig( String login, String arquivo, String secao, String item, String valor, double filial){
   return openUrl('GET','/Config.Get?login=$login&arquivo=$arquivo&secao=$secao&item=$item&valor=$valor&filial=$filial');
 } 
 
//Altera a configuração para o identificador
putConfig( String login, String arquivo, String secao, String item, String valor, double filial,body){
   return openUrl('PUT','/Config.Put?login=$login&arquivo=$arquivo&secao=$secao&item=$item&valor=$valor&filial=$filial',body);
 } 
 
//Lista configuração do servidor (*)
Future<String> getServerInfo( String login, String secao, String item){
   return openUrl('GET','/ServerInfo.Get?login=$login&secao=$secao&item=$item');
 } 
 
//Lista configuração do servidor (RestServer)
Future<String> getServerInfoList( String login, String secao, String item){
   return openUrl('GET','/ServerInfo.List?login=$login&secao=$secao&item=$item');
 } 
 
//Obtem versão do servidor
Future<String> getVersao(){
   return openUrl('GET','/Versao.Get?');
 } 
 
//Carrega lista de atalhos do cadastro
Future<String> getProdutosAtalhos( String codigo, String cod_pai){
   return openUrl('GET','/produtos/atalhos?codigo=$codigo&cod_pai=$cod_pai');
 } 
 
//Carrega lista de produto que faz parte do título
Future<String> getProdutosAtalhosItens( String codigo){
   return openUrl('GET','/produtos/atalhos/itens?codigo=$codigo');
 } 
 
//Carrega lista de grupos do cadastro
Future<String> getProdutosGrupos( String codigo){
   return openUrl('GET','/produtos/grupos?codigo=$codigo');
 } 
 
//Carrega lista de setores do cadastro
Future<String> getProdutosSetores( String codigo){
   return openUrl('GET','/produtos/setores?codigo=$codigo');
 } 
 
//Retorna a quantidade em estoque do produto
Future<String> getProdutosSaldoestoque( String login, String codigo, double filial){
   return openUrl('GET','/produtos/saldoestoque?login=$login&codigo=$codigo&filial=$filial');
 } 
 
//Retorna o cadastro de produto
Future<String> getProdutos( String login, String codigo, double filial){
   return openUrl('GET','/produtos?login=$login&codigo=$codigo&filial=$filial');
 } 
 
//Atualiza cadastro de produtos
Future<String> putProdutosAtualizar( String login, String codigo, double filial,body){
   return openUrl('PUT','/produtos/atualizar?login=$login&codigo=$codigo&filial=$filial',body);
 } 
 
//Retorna os dados da pessoa. Informar CNPJ ou CODIGO como parametro.
Future<String> getPessoas( String login, String cnpj, double codigo){
   return openUrl('GET','/pessoas?login=$login&cnpj=$cnpj&codigo=$codigo');
 } 
 
//Retorna a lista de complementos para um produto
Future<String> getProdutosComplementos( String login, String codigo){
   return openUrl('GET','/produtos/complementos?login=$login&codigo=$codigo');
 } 
 
//Incluir item na contagem de inventário.
Future<String> postInventarioEnviar( String login, String codigo, double qtde, double filial,body){
   return openUrl('POST','/inventario/enviar?login=$login&codigo=$codigo&qtde=$qtde&filial=$filial',body);
 } 
 
//Solicitar reposição de estoque.
Future<String> postProdutosRequisitarreposicao( String login, String codigo, double qtde, double filial,body){
   return openUrl('POST','/produtos/requisitarreposicao?login=$login&codigo=$codigo&qtde=$qtde&filial=$filial',body);
 } 
 
//Solicitar emissao de etiqueta.
Future<String> postProdutosRequisitaretiqueta( String login, String codigo, double qtde, double filial, String tipo,body){
   return openUrl('POST','/produtos/requisitaretiqueta?login=$login&codigo=$codigo&qtde=$qtde&filial=$filial&tipo=$tipo',body);
 } 
 
//Carrega tribução icms
Future<String> getCadastroTribIcms( String codigo){
   return openUrl('GET','/cadastro/trib_icms?codigo=$codigo');
 } 
 
//Obtem informacoes sobre o cpu
Future<String> getCpuSpecs(){
   return openUrl('GET','/cpu_specs?');
 } 
 
//Verifica se uma comanda é válida e retorna o limite estabelecido para a comanda.
Future<String> getNumeroComandaCheck( String login, String comanda){
   return openUrl('GET','/NumeroComanda.Check?login=$login&comanda=$comanda');
 } 
 
//Pega o saldo da comanda.
Future<String> getSaldoComanda( String login, String comanda, double filial){
   return openUrl('GET','/SaldoComanda.Get?login=$login&comanda=$comanda&filial=$filial');
 } 
 
//
Future<String> getTeste(){
   return openUrl('GET','/Teste?');
 } 
 
//Obter número para o próximo pedido
Future<String> getPedidoVendaNovoNumero( String login, double filial){
   return openUrl('GET','/PedidoVenda.NovoNumero.Get?login=$login&filial=$filial');
 } 
 
//Incluir novo item (produto) no pedido do cliente.
Future<String> postPedidoVendaItem( String login, double filial, String pedido, String codigo, double qtde, double ordem, String vendedor, String mesa, String terminal, double lote, String localterminal, String usuario, String impressaoimediata,body){
   return openUrl('POST','/PedidoVenda.Item.Put?login=$login&filial=$filial&pedido=$pedido&codigo=$codigo&qtde=$qtde&ordem=$ordem&vendedor=$vendedor&mesa=$mesa&terminal=$terminal&lote=$lote&localterminal=$localterminal&usuario=$usuario&impressaoimediata=$impressaoimediata',body);
 } 
 
//Envia dados para alteração do item
Future<String> putPedidoVendaItemUpdate( String login, double id, String dados,body){
   return openUrl('PUT','/PedidoVenda.Item.Update?login=$login&id=$id&dados=$dados',body);
 } 
 
//Confirma a finalização do pedido de venda.
Future<String> postPedidoVendaFechar( String login, String pedido,body){
   return openUrl('POST','/PedidoVenda.Fechar.Put?login=$login&pedido=$pedido',body);
 } 
 
//Retorna uma lista com os produtos que fazem parte do pedido
Future<String> getPedidoVendaItens( String login, String pedido, double filial, double estado){
   return openUrl('GET','/PedidoVenda.Itens.Get?login=$login&pedido=$pedido&filial=$filial&estado=$estado');
 } 
 
//Cancela um item do pedido com base no id do registro
Future<String> putPedidoVendaItemCancelar( String login, String pedido, String codigo, double id, String data, double filial, double ordem, double lote,body){
   return openUrl('PUT','/PedidoVenda.ItemCancelar.Post?login=$login&pedido=$pedido&codigo=$codigo&id=$id&data=$data&filial=$filial&ordem=$ordem&lote=$lote',body);
 } 
 
//Incluir complemento para o item
Future<String> postPedidoVendaComplemento( String login, String texto, double filial, String pedido, double ordem, String vendedor, String mesa, String terminal, double lote, String localterminal, String usuario,body){
   return openUrl('POST','/PedidoVenda.Complemento.Put?login=$login&texto=$texto&filial=$filial&pedido=$pedido&ordem=$ordem&vendedor=$vendedor&mesa=$mesa&terminal=$terminal&lote=$lote&localterminal=$localterminal&usuario=$usuario',body);
 } 
 
//Obtem dados do local de atendimento/lista
Future<String> getLocalAtendimento( String codigo){
   return openUrl('GET','/LocalAtendimento.Get?codigo=$codigo');
 } 
 
//Valida número da Mesa
Future<String> getNumeroMesaCheck( String codigo, double filial){
   return openUrl('GET','/NumeroMesa.Check?codigo=$codigo&filial=$filial');
 } 
 
//Imprimir a conta do cliente
Future<String> getImprimirConta( String login, String local, String conta, double pessoas){
   return openUrl('GET','/ImprimirConta.put?login=$login&local=$local&conta=$conta&pessoas=$pessoas');
 } 
 
//Obtem lista de mesas abertas
Future<String> getMesasAbertasList( double filial, DateTime data, String mesa, double estado){
   return openUrl('GET','/MesasAbertas.List?filial=$filial&data=$data&mesa=$mesa&estado=$estado');
 } 
 
//Trocar a comanda de mesa
Future<String> putComandaTrocarMesaUpdate( String login, String comanda, double filial, String antiga, String nova,body){
   return openUrl('PUT','/ComandaTrocarMesa.Update?login=$login&comanda=$comanda&filial=$filial&antiga=$antiga&nova=$nova',body);
 } 
 
//Obtem estatistica de venda do produto para 4 datas
Future<String> getVendaHoraria( String login, double filial, String codigo, DateTime data1, DateTime data2, DateTime data3, DateTime data4){
   return openUrl('GET','/VendaHoraria.Get?login=$login&filial=$filial&codigo=$codigo&data1=$data1&data2=$data2&data3=$data3&data4=$data4');
 } 
 
//Obtem formas de pagamento disponíveis
Future<String> getPedidoVendaFormaPgto( String login, String codigo, double filial){
   return openUrl('GET','/PedidoVenda.FormaPgto.Get?login=$login&codigo=$codigo&filial=$filial');
 } 
 
//Obtem meios da formas de pagamento disponíveis
Future<String> getPedidoVendaFormaPgtoMeios( String login, String codigo){
   return openUrl('GET','/PedidoVenda.FormaPgtoMeios.Get?login=$login&codigo=$codigo');
 } 
 
//Registrar cupom
Future<String> postVendaRegistrarCupom( String login, String cupomJson,body){
   return openUrl('POST','/Venda.RegistrarCupom.Post?login=$login&cupomJson=$cupomJson',body);
 } 
 
//Registrar pedido de venda
Future<String> postVendaRegistrarPedido( String login, String cupomJson,body){
   return openUrl('POST','/Venda.RegistrarPedido.Post?login=$login&cupomJson=$cupomJson',body);
 } 
 
//Registra solicitação de novo envio de NFCe e retorna o IDNFCe gerado para consulta posterior
Future<String> getGerarNFCe( String login, String dcto, String prtserie, String ecf, double filial, DateTime data, double ordem, String ambiente, String enviar){
   return openUrl('GET','/GerarNFCe.Put?login=$login&dcto=$dcto&prtserie=$prtserie&ecf=$ecf&filial=$filial&data=$data&ordem=$ordem&ambiente=$ambiente&enviar=$enviar');
 } 
 
//Retorna o estado da última transação efetuada
Future<String> getStatusNFCe( double idNFCe, String gid, String chave, String fields){
   return openUrl('GET','/StatusNFCe.Get?idNFCe=$idNFCe&gid=$gid&chave=$chave&fields=$fields');
 } 
 
//Retorna a lista de estados de consulta da NFCe
Future<String> getListaStatusNFCe( String chave, String fields){
   return openUrl('GET','/ListaStatusNFCe.Get?chave=$chave&fields=$fields');
 } 
 
//Registra solicitação de novo envio em contingência de NFCe e retorna o IDNFCe gerado para consulta posterior
Future<String> postGerarNFCeContingencia( String login, String dcto, String prtserie, String ecf, double filial, DateTime data, double ordem, String ambiente, String justificativa, String enviar,body){
   return openUrl('POST','/GerarNFCeContingencia.Put?login=$login&dcto=$dcto&prtserie=$prtserie&ecf=$ecf&filial=$filial&data=$data&ordem=$ordem&ambiente=$ambiente&justificativa=$justificativa&enviar=$enviar',body);
 } 
 
//Lista as NFCe em processamento por estado de processamento
Future<String> getListNFCe( String data, double estado, String filtro, String fields, String orderby){
   return openUrl('GET','/ListNFCe.Get?data=$data&estado=$estado&filtro=$filtro&fields=$fields&orderby=$orderby');
 } 
 
//Retorna a lista de log de uma NFCe
Future<String> getListNFCeLog( String gid, String chave, double id, DateTime data, String fields, String orderby){
   return openUrl('GET','/ListNFCeLog.Get?gid=$gid&chave=$chave&id=$id&data=$data&fields=$fields&orderby=$orderby');
 } 
 
//Retorna o arquivo XML gerado typ=(xml,json,redir)
Future<String> getNFCeXML( String gid, String chave, double id, String typ){
   return openUrl('GET','/NFCeXML.Get?gid=$gid&chave=$chave&id=$id&typ=$typ');
 } 
 
//Envia pedido de cancelamento de uma NFCe
Future<String> postCancelamentoNFCe( String login, String dcto, String prtserie, String ecf, double filial, DateTime data, double ordem, String motivo,body){
   return openUrl('POST','/CancelamentoNFCe.Put?login=$login&dcto=$dcto&prtserie=$prtserie&ecf=$ecf&filial=$filial&data=$data&ordem=$ordem&motivo=$motivo',body);
 } 
 
//Envia pedido de cancelamento de uma NFCe
Future<String> postCancelamentoNFCe2( String login, String gid, String chave, DateTime data, String motivo,body){
   return openUrl('POST','/CancelamentoNFCe2.Put?login=$login&gid=$gid&chave=$chave&data=$data&motivo=$motivo',body);
 } 
 
//Envia pedido de inutilizacao do número de uma NFCe
Future<String> postInutilizacaoNFCe( String login, double numerode, double numeroate, String serie, DateTime data, double filial, String motivo, String ambiente,body){
   return openUrl('POST','/InutilizacaoNFCe.Put?login=$login&numerode=$numerode&numeroate=$numeroate&serie=$serie&data=$data&filial=$filial&motivo=$motivo&ambiente=$ambiente',body);
 } 
 
//Configura ou obtem modo de operacao [modo in (none,on,off)]
Future<String> getContingenciaConfig( String login, String modo){
   return openUrl('GET','/Contingencia.Config?login=$login&modo=$modo');
 } 
 
//Obtem o Log do RestServer
Future<String> getLogs( String arquivo){
   return openUrl('GET','/Logs.Get?arquivo=$arquivo');
 } 
 
//Envia um XML para transmissão
Future<String> getNFCeProcessarXML( String xmltexto){
   return openUrl('GET','/NFCeProcessarXML.Post?xmltexto=$xmltexto');
 } 
 
//Envia link da NFCe para o destinatario Ex: mailto://xxxx@yyy.com
Future<String> getSendNFCe( String para, String gid, String chave){
   return openUrl('GET','/SendNFCe.post?para=$para&gid=$gid&chave=$chave');
 } 
 
//Enviar encerramento de dia NFCe
Future<String> getEncerrarDiaNFCe( String prtserie, DateTime data, double filial, String serie, String ambiente){
   return openUrl('GET','/EncerrarDiaNFCe.post?prtserie=$prtserie&data=$data&filial=$filial&serie=$serie&ambiente=$ambiente');
 } 
 
//Obtem dados da pessoa
Future<String> getUsuarios( String login, double codigo, String cnpj, String fone){
   return openUrl('GET','/usuarios?login=$login&codigo=$codigo&cnpj=$cnpj&fone=$fone');
 } 
 
//Obtem dados da pessoa
Future<String> getUsuariosList( String login, String nome){
   return openUrl('GET','/usuarios/list?login=$login&nome=$nome');
 } 
 
//Obtem acessos do usuario
Future<String> getUsuariosAcessos( String login, String usuario, double tipo){
   return openUrl('GET','/usuarios/acessos?login=$login&usuario=$usuario&tipo=$tipo');
 } 
 
//Consultar Status Operacional do SAT
Future<String> getSatConsultarStatusOperacional(){
   return openUrl('GET','/sat/ConsultarStatusOperacional.Get?');
 } 
  } 
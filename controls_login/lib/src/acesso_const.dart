// @dart=2.12
/// importado do acessoconst.pas em 30/09/2020 - AL

//mascara   aammiissrr
/*
   aa - aplicacao
   mm - Item do menu principal
   ii - subitem do menu principal
   ss - subitme do subitem do menu principal
   rr - recurso - ex: item de acesso dentro da janela
  */

const acesso_AcessoGrupoUsoGeral = -1;
const acesso_AcessoGrupoMateriaisSuprimentos = -2;

// ID de uso para todas as aplicacoes

const acesso_DesabilitaChecarPermissaoAcessoPorFilial = 1001;
const acesso_Geral_HabilitaUpperCapital = 1002;

// items do financiero - 01
// Financeiro-Arquivo
const acesso_cxBcoPodeAlterar = 0101010101;
const acesso_cxBcoPodeAlterarSdoInicial = 0101010102;
const acesso_CadCelulasPodeAlterar = 0101020001;
const acesso_PrcaCompensacaoPodeAlterar = 0101010201;
const acesso_CadAlineaPodeAlterar = 0101010301;
const acesso_CadPracaCobrancaPodeAlterar = 0101010401;
const acesso_CadTarifasBancariasPodeAlterar = 0101010501;
const acesso_CadPlanoContasPodeAlterar = 0101030101;

//Tarefa: 29107 - Leonardo - 06/06/2017
const acesso_RecebCobPermiteEnviarBaixarTituloOutroBanco = 0101030102;
const acesso_RecebCobPermiteEnviarBaixarTituloOutraFilial = 0101030103;

const acesso_CadCliForDadosCadastrais = 01010401;
const acesso_CadCliForPodeAlterar = 0101040101;
const acesso_CadCliForVisualizaDadosEntrega = 0101040102;
const acesso_CadCliForVisualizaDadosCobranca = 0101040103;
const acesso_CadCliForVisualizaComplemento = 0101040104;
const acesso_CadCliForVisualizaDadosFinanc = 0101040105;
const acesso_CadCliForVisualizaDadosCredito = 0101040106;
const acesso_CadCliForVisualizaReferencia = 0101040107;
const acesso_CadCliForPodeIncluir = 0101040108;

const acesso_CadCliForPodeTrocarSenhaCadastro = 0101040109;
const acesso_CadCliForPodeAlterarVendedor =
    0101040110; //,'Pode alterar o vendedor no cadastro',bloqueio);
const acesso_CadCliForPodeAlterarAgenteNegocio =
    0101040111; //,'Pode alterar o agente de negócio no cadastro',bloqueio);
const acesso_CadCliForPodeAcessarConectividade = 0101040112;
const acesso_CadCliForAlteraNivelBloqueio = 0101040113;
const acesso_CadCliForAlteraTabelaPreco = 0101040114;
const acesso_CadCliForTopicoAcessoBloqueioCredito =
    0101040115; // é um item de tópico. Habilita ou desabilita a checagem de crédito/Bloqueio.

//Aba Contratos
const acesso_CadCliForVisualizaContratos = 0101040116;
const acesso_CadCliForPodeAlterarContratos = 0101040117;
const acesso_CadCliForPodeImprimirContratos = 0101040118;

const acesso_CadCliForPodeImprimirDadosCadastro = 0101040119;

const acesso_CadCliForIntegridade =
    0101040600; //Grupo Verificação de Integridade.
const acesso_CadCliForPermiteCadastroSemIE =
    0101040601; //Forçar preenchimento do campo IE.
const acesso_CadCliForPermiteCadastroSemCNPJ =
    0101040602; //Forçar preenchimento do CNPJ.
const acesso_CadCliForPermiteCadastrarCNPJRepetido =
    010104603; //Permite cadastrar um CNPJ já cadastrado.
const acesso_CadCliForObrigaDadosNecessariosAoREDF =
    010104604; //{Tarefa: 8885 - Renata - 15/07/2008}
const acesso_CadCliForObrigaDadosNecessariosParaCobranca =
    010104605; //{Tarefa: 9561 - Vanderlei - 26/06/09}
//Tarefa: 11910 - Leonardo - 10/02/2014
const acesso_CadCliForPermiteCadastroSemFone = 010104606;
const acesso_CadCliForPermiteCadastroSemEMail = 010104607;
const acesso_CadCliForPodeInativarCliente = 010104608;
const acesso_CadCliForPodeAlterarDocumentos = 010104609;
const acesso_CadCliForPermiteCadastroSemRg =
    010104610; // Permite Cadastro sem RG Leandro tarefa 43486 29/04/2020

const acesso_CadTipoCadastroPodeAlterar = 0101040201;
const acesso_CadastrodeTipodeEstadodosTtulosPodeAlterar = 0101050001;
//Moeda
const acesso_CadastroDeMoedasPodeAlterar = 0101060001;
const acesso_CotaesdeMoedasPodeAlterar = 0101070001;
const acesso_HabilitaMoedaFluxoCaixa = 0101070002;
const acesso_PermiteAlteraValorMoedaFluxoCaixa = 0101070003;
const acesso_HabilitaAtualizacaoMonetariaTitulos = 0101070004;

// financeiro - trans entre contas
const acesso_TransfernciasdeValoresEntreFiliaisDiferentes = 01030501;

const acesso_TransfPermiteLctoComDataFutura = 01030502;
const acesso_TransfPermiteLctoComDataPassada = 01030503;

const acesso_EnviarDadosparaoPDV = 03030100;
const acesso_Acesso_EnviarDadosPDV_Cadastro_Produtos_Alterados = 0303010001;
const acesso_Acesso_EnviarDadosPDV_Cadastro_Produtos_Todos = 0303010002;
const acesso_Acesso_EnviarDadosPDV_Produtos_Promocao = 0303010003;
const acesso_Acesso_EnviarDadosPDV_Cesta_Produtos = 0303010004;
const acesso_Acesso_EnviarDadosPDV_Tabela_Precos = 0303010005;
const acesso_Acesso_EnviarDadosPDV_Cartoes_Tickets = 0303010006;
const acesso_Acesso_EnviarDadosPDV_SubGrupos = 0303010007;
const acesso_Acesso_EnviarDadosPDV_Caixas = 0303010008;
const acesso_Acesso_EnviarDadosPDV_Vendedores = 0303010009;
const acesso_Acesso_EnviarDadosPDV_Senhas = 0303010010;
const acesso_Acesso_EnviarDadosPDV_Controle_Acesso = 0303010011;
const acesso_Acesso_EnviarDadosPDV_Filiais = 0303010012;
const acesso_Acesso_EnviarDadosPDV_Condicoes_Pagamento = 0303010013;
const acesso_Acesso_EnviarDadosPDV_PAFECFDigital = 0303010014;

const acesso_ColetarDadosdosPDVs = 03030200;

const acesso_DigitaDadosFiscaisdaLeituraZ = 03031100;
const acesso_DigitaDadosFiscaisdaLeituraZPodeAlterarFilial = 03031101;
const acesso_DigitaDadosFiscaisdaLeituraZPodeFazerConferencia = 03031102;
const acesso_DigitaDadosFiscaisdaLeituraZPodeEstornarConferido = 03031103;

const acesso_ConfirmarecebimentodetransferenciaRomaneionaMatriz_ = 03031300;
const acesso_ConfirmarecebimentodetransferenciaRomaneionaMatrizVisuRelConf =
    0303130002;

const acesso_CadastrodeSenhasPodeAlterar = 0101800101;
const acesso_NivelAcessoPodeAlterar = 02160200;

// Finaceiro-contas
const acesso_LancamentosContasPodeAlterar = 01020101;
const acesso_LctoContasPodeInserirDados = 0102010101;
const acesso_LctoContasPodeAlterarDados = 0102010102;
const acesso_LctoContasPodeExcluirDados = 0102010103;
const acesso_LctoContasPodeBaixaComoPerda = 0102010104;
const acesso_LctoContasPodeAlterarVcto = 0102010105;
//  LctoContasPodeBaixaPagarComoPerda = 0102010105;
const acesso_LctoContasPodeExcluirTituloVendas = 0102010106;
const acesso_LctoContasPodeExcluirTituloCompras = 0102010107;
const acesso_LctoContasPodeAprovarReprovarLiquidacaoConta = 0102010108;
const acesso_ContasPermiteLiquidacaoContasDeFiliaisDiferentes = 0102010109;

const acesso_LctoContasPodeImprimir = 0102010110;
const acesso_ConstaLctoVerHistoricos = 0102010111;
const acesso_LctoContasPodeBaixaComoPerdaNegociada = 0102010115;
const acesso_LctoPerdaNecessarioIdentificarCelula = 0102010116;

const acesso_LancamentoCreditoPodeLancar = 0102100003;

const acesso_LctoContasPodeLiquidarDados = 0102010120;
const acesso_LctoContasPodeFazerEstornoLiquidacao = 0102010121;
const acesso_ContasLctoPodePorTituloCartorio = 0102010122;
const acesso_LctoContasPodeDevolverCheque = 0102010123;
const acesso_LctoContasPodeAlterarEstadoTitulo = 0102010124;
const acesso_LctoContasPodeAlterarDadosContabil = 0102010125;
const acesso_LctoContasPodeAlterarEstadoTituloUsandoEstadoSistema = 0102010126;
const acesso_LctoContasPodeEstornarTransferenciaCCorrenteFluxo = 0102010127;
const acesso_LctoContasPodeAlterarFilialPgtoAntecipadoNFFornecedor = 0102010128;
const acesso_LctoContasPodeAlterarTituloLiquidado = 0102010129;

const acesso_ContasLctoCarregaDadosContasReceber = 0102010130;
const acesso_ConstaLctoCarregaDadosContasPagar = 0102010131;
const acesso_ConstaLctoCarregaDadosOutrasFiliais = 0102010132;
//Tarefa 10313 - Calixto - 07/06/2010
const acesso_ContasRelContasFichadeCreditodeClienteLimiteCredito = 0102010133;
const acesso_ContasRelContasFichadeCreditodeClienteNivelBloqueio = 0102010134;

const acesso_LctoContasPodeLancarValorNegativo = 0102010135;

const acesso_LctoContasLiquidacao = 0102010136;
const acesso_LctoContasLiqPodeAjustarValor = 0102010137;
const acesso_LctoContasLiqPodeBaixarParcial = 0102010138;
const acesso_LctoContasLiqPodeBaixarComDescJuros = 0102010139;

const acesso_LctoContasPodeAlterarFilialTituloLancado = 0102010140;
const acesso_LctoContasPodeLancarCompensado = 0102010141;
const acesso_LctoContasCompensadoComoDefault = 0102010142;

//Tarefa 11118 - Calixto - 08/10/2012
const acesso_PagamentoFornecedoresAc = 01020300;
const acesso_PagamentoFornecedoresBDAc = 0102030001;
const acesso_PagamentoFornecedoresPodeLiquidarTituloNegativo = 0102030002;
const acesso_PagamentoFornecedoresPodeAjustarValor = 0102030003;
const acesso_PagamentoFornecedoresPodeLancarDesconto = 0102030004;
const acesso_PagamentoFornecedoresPodeLancarMulta = 0102030005;
const acesso_PagamentoFornecedoresPodeLancarAcrescimo = 0102030006;
const acesso_PagamentoFornecedoresPodeLancarPagParcial = 0102030007;
const acesso_PagamentoFornecedoresPodeUsarCheqTerceiro = 0102030008;
const acesso_PagamentoFornecedoresPodeVisualizarRelatorio = 0102030009;

const acesso_RecebimentodeClientesAc = 01020400;
const acesso_RecebimentodeClientesBDAc = 0102040000;
const acesso_RecContasClientePodeLiquidarTituloNegativo = 0102010240;
const acesso_RecContasClientePodeLancarDesconto = 0102010241;
const acesso_RecContasClientePodeLancarMulta = 0102010242;
const acesso_RecContasClientePodeLancarAcrescimo = 0102010243;
const acesso_RecContasClientePodeLancarRecParcial = 0102010244;
const acesso_RecContasClientePodeUsarAbatimentos = 0102010245;
const acesso_RecContasClientePodeUsarCheqTerceiros = 0102010246;
const acesso_RecContasClientePodeUsarCheqProprio = 0102010247;
const acesso_RecContasClientePodeUsarCartao = 0102010248;
const acesso_RecContasClientesPodeVisualizarRelatorio = 0102010249;

const acesso_PagEletronicoPodeLancarDataPgtoDiferenteVcto = 01020701;

const acesso_ContasBotaoMarcarDocumentos = 0102010150;
const acesso_ContasDocumentosBotaoHabilitado = 0102010151;

const acesso_LanamentosdeCaixaeBancosPodeAlterar = 0103010001;
const acesso_CtaCorrPodeInserirDados = 0103010002;
const acesso_ctaCorrPodeAlterarDados = 0103010003;
const acesso_ctaCorrPodeExcluirDados = 0103010004;
const acesso_ctaCorrPodeAlteraDataLcto = 0103010005;
const acesso_ctaCorrPodeAlteraDadosContabeis = 0103010006;
const acesso_CtaCorrPodeCarregaDadosOutrasFiliais = 0103010007;
const acesso_CtaCorrPodeImprimir = 0103010008;
const acesso_CtaCorrPodeLctoCaixaEncerrado = 0103010009;
const acesso_CtaCorrPodeLctoTituloVendas = 0103010020;
const acesso_CtaCorrPodeLctoTituloCompras = 0103010021;
const acesso_CtaCorrPodeLiberarLimiteCreditoConvenio = 0103010022;
const acesso_CtaCorrPodeLancarValorNegativo = 0103010023;
const acesso_CtaCorrPodeAlterarEstadoCompensado = 0103010024;
const acesso_CtaCorrCompensadoComoDefault = 0103010025;

const acesso_FinPosCaixaVeContasPagar = 01030305;
const acesso_FinPosCaixaVeContasReceber = 01030306;
//Tarefa 11141
const acesso_FinEncerrarCxPodeExcluirDataEncerrada = 0103100001;

const acesso_FinEncerrarMvtoPodeExcluirDataEncerrada = 0103040001;

// Ficha de Credito de Cliente
const acesso_FinFichaCreditoCliente = 0102120001;
const acesso_FinFichaCreditoClienteBD = 010201010101;

// items do estoque - 02
const acesso_EstAjustePercentPrecoPermitePrecoPend = 02130201;

// cadastro de produtos
const acesso_GrupoCadProdutosAcesso = -0201;
const acesso_CadProdutosAcesso = 2;
const acesso_CadProdTemAcesso = 02131011;
const acesso_CadProdPodeAlterar =
    021310100; //,CadastroPrincipaldoProduto1, nil, nil, OutBar1.Pages[2].Items[0]) do
const acesso_CadProdPodeIncluirCadastro =
    021310101; //,'Pode incluir novo cadastro');
const acesso_CadProdPodeExcluirCadastro =
    021310103; //,'Pode excluir um cadastro');
const acesso_CadProdPodeAutoEdit = 021310104;
const acesso_CadProdPodeFazerAlteracaoEmLote = 021310105;
const acesso_CadProdPodeDigitarMinusculo = 021310106; //Pode DigitarMinusculo
const acesso_CadProdDesativaOpcaoPrVendaSair =
    021310107; //Desativa opção Altera preços de venda ao sair do Cadastro de Produtos
const acesso_CadProdPodeAlterarPrecoVenda =
    021310111; //,'Pode alterar o preço de vendas').TornaDesabilitado;
const acesso_CadProdPodeAlterarMargemLucro =
    021310112; //,'Pode alterar margem de lucro').TornaDesabilitado;
const acesso_CadProdPodeAlterarCustoAquisicao =
    021310113; //,'Pode alterar custo de aquisição').TornaDesabilitado;
const acesso_CadProdPodeAlterarCustoImportado = 021310114;
const acesso_CadProdPodeAlterarCustoTransf = 021310115;
const acesso_CadProdPodeAlterarFornecedorProduto = 021310116;
const acesso_CadProdPodeAlterarComissao = 021310117;
const acesso_CadProdPodeAlterarEstoqueInicial = 021310118;
const acesso_CadProdPodeAlterarPrecoPorFilial = 021310119;
const acesso_CadProdPodeAlterarFatorSimuladorPrecos = 021310120;
const acesso_CadProdPodeVerAbaComplemento =
    021310121; //,'Pode visualizar a aba complemento');
const acesso_CadProdPodeVerAbaCustos =
    021310122; //,'Pode visualizar a aba custos');
const acesso_CadProdPodeVerAbaEstoque =
    021310123; //,'Pode visualizar a aba estoque');
const acesso_CadProdPodeVerAbaObras =
    021310124; //,'Pode visualizar a aba obras');
const acesso_CadProdPodeVerAbaLojVirt =
    021310125; //,'Pode visualizar a aba loja virtual');
const acesso_CadProdPodeVerAbaMisc =
    021310126; //,'Pode visualizar a aba misc');
const acesso_CadProdPodeVerAbaImportados =
    021310127; //,'Pode visualizar a aba importados');
const acesso_CadProdPodeVerAbaSimilares =
    021310128; //,'Pode visualizar a aba similares');
const acesso_CadProdPodeColarProduto =
    021310129; //Pode utilizar botão Colar de outro produto.
const acesso_CadProdPodeVerAbaFiscal = 021310130;
const acesso_CadProdPodeVerAbaImagem = 021310131; //Pode visualizar a aba Imagem
const acesso_CadProdPodeVerAbaRestaurante =
    021310132; //Pode visualizar a aba Restaurante
const acesso_CadProdAlteraDadosCustosProdutosFilhos =
    021310133; // utilizado para repassar para produtos CODFINAL QTDEFINAL os custos do PAI
const acesso_CadProdAlteraPrecoVendaAProdutosFilhos =
    021310134; // utilizado para repassar para o filho a alteração do preço de venda
//Tarefa 10868 - Calixto - 14/06/2011
const acesso_CadProdDefinirDetalhesPorFilial = 021310135;
const acesso_CadProdHabilitaDetalhesPorFilial = 021310136;
const acesso_CadProdHabilitaAbaCombustivel = 021310137;
const acesso_CadProdHabilitaAbaGrupoFilial = 021310138;
const acesso_CadProdPodeVerTabelaNutricional =
    021310139; //Pode visualizar a aba Imagem
const acesso_CadProdPodeAlterarDadosCombustivel = 021310140;
//Referente tarefa 42437 Josiel
const acesso_CadProdHabilitaAbaBalanca = 021310141;
const acesso_CadProdHabilitaAbaConfigNatRec = 021310142;
//Constantes estavam duplicadas
const acesso_CadProdPodeCadastrarProdutoAssociado = 021310143;
const acesso_CadProdPodeDefinirPoliticaDistribuicaoProdutos = 021310144;
const acesso_CadProdPodeCadastrarPet = 021310145;

const acesso_CadProdPodeCadastrarItemSemMargemPrecoVarejo = 0213000301;
const acesso_CadProdPodeCadastrarItemSemMargemPrecoAtacado = 0213000302;
const acesso_CadProdPodeCadastrarItemSemMargemPrecoRevenda = 0213000303;
const acesso_CadProdPodeCadastrarItemSemMargemPrecoTransferencia = 0213000304;
const acesso_CadProdPodeCadastrarItemSemMargemPrecoLojaVirtual = 0213000305;

// janela de cosulta de cadastro de produto
const acesso_CadProdPodeConsultarSaldoEstoque =
    02131012901; // F4 para consutla saldo de estoques
const acesso_cadProdPodeConsultarProdutosSimilares =
    02131012902; // F5 para consulta similares.
const acesso_CadProdPodeConsultarStatusProduto =
    02131012903; //F7 consulta Status Produto.
const acesso_CadProdPodeConsultarSaldoEstoqueGrade =
    02131012904; //F3 para consutla saldo de estoque grade

// verificacao de integridade no cadastro de produto
const acesso_CadProdPermiteCadastroSemGrupo = 02131013001;
const acesso_CadProdPermiteCadastroSemSetor = 02131013002;
const acesso_CadProdPermiteCadastroSemFamilia = 02131013003;
const acesso_CadProdPermiteCadastroSemFornecedor = 02131013004;
const acesso_CadProdPermiteCadastroSemICMS = 02131013005;
const acesso_CadProdPermiteCadastroSemIPI = 02131013006;
const acesso_CadProdPermiteCadastroSemPISCOFINS = 02131013007;
const acesso_CadProdPermiteCadastroSemEditora = 02131013008;
//Tarefa 11091 - Leonardo - 05/03/2012
const acesso_CadProdPermiteCadastroSemCSTIPI = 02131013009;
const acesso_CadProdPermiteCadastroSemCSTPIS = 02131013010;
const acesso_CadProdPermiteCadastroSemCSTCOFINS = 02131013011;
const acesso_CadProdPermiteCadastroSemGenero = 02131013012;
const acesso_CadProdHabilitaAbaServicos = 02131013013;

const acesso_StatProduto = 02131012;
const acesso_CadCategorias = 02131013;
const acesso_CadProdutosAssociados = 02131014;
const acesso_AltCodigodoProduto = 02131015;
//CadGrupos = 02131016;
//CadSetores = 02131017;
//CadFamiliasProdutos = 02131018;
const acesso_CadCestaProdutos = 02131019;
//Não usar a 02131020
const acesso_CadGrupoAtalhosLojaVirtual = 021310200;
const acesso_CadMarca = 02131021;
const acesso_CadAutor = 02131022;
const acesso_CadEditora = 02131023;
const acesso_CadAssunto = 02131024;
const acesso_CadUnidade = 02131025;
const acesso_CadTipoItemMercadoria = 02131026;
const acesso_CadastrodeFatoresdeFornecedores = 02131027;
const acesso_CadPISCOFINS = 02131028;
const acesso_CadastroCSTIPI = 02131029;
const acesso_CadastrodeNCMNBM = 02131030;
const acesso_CadastroDeCEST = 02131031;

const acesso_FormacaoPrVendaPodeAlterarFatorSimuladorPrecos = 021451000;

const acesso_CadClassFiscalPodeAlterar = 02145000;
//CadTributaoICMS = 02144000;
//CadPISCOFINS = 02146000;
const acesso_CadFichadeproduoexplosaodeprodutos1 = 02147000;
const acesso_Manupolticadeestocagem1 = 02148000;
const acesso_Conf1 = 02150000;
const acesso_RevCdigosdeOperaodoSistema1 = 02151000;
const acesso_CadClassifFiscalIPI = 02152000;
const acesso_CadICMSSubstituicaoTributariaSujAtivo = 02153000;
const acesso_ConfiguraSkin = 02154000;

const acesso_Transfernciaentrefiliaisdeprodutosconsignados = 02205200;

const acesso_TransfernciadeEstoqueentreFiliais = 02207000;

const acesso_AjustePeloColetorPodeAjustarQtdeColetor =
    0220830001; //Tarefa 12667 - Calixto

const acesso_TranfPodeTransferirItemSemSaldoConsignado = 02205201;
const acesso_TranfPodeEfetivarTransferenciaConsignado = 02205202;

const acesso_AcessoPrecoPendente = 02206000;
const acesso_PrecoPendPodeAlterarDados = 02206001;
const acesso_PrecoPendPodeConfPreco = 02206002;
const acesso_PrecoPendPodeAlterarDadosDeCustos = 02206003;
const acesso_PrecoPendPodeAlterarNovoPreco = 02206004;
const acesso_PrecoPendPodeBaixarPreco = 02206005;
const acesso_PrecoPendPodeConfirmarTodos = 02026006;
const acesso_PrecoPendPodeBaixarTodos = 02026007;
const acesso_PrecoPendPodePodeAlterarParamCadastro = 02026008;
const acesso_PrecoPendPodePodeConfirmarPrecoVarejo = 02026010;
const acesso_PrecoPendPodePodeConfirmarPrecoAtacado = 02026011;
const acesso_PrecoPendPodePodeConfirmarPrecoRevenda = 02026012;
const acesso_PrecoPendPodePodeAcessarOutrasFiliais = 02026020;
const acesso_PrecoPendPodeAlterarDtNovoPreco = 02026021;
const acesso_PrecoPendAlteraCadastroProd_MargemGrid = 02026022;

const acesso_AjustedoSaldodeEstoque = 02202000;

const acesso_CTe = 02204100;
const acesso_AcessoEntradasMercadorias = 02203000;
const acesso_EntrMercadoriaPodeAlterar = 02203001;
const acesso_EntrMercadoriaPodeIncluirReg =
    02203002; //,'Pode incluir nova entrada de mercadoria',bloqueio);
const acesso_EntrMercadoriaPodeAlterarReg =
    02203003; //,'Pode alterar uma entrada de mercadoria',bloqueio).TornaDesabilitado;
const acesso_EntrMercadoriaPodeExcluirReg =
    02203004; //,'Pode estornar uma entrada de mercadoria',bloqueio).TornaDesabilitado;
const acesso_EntrMercadoriaPodeConfirmarReg =
    02203010; //,'Pode confirmar em entrada de mercadoria',bloqueio);
const acesso_EntrMercadoriaPodeEstornar = 02203011;
const acesso_EntrMercadoriaPodeCaptPedidoCompras = 02203012;
const acesso_EntrMercadoriaPodeCaptEntrAlmox = 02203013;
const acesso_EntrMercadoriaPodeEntrarProdutoBaixaOutroCodigo =
    02203014; //AL Tarefa 2244 27/08/2004
const acesso_EntrMercadoriaPodeConfirmarComPendencia =
    02203015; //Tarefa 3175, 08/04/2005, FTonon.
const acesso_EntrMercadoriaPodeConfirmarComValorZero =
    02203016; //Tarefa 5697, Gravex, 21/11/05 FTonon.
const acesso_EntrMercadoriaPodeAcessarDigitadoOutroUsuario =
    02203017; // AL 15/03/06 - Supermercado Norte - Alexandre
const acesso_EntrMercadoriaPodeLancar =
    02203018; //{(Douglas - 11/2006) Tarefa 6471 - Usado na Brasileira.}
const acesso_EntrMercadoriaPodeEstornarLancado =
    02203019; //{(Douglas - 11/2006) Tarefa 6471 - Usado na Brasileira.}
const acesso_EntrMercadoriaAbrirJanelaPrecoPend =
    02203020; //{(FTonon - 02/07/2007) Tarefa 8286 - Para a Graciosa}
const acesso_EntrMercadoriaDesabilitaChecagemSintegra =
    02203021; // AL - 20/2/08 - checa validade dos dados para sintegra.
const acesso_EntrMercadoriaPodeAlterarData =
    02203022; //Tarefa 9342 - Calixto - 13/02/2009
const acesso_EntrMercadoriaBotaoCadastroProduto =
    02203023; //Tarefa 9747 - Calixto - 21/09/2009
const acesso_EntrMercadoriaTransferenciaFilialDistribuicao =
    02203024; //Tarefa 9747 - Calixto - 21/09/2009
const acesso_EntrMercadoriaPodeAtivarProdutoInativo =
    02203025; // Leonardo - Tarefa 10799 - 03/05/2012
const acesso_EntrMercadoriaPodeInserirProdInativoDigManual =
    02203026; // Tarefa 10953 - Calixto - 20/12/2012
//  EntrMercadoriaTransferenciaFilial               = 02203027; // Tarefa 11230 - Calixto - 23/12/2012
//  EntrMercadoriaTransferenciaFilial_Consig        = 02203028; // Tarefa 11230 - Calixto - 23/12/2012
const acesso_EntrMercadoriaEmissaoEtiq =
    02203029; // Tarefa 11230 - Calixto - 23/12/2012
const acesso_EntrMercadoriaTransferenciaFilial_AgruparNF =
    02203030; // Tarefa 11230 - Calixto - 23/12/2012
const acesso_EntrMercadoriaTransferenciaFilial_Auto =
    02203031; // Tarefa 11230 - Calixto - 23/12/2012
const acesso_EntrMercTransfFilial_UsaFilialDeposito_Destino =
    02203032; // Tarefa 11230 - Calixto - 23/12/2012

const acesso_EntrMercadoriaChecaOperacaoPedido =
    02203033; // Tarefa 10706 - Calixto - 23/01/2013
const acesso_EntrMercadoriaConfDadosFiscais =
    02203034; // Tarefa 11404 - Calixto - 08/04/2013

const acesso_EntrMercadoriaChecaNcmDiferenteXML =
    02203035; // Tarefa 28035 - Leonardo - 17/10/2016

const acesso_EntrMercCapturaNFeAlterarClassFisc = 022032001;
const acesso_EntrMercCapturaNFeAlterarFornec = 022032002; //Tarefa 12422

const acesso_ManFichaPodeAlterar =
    02201001; //, FichadeEstoque1, nil, speedItem1, OutBar1.Pages[1].Items[0]) do
const acesso_ManFichaPodeIncluirRegistro =
    02201002; //, 'Pode incluir um novo lançamento', bloqueio);
const acesso_ManFichaPodeAlterarData =
    02201003; //, 'Pode alterar a data de lançamento', bloqueio).TornaDesabilitado;
const acesso_ManFichaPodeEstornar =
    02201004; //, 'Pode estornar lançamento', bloqueio).TornaDesabilitado;
const acesso_ManFichaPodeInserirProdutoInativo = 02201005;
const acesso_ManFichaPodeDigitarPrecoUnitario = 02201006;
const acesso_ManFichaPodeAlterarData_Manual = 02201007;
const acesso_ManFichaPodeEstornar_Manual = 02201008;

const acesso_ManFichaLancamentoUsoConsumo = 02201100;
const acesso_ManFichaLancamentoQuebraXPerda = 02201101;

const acesso_ManConsgCpraPodeAlterar = 02205001;
const acesso_ManConsgCpraPodeIncluirRegistro = 02205002;
const acesso_ManConsgCpraPodeAlterarData =
    02205003; //,'Pode alterar a data de lançamento',bloqueio).TornaDesabilitado;
const acesso_ManConsgCpraPodeEstornar =
    02205004; //,'Pode estornar lançamento',bloqueio).TornaDesabilitado;

const acesso_AcertoPodeAlterarQtde = 02205102;
const acesso_AcertoUsaFiltroBusca = 02205103;
const acesso_AcertoPodeExcluirItem = 02205104;
const
    //Tarefa 10798 - Calixto - 02/03/2011
    AcertoDevPodeAlterarQtde = 02205302;
const acesso_AcertoDevUsaFiltroBusca = 02205303;
const acesso_AcertoDevPodeExcluirItem = 02205304;

const acesso_PedCprasPodeAlterarPedido = 02230001;
const acesso_PedCprasPodeEncerrarPedido = 02230002;
const acesso_PedCprasPodeReabrirPedido = 02230003;
const acesso_PedCprasPodeExcluirPedido = 02230004;
const acesso_PedCprasChecaQtdeEmbalNoPedidoCompras = 02230005;
const acesso_PedCprasPodeAlterarPedidoOutroUsuario = 02230006;
const acesso_PedCprasPodeInserirProdutoInativo = 02230007;
const acesso_PedCprasPodeVisualizarContasFornec = 02230008;
const acesso_PedCprasObrigatorioOperacao = 02230009;
const acesso_PedCprasIncluiProdutosEstoqueMinimo_Estoque = 02230010;
const acesso_PedCprasPodeAlterarPedidoDataAnterior = 02230011;

//Transferencia entre filiais
const acesso_TransfPodeTransferirItemSemSaldo = 02207001;
const acesso_TransfPodeEfetivarTransferencia = 02207002;
//  {Tarefa: 8967 - Renata - 20/08/2008}
const acesso_TransfPodeVisualizarPrecoCusto = 02207003;
//Tarefa 9650 - Calixto - 06/08/2009
const acesso_TransfPodeAlterarDadosCaptura = 02207004;
const acesso_TransfPodeAlterarQtdeCaptura = 02207005;
const acesso_TransfPodeTransferirParaFilialSemAcesso = 02207006;
const acesso_TransfPodeTransferirItemGradeSemSaldo = 02207007;
const acesso_TransfUsaFilialCorrenteFilialOrigem = 02207008;
const acesso_TransfVisualizaRelConf = 02207009;
const acesso_TransfPodeInserirItemRepetido = 02207010;

//Tarefa 10557 - Calixto - 06/10/2010
const acesso_DefPoliticaDistribPodeAlterarDiasEstMax = 022500001001;
const acesso_DefPoliticaDistribPodeAlterarDiasEntrega = 022500001002;
const acesso_DefPoliticaDistribPodeAlterarDiasSeguranca = 022500001003;
const acesso_DefPoliticaDistribPodeAlterarEstMaxQtde = 022500001004;
const acesso_DefPoliticaDistribPodePersonalizarGrid = 022500001005;
const acesso_DefPoliticaDistribVisualizaGrupoFilialMatriz = 022500001006;
const acesso_DefPoliticaDistribPodeAlterarPeriodicidade = 022500001007;
const acesso_DefPoliticaDistribPodeAlterarReparteAuto = 022500001008;
const acesso_DefPoliticaDistribPodeAlterarEmLote = 022500001009;
const acesso_LevtoDistribPodeDigitarAcimaSdoEstoque = 022600002002;
const acesso_LevtoDistribPodeAgregarRomaneiosExistentes = 022600002003;
const acesso_LevtoDistribAbreAutomaticamenteFiltro = 022600002004;

const acesso_TransfFilialDistribPodeAlterarFiliais = 022800004002;
const acesso_TransfFilialDistribPodeIncluirItens = 022800004003;
const acesso_TransfFilialDistribPodeExcluirItens = 022800004004;
const acesso_TransfFilialDistribPodeConfirmarTransf = 022800004005;
const acesso_TransfFilialDistribPodeTransferirItemSemSaldo = 022800004006;
const acesso_TransfFilialDistribPodeTransferirParaFilialSemAcesso =
    022800004007;
const acesso_TransfFilialDistribPodeEstornarConferido = 022800004008;
const acesso_TransfFilialDistribPodeConferidoTodos = 022800004009;
const acesso_TransfFilialDistribPodeExcluirTransf = 022800004010;

//Tarefa 10578 - Calixto - 19/10/2010
//  TransfFilialDistribPodeDigitarQtdeMaior = 022300004006;

const acesso_TransfFilialDistribPodeDigitarQtdeMaior = 0229000050;
const acesso_TransfFilialDistribPodePersonalizarGrid = 0229000051;
const acesso_TransfFilialDistribPodeAlterarCFOP = 0229000052;

const acesso_LevantamentoComprasPodeAlterarFator = 023000001002;
const acesso_LevantamentoComprasVisualizaGrupoFilialMatriz = 023000001003;
const acesso_LevantamentoComprasAbreAutomaticamenteFiltro = 023000001004;

const acesso_PedCprasSinteticoPodeCadastrarAlterarEmail = 023100002002;

const acesso_PedCprasPodePersonalizarGrid = 0232000040;

const acesso_Cuponspendentes = 03040504;

//Relatorios

//Relatorios de Estoque
const acesso_app_estoques = 02;
const acesso_ListaProdutosFalta = 02320010;
const acesso_ListagemPosicaoEst = 02320020;
const acesso_MovimentoEstSint = 02320030;
const acesso_MovimentoEstSint_dia = 02320040;
const acesso_ListadeEstoqueCorrentexPreodeAquisio = 02320050;
const acesso_ListadeEstoquexCustoFOBporFornecedor = 02320060;
const acesso_RelatriodeEstoquexCustoFOBSinttico = 02320070;
const acesso_RelatriodeEstoquesxPreoVenda = 02320080;
const acesso_RelatriodeEstoquesxCustoFobxVenda = 02320090;
const acesso_ValidadedeProdutos = 02320100;
const acesso_TransfernciaentrefiliaisPorData = 02320101;
const acesso_InventriodeProdutoseMercadorias = 02320102;
const acesso_Inventriocomparativo2datas = 02320103;
const acesso_GirodeMercadorias = 02320104;
const acesso_MovimentodeEstoqueporOperao = 02320105;
const acesso_Livroregistrodeinventrio = 02320106;
const acesso_PosiodeEstoqueAnalticoPMdioPorFornecedor = 02320107;
const acesso_PosiodeEstoqueAnalticoPMdioPorSetor = 02320108;
const acesso_PosiodeEstoqueAnalticoPMdioPorSubGrupo = 02320109;
const acesso_PosiodeEstoqueAnalticoPMdioPorCdigo = 02320110;

// items do supervisor -03
const acesso_supPodeConfigurarSerasa = 03000002;
const acesso_supPodeVerRelatorioComissao = 03000010;
const acesso_supPodeVerRelatorioComissaoVendaDiaria = 03000011;
const acesso_supPodeVerRelatorioComissaoVendaSintetica = 03000012;
const acesso_supPodeVerRelatorioComissaoVendaPorFinalizadora = 03000013;
const acesso_supPodeVerRelatorioComissaoVendaPorVencimento = 03000014;
const acesso_supPodeVerRelatorioComissaoVendaPorOperacao = 03000015;

const acesso_supConsultadaPosiodeEstoques = 03010300;

const acesso_supPodeAlterarOperadorQuebraCaixa = 03020101;

const acesso_supPodeAlterarOperadorAjusteMeioPgtoCaixa = 03021001;
const acesso_supPodeAlterarCaixaAjusteMeioPgtoCaixa = 03021002;
const acesso_supObrigInfoClienteAjusteMeioPgtoCaixa = 03021003;
const acesso_supObrigInfoClientePrazoAjusteMeioPgtoCaixa = 03021004;
const acesso_supObrigInfoClienteCheqAjusteMeioPgtoCaixa = 03021005;

const acesso_supPodeAlterarOperadorLanamentodeSuprimentoSangria = 03020501;
const acesso_supPodeLancarSuprimentoQuebradeCaixa = 03020502;
const acesso_supPodeLancarSangDinQuebradeCaixa = 03020503;
const acesso_supPodeLancarSangPrazoQuebradeCaixa = 03020504;
const acesso_supPodeLancarSangChequeQuebradeCaixa = 03020505;
const acesso_supPodeLancarSangCartaoPosQuebradeCaixa = 03020506;
const acesso_supPodeLancarSangOutrosQuebradeCaixa = 03020507;
const acesso_supPodeLancarSangTefQuebradeCaixa = 03020508;
const acesso_supPodeLancarSangTicketQuebradeCaixa = 03020509;

const acesso_supPermiteLctoComDataFutura = 03020510;
const acesso_supPermiteLctoComDataPassada = 03020511;

const acesso_supPodeAlterarHistTransfernciasValoresentreContas = 03020801;

const acesso_supPodeHabilitarComandas = 030312021;

const acesso_supPodeEditarDadosGridEtiq = 0301011001;
// Tarefa 11880 - Leonardo - 12/02/2014
const acesso_supUsaQtdeNotaParaQtdeEtq = 0301011002;
// Tarefa: 12073 - Leonardo - 13/11/2014
const acesso_supUsaLancamentoPrecoFuturoEtq = 0301011003;

const acesso_supPodeEstornarVdaExpedida = 0302110001;
const acesso_supPodeExpedirVendaComDiferenca = 0302110002;

const acesso_supPodeDigitarTempoeTemperatura = 0302020001;
//Tarefa: 22894 - Leonardo - 10/05/2015
const acesso_supPodeUsarPrecoAQTabeladePreco = 0302030002;

const acesso_supMenuGerencia = 030500000;
const acesso_supConfiguracoes = 030500001;

// items de vendas -04
const acesso_venPodeAcessarAplicativo = 04000001;
const acesso_VenUsaVendedorDoCadastroCliente = 04000002;
const acesso_VenPodeAlterarVendedor = 04000003;
const acesso_VenPodeFazerVendaSemCliente = 04000004;
const acesso_VenPodeConcederDescontoVenda = 04000005;
const acesso_VenPodeConcederDescontoAcimaDoPermitido = 04000006;
const acesso_VenPodeIncluirAcrescimoVenda = 04000007;
const acesso_VenPodeConcederDescontoNoItem = 04000008;
const acesso_VenPodeConcederDescontoNoItemAcimaDoPermitido = 04000009;
const acesso_VenPodeAlterarFormPgtoProvenientePedido = 04000010;
const acesso_VenVisualizaPedidosOutrasFiliais = 04000011;
const acesso_VenPodeAlterarTipoFrete = 04000012;
const acesso_VenPodeEmitirEtiqueta = 04000013;
// Tarefa: 20887 - Leonardo - 28/03/2016
const acesso_VenPermiteVendaSemIdentificarVendedor = 04000014;
// Tarefa: 17872 - Leonardo - 23/05/2016
const acesso_VenPermiteCancelarVendaDiaAnterior = 04000015;

// Tarefa: 12796 - Leonardo - 15/09/2015
const acesso_VenPodeEmitirNotaFiscal = 04000020;
const acesso_VenPodeEmitirRomaneioDeEntrega = 04000021;
const acesso_VenPodeEmitirImpressoDosItens = 04000022;
const acesso_VenPodeEmitirDuplicata = 04000023;
const acesso_VenPodeEmitirComprovanteDeVenda = 04000024;
const acesso_VenPodeEmitirBoletosAvulsos = 04000025;
const acesso_VenPodeAbrirRelCompartilhado = 04000026;
const acesso_VenPodeAcessarTrocaUsuario = 04000027;
const acesso_VenPodeEmitirBoletoBancario = 04000028;
const

    // items de devolucao de vendas; -05
    DevVendPodeAcessarDevVenda = 05010000;
const acesso_DevVenPodeDigitarPrecoUnit = 05000001;
const acesso_DevVenPodeAlterarDataDev = 05000002;
const acesso_DevVenPodeCacelarDevComOutroData = 05000003;
const acesso_DevVenPodeFinalDevCreditoVendPreenchido =
    05000004; // Leandro tarefa 43154 04/03/2020

const acesso_DevVendChecarValorPermitidoPDevolucao = 05000010;
const acesso_DevVendEmiteNotaFiscal = 05001101;
const acesso_DevVendEmiteDocumentoDevolucao = 05001102;
const acesso_DevVendEmiteValeCredito = 05001103;
const acesso_DevVendGerarControleValeCredito = 05001104; //Tarefa 11298
const acesso_DevVendaEmiteDev = 05001105;
const acesso_DevVendaPodeReimprimirValeCredito = 05001106; //Tarefa 11349
const acesso_DevVendaPodeEmitirDevValeApenasDctoCapturado =
    05001107; //Tarefa 11624

//Tarefa: 12237 - Leonardo - 25/07/2014
const acesso_FatCapturaCupomFiscal = 06200001;
const acesso_FatCapturaAcertoDeConsignacao = 06200002;
const acesso_FatCapturaTransferenciaDeMercadorias = 06200003;
const acesso_FatCapturaNotaFiscalCancelada = 06200004;

// items de FatEditor -06
//Tarefa 10057 - Calixto - 05/02/2010
// FatPodeAlterarDadosClienteIdentificado        = 06201001;
const acesso_FatPodeAlterarNomeProduto = 06201002; //Tarefa 11199
const acesso_FatPodeCancelarNF = 06201003;
const acesso_FatAtualizaPesoBrutoLiquido = 06001003; //Tarefa  11276
const acesso_FatPodeAlterarTipoFrete = 06001004; //Tarefa  11476
const acesso_FatPodeDigitarVctoInferiorEmissao = 06001005; //Tarefa  12316
const acesso_FatPodeDigitarVctoSuperiorEmissao = 06001006; //Tarefa  12316
const acesso_FatPodeAlterarIndicadorPresenca = 06001007;

const acesso_FatPodeAlterarDadosItensNota = 06203001;
//Tarefa: 28018 - Leonardo - 20/09/2016
const acesso_FatMantemCfopModeloCadastrado = 06203002;

const acesso_FatPodeAlterarVencimentoBoleto = 06204001;
const acesso_FatEmiteBoletoBancario = 06204002;

const acesso_FatAjustaNumeroControleModelo = 06206000;
//Alterado para parte de comum
//FatEmitirNotaFiscalEletronica = 06205000;

//  - 07

// items do Encomenda - 08
const acesso_EncPodeAcessarEncomenda = 08000000;
const acesso_EncPodeAcessarAppEncomenda = 08000001;

const acesso_EncPodeAcessarManutencao = 08020100;
const acesso_EncPedeLoginParaMudarJanela = 08020101;
const acesso_EncPodeCancelarComandaOuItem = 08020102;
const acesso_EncPodeExcluirItem = 08020103;
const acesso_EncPodeAlterarEncomendaImpressa = 08020104;
const acesso_EncHabilitaQtdePreenchidaEmNovaEncomenda = 08020105;
const acesso_EncVisualizarAntesImprimir = 08020106;
const acesso_EncHabilitaAlteracaoPrecoDeItemNaEncomenda = 08020107;

const acesso_EncPodeAcessarRecolhaRevista = 08020200;
const acesso_EncCadastroLocalArmazenamento = 08020500;
const acesso_EncCadastroEstadosProducao = 08020600;

const acesso_idAcessoMenuEncomendas = 08030000;
const acesso_EncPodeAcessarAcompanhamento = 08030100;
// pede login
const acesso_EncPedeLoginParaEntrarAcompanhamento = 0803010001;
const acesso_EncPedeLoginParaTransferirParaDelivery = 0803010002;
const acesso_EncPedeLoginParaTransferirParaComanda = 0803010003;
const acesso_EncPedeLoginParaAlterarDataExpedicao = 0803010004;
const acesso_EncPedeLoginParaExportarEncomenda = 0803010005;
const acesso_EncCarregaAutomaticoPaginaInicial = 0803010006;
const acesso_EncEmiteNotaFiscalAoFecharCarrinho = 0803010007;

const acesso_EncAcompPermiteRebaixarUmEstado = 08030101;
const acesso_EncAcompPermiteQtdeProducaoAnsteImprimirOS = 08030102;
const acesso_EncAcompPermiteArmazenarAntesQtdeProducao = 08030103;
const acesso_EncAcompPermiteAlterarArmazenamentoParaConcluidos = 08030104;
const acesso_EncAcompPermiteAlterarQtdeParaConcluidos = 08030105;
//  EncPermiteLocalArmazenamentoAutomatico = 08030106;
const acesso_EncAcompAutomaticoDadosDoGrid = 08030107;
const acesso_EncAcompPermiteAlterarQtdeDataAnterior = 08030108;
const acesso_EncPodeAumentarEstadodoItem = 08030109;
const acesso_EncPedPodeAumentarEstadodoItem = 08030110;
const acesso_EncAcompPodeAlterarQtdeItemDeRemessa = 08030111;
const acesso_EncAcompPodeAlterarQtdeItemComRemessa = 08030112;
const acesso_PedAcompPodeAlterarQtdeItemComRemessa = 08030113;

// Aplicativo Pedido de Vendas
const acesso_PedAcessoAoPedidoVendas = 09000001;
const acesso_PedUsaVendedorDoCadastroCliente = 09000002;
const acesso_PedPodeAlterarVendedor = 09000003;
const acesso_PedPodeDigitarPrecoVenda = 09000004;
const acesso_PedPodeAlterarAgenteNegocio = 09000005;
const acesso_PedPodeConcederDesconto = 09000006;
const acesso_PedPodeConcederDescontoAcimaDoPermitido = 09000007;
// Tarefa: 9779 - Renata - 06/10/2009
//  {Já estava inibido sua utilização}
const acesso_PedPodeExcluirPedido = 09000008;
const acesso_PedPodeDigitarDescricaoProduto = 09000009;
const acesso_PedPodeLiberarCreditoParaCompra = 09000010;
const acesso_PedPodeLiberarVendaClientePendencia = 09000011;
const acesso_PedPodeEntrarComMultiplosVendedores = 09000012;
const acesso_PedPodeExcluirItensVenda = 09000013;
const acesso_PedPodeConcederDescontoNoItem = 09000014;
const acesso_PedPodeConcederDescontoNoItemAcimaDoPermitido = 09000015;
const acesso_PedPodeConcederDescontoNoItemEmPromocao = 09000016;
const acesso_PedPodeTrocarTabelaPreco = 09000017;
const acesso_PedPermiteVendaClienteInativo = 09000018;
const acesso_PedMudaInativoParaAtivo = 09000019;
const acesso_PedPodeVenderProdutoSemSaldo = 09000020;
const acesso_PedPodeVenderSemConexao = 09000021;
const acesso_PedPermiteVendaSemVendedor = 09000022;
const acesso_PedSomenteUmVendedorPorPedido = 09000023;
const acesso_PedPodeAlterarTransportador = 09000024;
const acesso_PedPodeAlterarDadosGrid = 09000025;
const acesso_PedVisualizaApenasPedidoOperadorLogado = 09000026;
const acesso_PedPodeAlterarPedidoImpresso = 09000027;
const acesso_PedPodeConcederAcrescimoItem = 09000028;
const acesso_PedPodeCancelarPedido = 09000029;
const acesso_PedVisualizaApenasPedidoFilialLogada = 09000030;
const acesso_PedSomenteVendedorFilalLogada = 09000031;
const acesso_PedMostraMensagemPedidoJaIncluido = 09000032;
const acesso_PedFreteDestPadrao = 09000033;
const acesso_PedHabilitaRetira_Entrada = 09000034;
const acesso_PedHabilitaDataRetira_Entrada = 09000035;
const acesso_PedHabilitaCliente = 09000036;
const acesso_PedSemIdentificarCrmOrigem = 09000037;
const acesso_PedLimitaDecontosASomaDosDescontosDosItens = 09000038;
const acesso_PedDesabilitaChecaDescTotalSobreDescontoItem = 09000039;
const acesso_PedSemIdentificarCliente = 09000040;
//Acessibilidade Para Orçamento
const acesso_PedPodeAcessarOrcamentos = 09010100;
const acesso_PedPodeAlterarDescricaoProd = 09010101;
const acesso_PedOrcPodeConcederDescontoTotal = 09010102;
const acesso_PedOrcPodeConcederAcrescimoTotal = 09010103;
const acesso_PedOrcPodeConcederFreteTotal = 09010104;
const acesso_PedOrcPodeConcederDescontoItem = 09010105;
const acesso_PedOrcPodeConcederAcrescimoItem = 09010106;
const acesso_PedOrcVisualizaApenasPedidoOperadorLogado = 09010107;
//Vanderlei - Tarefa: 10596
const acesso_PedOrcPodeCancelarOrcamento = 09010108;
const acesso_PedOrcPodeExcluirItemOrcamento = 09010109;
//Fim
const acesso_PedPodeAcesssarFechaOrcamentos = 09010200;
const acesso_PedPodeAcessarVendasCliente = 09010500;

// aplicativo servicos 51
const acesso_SerPodeAcessarAppServicos = 51000001;

const acesso_SerPodeAlterarDadosContratos = 51010100;
const acesso_SerPodeAplicarReajuste = 51010101;
const acesso_SerPodeEmitirNota = 51010102;
const acesso_SerPodeGerarDadosFinanc = 51010103;
const acesso_SerPodeMarcarNF = 51010104;
const acesso_SerPodeDesmarcarNF = 51010105;
const acesso_SerPodeEnviarMalaDireta = 51010200;
const acesso_SerPodeEnviarEmail = 51010300;
const acesso_SerPodeAcessarNivelAcesso = 51010400;
const acesso_SerPodeCadastroTributacaoServicos = 51010500;
const acesso_SerPodeCadastroIndices = 51010600;

const acesso_SerPodeEncerrarOS = 51020100;
const acesso_SerPodeAlterarOSEncerrada = 51020200;
const acesso_SerPodeRelDemonstrativoServicos = 51020300;
const acesso_SerPodeRelHorasFaturadasExecutadas = 51020400;
const acesso_SerPodeRelServicosFaturados = 51020500;
const acesso_SerPodeRelServicosAFaturar = 51020600;
const acesso_SerPodeRelItensVendidos1Cliente = 51020700;
const acesso_SerPodeManutencaoTarefas = 51020800;

const acesso_SerPodeGerenciaDeAtendimentos = 51030100;
const acesso_SerPodeCadastroServicosAtendimento = 51030200;
const acesso_SerPodeCadastroEstadosAtendimentos = 51030300;
const acesso_SerPodeCadastrarPessoasAgenda = 51030400;

// Constrole de Patrimonio
const acesso_PatApp = 52000000;
const acesso_PatCadastros = 520100000;
const acesso_PatPluginTypes_Veiculos = 520101001;
const acesso_PatPodeFazerEditarDadosCadastro = 52010001;
const acesso_PatPodeAlterarPosseDoItem = 52010002;

const acesso_DashboardsManagerAppID = 53000000;
const acesso_DashboardsMetasVendas = 53000001;

const acesso_DashboardsMinhasAtividades = 53000100;
const acesso_DashboardsQtdeVendasSemanais = 53000101;
const acesso_AcessoPluginsID = 53010000; // ver unit AcessoConst.Plugins;
const acesso_AcessoKPIsID = 53020000;
// ver unit AcessoConst.KPI;

//Pedido Filial 60
const acesso_PedPodeAcessarDivergencia = 60000010;
const acesso_PedPodeAprovarDivergencia = 60000011;
const acesso_PedPodeAcessarLancDivergExp = 60000012;
const acesso_PedPodeSincronizarDivergExt = 60000013;
const acesso_PedBloqueiaDataLctoDivergExp = 60000014;
const acesso_PedPodeAcessarApontProd = 60000020;
const acesso_PedPodeBaixarEntProducao = 60000021;
const acesso_PedPedLoginApontProd = 60000022;
const acesso_PedPodeFazerApontamentoQtdeNegativa = 60000023;

// apontamento de produção - Encomenda
const acesso_bloqueiaFichasQueNaoSaoPorApontamento = 60000024;
const acesso_bloqueiaApontamentoEmFichaInativa = 60000025;
const acesso_bloqueiaApontamentoDataAnterior = 60000026;

const acesso_PedPodeAcessarCadPedido = 60000030;
const acesso_PedPedeLoginParaNovoPedido = 60000031;
const acesso_PedPedeLoginParaTransf = 60000032;
const acesso_PedValidaXCategorias = 60000033;
const acesso_PedPodeAcessarCofigPedido = 60000040;
const acesso_PedPodeAcessarAcompPedido = 60000050;
const acesso_PedPedeLoginAcompPedido = 60000051;
const acesso_PedPodeArmazenarItemPedFilial = 60000052;
const acesso_PedPodeExcluirPedidoFilial = 60000053;
const acesso_PedPodeFecharCarrinho = 60000054;
const acesso_PedPodeAcessarCarrinhos = 60000060;
const acesso_PedPedeLoginAcessarCarrinhos = 60000061;
const acesso_PedAlocacaoParaPedido = 60000070;
const acesso_PedPodeAcessarAlocacaoParaPedido = 60000071;
const acesso_PedImportarArquivodePedido = 60000080;
const acesso_PedPodeImportarArquivodePedido = 60000081;
const acesso_PedImportArqPedidoPodeAlterarQtde = 60000082;
const acesso_PedImportArqPodeExcluirItem = 60000083;
const acesso_PedImportArqPodeInserirNovoItem = 60000084;
const acesso_PedAcompPermiteAlterarQtdeDataAnterior = 60000085;

const acesso_PedPodeAcessarRegistroDeCompras = 60000090;
const acesso_PedPodePedidoDeCompras = 60000091;
const acesso_PedPodeAcessarSobras = 60000100;
const acesso_PedPodeLancarSobras = 60000101;
const acesso_PedPodeConcederAcrescimo = 60000102;
const acesso_PedPodeLancarEstoqueFabrica = 60000104;
const acesso_PedPodeAcessarEstoqueFabrica = 60000105;
const acesso_PedPodeLancarSobrasAlteraGrupos = 60000106;
const acesso_PedPodeConcederFrete = 60000103;
const acesso_PedPodeAcessarPedFilialExpArq = 60000110;
const acesso_PedPodeAcessarPedidoAdicional = 60000120;

const acesso_PedPodeAcessarTransfFiliais = 60000130;

// Tarefa: 11885 - Leonardo - 03/02/2014
const acesso_PedPodeAcessarConfEntrega = 60000140;

const acesso_PedPodeImportarSobras = 60000200;

const acesso_PedPodeAcessarAcompanhamentoProd = 60000210;

//*relatorios pedido e encomenda*//
const acesso_PedMenuRelEncomenda = 60000300;
const acesso_PedMenuRelPedido = 60000310;
const acesso_PedMenuRelProducao = 60000320;
const acesso_PedMenuRelGerencial = 60000330;
const acesso_PedMenuRelGerencialTransEntrFil = 60000331;
const acesso_PedMenuRelGerencialDiverExp = 60000332;
const acesso_PedMenuRelGerencialSobrasPorItem = 60000333;
const acesso_PedMenuRelGerencialSobrasPorGrupo = 60000334;
const acesso_PedMenuRelRegCompras = 60000340;

// menu produção
const acesso_prod_MenuProducao = 60010000;
const acesso_prod_FichaTecnica = 60010011;

const acesso_prod_FichaTecnica_podeAprovar = 6001001101;
const acesso_prod_MenuProducao_permiteExcluirUmaRequisicao = 6001005101;
//  prod_PodeCadastrarListaRequisicao = 6001005102;

// relatorios da produçao
const acesso_prod_MenuRelatoriosProducao = 60011000;

// Tabela Nutricional
const acesso_nutricao_menu_nutricional = 6001010000;
const acesso_nutricao_cadastro_nutrientes = 6001010001;
const acesso_nutricao_ctprod_nutrientes = 6001010002;
const acesso_nutricao_permiteAlterar_cadastro_nutrientes = 6001010003;
const
    // Pis/Cofins de entrada
    PISCOFINSENT = 6001010004;

//  {-----------------------------BALCÃO DE CRÉDITO------------------------------}
const acesso_BalcaoSerasaPodeAlterarOpcoesComunicacao = 70100011;
const acesso_BalcaoSerasaPodeForcarConsultaNaoVencidaDeCheque = 70100012;
const acesso_BalcaoPermiteAlterarLimiteCredito = 70100013;
const acesso_BalcaoPermiteAlterarNivelBloqueio = 70100014;

//  {--------------------------------ATENDIMENTO---------------------------------}
const acesso_AtendimentoPermiteAbrirTarefa = 1320003001;
const acesso_AtendimentoPermiteRequisitarAgenda = 1320003002;
const acesso_AtendimentoPermiteAbrirRelatorios = 1320003003;
const acesso_AtendimentoPermiteVerDadosDoCliente = 1320003004;
const acesso_AtendimentoPermiteAlterarCliente = 1320003005;
const acesso_AtendimentoPermiteAlterarComboTecnico = 1320003006;
const acesso_AtendimentoPermiteAnexarArquivos = 1320003007;
const acesso_AtendimentoPermiteLocalizarAnexos = 1320003008;
const acesso_AtendimentoPermiteReabrirChamado = 1320003009;
const acesso_AtendimentoPermiteAbrirChamadoClienteInativo = 1320003010;

const acesso_AtendimentoPermiteAcessarAgenda = 1320004001;
const acesso_AtendimentoPermiteCriarAgenda = 1320004002;
const acesso_AtendimentoPermiteAlterarAgenda = 1320004003;
const acesso_AtendimentoPermiteFecharAgenda = 1320004004;
const acesso_AtendimentoPermiteExcluirAgenda = 1320004005;
const acesso_AtendimentoPermiteEnviarOsPorEmail = 1320004006;

const acesso_AtendimentoPermiteCadastrarGrupo = 1320004007;
const acesso_AtendimentoPermiteCadastrarPessoa = 1320004008;
const acesso_AtendimentoPermiteCadastrarTipoAtendimento = 1320004009;
const acesso_AtendimentoPermiteVisualizarAgendaGrupoDiferente = 1320004010;

const acesso_AtendimentoEnviaEmailParaClienteSemConfirmacao = 1320004011;
// Tarefa: 12016 - Leonardo - 25/03/2014
const acesso_TornaObrigatorioPreenchimentoSolucaoAtendimento = 1320004012;
const acesso_TornaObrigatorioPreenchimentoMotivoDaLigacao = 1320004013;
// Tarefa: 12424 - Leonardo - 23/10/2014
const acesso_AtendimentoPermiteVisualizarFatura = 1320004014;
const acesso_AtendimentoObrigatorioAlterarFaturaAgenda = 1320004015;
// Tarefa: 12521 - Leonardo - 16/12/2014
const acesso_AtendimentoPermiteAlterarFilialAgenda = 1320004016;

const acesso_AtendimentoPermiteAcessarCadastroDeClientes = 1320005001;
const acesso_AtendimentoPermiteAcessarCadastroDePessoas = 1320005002;
const acesso_AtendimentoPermiteAcessarCadastroDeGrupos = 1320005003;
const acesso_AtendimentoPermiteAcessarCadastroDeTiposDeChamados = 1320005004;
const acesso_AtendimentoPermiteAcessarCadastroDeTiposDeEstadosDeAgenda =
    1320005005;
const acesso_AtendimentoPermiteAcessarCadastroDeAgendaPadrao = 1320005006;

const acesso_AtendimentoPermiteAbrirRelatrioporperodo = 1320006001;
const acesso_AtendimentoPermiteAbrirRelatriodeVisitaporCliente = 1320006002;
const acesso_AtendimentoPermiteAbrirRelatriodeHorasporCliente = 1320006003;
const acesso_AtendimentoPermiteAbrirRelatriodeVisitaporTecnico = 1320006004;
const acesso_AtendimentoPermiteAbrirRelatrioNaAberturaDeAtendimento =
    1320006005;
//  {-----------------------------FIM-ATENDIMENTO--------------------------------}

const acesso_RH_Aplicacao = 14;

//  {RH_Escala}
const acesso_RH_Menu_Escala = 1401;

const acesso_RH_Manutencao_Escala = 14010100;
const acesso_RH_Manutencao_Escala_PodeIncluirNovoEvento = 14010101;
const acesso_RH_Manutencao_Escala_PodeAlterarNovoEvento = 14010102;
const acesso_RH_Manutencao_Escala_PodeExcluirUmEvento = 14010103;
const acesso_RH_Manutencao_Escala_PodeBloquearUmEvento = 14010104;
const acesso_RH_Manutencao_Escala_PodeDesBloquearUmEvento = 14010105;
const acesso_RH_Manutencao_Escala_PodePublicarUmaEscala = 14010106;
const acesso_RH_Manutencao_Escala_PodeDesPublicarUmaEscala = 14010107;
const acesso_RH_Manutencao_Escala_PodeCopiarFolgas = 14010108;
const acesso_RH_Manutencao_Escala_PodeGerarFolgaPadrao = 14010109;
const acesso_RH_Manutencao_Escala_PodeExcluirEventoEscalaBloqueada = 14010110;
const acesso_RH_Manutencao_Escala_PodeIncluirEventoEscalaBloqueada = 14010111;
const acesso_RH_Manutencao_Escala_PodeExcluirEscalaDoMenu = 14010112;
const acesso_RH_Manutencao_Escala_HabilitaCampoDataDeDataAte = 14010113;

const acesso_RH_Cadastro_Funcionario = 14010200;
const acesso_RH_Cadastro_Turnos = 14010300;
const acesso_RH_Cadastro_Departamentos = 14010400;
const acesso_RH_Cadastro_Horarios = 14010500;
const acesso_RH_Cadastro_Qtde_Minima = 14010600;
const acesso_RH_Cadastro_Eventos = 14010700;
const acesso_RH_Cadastro_Feriados = 14010701;
const acesso_RH_Cadastro_Funcoes = 14010702;
const acesso_RH_Cadastro_TipoSalario = 14010703;
const acesso_RH_Cadastro_TipoCelula = 14010704;

const acesso_RH_Menu_Atributos = 1402;
const acesso_RH_Menu_Configuracao = 14020100;
const acesso_RH_Acessibildade = 14020200;

const acesso_RH_Relatorios = 14020300;
const acesso_RH_RelatoriosPodeAcessarPersonalizados = 14020301;
const acesso_RH_RelatoriosPodeIncluirPersonalizados = 14020302;

//  {RH_MudancaEvento}
const acesso_RH_SolicitaMudancaEvento = 14010800;
const acesso_RH_SolicitaMudancaEvento_VisualizaFiltro = 14010801;
const acesso_RH_SolicitaMudancaEvento_PodeAprovar = 14010802;
const acesso_RH_SolicitaMudancaEvento_PodeReprovar = 14010803;
const acesso_RH_SolicitaMudancaEvento_PodeTrocarFolga = 14010804;
const acesso_RH_SolicitaMudancaEvento_PodeLancarFeriasLicenca = 14010805;
const acesso_RH_SolicitaMudancaEvento_PodeDesfazerAprovarReprovar = 14010806;

const acesso_FollowUp_AplicacaoMainMenu = 15;

//  {------------ PETStudio -------------------------------------------------}

const acesso_PetStudio = 16;
const acesso_PetStudio_Menu = 1610;

const acesso_PetStudio_Atendimento = 16100100; //pai PetStudio_Menu
const acesso_PetStudio_Tipo_Atendimento = 16100101; //pai PetStudio_Atendimento
const acesso_PetStudio_Todos_Atendimentos_em_Aberto_Rel =
    16100102; //pai PetStudio_Atendimento
const acesso_PetStudio_Fechados_Por_Tipo_e_Periodo_Rel =
    16100103; //pai PetStudio_Atendimento
const acesso_PetStudio_Por_Numero_do_DCTO_Rel =
    16100104; //pai PetStudio_Atendimento
const acesso_PetStudio_Atendimento_Por_Pet_Rel =
    16100105; //pai PetStudio_Atendimento
const acesso_PetStudio_Todos_Por_Proprietario =
    16100106; //pai PetStudio_Atendimento
const acesso_PetStudio_Atendimento_Acrescimo =
    16100107; //pai PetStudio_Atendimento
const acesso_PetStudio_Atendimento_Desconto =
    16100108; //pai PetStudio_Atendimento
const acesso_PetStudio_Atendimento_Produto_Sem_Preco =
    16100109; //pai PetStudio_Atendimento
const acesso_PetStudio_Atendimento_Cancelar_item =
    16100110; //pai PetStudio_Atendimento
const acesso_PetStudio_Atendimento_altera_ficha =
    16100111; //pai PetStudio_Atendimento
const acesso_PetStudio_Atendimento_alterar_Preco_Venda =
    16100112; //pai PetStudio_Atendimento
const acesso_PetStudio_Atendimento_Obrigar_resposavel =
    16100113; //pai PetStudio_Atendimento

const acesso_PetStudio_Cadastro_de_Pet = 16100200; //pai PetStudio_Menu
const acesso_PetStudio_Cadastro_de_Racas =
    16100201; //pai PetStudio_Cadastro_de_Pet
const acesso_PetStudio_Cadastro_de_Especie =
    16100202; //pai PetStudio_Cadastro_de_Pet
const acesso_PetStudio_Cadastro_de_Pelagens =
    16100203; //pai PetStudio_Cadastro_de_Pet
const acesso_PetStudio_Todas_As_Especies_Rel =
    16100204; //pai PetStudio_Cadastro_de_Pet
const acesso_PetStudio_Pets_Cadastrados_por_Especie_Rel =
    16100205; //pai PetStudio_Cadastro_de_Pet
const acesso_PetStudio_Todas_As_Racas_Rel =
    16100206; //pai PetStudio_Cadastro_de_Pet
const acesso_PetStudio_Pets_Cadastrados_Por_Raca_Rel =
    16100207; //pai PetStudio_Cadastro_de_Pet
const acesso_PetStudio_Pet_Aniversariantes_da_Semana_Rel =
    16100208; //pai PetStudio_Cadastro_de_Pet
const acesso_PetStudio_Reaplicacoes_Vacinas_da_Semana_Rel =
    16100209; //pai PetStudio_Cadastro_de_Pet
const acesso_PetStudio_AlteraFechamento_Pacote =
    16100210; //pai PetStudio_Cadastro_de_Pet
const acesso_PetStudio_AcessarConfiguracoes =
    16100211; //pai PetStudio_Cadastro_de_Pet
const acesso_PetStudio_ControleDeAtividades =
    16100212; //pai PetStudio_Cadastro_de_Pet
const acesso_PetStudio_Cadastro_de_Cor =
    16100213; //pai PetStudio_Cadastro_de_Pet
const acesso_PetStudio_Cadastro_de_Porte =
    16100214; //pai PetStudio_Cadastro_de_Pet

const acesso_Agenda_Studio = 17;
const acesso_Agenda_Calendario = 17001000; //Pai PetStudio
const acesso_Agenda_LocalAgendamento = 17001001; //Pai Agenda_Calendario
const acesso_Agenda_Recurso = 17001002; //Pai Agenda_Calendario
const acesso_Agenda_Tipo = 17001003; //Pai Agenda_Calendario
const acesso_Agenda_Estado = 17001004; //Pai Agenda_Calendario
const acesso_Agenda_Por_Periodo_Rel = 17001005;
const acesso_Agenda_Por_Recurso_Rel = 17001006;

const acesso_Studio = 18;
const acesso_Studio_Area_Negocios = 1810;

const acesso_Studio_Orcamento_de_vendas = 18100100; //Pai Studio_Area_Negocios

const acesso_Studio_Pedido_de_Vendas = 18100200; //Pai Studio_Area_Negocios
const acesso_Studio_Pedido_de_Vendas_Comissao_Por_Vendedor_Rel =
    18100201; //Pai Studio_Pedido_de_Vendas
const acesso_Studio_Pedido_de_Vendas_Vendas_Por_Produto_Servico_Rel =
    18100202; //Pai Studio_Pedido_de_Vendas
const acesso_Studio_Pedido_de_Vendas_Vendas_Analiticas_Rel =
    18100203; //Pai Studio_Pedido_de_Vendas
const acesso_Studio_Pedido_de_Vendas_Vendas_Sinteticas_Rel =
    18100204; //Pai Studio_Pedido_de_Vendas
const acesso_Studio_Pedido_de_Vendas_Venda_Por_Modalidade_Rel =
    18100205; //Pai Studio_Pedido_de_Vendas
const acesso_Studio_Pedido_de_Vendas_Dados_do_Cupom_de_Venda_Rel =
    18100206; //Pai Studio_Pedido_de_Vendas
const acesso_Studio_Pedido_de_Vendas_Vendas_Por_Vendedor_Analitica_Rel =
    18100207; //Pai Studio_Pedido_de_Vendas
const acesso_Studio_Pedido_de_Vendas_Vendas_Por_Vendedor_Sintetica_Rel =
    18100208; //Pai Studio_Pedido_de_Vendas
const acesso_Studio_Pedido_de_Vendas_Resumo_de_Vendas_Por_Vendedor_Rel =
    18100209; //Pai Studio_Pedido_de_Vendas
const acesso_Studio_Acompanhamento_de_Pedidos =
    18100300; //Pai Studio_Area_Negocios
const acesso_Studio_Acompanhamento_de_Pedidos_Estados_do_Pedido =
    18100301; //Pai Studio_Acompanhamento_de_Pedidos
const acesso_Studio_Acompanhamento_de_Pedidos_Estados_Mov_Pedidos =
    18100302; //Pai Studio_Acompanhamento_de_Pedidos

const acesso_Studio_Clientes = 18100400; //Pai Studio_Area_Negocios

const acesso_Studio_Precos_e_Promocoes = 18100500; //Pai Studio_Area_Negocios
const acesso_Studio_Reajuste_Por_Margem_Bruta =
    02130100; //02130100Pai Studio_Precos_e_Promocoes
const acesso_Studio_Reajuste_por_Percentual =
    18100502; //02130200Pai Studio_Precos_e_Promocoes
const acesso_Studio_Texto_Para_O_Cartao_de_Presente =
    18100503; //Pai Studio_Precos_e_Promocoes

const acesso_Studio_Condicoes_de_Pagamento =
    18100600; //Pai Studio_Area_Negocios
const acesso_Studio_Tipos_De_Desconto =
    18100601; //Pai Studio_Condicoes_de_Pagamento
const acesso_Studio_Cartoes_de_Credito =
    18100602; //Pai Studio_Condicoes_de_Pagamento
const acesso_Studio_Caixas = 18100603; //Pai Studio_Condicoes_de_Pagamento
//Cadastro de Vendedores mesmo com código do SupAcesso.pas Ainda aparecendo na RAIZ
const acesso_Studio_Cadastro_de_Vendedores =
    03010700; //18100604; //Pai Studio_Condicoes_de_Pagamento

//Verificar está dúbio aparecendo fora do
const acesso_Studio_Categoria_de_Produtos =
    02131013; //18100700; //Pai Studio_Area_Negocios
const acesso_Studio_Atalhos_e_Menus_de_Produtos =
    18100701; //Pai Studio_Categoria_de_Produtos

const acesso_Studio_Materiais_e_Suprimentos = 1820; //pai Studio
const acesso_Studio_Materiais_e_Suprimentos_Entrada_de_Mercadoria =
    18200100; //pai Studio_Materiais_e_Suprimentos
const acesso_Studio_Materiais_e_Suprimentos_Preco_Pendente =
    18200101; //pai Studio_Materiais_e_Suprimentos
const acesso_Studio_Materiais_e_Suprimentos_Emissao_De_Eti_de_Produtos =
    18200102; //pai Studio_Materiais_e_Suprimentos
const acesso_Studio_Materiais_e_Suprimentos_Operacoes_De_Movimentacao =
    18200103; //pai Studio_Materiais_e_Suprimentos
const acesso_Studio_Entradas_de_Mercadorias_Rel =
    18200104; //pai Studio_Materiais_e_Suprimentos
const acesso_Studio_Materiais_e_Suprimentos_Pedido_De_Compras =
    18200200; //pai Studio_Materiais_e_Suprimentos

const acesso_Studio_Materiais_e_Suprimentos_Estatisticas_De_Produtos =
    18200300; //pai Studio_Materiais_e_Suprimentos

const acesso_Studio_Materiais_e_Suprimentos_Fornecedores =
    18200400; //pai Studio_Materiais_e_Suprimentos
const acesso_Studio_Materiais_e_Suprimentos_ficha_de_fornecedor_cliente =
    18200401; //pai Studio_Materiais_e_Suprimentos_Fornecedores

const acesso_Studio_Financas = 1830; //Pai Studio
const acesso_Studio_Financas_Cta_Corrente =
    18300100; //Verificar 01020101 pai Studio_Financas
const acesso_Studio_Financas_Cta_Corrente_Caixas_e_Bancos =
    18300101; //pai Studio_Financas_Cta_Corrente
const acesso_Studio_Financas_Cta_Corrente_Plano_De_Contas =
    18300102; //pai Studio_Financas_Cta_Corrente
const acesso_Studio_Financas_Cta_Corrente_Extrato_De_Contas_Rel =
    18300103; //pai Studio_Financas_Cta_Corrente
const acesso_Studio_Financas_Cta_Corrente_Saldo_Bancario_Rel =
    18300104; //pai Studio_Financas_Cta_Corrente
const acesso_Studio_Financas_Cta_Corrente_Resumo_Financeiro_Rel =
    18300105; //pai Studio_Financas_Cta_Corrente

const acesso_Studio_Financas_Ctas_A_Pagar = 1840; //pai Studio_Financas
//Studio_Financas_Ctas_A_Pagar_Rec_de_Contas       = 18400101;//pai Studio_Financas_Ctas_A_Pagar
const acesso_Studio_Financas_Rec_de_Contas =
    acesso_RecebimentodeClientesAc; //pai Studio_Financas_Ctas_A_Pagar
const acesso_Studio_Financas_Ctas_A_Pagar_Pgto_de_Contas =
    acesso_PagamentoFornecedoresAc; //pai Studio_Financas_Ctas_A_Pagar
const acesso_Studio_Financas_Ctas_A_Pagar_Cobranca_de_Contas =
    18400102; //pai Studio_Financas_Ctas_A_Pagar
const acesso_Studio_Financas_Ctas_A_Pagar_Cadastro_De_Moedas =
    18400103; //pai Studio_Financas_Ctas_A_Pagar
const acesso_Studio_Financas_Ctas_A_Pagar_Mov_Financeiro_Diario =
    18400104; //pai Studio_Financas_Ctas_A_Pagar

const acesso_Studio_Financas_Fluxo_De_Caixa = 1850; //pai Studio_Financas
const acesso_Studio_Financas_Fluxo_De_Caixa_Detalhado_Rel =
    185000100; //pai Studio_Financas_Fluxo_De_Caixa
const acesso_Studio_Financas_Fluxo_Analitico_Rel =
    185000101; //pai Studio_Financas_Fluxo_De_Caixa
const acesso_Studio_Financas_Fluxo_Sintetico_Rel =
    185000102; //pai Studio_Financas_Fluxo_De_Caixa

const acesso_Studio_Financas_Parceiros = 1860; //pai Studio_Financas
const acesso_Studio_Financas_Parceiros_Tipos_de_parceiros =
    186000100; //pai Studio_Financas_Parceiros
const acesso_Studio_Financas_Parceiros_Vendedores =
    186000101; //pai Studio_Financas_Parceiros

const acesso_Studio_Financas_Movimentacoes = 1870; //pai Studio_Financas
const acesso_Studio_Financas_Movimentacoes_Sangria_e_Suprimentos =
    187000100; // pai Studio_Financas_Movimentacoes
const acesso_Studio_Financas_Movimentacoes_Quebra_de_Caixa =
    187000101; // pai Studio_Financas_Movimentacoes

// {------- FIM PETStudio ---------------------------------------------------}

//*WbaReport //
const acesso_AcessaWBAReport = 97000000;

//*Alertas*// 99
const acesso_RecursoAlerta = 99000000;
//AlertaCriticaCupom = 99000001;
const acesso_AlertaTeste = 99000002;
//AlertaEnviarDadosPDV = 99000003;
//AlertaColetarDadosPDV = 99000004;
//AlertaDigitaDadosFiscaisdaLeituraZ = 99000005;
//AlertaTransferenciasPendentes = 99000006;

//*Alertas - Estoque*// 99
const acesso_AlertaTransferenciasFilialDistrib_RelTransfAbertas = 99000007;

const acesso_AlertaCancelarPedidosAbertos = 99000008;

//Comum
const acesso_CadGrupos = 99999901;
const acesso_CadSetores = 99999902;
const acesso_CadTributaoICMS = 99999903;
const acesso_CadFamiliasProdutos = 99999904;
const acesso_CadParametrosCSOSN = 99999905;
const acesso_CadParametrosCFOP = 99999906;
const acesso_AlteraodePrecodeVendaFilial = 99999907;
const acesso_CadTipoContato = 99999908;
const acesso_ImprimiReciboLctoDespesas = 99999909;

//O código está diferente pois veio do faturamento (não alterar)
const acesso_EmitirNotaFiscalEletronica = 06205000;
const acesso_ImprimirDANFeCopia = 06205001;
const acesso_GeraPDFDANFe = 06205002;
const acesso_FatEnviaCopiaEmailParaEmitenteFilial = 06205003;
const acesso_NFePodeAcessarConfiguracoes = 06205004;
const acesso_NFePodeGerarCCe = 06205005;
const acesso_NFePodeCancelarNFe = 06205006;
const acesso_NFePodeConsultasNFe = 06205007;
const acesso_NFePodeEnviarDanfeNFe = 06205008;
const acesso_NFePodeImprimirDanfeNFe = 06205009;
const acesso_NFeHabilitaBotaoNotaJa = 06205010;
const acesso_NFePodeCancelarNFeApos24h = 06205011;

const acesso_CadPais = 02142000;
const acesso_CadEstado = 06105000;
const acesso_CadMunicipio = 06106000;

const acesso_Alertas = 02160500;

const acesso_TrocarUsuario = 02160300;
const acesso_JanelaCadastroCliente = 9800;
const acesso_TrocarSenha = 99999910;

const acesso_VisualizaInfoHorarioAtendimentoFiliais = 9999999990;

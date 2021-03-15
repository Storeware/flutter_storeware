import 'widget_clientes.dart';

import 'widget_fornecedores.dart';
import 'widget_operacoes.dart';
import 'widget_tipoOperacoes.dart';
import 'widget_titulos_do_dia.dart';

/// Inicilização da lista de [WidgetSetup] carregado no inicio de carga do app
/// Itens disponíveis serão adicionada no _init() para a lista [WidgetSetup]
class WidgetSetup {
  static final _singleton = WidgetSetup._create();
  WidgetSetup._create() {
    _init();
  }
  factory WidgetSetup() => _singleton;

  /// adiciona os widgets disponiveis para o usuario acessar
  /// aqui será montado a lista de widgets conhecidos e disponiveis
  _init() {
    TitulosDoDiaChart().register();
    SaidasPorTiposChart().register();
    BoxCadastrosClientesCount().register();
    BoxCadastrosFornecedoresCount().register();
    BoxCadastrosOperacoesCount().register();
  }
}

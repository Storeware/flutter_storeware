import 'package:comum/widgets/widget_data.dart';
import 'package:comum/widgets/widgets_base.dart';
import 'package:controls_data/local_storage.dart';
import 'package:loja_console/widgets/grupos_produtos.dart';
import 'package:loja_console/widgets/produtos.dart';
import 'package:loja_console/widgets/produtos_promocao.dart';

class WidgetsList {
  static final _singleton = WidgetsList._create();
  WidgetsList._create() {
    init();
  }
  factory WidgetsList() => _singleton;
  final data = WidgetData();

  init() {
    LocalStorage storage = LocalStorage();
    registerStorage(storage);
    // registrar os widgets
    ProdutosPromocaoWidget().register();
    GruposProdutosWidget().register();
    ProdutosCountWidget().register();
  }

  get headers => data.headers;
  get items => data.items;
}

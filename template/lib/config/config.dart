//import 'package:comum/config/config.dart';
import 'package:comum/services/config_service.dart';
import 'package:controls_data/odata_client.dart';
import 'package:controls_data/odata_firestore.dart';
import '../widgets/register.dart';
import 'left_menu_items.dart';
import 'main_drawer_menu.dart';
//import 'package:comum/adapter/odatacloudV3.dart';

class ConfigApp extends ConfigBase {
  get restServerBase => 'http://localhost:8886';
  int filial = 1;
  @override
  init() {
    CloudV3().loja = loja;
    ODataInst().baseUrl = restServerBase;
    ODataInst().prefix = '/v3/';
  }

  @override
  setup() {
    /// registra os widgets
    WidgetsList();

    /// inicializa o menu MainDrawer
    MainMenuDrawerApp();

    /// inicializa menu esquerdo
    LeftMenuItems();
  }

  get loja => Uri().queryParameters['q'];
  set mainContext(context) {
    LeftMenuItems().context = context;
  }
}

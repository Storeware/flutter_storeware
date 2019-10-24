
library services;
import 'dart:html';
import './models/config_model.dart';
export 'services/routes.dart';
export 'services/assets_files.dart';
export 'services/translate.dart';
export 'system.utils.dart';


checkRedirect([b=false]){
      if (b || configModel==null)
        {
         print('Não incializou configurações iniciais'); 
         window.location.href = "index.html";
        }
}
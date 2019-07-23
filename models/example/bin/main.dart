//import 'package:example/example.dart' as example;
import '../../lib/models/grupos_model.dart';


main(List<String> arguments) {
  print('Hello world:');
  var g = GruposModel();
  g.get().then((r){
    r.forEach((d) { print(d.toJson()); });
  });
  
}

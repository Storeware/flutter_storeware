import '../models/restserver.dart';
import '../data.dart';

class GrupoItem extends DataItem {
  String grupo;
  String nome;
  @override
  fromJson(Map<String, dynamic> data) {
    grupo = data['grupo'];
    nome = data['nome'];
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    return {"grupo": grupo, "nome": nome};
  }
}

class GruposModel extends DataRows<GrupoItem> {
  Future<dynamic> get({String codigo = ''}) async {
    var r = RestServer();
    return r.getProdutosGrupos(codigo).then((data) {
        fromList(r.toList(key:'result'));
        return items;
    });
  }

  @override
  GrupoItem newItem() {
    return GrupoItem();
  }
}

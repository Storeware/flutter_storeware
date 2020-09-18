import 'package:controls_data/data_model.dart';
import 'package:controls_data/odata_client.dart';

class CtrlIdItem extends DataItem {
  String nome;
  double numero;
  int status;
  double valor;

  CtrlIdItem({this.nome, this.numero, this.status, this.valor});

  CtrlIdItem.fromJson(Map<String, dynamic> json) {
    fromMap(json);
  }
  @override
  fromMap(Map<String, dynamic> json) {
    nome = json['nome'];
    numero = toDouble(json['numero']);
    status = toInt(json['status']);
    valor = toDouble(json['valor']);
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nome'] = this.nome;
    data['numero'] = this.numero;
    data['status'] = this.status;
    data['valor'] = this.valor;
    return data;
  }
}

class CtrlIdItemModel extends ODataModelClass<CtrlIdItem> {
  CtrlIdItemModel() {
    collectionName = 'ctrl_id';
    super.API = ODataInst();
  }
  CtrlIdItem newItem() => CtrlIdItem();

  static Future<CtrlIdItem> proximo(String nome) async {
    return CtrlIdItemModel()
        .API
        .openJson("select * from obter_id('$nome')")
        .then((rsp) {
      return CtrlIdItem.fromJson(rsp['result'][0]);
    });
  }
}

import 'package:controls_data/data_model.dart';
import 'package:controls_data/odata_client.dart';
import 'package:controls_data/odata_firestore.dart';

class MetasVendasItem extends DataItem {
  int ano;
  int mes;
  double filial;
  double valor;
  double realizado;

  MetasVendasItem(
      {this.ano, this.mes, this.filial, this.valor, this.realizado});

  MetasVendasItem.fromJson(Map<String, dynamic> json) {
    fromMap(json);
  }
  @override
  fromMap(Map<String, dynamic> json) {
    ano = toInt(json['ano']);
    mes = toInt(json['mes']);
    filial = toDouble(json['filial']);
    valor = toDouble(json['valor']);
    realizado = toDouble(json['realizado']);
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ano'] = this.ano;
    data['mes'] = this.mes;
    data['filial'] = this.filial;
    data['valor'] = this.valor;
    data['realizado'] = this.realizado;
    data['id'] = '$filial-$ano$mes';

    return data;
  }

  fullJson() {
    var r = toJson();
    r['id'] = '${this.ano}${this.mes}';
    return r;
  }
}

class MetasVendasItemModel extends ODataModelClass<MetasVendasItem> {
  MetasVendasItemModel() {
    collectionName = 'metas_vendas';
    super.API = ODataInst();
    super.CC = CloudV3().client..client.silent = true;
  }
  MetasVendasItem newItem() => MetasVendasItem();

  Future<dynamic> metaMes({DateTime data}) {
    data = data ?? DateTime.now();
    var mes = data.month;
    var ano = data.year;
    return listNoCached(filter: 'ano = $ano and mes = $mes').then((rsp) {
      return rsp.first;
    });
  }
}

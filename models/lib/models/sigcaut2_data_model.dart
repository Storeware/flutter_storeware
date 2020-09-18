import 'package:controls_data/data_model.dart';
import 'package:controls_data/odata_client.dart';
import 'package:controls_data/odata_firestore.dart';
import 'package:controls_extensions/extensions.dart' hide DynamicExtension;

class Sigcaut2DataItem extends DataItem {
  DateTime data;
  String codigo;
  int filial;
  String operacao;
  int qtde;
  int valor;
  int descontos;
  int acrescimos;

  Sigcaut2DataItem(
      {this.data,
      this.codigo,
      this.filial,
      this.operacao,
      this.qtde,
      this.valor,
      this.descontos,
      this.acrescimos});

  Sigcaut2DataItem.fromJson(Map<String, dynamic> json) {
    fromMap(json);
  }
  @override
  fromMap(Map<String, dynamic> json) {
    data = toDateTime(json['data']);
    codigo = json['codigo'];
    filial = json['filial'];
    operacao = json['operacao'];
    qtde = json['qtde'];
    valor = json['valor'];
    descontos = json['descontos'];
    acrescimos = json['acrescimos'];

    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data;
    data['codigo'] = this.codigo;
    data['filial'] = this.filial;
    data['operacao'] = this.operacao;
    data['qtde'] = this.qtde;
    data['valor'] = this.valor;
    data['descontos'] = this.descontos;
    data['acrescimos'] = this.acrescimos;
    data['id'] = '$filial-$codigo-${this.data.format('yyyyMMdd')}';
    return data;
  }
}

class Sigcaut2DataItemModel extends ODataModelClass<Sigcaut2DataItem> {
  Sigcaut2DataItemModel() {
    collectionName = 'sigcaut2_data';
    super.API = ODataInst();
    super.CC = CloudV3().client;
  }
  Sigcaut2DataItem newItem() => Sigcaut2DataItem();
  vendasPeriodo({double filial, DateTime de, DateTime ate}) {
    String dDe = de.toIso8601String().substring(0, 10);
    String dAte = ate.toIso8601String().substring(0, 10);
    return search(
            select:
                "filial,data,sum(valor*(case when operacao<'200' then 1 else -1 end)) valor",
            top: 100,
            filter: " data ge '$dDe' and data le '$dAte' ",
            orderBy: 'data,filial',
            groupBy: 'data,filial')
        .then((rsp) => rsp.asMap());
  }
}

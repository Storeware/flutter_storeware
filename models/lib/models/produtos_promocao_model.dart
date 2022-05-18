import 'package:controls_data/data_model.dart';
import 'package:controls_data/odata_client.dart';

class ProdutosPromocaoItem extends DataItem {
  double? filial;
  String? codigo;
  String? nome;
  String? unidade;
  double? prompreco;

  ProdutosPromocaoItem(
      {this.filial, this.codigo, this.nome, this.unidade, this.prompreco});

  ProdutosPromocaoItem.fromJson(Map<String, dynamic> json) {
    fromMap(json);
  }
  @override
  fromMap(Map<String, dynamic> json) {
    filial = (json['filial'] ?? 0).toDouble();
    codigo = json['codigo'];
    nome = json['nome'] ?? '';
    unidade = json['unidade'];
    prompreco = (json['prompreco'] ?? 0).toDouble();
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['filial'] = this.filial ?? 0;
    data['codigo'] = this.codigo;
    data['nome'] = this.nome;
    data['unidade'] = this.unidade;
    data['prompreco'] = this.prompreco ?? 0;
    return data;
  }

  double precoByQtde([double qtde = 0]) {
    return prompreco ?? 0;
  }
}

class ProdutosPromocaoItemModel extends ODataModelClass<ProdutosPromocaoItem> {
  ProdutosPromocaoItemModel() {
    collectionName = 'web_produtos_promocao';
    API = ODataInst();
  }
  ProdutosPromocaoItem newItem() => ProdutosPromocaoItem();

  Future<ODataResult> listByFilial(double filial) {
    //print('filial: $filial');
    return search(filter: 'filial eq $filial');
  }
}

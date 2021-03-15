import 'package:controls_data/data_model.dart';
import 'package:controls_data/odata_client.dart';

class ProdutosDestaqueItem extends DataItem {
  double? filial;
  String? codigo;
  String? nome;
  String? unidade;
  double? precoweb;
  double? precovenda;

  ProdutosDestaqueItem(
      {this.filial,
      this.codigo,
      this.nome,
      this.unidade,
      this.precoweb,
      this.precovenda});

  ProdutosDestaqueItem.fromJson(Map<String, dynamic> json) {
    fromMap(json);
  }
  @override
  fromMap(Map<String, dynamic> json) {
    filial = (json['filial'] ?? 0).toDouble();
    codigo = (json['codigo'] ?? '');
    nome = json['nome'];
    unidade = json['unidade'];
    precoweb = (json['precoweb'] ?? 0).toDouble();
    precovenda = (json['precovenda'] ?? 0).toDouble();
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['filial'] = this.filial;
    data['codigo'] = this.codigo;
    data['nome'] = this.nome;
    data['unidade'] = this.unidade;
    data['precoweb'] = this.precoweb;
    data['precovenda'] = this.precovenda;
    return data;
  }
}

class ProdutosDestaqueItemModel extends ODataModelClass<ProdutosDestaqueItem> {
  ProdutosDestaqueItemModel() {
    collectionName = 'web_produtos_destaque';
    API = ODataInst();
  }
  ProdutosDestaqueItem newItem() => ProdutosDestaqueItem();

  listByFilial(double filial) {
    return super.search(filter: "filial eq $filial", orderBy: "nome");
  }
}

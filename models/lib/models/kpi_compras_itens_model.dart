import 'package:controls_data/data_model.dart';
import 'package:controls_data/odata_client.dart';

class KpiComprasItensItem extends DataItem {
  String? nomeproduto;
  int? mes;
  int? ano;
  String? codproduto;
  int? qtde;
  int? total;
  int? filial;

  KpiComprasItensItem(
      {this.nomeproduto,
      this.mes,
      this.ano,
      this.codproduto,
      this.qtde,
      this.total,
      this.filial});

  KpiComprasItensItem.fromJson(Map<String, dynamic> json) {
    fromMap(json);
  }
  @override
  fromMap(Map<String, dynamic> json) {
    nomeproduto = json['nomeproduto'];
    mes = json['mes'];
    ano = json['ano'];
    codproduto = json['codproduto'];
    qtde = json['qtde'];
    total = json['total'];
    filial = json['filial'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nomeproduto'] = this.nomeproduto;
    data['mes'] = this.mes;
    data['ano'] = this.ano;
    data['codproduto'] = this.codproduto;
    data['qtde'] = this.qtde;
    data['total'] = this.total;
    data['filial'] = this.filial;
    return data;
  }
}

class KpiComprasItensItemModel extends DataModelClass<KpiComprasItensItem> {
  KpiComprasItensItemModel() {
    collectionName = 'kpi_compras_itens';
  }
  KpiComprasItensItem newItem() => KpiComprasItensItem();

  @override
  enviar(KpiComprasItensItem item) {
    // TODO: implement enviar
    throw UnimplementedError();
  }

  @override
  getById(id) {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  snapshots({bool? inativo}) {
    // TODO: implement snapshots
    throw UnimplementedError();
  }
}

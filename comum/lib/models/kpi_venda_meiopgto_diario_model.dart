import 'package:controls_data/data_model.dart';

class KpiVendaMeiopgtoDiarioItem extends DataItem {
  int? filial;
  String? data;
  int? ano;
  int? mes;
  String? meio;
  int? idMeioPagto;
  double? qtitens;
  double? total;
  int? dia;

  KpiVendaMeiopgtoDiarioItem(
      {this.filial,
      this.data,
      this.ano,
      this.mes,
      this.meio,
      this.idMeioPagto,
      this.qtitens,
      this.total,
      this.dia});

  KpiVendaMeiopgtoDiarioItem.fromJson(Map<String, dynamic> json) {
    fromMap(json);
  }
  @override
  fromMap(Map<String, dynamic> json) {
    filial = json['filial'];
    data = json['data'];
    ano = json['ano'];
    mes = json['mes'];
    meio = json['meio'];
    idMeioPagto = json['id_meio_pagto'];
    qtitens = json['qtitens'];
    total = json['total'];
    dia = json['dia'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['filial'] = this.filial;
    data['data'] = this.data;
    data['ano'] = this.ano;
    data['mes'] = this.mes;
    data['meio'] = this.meio;
    data['id_meio_pagto'] = this.idMeioPagto;
    data['qtitens'] = this.qtitens;
    data['total'] = this.total;
    data['dia'] = this.dia;
    return data;
  }
}

class KpiVendaMeiopgtoDiarioItemModel
    extends DataModelClass<KpiVendaMeiopgtoDiarioItem> {
  KpiVendaMeiopgtoDiarioItemModel() {
    collectionName = 'kpi_venda_meiopgto_diario';
  }
  KpiVendaMeiopgtoDiarioItem newItem() => KpiVendaMeiopgtoDiarioItem();

  @override
  enviar(KpiVendaMeiopgtoDiarioItem item) {
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

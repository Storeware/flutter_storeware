import 'package:controls_data/data_model.dart';

class KpiVendasMensalItem extends DataItem {
  int? filial;
  String? data;
  int? qtde;
  int? total;
  int? qtitens;
  int? ano;
  int? mes;

  KpiVendasMensalItem(
      {this.filial,
      this.data,
      this.qtde,
      this.total,
      this.qtitens,
      this.ano,
      this.mes});

  KpiVendasMensalItem.fromJson(json) {
    fromMap(json);
  }
  @override
  fromMap(Map<String, dynamic> json) {
    filial = json['filial'];
    data = json['data'];
    qtde = json['qtde'];
    total = json['total'];
    qtitens = json['qtitens'];
    ano = json['ano'];
    mes = json['mes'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['filial'] = this.filial;
    data['data'] = this.data;
    data['qtde'] = this.qtde;
    data['total'] = this.total;
    data['qtitens'] = this.qtitens;
    data['ano'] = this.ano;
    data['mes'] = this.mes;
    return data;
  }
}

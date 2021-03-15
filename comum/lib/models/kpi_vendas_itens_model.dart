import 'package:controls_data/data_model.dart';

class KpiVendasItensItem extends DataItem {
  String? codigo;
  int? ano;
  int? mes;
  int? qtde;
  int? total;

  KpiVendasItensItem({this.codigo, this.ano, this.mes, this.qtde, this.total});

  KpiVendasItensItem.fromJson(Map<String, dynamic> json) {
    fromMap(json);
  }
  @override
  fromMap(Map<String, dynamic> json) {
    codigo = json['codigo'];
    ano = json['ano'];
    mes = json['mes'];
    qtde = json['qtde'];
    total = json['total'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['codigo'] = this.codigo;
    data['ano'] = this.ano;
    data['mes'] = this.mes;
    data['qtde'] = this.qtde;
    data['total'] = this.total;
    return data;
  }
}

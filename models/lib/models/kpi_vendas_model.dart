import 'package:controls_data/data_model.dart';

class KpiVendasItem extends DataItem {
  int? ano;
  int? mes;
  int? qtde;
  int? total;

  KpiVendasItem({this.ano, this.mes, this.qtde, this.total});

  KpiVendasItem.fromJson(json) {
    fromMap(json);
  }

  @override
  fromMap(Map<String, dynamic> json) {
    ano = json['ano'];
    mes = json['mes'];
    qtde = json['qtde'];
    total = json['total'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ano'] = this.ano;
    data['mes'] = this.mes;
    data['qtde'] = this.qtde;
    data['total'] = this.total;
    return data;
  }
}

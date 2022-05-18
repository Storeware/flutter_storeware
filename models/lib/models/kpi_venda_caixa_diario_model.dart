import 'package:controls_data/data_model.dart';

class KpiVendaCaixaDiarioItem extends DataItem {
  int? filial;
  String? data;
  int? ano;
  int? mes;
  String? caixa;
  int? qtitens;
  double? total;
  int? dia;
  int? diasemana;

  KpiVendaCaixaDiarioItem(
      {this.filial,
      this.data,
      this.ano,
      this.mes,
      this.caixa,
      this.qtitens,
      this.total,
      this.dia,
      this.diasemana});

  KpiVendaCaixaDiarioItem.fromJson(Map<String, dynamic> json) {
    fromMap(json);
  }
  @override
  fromMap(Map<String, dynamic> json) {
    filial = json['filial'];
    data = json['data'];
    ano = json['ano'];
    mes = json['mes'];
    caixa = json['caixa'];
    qtitens = json['qtitens'];
    total = json['total'];
    dia = json['dia'];
    diasemana = json['diasemana'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['filial'] = this.filial;
    data['data'] = this.data;
    data['ano'] = this.ano;
    data['mes'] = this.mes;
    data['caixa'] = this.caixa;
    data['qtitens'] = this.qtitens;
    data['total'] = this.total;
    data['dia'] = this.dia;
    data['diasemana'] = this.diasemana;
    return data;
  }
}

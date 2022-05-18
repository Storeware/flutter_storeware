import 'package:controls_data/data_model.dart';

class KpiVendasMaisVendidosItem extends DataItem {
  int? ano;
  int? mes;
  String? codigo;
  String? nome;
  int? total;
  int? filial;

  KpiVendasMaisVendidosItem(
      {this.ano, this.mes, this.codigo, this.nome, this.total, this.filial});

  KpiVendasMaisVendidosItem.fromJson(json) {
    fromMap(json);
  }
  @override
  fromMap(Map<String, dynamic> json) {
    ano = json['ano'];
    mes = json['mes'];
    codigo = json['codigo'];
    nome = json['nome'];
    total = json['total'];
    filial = json['filial'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ano'] = this.ano;
    data['mes'] = this.mes;
    data['codigo'] = this.codigo;
    data['nome'] = this.nome;
    data['total'] = this.total;
    data['filial'] = this.filial;
    return data;
  }
}

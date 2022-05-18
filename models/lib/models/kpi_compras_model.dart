import 'package:controls_data/data_model.dart';

class KpiComprasItem extends DataItem {
  String? nome;
  int? fornecedor;
  String? data;
  int? total;
  int? mes;
  int? ano;
  int? filial;

  KpiComprasItem(
      {this.nome,
      this.fornecedor,
      this.data,
      this.total,
      this.mes,
      this.ano,
      this.filial});

  KpiComprasItem.fromJson(Map<String, dynamic> json) {
    fromMap(json);
  }
  @override
  fromMap(Map<String, dynamic> json) {
    nome = json['nome'];
    fornecedor = json['fornecedor'];
    data = json['data'];
    total = json['total'];
    mes = json['mes'];
    ano = json['ano'];
    filial = json['filial'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nome'] = this.nome;
    data['fornecedor'] = this.fornecedor;
    data['data'] = this.data;
    data['total'] = this.total;
    data['mes'] = this.mes;
    data['ano'] = this.ano;
    data['filial'] = this.filial;
    return data;
  }
}

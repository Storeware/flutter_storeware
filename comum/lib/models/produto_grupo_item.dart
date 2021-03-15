import 'package:controls_data/data_model.dart';

class ProdutoGrupoItem extends DataItem {
  String? grupo;
  String? nome;
  String? bmp;
  int? comissao;
  String? sintetico;
  String? issintetico;
  String? setor;
  String? producao;

  ProdutoGrupoItem(
      {this.grupo,
      this.nome,
      this.bmp,
      this.comissao,
      this.sintetico,
      this.issintetico,
      this.setor,
      this.producao});

  ProdutoGrupoItem.fromJson(Map<String, dynamic> json) {
    fromMap(json);
  }

  @override
  fromMap(json) {
    grupo = json['grupo'];
    nome = json['nome'];
    bmp = json['bmp'];
    comissao = json['comissao'];
    sintetico = json['sintetico'];
    issintetico = json['issintetico'];
    setor = json['setor'];
    producao = json['producao'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['grupo'] = this.grupo;
    data['nome'] = this.nome;
    data['bmp'] = this.bmp;
    data['comissao'] = this.comissao;
    data['sintetico'] = this.sintetico;
    data['issintetico'] = this.issintetico;
    data['setor'] = this.setor;
    data['producao'] = this.producao;
    return data;
  }
}

import 'package:controls_data/data_model.dart';

class ProdutoAtalhoItens extends DataItem {
  String? codprod;
  int? codtitulo;
  String? dtatualiz;
  int? prioridade;

  ProdutoAtalhoItens(
      {this.codprod, this.codtitulo, this.dtatualiz, this.prioridade});

  ProdutoAtalhoItens.fromJson(json) {
    fromMap(json);
  }

  @override
  fromMap(Map<String, dynamic> json) {
    codprod = json['codprod'];
    codtitulo = json['codtitulo'];
    dtatualiz = json['dtatualiz'];
    prioridade = json['prioridade'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['codprod'] = this.codprod;
    data['codtitulo'] = this.codtitulo;
    data['dtatualiz'] = this.dtatualiz;
    data['prioridade'] = this.prioridade;
    return data;
  }
}

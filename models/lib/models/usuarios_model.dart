import 'package:controls_data/data_model.dart';
import 'package:controls_data/odata_client.dart';
import 'package:controls_data/odata_firestore.dart';

class SenhasItem extends DataItem {
  String aplicacao;
  String caixa;
  String codigo;
  int inativo;
  String nome;
  String grupo;
  String validade;
  String trocasenha;
  String dtatualiz;
  String vendedor;

  SenhasItem(
      {this.aplicacao,
      this.caixa,
      this.codigo,
      this.inativo,
      this.nome,
      this.grupo,
      this.validade,
      this.trocasenha,
      this.dtatualiz});

  SenhasItem.fromJson(Map<String, dynamic> json) {
    fromMap(json);
  }
  @override
  fromMap(Map<String, dynamic> json) {
    aplicacao = json['aplicacao'];
    caixa = json['caixa'];
    codigo = json['codigo'];
    inativo = json['inativo'];
    nome = json['nome'];
    grupo = json['grupo'];
    validade = json['validade'];
    trocasenha = json['trocasenha'];
    dtatualiz = json['dtatualiz'];
    vendedor = json['vendedor'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['aplicacao'] = this.aplicacao;
    data['caixa'] = this.caixa;
    data['codigo'] = this.codigo;
    data['inativo'] = this.inativo;
    data['nome'] = this.nome;
    data['grupo'] = this.grupo;
    data['validade'] = this.validade;
    data['trocasenha'] = this.trocasenha;
    data['dtatualiz'] = this.dtatualiz;
    data['vendedor'] = this.vendedor;
    return data;
  }
}

class SenhasItemModel extends ODataModelClass<SenhasItem> {
  SenhasItemModel() {
    collectionName = 'senhas';
    super.API = ODataInst();
    super.CC = CloudV3().client..client.silent = true;
  }
  SenhasItem newItem() => SenhasItem();
}

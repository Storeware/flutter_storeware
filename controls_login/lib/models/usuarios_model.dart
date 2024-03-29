// @dart=2.12
import 'package:controls_data/data_model.dart';
import 'package:controls_data/odata_client.dart';
import 'package:controls_data/odata_firestore.dart';
import 'package:controls_data/cached.dart';

class SenhasItem extends DataItem {
  String? aplicacao;
  String? caixa;
  String? codigo;
  int? inativo;
  String? nome;
  String? grupo;
  String? validade;
  String? trocasenha;
  DateTime? dtatualiz;
  String? vendedor;
  String? funcao;

  SenhasItem(
      {this.aplicacao,
      this.caixa,
      this.codigo,
      this.inativo,
      this.nome,
      this.grupo,
      this.funcao,
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
    inativo = toInt(json['inativo']);
    nome = json['nome'];
    grupo = json['grupo'];
    validade = json['validade'];
    trocasenha = json['trocasenha'];
    dtatualiz = toDateTime(json['dtatualiz']);
    vendedor = '${json['vendedor']}';
    funcao = json['funcao'];
    return this;
  }

  bool get isEmpty => this.codigo == null;

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
    data['funcao'] = this.funcao;

    /// quando é um insert, o codigo é gerado no servidor.
    if (this.codigo != null) data['id'] = this.codigo;
    return data;
  }

  get grupoUpper => (grupo ?? '').toUpperCase();
  get isAdmin => 'Administrador,Administração,Diretoria'
      .toUpperCase()
      .contains(grupoUpper);
  get isGestor =>
      'Gerente,Supervisor,Encarregado,Chefe'
          .toUpperCase()
          .contains(grupo ?? '') ||
      isAdmin;
  get isOperador => (!isAdmin && !isGestor);
  get isReadOnly =>
      'Consulta,Relatório,Relatorio'.toUpperCase().contains(grupo ?? '');
}

class SenhasItemModel extends ODataModelClass<SenhasItem> {
  SenhasItemModel() {
    collectionName = 'senhas';
    super.API = ODataInst();
    super.CC = CloudV3().client..client.silent = true;
  }
  SenhasItem newItem() => SenhasItem();
  Future<Map<String, dynamic>> buscarByCodigo(codigo) async {
    return Cached.value('usuario_$codigo',
        builder: (x) => super.getOne(filter: "codigo eq '$codigo'"));
  }
}

class UsuarioItem extends SenhasItem {}

class UsuarioItemModel extends SenhasItemModel {}

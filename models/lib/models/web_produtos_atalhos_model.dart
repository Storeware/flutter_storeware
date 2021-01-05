import 'package:controls_data/data_model.dart';
import 'package:controls_data/odata_client.dart';
//import 'package:controls_extensions/extensions.dart';

class WebProdutosAtalhosItem extends DataItem {
  WebProdutosAtalhosItem(
      {this.codtitulo,
      this.titulo,
      this.prioridade,
      this.inativo,
      this.filial,
      this.peso,
      this.imagem,
      this.codigo,
      this.nome,
      this.unidade,
      this.marca,
      this.precovenda,
      this.estoquedisponivel,
      this.precoweb,
      this.qtvarejo,
      this.precovda2});

  double codtitulo;
  String titulo;
  int prioridade;
  String inativo;
  double filial;
  double peso;
  String imagem;
  String codigo;
  String nome;
  String unidade;
  String marca;
  double precovenda;
  double estoquedisponivel;
  double precoweb;
  double qtvarejo;
  double precovda2;

  WebProdutosAtalhosItem.fromJson(Map<String, dynamic> json) {
    fromMap(json);
  }
  @override
  fromMap(Map<String, dynamic> json) {
    codtitulo = toDouble(json['codtitulo']);
    titulo = (json['titulo']);
    prioridade = toInt(json['prioridade']);
    inativo = (json['inativo']);
    filial = toDouble(json['filial']);
    peso = toDouble(json['peso']);
    imagem = (json['imagem']);
    codigo = (json['codigo']);
    nome = (json['nome']);
    unidade = (json['unidade']);
    marca = (json['marca']);
    precovenda = toDouble(json['precovenda']);
    estoquedisponivel = toDouble(json['estoquedisponivel']);
    precoweb = toDouble(json['precoweb']);
    qtvarejo = toDouble(json['qtvarejo']);
    precovda2 = toDouble(json['precovda2']);
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['codtitulo'] = this.codtitulo;
    data['titulo'] = this.titulo;
    data['prioridade'] = this.prioridade;
    data['inativo'] = this.inativo;
    data['filial'] = this.filial;
    data['peso'] = this.peso;
    data['imagem'] = this.imagem;
    data['codigo'] = this.codigo;
    data['nome'] = this.nome;
    data['unidade'] = this.unidade;
    data['marca'] = this.marca;
    data['precovenda'] = this.precovenda;
    data['estoquedisponivel'] = this.estoquedisponivel;
    data['precoweb'] = this.precoweb;
    data['qtvarejo'] = this.qtvarejo;
    data['precovda2'] = this.precovda2;
    return data;
  }
}

class WebProdutosAtalhosItemModel
    extends ODataModelClass<WebProdutosAtalhosItem> {
  WebProdutosAtalhosItemModel() {
    collectionName = 'web_produtos_atalhos';
    super.API = ODataInst();
  }
  WebProdutosAtalhosItem newItem() => WebProdutosAtalhosItem();
}

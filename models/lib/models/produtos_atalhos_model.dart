import 'package:controls_data/data_model.dart';
import 'package:controls_data/odata_client.dart';

class ProdutosCategoriaItem extends DataItem {
  int? codtitulo;
  String? titulo;
  String? inativo;
  double? filial;
  double? peso;
  String? imagem;
  String? codigo;
  String? nome;
  String? unidade;
  String? marca;
  double? precovenda;
  double? estoquedisponivel;
  double? qtvarejo;
  double? precoAtacado;
  double? prompreco;
  //String obs;
  // String sinopse;

  ProdutosCategoriaItem({
    this.codtitulo,
    this.titulo,
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
    this.qtvarejo,
    //this.obs,
    //this.sinopse
  });

  ProdutosCategoriaItem.fromJson(Map<String, dynamic> json) {
    fromMap(json);
  }
  @override
  fromMap(Map<String, dynamic> json) {
    codtitulo = json['codtitulo'] ?? 0;
    titulo = json['titulo'];
    inativo = json['inativo'];
    filial = (json['filial'] ?? '0').toDouble();
    peso = (json['peso'] ?? 0).toDouble();
    imagem = json['imagem'];
    codigo = json['codigo'];
    nome = json['nome'] ?? '';
    unidade = json['unidade'];
    marca = json['marca'];
    precovenda = (json['precovenda'] ?? 0).toDouble();
    estoquedisponivel = (json['estoquedisponivel'] ?? 0).toDouble();
    qtvarejo = (json['qtvarejo'] ?? 0).toDouble();
    precoAtacado = (json['precovda2'] ?? 0).toDouble();
    prompreco = (json['prompreco'] ?? 0).toDouble();
    // obs = json['obs'];
    // sinopse = json['sinopse'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['codtitulo'] = this.codtitulo;
    data['titulo'] = this.titulo;
    data['inativo'] = this.inativo;
    data['filial'] = this.filial;
    data['peso'] = this.peso;
    data['imagem'] = this.imagem;
    data['codigo'] = this.codigo;
    data['nome'] = this.nome;
    data['unidade'] = this.unidade;
    data['marca'] = this.marca;
    data['precovenda'] = this.precovenda ?? 0;
    data['estoquedisponivel'] = this.estoquedisponivel ?? 0;
    data['qtvarejo'] = this.qtvarejo ?? 0;
    // data['obs'] = this.obs;
    // data['sinopse'] = this.sinopse;
    data['precovda2'] = this.precoAtacado;
    data['prompreco'] = this.prompreco;
    return data;
  }

  double precoByQtde([double qtde = 0]) {
    double p = ((prompreco ?? 0) > 0 ? prompreco! : precovenda!);
    if ((precovenda! < p) && (precovenda! > 0)) p = precovenda!;
    if ((qtde > 0) &&
        (precoAtacado! > 0) &&
        (qtvarejo! > 0) &&
        (precoAtacado! < p) &&
        (qtvarejo! <= qtde)) p = precoAtacado!;
    return p;
  }
}

class ProdutosCategoriaItemModel
    extends ODataModelClass<ProdutosCategoriaItem> {
  ProdutosCategoriaItemModel() {
    collectionName = 'web_produtos_atalhos';
    API = ODataInst();
  }
  ProdutosCategoriaItem newItem() => ProdutosCategoriaItem();

  byCategoria(int codigo, double filial) async {
    return search(
        filter: "filial eq $filial and codtitulo eq $codigo",
        orderBy: 'prioridade');
  }
}

// @dart=2.12
import 'package:controls_data/cached.dart';
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

  double? codtitulo;
  String? titulo;
  int? prioridade;
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
  double? precoweb;
  double? qtvarejo;
  double? precovda2;
  double? descmaximo;

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
    double pw = toDouble(json['precoweb']);
    precoweb = (pw == 0) ? precovenda : pw;
    qtvarejo = toDouble(json['qtvarejo']);
    precovda2 = toDouble(json['precovda2']);
    descmaximo = toDouble(json['descmaximo']);
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
    data['descmaximo'] = this.descmaximo;
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

  Future<List<dynamic>> listCachedTabPreco(
      {filter,
      cacheControl,
      resource,
      join,
      top,
      skip,
      orderBy,
      select,
      double? tabelaPreco,
      required double? filial}) async {
    String cached = (cacheControl ?? 'max-age=60');
    String tempo = '1';
    String res = (resource ?? makeCollection(null)) + ' p ';
    if (cached.contains('=')) tempo = cached.split('=')[1];
    String key =
        '${API!.client.headers['contaid']}$res $filter $select ${tabelaPreco ?? ''}';

    String subQueryPreco = '';
    if (tabelaPreco != null)
      subQueryPreco =
          ", (select precovenda from web_ctprod_tabpreco j where j.codigo= p.codigo and filial=$filial and tabela=$tabelaPreco) as pv ";

    String? cols = select;
    if (cols == null)
      cols =
          "p.*, (select descmaximo from ctprod where ctprod.codigo=p.codigo) descmaximo";

    return Cached.value(key, maxage: int.tryParse(tempo) ?? 60, builder: (k) {
      return search(
              resource: res,
              select: '$cols $subQueryPreco',
              filter: filter,
              top: top,
              skip: skip,
              orderBy: orderBy,
              cacheControl: cached)
          .then((ODataResult r) {
        var mp = r.asMap();
        for (var e in mp) {
          if (e['pv'] != null) e['precoweb'] = e['pv'];
          //print(e);
          if (toDouble(e['precoweb']) == 0)
            e['precoweb'] = e['precovenda'] ?? 0;
        }
        return mp;
      });
    });
  }
}

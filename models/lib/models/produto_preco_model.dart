import 'package:controls_data/data_model.dart';
import 'package:controls_data/odata_client.dart';

class WebProdutoPrecoItem extends DataItem {
  String? nome;
  String? nomereduz;
  String? unidade;
  String? marca;
  String? grupo;
  String? setor;
  String? pesavel;
  int? validade;
  String? obsetiqueta;
  double? filial;
  String? codigo;
  double? precovenda;
  double? precovda2;
  double? precovda3;
  double? precoweb;
  String? inativo;
  String? sinopse;
  String? obs;
  double? qtvarejo;

  WebProdutoPrecoItem(
      {this.nome,
      this.nomereduz,
      this.unidade,
      this.marca,
      this.grupo,
      this.setor,
      this.pesavel,
      this.validade,
      this.obsetiqueta,
      this.filial,
      this.codigo,
      this.precovenda,
      this.precovda2,
      this.precovda3,
      this.precoweb,
      this.inativo,
      this.sinopse,
      this.obs});

  WebProdutoPrecoItem.fromJson(Map<String, dynamic> json) {
    fromMap(json);
  }
  @override
  fromMap(Map<String, dynamic> json) {
    nome = json['nome'];
    nomereduz = json['nomereduz'];
    unidade = json['unidade'];
    marca = json['marca'];
    grupo = json['grupo'];
    setor = json['setor'];
    pesavel = json['pesavel'] ?? 'N';
    validade = json['validade'] ?? 0;
    obsetiqueta = json['obsetiqueta'];
    filial = (json['filial'] ?? 0.0).toDouble();
    codigo = json['codigo'];
    precovenda = (json['precovenda'] ?? 0.0).toDouble();
    precovda2 = (json['precovda2'] ?? 0.0).toDouble();
    precovda3 = (json['precovda3'] ?? 0.0).toDouble();
    precoweb = (json['precoweb'] ?? 0.0).toDouble();
    inativo = json['inativo'] ?? 'N';
    sinopse = json['sinopse'] ?? '';
    obs = json['obs'] ?? '';
    qtvarejo = (json['qtvarejo'] ?? 0.0).toDouble();
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nome'] = this.nome;
    data['nomereduz'] = this.nomereduz;
    data['unidade'] = this.unidade;
    data['marca'] = this.marca;
    data['grupo'] = this.grupo;
    data['setor'] = this.setor;
    data['pesavel'] = this.pesavel;
    data['validade'] = this.validade;
    data['obsetiqueta'] = this.obsetiqueta;
    data['filial'] = this.filial;
    data['codigo'] = this.codigo;
    data['precovenda'] = this.precovenda;
    data['precovda2'] = this.precovda2;
    data['precovda3'] = this.precovda3;
    data['precoweb'] = this.precoweb;
    data['inativo'] = this.inativo;
    data['sinopse'] = this.sinopse;
    data['obs'] = this.obs;
    data['qtvarejo'] = this.qtvarejo;
    return data;
  }

  double preco({qtde = 0}) {
    //print(
    //    'qtde $qtde, precoweb $precoweb, precovenda $precovenda, qtvarejo $qtvarejo, precovda2 $precovda2');
    double r = (((precoweb ?? 0) > 0)) ? precoweb! : (precovenda ?? 0);
    if (((qtde ?? 0) > 0) &&
        ((qtvarejo ?? 0) > 0) &&
        ((precovda2 ?? 0) > 0) &&
        ((qtde ?? 0) >= (qtvarejo ?? 0))) r = precovda2 ?? 0;
    // print('$r');
    return r;
  }
}

class WebProdutoPrecoModel extends ODataModelClass<WebProdutoPrecoItem> {
  WebProdutoPrecoModel() {
    collectionName = 'web_ctprod_precos';
    API = ODataInst();
  }
  WebProdutoPrecoItem newItem() => WebProdutoPrecoItem();

  Future<WebProdutoPrecoItem?> getProduto(String codigo, double filial) async {
    WebProdutoPrecoItem? rt; //= ProdutosPrecosCache().findByCodigo(codigo);
    if (rt != null) return rt;
    return search(filter: "codigo eq '$codigo' and filial eq $filial")
        .then((p) {
      //print('chegou ${p[0]}');
      rt = WebProdutoPrecoItem.fromJson(p[0].data());
      ProdutosPrecosCache().addItem(rt!);
      //print('produto chegou');
      return rt;
    });
  }
}

class ProdutosPrecosCache extends DataRows<WebProdutoPrecoItem> {
  static final _singleton = ProdutosPrecosCache._create();
  ProdutosPrecosCache._create();
  factory ProdutosPrecosCache() => _singleton;

  @override
  WebProdutoPrecoItem newItem() {
    return WebProdutoPrecoItem();
  }

  WebProdutoPrecoItem? findByCodigo(String codigo) {
    WebProdutoPrecoItem? rt;

    items.forEach((p) {
      if (p.codigo == codigo) {
        rt = p;
        return;
      }
    });

    return rt;
  }
}

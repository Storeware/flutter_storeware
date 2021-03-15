import 'package:controls_data/data_model.dart';
import 'package:controls_data/odata_client.dart';

class ProdutoCacheModel extends DataRows<ProdutoItem> {
  static final _singleton = ProdutoCacheModel._create();
  ProdutoCacheModel._create();
  factory ProdutoCacheModel() => _singleton;
  @override
  ProdutoItem newItem() {
    return ProdutoItem();
  }

  ProdutoItem? findByCodigo(String codigo) {
    ProdutoItem? rt;

    items.forEach((p) {
      if (p.codigo == codigo) {
        rt = p;
        return;
      }
    });

    return rt;
  }
}

class ProdutoItem extends DataItem {
  String? inativo;
  double? filial;
  double? peso;
  String? imagem;
  String? codigo;
  String? nome;
  String? categoria;
  String? subcategoria;
  String? marca;
  double? precovenda;
  double? qtvarejo;
  double? precovda2;
  String? obs;
  String? sinopse;

  ProdutoItem(
      {this.inativo,
      this.filial,
      this.peso,
      this.imagem,
      this.codigo,
      this.nome,
      this.categoria,
      this.subcategoria,
      this.marca,
      this.precovenda,
      this.qtvarejo,
      this.precovda2,
      this.obs,
      this.sinopse});

  ProdutoItem.fromJson(Map<String, dynamic> json) {
    fromMap(json);
  }
  @override
  fromMap(Map<String, dynamic> json) {
    inativo = json['inativo'];
    filial = toDouble(json['filial']);
    peso = toDouble(json['peso']);
    imagem = json['imagem'];
    codigo = json['codigo'];
    nome = json['nome'];
    categoria = json['categoria'];
    subcategoria = json['subcategoria'];
    marca = json['marca'];
    precovenda = toDouble(json['precovenda']);
    qtvarejo = toDouble(json['qtvarejo']);
    precovda2 = toDouble(json['precovda2']);
    obs = json['obs'];
    sinopse = json['sinopse'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['inativo'] = this.inativo;
    data['filial'] = this.filial;
    data['peso'] = this.peso;
    data['imagem'] = this.imagem;
    data['codigo'] = this.codigo;
    data['nome'] = this.nome;
    data['categoria'] = this.categoria;
    data['subcategoria'] = this.subcategoria;
    data['marca'] = this.marca;
    data['precovenda'] = this.precovenda;
    data['qtvarejo'] = this.qtvarejo;
    data['precovda2'] = this.precovda2;
    data['obs'] = this.obs;
    data['sinopse'] = this.sinopse;
    return data;
  }
}

class ProdutosItemModel extends ODataModelClass<ProdutoItem> {
  ProdutosItemModel() {
    collectionName = 'web_produtos';
    API = ODataInst();
  }
  ProdutoItem newItem() => ProdutoItem();

  Future<ProdutoItem?> getProduto(String codigo, double filial) async {
    ProdutoItem? rt = ProdutoCacheModel().findByCodigo(codigo);
    if (rt != null) return rt;
    return search(filter: "codigo eq '$codigo' and filial eq $filial")
        .then((p) {
      //print(p[0].data());
      rt = ProdutoItem.fromJson(p[0].data());
      ProdutoCacheModel().addItem(rt!);
      return rt;
    });
  }
}

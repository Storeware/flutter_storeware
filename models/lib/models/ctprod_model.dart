//https://javiercbk.github.io/json_to_dart/
import 'package:controls_data/cached.dart';
import 'package:controls_data/data_model.dart';
import 'package:controls_data/odata_client.dart';

import 'package:controls_data/odata_firestore.dart';

class ProdutoItem extends DataItem {
  String codigo;
  String nome;
  double precoweb = 0;
  String unidade = "UN";
  String sinopse;
  String obs;
  double codtitulo; // codigo do atalho
  bool publicaweb = true;
  bool inservico = false;
  double filial;
  ProdutoItem(
      {this.codigo,
      this.nome,
      this.precoweb,
      this.unidade,
      this.sinopse,
      this.inservico,
      this.obs});

  ProdutoItem.fromJson(Map<String, dynamic> json) {
    fromMap(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['codigo'] = this.codigo;
    data['nome'] = this.nome;
    data['precoweb'] = this.precoweb ?? 0;
    data['unidade'] = (this.unidade ?? '').length == 0 ? 'UN' : this.unidade;
    data['sinopse'] = this.sinopse;
    data['obs'] = this.obs;
    data['codtitulo'] = this.codtitulo;
    data['publicaweb'] = (this.publicaweb ?? 'S') ? 'S' : 'N';
    data['inservico'] = (this.inservico ?? 'N') ? 'S' : 'N';
    data['id'] = '$codigo';
    data['filial'] = filial;
    return data;
  }

  fullJson() {
    var r = toJson();
    r['id'] = this.codigo;
    return r;
  }

  @override
  fromMap(Map<String, dynamic> json) {
    codigo = json['codigo'];
    nome = json['nome'];
    precoweb = toDouble(json['precoweb']);
    unidade = json['unidade'] ?? '';
    if (unidade == '') unidade = 'UN';
    try {
      sinopse = json['sinopse'] ?? '';
    } catch (e) {
      sinopse = null;
    }
    obs = json['obs'];
    codtitulo = toDouble(json['codtitulo']);
    this.publicaweb = (json['publicaweb' ?? 'S'] == 'S');
    this.inservico = (json['inservico'] ?? 'N') == 'S';
    this.filial = toDouble(json['filial']);
  }

  static List<String> get keys {
    List<String> k = ProdutoItem.fromJson({}).toJson().keys.toList();
    k.remove('codtitulo'); // nao pertence a tabela
    return k;
  }

  static Map<String, dynamic> copy(dados) {
    var d;
    if (dados is ProdutoItem)
      d = ProdutoItem.fromJson(dados.toJson());
    else
      d = ProdutoItem.fromJson(dados);
    return d.toJson();
  }
}

class ProdutoModel extends ODataModelClass<ProdutoItem> {
  static final _singleton = ProdutoModel._create();
  ProdutoModel._create() {
    collectionName = 'ctprod';
    super.API = ODataInst();
    super.CC = CloudV3().client..client.silent = true;

    columns = ProdutoItem.keys.join(',').replaceAll(',id', '');
    externalKeys = 'codtitulo,id';
  }
  factory ProdutoModel() => _singleton;

  ProdutoItem newItem() => ProdutoItem();

  Future<List<dynamic>> listGrid(
      {String filter,
      top: 20,
      skip: 0,
      String orderBy,
      double filial = 1}) async {
    return search(
            resource: 'ctprod',
            select:
                'ctprod.codigo,ctprod.inservico, ctprod.nome, coalesce( (select precoweb from ctprod_filial where codigo=ctprod.codigo and filial = $filial) ,ctprod.precoweb) precoweb ,ctprod.unidade,ctprod.obs,cast(ctprod.sinopse as varchar(1024)) sinopse , i.codtitulo',
            filter: filter,
            join:
                ' left join ctprod_atalho_itens i on (i.codprod=ctprod.codigo)',
            orderBy: orderBy ?? 'ctprod.dtatualiz desc',
            top: top,
            skip: skip,
            cacheControl: 'no-cache')
        .then((rsp) {
      //debugPrint('$rsp');
      return rsp.asMap();
    });
    //});
  }

  clearCached() {
    Cached.clearLike('listGrid');
  }

  @override
  put(item) {
    var it = ProdutoItem.copy(item);
    return super.put(it).then((rsp) {
      atalhoUpdate(it);
      updatePrecoFilial(it);
      return rsp;
    });
  }

  @override
  post(item) {
    var it = ProdutoItem.copy(item);
    return super.post(it).then((rsp) {
      atalhoUpdate(it);
      updatePrecoFilial(it);
      return rsp;
    });
  }

  Future<String> atalhoUpdate(item) async {
    if (item != null) {
      if ((item['codtitulo'] ?? 0) == 0) return null;
      // atalhoUpdate
      String upd =
          "update or insert into ctprod_atalho_itens (codtitulo,codprod) values(${item['codtitulo']},'${item['codigo']}') matching (codprod)   ";
      return API.execute(upd);
    }
  }

  Future<String> updatePrecoFilial(Map<String, dynamic> dados) async {
    var it = ProdutoItem.fromJson(dados);
    if ((it.filial ??= 0) > 0) {
      var p = '${it.precoweb}'.replaceAll(',', '.');
      var upd =
          "update or insert into ctprod_filial (codigo,filial,precoweb) values ('${it.codigo}',${it.filial}, ${p}) matching (codigo,filial)";
      print(upd);
      return API.execute(upd);
    }
  }

  Future<Map<String, dynamic>> buscarByCodigo(String codigo) async {
    return listCached(
            filter: "codigo eq '$codigo'",
            select:
                'codigo,nome,precoweb,unidade,cast(sinopse as varchar(1024)) sinopse,obs,publicaweb,inservico')
        .then((rsp) => rsp[0]);
  }
}

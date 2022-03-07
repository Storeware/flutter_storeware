// @dart=2.12
//https://javiercbk.github.io/json_to_dart/
import 'package:controls_data/cached.dart';
import 'package:controls_data/data_model.dart';
import 'package:controls_data/odata_client.dart';

import 'package:controls_data/odata_firestore.dart';

class CtProdItem extends DataItem {
  String? codigo;
  String? nome;
  double? precoweb = 0;
  String? unidade = "UN";
  String? sinopse;
  String? obs;
  double? codtitulo; // codigo do atalho
  bool publicaweb = true;
  bool inservico = false;
  double? filial;
  String inativo = 'N';
  double descmaximo = 0;
  CtProdItem({
    this.codigo,
    this.nome,
    this.precoweb,
    this.unidade,
    this.sinopse,
    this.inservico = false,
    this.obs,
    this.descmaximo = 0,
  });

  CtProdItem.fromJson(Map<String, dynamic> json) {
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
    data['publicaweb'] = (this.publicaweb) ? 'S' : 'N';
    data['inservico'] = (this.inservico) ? 'S' : 'N';
    data['id'] = '$codigo';
    data['filial'] = filial;
    data['inativo'] = this.inativo;
    data['codtitulo'] = this.codtitulo;
    data['descmaximo'] = this.descmaximo;
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
    this.publicaweb = (json['publicaweb'] ?? 'S') == 'S';
    this.inservico = (json['inservico'] ?? 'N') == 'S';
    this.filial = toDouble(json['filial']);
    this.inativo = json['inativo'] ?? 'N';
    this.descmaximo = toDouble(json['descmaximo']);
  }

  static List<String> get keys {
    List<String> k = CtProdItem.fromJson({}).toJson().keys.toList();
    k.remove('codtitulo'); // nao pertence a tabela
    return k;
  }

  static Map<String, dynamic>? copy(dados) {
    var d;
    if (dados is CtProdItem)
      d = CtProdItem.fromJson(dados.toJson());
    else
      d = CtProdItem.fromJson(dados);
    return d.toJson();
  }
}

class CtProdItemModel extends ODataModelClass<CtProdItem> {
  static final _singleton = CtProdItemModel._create();
  CtProdItemModel._create() {
    collectionName = 'ctprod';
    super.API = ODataInst();
    super.CC = CloudV3().client..client.silent = true;

    columns = CtProdItem.keys.join(',').replaceAll(',id', '');
    externalKeys = 'codtitulo,id';
  }
  factory CtProdItemModel() => _singleton;

  CtProdItem newItem() => CtProdItem();

  Future<List<dynamic>> listGridTabPreco(
      {String? filter,
      top: 20,
      skip: 0,
      String? orderBy,
      double? filial = 1,
      String? intraFilter,
      double? tabelaPreco}) async {
    String ftr =
        (((intraFilter ?? '').isNotEmpty) ? ' and ' : '') + (intraFilter ?? '');

    String subQueryPreco =
        "select (case when coalesce(precoweb,0)=0 then precovenda else precoweb end) from ctprod_filial where ctprod_filial.codigo=ctprod.codigo and ctprod_filial.filial = $filial";
    if (tabelaPreco != null)
      subQueryPreco =
          "select precovenda from web_ctprod_tabpreco tab where tab.codigo=ctprod.codigo and tab.filial=$filial and tab.tabela=$tabelaPreco ";
    return search(
            resource: 'ctprod',
            select: 'ctprod.descmaximo, ctprod.codigo,ctprod.inservico,ctprod.inativo, ctprod.nome, ' +
                'coalesce( ( $subQueryPreco ) ,' +
                'case when coalesce(ctprod_filial.precoweb,0)=0 then ctprod_filial.precovenda else ctprod_filial.precoweb end) precoweb ,' +
                'ctprod.unidade,ctprod.obs ,ctprod.sinopse  , i.codtitulo',
            filter: (filter == null)
                ? 'ctprod.nome is not null'
                : '$filter and ctprod.nome is not null $ftr',
            join: ' left join ctprod_atalho_itens i on (i.codprod=ctprod.codigo) ' +
                " left join ctprod_filial on (ctprod_filial.codigo=ctprod.codigo and ctprod_filial.filial=$filial)",
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
    var it = CtProdItem.copy(item);
    return super.put(it).then((rsp) {
      atalhoUpdate(item);
      updatePrecoFilial(it!);
      return rsp!;
    });
  }

  @override
  post(item) {
    var it = CtProdItem.copy(item);
    return super.post(it).then((rsp) {
      atalhoUpdate(item);
      updatePrecoFilial(it!);
      return rsp!;
    });
  }

  Future<String?> atalhoUpdate(item) async {
    if (item != null) {
      if ((item['codtitulo'] ?? 0) == 0) return null;
      if (driver == 'mssql') {
        item['codprod'] = item['codigo'];
        return API!.put(
          'ctprod_atalho_itens',
          item,
        );
      }
      String upd =
          "update or insert into ctprod_atalho_itens (codtitulo,codprod) values(${item['codtitulo']},'${item['codigo']}') matching (codprod)   ";
      return API!.execute(upd);
    }
    return null;
  }

  Future<String?> updatePrecoFilial(Map<String, dynamic> dados) async {
    var it = CtProdItem.fromJson(dados);
    if ((it.filial ??= 0) > 0) {
      if (driver == 'mssql') return API!.put('ctprod_filial', dados);
      var p = '${it.precoweb}'.replaceAll(',', '.');
      var upd =
          "update or insert into ctprod_filial (codigo,filial,precoweb) values ('${it.codigo}',${it.filial}, $p) matching (codigo,filial)";
      // print(upd);
      return API!.execute(upd);
    }
    return null;
  }

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
      required double? filial,
      String alias = 'p'}) async {
    String cached = (cacheControl ?? 'max-age=60');
    String tempo = '1';
    String res = (resource ?? makeCollection(null)) + ' $alias ';
    if (cached.contains('=')) tempo = cached.split('=')[1];
    String key =
        "${API!.client.headers['contaid']}$res $filter $select ${tabelaPreco ?? ''}";
    String subQueryPreco = '';
    if (tabelaPreco != null)
      subQueryPreco = ", (select precovenda from web_ctprod_tabpreco " +
          " where codigo= $alias.codigo and filial=$filial! and tabela=$tabelaPreco!) as pv ";
    return Cached.value(key, maxage: int.tryParse(tempo) ?? 60, builder: (k) {
      return search(
              resource: res,
              select: '${select ?? columns} $subQueryPreco',
              filter: filter,
              top: top,
              skip: skip,
              orderBy: orderBy,
              cacheControl: cached)
          .then((ODataResult r) {
        var mp = r.asMap();
        for (var e in mp) {
          if (e['pv'] != null) e['precoweb'] = e['pv'];
          if (toDouble(e['precoweb']) == 0 && e['precovenda'] != null)
            e['precoweb'] = e['precovenda'];
        }
        return mp;
      });
    });
  }

  Future<Map<String, dynamic>> buscarByCodigo(String? codigo,
      {double filial = 0, double? tabelaPreco}) async {
    return listCachedTabPreco(
            filial: filial,
            tabelaPreco: tabelaPreco,
            alias: 'p',
            filter: "codigo eq '$codigo'",
            select:
                'codigo,nome,(select case when coalesce(precoweb,0)=0 then precovenda else precoweb end from ctprod_filial b where b.codigo=p.codigo and b.filial=$filial) precoweb,' +
                    'unidade, sinopse,obs,publicaweb,inservico')
        .then((rsp) => (rsp.length > 0) ? rsp[0] : {});
  }
}

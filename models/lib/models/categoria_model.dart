import 'dart:convert';
import 'package:controls_data/cached.dart';
import 'package:controls_data/data_model.dart';
import 'package:controls_data/odata_client.dart';
import 'package:controls_data/odata_firestore.dart';

class CategoriaItem extends DataItem {
  int? codigo = 0;
  String? nome;
  int? codigoPai = 0;
  int? prioridade = 0;
  int? conta = 0;

  CategoriaItem({this.codigo, this.nome, this.codigoPai, this.prioridade});

  CategoriaItem.fromJson(Map<String, dynamic> json) {
    fromMap(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['codigo'] = this.codigo;
    data['nome'] = this.nome;
    data['codigo_pai'] = this.codigoPai;
    data['prioridade'] = this.prioridade;
    data['id'] = this.codigo;

    return data;
  }

  @override
  fromMap(Map<String, dynamic> json) {
    codigo = toInt(json['codigo']);
    nome = json['nome'];
    codigoPai = toInt(json['codigo_pai']);
    prioridade = toInt(json['prioridade']);
    conta = toInt(json['conta']);
    return this;
  }
}

class CategoriaModel extends ODataModelClass<CategoriaItem> {
  static final _singleton = CategoriaModel._create();
  CategoriaModel._create() {
    collectionName = 'ctprod_atalho_titulo';
    super.API = ODataInst();
    super.CC = CloudV3().client..client.silent = true;

    //columns = CategoriaItem.keys.join(',');
    externalKeys = '';
  }
  factory CategoriaModel() => _singleton;

  CategoriaItem newItem() => CategoriaItem();

  @override
  Future<Map<String, dynamic>> enviar(CategoriaItem item) async {
    var values =
        [item.codigo, item.nome, item.prioridade, item.codigoPai].join("','");
    String cmd = '''select * from ESTAPP_SP_CATEG_INSERIR('$values')''';
    return ODataInst()
        .post('command', {'command': '$cmd'}, removeNulls: false)
        .then((rsp) => jsonDecode(rsp));
  }

  buscar([String? queryStr]) async {
    String filter = '';
    if (queryStr != null) {
      String query = queryStr;

      bool isNum = (int.tryParse(query) != null);

      if (isNum) {
        filter = ''' codigo eq $query ''';
      } else {
        query = query.replaceAll(' ', '%25').toLowerCase();
        filter = ''' lower(nome) like '$query%25' ''';
      }
    }
    var oDataQ = ODataQuery(
        resource: 'estapp_cons_categ',
        select: '*',
        top: 100,
        filter: (queryStr != null) ? filter : null);
    return ODataInst().send(oDataQ);
  }

  listGrid({filter, top = 20, skip = 0, orderBy}) {
    return Cached.value('categoria_$filter', builder: (k) {
      return search(
        resource: collectionName,
        filter: filter,
        top: top,
        skip: skip,
        orderBy: orderBy,
        cacheControl: 'no-cache',
      ).then((rsp) => rsp.asMap());
    });
  }

  clearCached() {
    Cached.clearLike('categoria_');
  }

  buscarByCodigo(codigo) {
    return listCached(filter: "codigo eq $codigo", select: 'codigo, nome')
        .then((rsp) => (rsp.length == 0) ? {} : rsp[0]);
  }
}

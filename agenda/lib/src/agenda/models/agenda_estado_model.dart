// @dart=2.12

import 'package:controls_data/data_model.dart';
import 'package:controls_data/odata_client.dart';
import 'package:controls_data/odata_firestore.dart';
import 'package:uuid/uuid.dart';

class AgendaEstadoItem extends DataItem {
  String? gid;
  String? nome;
  String? encerrado;
  int? ordem;
  String? inativo;
  String? cor;
  int? corQuadrado;

  /// internoOrdem  de uso interno - não faz parte da coleção
  int internoOrdem = 0;

  AgendaEstadoItem(
      {this.gid,
      this.nome,
      this.encerrado,
      this.ordem,
      this.inativo,
      this.cor,
      this.corQuadrado});

  AgendaEstadoItem.fromJson(Map<String, dynamic> json) {
    fromMap(json);
  }
  @override
  fromMap(Map<String, dynamic> json) {
    gid = json['gid'];
    nome = json['nome'];
    encerrado = json['encerrado'] ?? 'S';
    ordem = json['ordem'] ?? 999;
    inativo = json['inativo'] ?? 'N';
    cor = json['cor'];
    corQuadrado = json['cor_quadrado'] ?? 1;
    internoOrdem = json['internoOrdem'] ?? 0;
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    this.gid ??= Uuid().v4();
    data['gid'] = this.gid;
    data['nome'] = this.nome;
    data['encerrado'] = this.encerrado ?? 'S';
    data['ordem'] = this.ordem;
    data['inativo'] = this.inativo ?? 'N';
    data['cor'] = this.cor;
    data['cor_quadrado'] = this.corQuadrado ?? 1;
    data['id'] = this.gid;
    data['internoOrdem'] = this.internoOrdem;
    return data;
  }
}

class AgendaEstadoItemModel extends ODataModelClass<AgendaEstadoItem> {
  static final _singleton = AgendaEstadoItemModel._create();
  AgendaEstadoItemModel._create() {
    collectionName = 'agenda_estado';
    super.API = ODataInst();
    super.CC = CloudV3().client..client.silent = true;
  }
  factory AgendaEstadoItemModel() => _singleton;

  AgendaEstadoItem newItem() => AgendaEstadoItem();
  List<dynamic> _list = [];

  listAll({filter}) async {
    if (_list.length > 0) return _list;
    return super.listNoCached(filter: filter ?? "inativo eq 'N' ").then((rsp) {
      var seq = 0;
      rsp.forEach((item) {
        item['internoOrdem'] = seq++;
        _list.add(item);
      });
      return _list;
    });
  }

  Future<AgendaEstadoItem?> procurar(String? gid) async {
    await listAll();
    var rsp;
    _list.forEach((item) {
      if (item['gid'] == gid) rsp = AgendaEstadoItem.fromJson(item);
    });
    return rsp;
  }

  @override
  bool validate(value) {
    if ((value['gid'] ?? '').isEmpty) {
      throw 'Falta o identificador do estado';
    }
    return true;
  }
}

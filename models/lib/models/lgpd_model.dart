// @dart=2.12
//import 'dart:convert';

//import 'package:controls_data/data_model.dart';
//import 'package:controls_data/odata_client.dart';
//import 'package:controls_data/odata_firestore.dart';
//import 'package:universal_html/html.dart';
import 'historico_model.dart';

class LgpdItem extends HistoricoItem {}

class LgpdItemModel extends HistoricoItemModel {
  static register(
      {double? codigo,
      DateTime? data,
      String? origem,
      String? info,
      String? usuario}) async {
    return HistoricoItemModel.registerLGPD(
      codigoPessoa: codigo,
      info: info,
      origem: origem,
      usuario: usuario,
      titulo: 'Acesso aos dados',
    );
  }
}

/*

--- substiuido pelo Eventos_Item / HistoricoItemModel
class LgpdItem extends DataItem {
  double codigo;
  DateTime data;
  String origem;
  String info;
  String usuario;
  String gid;
  LgpdItem(
      {this.codigo, this.usuario, this.data, this.origem, this.gid, this.info});
  @override
  LgpdItem.fromJson(Map<String, dynamic> data) {
    fromMap(data);
  }

  @override
  Map<String, dynamic> toJson() {
    data ??= DateTime.now();
    return {
      "codigo": this.codigo,
      "data": toDateTimeSql(this.data),
      "origem": this.origem,
      "info": this.info,
      "usuario": this.usuario,
      "gid": this.gid,
    };
  }

  @override
  fromMap(Map<String, dynamic> data) {
    this.codigo = toDouble(data['codigo']);
    this.data = toDateTime(data['data']);
    this.origem = data['origem'];
    this.info = data['info'];
    this.usuario = data['usuario'];
    this.gid = data['gid'];
    id = data['id'];
  }
}

class LgpdItemModel extends ODataModelClass<LgpdItem> {
  Map<String, dynamic> currentItem;
  LgpdItemModel() {
    super.API = CloudV3().client;
  }
  @override
  makeCollection(Map<String, dynamic> item) {
    if (item != null) currentItem = item;
    if (item == null && currentItem == null)
      throw "Falta indicar a pessoa para criar a origem dos dados (lgpd)";
    collectionName = 'lgpd:{codigo}:acessos'
        .replaceAll('{codigo}', '${currentItem['codigo'] ~/ 1}');
    return collectionName;
  }

  LgpdItem newItem() => LgpdItem();
  @override
  post(item) {
    try {
      return super.post(item);
    } catch (e) {
      /// nao faz nada;
      return null;
    }
  }

  static register(
      {double codigo,
      DateTime data,
      String origem,
      String info,
      String usuario}) async {
    final item = LgpdItem();
    item.codigo = codigo;
    item.data = data ?? DateTime.now();
    item.origem = origem;
    item.info = info;
    item.usuario = usuario;
    return LgpdItemModel().post(item);
  }
}
*/

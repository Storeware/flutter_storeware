import 'package:controls_data/data_model.dart';
import 'package:controls_data/odata_client.dart';
import 'package:controls_extensions/extensions.dart' hide DynamicExtension;
import 'package:controls_data/odata_firestore.dart';

/*

 Resumo para Dashboard

 */

class Sigcaut2HoraItem extends DataItem {
  String? codigo;
  DateTime? data;
  String? hora;
  double? qtde;
  String? grupo;
  double? filial;
  double? total;
  int? itens;

  Sigcaut2HoraItem(
      {this.codigo,
      this.data,
      this.hora,
      this.qtde,
      this.grupo,
      this.filial,
      this.total});

  Sigcaut2HoraItem.fromJson(Map<String, dynamic> json) {
    fromMap(json);
  }
  @override
  fromMap(Map<String, dynamic> json) {
    codigo = json['codigo'];
    data = toDateTime(json['data']);
    hora = json['hora'];
    qtde = toDouble(json['qtde']);
    grupo = json['grupo'];
    filial = toDouble(json['filial']);
    total = toDouble(json['total']);
    itens = toInt(json['itens']);
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['codigo'] = this.codigo;
    data['data'] = this.data;
    data['hora'] = this.hora;
    data['qtde'] = this.qtde;
    data['grupo'] = this.grupo;
    data['filial'] = this.filial;
    data['total'] = this.total;
    data['itens'] = this.itens; // é virtual;
    data['id'] = '$filial-$codigo-${this.data?.format('yyyMMdd') ?? ''}$hora';
    return data;
  }
}

class Sigcaut2HoraItemModel extends ODataModelClass<Sigcaut2HoraItem> {
  Sigcaut2HoraItemModel() {
    collectionName = 'Sigcaut2_hora';
    super.API = ODataInst();
    super.CC = CloudV3().client;
  }
  Sigcaut2HoraItem newItem() => Sigcaut2HoraItem();

  Future<ODataResult> resumoDiaHora({DateTime? data, filial}) {
    String dt = ((data ?? DateTime.now())).toIso8601String().substring(0, 10);
    String qry =
        "select data,hora, sum(qtde) qtde,sum(total) total, count(*) itens from Sigcaut2_hora " +
            "where data = '$dt' ${(filial != null) ? ' and filial=$filial' : ''} " +
            "group by data,hora ";
    return API!.openJson(qry).then((rsp) {
      return ODataResult(json: rsp);
    });
  }

  Future<ODataResult> resumoDia({DateTime? inicio, DateTime? fim, filial}) {
    DateTime? _de = inicio;
    if (_de == null) {
      _de = DateTime.now().startOfMonth();
    }
    DateTime? _ate = fim;
    if (_ate == null) _ate = DateTime.now().endOfMonth();
    String qry =
        "select data, sum(qtde) qtde,sum(total) total, count(*) itens from Sigcaut2_hora " +
            "where data between '${_de.toIso8601String().substring(0, 10)}' and '${_ate.toIso8601String().substring(0, 10)}' ${(filial != null) ? ' and filial=$filial' : ''} " +
            "group by data ";
    return API!.openJson(qry).then((rsp) {
      return ODataResult(json: rsp);
    });
  }
}

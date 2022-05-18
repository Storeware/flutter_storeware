// @dart=2.12
import 'package:controls_data/data_model.dart';
import 'package:controls_data/odata_client.dart';

class SigcautpItem extends DataItem {
  String? codigo;
  DateTime? data;
  String? dcto;
  double? desctotal;
  double? filial;
  //int id;
  double? idrefer;
  double? oldfilial;
  double? operadora;
  int? parcela;
  String? registrado;
  String? tipo;
  double? valor;
  DateTime? vcto;
  double? valorpago;
  double? sigcauthlote;
  int? ordem;
  String? pgtoOnline;
  String? codtrans;

  SigcautpItem(
      {this.codigo,
      this.data,
      this.dcto,
      this.desctotal,
      this.filial,
      //this.id,
      this.idrefer,
      this.oldfilial,
      this.operadora,
      this.parcela,
      this.registrado,
      this.tipo,
      this.valor,
      this.vcto,
      this.valorpago,
      this.sigcauthlote,
      this.ordem,
      this.pgtoOnline,
      this.codtrans});

  SigcautpItem.fromJson(Map<String, dynamic> json) {
    fromMap(json);
  }
  @override
  fromMap(Map<String, dynamic> json) {
    codigo = json['codigo'];
    data = toDateTime(json['data']);
    dcto = json['dcto'];
    desctotal = toDouble(json['desctotal']);
    filial = json['filial'];
    id = json['id'];
    idrefer = json['idrefer'];
    oldfilial = json['oldfilial'];
    operadora = json['operadora'];
    parcela = json['parcela'];
    registrado = json['registrado'];
    tipo = json['tipo'];
    valor = json['valor'];
    vcto = json['vcto'];
    valorpago = json['valorpago'];
    sigcauthlote = json['sigcauthlote'];
    ordem = json['ordem'];
    pgtoOnline = json['pgto_online'];
    codtrans = json['codTrans'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['codigo'] = this.codigo;
    data['data'] = this.data;
    data['dcto'] = this.dcto;
    data['desctotal'] = this.desctotal;
    data['filial'] = this.filial;
    data['id'] = this.id;
    data['idrefer'] = this.idrefer;
    data['oldfilial'] = this.oldfilial;
    data['operadora'] = this.operadora;
    data['parcela'] = this.parcela;
    data['registrado'] = this.registrado;
    data['tipo'] = this.tipo;
    data['valor'] = this.valor;
    data['vcto'] = this.vcto;
    data['valorpago'] = this.valorpago;
    data['sigcauthlote'] = this.sigcauthlote;
    data['ordem'] = this.ordem;
    data['pgto_online'] = this.pgtoOnline;
    data['codtrans'] = this.codtrans;
    return data;
  }
}

class SigcautpItemModel extends ODataModelClass<SigcautpItem> {
  SigcautpItemModel() {
    collectionName = 'sigcautp';
    super.API = ODataInst();
  }
  SigcautpItem newItem() => SigcautpItem();
}

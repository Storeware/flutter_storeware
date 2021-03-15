import 'package:controls_data/data_model.dart';
import 'package:controls_data/odata_client.dart';

class SigbcoSaldosItem extends DataItem {
  String? codigo;
  int? valor;
  String? dtatualiz;

  SigbcoSaldosItem({this.codigo, this.valor, this.dtatualiz});

  SigbcoSaldosItem.fromJson(Map<String, dynamic> json) {
    fromMap(json);
  }
  @override
  fromMap(Map<String, dynamic> json) {
    codigo = json['codigo'];
    valor = json['valor'];
    dtatualiz = json['dtatualiz'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['codigo'] = this.codigo;
    data['valor'] = this.valor;
    data['dtatualiz'] = this.dtatualiz;
    return data;
  }
}

class SigbcoSaldosItemModel extends ODataModelClass<SigbcoSaldosItem> {
  SigbcoSaldosItemModel() {
    collectionName = 'sigbco_saldos';
    super.API = ODataInst();
  }
  SigbcoSaldosItem newItem() => SigbcoSaldosItem();
  saldos({String? filter}) {
    return listNoCached(
        filter: filter,
        resource: 'sigbco_saldos a join sigbco b on (a.codigo=b.codigo)',
        select: 'a.*,b.nome');
  }
}

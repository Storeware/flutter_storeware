import 'package:controls_data/data_model.dart';
import 'package:controls_data/odata_client.dart';
import 'package:controls_data/odata_firestore.dart';
import 'package:controls_extensions/extensions.dart' hide DynamicExtension;

class CtprodFilialPromocaoItem extends DataItem {
  double filial;
  String codigo;
  DateTime promdtini;
  DateTime promdtfim;
  double prompreco;
  DateTime dtatualiz;

  CtprodFilialPromocaoItem(
      {this.filial,
      this.codigo,
      this.promdtini,
      this.promdtfim,
      this.prompreco,
      this.dtatualiz});

  CtprodFilialPromocaoItem.fromJson(Map<String, dynamic> json) {
    fromMap(json);
  }
  @override
  fromMap(Map<String, dynamic> json) {
    id = json['id'];
    filial = toDouble(json['filial']);
    codigo = json['codigo'];
    promdtini = toDateTime(json['promdtini']);
    promdtfim = toDateTime(json['promdtfim']);
    prompreco = toDouble(json['prompreco']);
    dtatualiz = toDateTime(json['dtatualiz']);
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['filial'] = this.filial;
    data['codigo'] = this.codigo;
    data['promdtini'] =
        toDateTimeSql(this.promdtini ?? DateTime.now().startOfDay());
    data['promdtfim'] =
        toDateTimeSql(this.promdtfim ?? DateTime.now().endOfDay());
    data['prompreco'] = this.prompreco;
    data['dtatualiz'] = toDateTimeSql(this.dtatualiz ?? DateTime.now());
    data['id'] = '$filial-$codigo';
    return data;
  }
}

class CtprodFilialPromocaoItemModel
    extends ODataModelClass<CtprodFilialPromocaoItem> {
  CtprodFilialPromocaoItemModel() {
    collectionName = 'ctprod_filial_promocao';
    super.API = ODataInst();
    super.CC = CloudV3().client..client.silent = true;
  }
  CtprodFilialPromocaoItem newItem() => CtprodFilialPromocaoItem();
}

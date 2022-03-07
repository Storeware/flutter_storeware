// @dart=2.12
import 'package:controls_data/data_model.dart';
import 'package:controls_data/odata_client.dart';
//import 'package:controls_extensions/extensions.dart';

class CtgrupoItem extends DataItem {
  String? grupo;
  String? nome;
  DateTime? dtatualiz;
  String? sintetico;
  String? isSintetico;

  CtgrupoItem({this.grupo, this.nome});

  CtgrupoItem.fromJson(Map<String, dynamic> json) {
    fromMap(json);
  }
  @override
  fromMap(Map<String, dynamic> json) {
    grupo = json['grupo'];
    nome = json['nome'];
    dtatualiz = toDateTime(json['dtatualiz']);
    sintetico = json['sintetico'];
    isSintetico = json['issintetico'] ?? 'N';
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['grupo'] = this.grupo;
    data['nome'] = this.nome;
    data['dtatualiz'] = dtatualiz;
    data['issintetico'] = this.isSintetico;
    data['sintetico'] = this.sintetico;
    return data;
  }
}

class CtgrupoItemModel extends ODataModelClass<CtgrupoItem> {
  CtgrupoItemModel() {
    collectionName = 'ctgrupo';
    super.API = ODataInst();
  }
  CtgrupoItem newItem() => CtgrupoItem();
}

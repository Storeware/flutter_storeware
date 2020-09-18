import 'package:controls_data/data_model.dart';
import 'package:controls_data/odata_client.dart';
import 'package:controls_data/odata_firestore.dart';

class CtprodUnidadeItem extends DataItem {
  String codigo;
  String descricao;
  String permitefracao;
  String abreviacao;

  CtprodUnidadeItem(
      {this.codigo, this.descricao, this.permitefracao, this.abreviacao});

  CtprodUnidadeItem.fromJson(Map<String, dynamic> json) {
    fromMap(json);
  }
  @override
  fromMap(Map<String, dynamic> json) {
    codigo = json['codigo'];
    descricao = json['descricao'];
    permitefracao = json['permitefracao'];
    abreviacao = json['abreviacao'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['codigo'] = this.codigo;
    data['descricao'] = this.descricao;
    data['permitefracao'] = this.permitefracao;
    data['abreviacao'] = this.abreviacao;
    data['id'] = '$codigo';
    return data;
  }
}

class CtprodUnidadeItemModel extends ODataModelClass<CtprodUnidadeItem> {
  CtprodUnidadeItemModel() {
    collectionName = 'ctprod_unidade';
    super.API = ODataInst();
    super.CC = CloudV3().client..client.silent = true;
  }
  CtprodUnidadeItem newItem() => CtprodUnidadeItem();
}

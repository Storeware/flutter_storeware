import 'package:controls_data/data_model.dart';
import 'package:controls_data/odata_client.dart';
import 'package:controls_data/odata_firestore.dart';

class EstoperItem extends DataItem {
  String? codigo;
  String? nome;
  String? codfinanc;

  bool? icmsiscustos = false;
  bool? ipiiscustos = false;
  bool? isentrada = false;

  bool? mudafinanc = true;
  bool? mudapmedio = true;
  bool? naoatualpreco = false;

  bool? somacompras = false;
  bool? somavendas = false;
  bool? somaconsig = false;
  bool? somademanda = true;
  bool? mudaestoq = true;

  EstoperItem(
      {this.codfinanc,
      this.codigo,
      this.icmsiscustos,
      // this.id,
      this.ipiiscustos,
      this.isentrada,
      this.mudafinanc,
      this.mudapmedio,
      this.nome,
      this.somacompras,
      this.somavendas,
      this.naoatualpreco,
      this.mudaestoq,
      this.somaconsig,
      this.somademanda});

  EstoperItem.fromJson(Map<String, dynamic> json) {
    fromMap(json);
  }
  @override
  fromMap(Map<String, dynamic> json) {
    codfinanc = json['codfinanc'];
    codigo = json['codigo'];
    icmsiscustos = json['icmsiscustos'] == 1;
    id = json['id'];
    ipiiscustos = json['ipiiscustos'] == 1;
    isentrada = json['isentrada'] == 1;
    mudafinanc = json['mudafinanc'] == 1;
    mudapmedio = json['mudapmedio'] == 1;
    nome = json['nome'];
    somacompras = json['somacompras'] == 1;
    somavendas = json['somavendas'] == 1;
    naoatualpreco = json['naoatualpreco'] == 1;
    mudaestoq = json['mudaestoq'] == 1;
    somaconsig = json['somaconsig'] == 1;
    somademanda = json['somademanda'] == 1;
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;

    data['codigo'] = this.codigo;
    data['nome'] = this.nome;
    data['codfinanc'] = this.codfinanc;

    data['isentrada'] = this.isentrada ?? false ? 1 : 0;

    data['icmsiscustos'] = this.icmsiscustos ?? false ? 1 : 0;
    data['ipiiscustos'] = this.ipiiscustos ?? false ? 1 : 0;
    data['naoatualpreco'] = this.naoatualpreco ?? false ? 1 : 0;

    data['mudafinanc'] = this.mudafinanc ?? true ? 1 : 0;
    data['mudapmedio'] = this.mudapmedio ?? true ? 1 : 0;
    data['somacompras'] = this.somacompras ?? false ? 1 : 0;
    data['somavendas'] = this.somavendas ?? false ? 1 : 0;

    data['mudaestoq'] = this.mudaestoq ?? true ? 1 : 0;
    data['somaconsig'] = this.somaconsig ?? false ? 1 : 0;
    data['somademanda'] = this.somademanda ?? false ? 1 : 0;
    return data;
  }
}

class EstoperItemModel extends ODataModelClass<EstoperItem> {
  EstoperItemModel() {
    collectionName = 'estoper';
    super.API = ODataInst();
    super.CC = CloudV3().client..client.silent = true;

    columns = EstoperItem().toJson().keysJoin(separator: ',');
  }
  EstoperItem newItem() => EstoperItem();

  Future<Map<String, dynamic>> buscarByCodigo(String codigo) async {
    return listCached(filter: "codigo eq '$codigo'", select: columns)
        .then((rsp) => rsp[0]);
  }
}

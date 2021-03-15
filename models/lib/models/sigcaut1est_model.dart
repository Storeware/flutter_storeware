import 'package:controls_data/data_model.dart';
import 'package:controls_data/odata_client.dart';
import 'package:controls_data/odata_firestore.dart';

class Sigcaut1estItem extends DataItem {
  //int id;
  int? codigo;
  String? nome;
  String? estconcluido;
  int? pdvpodefechar;
  double? qtdeestadopara;
  String? cor;

  Sigcaut1estItem(
      {this.codigo, this.nome, this.estconcluido, this.pdvpodefechar});

  Sigcaut1estItem.fromJson(Map<String, dynamic> json) {
    fromMap(json);
  }
  @override
  fromMap(Map<String, dynamic> json) {
    id = (json['id'] ?? '0').toString();
    codigo = toInt(json['codigo']);
    nome = json['nome'];
    estconcluido = json['estconcluido'].toString();
    pdvpodefechar = toInt(json['pdvpodefechar']);
    qtdeestadopara = toDouble(json['qtdeestadopara'] ?? 0.0);
    cor = json['cor'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = '$id';
    data['codigo'] = this.codigo;
    data['nome'] = this.nome;
    data['estconcluido'] = this.estconcluido ?? 'N';
    data['pdvpodefechar'] = this.pdvpodefechar ?? 'N';
    if (this.qtdeestadopara != null)
      data['qtdeestadopara'] = this.qtdeestadopara;
    if (this.cor != null) data['cor'] = this.cor;
    return data;
  }
}

class Sigcaut1estItemModel extends ODataModelClass<Sigcaut1estItem> {
  static final _singleton = Sigcaut1estItemModel._create();
  Sigcaut1estItemModel._create() {
    collectionName = 'sigcaut1estados';
    API = ODataInst();
    super.CC = CloudV3().client..client.silent = true;

    list();
  }
  factory Sigcaut1estItemModel() => _singleton;

  Sigcaut1estItem newItem() => Sigcaut1estItem();
  List<dynamic> items = [];
  clear() {
    items.clear();
  }

  static Sigcaut1estItem? find(estado) {
    var idx = indexOf(estado);
    if (idx > -1) return Sigcaut1estItem.fromJson(_singleton.items[idx]);
    return null;
  }

  static int indexOf(estado) {
    for (int i = 0; i < _singleton.items.length; i++) {
      if (_singleton.items[i]['codigo'] == estado) return i;
    }
    return -1;
  }

  @override
  list({filter = ''}) async {
    //if (filter == '') if (items.length > 0) return items;
    return super.listCached(filter: filter).then((rsp) {
      if (filter == '') {
        items.clear();
        items.addAll(rsp);
        items.sort((a, b) {
          return a['codigo'].compareTo(b['codigo']);
        });
        return items;
      }
      return rsp;
    });
  }
}

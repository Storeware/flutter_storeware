import 'package:controls_data/data_model.dart';
import 'package:controls_data/odata_client.dart';
import 'package:controls_data/odata_firestore.dart';

class FormpgtoItem extends DataItem {
  String? codigo;
  DateTime? dtaprov;
  DateTime? dtfim;
  DateTime? dtinicio;
  double? filial;
  int? halterar;
  //int id;
  int? nivel;
  int? nmaxparc;
  String? nome;
  int? npzoinic;
  int? npzointe;
  String? operacao;
  int? percentr;
  int? tarifa;
  int? taxajuros;
  int? idCond;
  String? aplicaPdv;
  bool? inativo = false;

  FormpgtoItem(
      {this.codigo,
      this.dtaprov,
      this.dtfim,
      this.dtinicio,
      this.filial,
      this.halterar,
      // this.id,
      this.nivel,
      this.nmaxparc,
      this.nome,
      this.npzoinic,
      this.npzointe,
      this.operacao,
      this.percentr,
      this.tarifa,
      this.taxajuros,
      this.idCond,
      this.inativo,
      this.aplicaPdv});

  FormpgtoItem.fromJson(Map<String, dynamic> json) {
    fromMap(json);
  }
  @override
  fromMap(Map<String, dynamic> json) {
    codigo = json['codigo'];
    dtaprov = toDateTime(json['dtaprov'] ?? DateTime.now());
    dtfim =
        toDateTime(json['dtfim'] ?? DateTime.now().add(Duration(days: 36000)));
    dtinicio = toDateTime(json['dtinicio'] ?? DateTime.now());
    filial = toDouble(json['filial']);
    halterar = json['halterar'];
    id = json['id'];
    nivel = json['nivel'];
    nmaxparc = json['nmaxparc'];
    nome = json['nome'];
    npzoinic = json['npzoinic'];
    npzointe = json['npzointe'];
    operacao = json['operacao'];
    percentr = json['percentr'];
    tarifa = json['tarifa'];
    taxajuros = json['taxajuros'];
    idCond = toInt(json['id_cond']);
    aplicaPdv = json['aplica_pdv'];
    inativo = json['inativo'] == 'S';

    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['codigo'] = this.codigo;
    data['dtaprov'] = fromDateTime(this.dtaprov!);
    data['dtfim'] = fromDateTime(this.dtfim!);
    data['dtinicio'] = fromDateTime(this.dtinicio!);
    data['filial'] = this.filial;
    data['halterar'] = this.halterar;
    data['id'] = this.id;
    data['nivel'] = this.nivel;
    data['nmaxparc'] = this.nmaxparc;
    data['nome'] = this.nome;
    data['npzoinic'] = this.npzoinic;
    data['npzointe'] = this.npzointe;
    data['operacao'] = this.operacao;
    data['percentr'] = this.percentr;
    data['tarifa'] = this.tarifa;
    data['taxajuros'] = this.taxajuros;
    data['id_cond'] = this.idCond;
    data['aplica_pdv'] = this.aplicaPdv;
    data['inativo'] = this.inativo! ? 'S' : 'N';
    data['id'] = '$codigo';
    return data;
  }
}

class FormpgtoItemModel extends ODataModelClass<FormpgtoItem> {
  FormpgtoItemModel() {
    collectionName = 'formpgto';
    super.API = ODataInst();
    super.CC = CloudV3().client..client.silent = true;
  }
  FormpgtoItem newItem() => FormpgtoItem();

  listGrid({filter, top = 20, skip = 0, orderBy}) {
    return search(
      resource: collectionName,
      select: 'filial,codigo,nome,operacao,inativo',
      filter: filter,
      top: top,
      skip: skip,
      orderBy: orderBy,
    ).then((rsp) => rsp.asMap());
  }
}

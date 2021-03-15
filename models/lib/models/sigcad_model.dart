import 'package:controls_data/data_model.dart';
import 'package:controls_data/odata_client.dart';
import 'package:controls_data/odata_firestore.dart';
import 'ctrl_id_model.dart';
//import 'package:controls_extensions/extensions.dart' hide DynamicExtension;

class SigcadItem extends DataItem {
  double? codigo;
  String? nome;
  String? cnpj;
  String? cidade;
  String? bairro;
  String? numero;
  String? compl;
  String? ender;
  String? estado;
  String? cep;
  String? celular;
  String? cpfnaNota;
  String? email;
  String? tipo;
  String? terminal;
  double? filial;

  SigcadItem(
      {this.codigo,
      this.nome,
      this.cnpj,
      this.cidade,
      this.bairro,
      this.numero,
      this.compl,
      this.ender,
      this.estado,
      this.cep,
      this.celular,
      this.cpfnaNota,
      this.email});

  SigcadItem.fromJson(Map<String, dynamic> json) {
    fromMap(json);
  }
  @override
  fromMap(Map<String, dynamic> json) {
    codigo = toDouble(json['codigo']);
    nome = json['nome'];
    cnpj = json['cnpj'];
    cidade = json['cidade'];
    bairro = json['bairro'];
    numero = json['numero'];
    compl = json['compl'];
    ender = json['ender'];
    estado = json['estado'];
    cep = json['cep'];
    celular = json['celular'];
    cpfnaNota = json['cpfna_nota'];
    email = json['email'];
    tipo = json['tipo'];
    terminal = json['terminal'];
    filial = toDouble(json['filial']);
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['codigo'] = this.codigo;
    data['nome'] = this.nome;
    data['cnpj'] = this.cnpj;
    data['cidade'] = this.cidade;
    data['bairro'] = this.bairro;
    data['numero'] = this.numero;
    data['compl'] = this.compl;
    data['ender'] = this.ender;
    data['estado'] = this.estado;
    data['cep'] = this.cep;
    data['celular'] = this.celular;
    if (cpfnaNota != null) data['cpfna_nota'] = this.cpfnaNota;
    data['email'] = this.email;
    data['id'] = '$codigo';
    data['tipo'] = this.tipo ?? 'CONSUMIDOR';
    data['filial'] = this.filial ?? 0;
    data['terminal'] = this.terminal ?? 'WEB';
    return data;
  }

  static get keys => SigcadItem.fromJson({}).toJson().keys;
}

class SigcadItemModel extends ODataModelClass<SigcadItem> {
  SigcadItemModel() {
    collectionName = 'sigcad';
    super.API = ODataInst();
    super.CC = CloudV3().client..client.silent = true;

    columns = SigcadItem.keys.join(',');
  }
  SigcadItem newItem() => SigcadItem();

  /// [listRows] permite paginação dos registros.
  Future<ODataResult> listRows(
      {filter, select, orderBy = 'nome', top = 20, skip = 0}) {
    var cols = select ??
        'codigo,filial,tipo,terminal,nome,celular,cidade,bairro,ender,numero,cep,compl,estado,cnpj,email';

    return search(
        resource: 'sigcad',
        select: cols,
        filter: filter,
        top: top,
        orderBy: orderBy,
        skip: skip,
        cacheControl: 'no-cache');
  }

  Future<Map<String, dynamic>> buscarByCodigo(double codigo) async {
    return listCached(
            filter: "codigo eq '$codigo'",
            select: 'codigo, nome,cnpj,cep,cidade')
        .then((rsp) => (rsp.length == 0) ? {} : rsp[0]);
  }

  Future<num> indicadorAquisicaoClientes(
      {dias = 7, String? tipo, String? filtro}) async {
    final d = DateTime.now().add(Duration(days: -dias));
    final sDe = toDateSql(d);
    var s = '';
    if (tipo != null) s = " and tipo like '%tipo%' ";
    if (filtro != null) s += ' and $filtro';

    final qry = "select count(*) conta from sigcad where data ge '$sDe' $s ";
    //print(qry);
    return API!.openJson(qry).then(
        (rsp) => ((rsp['rows'] ?? 0) == 0) ? 0 : rsp['result'][0]['conta']);
  }

  Future<double> proximoCodigo(double filial) async {
    return CtrlIdItemModel.proximo('CLIFOR').then((rsp) {
      return (rsp.numero! * 1000) + filial;
    });
  }
}

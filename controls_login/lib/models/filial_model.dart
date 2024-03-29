// @dart=2.12

import 'package:controls_data/cached.dart';
import 'package:controls_data/data_model.dart';
import 'package:controls_data/odata_client.dart';
import 'package:controls_data/odata_firestore.dart';

class FilialItem extends DataItem {
  String? cgc;
  double? codigo;
  String? ender;
  //int id;
  String? ie;
  String? _nome;
  String? inativa;
  String? cep;
  String? fone;
  String? cidade;
  String? estado;
  String? web;
  String? razao;
  String? fatender;
  String? fatcidade;
  String? fatestado;
  String? fatcnpj;
  String? fatie;
  String? fatfone;
  String? fatcep;
  String? geraencautom;
  String? loja;
  String? sigla;
  double? sigcad;
  String? fax;
  String? bairro;
  String? contato;
  String? numero;
  String? complemento;
  String? bancoTesouraria;
  String? simplesnacional;
  String? im;
  String? indicadorTipoAtividade;
  String? email;
  String? indicadorPropriedade;
  int? cnae;
  double? fgrupo;
  String? alteraprecovenda;
  String? permitecreditoicmssn;
  String? horariodeabertura;
  String? horariodefechamento;
  int? ffiscal;
  double? idcontabilista;
  int? fpisCofins;

  String get cnpj => this.cgc ?? '';
  String get fullEnder =>
      '${this.ender ?? ''}${(this.numero ?? '').isNotEmpty ? ', ' : ''}${this.numero ?? ''}';

  FilialItem(
      {this.cgc,
      this.codigo,
      this.ender,
      //  this.id,
      this.ie,
      String? nome,
      this.inativa,
      this.cep,
      this.fone,
      this.cidade,
      this.estado,
      this.web,
      this.razao,
      this.fatender,
      this.fatcidade,
      this.fatestado,
      this.fatcnpj,
      this.fatie,
      this.fatfone,
      this.fatcep,
      this.geraencautom,
      this.loja,
      this.sigla,
      this.sigcad,
      this.fax,
      this.bairro,
      this.contato,
      this.numero,
      this.complemento,
      this.bancoTesouraria,
      this.simplesnacional,
      this.im,
      this.indicadorTipoAtividade,
      this.email,
      this.indicadorPropriedade,
      this.cnae,
      this.fgrupo,
      this.alteraprecovenda,
      this.permitecreditoicmssn,
      this.horariodeabertura,
      this.horariodefechamento,
      this.ffiscal,
      this.idcontabilista,
      this.fpisCofins})
      : this._nome = nome;

  FilialItem.fromJson(Map<String, dynamic> json) {
    fromMap(json);
  }
  toStr(x) {
    if (x == null) return '';
    return x.toString();
  }

  @override
  fromMap(Map<String, dynamic>? json) {
    if (json == null) return this;
    try {
      cgc = json['cgc'];
      codigo = toDouble(json['codigo']);
      ender = json['ender'];
      id = toStr(json['id']);
      ie = json['ie'];
      _nome = json['nome'];
      inativa = json['inativa'];
      cep = json['cep'];
      fone = json['fone'];
      cidade = json['cidade'];
      estado = json['estado'];
      web = json['web'];
      razao = json['razao'];
      fatender = json['fatender'];
      fatcidade = json['fatcidade'];
      fatestado = json['fatestado'];
      fatcnpj = json['fatcnpj'];
      fatie = json['fatie'];
      fatfone = json['fatfone'];
      fatcep = json['fatcep'];
      geraencautom = json['geraencautom'];
      loja = json['loja'];
      sigla = json['sigla'];
      sigcad = toDouble(json['sigcad']);
      fax = json['fax'];
      bairro = json['bairro'];
      contato = json['contato'];
      numero = json['numero'];
      complemento = json['complemento'];
      bancoTesouraria = json['banco_tesouraria'];
      simplesnacional = json['simplesnacional'];
      im = json['im'];
      indicadorTipoAtividade = json['indicador_tipo_atividade'];
      email = json['email'];
      indicadorPropriedade = json['indicador_propriedade'] ?? 'T';
      cnae = toInt(json['cnae']);
      fgrupo = toDouble(json['fgrupo']);
      alteraprecovenda = json['alteraprecovenda'];
      permitecreditoicmssn = json['permitecreditoicmssn'];
      horariodeabertura = json['horariodeabertura'];
      horariodefechamento = json['horariodefechamento'];
      ffiscal = toInt(json['ffiscal']);
      idcontabilista = toDouble(json['idcontabilista']);
      fpisCofins = toInt(json['fpis_cofins']);
    } catch (e) {
      //
    }
    return this;
  }

  String? get nome => this._nome;
  set nome(String? value) {
    this._nome = value;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cgc'] = this.cgc;
    data['codigo'] = this.codigo;
    data['ender'] = this.ender;
    data['id'] = this.id;
    data['ie'] = this.ie;
    data['nome'] = this._nome;
    data['inativa'] = this.inativa;
    data['cep'] = this.cep;
    data['fone'] = this.fone;
    data['cidade'] = this.cidade;
    data['estado'] = this.estado;
    data['web'] = this.web;
    data['razao'] = this.razao;
    data['fatender'] = this.fatender;
    data['fatcidade'] = this.fatcidade;
    data['fatestado'] = this.fatestado;
    data['fatcnpj'] = this.fatcnpj;
    data['fatie'] = this.fatie;
    data['fatfone'] = this.fatfone;
    data['fatcep'] = this.fatcep;
    data['geraencautom'] = this.geraencautom;
    data['loja'] = this.loja;
    data['sigla'] = this.sigla;
    data['sigcad'] = this.sigcad;
    data['fax'] = this.fax;
    data['bairro'] = this.bairro;
    data['contato'] = this.contato;
    data['numero'] = this.numero;
    data['complemento'] = this.complemento;
    data['banco_tesouraria'] = this.bancoTesouraria;
    data['simplesnacional'] = this.simplesnacional;
    data['im'] = this.im;
    data['indicador_tipo_atividade'] = this.indicadorTipoAtividade;
    data['email'] = this.email;
    data['indicador_propriedade'] = this.indicadorPropriedade;
    data['cnae'] = this.cnae;
    data['fgrupo'] = this.fgrupo;
    data['alteraprecovenda'] = this.alteraprecovenda;
    data['permitecreditoicmssn'] = this.permitecreditoicmssn;
    data['horariodeabertura'] = this.horariodeabertura;
    data['horariodefechamento'] = this.horariodefechamento;
    data['ffiscal'] = this.ffiscal;
    data['idcontabilista'] = this.idcontabilista;
    data['fpis_cofins'] = this.fpisCofins;
    data['id'] = '$codigo';
    return data;
  }
}

class FilialItemModel extends ODataModelClass<FilialItem> {
  static final _singleton = FilialItemModel._create();
  FilialItemModel._create() {
    collectionName = 'filial';
    super.API = ODataInst();
    super.CC = CloudV3().client..client.silent = true;
  }
  factory FilialItemModel() => _singleton;

  FilialItem newItem() => FilialItem();
  @override
  Future<List<dynamic>> list({filter}) {
    return Cached.value('_filial_list_${filter ?? ''}', builder: (x) {
      return super.listNoCached(filter: filter).then((rsp) {
        return rsp;
      });
    });
  }

  Future<bool> exists(double codigo) async {
    return Cached.value('exists_filial_$codigo', builder: (v) {
      return super.getOne(filter: 'codigo=$codigo').then((dynamic rsp) {
        return rsp['codigo'] ?? 0 == codigo;
      });
    });
  }

  Future<Map<String, dynamic>> buscarByCodigo(codigo, {String? select}) async {
    return listCached(
            resource: 'filial',
            filter: "codigo eq $codigo ",
            select: select ?? 'codigo, nome')
        .then((rsp) {
      return (rsp.isEmpty) ? {} : rsp[0];
    });
  }
}

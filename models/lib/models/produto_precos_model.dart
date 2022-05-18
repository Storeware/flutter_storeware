import 'package:controls_data/data_model.dart';

class ProdutoPrecosItem extends DataItem {
  String? nome;
  String? nomereduz;
  String? unidade;
  String? marca;
  String? grupo;
  String? setor;
  int? filialprod;
  int? listarprec;
  String? pesavel;
  int? validade;
  int? vdasuspens;
  String? integbalan;
  String? setorbalanca;
  String? teclabalanca;
  String? obsetiqueta;
  String? familia;
  int? filial;
  String? codigo;
  double? precovenda;
  double? precovda2;
  double? precovda3;
  double? precoweb;
  String? nfCodicms;
  String? nfCodicms2;
  double? precoAq;
  double? prompreco;
  int? markup;
  String? dtatualiz;
  String? dataCt;
  String? inativo;
  int? idCesta;
  String? nfCodipi;
  String? idgrade;
  double? qtvarejo;

  ProdutoPrecosItem(
      {this.nome,
      this.nomereduz,
      this.unidade,
      this.marca,
      this.grupo,
      this.setor,
      this.filialprod,
      this.listarprec,
      this.pesavel,
      this.validade,
      this.vdasuspens,
      this.integbalan,
      this.setorbalanca,
      this.teclabalanca,
      this.obsetiqueta,
      this.familia,
      this.filial,
      this.codigo,
      this.precovenda,
      this.precovda2,
      this.precovda3,
      this.precoweb,
      this.nfCodicms,
      this.nfCodicms2,
      this.precoAq,
      this.prompreco,
      this.markup,
      this.dtatualiz,
      this.dataCt,
      this.inativo,
      this.idCesta,
      this.nfCodipi,
      this.idgrade});

  ProdutoPrecosItem.fromJson(json) {
    fromMap(json);
  }
  @override
  fromMap(Map<String, dynamic> json) {
    nome = json['nome'];
    nomereduz = json['nomereduz'];
    unidade = json['unidade'];
    marca = json['marca'];
    grupo = json['grupo'];
    setor = json['setor'];
    filialprod = json['filialprod'];
    listarprec = json['listarprec'];
    pesavel = json['pesavel'];
    validade = json['validade'];
    vdasuspens = json['vdasuspens'];
    integbalan = json['integbalan'];
    setorbalanca = json['setorbalanca'];
    teclabalanca = json['teclabalanca'];
    obsetiqueta = json['obsetiqueta'];
    familia = json['familia'];
    filial = json['filial'];
    codigo = json['codigo'];
    precovenda = json['precovenda'];
    precovda2 = json['precovda2'];
    precovda3 = json['precovda3'];
    precoweb = json['precoweb'];
    nfCodicms = json['nf_codicms'];
    nfCodicms2 = json['nf_codicms2'];
    precoAq = json['preco_aq'];
    prompreco = json['prompreco'];
    markup = json['markup'];
    dtatualiz = json['dtatualiz'];
    dataCt = json['data_ct'];
    inativo = json['inativo'];
    idCesta = json['id_cesta'];
    nfCodipi = json['nf_codipi'];
    idgrade = json['idgrade'];
    qtvarejo = json['qtvarejo'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nome'] = this.nome;
    data['nomereduz'] = this.nomereduz;
    data['unidade'] = this.unidade;
    data['marca'] = this.marca;
    data['grupo'] = this.grupo;
    data['setor'] = this.setor;
    data['filialprod'] = this.filialprod;
    data['listarprec'] = this.listarprec;
    data['pesavel'] = this.pesavel;
    data['validade'] = this.validade;
    data['vdasuspens'] = this.vdasuspens;
    data['integbalan'] = this.integbalan;
    data['setorbalanca'] = this.setorbalanca;
    data['teclabalanca'] = this.teclabalanca;
    data['obsetiqueta'] = this.obsetiqueta;
    data['familia'] = this.familia;
    data['filial'] = this.filial;
    data['codigo'] = this.codigo;
    data['precovenda'] = this.precovenda;
    data['precovda2'] = this.precovda2;
    data['precovda3'] = this.precovda3;
    data['precoweb'] = this.precoweb;
    data['nf_codicms'] = this.nfCodicms;
    data['nf_codicms2'] = this.nfCodicms2;
    data['preco_aq'] = this.precoAq;
    data['prompreco'] = this.prompreco;
    data['markup'] = this.markup;
    data['dtatualiz'] = this.dtatualiz;
    data['data_ct'] = this.dataCt;
    data['inativo'] = this.inativo;
    data['id_cesta'] = this.idCesta;
    data['nf_codipi'] = this.nfCodipi;
    data['idgrade'] = this.idgrade;
    data['qtvarejo'] = this.qtvarejo;
    return data;
  }

  double? preco({qtde = 0}) {
    double r = (precoweb! > 0) ? precoweb! : precovenda!;
    if ((qtde > 0) && (qtvarejo! > 0) && (precovda2! > 0) && (qtde >= qtvarejo))
      r = precovda2!;
    return r;
  }
}

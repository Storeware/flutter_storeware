import 'package:controls_data/data_model.dart';

class WbaSigcadItem extends DataItem {
  String? bairro;
  String? bairrocobr;
  String? bairroentr;
  String? bip;
  int? bloqueio;
  String? bloqueioinfo;
  String? categoria;
  String? ccm;
  String? ccmentr;
  int? ccusto;
  String? celular;
  String? cep;
  String? cepcobr;
  String? cidacobr;
  String? cidade;
  String? cidadeentr;
  String? cmmcobr;
  String? cnpj;
  String? cnpjcobr;
  String? cnpjentr;
  int? codigo;
  String? compl;
  String? contabil;
  String? contato;
  String? data;
  String? email;
  String? endcobr;
  String? endentr;
  String? ender;
  String? estacobr;
  String? estado;
  String? estadoentr;
  int? fatorcompra;
  int? favorecido;
  String? fax;
  int? filial;
  String? fone;
  String? formapgto;
  String? hiscontabil;
  String? homepage;
  String? ie;
  String? iecobr;
  String? ieentr;
  int? limite;
  String? logradouro;
  String? microempresa;
  String? nome;
  String? numero;
  String? ramo;
  String? rapido;
  String? razao;
  String? refer;
  String? registro;
  String? tipo;
  int? tipocont;
  String? tipocontato;
  int? transportador;
  String? vendedor;
  int? oldcodigo;
  int? tabela;
  String? figura;
  int? inativo;
  String? fantasia;
  String? pjuridica;
  String? arquivo;
  String? senha;
  String? chave;
  int? validade;
  int? nivel;
  int? agente;
  String? profissao;
  String? estadocivil;
  String? nacionalidade;
  String? orgaopublico;
  String? emailcobr;
  String? perimetroEntrega;
  String? rg;
  String? cepentr;
  int? suframa;
  String? numerocobr;
  String? numeroentr;
  String? complementoentr;
  String? simplesnacional;
  String? codPais;
  String? latitude;
  String? longitude;
  String? industria;

  WbaSigcadItem(
      {this.bairro,
      this.bairrocobr,
      this.bairroentr,
      this.bip,
      this.bloqueio,
      this.bloqueioinfo,
      this.categoria,
      this.ccm,
      this.ccmentr,
      this.ccusto,
      this.celular,
      this.cep,
      this.cepcobr,
      this.cidacobr,
      this.cidade,
      this.cidadeentr,
      this.cmmcobr,
      this.cnpj,
      this.cnpjcobr,
      this.cnpjentr,
      this.codigo,
      this.compl,
      this.contabil,
      this.contato,
      this.data,
      this.email,
      this.endcobr,
      this.endentr,
      this.ender,
      this.estacobr,
      this.estado,
      this.estadoentr,
      this.fatorcompra,
      this.favorecido,
      this.fax,
      this.filial,
      this.fone,
      this.formapgto,
      this.hiscontabil,
      this.homepage,
      this.ie,
      this.iecobr,
      this.ieentr,
      this.limite,
      this.logradouro,
      this.microempresa,
      this.nome,
      this.numero,
      this.ramo,
      this.rapido,
      this.razao,
      this.refer,
      this.registro,
      this.tipo,
      this.tipocont,
      this.tipocontato,
      this.transportador,
      this.vendedor,
      this.oldcodigo,
      this.tabela,
      this.figura,
      this.inativo,
      this.fantasia,
      this.pjuridica,
      this.arquivo,
      this.senha,
      this.chave,
      this.validade,
      this.nivel,
      this.agente,
      this.profissao,
      this.estadocivil,
      this.nacionalidade,
      this.orgaopublico,
      this.emailcobr,
      this.perimetroEntrega,
      this.rg,
      this.cepentr,
      this.suframa,
      this.numerocobr,
      this.numeroentr,
      this.complementoentr,
      this.simplesnacional,
      this.codPais,
      this.latitude,
      this.longitude,
      this.industria});

  WbaSigcadItem.fromJson(Map<String, dynamic> json) {
    fromMap(json);
  }
  @override
  fromMap(Map<String, dynamic> json) {
    bairro = json['bairro'];
    bairrocobr = json['bairrocobr'];
    bairroentr = json['bairroentr'];
    bip = json['bip'];
    bloqueio = json['bloqueio'];
    bloqueioinfo = json['bloqueioinfo'];
    categoria = json['categoria'];
    ccm = json['ccm'];
    ccmentr = json['ccmentr'];
    ccusto = json['ccusto'];
    celular = json['celular'];
    cep = json['cep'];
    cepcobr = json['cepcobr'];
    cidacobr = json['cidacobr'];
    cidade = json['cidade'];
    cidadeentr = json['cidadeentr'];
    cmmcobr = json['cmmcobr'];
    cnpj = json['cnpj'];
    cnpjcobr = json['cnpjcobr'];
    cnpjentr = json['cnpjentr'];
    codigo = json['codigo'];
    compl = json['compl'];
    contabil = json['contabil'];
    contato = json['contato'];
    data = json['data'];
    email = json['email'];
    endcobr = json['endcobr'];
    endentr = json['endentr'];
    ender = json['ender'];
    estacobr = json['estacobr'];
    estado = json['estado'];
    estadoentr = json['estadoentr'];
    fatorcompra = json['fatorcompra'];
    favorecido = json['favorecido'];
    fax = json['fax'];
    filial = json['filial'];
    fone = json['fone'];
    formapgto = json['formapgto'];
    hiscontabil = json['hiscontabil'];
    homepage = json['homepage'];
    id = json['id'];
    ie = json['ie'];
    iecobr = json['iecobr'];
    ieentr = json['ieentr'];
    limite = json['limite'];
    logradouro = json['logradouro'];
    microempresa = json['microempresa'];
    nome = json['nome'];
    numero = json['numero'];
    ramo = json['ramo'];
    rapido = json['rapido'];
    razao = json['razao'];
    refer = json['refer'];
    registro = json['registro'];
    tipo = json['tipo'];
    tipocont = json['tipocont'];
    tipocontato = json['tipocontato'];
    transportador = json['transportador'];
    vendedor = json['vendedor'];
    oldcodigo = json['oldcodigo'];
    tabela = json['tabela'];
    figura = json['figura'];
    inativo = json['inativo'];
    fantasia = json['fantasia'];
    pjuridica = json['pjuridica'];
    arquivo = json['arquivo'];
    senha = json['senha'];
    chave = json['chave'];
    validade = json['validade'];
    nivel = json['nivel'];
    agente = json['agente'];
    profissao = json['profissao'];
    estadocivil = json['estadocivil'];
    nacionalidade = json['nacionalidade'];
    orgaopublico = json['orgaopublico'];
    emailcobr = json['emailcobr'];
    perimetroEntrega = json['perimetro_entrega'];
    rg = json['rg'];
    cepentr = json['cepentr'];
    suframa = json['suframa'];
    numerocobr = json['numerocobr'];
    numeroentr = json['numeroentr'];
    complementoentr = json['complementoentr'];
    simplesnacional = json['simplesnacional'];
    codPais = json['cod_pais'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    industria = json['industria'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bairro'] = this.bairro;
    data['bairrocobr'] = this.bairrocobr;
    data['bairroentr'] = this.bairroentr;
    data['bip'] = this.bip;
    data['bloqueio'] = this.bloqueio;
    data['bloqueioinfo'] = this.bloqueioinfo;
    data['categoria'] = this.categoria;
    data['ccm'] = this.ccm;
    data['ccmentr'] = this.ccmentr;
    data['ccusto'] = this.ccusto;
    data['celular'] = this.celular;
    data['cep'] = this.cep;
    data['cepcobr'] = this.cepcobr;
    data['cidacobr'] = this.cidacobr;
    data['cidade'] = this.cidade;
    data['cidadeentr'] = this.cidadeentr;
    data['cmmcobr'] = this.cmmcobr;
    data['cnpj'] = this.cnpj;
    data['cnpjcobr'] = this.cnpjcobr;
    data['cnpjentr'] = this.cnpjentr;
    data['codigo'] = this.codigo;
    data['compl'] = this.compl;
    data['contabil'] = this.contabil;
    data['contato'] = this.contato;
    data['data'] = this.data;
    data['email'] = this.email;
    data['endcobr'] = this.endcobr;
    data['endentr'] = this.endentr;
    data['ender'] = this.ender;
    data['estacobr'] = this.estacobr;
    data['estado'] = this.estado;
    data['estadoentr'] = this.estadoentr;
    data['fatorcompra'] = this.fatorcompra;
    data['favorecido'] = this.favorecido;
    data['fax'] = this.fax;
    data['filial'] = this.filial;
    data['fone'] = this.fone;
    data['formapgto'] = this.formapgto;
    data['hiscontabil'] = this.hiscontabil;
    data['homepage'] = this.homepage;
    data['id'] = this.id;
    data['ie'] = this.ie;
    data['iecobr'] = this.iecobr;
    data['ieentr'] = this.ieentr;
    data['limite'] = this.limite;
    data['logradouro'] = this.logradouro;
    data['microempresa'] = this.microempresa;
    data['nome'] = this.nome;
    data['numero'] = this.numero;
    data['ramo'] = this.ramo;
    data['rapido'] = this.rapido;
    data['razao'] = this.razao;
    data['refer'] = this.refer;
    data['registro'] = this.registro;
    data['tipo'] = this.tipo;
    data['tipocont'] = this.tipocont;
    data['tipocontato'] = this.tipocontato;
    data['transportador'] = this.transportador;
    data['vendedor'] = this.vendedor;
    data['oldcodigo'] = this.oldcodigo;
    data['tabela'] = this.tabela;
    data['figura'] = this.figura;
    data['inativo'] = this.inativo;
    data['fantasia'] = this.fantasia;
    data['pjuridica'] = this.pjuridica;
    data['arquivo'] = this.arquivo;
    data['senha'] = this.senha;
    data['chave'] = this.chave;
    data['validade'] = this.validade;
    data['nivel'] = this.nivel;
    data['agente'] = this.agente;
    data['profissao'] = this.profissao;
    data['estadocivil'] = this.estadocivil;
    data['nacionalidade'] = this.nacionalidade;
    data['orgaopublico'] = this.orgaopublico;
    data['emailcobr'] = this.emailcobr;
    data['perimetro_entrega'] = this.perimetroEntrega;
    data['rg'] = this.rg;
    data['cepentr'] = this.cepentr;
    data['suframa'] = this.suframa;
    data['numerocobr'] = this.numerocobr;
    data['numeroentr'] = this.numeroentr;
    data['complementoentr'] = this.complementoentr;
    data['simplesnacional'] = this.simplesnacional;
    data['cod_pais'] = this.codPais;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['industria'] = this.industria;
    return data;
  }
}

class WbaSigcadItemModel extends DataModelClass<WbaSigcadItem> {
  WbaSigcadItemModel() {
    collectionName = 'wba_sigcad';
  }
  WbaSigcadItem newItem() => WbaSigcadItem();

  @override
  enviar(WbaSigcadItem item) {
    // TODO: implement enviar
    throw UnimplementedError();
  }

  @override
  getById(id) {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  snapshots({bool? inativo}) {
    // TODO: implement snapshots
    throw UnimplementedError();
  }
}

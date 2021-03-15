import 'package:controls_data/data_model.dart';
import 'package:controls_data/odata_client.dart';

class CadastroItem extends DataItem {
  double? codigo;
  String? nome;
  String? cnpj;
  String? cep;
  String? ender;
  String? estado;
  String? celular;
  String? cidade;
  String? bairro;
  String? fone;
  String? email;
  bool? cpfNaNota;
  String? numero;
  String? compl;
  double? filial;
  String? terminal;
  String? tipo;
  String? get cpf => cnpj;
  set cpf(String? value) {
    cnpj = value;
  }

  from(CadastroItem pessoa) {
    return fromMap(pessoa.toJson());
  }

  CadastroItem(
      {this.codigo,
      this.nome,
      this.cnpj,
      this.cep,
      this.cidade,
      this.ender,
      this.estado,
      this.celular,
      this.fone,
      this.email,
      this.cpfNaNota});

  CadastroItem.fromJson(Map<String, dynamic> json) {
    fromMap(json);
  }
  maskPhone(String? v) {
    if (v == null) return '';
    if (v.startsWith('55')) v = '+' + v;
    return v;
  }

  @override
  fromMap(Map<String, dynamic> json) {
    codigo = double.tryParse((json['codigo'] ?? 0.0).toString());
    nome = json['nome'] ?? '';
    cnpj = json['cnpj'];
    cep = json['cep'];
    ender = json['ender'];
    estado = json['estado'];
    celular = maskPhone(json['celular']);
    fone = json['fone'];
    email = json['email'];
    cidade = json['cidade'];
    bairro = json['bairro'];
    cpfNaNota = ((json['cpfna_nota'] ?? 'N') == 'S') ? true : false;
    numero = json['numero'];
    compl = json['compl'];
    tipo = json['tipo'];
    terminal = json['terminal'];
    filial = toDouble(json['filial']);
    return this;
  }

  me(Function(CadastroItem) proc) {
    proc(this);
  }

  static String clearPhone(v) {
    return (v == null)
        ? ''
        : v
            .replaceAll('(', '')
            .replaceAll(')', '')
            .replaceAll('-', '')
            .replaceAll('+', '');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['codigo'] = this.codigo ?? 0;
    data['nome'] = this.nome ?? '';
    data['cnpj'] = this.cnpj ?? '';
    data['cep'] = this.cep ?? '';
    data['ender'] = this.ender ?? '';
    data['estado'] = this.estado ?? '';
    data['celular'] = this.celular ?? '';
    data['fone'] = this.fone ?? '';
    data['email'] = this.email ?? '';
    data['cpfna_nota'] = (this.cpfNaNota ?? true) ? 'S' : 'N';
    data['cidade'] = this.cidade;
    data['bairro'] = this.bairro;
    data['compl'] = this.compl;
    data['numero'] = this.numero;
    data['terminal'] = this.terminal ?? 'WEB';
    data['tipo'] = this.tipo ?? 'CLIENTE';
    data['filial'] = this.filial ?? 0;
    return data;
  }

  static String get columns =>
      'codigo,nome,cnpj,cidade,bairro,numero,compl,ender,estado,cidade,cep,celular,cpfna_nota,email, terminal,tipo,filial';
}

class CadastroItemModel extends ODataModelClass<CadastroItem> {
  double filial = 0;
  CadastroItemModel() {
    collectionName = 'sigcad';
    API = ODataInst();
  }
  CadastroItem newItem() => CadastroItem();

  String columns = CadastroItem.columns;

  Future<ODataResult> byCelular(String celular) async {
    var s = CadastroItem.clearPhone(celular);
    return await search(filter: "celular eq '$s' ");
  }

  Future<ODataResult> byCodigo(double codigo) async {
    return await search(filter: "codigo eq $codigo ");
  }

  Future<ODataResult> byNome(String nome) async {
    return await search(filter: "nome like ('$nome') ", orderBy: 'nome');
  }

  Future<ODataResult> byCPNJ(String cnpj) async {
    return await search(filter: "cnpj  eq '$cnpj' ");
  }

  Future<bool> atualizar(dados, {filial}) async {
    CadastroItem pessoa;
    if (dados is CadastroItem)
      pessoa = dados;
    else
      pessoa = CadastroItem.fromJson(dados);
    if ((pessoa.codigo ?? 0) == 0)
      await proximoCodigo(filial ?? this.filial).then((double? x) {
        pessoa.codigo = x;
        pessoa.filial = filial ?? this.filial;

        /// propaga o codigo para a referencia
        if (dados is CadastroItem) {
          /// nada a fazer

        } else {
          dados['codigo'] = pessoa.codigo;
          dados['filial'] = pessoa.filial;
        }
        return super.post(pessoa).then((rsp) {
          return true;
        });
      });

    return super.put(pessoa).then((rsp) {
      return true;
    });
  }

  @override
  Future<Map<String, dynamic>> post(pessoa) {
    return atualizar(pessoa).then((rsp) => {"rows": 0});
  }

  @override
  Future<Map<String, dynamic>> put(pessoa) {
    return atualizar(pessoa).then((rsp) => {"rows": 0});
  }

  Future<double?> proximoCodigo(filial) async {
    var resp = await API!
        .send(ODataQuery(resource: "obter_id('CLIFOR')", select: "*"));
    ODataResult r = ODataResult(json: resp);
    if (r.rows == 0) return null;
    var n = r.docs[0]['numero'];

    if ((filial ?? 0) > 0) {
      return (n * 1000) + filial;
    }
    return n;
  }
}

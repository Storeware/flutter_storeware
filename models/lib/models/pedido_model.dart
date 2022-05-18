import 'dart:convert';
import 'package:controls_data/odata_client.dart';
import 'package:controls_web/drivers/bloc_model.dart';
import 'cadastros_model.dart';
import 'package:controls_extensions/extensions.dart';
import 'package:controls_data/local_storage.dart';

import 'model_base.dart';
import 'package:uuid/uuid.dart';

class PedidoNotifier extends BlocModel<int> {
  static final _singleton = PedidoNotifier._create();
  PedidoNotifier._create();
  factory PedidoNotifier() => _singleton;
}

class PedidoProdutoItem extends ModelItemBase {
  String? codigo;
  String? unidade;
  String? nome;
  String? obs;
  double? qtde;
  double? preco;
  int? ordem;
  double? get valor {
    return qtde! * preco!;
  }

  PedidoProdutoItem.fromJson(json) {
    fromMap(json);
  }
  fromMap(json) {
    codigo = json['codigo'];
    unidade = json['unidade'];
    nome = json['none'];
    obs = json['obs'];
    qtde = (json['qtde'] ?? 0) + 0.0;
    preco = (json['preco'] ?? 0) + 0.0;
    ordem = json['ordem'] ?? 0;
  }

  @override
  toJson() {
    return {
      "codigo": codigo ?? '',
      "unidade": unidade ?? '',
      "nome": nome ?? '',
      "obs": obs ?? '',
      "qtde": qtde ?? 0.0,
      "preco": preco ?? 0.0,
      "ordem": ordem ?? 0,
      "valor": valor ?? 0.0,
    };
  }
}

class PedidoProdutoItems {
  List<PedidoProdutoItem> items = [];
  clear() {
    items.clear();
    return this;
  }

  toJson() {
    return [for (var item in items) item.toJson()];
  }

  bool _loading = false;
  PedidoProdutoItems.fromJson(List<dynamic> json) {
    _loading = true;
    try {
      items.clear();
      for (var item in json) {
        addJson(item);
      }
    } finally {
      _loading = false;
    }
  }
  addJson(Map json) {
    return add(PedidoProdutoItem.fromJson(json));
  }

  add(PedidoProdutoItem item) {
    item.ordem = count + 1;
    items.add(item);
    if (!_loading) PedidoNotifier().notify(count);
    return count;
  }

  get count => items.length;
  get total {
    double v = 0;
    for (var item in items) v += item.valor!;
    return double.tryParse(v.toStringAsFixed(2));
  }
}

class PedidoDadosVenda extends ModelItemBase {
  String? pedido;
  DateTime? data;
  int? itensCount;
  double? total;
  String? vendedor;
  String? _gid;
  //DateTime dataRetira;

  PedidoDadosVenda({this.pedido, this.vendedor, this.itensCount, this.total});

  PedidoDadosVenda.fromJson(Map<String, dynamic> json) {
    pedido = json['pedido'];
    itensCount = json['itensCount'] ?? 0;
    total = json['total'] ?? 0.0;
    vendedor = json['vendedor'] ?? '';
    //dataRetira = DateTime.tryParse(
    //    json['dataretira'] ?? DateTime.now().toDate().toString());
    data =
        DateTime.tryParse(json['vcto'] ?? DateTime.now().toDate().toString());
    //log(data);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    try {
      data['pedido'] = this.pedido;
      data['itensCount'] = this.itensCount ?? 0;
      data['total'] = this.total ?? 0;
      data['vendedor'] = this.vendedor ?? '';
      data['data'] = this.data!.toIso8601String();
      //data['dataretira'] = this.dataRetira.toIso8601String();
    } catch (e) {
      print('Dados da venda: $e');
    }
    return data;
  }

  get gid {
    if (_gid == null) _gid = Uuid().v4();

    return _gid;
  }

  clear() {
    _gid = null;
  }
}

class PedidoEntregaModo {
  static get internoNaLoja => '0'; /* aka balcao */
  static get delivery => '1'; /* aka entrega */
  static get driveThru => '2'; /* aka viagem */
  static get mesa => '3';
  static get comanda => '4';
}

class PedidoEntrega extends ModelItemBase {
  String? ender;
  String? cep;
  String? bairro;
  String? cidade;
  String? estado;
  String? numero;
  String? foneContato;
  String? email;
  String? referencia;
  String? obs;
  String? compl;
  DateTime? dataEntrega;
  String? entrega; // ver ProdutoEntregaModo

  PedidoEntrega(
      {this.ender,
      this.cep,
      this.cidade,
      this.estado,
      this.numero,
      this.foneContato,
      this.email,
      this.referencia,
      this.dataEntrega,
      this.entrega,
      this.obs});

  PedidoEntrega.fromJson(Map<String, dynamic> json) {
    fromMap(json);
  }

  fromMap(json) {
    try {
      ender = json['ender'];
      cep = json['cep'];
      bairro = json['bairro'];
      cidade = json['cidade'];
      estado = json['estado'];
      numero = json['numero'];
      foneContato = json['fonecontato'];
      email = json['email'];
      referencia = json['referencia'];
      obs = json['obs'];
      dataEntrega = DateTime.tryParse(
          json['dataentrega'] ?? DateTime.now().toDate().toString());
      entrega = json['entrega'] ?? '0';
      compl = json['compl'] ?? '';
    } catch (e) {
      print('Entrega.fromMap: $e -> |$json|');
    }
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    try {
      data['ender'] = this.ender ?? '';
      data['cep'] = this.cep ?? '';
      data['bairro'] = this.bairro ?? '';
      data['cidade'] = this.cidade ?? '';
      data['estado'] = this.estado ?? '';
      data['numero'] = this.numero ?? '';
      data['fonecontato'] = this.foneContato ?? '';
      data['email'] = this.email ?? '';
      data['referencia'] = this.referencia ?? '';
      data['obs'] = this.obs ?? '';
      data['compl'] = this.compl ?? '';
      if (this.dataEntrega != null)
        data['dataentrega'] = this.dataEntrega!.toIso8601String();
      data['entrega'] = entrega;
      //log(data);
    } catch (e) {
      print('Entrega.toJson: $e');
    }
    return data;
  }
}

class PedidoPagamentoItem extends ModelItemBase {
  String? id;
  int? ordem = 0;
  String? operacao = '111';
  DateTime? vcto;
  double? valor = 0.0;
  String? dcto;
  String? gid;
  String? complemento;

  PedidoPagamentoItem(
      {this.id,
      this.operacao,
      this.vcto,
      this.valor,
      this.dcto,
      this.gid,
      this.complemento});

  PedidoPagamentoItem.fromJson(Map<String, dynamic> json) {
    try {
      ordem = json['ordem'];
      id = json['id'];
      operacao = json['operacao'];
      vcto =
          DateTime.tryParse(json['vcto'] ?? DateTime.now().toDate().toString());
      valor = json['valor'];
      dcto = json['dcto'];
      gid = json['gid'];
      complemento = json['complemento'];
    } catch (e) {
      print('PedidoPagamentoItem.fromJson: $e');
    }
  }
  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    try {
      data['id'] = this.id ?? this.ordem.toString();
      data['ordem'] = this.ordem ?? 0;
      data['operacao'] = this.operacao ?? '';
      DateTime v = this.vcto ?? DateTime.now().toDate();
      data['vcto'] = v.toIso8601String();
      data['valor'] = this.valor ?? 0;
      data['dcto'] = this.dcto ?? '';
      data['gid'] = this.gid ?? '';
      data['complemento'] = this.complemento ?? '';
    } catch (e) {
      print('PedidoPagamentoItem.toJson: $e');
    }

    return data;
  }
}

class PedidoPagamentoItems {
  List<PedidoPagamentoItem> items = [];
  toJson() {
    return [for (var item in items) item.toJson()];
  }

  PedidoPagamentoItems.fromJson(List<Map<String, dynamic>> json) {
    items.clear();
    for (var item in json) {
      addJson(item);
    }
  }
  PedidoPagamentoItem addJson(Map<String, dynamic> json) {
    PedidoPagamentoItem item = PedidoPagamentoItem.fromJson(json);
    add(item);
    return item;
  }

  PedidoPagamentoItem add(PedidoPagamentoItem item) {
    item.ordem = items.length + 1;
    items.add(item);
    return item;
  }

  get total {
    double v = 0;
    for (var item in items) {
      v += item.valor!;
    }
    return double.tryParse(v.toStringAsFixed(2));
  }

  set numero(x) {
    for (var item in items) {
      item.dcto = x + '/' + item.ordem.toString();
      //log(item.toJson());
    }
  }
}

class PedidoInterface extends ModelItemBase {
  PedidoDadosVenda? dadosVenda;
  CadastroItem? cliente;
  PedidoProdutoItems? items;
  PedidoEntrega? entrega;
  PedidoPagamentoItems? pagamento;
  Map<String, dynamic>? lojista = {};
  PedidoInterface(
      {this.dadosVenda,
      this.cliente,
      this.items,
      this.entrega,
      this.pagamento});

  @override
  toJson() {
    prepare();
    try {
      return {
        "loja": lojista,
        "dadosvenda": dadosVenda!.toJson(),
        "cliente": cliente!.toJson(),
        "items": items!.toJson(),
        "entrega": (entrega!.entrega != PedidoEntregaModo.internoNaLoja)
            ? entrega!.toJson()
            : {},
        "pagamento": pagamento!.toJson()
      };
    } catch (e) {
      print('Pedido.toJson: $e');
      rethrow;
    }
  }

  prepare() {
    try {
      dadosVenda!.data ??=
          DateTime.parse(DateTime.now().format('yyyy-mm-ddT00:00:00'));
      dadosVenda!.itensCount = items!.count;
      dadosVenda!.total = items!.total;
    } catch (e) {
      print('Pedido.prepare $e');
      rethrow;
    }
  }

  PedidoInterface.fromJson(json) {
    fromMap(json);
  }
  fromMap(json) {
    try {
      dadosVenda = PedidoDadosVenda.fromJson(json['dadosvenda'] ?? {});
      cliente = CadastroItem.fromJson(json['cliente'] ?? {});
      items = PedidoProdutoItems.fromJson(json['items'] ?? []);
      entrega = PedidoEntrega.fromJson(json['entrega'] ?? {});
      pagamento = PedidoPagamentoItems.fromJson(json['pagamento'] ?? []);
      PedidoNotifier().notify(items!.count);
    } catch (e) {
      print('Pedido.fromJson: $e');
    }
    return this;
  }
}

class PedidoModel extends ModelItemBase {
  PedidoInterface _pedido = PedidoInterface();

  fillEntrega(json) {
    var e = PedidoEntrega.fromJson(json);
    try {
      _pedido.entrega!.cep ??= e.cep;
      _pedido.entrega!.ender ??= e.ender;
      _pedido.entrega!.cidade ??= e.cidade;
      _pedido.entrega!.estado ??= e.estado;
      _pedido.entrega!.email ??= e.email;
      _pedido.entrega!.foneContato ??= e.foneContato;
      _pedido.entrega!.numero ??= e.numero;
      _pedido.entrega!.referencia ??= e.referencia;
      _pedido.entrega!.obs ??= e.obs;
      _pedido.entrega!.entrega ??= e.entrega;
    } catch (e) {
      print('FillEntrega: $e');
    }
  }

  send() async {
    try {
      /* o numero passou a ser gerado no servidor 
     if ((_pedido.dadosVenda.pedido ?? '').isEmpty) {
        await gerarNumero();
      }*/
    } catch (e) {
      print('Gerar Número Pedido: $e');
    }
    var resp;
    var dados;
    try {
      dados = _pedido.toJson();
    } catch (e) {
      print('Criando Json Pedido: $e');
      rethrow;
    }
    try {
      resp = await ODataInst().post('pedido/registrar', dados);
      if (resp is String) resp = jsonDecode(resp);
      var j = ODataResult(json: resp);
      _pedido.dadosVenda!.pedido = (j.first['pedido']).toString();
      print('Pedido enviado: $resp');
      try {
        addHistorico(resp);
      } catch (e) {
        print('Pedido.addHistorico: $e');
      }
      return resp;
    } catch (e) {
      print('Resposta de envio do pedido $e');
      rethrow;
    }
    //log(resp);
    return resp;
  }

  addHistorico(dados) {
    try {
      if (dados['rows'] > 0) PedidoHistorico().add(dados['result'][0]);
    } catch (e) {
      print('$dados : $e');
    }
  }

  get items => _pedido.items;
  PedidoDadosVenda get dadosVenda => _pedido.dadosVenda!;
  CadastroItem get cliente => _pedido.cliente!;
  get pagamento => _pedido.pagamento;
  get entrega => _pedido.entrega;
  get lojista => _pedido.lojista;

  toJson() {
    return _pedido.toJson();
  }

  get total => _pedido.items!.total;
  get itemCount => _pedido.items!.count;
  get numero => _pedido.dadosVenda!.pedido;

  PedidoModel.fromJson(json) {
    _pedido = PedidoInterface.fromJson(json);
  }
  fromMap(json) {
    _pedido.fromMap(json);
    return this;
  }

/*  numero passou a ser gerado no servidor
  gerarNumero() async {
    if ((_pedido.dadosVenda.pedido ?? '').isEmpty) {
      _pedido.dadosVenda.pedido = await obterId('PEDIDO');
    }
    _pedido.pagamento.numero = _pedido.dadosVenda.pedido;
    return _pedido.dadosVenda.pedido;
  }
*/

  clear() {
    _pedido.fromMap({});
    dadosVenda.clear();
    notifyChange();
  }

  notifyChange({value}) {
    PedidoNotifier().notify(value ?? items.count);
  }

  prepare() async {
    _pedido.prepare();
    //await gerarNumero();
  }
}

class PedidoHistorico {
  static final _singleton = PedidoHistorico._create();
  int _instances = 0;
  PedidoHistorico._create();
  factory PedidoHistorico() => _singleton;
  final List<Map<String, dynamic>> items = [];
  init() {
    if (_instances == 0) carregar();
  }

  add(item) {
    items.insert(0, item);
    //log(items);
    gravar();
  }

  toJson() {
    return [for (var item in items) item];
  }

  gravar() {
    LocalStorage().setKey('pedido_historico', jsonEncode(toJson()));
  }

  carregar() {
    _instances++;
    try {
      List<Map<String, dynamic>> lst =
          jsonDecode(LocalStorage().getKey('pedido_historico') ?? '[]')
              as List<Map<String, dynamic>>;
      items.clear();
      //log(lst);
      for (var item in lst) {
        items.add(item);
      }
    } catch (e) {
      print('Não tem historico para carregar - pedido_model');
    }
  }
}

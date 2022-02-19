// @dart=2.12

import 'package:controls_data/data_model.dart';

const c_restserver = 'https://estouentregando.com';
const c_smsserver = 'https://sms.estouentregando.com:8080';

class ConfigItem extends DataItem {
  String? _id;
  String? nome;
  String restserver = c_restserver;
  String restserverPrefix = '/v3/';
  String smsserver = c_smsserver;
  bool? inativo = false;
  double? filial = 1;
  bool ativarAgendaPET = false;
  bool ativarAgendaContato = true;
  bool ativarOrdemServico = false;
  bool ativarPedidoVenda = true;
  bool ativarEstoque = false;
  bool ativarFinancas = false;
  bool ativarAgendaVeiculo = false;
  bool ativarPagamentoNoPedido = false;
  bool ativarConsignadoProprio = false;
  //bool ativarPrecoPorFilial = false;
  bool ativarControlePorFilial = false;
  bool ativarMensageria = false; // reservado para expansão da mensageria.

  bool pedidoLimitarVisaoPorVendedor = true;

  String? googleCseEngineID;
  String? googleCseKey;

  ConfigItem.fromJson(json) {
    fromMap(json);
  }
  Map<String, dynamic> toJson() {
    var r = {
      'id': _id,
      'nome': nome,
      'restserver': restserver,
      'restserverPrefix': restserverPrefix,
      'filial': filial,
      'inativo': inativo,
      'ativarAgendaPET': ativarAgendaPET,
      'ativarAgendaContato': ativarAgendaContato,
      'ativarOrdemServico': ativarOrdemServico,
      'ativarAgendaVeiculo': ativarAgendaVeiculo,
      'ativarFinancas': ativarFinancas,
      'ativarEstoque': ativarEstoque,
      'ativarPedidoVenda': ativarPedidoVenda,
      'ativarPagamentoNoPedido': ativarPagamentoNoPedido,
      'ativarControlePorFilial': ativarControlePorFilial,
      'smsserver': smsserver,
      'ativarConsignadoProprio': ativarConsignadoProprio,
      'pedidoLimitarVisaoPorVendedor': pedidoLimitarVisaoPorVendedor,
      'googleCseEngineID': googleCseEngineID,
      'googleCseKey': googleCseKey,
    };
    return r;
  }

  fromMap(json) {
    _id = json['id'];
    nome = json['nome'] ?? '';
    restserver = json['restserver'] ?? c_restserver;
    restserverPrefix = json['restserverPrefix'] ?? '/v3/';
    if (json['inativo'] is bool) inativo = json['inativo'];
    filial = double.tryParse((json['filial'] ?? 1).toString());
    ativarAgendaPET = json['ativarAgendaPET'] ?? false;
    ativarAgendaContato = json['ativarAgendaContato'] ?? false;
    ativarOrdemServico = json['ativarOrdemServico'] ?? false;
    ativarAgendaVeiculo = json['ativarAgendaVeiculo'] ?? false;
    //DONE: ajustar configuracao de estoque nas configuracoes
    ativarEstoque = json['ativarEstoque'] ?? ativarOrdemServico ?? false;
    //DONE: ajustar configuracao de financas nas configuracoes
    ativarFinancas = json['ativarFinancas'] ?? ativarOrdemServico ?? false;
    ativarPedidoVenda = json['ativarPedidoVenda'] ?? false;
    ativarPagamentoNoPedido = json['ativarPagamentoNoPedido'] ?? false;
    ativarControlePorFilial =
        (json['ativarControlePorFilial'] ?? json['ativarPrecoPorFilial']) ??
            false;
    smsserver = json['smsserver'] ?? c_smsserver;
    ativarConsignadoProprio = json['ativarConsignadoProprio'] ?? false;
    pedidoLimitarVisaoPorVendedor =
        json['pedidoLimitarVisaoPorVendedor'] ?? true;

    googleCseEngineID = json['googleCseEngineID'];
    googleCseKey = json['googleCseKey'];
  }

  get ativarPrecoPorFilial => ativarControlePorFilial;
}

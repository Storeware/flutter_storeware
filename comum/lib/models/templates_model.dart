// @dart=2.12
import 'package:controls_data/data_model.dart';
import 'package:controls_data/odata_client.dart';
import 'package:controls_data/odata_firestore.dart';
//import 'package:console/config/config.dart';
import 'package:controls_extensions/extensions.dart';

class TemplatesItem extends DataItem {
  String? nome;
  String? texto;

  TemplatesItem({this.nome, this.texto});

  TemplatesItem.fromJson(Map<String, dynamic> json) {
    fromMap(json);
  }
  @override
  fromMap(Map<String, dynamic> json) {
    nome = json['nome'];
    texto = json['texto'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nome'] = this.nome;
    data['texto'] = this.texto;
    data['id'] = this.nome;
    return data;
  }
}

class TemplatesItemModel extends ODataModelClass<TemplatesItem> {
  final dynamic configInstance;
  TemplatesItemModel(this.configInstance) {
    collectionName = 'templates';
    super.API = ODataInst();
    super.CC = CloudV3().client..client.silent = true;
  }
  TemplatesItem newItem() => TemplatesItem();

  procurarPor(String key) {
    return listCached(filter: "nome eq '$key'");
  }

  Future<List<dynamic>> procurarOuInserir(String key, String texto) async {
    return listCached(filter: "nome eq '$key'").then((rsp) {
      if (rsp.length == 0) {
        var result = {"nome": key, "texto": texto};
        put(result);
        return [result];
      }
      return rsp;
    });
  }

  Future<String> procurarETraduzir(String key, String texto,
      {String? titulo,
      Map<String, dynamic>? values,
      DateTime? data,
      String? ctprodCodigo,
      double? sigcadCodigo,
      double? filial}) async {
    return procurarOuInserir(key, texto).then((rsp) {
      if (rsp.length == 0) return '';
      var txt = rsp[0]['texto'];
      return traduzirTags(txt,
          titulo: titulo ?? '',
          values: values ?? {},
          data: data ?? DateTime.now(),
          ctprodCodigo: ctprodCodigo ?? '',
          sigcadCodigo: sigcadCodigo ?? 0,
          filial: filial ?? 0);
    });
  }

  traduzirTexto(String texto, Map<String, dynamic> json, {String alias = ''}) {
    var result = texto;
    json.forEach((key, value) {
      var palavra = '{$alias$key}'.toLowerCase();
      result = result.replaceAll(palavra, '$value');
    });
    return result;
  }

  static final names = [
    '{titulo}',
    '{vendedor.codigo}',
    '{vendedor.nome}',
    '{dia}',
    '{mes}',
    '{ano}',
    '{data}',
    '{hora}',
    '{loja.nome}',
    '{loja.fone}',
    '{loja.email}',
    '{loja.ender}',
    '{loja.cnpj}',
    '{loja.ie}',
    '{pessoa.nome}',
    '{pessoa.ender}',
    '{pessoa.fone}',
    '{pessoa.email}',
    '{pessoa.cep}',
    '{produto.nome}',
    '{produto.unidade}',
    '{produto.codigo}'
  ];

  Future<String> traduzirTags(String texto,
      {String? titulo,
      Map<String, dynamic>? values,
      DateTime? data,
      String? ctprodCodigo,
      double? sigcadCodigo,
      double? filial}) async {
    /// dados customizados
    Map<String, dynamic> dados = configInstance?.dadosLoja ?? {};
    if (configInstance != null) {
      dados["vendedor.nome"] = configInstance?.nomeVendedor ?? '';
      dados['vendedor.codigo'] = configInstance?.codigoVendedor ?? '';
    }
    if (titulo != null) dados['titulo'] = titulo;
    if (data != null) {
      dados['dia'] = data.format('dd');
      dados['mes'] = data.format('MMMM');
      dados['ano'] = data.format('yyyy');
      dados['data'] = data.format('dd/MM/yyyy');
      dados['hora'] = data.format('H:mm');
    }

    String result = traduzirTexto(texto, dados);

    /// por parametros
    if (values != null) result = traduzirTexto(result, values);

    /// dados da filial
    try {
      if (filial != null)
        await listCached(resource: 'filial', filter: 'codigo eq $filial')
            .then((frow) {
          if (frow.length > 0) {
            var d = frow[0];
            d['cnpj'] = d['cgc'];
            result = traduzirTexto(result, d, alias: 'loja.');
          }
        });
    } catch (d) {
      //
    }

    /// dados do cliente
    try {
      if (sigcadCodigo != null)
        await listCached(resource: 'sigcad', filter: 'codigo eq $sigcadCodigo')
            .then((frow) {
          if (frow.length > 0) {
            result = traduzirTexto(result, frow[0], alias: 'pessoa.');
          }
        });
    } catch (e) {
      //
    }

    /// dados de prooduto
    try {
      if (ctprodCodigo != null)
        await listCached(
                resource: 'ctprod', filter: "codigo eq '$ctprodCodigo'")
            .then((frow) {
          if (frow.length > 0) {
            result = traduzirTexto(result, frow[0], alias: 'produto.');
          }
        });
    } catch (e) {
      //
    }

    /// informações de usuario
    if (configInstance != null)
      try {
        result = traduzirTexto(result, configInstance.dadosUsuario.toJson());
      } catch (e) {
        //
      }
    return result;
  }
}

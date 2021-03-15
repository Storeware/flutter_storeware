import 'dart:convert';

import 'package:controls_data/data_model.dart';
import 'package:controls_data/odata_client.dart';
import 'package:dio/dio.dart';

class PixParams {
  DateTime? data = DateTime.now();
  String? conta;
  String? ref;
  double? valor;
  String? nome;
  String? local;

  toUrlParams({String sep = '&'}) {
    String r = '';
    toJson().forEach((key, value) {
      if (value != null) {
        String v;
        if (value is String)
          v = Uri.encodeComponent(value);
        else
          v = '$value';
        var s = '$key=$v';
        r += (r.isEmpty) ? s : '&$s';
      }
    });
    return r;
  }

  Map<String, dynamic> toJson() {
    return {
      "data": data!.toIso8601String(),
      "conta": conta,
      "valor": valor,
      "ref": ref,
      "nome": nome,
      "local": local
    };
  }

  PixParams.fromJson(Map<String, dynamic> json) {
    try {
      conta = json['pixConta'] ?? json['conta'];
      valor = toDouble(json['valor']);
      ref = json['ref'];
      nome = json['pixNome'] ?? json['nome'];
      local = json['local'] ?? json['pixLocal'];
      data = toDateTime(json['data'] ?? DateTime.now());
    } catch (e) {
      // nada.
      print(toJson());
    }
  }
}

class PixItem extends DataItem {
  bool? inativo;

  PixItem({this.inativo});

  PixItem.fromJson(data) {
    fromMap(data);
  }

  @override
  fromMap(data) {
    id = data['id'];
    inativo = data['inativo'] ?? false;
    return this;
  }

  @override
  toJson() {
    return {'id': id, 'inativo': inativo};
  }
}

class PixModel extends ODataModelClass<PixItem> {
  PixModel() {
    super.collectionName = 'Pix';
    API = ODataClient();
  }
  // @override
  PixItem createItem() {
    return PixItem();
  }

  String urlBase = 'https://estouentregando.com/pagar';
  genCode(PixParams item) async {
    var url = '$urlBase/pix?${item.toUrlParams()}';
    print(url);
    Dio dio = Dio();
    return dio.get(url).then((rsp) {
      return rsp.data;
    });
  }

  getImageBytes(PixParams item) async {
    return genCode(item).then((imagemBase64) {
      var img = imagemBase64.split('base64,');
      var cod = (img.length > 0) ? img[1] : img[0];

      return base64Decode(cod);
    });
  }
}

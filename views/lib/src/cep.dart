// @dart=2.12
import 'package:controls_data/cached.dart';
import 'package:controls_data/rest_client.dart';

class CEPItem {
  String? logradouro;
  String? cidade;
  String? estado;
  String? bairro;
  String? cep;
  String? compl;
  String? ddd;
  String? ibge;
  String? gia;
  String? siafi;
  CEPItem.fromJson(json) {
    logradouro = json['logradouro'];
    cep = json['cep'];
    compl = json['complemento'];
    bairro = json['bairro'];
    cidade = json['localidade'];
    estado = json['uf'];
    ddd = json['ddd'];
    ibge = json['ibge'];
    gia = json['gia'];
    siafi = json['siafi'];
    //(json);
  }
}

class CEP {
  static Future<dynamic> buscar(String? cep) async {
    if (cep == null) return null;
    String v = CEP.soNumeros(cep);
    return Cached.value(v, builder: (v) {
      if (v.length == 8) {
        try {
          var client = RestClient();
          return client
              .openJsonAsync('https://viacep.com.br/ws/' + v + '/json/')
              .then((resp) {
            return resp;
          });
        } catch (e) {
          return null;
        }
      }
    });
  }

  static soNumeros(v) {
    String r = '';
    for (var i = 0; i < v.length; i++) {
      var k = v[i];
      if ('0123456789'.contains(k)) r += k;
    }
    return r;
  }
}

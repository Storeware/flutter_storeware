import 'dart:async';
import 'package:models/data.dart';
import 'dart:convert';

class ViaCepService extends RestClient {
  ViaCepService({baseUrl}) {
    if (baseUrl!=null)
       this.baseUrl = baseUrl;
  }
  Future<String> consultarFire(String cep) async {
    return await send('/extra/buscaCep/' + cep, method: 'GET').then((r) {
      print(r);
      return r;
    });
  }

  Future<String> consultarGeoCode(String cep) async {
    String url =
        "https://maps.google.com/maps/api/geocode/json?address=$cep&language=pt-BR&region=br&key=AIzaSyBZPzEgwY2uLZsvKL4idTWyFZezG66Dr20";
    var r = await openUrl(Uri.parse(url), method: 'GET');
    var resp = json.decode(r);
    List<dynamic> results = resp['results'];
    resp = {};
    results.forEach((r) {
      if (r['geometry'] != null) {
        resp['location'] = r['geometry']['location'];
      }
      if (r['formatted_address'] != null) {
        resp['complemento'] = r['formatted_address'];
      }

      if (r['address_components'] != null) {
        List<dynamic> cmps = r['address_components'];
        List<dynamic> _types;
        cmps.forEach((f) {
          _types = f['types'];
          if (_types.contains('postal_code'))
            resp['cep'] = f['short_name'];
          else if (_types.contains('sublocality'))
            resp['bairro'] = f['long_name'];
          else if (_types.contains('administrative_area_level_2')) {
            resp['localidade'] = f['long_name'];
            resp['cidade'] = f['long_name'];
          } else if (_types.contains('administrative_area_level_1')) {
            resp['estado'] = f['long_name'];
            resp['uf'] = f['short_name'];
          } else if (_types.contains('country')) resp['pais'] = f['long_name'];
        });
      }
    });
    return jsonEncode(resp);
  }
}

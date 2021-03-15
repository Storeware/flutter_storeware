import '../data/restserver_service.dart';

String defaultServerHost = 'http://localhost:8886';

class RestServer extends RestserverService {
  static final _singleton = RestServer._create();
  RestServer._create() : super(defaultServerHost);
  factory RestServer() => _singleton;
  String get baseUrl => super.host;
  set baseUrl(String x) {
    host = x;
  }

  results({key = 'result'}) {
    return toList(key: key);
  }

  Future<String> send(servico) async {
    return openUrl('GET', servico);
  }

  Map<String, dynamic>? result({Map<String, dynamic>? data, key = 'result'}) {
    return value(data: data, key: key);
  }

  int? rows({key = 'rows'}) {
    return int.tryParse(value(key: key).toString());
  }
}

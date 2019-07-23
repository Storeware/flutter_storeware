import '../data/restserver_service.dart';

String defaultServerHost = 'http://localhost:8886';

class RestServer extends RestserverService {
  static final _singleton = RestServer._create();
  RestServer._create() : super(defaultServerHost);
  factory RestServer() => _singleton;
  get baseUrl => super.host;
  set baseUrl(String x) {
    host = x;
  }

  result({key = 'result'}) {
    return toList(key: key);
  }
}

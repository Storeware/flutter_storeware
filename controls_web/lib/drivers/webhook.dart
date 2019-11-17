import '../classes.dart';

import 'firebase_config.dart';

import "rest_client.dart";

class WebHook extends RestClient with Base {
  WebHook({baseUrl}) {
    super.baseUrl = baseUrl ?? AssetsConfig().webhook;
  }
}

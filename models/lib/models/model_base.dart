import 'dart:convert';

import 'package:controls_data/odata_client.dart';

abstract class ModelItemBase {
  toJson();
  String toString() {
    return jsonEncode(toJson());
  }

  Future<String?> obterId(String nome) async {
    var resp = await ODataInst().send(ODataQuery(
        resource: "obter_id('$nome')",
        select: 'numero')); // usa open para não entrar no cache.
    if (resp['rows'] == 0) return null;
    var n = resp['result'][0]['numero'].toString();
    return n;
  }
}

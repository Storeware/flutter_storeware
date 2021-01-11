import 'package:controls_extensions/extensions.dart';

class SqlBuilder {
  static createSqlUpdate(collection, key, Map<String, dynamic> dados,
      {String colunas}) {
    var where = "$key = '${dados[key]}' ";
    var s = '';
    List<String> keys = dados.keys.join(',').split(',');
    if (colunas != null) keys = colunas.split(',');

    keys.forEach((k) {
      var d = dados[k];
      if (d == null) {
        //s += '$k = null'; // nao enviar nulls
      } else {
        if (s.isNotEmpty) s += ', ';
        if (d is num)
          s += '$k = $d';
        else if (d is DateTime) {
          var dt = d.toDateTimeSql();

          s += "$k = '$dt' ";
        } else
          s += "$k = '$d'";
      }
    });
    s = 'update $collection set $s where $where';
    return s;
  }

  // TODO: insert sql
  static createSqlInsert(collection,
      {Map<String, dynamic> dados, String colunas}) {
    // TODO:
    throw 'nao implementado';
  }

  // TODO: delete sql
  static createSqlDelete(collection, key, {Map<String, dynamic> dados}) {
    var where = "$key = '${dados[key]}' ";
    return 'delete from $collection where $where';
  }
}

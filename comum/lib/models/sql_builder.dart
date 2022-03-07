// @dart=2.12
import 'package:controls_extensions/extensions.dart';

class SqlBuilder {
  static createSqlUpdate(
      collection, String matching, Map<String, dynamic> dados,
      {String? colunas, required String? driver}) {
    var mts = matching.split(',');
    if (mts.isEmpty)
      throw 'Condição "matching" não informada para montar a where';
    var where = '';
    mts.forEach((elem) {
      final k = elem.trim();
      if (dados[k] == null)
        throw 'Condição de seleção where não pode ser null para coluna [$k]';
      if (where.isNotEmpty) where += ' and ';
      where += "$k = ${reviverEncode(dados[k])} ";
    });
    var qry = '';
    List<String> keys = dados.keys.join(',').split(',');
    if (colunas != null) keys = colunas.split(',');

    keys.forEach((elem) {
      final k = elem.trim();
      var d = dados[k];
      if (d == null) {
        //s += '$k = null'; // nao enviar nulls
      } else {
        if (qry.isNotEmpty) qry += ', ';
        qry += "$k = ${reviverEncode(d)}";
      }
    });
    qry = 'update $collection set $qry where $where';
    if (driver == 'mssql') if (driver == 'mssql') return formatMsSql(qry);

    return qry;
  }

  static reviverEncode(value) {
    String rsp = '';
    if (value is int || value is double || value is num)
      rsp = '$value';
    else if (value is DateTime)
      rsp = "'${value.toDateTimeSql()}'";
    else
      rsp += "'$value'";
    return rsp;
  }

  static createSqlInsert(collection,
      {required Map<String, dynamic> dados,
      required String colunas,
      required String driver}) {
    // TODO: não foi testado (não esta em uso no momento)
    // apos validar, remover esta mensagem.
    String values = '';
    List<String> keys = colunas.split(',');
    keys.forEach((elem) {
      final k = elem.trim();
      if (values.isNotEmpty) values += ', ';
      values += reviverEncode(dados[k]);
    });
    String qry = 'insert into $collection ($colunas) values ($values)';
    if (driver == 'mssql') return formatMsSql(qry);
    return qry;
  }

  static createSqlDelete(collection, matching,
      {Map<String, dynamic>? dados, required String driver}) {
    var mts = matching.split(',');
    if (mts.isEmpty)
      throw 'Condição "matching" não informada para montar a where';
    var where = '';
    mts.forEach((elem) {
      final key = elem.trim();
      if (dados![key] == null)
        throw 'Condição de seleção where não pode ser null para coluna [$key]';
      if (where.isNotEmpty) where += ' and ';
      where += "$key = ${reviverEncode(dados[key])} ";
    });
    String qry = 'delete from $collection where $where';
    if (driver == 'mssql') return formatMsSql(qry);
    return qry;
  }

  static formatMsSql(String query) {
    return '''
        begin
          $query;
          select @@rowcount as __rows;
        end''';
  }
}

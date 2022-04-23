// @dart=2.12

import 'package:controls_data/odata_client.dart';
import 'package:controls_data/odata_firestore.dart';
import 'package:controls_extensions/extensions.dart';
import 'package:uuid/uuid.dart';
import 'agenda_item_model.dart';

class AgendaItemModel extends ODataModelClass<AgendaItem> {
  AgendaItemModel() {
    collectionName = 'agenda';
    super.API = ODataInst();
    super.CC = CloudV3().client; //..client.silent = true;
  }
  AgendaItem newItem() => AgendaItem();

  webHookSend() {
    try {
      // print('webHookSend');
      API!.client
          .openJson('/webhook/send', method: 'GET', cacheControl: 'no-cache')
          .then((r) => print(r));
    } catch (e) {
      // nao faz nada
    }
  }

  listAgenda({String? filter, num? top}) {
    return super.listNoCached(
      filter: filter,
      top: top,
      cacheControl: 'no-cache',
      select: 'a.*, c.nome nomecliente',
      resource: 'agenda a left join sigcad c on (c.codigo=a.sigcad_codigo)',
    );
  }

  Future<int> qtdeAgendasDoDia(DateTime data) {
    DateTime de = data.startOfDay();
    DateTime ate = data.endOfDay();
    return API!
        .openJson(
            "select count(*) qtde from agenda where datainicio between '$de' and '$ate' ")
        .then((item) {
      //print(item);

      return item['result'].first['qtde'];
    });
  }

  get isMssql => (API!.client.headers['db-driver'] ?? 'fb') == 'mssql';
  Future<List<dynamic>> qtdeDiariaNoMes(DateTime dataInicio, DateTime dataFim) {
    DateTime de = dataInicio.startOfDay();
    DateTime ate = dataFim.endOfDay();

    if (isMssql)
      return API!
          .openJson(
              "select day(datainicio) dia, count(*) qtde from agenda where datainicio between '$de' and '$ate' group by day(datainicio) ")
          .then((item) {
        return item['result'];
      });
    else
      return API!
          .openJson(
              "select extract(day from datainicio ) dia, count(*) qtde from agenda where datainicio between '$de' and '$ate' group by 1 ")
          .then((item) {
        //print(item);

        return item['result'];
      });
  }

  Future<List<dynamic>> qtdePorRecurso(DateTime dataInicio, DateTime dataFim) {
    DateTime de = dataInicio.startOfDay();
    DateTime ate = dataFim.endOfDay();
    return API!
        .openJson(
            "select b.gid, b.nome nome, count(*) qtde from agenda a, AGENDA_RECURSO b " +
                "where a.recurso_gid = b.gid and datainicio between '$de' and '$ate'  " +
                "group by b.gid,b.nome order by 3 desc")
        //"select extract(day from datainicio ) dia, count(*) qtde from agenda where datainicio between '$de' and '$ate' group by 1 ")
        .then((item) {
      //print(item);

      return item['result'];
    });
  }

  Future<List<dynamic>> qtdePorEstado(DateTime dataInicio, DateTime dataFim) {
    DateTime de = dataInicio.startOfDay();
    DateTime ate = dataFim.endOfDay();
    return API!
        .openJson(
            "select b.gid, b.nome nome, count(*) qtde from agenda a, agenda_estado b " +
                "where a.estado_gid = b.gid and datainicio between '$de' and '$ate'  " +
                "group by b.gid,b.nome  order by 3 desc")
        .then((item) {
      return item['result'];
    });
  }

  Future<List<AgendaItem>> replicarAgenda(
      {required AgendaItem item,
      int? dias,
      required int vezes,
      String estado = '1',
      Function(int, int)? onProgress}) async {
    List<AgendaItem> rsp = [];
    DateTime? ini = item.datainicio, fim = item.datafim;
    for (var i = 1; i <= vezes; i++) {
      ini = ini!.add(Duration(days: dias!));
      fim = fim!.add(Duration(days: dias));
      var clone = AgendaItem.fromJson(item.toJson());
      try {
        if (onProgress != null) onProgress(i, vezes);
        clone.id = Uuid().v4();
        clone.parentid = item.id;

        clone.datainicio = ini;
        clone.datafim = fim;
        clone.estadoGid = estado;
        clone.completada = 0;
        await post(clone).then((r) {
          rsp.add(clone);
        });
      } catch (e) {
        /// nada a fazer
      }
    }
    return rsp;
  }
}

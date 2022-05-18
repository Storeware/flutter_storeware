// @dart=2.12
import 'package:controls_data/data_model.dart';
import 'package:controls_data/odata_client.dart';

class EventosItemNotasItem extends DataItem {
  double? eventosid;
  DateTime? data;
  String? texto;
  String? pessoa;
  String? usuario;

  EventosItemNotasItem(
      {this.eventosid, this.data, this.texto, this.pessoa, this.usuario});

  EventosItemNotasItem.fromJson(data) {
    fromMap(data);
  }

  @override
  fromMap(data) {
    id = data['id'];
    this.eventosid = toDouble(data['eventosid']);
    this.data = toDateTime(data['data']);
    this.texto = data['texto'];
    this.pessoa = data['pessoa'];
    this.usuario = data['usuario'];
    return this;
  }

  @override
  toJson() {
    return {
      'id': id,
      'eventosid': this.eventosid,
      'data': toDateTimeSql(this.data!),
      'texto': texto,
      'pessoa': pessoa,
      'usuario': usuario
    };
  }
}

class EventosItemNotasModel extends ODataModelClass<EventosItemNotasItem> {
  EventosItemNotasModel() {
    super.collectionName = 'eventos_item_notas';
    API = ODataInst();
  }
  // @override
  EventosItemNotasItem createItem() {
    return EventosItemNotasItem();
  }
}

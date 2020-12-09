import 'package:controls_data/data_model.dart';
import 'package:controls_data/odata_client.dart' hide DynamicExtension;
//import 'package:controls_data/odata_firestore.dart';
import 'package:controls_extensions/extensions.dart';
import 'package:controls_web/drivers/bloc_model.dart';
import 'package:uuid/uuid.dart';

class EventosItemItem extends DataItem {
  //int id;
  DateTime data;
  String obs;
  String link;
  String inativo;
  String titulo;
  String autor;
  String pessoa;
  String arquivado;
  DateTime datalimite;
  double idestado;
  double idgrupoEstado;
  double cliente;
  String dcto;
  double idmaster;
  String tabela;
  double idtabela;
  String eventosAutoNome;
  double ordemtabela;
  double valor;
  String usuario;
  String gid;

  EventosItemItem(
      { //this.id,
      this.data,
      this.obs,
      this.link,
      this.inativo,
      this.titulo,
      this.autor,
      this.pessoa,
      this.arquivado,
      this.datalimite,
      this.idestado,
      this.idgrupoEstado,
      this.cliente,
      this.dcto,
      this.idmaster,
      this.tabela,
      this.idtabela,
      this.eventosAutoNome,
      this.ordemtabela,
      this.valor,
      this.usuario,
      this.gid});

  EventosItemItem.fromJson(Map<String, dynamic> json) {
    fromMap(json);
  }
  @override
  fromMap(Map<String, dynamic> json) {
    data = toDateTime(json['data'], zone: 0);
    obs = json['obs'];
    link = json['link'];
    inativo = json['inativo'];
    titulo = json['titulo'];
    autor = json['autor'];
    pessoa = json['pessoa'];
    arquivado = json['arquivado'];
    datalimite = toDateTime(json['datalimite']);
    idestado = toDouble(json['idestado']);
    idgrupoEstado = toDouble(json['idgrupo_estado']);
    cliente = toDouble(json['cliente']);
    dcto = json['dcto'];
    idmaster = toDouble(json['idmaster']);
    tabela = json['tabela'];
    idtabela = toDouble(json['idtabela']);
    eventosAutoNome = json['eventos_auto_nome'];
    ordemtabela = toDouble(json['ordemtabela']);
    valor = toDouble(json['valor']);
    usuario = json['usuario'];
    gid = json['gid'];
    if (json['id'] != null) id = '${json['id']}';

    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = toDateTime(this.data).toDateTimeSql();
    data['obs'] = this.obs;
    data['link'] = this.link;
    data['inativo'] = this.inativo ?? 'N';
    data['titulo'] = this.titulo;
    data['autor'] = this.autor;
    data['pessoa'] = this.pessoa;
    data['arquivado'] = this.arquivado ?? 'N';
    data['datalimite'] = toDateTime(this.datalimite).toDateTimeSql();
    data['idestado'] = this.idestado ?? 0;
    data['idgrupo_estado'] = this.idgrupoEstado ?? 0;
    data['cliente'] = this.cliente ?? 0;
    data['dcto'] = this.dcto;
    data['idmaster'] = this.idmaster ?? 0;
    data['tabela'] = this.tabela;
    data['idtabela'] = this.idtabela ?? 0;
    data['eventos_auto_nome'] = this.eventosAutoNome;
    data['ordemtabela'] = this.ordemtabela ?? 0;
    data['valor'] = this.valor;
    data['usuario'] = this.usuario;
    data['gid'] ??= Uuid().v4();

    /// quando é insert o id é gerado no servidor.
    if (this.id != null)
      data['id'] = '${this.id}'; // no firebird id é um double
    return data;
  }

  static get keys {
    return EventosItemItem.fromJson({}).toJson().keys;
  }
}

class EventosItemNotifier extends BlocModel<String> {
  static final _singleton = EventosItemNotifier._create();
  EventosItemNotifier._create();
  factory EventosItemNotifier() => _singleton;
}

class EventosItemItemModel extends ODataModelClass<EventosItemItem> {
  EventosItemItemModel() {
    collectionName = 'eventos_item';
    super.API = ODataInst();
    //super.CC = CloudV3().client; // inconsistencia no ID que é um double no firebird

    columns = EventosItemItem.keys.join(',').replaceAll('obs',
        'cast(obs as varchar(255)) obs'); // troca o memo para um cast varchar
  }
  EventosItemItem newItem() => EventosItemItem();

  arquivar({gid, String flag = 'S'}) async {
    return API
        .execute("update eventos_item set arquivado='$flag' where gid ='$gid'");
  }

  @override
  put(dynamic item) {
    return super.put(item).then((resp) {
      EventosItemNotifier().notify(item['titulo']);
      return resp;
    });
  }
}

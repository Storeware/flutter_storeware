// @dart=2.12
import 'package:controls_data/data_model.dart';
import 'package:controls_data/odata_client.dart';
//import 'package:controls_data/odata_firestore.dart';
//import 'package:controls_extensions/extensions.dart' as ext;
import 'package:controls_web/drivers/bloc_model.dart';
import 'package:uuid/uuid.dart';

class EventosItemItem extends DataItem {
  //int id;
  DateTime? data;
  String? obs;
  String? link;
  String? inativo;
  String? titulo;
  String? autor;
  String? pessoa;
  String? arquivado;
  DateTime? datalimite;
  double? idestado;
  double? idgrupoEstado;
  double? cliente;
  String? dcto;
  double? idmaster;
  String? master;
  String? masterGid;
  String? tabela;
  double? idtabela;
  String? tabelaGid;
  String? eventosAutoNome;
  double? ordemtabela;
  double? valor;
  String? usuario;
  String? gid;
  String? leu;

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
    datalimite = toDateTime(json['datalimite'], zone: 0);
    idestado = toDouble(json['idestado']);
    idgrupoEstado = toDouble(json['idgrupo_estado']);
    cliente = toDouble(json['cliente']);
    dcto = json['dcto'];
    idmaster = toDouble(json['idmaster']);
    tabela = json['tabela'];
    idtabela = toDouble(json['idtabela']);
    tabelaGid = json['tabela_gid'];
    eventosAutoNome = json['eventos_auto_nome'];
    ordemtabela = toDouble(json['ordemtabela']);
    valor = toDouble(json['valor']);
    usuario = json['usuario'];
    gid = json['gid'];
    id = json['id'];
    master = json['master'];
    masterGid = json['master_gid'];
    leu = json['leu'] ?? 'N';
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = toDateTimeSql(toDateTime(this.data));
    data['obs'] = this.obs;
    data['link'] = this.link;
    data['inativo'] = this.inativo ?? 'N';
    data['titulo'] = this.titulo;
    data['autor'] = this.autor;
    data['pessoa'] = this.pessoa;
    data['arquivado'] = this.arquivado ?? 'N';
    data['datalimite'] = toDateTimeSql(toDateTime(this.datalimite));
    data['idestado'] = this.idestado ?? 0;
    data['idgrupo_estado'] = this.idgrupoEstado ?? 0;
    data['cliente'] = this.cliente ?? 0;
    data['dcto'] = this.dcto;
    data['idmaster'] = this.idmaster ?? 0;
    data['tabela'] = this.tabela;
    data['idtabela'] = this.idtabela ?? 0;
    data['tabela_gid'] = this.tabelaGid;
    data['eventos_auto_nome'] = this.eventosAutoNome;
    data['ordemtabela'] = this.ordemtabela ?? 0;
    data['valor'] = this.valor;
    data['usuario'] = this.usuario;
    data['gid'] ??= Uuid().v4();
    data['master'] = this.master;
    data['master_gid'] = this.masterGid;
    data['leu'] = this.leu ?? 'N';

    /// quando é insert o id é gerado no servidor.
    if (this.id != null)
      data['id'] = '${this.id}'; // no firebird id é um double
    return data;
  }

  static get keys {
    return EventosItemItem.fromJson({"id": ""}).toJson().keys;
  }
}

class EventosItemNotifier extends BlocModel<String?> {
  static final _singleton = EventosItemNotifier._create();
  EventosItemNotifier._create();
  factory EventosItemNotifier() => _singleton;
}

class EventosItemItemModel extends ODataModelClass<EventosItemItem> {
  EventosItemItemModel() {
    collectionName = 'eventos_item';
    super.API = ODataInst();
    //super.CC = CloudV3().client; // inconsistencia no ID que é um double no firebird
    final keys = EventosItemItem.fromJson({"id": ''}).toJson();
    columns = keys.keys.join(',').replaceAll('obs',
        'cast(obs as varchar(255)) obs'); // troca o memo para um cast varchar
  }
  EventosItemItem newItem() => EventosItemItem();

  arquivar({gid, String flag = 'S'}) async {
    return API!
        .execute("update eventos_item set arquivado='$flag' where gid ='$gid'");
  }

  @override
  put(item) {
    Map<String, dynamic>? _item;
    if (item is EventosItemItem)
      _item = item.toJson();
    else
      _item = item;
    return super.put(_item).then((resp) {
      EventosItemNotifier().notify(_item!['titulo']);
      return resp!;
    });
  }

  pegar(gid, pessoa) {
    return API!.execute(
        "update eventos_item set leu='S', arquivado='N', pessoa = '$pessoa' where gid = '$gid' ");
  }

  marcarLeu({String? gid, String flag = 'S'}) {
    return API!
        .execute("update eventos_item set leu='$flag' where gid = '$gid' ");
  }

  Future<num> pegarNaoLidas(String usuario) async {
    return listNoCached(
            select: 'count(*) n',
            filter:
                "pessoa='$usuario' and arquivado='N' and (leu='N' or leu is null) ")
        .then((rsp) {
      // print(rsp);
      return (rsp.length == 0) ? 0 : rsp[0]['n'];
    });
  }
}

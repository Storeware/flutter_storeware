// @dart=2.12
import 'dart:async';

import 'package:controls_web/drivers/bloc_model.dart';

import 'agenda_const.dart';
import 'package:flutter/widgets.dart';

import 'agenda_notifier.dart';
import 'agenda_resource.dart';
import 'models/agenda_config.dart';
import 'models/agenda_item_model.dart';
import 'package:controls_extensions/extensions.dart';

class AgendaData {
  AgendaItem? item;
  AgendaController? controller;
  DateTime? date;
  double? hour;
  int? interval;
  DefaultSourceList? sources;
  String? resource;
  BuildContext? parentContext;
  bool mostrarResource;
  AgendaData({
    this.item,
    this.date,
    this.controller,
    this.hour,
    this.mostrarResource = false,
    this.interval,
    required this.sources,
    this.resource,
    this.parentContext,
  });
  AgendaData copyWith({
    item,
    date,
    controller,
    hour,
    interval,
    sources,
    resource,
    mostrarResource,
    parentContext,
  }) {
    return AgendaData(
        item: item ?? this.item,
        controller: controller ?? this.controller,
        date: date ?? this.date,
        hour: hour ?? this.hour,
        interval: interval ?? this.interval,
        sources: sources ?? this.sources,
        mostrarResource: mostrarResource ?? this.mostrarResource,
        resource: resource ?? this.resource,
        parentContext: parentContext ?? this.resource as BuildContext?);
  }
}

enum AgendaPostEvent { insert, delete, update }
enum AgendaViewerType { horario, semanal, mensal, periodo }

class AgendaViewerRefNotifier with ChangeNotifier {
  AgendaViewerType? viewer = AgendaViewerType.horario;
  notify(AgendaViewerType? value) {
    if ((viewer == null) || ((value != null) && (viewer != value))) {
      viewer = value;
      notifyListeners();
    }
    if (value == null) notifyListeners();
  }
}

class AgendaDataRefNofifier with ChangeNotifier {
  DateTime? data;
  notify(DateTime? value) {
    data = value;
    notifyListeners();
  }
}

class AgendaSourceRefNotifier with ChangeNotifier {
  List<AgendaItem?>? value;
  String hash = '';
  update(List<AgendaItem?>? source) {
    if (source == null) return;
    String h = '';
    source.forEach((item) {
      h += item?.gid?.substring(0, 1) ?? '';
    });
    if (h != hash) {
      hash = h;
      this.value = source;
      notifyListeners();
    }
  }
}

class AgendaItemChanged {
  final AgendaPostEvent event;
  final AgendaItem? item;
  AgendaItemChanged({
    required this.event,
    required this.item,
  });
}

/// notifica o grid que um dado da agenda foi alterado.
/// usado para refreh de grids que dependem da agendaitem
/// DONE: talves seja mais eficiente com Provider
class AgendaItemChangedNotifier extends BlocModel<AgendaItemChanged> {
  static final _singleton = AgendaItemChangedNotifier._create();
  AgendaItemChangedNotifier._create();
  factory AgendaItemChangedNotifier() => _singleton;
}

/// usado para notificar que um item da agenda mudou;
class AgendaItemNotifier extends ChangeNotifier {
  AgendaItem? value;
  AgendaItemNotifier({this.value});
  notify(AgendaItem item) {
    // if (value.gid != item.gid) {
    value = item;
    return notifyListeners();
    // }
    // print('AgendaItem changed:${value.gid} -> ${item.gid} {$item.toJson()}');
  }
}

class AgendaSize {
  double width;
  double height;
  AgendaSize({this.width = 0, this.height = 0});
  withSize(Size size) {
    width = size.width;
    height = size.height;
  }

  widthExpand(double v) => width += v;

  heightExpand(double v) => height += v;
}

class AgendaController extends ChangeNotifier {
  final Future<dynamic>? Function()? future;
  AgendaResources _resources = AgendaResources();
  final AgendaSize size = AgendaSize();
  resourceFind(String? gid) {
    return _resources.find(gid);
  }

  List<AgendaItem?>? sources;
  final Function(AgendaData)? onInsert;
  final Function(AgendaData)? onEdit;
  final Function(AgendaData)? onDelete;
  Function(int)? onSaving;
  //AgendaViewerType viewer = AgendaViewerType.horario;
  DateTime? _data;
  DateTime? get data => _data;

  /// muda a data de referencia da agenda
  set data(DateTime? x) {
    resetData(x);
  }

  int _changed = 0;

  /// suspende notificações para fazer alguma alterção em varios itens
  beginEndReset() {
    _changed = 0;
    //changed(true); /// nao fazer refresh neste ponto, não esta pronto para executar;
  }

  begin([bool b = true]) {
    _changed += (b) ? 1 : -1;
  }

  /// usado para habilitar notificações que foram suspensas com [begin]
  void end() {
    _changed--;
    changed(true);
  }

  final List<dynamic> tipos = [];
  final Function(DefaultSourceList, DateTime, DateTime)? onListDates;

  final Future<dynamic> Function(AgendaItem?, AgendaPostEvent)? onPostItem;
  int defaultDuracaoAgenda = 30; // em minutos
  AgendaController({
    required this.future,
    this.onInsert,
    this.onEdit,
    this.onDelete,
    this.onPostItem,
    this.sources,
    this.onListHour,
    this.onListResource,
    this.onListDates,
    AgendaViewerType? viewer,
    List<AgendaResource>? resources,
  }) {
    if (resources != null) _resources.addAll(resources);
    if (sources == null) this.sources = [];
    viewerNotifier.notify(viewer ?? AgendaViewerType.horario);
  }

  /// notificação quando a data de referencia da agenda foi alterada
  AgendaDataRefNofifier dataNotifier = AgendaDataRefNofifier();

  /// notificação quando houve alteração na lista de items que precisa refazer a view
  AgendaSourceRefNotifier sourceNotifier = AgendaSourceRefNotifier();

  /// notifica quando houve mudança no tipo de agenda
  AgendaViewerRefNotifier viewerNotifier = AgendaViewerRefNotifier();

  @override
  void dispose() {
    dataNotifier.dispose();
    sourceNotifier.dispose();
    viewerNotifier.dispose();
    super.dispose();
  }

  DateTime? _de;
  DateTime? _ate;

  /// primeira data no periodo de dados da agenda
  String get de => (_de ?? data)!.startOfDay().toDateTimeSql();
  set de(d) => _de = d;

  /// ultima data no intervalo da agenda
  String get ate => (_ate ?? data)!.endOfDay().toDateTimeSql();
  set ate(d) => _ate = d;

  /// primeiro dia da semana
  DateTime get startOfWeek => _data!.startOfWeek();

  /// ultimo dia da semana
  DateTime get endOfWeek => _data!.endOfWeek();

  /// lista de recursos (pessoas, salas, meios )
  AgendaResources get resources => _resources;

  double? cardHeigth;
  double? _heigthMinutes;

  /// notifcar alteração global de itens
  notifyChange(item) {
    //subscribeChanges.sink.add(item);
    changed(true);
  }

  Function(DefaultSourceList?, DateTime?, int)? onListHour;

  /// chamadad para relatorio por hora - foi

  // TO DO - remover este item, substiuir pela chamada de periodo
  list(DefaultSourceList? list, int hora) {
    if (onListHour != null) onListHour!(list, data, hora);
  }

  /// relatorio usando periodo [de,ate] e opções [resources]
  Function(DefaultSourceList, DateTime?, DateTime?, String?)? onListResource;
  listResource(DefaultSourceList list, resource) {
    if (onListResource != null) onListResource!(list, _de, _ate, resource);
  }

  /// mudou a data, checa se muda o periodo de dados da agenda
  resetData(DateTime? data) {
    this._data = data ?? DateTime.now();
    switch (viewerNotifier.viewer) {
      case AgendaViewerType.periodo:
        // nao alterar
        break;
      case AgendaViewerType.semanal:
        _de = _data!.startOfWeek().startOfDay();
        _ate = _data!.endOfWeek().endOfDay();
        break;
      case AgendaViewerType.mensal:
        _de = _data!.startOfMonth().startOfDay();
        _ate = _data!.endOfMonth().endOfDay();
        break;
      default:
        _de = _data!.startOfDay();
        _ate = _data!.endOfDay();
    }
    _changed = 0;
  }

  dataChange(data, {AgendaViewerType? viewer}) {
    try {
      begin(true);
      viewerNotifier.notify(viewer);
      resetData(data);
      //print('dataChange $data');
      dataNotifier.notify(_data);
    } finally {
      begin(false);
    }
  }

  viewerChange(AgendaViewerType viewer, {DateTime? data}) {
    try {
      begin(true);
      sources!.clear();
      viewerNotifier.notify(viewer);
      dataChange(_data);
    } finally {
      begin(false);
    }
  }

  /// hora inicial a ser mostrada na timeline da agenda
  double? get startHour => AgendaConfig().nHoraInicio;

  /// hora final a mostrar na timeline
  double? get endHour => AgendaConfig().nHoraFim;

  double calcTop(double? hour) {
    // print(hour);
    if (hour == null || startHour == null) return 0.0;
    double dif = (hour - startHour!);
    if (dif < 0) dif = 0.0;
    var max = endHour! - startHour!;
    if (dif > max) dif = max;
    return (dif * (cardHeigth ?? 10.0)) + kTitleHeight + 2.0;
  }

  /// hora inicial cheia para a timeline
  get iStart => startHour! ~/ 1;

  /// hora final cheia para a timeline
  get iEnd => endHour! ~/ 1;

  /// filtro para o resource
  List<AgendaItem?> sourceWhere(resourceId, date) {
    List<AgendaItem?> r = [];
    sources!.forEach((item) {
      if (item!.resource == resourceId) r.add(item);
    });
    return r;
  }

  int intervalo = 30;
  doSavingEvent(int x) {
    if (onSaving != null) onSaving!(x);
  }

  /// move um item da agenda para outro local
  AgendaItem? moveTo(AgendaItem item, DateTime? start, String? resource,
      {int? interval}) {
    try {
      doSavingEvent(1);
      AgendaItem novo = AgendaItem.fromJson(item.toJson());
      var idx = indexOf(item.id);
      if (idx >= 0) {
        var minutos =
            interval ?? item.datafim!.difference(item.datainicio!).inMinutes;
        if (minutos < 0) minutos = intervalo;
        novo.resource = resource ?? item.resource;
        novo.datainicio = start;
        novo.datafim = novo.datainicio!.add(Duration(minutes: minutos));
        update(novo);

        return novo;
      }
    } catch (e) {
      print('moveTo: $e');
    }
    return null;
  }

  /// adiciona um novo item na agenda
  add(AgendaItem? item) async {
    if (onPostItem != null)
      return onPostItem!(item, AgendaPostEvent.insert).then((it) {
        doSavingEvent(1);
        sources!.add(item);
        try {
          changed(true);
          AgendaItemChangedNotifier().notify(
              AgendaItemChanged(event: AgendaPostEvent.insert, item: item));
        } catch (e) {
          // nada a fazer
        }
        return item;
      });
    return null;
  }

  /// apaga um item da agenda
  delete(AgendaItem item) {
    if (onPostItem != null)
      return onPostItem!(item, AgendaPostEvent.delete).then((it) {
        doSavingEvent(1);
        sources!.remove(item);
        changed(true);
        AgendaItemChangedNotifier().notify(
            AgendaItemChanged(event: AgendaPostEvent.delete, item: item));
        return item;
      });
    return null;
  }

  /// altera um item da agenda - preexistente
  update(AgendaItem? item, {bool forceReload = false}) async {
    if (onPostItem != null)
      return onPostItem!(item, AgendaPostEvent.update).then((it) {
        doSavingEvent(1);
        var idx = indexOf(item!.gid);
        AgendaItem oldItem = sources![idx]!.clone();

        if (idx >= 0) sources!.removeAt(idx);
        //print('Remove: $idx, Resource ${item.resource}:');
        sources!.add(item.validateValues());
        if (forceReload ||
            oldItem.datainicio!.dateChanged(item.datainicio!) ||
            oldItem.datafim!.dateChanged(item.datafim!) ||
            (oldItem.sigcadCodigo!.compareTo(item.sigcadCodigo!) != 0) ||
            (oldItem.recursoGid != item.recursoGid))
          viewerNotifier.notifyListeners();
        else {
          changed(true);
          AgendaItemChangedNotifier().notify(
              AgendaItemChanged(event: AgendaPostEvent.update, item: item));
        }
        return item;
      });
    return null;
  }

  int iCount = 0;

  /// verifica se agenda esta ativa para notificar mudanças globais
  void changed(bool b) {
    if (_changed <= 0) {
      _changed = 0;
      sourceNotifier.update(sources);
    }
  }

  /// procura na liste um item pelo ID do item
  indexOf(String? id) {
    for (var i = 0; i < sources!.length; i++) {
      if (sources![i]!.id == id) return i;
    }
    return -1;
  }

  /// calcula a altura do card para mostrar na agenda - mais horas -> mais alto
  calcHeigth(DateTime? dataRef, DateTime open, DateTime close) {
    if (_heigthMinutes == null) {
      double de = calcTop(startHour!);
      double ate = calcTop(startHour! + 1);
      _heigthMinutes = (ate - de) / 60;
    }
    dataRef ??= open;

    // ajusta quando cai fora da area de validade da arena
    var _close = close;
    if (_close.isAfter(dataRef.hourChanges(endHour! ~/ 1)))
      _close = dataRef.hourChanges(endHour! ~/ 1);
    var _open = open;
    if (open.isBefore(dataRef)) {
      _open = close.hourChanges(startHour! ~/ 1);
    }

    var m = _close.difference(_open).inMinutes;
    if (m < 20) m = 20;
    var h = m * _heigthMinutes!;
    if (h < 20) h = 20;

    //if (h > 200) h = 200;
    return h;
  }
}

var ultimoContext;

class DefaultAgenda extends InheritedWidget {
  final AgendaController? controller;
  final DateTime? data;

  DefaultAgenda({Key? key, this.data, required Widget child, this.controller})
      : super(key: key, child: child);
  @override
  bool updateShouldNotify(DefaultAgenda oldWidget) {
    return oldWidget.controller!.data != controller!.data ||
        oldWidget.data != data;
  }

  static setContext(BuildContext context) => ultimoContext = context;
  static DefaultAgenda? of(BuildContext context) {
    var rsp = context.dependOnInheritedWidgetOfExactType<DefaultAgenda>();
    if (rsp != null) ultimoContext = context;
    if (rsp == null && ultimoContext != null)
      rsp = ultimoContext.dependOnInheritedWidgetOfExactType<DefaultAgenda>();
    return rsp;
  }

  get cardHeigth => controller!.cardHeigth;
  set cardHeight(x) => controller!.cardHeigth = x;
  get resources => controller!.resources;
  get sources => controller!.sources;
  notifyChange(item) => controller!.notifyChange(item);

  reaload(DateTime data) {
    //print(data);
    controller!.data = data;
  }
}

extension DateTimeChanges on DateTime {
  hourChanges(int hour) {
    return DateTime(
        this.year, this.month, this.day, hour, this.minute, this.second);
  }

  changed(DateTime other) {
    return this.toLocal() != other.toLocal();
  }

  dateChanged(DateTime other) {
    var a = this.format('y/MM/dd');
    var b = other.format('y/MM/dd');
    return a != b;
  }
}

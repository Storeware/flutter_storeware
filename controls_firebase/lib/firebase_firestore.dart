import 'dart:async';
import 'dart:convert';
import 'package:firebase_web/firebase.dart';
import 'package:firebase_web/firestore.dart' as fs;
import 'package:uuid/uuid.dart';
import 'firebase_config.dart';
import 'firebase_data_model.dart';
import 'package:controls_data/data_model.dart';

String dbfirestoreSuffix;

class FirebaseApp {
  fs.Firestore store;
  init() {
    var _carregar = (store == null);
    if (_carregar)
      try {
        if (AssetsConfig().config == null) {
          _carregar = true;
          AssetsConfig().load();
        }
        if (_carregar) {
          try {
            //debug('firebase_loading()');
            firebase_loading();
            debug('inializing FirestroeApp');
            initializeApp(
                apiKey: AssetsConfig.apiKey,
                authDomain: AssetsConfig.authDomain,
                databaseURL: AssetsConfig.databaseURL,
                storageBucket: AssetsConfig.storageBucket,
                projectId: AssetsConfig.projectId,
                messagingSenderId: AssetsConfig.messagingSenderId);
            debug('initlizeApp Ok');
          } on FirebaseJsNotLoadedException catch (e) {
            error("Erro ao configurar apiKey: ${AssetsConfig.apiKey}");
            error(e);
          }
        }
      } finally {
        print('Firestore: OK');
        store = firestore();
      }
  }

  static Storage get storageApp => storage();
}

class FirestoreApp extends FirebaseApp {
  static final _instance = FirestoreApp._create();
  final Uuid uuid = Uuid();

  static get userLogged => bdUserLogged;
  static set userLogged(x) {
    bdUserLogged = x;
  }

  static get firestoreSuffix {
    if (dbfirestoreSuffix == null) {
      var _params = Uri.base.queryParameters;
      dbfirestoreSuffix = _params['q'] ?? '';
    }
    return dbfirestoreSuffix;
  }

  static set firestoreSuffix(x) {
    dbfirestoreSuffix = x;
  }

  FirestoreApp._create() {
    try {
      init();
    } catch (e) {
      error('firebase_firestore._create $e');
    }
  }
  factory FirestoreApp() {
    return _instance;
  }

  _newId() {
    return uuid.v1();
  }

  fs.Firestore get instance => firestore(); //_instance.store;
  fs.CollectionReference collection(String collectionPath) {
    try {
      return firestore().collection(collectionPath);
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> enviar(String table, String id, DataModelItem data,
      {String conta, Map<String, dynamic> map}) async {
    var r;
    switch (data.state) {
      case DataState.dsEdit:
        {
          var doc = firestore().collection(table);
          if (data.id == null) data.id = _newId();
          Map<String, dynamic> values = map ?? data.toJson();
          values.remove('id'); // é um controle interno do banco, não dos dados
          values['dtatualiz'] = DateTime.now();
          values['userLogged'] = bdUserLogged;
          r = doc.doc(data.id).set(values, fs.SetOptions(merge: true));
          break;
        }
      case DataState.dsInsert:
        {
          var doc = firestore().collection(table);
          if (data.id == null) data.id = _newId();
          Map<String, dynamic> values = data.toJson();
          values.remove('id'); // é um controle interno do banco, não dos dados
          values['dtatualiz'] = DateTime.now();
          values['userLogged'] = bdUserLogged;
          doc.doc(data.id).set(values, fs.SetOptions(merge: true));
          break;
        }
      case DataState.dsDelete:
        {
          firestore().collection(table).doc(id).delete();
          break;
        }
    }
    return r;
  }

  static String formatCollection(nome) {
    String r = 'lojas/${FirestoreApp.firestoreSuffix}/$nome';
    debug('formatCollection-> $r');
    return r;
  }
}

abstract class FirestoreModelClass<T extends DataModelItem>
    extends DataModelClass<T> {
  fs.DocumentSnapshot lastDocument;
  fs.DocumentSnapshot firstDocument;
  String collectionName;
  @override
  Stream<fs.QuerySnapshot> snapshots({bool inativo}) {
    var r = FirestoreApp()
        .collection(collectionName)
        .where('inativo', '==', inativo ?? false)
        .get();
    r.then((d) {
      if (d != null) {
        firstDocument = d.docs.first;
        lastDocument = d.docs.last;
      }
    });
    return r.asStream();
  }

  /// avaliando
  Stream<fs.QuerySnapshot> limit({String orderBy, int limit, bool inativo}) {
    var r = FirestoreApp()
        .collection(collectionName)
        .where('inativo', '==', inativo ?? false)
        .orderBy(orderBy)
        .limit(limit)
        .get();
    r.then((d) {
      print('Resposta: $d');
      if (d != null) {
        firstDocument = d.docs.first;
        lastDocument = d.docs.last;
      }
    });
    return r.asStream();
  }

  /// avaliando
  Stream<fs.QuerySnapshot> startAfter(
      {String orderBy, int limit, bool inativo}) {
    var r = FirestoreApp()
        .collection(collectionName)
        .where('inativo', '==', inativo ?? false)
        .orderBy(orderBy)
        .limit(limit)
        .startAfter(snapshot: lastDocument)
        .get();
    r.then((d) {
      if (d != null) {
        firstDocument = d.docs.first;
        lastDocument = d.docs.last;
      }
    });
    return r.asStream();
  }

  Stream<fs.QuerySnapshot> endAt({String orderBy, int limit, bool inativo}) {
    var r = FirestoreApp()
        .collection(collectionName)
        .where('inativo', '==', inativo ?? false)
        .orderBy(orderBy)
        .limit(limit)
        .endAt(snapshot: firstDocument)
        .get();
    r.then((d) {
      if (d != null) {
        firstDocument = d.docs.first;
        lastDocument = d.docs.last;
      }
    });
    return r.asStream();
  }

  fs.CollectionReference getRef() {
    return FirestoreApp().collection(collectionName);
  }

  Stream<fs.QuerySnapshot> getAll() {
    var r = FirestoreApp().collection(collectionName).get();
    r.then((d) {
      if (d != null) {
        firstDocument = d.docs.first;
        lastDocument = d.docs.last;
      }
    });
    return r.asStream();
  }

  @override
  getById(id) {
    return FirestoreApp().collection(collectionName).doc(id).get();
  }

  @override
  enviar(T data, {Map<String, dynamic> map}) async {
    return FirestoreApp().enviar(collectionName, data.id, data, map: map);
  }

  delete(String id) {
    return FirestoreApp().collection(collectionName).doc(id).delete();
  }

  T createItem();

  List<DocumentGroupItem> getCountBy(
      List<fs.DocumentSnapshot> docs, String name) {
    return DocumentGroupped(docs).count(name);
  }
}

class DocumentGroupItem {
  String name;
  double value = 0;
  toJson() {
    return {'name': name, 'value': value};
  }

  fromMap(data) {
    name = data['name'];
    value = data['value'];
  }
}

class DocumentGroupped {
  List<DocumentGroupItem> items = [];
  final List<fs.DocumentSnapshot> docs;
  DocumentGroupped(this.docs);

  List<DocumentGroupItem> count(column) {
    for (var i = 0; i < docs.length; i++) {
      var item = docs[i].data();
      var s = item[column];
      if (s == null) s = 'nc';
      tryAddOrSum(s, 1);
    }
    return items;
  }

  DocumentGroupItem tryAddOrSum(column, n) {
    var i = indexOf(column);
    if (i < 0) {
      var it = DocumentGroupItem();
      it.name = column;
      it.value = n;
      items.add(it);
      return it;
    }
    var it = items[i];
    it.value += n;
    return it;
  }

  int indexOf(column) {
    for (var i = 0; i < items.length; i++) {
      if (items[i].name == column) return i;
    }
    return -1;
  }
}

class DocumentItem {
  String id;
  Map<String, dynamic> _data;
  static fromJson(dados) {
    return DocumentItem().fromMap(dados);
  }

  data() => _data;
  Map<String, dynamic> toJson() {
    return {"id": id, ..._data};
  }

  fromDoc(fs.DocumentSnapshot doc) {
    debug('firebase_firestore->fromDoc ${doc.id}');
    _data = doc.data();
    id = doc.id;
    return this;
  }

  fromMap(values) {
    id = values['id'];
    _data = values;
    return this;
  }

  encode() {
    return jsonEncode({"id": id, ..._data});
  }

  decode(String json) {
    return fromMap(jsonDecode(json));
  }
}

class BlocData<T> {
  StreamController _controller = StreamController<T>.broadcast();
  get stream => _controller.stream;
  get sink => _controller.sink;
  notify(T data) {
    sink.add(data);
  }

  notifyChild() {}
  close() {
    _controller.close();
  }
}

class ListDocuments {
  List<DocumentItem> _docs = [];
  addDoc(DocumentItem doc) => _docs.add(doc);
  get length => _docs.length;
  clear() => _docs.clear();
  List<DocumentItem> data() => _docs;
  List<DocumentItem> get docs => _docs;
  int indexOf(String id) {
    for (var i = 0; i < _docs.length; i++) if (_docs[i].id == id) return i;
    return -1;
  }
}

class BlocDataFirestore extends BlocData<ListDocuments> {
  ListDocuments items = ListDocuments();
  int _inProc = 0;
  begin() {
    _inProc += 1;
  }

  end() {
    _inProc += -1;
    send();
  }

  get length {
    return items.length;
  }

  addDocs(List<fs.DocumentSnapshot> docs) {
    begin();
    clear();
    for (var i = 0; i < docs.length; i++) {
      addDoc(docs[i]);
    }
    end();
    send();
  }

  addDocsReverse(List<fs.DocumentSnapshot> docs) {
    begin();
    clear();
    for (var i = docs.length - 1; i > 0; i--) {
      addDoc(docs[i]);
    }
    end();
    send();
  }

  tryAddDocs(List<fs.DocumentSnapshot> docs) {
    begin();
    for (var i = 0; i < docs.length; i++) {
      tryAddDoc(docs[i]);
    }
    end();
    send();
  }

  tryInsertDocs(int index, List<fs.DocumentSnapshot> docs) {
    begin();
    for (var i = docs.length - 1; i >= 0; i--) {
      tryInsertDoc(index, docs[i]);
    }
    end();
    send();
  }

  clear() {
    items.clear();
    notify(null);
  }

  DocumentItem addDoc(fs.DocumentSnapshot doc) {
    var r = DocumentItem().fromDoc(doc);
    items.addDoc(r);
    send();
    return r;
  }

  DocumentItem insertDoc(int index, fs.DocumentSnapshot doc) {
    var r = DocumentItem().fromDoc(doc);
    items.docs.insert(index, r);
    send();
    return r;
  }

  DocumentItem tryInsertDoc(int index, fs.DocumentSnapshot doc) {
    var idx = items.indexOf(doc.id);
    if (idx >= 0) return items.docs[idx];
    var r = DocumentItem().fromDoc(doc);
    items.docs.insert(index, r);
    send();
    return r;
  }

  DocumentItem tryAddDoc(fs.DocumentSnapshot doc) {
    var idx = items.indexOf(doc.id);
    if (idx >= 0) return items.docs[idx];
    return addDoc(doc);
  }

  send() {
    //print(['inProc',_inProc]);
    if (_inProc <= 0) {
      notify(items);
      notifyChild();
    }
  }
}

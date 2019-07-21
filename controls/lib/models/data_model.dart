import 'dart:async';
import 'dart:convert';
import 'dart:core';
import '../bloc/firestore_bloc.dart';
import '../bloc/rxdart_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../bloc/firebase_model.dart';

typedef bool AsyncFilterCallback<T>(T doc);
typedef int SorterCompareCallback<T>(T a, T b);

class DocsSnap {
  String documentID;
  Map<String, dynamic> data;
  DocsSnap(this.documentID, this.data);
  dynamic operator [](String key) => data[key];
}

/*
class ListDocumentSnapshot {
  List<DocumentSnapshot> documents = [];
  add(DocumentSnapshot doc) {
    documents.add(doc); //new DocsSnap( doc.documentID, doc.data) ) ;
  }

  addList(ListDocumentSnapshot list, AsyncFilterCallback<DocumentSnapshot> fn) {
    list.documents.forEach((f) {
      if (fn(f)) add(f);
    });
  }

  int get length {
    return documents.length;
  }

  get data {
    return this;
  }

  clear() {
    documents.clear();
  }

  static ListDocumentSnapshot from(QuerySnapshot rsp) {
    ListDocumentSnapshot r = ListDocumentSnapshot();
    r.fromSnapshots(rsp);
    return r;
  }

  ListDocumentSnapshot fromSnapshots(QuerySnapshot rsp) {
    rsp.documents.forEach((f) {
      add(f);
    });
    return this;
  }
}
*/

/*
class ObjectModel {
  String documentID;
  String toJson() {
    return DataModel.jsonEncode(this);
  }
}
*/

class DataModel {
  static String jsonEncode(dynamic object) {
    const jsonCodec = JsonCodec();
    return jsonCodec.encode(object, toEncodable: (x) {
      if (x is DateTime)
        return x.toIso8601String();
      else
        return x;
    });
  }

  static dynamic jsonDecode(String json) {
    const jsonCodec = JsonCodec();
    return jsonCodec.decode(json, reviver: (k, v) {
      if (v is String && v.length > 13) if (v.substring(10, 10) == 'T' &&
          v.substring(13, 13) == ':') {
        //yyyy-mm-ddThh:mm:nn
        DateTime d = DateTime.tryParse(v);
        if (d != null)
          return d;
        else
          return v;
      }
      return v;
    });
  }

  static String uriEncode(String motivo) {
    return Uri.encodeFull(motivo);
  }

  static String uriDecode(String motivo) {
    return Uri.decodeFull(motivo);
  }

  Firestore get firestore {
    return FirebaseModel.firestore();
  }

  String tableName;

  Future<Map<String, dynamic>> proximoNumero(String nomeSeq) async {
    DocumentReference doc =
        Firestore.instance.collection('ctrl_id').document(nomeSeq);
    int conta = 0;
    Map<String, dynamic> v;
    return /*await*/ Firestore.instance.runTransaction((trans) async {
      return trans.get(doc).then((DocumentSnapshot d) {
        if (conta == 0) {
          v = {
            "dtatualiz": DateTime.now(),
            "valor":
                (d.exists ? double.parse(d.data['valor'].toString()) + 1 : 1)
          };
          conta--;
          if (d.exists)
            return trans.update(doc, v).then((x) {
              return v;
            });
          else {
            v['nome'] = nomeSeq;
            return trans.set(doc, v).then((x) {
              return v;
            });
          }
        }
        return null;
      });
    });
  }

  /*
   sample:
     _categoriasClass.listAll(),
   */
  Stream<QuerySnapshot> listAll([String tabela]) {
    if (tabela == null) {
      tabela = this.tableName;
    }
    var docs = firestore.collection(tabela);
    var ref = this.beforeOpen(docs);
    return (ref != null ? ref.snapshots() : null);
  }

  Future<QuerySnapshot> listAsync([String tabela]) async {
    if (tabela == null) {
      tabela = this.tableName;
    }
    var docs = firestore.collection(tabela);
    var ref = this.beforeOpen(docs);
    return await ref.getDocuments();
  }

  ListDocumentSnapshot filter(
      QuerySnapshot qrySnaps, AsyncFilterCallback<DocumentSnapshot> fnFilter) {
    ListDocumentSnapshot rt = new ListDocumentSnapshot();
    qrySnaps.documents.forEach((doc) {
      if (fnFilter(doc)) {
        rt.addDocument(doc);
      }
    });
    return rt;
  }

  Future<ListDocumentSnapshot> sorter(ListDocumentSnapshot doc,
      SorterCompareCallback<FirestoreDocumentSnapshot> sorter) async {
    doc.documents.sort((a, b) {
      return sorter(a, b);
    });
    return doc;
  }

  Stream<QuerySnapshot> snapshot(Function where, Function pComplete) {
    StreamController<QuerySnapshot> controller =
        StreamController<QuerySnapshot>.broadcast();
    var docs = firestore.collection(tableName);
    Query ref;
    if (where != null) {
      ref = where(docs);
    } else
      ref = docs;
    ref.getDocuments().then((QuerySnapshot d) {
      if (pComplete != null) {
        pComplete(d);
      }
      //print(d.documents);
      controller.add(d);
    });
    return controller.stream;
  }

/*
  Sample:
  _fornecedoresClass.listOne(codigo.toString()).then( ( DocumentSnapshot onValue){
  //print('Forn: '+onValue['nome']);
  });
*/
  Future<DocumentSnapshot> listOne(String id) async {
    DocumentReference coll = firestore.collection(tableName).document(id);
    return await coll.get().then((d) {
      //print('DoucmentSnapshot: '+id+' : '+d.documentID);
      //print( x.data.toString()  );
      //DocumentSnapshot x = d;
      return d;
    });
  }

  // para override;
  /*
    sample:
       return ref.where('inativo',isEqualTo:false);
   */
  beforeOpen(ref) {
    return ref;
  }

  DataModel() {
    inited();
  }

  void inited() {
    // para herdar
  }

  Future<void> insert(Map<String, dynamic> data,email) {
    data['dtatualiz'] = new DateTime.now();
    data['usuario'] = email;
    return Firestore.instance.collection(tableName).reference().add(data);
  }

  String createId() {
    String key = Firestore.instance.collection(tableName).document().documentID;
    return key;
  }

  Future<void> updateOrInsert(String id, Map<String, dynamic> data) {
    data['dtatualiz'] = new DateTime.now();
    return Firestore.instance
        .collection(tableName)
        .document(id)
        .setData(data, merge: true);
  }

  /*
      Post(data);
   */
  Future<void> post(Map<String, dynamic> data,email) {
    String id;
    try {
      if (data['id'] != null) {
        id = data["id"];
        data.remove("id");
      }
      if (id == null) {
        return this.insert(data,email);
      } else {
        return this.updateOrInsert(id, data);
      }
    } catch (e) {
      return null;
    }
  }
}

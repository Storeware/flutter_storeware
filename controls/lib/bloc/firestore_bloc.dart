import 'dart:async';

import 'rxdart_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';


class QueryDocuments<T> {
  List<T> _documents = [];
  List<T> get documents => _documents;
  List<T> get data => _documents;
  int get length => _documents.length;
  T operator [](int index) => _documents[index];
  bool get hasData => _documents.length > 0;
  add(T item) {
    return _documents.add(item);
  }
}

class FirestoreDocumentSnapshot {
  Map<String, dynamic> data;
  String documentID;
  String tag;
  dynamic operator [](String name) => data[name];
  FirestoreDocumentSnapshot({this.documentID, this.data, this.tag});
  static from(DocumentSnapshot item) {
    return FirestoreDocumentSnapshot(
        documentID: item.documentID, data: item.data);
  }
}

class FirestoreDocuments extends QueryDocuments<FirestoreDocumentSnapshot> {
  changeItem(index, FirestoreDocumentSnapshot item) => documents[index] = item;
  void add(FirestoreDocumentSnapshot item) => documents.add(item);
  int addIfNotExists(FirestoreDocumentSnapshot item) {
    var i = indexOf(item.documentID);
    if (i < 0) add(item);
    return i;
  }

  clear() {
    documents.clear();
  }

  deleteIfExists(documentID) {
    var i = indexOf(documentID);
    if (i >= 0) return documents.removeAt(i);
  }

  int indexOf(documentID) {
    for (var i = 0; i < documents.length; i++) {
      if (documents[i].documentID == documentID) return i;
    }
    return -1;
  }

  int indexOfTag(tag) {
    for (var i = 0; i < documents.length; i++) {
      if (documents[i].tag == tag) return i;
    }
    return -1;
  }

  void addDocument(DocumentSnapshot doc) {
    return add(FirestoreDocumentSnapshot.from(doc));
  }
}

class FirestoreBloc {
  bool inUpdating = false;

  final FirestoreDocuments list = FirestoreDocuments();
  final _subject = BehaviorSubject<FirestoreDocuments>();
  get subject => _subject;

  get stream => _subject.stream;
  get sink => _subject.sink;
  get documents => list;

  addDocument(String id, DocumentSnapshot item,
      [int _groupId = -1, sinking = true]) {
    int i = list.indexOf(item.documentID);
    if (i >= 0)
      list.changeItem(i, FirestoreDocumentSnapshot.from(item));
    else
      list.add(FirestoreDocumentSnapshot.from(item));
    if (sinking && !inUpdating) subject.sink.add(list);
    return this;
  }

  indexOfDocument(String documentID) {
    return list.indexOf(documentID);
  }

  changeItem(index, DocumentSnapshot item) {
    list.changeItem(index, FirestoreDocumentSnapshot.from(item));
    return this;
  }

  addOrUpdateDocument(String id, DocumentSnapshot item,
      [int _groupId = -1, sinking = true]) {
    var i = indexOfDocument(id);
    if (i >= 0)
      changeItem(i, item);
    else
      addDocument(id, item, _groupId, sinking);
    return this;
  }

  addDocuments(QuerySnapshot docs) {
    docs.documents.forEach((f) {
      addDocument(f.documentID, f);
    });
    update();
    return this;
  }

  documentChanges(List<DocumentChange> docs, [beforeEvent]) {
    startUpdate();
    docs.forEach((f) {
      if (f.type == DocumentChangeType.removed)
        removeDocument(f.document.documentID);
      else {
        addOrUpdateDocument(f.document.documentID, f.document, -1, false);
      }
    });
    endUpdate(beforeEvent);
    return this;
  }

  attachStream(Stream<QuerySnapshot> query, [beforeEvent]) {
    query.listen((onData) {
      //print(['Docs:', onData.documents.length]);
      documentChanges(onData.documentChanges, beforeEvent);
      //addDocuments(onData);
    });
    return this;
  }

  removeDocument(String id, [sinking = true]) {
    var i = indexOfDocument(id);
    if (i >= 0) removeAt(i, sinking);
    return this;
  }

  removeAt(int index, [sinking = true]) {
    list.documents.removeAt(index);
    if (sinking && !inUpdating) sink.add(list);
    return this;
  }

  void close() {
    // print('close bloc');
    _subject.close();
  }

  startUpdate() {
    inUpdating = true;
    return this;
  }

  endUpdate([beforeEvent]) {
    if (beforeEvent != null) beforeEvent(list);
    inUpdating = false;
    update();
    return this;
  }

  update() {
    sink.add(list);
    //print(list.length);
    return this;
  }

  clear() {
    list.clear();
    update();
  }
}

class FirestoreProvider extends FirestoreBuilder<FirestoreBloc> {
  FirestoreProvider(
      {Key key,
      @required FirestoreBloc bloc,
      @required AsyncWidgetBuilder<FirestoreDocuments> builder,
      bool autoClose = false})
      : super(key: key, bloc: bloc, builder: builder, autoClose: autoClose);
}

class FirestoreBuilder<T extends FirestoreBloc> extends StatefulWidget {
  final T bloc;
  final AsyncWidgetBuilder<FirestoreDocuments> builder;
  final bool autoClose;
  FirestoreBuilder(
      {Key key,
      @required this.bloc,
      @required this.builder,
      this.autoClose = true})
      : super(key: key);
  _SnapshotBuilderState createState() => _SnapshotBuilderState();
}

class _SnapshotBuilderState extends State<FirestoreBuilder> {
  @override
  void dispose() {
    super.dispose();
    if (widget.autoClose) widget.bloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FirestoreDocuments>(
        stream: widget.bloc.stream,
        builder: (context, snapshot) {
          return widget.builder(context, snapshot);
        });
  }
}

class ListDocumentSnapshot extends FirestoreDocuments {}

class QueryWidgets extends QueryDocuments<WidgetDocument> {}

class WidgetBuilderBloc extends BehaviorSubjectBloc<QueryWidgets> {
  var q = QueryWidgets();
  int get length => q.length;
  addWidgets(List<Widget> children, [int tag]) {
    children.forEach((f) {
      q.add(WidgetDocument(f, tag));
    });
    add(q);
    return this;
  }

  addItem(Widget item, int tag) {
    q.add(WidgetDocument(item, tag));
    add(q);
    return this;
  }

  removeGroup(int tag) {
    for (var i = length - 1; i > 0; i--) {
      if (q.data[i].tag == tag) q.data.removeAt(i);
    }
  }
}

typedef WidgetBuilderType<T>(context, QueryWidgets snapshot);

class WidgetBuilderProvider extends StatefulWidget {
  final List<Widget> children;
  final AsyncWidgetBuilder<QueryWidgets> builder;
  final WidgetBuilderBloc bloc;
  final bool autoClose;
  WidgetBuilderProvider(
      {this.children,
      @required this.bloc,
      @required this.builder,
      this.autoClose = false}) {
    if (this.children != null) bloc.addWidgets(children);
  }
  _WidgetBuilderState createState() => _WidgetBuilderState();
}

class _WidgetBuilderState extends State<WidgetBuilderProvider> {
  @override
  void dispose() {
    if (widget.autoClose) widget.bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QueryWidgets>(
        stream: widget.bloc.stream,
        builder: (context, snaps) {
          return widget.builder(context, snaps);
        });
  }
}



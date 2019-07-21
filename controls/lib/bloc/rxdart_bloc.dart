import 'dart:async';
import 'dart:convert';

//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class ObjectModel {
  String documentID;
  toJson() {
    return jsonEncode(this, toEncodable: (x) {
      if (x is DateTime)
        return x.toIso8601String();
      else
        return x;
    });
  }
}

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

class SingularityBloc<T> {
  final List<Function(T)> _eventos = [];
  final T initialState;
  bool inUpdating = false;
  T lastValue;
  final Subject<T> _subject;
  Stream<T> get stream => _subject.stream;

  SingularityBloc(this._subject, {this.initialState}) {
    stream.listen((onData) {
      for (var item in _eventos) {
        try {
          item(onData);
        } catch (e) {
          //
        }
      }
    });
  }

  add(T value) {
    _subject.sink.add(value);
  }

  void subscribe(onEvent) {
    _eventos.add(onEvent);
  }

  void unSubscribe(onEvent) {
    _eventos.remove(onEvent);
  }

  void close() {
    print('close SingularityBloc');
    _subject.close();
  }

  notify([T value]) {
    if (value == null || value != lastValue) {
      _subject.sink.add(value);
      lastValue = value;
    }
  }

  startUpdate() {
    inUpdating = true;
    return this;
  }

  endUpdate() {
    inUpdating = false;
    return this;
  }

  addChildren(List<T> children) {
    children.forEach((f) {
      add(f);
    });
  }
}

class BehaviorSubjectBloc<T> extends SingularityBloc<T> {
  BehaviorSubjectBloc({T initialState})
      : super(BehaviorSubject<T>(), initialState: initialState);
}

class ReplaySubjectBloc<T> extends SingularityBloc<T> {
  ReplaySubjectBloc({T initialState})
      : super(ReplaySubject<T>(), initialState: initialState);
}

class PublishSubjectBloc<T> extends SingularityBloc<T> {
  PublishSubjectBloc({T initialState})
      : super(PublishSubject<T>(), initialState: initialState);
}

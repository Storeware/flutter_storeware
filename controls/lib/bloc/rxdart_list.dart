
import 'dart:async';

import 'package:rxdart/rxdart.dart';

class BehaviorListBloc<T> {
  final List<T> _list = [];
  bool _inUpdating = false;
  final BehaviorSubject<List<T>> _subject = BehaviorSubject<List<T>>();
  Stream get stream => _subject.stream;
  StreamSink get sink => _subject.sink;
  List<T> get list => _list;

  add(T item) {
    _list.add(item);
    if (!_inUpdating) notify();
    return;
  }

  void close() {
    _subject.close();
  }

  clear() {
    _list.clear();
    if (!_inUpdating) notify();
  }

  notify() {
    _subject.sink.add(_list);
  }

  startUpdate() {
    _inUpdating = true;
  }

  endUpdate([bool reflesh=true]) {
    _inUpdating = false;
    if (reflesh) notify();
  }
}

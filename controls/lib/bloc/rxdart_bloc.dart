import 'dart:async';
import 'dart:convert';
import 'package:flutter/widgets.dart';
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

class SubjectBloc<T> {
  final List<Function(T)> _eventos = [];
  final T initialState;
  final Subject<T> _subject;
  Stream<T> get stream => _subject.stream;

  SubjectBloc(this._subject, {this.initialState}) {
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

  bool inUpdating = false;
  T lastValue;

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

class BehaviorSubjectBloc<T> extends SubjectBloc<T> {
  BehaviorSubjectBloc({T initialState})
      : super(BehaviorSubject<T>(), initialState: initialState);
}

class ReplaySubjectBloc<T> extends SubjectBloc<T> {
  ReplaySubjectBloc({T initialState})
      : super(ReplaySubject<T>(), initialState: initialState);
}

class PublishSubjectBloc<T> extends SubjectBloc<T> {
  PublishSubjectBloc({T initialState})
      : super(PublishSubject<T>(), initialState: initialState);
}



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



class NotifyChangesBloc extends BehaviorSubjectBloc<int> {}

class BehaviorNotifyProvider<T> extends StatefulWidget {
  final BehaviorSubjectBloc<T> bloc;
  final AsyncWidgetBuilder<T> builder;
  final bool autoClose;
  BehaviorNotifyProvider(
      {@required this.bloc, @required this.builder, this.autoClose = true});
  _BehaviorNotifyProviderState createState() =>
      _BehaviorNotifyProviderState<T>();
}

class _BehaviorNotifyProviderState<T> extends State<BehaviorNotifyProvider<T>> {
  @override
  void dispose() {
    if (widget.autoClose) widget.bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: widget.bloc.stream,
      builder: widget.builder,
    );
  }
}

class RefleshBloc<T> extends BehaviorSubjectBloc<T> {
  RefleshBloc({T initialState}) : super(initialState: initialState);
}

class RefleshBuilder<T> extends StatelessProvider<T> {
  const RefleshBuilder({Key key, @required bloc, @required builder})
      : assert(bloc != null),
        assert(builder != null),
        super(key: key, bloc: bloc, builder: builder);
}


class WidgetDocument {
  Widget data;
  int tag;
  WidgetDocument(this.data, this.tag);
}



class BehaviorBuilderBloc<T> extends BehaviorSubjectBloc<T> {}

Type _typeOf<T>() => T;

class StatelessProvider<T> extends StatelessWidget {
  final BehaviorSubjectBloc<T> bloc;
  final AsyncWidgetBuilder<T> builder;

  const StatelessProvider(
      {Key key, @required this.bloc, @required this.builder})
      : assert(bloc != null),
        assert(builder != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      initialData: bloc.initialState,
      stream: bloc.stream,
      builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
        return builder(context, snapshot);
      },
    );
  }
}

class StatefulProvider<T> extends StatefulWidget {
  final BehaviorSubjectBloc<T> bloc;
  final AsyncWidgetBuilder<T> builder;
  final bool autoClose;
  //final BehaviorSubjectBloc<T> Function(BehaviorSubjectBloc<T>) blocBuilder;
  final void Function(BuildContext context, BehaviorSubjectBloc<T> value)
      onDispose;

  StatefulProvider(
      {Key key,
      @required this.bloc,
      @required this.builder,
      //this.blocBuilder,
      this.onDispose,
      this.autoClose = true})
      : assert(bloc != null),
        assert(builder != null),
        super(key: key);

  _StatefulProviderState<T> createState() => _StatefulProviderState<T>();
}

class _StatefulProviderState<T> extends State<StatefulProvider> {
  @override
  void dispose() {
    if (widget.onDispose != null) widget.onDispose(context, widget.bloc);
    if (widget.autoClose) widget.bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      initialData: widget.bloc.initialState,
      stream: widget.bloc.stream,
      builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
        return widget.builder(context, snapshot);
      },
    );
  }
}

class BehaviorProvider<T> extends InheritedWidget {
  /// The Bloc which is to be made available throughout the subtree
  final BehaviorSubjectBloc<T> bloc;
  BehaviorProvider({
    Key key,
    @required this.bloc,
    @required Widget child,
  })  : assert(bloc != null),
        super(
          key: key,
          child: child,
        );
  @override
  bool updateShouldNotify(BehaviorProvider<T> oldWidget) =>
      oldWidget.bloc != bloc;

  static BehaviorSubjectBloc<T> of<T>(BuildContext context) {
    // this is required to get generic Type
    final type = _typeOf<BehaviorProvider<T>>();
    final BehaviorProvider<T> provider =
        context.inheritFromWidgetOfExactType(type);
    return provider?.bloc;
  }
}

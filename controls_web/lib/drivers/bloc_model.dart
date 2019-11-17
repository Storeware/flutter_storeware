import 'dart:async';
import 'package:flutter/material.dart';

class BlocModel<T> {
  final _stream = StreamController<T>.broadcast();
  get stream => _stream.stream;
  get sink => _stream.sink;
  notify(T value) {
    sink.add(value);
  }

  close() {
    _stream.close();
  }
}

class BlocNotifier<T> extends StatelessWidget {
  final Function(AsyncSnapshot<T>) builder;
  final BlocModel<dynamic> bloc;
  final T initialData;
  const BlocNotifier({Key key, this.bloc, this.builder, this.initialData})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.stream,
      initialData: initialData,
      builder: (x, y) {
        return builder(y);
      },
    );
  }
}

class StreamNotifier<T> extends StatelessWidget {
  final BlocModel<T> bloc;
  final AsyncWidgetBuilder<T> builder;
  final T initialData;
  const StreamNotifier({Key key, this.bloc, this.builder, this.initialData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.stream,
      builder: builder,
      initialData: initialData,
    );
  }
}

class RebuilderBloc extends BlocModel<dynamic> {
  static final _singleton = RebuilderBloc._create();
  RebuilderBloc._create();
  factory RebuilderBloc() => _singleton;
}

class RebuildNotify extends StatelessWidget {
  final Function(AsyncSnapshot<dynamic>) builder;
  final BlocModel<dynamic> bloc;
  const RebuildNotify({Key key, @required this.builder, this.bloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocNotifier<dynamic>(
      bloc: bloc ?? RebuilderBloc(),
      builder: builder,
    );
  }
}

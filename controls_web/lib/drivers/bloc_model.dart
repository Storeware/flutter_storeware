import 'dart:async';
import 'package:flutter/material.dart';

class BlocModel<T> {
  final _stream = StreamController<T>.broadcast();
  Stream<T> get stream => _stream.stream;
  get sink => _stream.sink;
  notify(T value) {
    sink.add(value);
  }

  listen(Function(T) event) {
    return stream.listen(event);
  }

  close() {
    _stream.close();
  }

  void dispose() {
    close();
  }

  initial({T Function()? next}) {
    var r = next!();
    notify(r);
    return stream;
  }

  Widget value(T value, {Widget Function(T)? builder}) {
    return StreamBuilder<T>(
        stream: this.stream,
        initialData: value,
        builder: (ctx, snap) {
          if (!snap.hasData) return Container();
          return builder!(snap.data!);
        });
  }
}

class BlocNotifier<T> extends StatelessWidget {
  final Function(AsyncSnapshot)? builder;
  final BlocModel<dynamic>? bloc;
  final T? initialData;
  const BlocNotifier({Key? key, this.bloc, this.builder, this.initialData})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<dynamic>(
      stream: bloc!.stream,
      initialData: initialData,
      builder: (x, y) {
        return builder!(y);
      },
    );
  }
}

class StreamNotifier<T> extends StatelessWidget {
  final BlocModel<T>? bloc;
  final AsyncWidgetBuilder<T>? builder;
  final T? initialData;
  const StreamNotifier({Key? key, this.bloc, this.builder, this.initialData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc!.stream,
      builder: builder!,
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
  final Function(AsyncSnapshot<dynamic>)? builder;
  final BlocModel<dynamic>? bloc;
  const RebuildNotify({Key? key, @required this.builder, this.bloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocNotifier<dynamic>(
      bloc: bloc ?? RebuilderBloc(),
      builder: builder,
    );
  }
}

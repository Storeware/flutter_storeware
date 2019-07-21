import 'package:flutter/material.dart';
import 'firestore_bloc.dart';
import 'rxdart_bloc.dart';

class ListDocumentSnapshot extends FirestoreDocuments {}

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

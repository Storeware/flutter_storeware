
import 'package:flutter/material.dart';

import 'rxdart_bloc.dart';

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


import 'package:flutter/material.dart';

import 'rxdart_bloc.dart';

class WidgetDocument {
  Widget data;
  int tag;
  WidgetDocument(this.data, this.tag);
}

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

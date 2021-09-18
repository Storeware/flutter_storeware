// @dart=2.12
import 'package:flutter/material.dart';

import 'view_loading.dart';

class FutureSnapBuilder<T> extends StatelessWidget {
  const FutureSnapBuilder({
    Key? key,
    required this.future,
    //this.errorBuilder,
    this.initialData,
    //this.waitingBuilder,
    this.placeHolder,
    //this.stateBuilder,
    required this.builder,
  }) : super(key: key);
  final AsyncWidgetBuilder builder;
  final T? initialData;
  final Future<T> future;
  //final Function(BuildContext context)? errorBuilder;
  //final Function(BuildContext context)? waitingBuilder;
  final Widget? placeHolder;
  //final Function(BuildContext context)? stateBuilder;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      initialData: initialData,
      builder: (a, snapshot) {
        // if (snapshot.connectionState == ConnectionState.waiting) {
        //   if (placeHolder != null) return placeHolder!;
        if (!snapshot.hasData) {
          return ViewLoading();
        }
        return builder(a, snapshot);
      },
    );
  }
}

class StreamSnapBuilder<T> extends StatelessWidget {
  const StreamSnapBuilder({
    Key? key,
    required this.stream,
//    this.errorBuilder,
    this.initialData,
    //this.waitingBuilder,
    this.placeHolder,
    //  this.stateBuilder,
    required this.builder,
  }) : super(key: key);
  final AsyncWidgetBuilder builder;
  final T? initialData;
  final Stream<T> stream;
  //final Function(BuildContext context)? errorBuilder;
  //final Function(BuildContext context)? waitingBuilder;
  final Widget? placeHolder;
  //final Function(BuildContext context)? stateBuilder;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
        stream: stream,
        initialData: initialData,
        builder: (a, snapshot) {
          if (!snapshot.hasData) {
            if (placeHolder != null) return placeHolder!;
            if (!snapshot.hasData) {
              return ViewLoading();
            }
          }
          return builder(a, snapshot);
        });
  }
}

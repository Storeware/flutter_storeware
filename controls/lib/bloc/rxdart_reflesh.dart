
import 'package:flutter/material.dart';

import 'rxdart_bloc.dart';
import 'rxdart_provider.dart';

class RefleshBloc<T> extends BehaviorSubjectBloc<T> {
  RefleshBloc({T initialState}) : super(initialState: initialState);
}

class RefleshBuilder<T> extends StatelessProvider<T> {
  const RefleshBuilder({Key key, @required bloc, @required builder})
      : assert(bloc != null),
        assert(builder != null),
        super(key: key, bloc: bloc, builder: builder);
}

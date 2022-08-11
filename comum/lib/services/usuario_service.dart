import 'package:comum/services/config_service.dart';
import 'package:flutter/widgets.dart';

class DefaultUsuario extends InheritedWidget {
  final ConfigAppBase? config;
  get logado {
    if (config != null) return config!.logado;
  }

  get usuario => config!.usuario;

  DefaultUsuario({Key? key, @required this.config, Widget? child})
      : super(key: key, child: child!);

  @override
  bool updateShouldNotify(DefaultUsuario oldWidget) {
    return (oldWidget.usuario != usuario) || (oldWidget.logado != logado);
  }

  static of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DefaultUsuario>();
  }
}

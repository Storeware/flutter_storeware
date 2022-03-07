import 'package:controls_web/drivers/bloc_model.dart';

class DefaultMensagemNotifier extends BlocModel<String> {
  static final _singleton = DefaultMensagemNotifier._create();
  DefaultMensagemNotifier._create();
  factory DefaultMensagemNotifier() => _singleton;
}

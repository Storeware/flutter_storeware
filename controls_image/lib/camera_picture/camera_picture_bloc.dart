import 'dart:typed_data';

import 'package:controls_web/drivers/bloc_model.dart';

class CameraPictureBlocNotifier extends BlocModel<Uint8List> {
  static final _singleton = CameraPictureBlocNotifier._create();
  CameraPictureBlocNotifier._create();
  factory CameraPictureBlocNotifier() => _singleton;
}

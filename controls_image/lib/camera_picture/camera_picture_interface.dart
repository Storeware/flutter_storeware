import 'dart:typed_data';

import 'package:flutter/widgets.dart';

abstract class TakeAPictureInterface {
  Future<Uint8List?> take(BuildContext context);

  Future<Uint8List?> gallery(BuildContext context);
}

library controls_image_interface;

import 'dart:typed_data';

abstract class ControlsImageInterface {
  Future<Uint8List?> pickFromGallary({int? imageQuality}) async {
    return null;
  }

  Future<Uint8List?> pickFromCamera({int? imageQuality}) async {
    return null;
  }
}

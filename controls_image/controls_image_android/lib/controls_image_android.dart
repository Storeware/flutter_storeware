library controls_image_android;

import 'package:controls_image_interface/controls_image_interface.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

class ControlsImage extends ControlsImageInterface {
  @override
  Future<Uint8List?> pickFromGallary({int? imageQuality}) async {
    XFile? f = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: imageQuality ?? 60,
    );
    if (f != null) return f.readAsBytes();
    return null;
  }

  @override
  Future<Uint8List?> pickFromCamera({int? imageQuality}) async {
    XFile? f = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: imageQuality ?? 60,
    );
    if (f != null) return f.readAsBytes();
    return null;
  }
}

library controls_image_web;

import 'dart:typed_data';
import 'package:controls_image_interface/controls_image_interface.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:universal_io/prefer_universal/io.dart' as io;

class ControlsImage extends ControlsImageInterface {
  @override
  Future<io.File> pickFromGallary({imageQuality}) async {
    Uint8List bytesFromPicker =
        await ImagePickerWeb.getImage(asUint8List: true);
    return io.File.fromRawPath(
        bytesFromPicker); //File(bytesFromPicker, 'image.jpg');
  }

  @override
  Future<io.File> pickFromCamera({imageQuality}) async {
    Uint8List bytesFromPicker =
        await ImagePickerWeb.getImage(asUint8List: true);
    return io.File.fromRawPath(
        bytesFromPicker); //File(bytesFromPicker, 'image.jpg');
  }
}

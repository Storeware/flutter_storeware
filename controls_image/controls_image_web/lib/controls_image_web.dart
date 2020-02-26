library controls_image_web;

import 'dart:typed_data';

import 'package:controls_image_interface/controls_image_interface.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:universal_html/prefer_universal/html.dart';

class ControlsImage extends ControlsImageInterface {
  @override
  Future<File> pickFromGallary({imageQuality}) async {
    Uint8List bytesFromPicker =
        await ImagePickerWeb.getImage(asUint8List: true);
    return File(bytesFromPicker, 'image.jpg');
  }

  @override
  Future<File> pickFromCamera({imageQuality}) async {
    Uint8List bytesFromPicker =
        await ImagePickerWeb.getImage(asUint8List: true);
    return File(bytesFromPicker, 'image.jpg');
  }
}

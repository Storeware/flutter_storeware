library controls_image_web;

import 'dart:typed_data';

import 'package:controls_image_interface/controls_image_interface.dart';
import 'package:image_picker_web/image_picker_web.dart';

class ControlsImage extends ControlsImageInterface {
  @override
  Future<Uint8List> pickFromGallary({imageQuality}) async {
    Uint8List bytesFromPicker =
        await ImagePickerWeb.getImage(asUint8List: true);
    return bytesFromPicker;
  }

  @override
  pickFromCamera({imageQuality}) {
    return UnimplementedError();
  }
}

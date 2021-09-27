library controls_image_web;

//import 'dart:typed_data';
import 'dart:typed_data';

import 'package:controls_image_interface/controls_image_interface.dart';
//import 'package:image_picker_web/image_picker_web.dart';

import 'imagePickerWeb.dart';

class ControlsImage extends ControlsImageInterface {
  @override
  Future<Uint8List?> pickFromGallary({int? imageQuality}) async {
    var picked =
        await ImagePickerWeb().getImage(/*outputType: ImageType.bytes*/);
    return picked.image_memory; //File(bytesFromPicker, 'image.jpg');
  }

  @override
  Future<Uint8List?> pickFromCamera({int? imageQuality}) async {
    var picked =
        await ImagePickerWeb().getImage(/*outputType: ImageType.bytes*/);
    return picked.image_memory; //File(bytesFromPicker, 'image.jpg');
  }
}

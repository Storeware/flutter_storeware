library controls_image_web;

//import 'dart:typed_data';
import 'package:controls_image_interface/controls_image_interface.dart';
//import 'package:image_picker_web/image_picker_web.dart';
import 'package:universal_io/io.dart' as io;

import 'imagePickerWeb.dart';

class ControlsImage extends ControlsImageInterface {
  @override
  Future<io.File> pickFromGallary({int? imageQuality}) async {
    var picked =
        await ImagePickerWeb().getImage(/*outputType: ImageType.bytes*/);
    return io.File.fromRawPath(
        picked.image_memory!); //File(bytesFromPicker, 'image.jpg');
  }

  @override
  Future<io.File> pickFromCamera({int? imageQuality}) async {
    var picked =
        await ImagePickerWeb().getImage(/*outputType: ImageType.bytes*/);
    return io.File.fromRawPath(
        picked.image_memory!); //File(bytesFromPicker, 'image.jpg');
  }
}

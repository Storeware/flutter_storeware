library controls_image_android;

import 'package:controls_image_interface/controls_image_interface.dart';
import 'package:image_picker/image_picker.dart';
import 'package:universal_io/io.dart' as io;

class ControlsImage extends ControlsImageInterface {
  @override
  Future<io.File?> pickFromGallary({int? imageQuality}) async {
    var f = await ImagePicker().getImage(
      source: ImageSource.gallery,
      imageQuality: imageQuality ?? 60,
    );
    if (f != null) return io.File.fromRawPath(await f.readAsBytes());
    return null;
  }

  @override
  Future<io.File?> pickFromCamera({int? imageQuality}) async {
    var f = await ImagePicker().getImage(
      source: ImageSource.camera,
      imageQuality: imageQuality ?? 60,
    );
    if (f != null) return io.File.fromRawPath(await f.readAsBytes());
    return null;
  }
}

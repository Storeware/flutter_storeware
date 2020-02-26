library controls_image_android;

import 'package:controls_image_interface/controls_image_interface.dart';
import 'package:image_picker/image_picker.dart';
import 'package:universal_io/prefer_universal/io.dart' as io;

class ControlsImage extends ControlsImageInterface {
  @override
  Future<io.File> pickFromGallary({imageQuality}) async {
    var rt = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: imageQuality,
    );
    var bytes = await rt.readAsBytes();
    return io.File.fromRawPath(bytes);
  }

  @override
  Future<io.File> pickFromCamera({imageQuality}) async {
    var rt = await ImagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: imageQuality,
    );
    var bytes = await rt.readAsBytes();
    return io.File.fromRawPath(bytes);
  }
}

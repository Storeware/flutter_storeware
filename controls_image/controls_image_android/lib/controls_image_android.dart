library controls_image_android;

import 'dart:io';

import 'package:controls_image_interface/controls_image_interface.dart';
import 'package:image_picker/image_picker.dart';

class ControlsImage extends ControlsImageInterface {
  @override
  Future<File> pickFromGallary({imageQuality = 75}) {
    return ImagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: imageQuality,
    );
  }

  @override
  pickFromCamera(imageQuality) {
    return ImagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: imageQuality,
    );
  }
}

library controls_image_interface;

abstract class ControlsImageInterface {
  pickFromGallary({int ? imageQuality}) async {
    return UnimplementedError();
  }

  pickFromCamera({int ? imageQuality}) async {
    return UnimplementedError();
  }
}

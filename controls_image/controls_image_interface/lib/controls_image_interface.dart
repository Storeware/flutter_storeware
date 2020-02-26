library controls_image_interface;

abstract class ControlsImageInterface {
  pickFromGallary({imageQuality}) {
    return UnimplementedError();
  }

  pickFromCamera(imageQuality) {
    return UnimplementedError();
  }
}

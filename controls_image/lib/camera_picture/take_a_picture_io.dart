import 'dart:typed_data';

import 'camera_picture_bloc.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'camera_picture_interface.dart';

class TakeAPictureImpl extends TakeAPictureInterface {
  final ImagePicker _picker = ImagePicker();

  Future<Uint8List> take(BuildContext context) async {
    return _picker.getImage(source: ImageSource.camera).then((PickedFile? rsp) {
      return rsp!.readAsBytes().then((bytes) {
        CameraPictureBlocNotifier().notify(bytes);
        return bytes;
      });
    });
  }

  Future<Uint8List> gallery(BuildContext context) async {
    return _picker
        .getImage(source: ImageSource.gallery)
        .then((PickedFile? rsp) {
      return rsp!.readAsBytes().then((bytes) {
        CameraPictureBlocNotifier().notify(bytes);
        return bytes;
      });
    });
  }
}

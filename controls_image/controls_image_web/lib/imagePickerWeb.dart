import 'dart:convert';
import 'dart:typed_data';

import 'package:universal_html/html.dart' as html;

class ImagePickerWeb {
  Uint8List? image_memory;
  html.File? image_upload;

  Future<ImagePickerWeb> getImage() async {
    _get();
    while (image_memory == null) {
      await Future.delayed(Duration(microseconds: 1));
    }

    ImagePickerWeb img = ImagePickerWeb();
    img.image_memory = this.image_memory;
    img.image_upload = this.image_upload;
    return img;
  }

  _get() {
    final html.InputElement input =
        html.document.createElement('input') as html.InputElement;
    input
      ..type = 'file'
      ..accept = 'image/*';

    input.onChange.listen((e) async {
      if (input.files!.isEmpty) return;

      final reader = html.FileReader();
      image_upload = input.files!.first;
      reader.readAsDataUrl(input.files![0]);
      reader.onError.listen((erro) {
        print(erro);
      });
      await reader.onLoad.first.then((res) async {
        final encoded = reader.result as String;
        // remove data:image/*;base64 preambule
        final stripped =
            encoded.replaceFirst(RegExp(r'data:image/[^;]+;base64,'), '');

        image_memory = base64.decode(stripped);
      });
    });
    input.click();
  }
}

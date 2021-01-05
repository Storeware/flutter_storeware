import 'package:flutter/material.dart';

import 'take_a_picture_io.dart' if (dart.js) 'take_a_picture_web.dart';

class TakeAPicture extends TakeAPictureImpl {
  static Widget builder(BuildContext context) {
    return Wrap(children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
            child: Icon(Icons.camera),
            onTap: () {
              TakeAPicture().take(context);
            }),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
            child: Icon(Icons.image),
            onTap: () {
              TakeAPicture().gallery(context);
            }),
      )
    ]);
  }
}

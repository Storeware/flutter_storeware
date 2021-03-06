import 'dart:async';
import 'dart:typed_data';

import 'package:controls_web/controls/injects.dart';
import 'package:flutter/material.dart';

import 'camera_picture_bloc.dart';
import 'take_a_picture.dart';

class TakeAPictureView extends StatefulWidget {
  final Function(Uint8List)? onChanged;
  final double? width;
  final double? height;
  final Uint8List? initialData;
  final Widget? title;
  const TakeAPictureView(
      {Key? key,
      this.onChanged,
      this.width,
      this.height,
      this.initialData,
      this.title})
      : super(key: key);

  @override
  _TakeAPictureViewState createState() => _TakeAPictureViewState();
}

class _TakeAPictureViewState extends State<TakeAPictureView> {
  ValueNotifier? imageBytes;
  StreamSubscription? cameraEvent;

  @override
  void initState() {
    super.initState();
    cameraEvent = CameraPictureBlocNotifier().stream.listen((rsp) {
      imageBytes!.value = rsp;
    });

    imageBytes = ValueNotifier<Uint8List>(Uint8List(0));
    if (widget.initialData != null)
      Timer.run(() {
        imageBytes!.value = widget.initialData;
      });
  }

  @override
  void dispose() {
    cameraEvent!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    dynamic? injects = InjectBuilder.of(context);

    InjectItem<TakeAPicture>? camera = injects!['injectCameraPicture'];

    return Material(
        child: Column(children: [
      AppBar(title: widget.title, actions: [
        Row(children: [
          if (camera != null) camera.builder!(context, null),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
                child: Icon(Icons.check),
                onTap: () {
                  if (widget.onChanged != null)
                    widget.onChanged!(imageBytes!.value);
                  // Navigator.pop(context);
                }),
          )
        ])
      ]),
      Center(
          child: ValueListenableBuilder<dynamic>(
              valueListenable: imageBytes!,
              builder: (a, bytes, c) => Container(
                  height: 300,
                  child: (bytes != null)
                      ? Image.memory(
                          bytes,
                          fit: BoxFit.fitHeight,
                        )
                      : null)))
    ]));
  }
}

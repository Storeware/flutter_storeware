//import 'dart:io';

import 'package:controls_data/cached.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_cached/flutter_cached.dart';
import 'package:universal_html/prefer_universal/html.dart' as html;
import 'firebase_driver.dart';

class FirestorageDownloadImage extends StatefulWidget {
  final String img;
  final double width;
  final double height;
  final BoxFit fit;
  final String clientId;
  final double radius;
  final double padding;
  final String alias;
  final FilterQuality filterQuality;
  final Function onLoaded;
  FirestorageDownloadImage(
      {Key key,
      @required this.clientId,
      @required this.img,
      this.width,
      this.radius = 10,
      this.padding = 0,
      this.height,
      this.fit,
      this.filterQuality = FilterQuality.medium,
      this.onLoaded,
      this.alias = ''})
      : super(key: key);

  static Future<String> getDownloadURL(src) async {
    return await Cached.value<Future<String>>(src, builder: (x) {
      return FirebaseApp().storage().getDownloadURL(x);
    });
  }

  @override
  _FirestorageDownloadImageState createState() =>
      _FirestorageDownloadImageState();
}

class _FirestorageDownloadImageState extends State<FirestorageDownloadImage> {
  Future<String> _get(src) async {
    return FirestorageDownloadImage.getDownloadURL(src);
  }

  String formatStoragePath(String path) {
    if (!path.startsWith('/')) path = '/$path';
    return '${widget.clientId}$path';
  }

  Image _image;

  ImageProvider imageProvider() {
    return _image.image;
  }

  @override
  Widget build(BuildContext context) {
    if ((widget.img ?? '') == '')
      return Container(
        height: widget.height,
        width: widget.width,
      );
    return FutureBuilder<String>(
        future: _get(formatStoragePath(widget.img)),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Align(
              child: Icon(Icons.picture_in_picture),
            );
          var s = snapshot.data.toString();

          return Cached.image(context, '$s.${widget.alias}', builder: (url) {
            return Image.network(
              s,
              fit: widget.fit ?? BoxFit.cover,
              filterQuality: widget.filterQuality,
            );
          });
        });
  }
}

class FirestorageUploadImage extends StatefulWidget {
  final double width;
  final double height;
  final String img;
  final Function(String) onChange;
  //final String path;
  final String clientId;
  final BoxFit fit;
  final double elevation;
  FirestorageUploadImage(
      {Key key,
      this.img,
      this.width,
      this.height,
      this.onChange,
      //@required this.path,
      @required this.clientId,
      this.fit,
      this.elevation = 0})
      : super(key: key);
  @override
  _FirestorageUploadImageState createState() => _FirestorageUploadImageState();
}

class _FirestorageUploadImageState extends State<FirestorageUploadImage> {
  String img;
  _load(src) {
    img = src;
  }

  @override
  Widget build(BuildContext context) {
    _load(widget.img);
    return Center(
      child: Container(
          width: widget.width,
          height: widget.height,
          child: Card(
            elevation: widget.elevation,
            child: Stack(children: [
              Positioned(
                left: 10,
                right: 10,
                top: 10,
                bottom: 40,
                child: FirestorageDownloadImage(
                  img: img,
                  height: widget.height,
                  fit: widget.fit,
                  clientId: widget.clientId,
                ),
              ),
              Positioned(
                bottom: 0,
                child: FlatButton(
                  child: Text('Carregar'),
                  onPressed: () {
                    ImageToUpload().load((f) {
                      if (f != null) {
                        var src = formatStoragePath(f.name);
                        urlDownload(f, (x) {});
                        widget.onChange(src);
                      }
                    });
                  },
                ),
              )
            ]),
          )),
    );
  }

  Future<String> urlDownload(html.File file, callback) async {
    String sFile = formatStoragePath(file.name);

    FirebaseApp().storage().uploadFileImage(sFile, file);
    return FirebaseApp().storage().getDownloadURL(sFile).then((x) {
      callback(x);
      return x;
    });
  }

  String formatStoragePath(path) {
    return '${widget.clientId}/$path';
  }

  String imageRefPath() {
    return '${widget.clientId}';
  }
}

class ImageToUpload {
  load(callback) async {
    html.InputElement element = html.querySelector("#upload_image");
    if (element != null) element.remove();
    element = html.document.createElement("input");
    element.type = 'file';
    element.id = "upload_image";
    element.accept = "image/x-png,image/gif,image/jpeg";
    element.name = "upload_image";
    element.addEventListener('change', (x) {
      html.File file = element.files[0];
      callback(file);
    });
    html.querySelector("html").querySelector('body').append(element);
    element.click();
    return null;
  }
}

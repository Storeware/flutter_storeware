import 'package:controls_web/drivers/firebase_firestore.dart';
import 'package:firebase_web/firebase.dart';
import 'package:flutter/material.dart';
import 'package:universal_html/prefer_universal/html.dart' as html;

String firestore_clientId = 'm5';

class FirestorageImage extends StatelessWidget {
  final String img;
  final double width;
  final double height;
  final BoxFit fit;
  FirestorageImage({Key key, this.img, this.width, this.height, this.fit})
      : super(key: key);

  _get(src) {
    return FirebaseApp.storageApp.ref(src).getDownloadURL();
  }

  Image _image;

  ImageProvider imageProvider(){
     return _image.image;
  }

  static Future<String> getDownloadURL(src) async {
    Uri uri = await FirebaseApp.storageApp.ref(src).getDownloadURL();
    print(uri.toFilePath());
    return uri.toString();
  }

  @override
  Widget build(BuildContext context) {
    if ((img ?? '') == '')
      return Container(
        height: height,
        width: width,
      );
    return FutureBuilder<Uri>(
        future: _get(img),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Container(
              color: Colors.transparent,
              height: width,
              width: height,
            );
          var s = snapshot.data.toString();
          _image = Image.network(
            s,
            width: width,
            height: height,
            fit: fit,
          );
          return _image;
        });
  }
}

class FirestorageUploadImage extends StatefulWidget {
  final double width;
  final double height;
  final String img;
  final Function(String) onChange;
  final String path;
  String clientId;
  final BoxFit fit;
  final double elevation;
  FirestorageUploadImage(
      {Key key,
      this.img,
      this.width,
      this.height,
      this.onChange,
      @required this.path,
      clientId,
      this.fit,
      this.elevation = 0})
      : super(key: key) {
    this.clientId = clientId ?? firestore_clientId;
  }
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
                child: FirestorageImage(
                  img: img,
                  height: widget.height,
                  fit: widget.fit,
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
    StorageReference ref = FirebaseApp.storageApp.ref(sFile);
    //print(sFile);
    UploadTask uploadTask = await ref.put(file);
    ref.getDownloadURL().then((x) {
      callback(sFile);
    });
  }

  String formatStoragePath(src) {
    return '${widget.path}/${widget.clientId}/${src}';
  }

  String imageRefPath() {
    return '${widget.path}/${widget.clientId}';
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

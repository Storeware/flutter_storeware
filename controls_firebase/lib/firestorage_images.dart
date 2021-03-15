import 'package:controls_data/cached.dart';
import 'package:controls_data/data_model.dart';
import 'package:controls_firebase/firebase_driver.dart';
import 'package:flutter/material.dart';
import 'dart:html' hide Text;

class FirestorageDownloadImage extends StatefulWidget {
  final String? img;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final String? clientId;
  final double? radius;
  final double? padding;
  final String? alias;
  final FilterQuality? filterQuality;
  final Function? onLoaded;
  FirestorageDownloadImage(
      {Key? key,
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
      return FirebaseApp().storage().getDownloadURL(src);
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
    if (path.startsWith(widget.clientId!)) return path;
    if (!path.startsWith('/')) path = '/$path';
    return '${widget.clientId}$path';
  }

  Image? _image;

  ImageProvider imageProvider() {
    return _image!.image;
  }

  loadImagem(s) {
    return Cached.image(context, '$s', builder: (url) {
      return Image.network(
        s,
        fit: widget.fit ?? BoxFit.cover,
        filterQuality: widget.filterQuality!,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if ((widget.img ?? '') == '')
      return Container(
        height: widget.height,
        width: widget.width,
      );
    if (widget.img!.startsWith('http')) {
      return loadImagem(widget.img);
    }

    return FutureBuilder<String>(
        future: _get(formatStoragePath(widget.img!)),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Align(
              child: Icon(Icons.picture_in_picture),
            );
          var s = snapshot.data.toString();
          return loadImagem(s);
        });
  }
}

class FirestorageUploadImage extends StatefulWidget {
  final double? width;
  final double? height;
  final String? img;
  final String? maskTo;
  final String? buttonTitle;
  final int? maxBytes;
  final Function(String)? onChange;
  //final String path;
  final String? clientId;
  final BoxFit? fit;
  final double? elevation;
  final Map<String, String>? metadata;
  final Function(bool)? onProgress;
  FirestorageUploadImage(
      {Key? key,
      this.img,
      this.width,
      this.height,
      this.onChange,
      this.onProgress,
      //@required this.path,
      @required this.clientId,
      this.fit,
      this.metadata,
      this.elevation = 0,
      this.maskTo,
      this.buttonTitle,
      this.maxBytes = 100000})
      : super(key: key);
  @override
  _FirestorageUploadImageState createState() => _FirestorageUploadImageState();
}

class _FirestorageUploadImageState extends State<FirestorageUploadImage> {
  String? img;
  _load(src) {
    img = src;
  }

  FileReader fileReader = FileReader();
  @override
  Widget build(BuildContext context) {
    ValueNotifier<String> img = ValueNotifier<String>(widget.img!);
    return ValueListenableBuilder<String>(
        valueListenable: img,
        builder: (a, _img, w) {
          _load(_img);
          print('carregando: $_img');
          bool isFirebase = (_img == '') || (!_img.startsWith('http'));
          return Center(
            child: Container(
                width: widget.width,
                height: (widget.height != null) ? widget.height! + 30 : null,
                child: Card(
                  elevation: widget.elevation,
                  child: Stack(children: [
                    Positioned(
                      left: 10,
                      right: 10,
                      top: 10,
                      bottom: 40,
                      child: isFirebase
                          ? FirestorageDownloadImage(
                              img: _img,
                              height: widget.height,
                              fit: widget.fit,
                              clientId: widget.clientId,
                            )
                          : Cached.image(context, _img,
                              builder: (k) => Image.network(
                                    _img,
                                    fit: widget.fit,
                                    height: widget.height,
                                  )),
                    ),
                    Positioned(
                      bottom: 0,
                      child: TextButton(
                        child:
                            Text(widget.buttonTitle ?? 'Procurar uma imagem'),
                        onPressed: () {
                          ImageToUpload().load((f) async {
                            //if (f != null) {
                            var size = f.size;
                            print(size);
                            if (size > widget.maxBytes!)
                              ErrorNotify().notify(
                                  'Imagem com $size bytes (max: ${widget.maxBytes} bytes)');
                            else {
                              if (widget.onProgress != null)
                                widget.onProgress!(true);
                              urlDownload(f, (x) {
                                if (widget.onProgress != null)
                                  widget.onProgress!(false);

                                widget.onChange!(x);
                                print('nova imagem $x');
                                img.value = x;
                              }, maskTo: widget.maskTo!);
                            }
                          });
                        },
                      ),
                    )
                  ]),
                )),
          );
        });
  }

  Future<String> urlDownload(File file, callback, {String? maskTo}) async {
    String sFile = formatStoragePath(file.name);
    if ((maskTo != null) && (maskTo.indexOf('.') < 0)) {
      var lst = sFile.split('/');
      sFile = maskTo + lst.last;
    } else if (maskTo!.indexOf('.') > 0) sFile = maskTo;

    FileReader fileReader = FileReader();
    fileReader.onLoad.listen((data) async {
      try {
        var rawFile = fileReader.result;
        print('pronto para pegar dados do arquivo: $sFile');
        await FirebaseApp()
            .storage()
            .uploadFileImage(sFile, rawFile, metadata: widget.metadata)
            .then((rsp) => print(rsp));
        FirebaseApp().storage().getDownloadURL(sFile).then((f) {
          callback(sFile);
        });
      } on FormatException catch (e) {
        print('Error ${e.message}');
      }
    });
    print('$file');
    fileReader.readAsArrayBuffer(file);
    return sFile;
  }

  String formatStoragePath(String path) {
    if (path.startsWith(widget.clientId!)) return path;
    return '${widget.clientId}/$path';
  }

  String imageRefPath() {
    return '${widget.clientId}';
  }
}

class ImageToUpload {
  load(Function(File) callback) async {
    //html.InputElement element = html.querySelector("#upload_image");
    //if (element != null) element.remove();
    //element = html.document.createElement("input");
    FileUploadInputElement element = FileUploadInputElement();
    element.id = "upload_image";
    element.accept = "image/x-png,image/gif,image/jpeg";
    element.name = "upload_image";
    element.onChange.listen((e) {
      final files = element.files;
      if (files!.length == 1) {
        final File file = files[0];
        callback(file);
      }
    });
    element.click();
    return null;
  }
}

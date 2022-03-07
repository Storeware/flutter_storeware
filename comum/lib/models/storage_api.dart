// @dart=2.12
import 'dart:convert';
import 'dart:typed_data';

import 'package:controls_data/cached.dart';
import 'package:controls_data/odata_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart' as cacheApi;
import 'package:universal_platform/universal_platform.dart';

class ProdutoMetadata {
  String? gtin;
  String? unit;
  String? description;
  String? tag;
  String? origem;
  toJson() {
    return {
      "gtin": gtin,
      "unit": unit,
      "description": description,
      "tag": tag,
      "origem": origem
    };
  }
}

class StorageApi {
  bool inited = false;
  cacheApi.CacheManager? instance;
  int days = 7;
  int maxNrOfCacheObjects = 512;
  init() {
    if (inited) return;
    instance = cacheApi.CacheManager(cacheApi.Config(
      'firestorage_image_cache_manager',
      stalePeriod: Duration(days: days),
      maxNrOfCacheObjects: maxNrOfCacheObjects,
    ));
  }

  //Future<Uint8List>
  download(String path, {bool cached = true}) async {
    init();
    if (path.startsWith('http')) {
      var rt = instance!.getSingleFile(path).then((f) => f.readAsBytes())
        ..onError((error, stackTrace) => Future.value(null));
      return rt;
    }
    if (path.startsWith('assets'))
      return rootBundle.load(path).then((f) => f.buffer.asUint8List());

    var _img = genPath(path);
    var client = CloudV3().client.clone();
    client.prefix = '';
    var url = client.client.formatUrl(path: '/storage/download64?path=' + path);
    var cache = () => client.client
            .rawData(
          url,
          contentType: 'text/plain',
          method: 'GET',
          cacheControl: (cached) ? 'public; max-age:3600' : null,
        )
            .then((rsp) {
          var img64 = rsp.data.split('base64,').last;
          Uint8List decoded = base64Decode(img64);

          if (UniversalPlatform.isWeb) {
            // deixa o browser deciidr sobre o cache.
            //Cached.add(_img, decoded);
          } else {
            instance!.putFile(_img, decoded);
          }
          return decoded;
        }).catchError((err) {
          return null;
        });
    if (!cached) return cache();
    if (UniversalPlatform.isWeb) {
      // deixa o browser decidir sobre o cache.
      //var bytes = Cached.value(_img);
      //if (bytes != null) return bytes;
    } else {
      var file = await instance!.getFileFromCache(_img);
      if (file != null) {
        var rt = await file.file.readAsBytes();
        instance!.removeFile(_img);
        instance!.putFile(_img, rt);
        return rt;
      }
    }
    return cache();
  }

  clear() {
    init();
    instance!.emptyCache();
  }

  upload(Uint8List file, String path, {Map<String, dynamic>? metadata}) async {
    init();
    // carregar o arquivo
    final Uint8List bytes = file;
    final ext = path.split('.').last; //?? 'jpg';
    // gerar base64
    String img64 = base64Encode(bytes);
    var data = {
      "path": path,
      "metadata": (metadata ?? {})..["sender"] = "Storeware Console",
      "content": 'data:image/$ext;base64,' + img64,
      "contentType": 'image/jpeg'
    };

    // enviar para o servidor
    var client = CloudV3().client.clone();
    client.prefix = '';
    var url = client.client.formatUrl(path: '/storage/upload64?path=' + path);
    String _img = genPath(path);
    return client.client
        .rawData(url,
            method: 'POST',
            body: data,
            contentType: 'application/json',
            cacheControl: 'public; max-age=3600')
        .then((rsp) {
      Uint8List decoded = base64Decode(img64);
      if (UniversalPlatform.isWeb)
        Cached.add(_img, decoded);
      else {
        instance!.removeFile(_img);
        instance!.putFile(_img, decoded);
      }
      return rsp.data;
    });
  }

  genPath(path) => 'image_$path';
}

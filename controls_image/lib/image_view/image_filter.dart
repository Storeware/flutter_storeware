import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photofilters/filters/filters.dart';
import 'package:image/image.dart' as imageLib;
import 'package:path_provider/path_provider.dart';

class PhotoFilter extends StatelessWidget {
  final imageLib.Image? image;
  final String? filename;
  final Filter? filter;
  final BoxFit fit;
  final Widget loader;
  const PhotoFilter({
    Key? key,
    @required this.image,
    @required this.filename,
    @required this.filter,
    this.fit = BoxFit.fill,
    this.loader = const Center(child: CircularProgressIndicator()),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<int>>(
      future: compute(applyFilter, <String, dynamic>{
        "filter": filter,
        "image": image,
        "filename": filename,
      }),
      builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return loader;
          case ConnectionState.active:
          case ConnectionState.waiting:
            return loader;
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            return Image.memory(
              Uint8List.fromList(snapshot.data!),
              fit: fit,
            );
        }
      },
    );
  }
}

///The PhotoFilterSelector Widget for apply filter from a selected set of filters
class PhotoFilterEditor extends StatefulWidget {
  final Widget title;

  final List<Filter> filters;
  final imageLib.Image image;
  final Widget loader;
  final BoxFit fit;
  final String? filename;
  final bool circleShape;
  final Function(Uint8List)? okPressed;
  const PhotoFilterEditor({
    Key? key,
    required this.title,
    required this.filters,
    required this.image,
    this.okPressed,
    this.loader = const Center(child: CircularProgressIndicator()),
    this.fit = BoxFit.fitWidth,
    @required this.filename,
    this.circleShape = false,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PhotoFilterEditorState();
}

class _PhotoFilterEditorState extends State<PhotoFilterEditor> {
  String? filename;
  Map<String, List<int>> cachedFilters = {};
  late Filter _filter;
  late imageLib.Image image;
  late bool loading;

  @override
  void initState() {
    super.initState();
    loading = false;
    _filter = widget.filters[0];
    filename = widget.filename;
    image = widget.image;
  }

  @override
  void dispose() {
    cachedFilters = {};
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.title,
        actions: <Widget>[
          loading
              ? Container()
              : IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: () async {
                    setState(() {
                      loading = true;
                    });
                    var imageFile = await saveFilteredImage();
                    imageFile.readAsBytes().then((bytes) {
                      if (widget.okPressed != null) widget.okPressed!(bytes);
                      Navigator.pop(context);
                    });
                    //Navigator.pop(context, {'image_filtered': imageFile});
                  },
                )
        ],
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: loading
            ? widget.loader
            : Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    flex: 6,
                    child: Container(
                      color: Colors.white12,
                      width: double.infinity,
                      height: double.infinity,
                      padding: const EdgeInsets.all(12.0),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: _buildFilteredImage(
                            _filter,
                            image,
                            filename!,
                          )),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.filters.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          child: Container(
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                _buildFilterThumbnail(
                                    widget.filters[index], image, filename!),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                Text(
                                  widget.filters[index].name,
                                )
                              ],
                            ),
                          ),
                          onTap: () => setState(() {
                            _filter = widget.filters[index];
                          }),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  _buildFilterThumbnail(Filter filter, imageLib.Image image, String filename) {
    if (cachedFilters[filter.name] == null) {
      return FutureBuilder<List<int>>(
        future: compute(applyFilter, <String, dynamic>{
          "filter": filter,
          "image": image,
          "filename": filename,
        }),
        builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return CircleAvatar(
                radius: 50.0,
                child: Center(
                  child: widget.loader,
                ),
                backgroundColor: Colors.white,
              );
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              cachedFilters[filter.name] = snapshot.data!;
              return CircleAvatar(
                radius: 50.0,
                backgroundImage: MemoryImage(
                  Uint8List.fromList(snapshot.data!),
                ),
                backgroundColor: Colors.white,
              );
          }
        },
      );
    } else {
      return CircleAvatar(
        radius: 50.0,
        backgroundImage: MemoryImage(
          Uint8List.fromList(cachedFilters[filter.name]!),
        ),
        backgroundColor: Colors.white,
      );
    }
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File?> get _localFile async {
    final path = await _localPath;
    return File('$path/filtered_${_filter.name}_$filename');
  }

  Future<File> saveFilteredImage() async {
    var imageFile = await _localFile;
    List<int>? bytes =
        cachedFilters[_filter.name] ?? cachedFilters[cachedFilters.keys.first];
    await imageFile!.writeAsBytes(bytes!);
    return imageFile;
  }

  Widget _buildFilteredImage(
      Filter filter, imageLib.Image image, String filename) {
    if (cachedFilters[filter.name] == null) {
      return FutureBuilder<List<int>>(
        future: compute(applyFilter, <String, dynamic>{
          "filter": filter,
          "image": image,
          "filename": filename,
        }),
        builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return const Align(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.waiting:
              return widget.loader;
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              cachedFilters[filter.name] = snapshot.data!;
              return widget.circleShape
                  ? SizedBox(
                      height: MediaQuery.of(context).size.width / 3,
                      width: MediaQuery.of(context).size.width / 3,
                      child: Center(
                        child: CircleAvatar(
                          radius: MediaQuery.of(context).size.width / 3,
                          backgroundImage: MemoryImage(
                            Uint8List.fromList(snapshot.data!),
                          ),
                        ),
                      ),
                    )
                  : SizedBox(
                      height: MediaQuery.of(context).size.width / 3,
                      width: MediaQuery.of(context).size.width / 3,
                      child: Center(
                        child: Image.memory(
                          Uint8List.fromList(snapshot.data!),
                          //fit: BoxFit.contain,
                        ),
                      ));
          }
        },
      );
    } else {
      return widget.circleShape
          ? SizedBox(
              height: MediaQuery.of(context).size.width / 3,
              width: MediaQuery.of(context).size.width / 3,
              child: Center(
                child: CircleAvatar(
                  radius: MediaQuery.of(context).size.width / 3,
                  backgroundImage: MemoryImage(
                    Uint8List.fromList(cachedFilters[filter.name]!),
                  ),
                ),
              ),
            )
          : Image.memory(
              Uint8List.fromList(cachedFilters[filter.name]!),
              fit: widget.fit,
            );
    }
  }
}

///The global applyfilter function
List<int> applyFilter(Map<String, dynamic> params) {
  Filter? filter = params["filter"];
  imageLib.Image image = params["image"];
  String filename = params["filename"];
  List<int>? _bytes = image.getBytes();
  if (filter != null) {
    filter.apply(Uint8List.fromList(_bytes), image.width, image.height);
  }
  imageLib.Image _image =
      imageLib.Image.fromBytes(image.width, image.height, _bytes);
  _bytes = imageLib.encodeNamedImage(_image, filename);

  return _bytes!;
}

///The global buildThumbnail function
List<int> buildThumbnail(Map<String, dynamic> params) {
  int width = params["width"];
  params["image"] = imageLib.copyResize(params["image"], width: width);
  return applyFilter(params);
}

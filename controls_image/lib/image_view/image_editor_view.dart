import 'dart:async';
//import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:controls_web/controls.dart';
import 'package:controls_image/controls_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_editor/image_editor.dart';
//import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photofilters/photofilters.dart';
import 'image_filter.dart';
import 'package:image/image.dart' as imageLib;
import './image_widgets.dart';
//import 'package:universal_platform/universal_platform.dart';

class ImageEditorView extends StatefulWidget {
  final double width;
  final double height;
  final Function(Uint8List)? onSelected;
  final String? titulo;
  final String? filename;
  final Uint8List? rawPath;
  final bool useFilter;
  const ImageEditorView(
      {Key? key,
      this.titulo,
      this.width = 300,
      this.height = 300,
      this.rawPath,
      this.useFilter = false,
      this.filename,
      this.onSelected})
      : super(key: key);
  @override
  _ImageEditorViewState createState() => _ImageEditorViewState();
}

class _ImageEditorViewState extends State<ImageEditorView> {
  final editorKey = GlobalKey<ExtendedImageEditorState>();
  String? filterFileName;
  ImageProvider? provider;
  bool selected = false;
  @override
  void initState() {
    originalFile = widget.rawPath != null;
    _aspectRatioSelected = 5;
    _aspectRatio = _aspectRatios[_aspectRatioSelected];
    filterFileName =
        widget.filename ?? 'resised.jpg'; // corrige bug de carga com NULL;
    super.initState();
    if (widget.rawPath != null) {
      //print(['passou a imagem']);
      _fileOriginal = widget.rawPath!;
      File file = File.fromRawPath(_fileOriginal!);
      provider = ExtendedFileImageProvider(file);
    }
    getPath(name: 'filters').then((x) {
      filterFileName = x;
    });
  }

  final sz = 28.0;
  Uint8List? _fileOriginal;
  bool originalFile = false;
  Size? size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return ScaffoldLight(
      appBar: appBarLight(title: const Text('Imagem'), actions: [
        IconButton(
          icon: Icon(
            Icons.photo,
            size: sz,
          ),
          onPressed: _gallery,
        ),
        IconButton(
          icon: Icon(
            Icons.camera,
            size: sz,
          ),
          onPressed: _pick,
        ),
        //_gallery()
        IconButton(
          icon: Icon(
            Icons.check,
            size: sz,
          ),
          onPressed: () {
            crop(context, false);
          },
        ),
      ]),
      //extendedPanelHeigh: 150,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: SizedBox(
            height: double.infinity,
            child: Column(
              children: <Widget>[
                Text(widget.titulo ?? '',
                    style: const TextStyle(color: Colors.black87)),
                AspectRatio(
                  aspectRatio: 1,
                  child: buildImage(),
                ),
                Expanded(
                    child: Column(children: [
                  ValueListenableBuilder<double>(
                    valueListenable: sliderValue,
                    builder:
                        (BuildContext context, double value, Widget? child) {
                      return Container(
                        height: 20,
                        child: Slider(
                            min: 1,
                            max: 9,
                            label: '${percentagem()}%',
                            activeColor: Colors.blue,
                            inactiveColor: Colors.blue,
                            value: value,
                            divisions: 8,
                            onChangeEnd: (x) {
                              resize(x);
                            },
                            onChanged: (x) {}),
                      );
                    },
                  ),
                  buildAspectRatios(),
                  ValueListenableBuilder<Size>(
                      valueListenable: imageSize,
                      builder:
                          (BuildContext context, Size value, Widget? child) {
                        return Text('${value.width} x ${value.height}',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w200,
                            ));
                      }),
                ])),
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar: _buildFunctions(),
    );
  }

  double percentagem() {
    return [
      -100.0,
      -80.0,
      -60.0,
      -40.0,
      -20.0,
      00.0,
      20.0,
      40.0,
      60.0,
      80.0,
      100.0
    ][(sliderValue.value) ~/ 1];
  }

  ValueNotifier<double> sliderValue = ValueNotifier(5);
  double get width => 400.0; //(size?.width ?? 550) / 5 * 4;
  double get height => 300.0; // (size?.height ?? 850) / 5 * 3;

  Widget buildImage() {
    if (provider == null) {
      return Container(
          height: widget.height,
          width: widget.width,
          color: Colors.white,
          child: InkWell(
            child: const Icon(Icons.photo, color: Colors.black, size: 64),
            onTap: () {
              _gallery();
            },
          ));
    }

    if (originalFile) {
      var img = ExtendedImage.memory(widget.rawPath!,
          width: width,
          height: height,
          extendedImageEditorKey: editorKey,
          mode: ExtendedImageMode.editor,
          fit: BoxFit.contain, initEditorConfigHandler: (state) {
        return EditorConfig(
          maxScale: 8.0,
          cropRectPadding: const EdgeInsets.all(10.0),
          initCropRectType: InitCropRectType.imageRect,
          cropAspectRatio: _aspectRatio!.value,
        );
      });
      return img;
    }

    var img = ExtendedImage(
      image: provider!,
      width: width,
      height: height,
      extendedImageEditorKey: editorKey,
      mode: ExtendedImageMode.editor,
      fit: BoxFit.contain,
      initEditorConfigHandler: (state) {
        return EditorConfig(
          maxScale: 8.0,
          cropRectPadding: const EdgeInsets.all(10.0),
          initCropRectType: InitCropRectType.imageRect,
          cropAspectRatio: _aspectRatio!.value,
        );
      },
    );

    return img;
  }

  final List<AspectRatioItem> _aspectRatios = [
    //AspectRatioItem(text: "***", value: CropAspectRatios.custom!),
    AspectRatioItem(text: "   ", value: CropAspectRatios.original),
    AspectRatioItem(text: "1*1", value: CropAspectRatios.ratio1_1),
    AspectRatioItem(text: "4*3", value: CropAspectRatios.ratio4_3),
    AspectRatioItem(text: "3*4", value: CropAspectRatios.ratio3_4),
    AspectRatioItem(text: "16*9", value: CropAspectRatios.ratio16_9),
    AspectRatioItem(text: "9*16", value: CropAspectRatios.ratio9_16)
  ];

  resize(x) async {
    sliderValue.value = x;

    imageLib.Image? _img = imageLib.decodeImage(_fileOriginal!);

    var h = _img!.height;
    var w = _img.width;
    var p = percentagem();
    var f = 1 + (p / 100);

    imageLib.Image _xmg =
        imageLib.copyResize(_img, height: (h * f) ~/ 1, width: (w * f) ~/ 1);

    imageSize.value = Size(_xmg.width + 0.0, _xmg.height + 0.0);

    provider = ExtendedMemoryImageProvider(
        Uint8List.fromList(imageLib.encodePng(_xmg)));
    setState(() {
      originalFile = false;
    });
  }

  ValueNotifier<Size> imageSize = ValueNotifier(Size(0, 0));

  AspectRatioItem? _aspectRatio;
  Widget _buildFunctions() {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.flip, size: sz),
          label: "",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.rotate_left, size: sz),
          label: "",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.rotate_right, size: sz),
          label: "",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_backup_restore, size: sz),
          label: "",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.filter, size: sz),
          label: "",
        ),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            flip();
            break;
          case 1:
            rotate(false);
            break;
          case 2:
            rotate(true);
            break;
          case 3:
            resetImage();
            break;
          case 4:
            goFilter();
            break;
        }
      },
      currentIndex: 0,
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Theme.of(context).primaryColor,
    );
  }

  goFilter() {
    crop(context, true);
  }

  int _aspectRatioSelected = 0;
  buildAspectRatios() {
    return SizedBox(
      height: 60.0,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(5.0),
        itemBuilder: (_, index) {
          var item = _aspectRatios[index];
          return InkWell(
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: (_aspectRatioSelected == index)
                          ? Colors.blue
                          : Colors.blue.withAlpha(30),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.image,
                        size: 42, color: Colors.white70),
                  ),
                ),
                Positioned(
                    left: 1,
                    top: 1,
                    right: 1,
                    bottom: 1,
                    child: Center(child: Text(item.text!))),
              ],
            ),
            onTap: () {
              _aspectRatioSelected = index;
              setState(() {
                _aspectRatio = item;
              });
            },
          );
        },
        itemCount: _aspectRatios.length,
      ),
    );
  }

  void crop(context, bool filter) async {
    final state = editorKey.currentState;
    final rect = state!.getCropRect();
    final action = state.editAction;
    final radian = action!.rotateAngle;

    final flipHorizontal = action.flipY;
    final flipVertical = action.flipX;
    // final img = await getImageFromEditorKey(editorKey);
    final img = state.rawImageData;

    ImageEditorOption option = ImageEditorOption();

    option.addOption(ClipOption.fromRect(rect!));
    option.addOption(
        FlipOption(horizontal: flipHorizontal, vertical: flipVertical));
    if (action.hasRotateAngle) {
      option.addOption(RotateOption(radian.toInt()));
    }

    option.outputFormat = const OutputFormat.png(88);

    //print(json.encode(option.toJson()));

    //final start = DateTime.now();
    // warm : The problem because flutter plugin(have native code) is not support hot restart/hot reload. So you must exit app and rerun.
    final Uint8List? result = await ImageEditor.editImage(
      image: img,
      imageEditorOption: option,
    );

    //print("result.length = ${result.length}");

    //final diff = DateTime.now().difference(start);

    //print("image_editor time : $diff");

    if ((!widget.useFilter) || (!filter)) {
      if (widget.onSelected != null) {
        widget.onSelected!(result!);
        Navigator.pop(context);
      }
    } else {
      _fileOriginal = result;
      showPreviewDialog(result!, okPressed: (bytes) {
        if (widget.onSelected != null) {
          widget.onSelected!(bytes);
          Navigator.pop(context);
        }
      });
    }
  }

  void flip() {
    editorKey.currentState!.flip();
  }

/*  static Future<Uint8List> getImageFromEditorKey(
      GlobalKey<ExtendedImageEditorState> editorKey) async {
    return editorKey.currentState.rawImageData;
  }
*/
  resetImage() {
    editorKey.currentState!.reset();
  }

  rotate(bool right) {
    editorKey.currentState!.rotate(right: right);
  }

  void showPreviewDialog(Uint8List image, {Function(Uint8List)? okPressed}) {
    //List<int> bytes = image.toList();
    showDialog(
      context: context,
      builder: (ctx) {
        return ImageFiltersWidget(
            filename: filterFileName ?? '_',
            image: image,
            okPressed: (bytes) {
              if (okPressed != null) okPressed(bytes);
            },
            onPressed: () {
              setState(() {
                selected = true;
              });
              Navigator.pop(context);
            });
      },
    );
  }

  void _pick() async {
    final result = await ImagePicker().pickFromCamera(imageQuality: 75);
    if (result != null) {
      _fileOriginal = result;
      provider = ExtendedMemoryImageProvider(result);
      setState(() {
        originalFile = false;
      });
    }
  }

  void _gallery() async {
    final result = await ImagePicker().pickFromGallary(imageQuality: 75);
    if (result != null) {
      _fileOriginal = result;
      provider = ExtendedMemoryImageProvider(result);

      setState(() {
        originalFile = false;
      });
    }
  }

  Directory? dir;
  Future<String> getPath({String name = 'resize1_'}) async {
    dir = dir ?? await getTemporaryDirectory();
    String f = '${dir!.path}/$name.jpg'.replaceAll(' ', '_');
    return f;

    ///?? '$name.jpg';
  }
}

class ImageFiltersWidget extends StatefulWidget {
  final Uint8List image;
  final Function(Uint8List) okPressed;
  final Function? onPressed;
  final String filename;
  const ImageFiltersWidget({
    Key? key,
    required this.okPressed,
    this.onPressed,
    required this.image,
    this.filename = 'captured.jpg',
  }) : super(key: key);

  @override
  _ImageFiltersWidgetState createState() => _ImageFiltersWidgetState();
}

class XFilter {
  final Filter filter;
  final String name;
  XFilter(this.filter, this.name);
}

class _ImageFiltersWidgetState extends State<ImageFiltersWidget> {
  List<Filter> filterToList() {
    List<Filter> rt = [];
    for (var f in filters) {
      rt.add(f.filter);
    }
    return rt;
  }

  final List<XFilter> filters = [
    XFilter(NoFilter(), 'Original'),
    //AddictiveBlueFilter(),
    XFilter(AddictiveRedFilter(), 'Vermelho'),
    //AdenFilter(),
    //AmaroFilter(),
    //AshbyFilter(),
    //BrannanFilter(),
    //BrooklynFilter(),
    //CharmesFilter(),
    //ClarendonFilter(),
    XFilter(CremaFilter(), 'Creme'),
    //DogpatchFilter(),
    //EarlybirdFilter(),
    //F1977Filter(),
    //GinghamFilter(),
    //GinzaFilter(),
    //HefeFilter(),
    //HelenaFilter(),
    //HudsonFilter(),
    //InkwellFilter(),
    //XFilter(JunoFilter(), 'Juno'),
    //KelvinFilter(),
    //LarkFilter(),
    //LoFiFilter(),
    //LudwigFilter(),
    //MavenFilter(),
    //XFilter(MayfairFilter(), 'Primavera'),
    //MoonFilter(),
    //NashvilleFilter(),*
    //PerpetuaFilter(),*
    XFilter(ReyesFilter(), 'Real'),
    //XFilter(RiseFilter(), 'Destaque'),
    //SierraFilter(),
    //SkylineFilter(),*
    //XFilter(SlumberFilter(), 'Sublime'),
    //StinsonFilter(),
    //SutroFilter(),*
    //ToasterFilter(),
    XFilter(ValenciaFilter(), 'Valência'),
    //VesperFilter(),
    //WaldenFilter(),
    XFilter(WillowFilter(), 'P&B'),
    //XProIIFilter(),
  ];

  imageLib.Image? image;
  @override
  void initState() {
    image = imageLib.decodeImage(widget.image.toList());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PhotoFilterEditor(
        title: const Text(''),
        image: image!,
        filters: filterToList(),
        loader: Container(),
        filename: 'filtered.jpg',
        circleShape: false, //widget.filename,
        okPressed: (bytes) {
          widget.okPressed(bytes);
          setState(() {
            image = imageLib.decodeImage(bytes.toList());
          });
          //Navigator.pop(context);
        },
      ),
    );
  }
}

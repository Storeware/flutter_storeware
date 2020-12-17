import 'package:controls_web/controls/dialogs_widgets.dart';
import 'package:flutter/material.dart';
import 'package:controls_web/controls/colores.dart';

class ColorPickerField extends StatelessWidget {
  final Color color;
  final Function(Color) onChanged;
  const ColorPickerField({Key key, this.color, this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (size.width > 550) size = Size(550, size.height);
    if (size.height > 550) size = Size(size.width, 550);
    Color _color = color;
    //ResponsiveInfo responsive = ResponsiveInfo(context);
    return (onChanged != null)
        ? StatefulBuilder(builder: (a, _setState) {
            return InkWell(
                child: CircleAvatar(
                  backgroundColor: _color,
                ),
                onTap: () {
                  Dialogs.showPage(
                    context,
                    width: size.width,
                    height: size.height,
                    child: ColorPickerDialog(
                      color: _color,
                      onChanged: (c) {
                        onChanged(c);
                        _setState(() {
                          _color = c;
                        });
                      },
                    ),
                  );
                });
          })
        : CircleAvatar(
            backgroundColor: color,
          );
  }
}

class ColorPickerDialog extends StatelessWidget {
  final List<Color> colors;
  final Color color;
  final Function(Color) onChanged;
  const ColorPickerDialog({Key key, this.colors, this.color, this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Color> _colors = colors ?? [];
    if (_colors.length == 0) {
      _colors = primariesColors;
    }
    return Scaffold(
      appBar: AppBar(title: Text('Selecionar uma cor')),
      body: LayoutBuilder(
        builder: (ctx, constraints) {
          int x = constraints.maxWidth ~/ 60;
          return GridView.count(
            crossAxisCount: x,
            children: [
              for (var item in _colors)
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: CircleAvatar(
                      backgroundColor: item,
                      child: (item == color)
                          ? Icon(Icons.check,
                              color: (item == Colors.red)
                                  ? Colors.white
                                  : Colors.red)
                          : Container(),
                    ),
                  ),
                  onTap: () {
                    if (onChanged != null) onChanged(item);
                    Navigator.of(context).pop();
                  },
                )
            ],
          );
        },
      ),
    );
  }
}

const List<Color> primariesColors = [
  Colors.red,
  Colors.pink,
  Colors.purple,
  Colors.deepPurple,
  Colors.indigo,
  Colors.blue,
  Colors.lightBlue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.lightGreen,
  Colors.lime,
  Colors.yellow,
  Colors.amber,
  Colors.orange,
  Colors.deepOrange,
  Colors.brown,
  // The grey swatch is intentionally omitted because when picking a color
  // randomly from this list to colorize an application, picking grey suddenly
  // makes the app look disabled.
  Colors.blueGrey,
  Colors.grey,
  Colors.white54,
  //...pastelColors,
  //...amethistColors,
];

extension ColorExtension on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';

  static Color intRGBToColor(num c, {Color def = Colors.blue}) {
    if (c is int) {
      Color cor;
      if (c != null) {
        String hex = '0xff' + (c.toInt().toRadixString(16));
        cor = hexToARGB(hex, def);
      } else
        cor = def;
      return cor;
    }
    return def;
  }

  static Color fromString(String str, {Color def}) => hexToARGB(str, def);
  int toRGBInt() {
    return int.parse('0x' + this.toHex(leadingHashSign: false).substring(2));
  }

  static Color hexToARGB(String str, Color def) {
    if (str == null || str == '') return def;
    Color g;
    if (str != null) g = dRGBColor(str);

    if (g != null) return g;
    g = getColorByName(str);
    if (g != Colors.transparent) return g;
    //print(str);
    Color c = def;
    try {
      if (str != null && str.startsWith('\$')) str = '0x' + str.substring(1);

      if (str != null && str.startsWith('0x')) {
        str = str.padRight(10, 'F');
        int i1 = int.parse(str.substring(2, 4), radix: 16);
        int i2 = int.parse(str.substring(4, 6), radix: 16);
        int i3 = int.parse(str.substring(6, 8), radix: 16);
        int i4 = int.parse(str.substring(8, 10), radix: 16);
        return Color.fromARGB((i1 == 0) ? 255 : i1, i2, i3, i4);
      }
    } catch (e) {
      //
    }
    return c;
  }

  toRGB() {
    return '\$00' + toHex(leadingHashSign: false).substring(2, 8);
  }
}

dRGBColor(cor) {
  if (cor.startsWith('cl')) {
    var r = getColorByName(cor.substring(2).toLowerCase());
    if (r != null) return r;
  }
  var c = {
    'clGray': Colors.grey,
    'clBlue': Colors.blue,
    'clGreen': Colors.green,
    'clYeallow': Colors.yellow,
    'clBlack': Colors.black,
    'clWhite': Colors.white,
    'clRed': Colors.red,
    'clLime': Colors.lime,
    'clIndigo': Colors.indigo,
    'clNavy': Colors.indigo,
    'clAqua': Colors.lightBlue,
    'clPink': Colors.pink,
    'clTeal': Colors.teal,
    'clPurple': Colors.purple,
  };
  return c[cor];
}

Color getColorByName(String name) {
  if (name == 'teal') return Colors.teal;
  if (name == 'tealAccent') return Colors.tealAccent;
  if (name == 'black') return Colors.black;
  if (name == 'grey') return Colors.grey;
  if (name == 'purple') return Colors.purple;
  if (name == 'purpleAccent') return Colors.purpleAccent;
  if (name == 'deepPurple') return Colors.deepPurple;
  if (name == 'orange') return Colors.orange;
  if (name == 'orangeAccent') return Colors.orangeAccent;
  if (name == 'deepOrange') return Colors.deepOrange;
  if (name == 'blue') return Colors.blue;
  if (name == 'blueAccent') return Colors.blueAccent;
  if (name == 'green') return Colors.green;
  if (name == 'greenAccent') return Colors.greenAccent;

  if (name == 'white') return Colors.white;
  if (name == 'pink') return Colors.pink;
  if (name == 'red') return Colors.red;
  if (name == 'redAccent') return Colors.redAccent;
  if (name == 'amber') return Colors.amber;
  if (name == 'amberAccent') return Colors.amberAccent;
  if (name == 'yellow') return Colors.yellow;
  if (name == 'yellowAccent') return Colors.yellowAccent;
  if (name == 'lime') return Colors.lime;
  if (name == 'limeAccent') return Colors.limeAccent;
  if (name == 'lightGreen') return Colors.lightGreen;
  if (name == 'lightBlue') return Colors.lightBlue;
  if (name == 'cyan') return Colors.cyan;
  if (name == 'cyanAccent') return Colors.cyanAccent;
  if (name == 'indigo') return Colors.indigo;
  if (name == 'indigoAccent') return Colors.indigoAccent;
  if (name == 'purple') return Colors.purple;
  if (name == 'azure') return Color.fromRGBO(254, 255, 255, 0.1);

  return Colors.transparent;
}

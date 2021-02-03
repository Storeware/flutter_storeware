import 'package:controls_web/controls/dialogs_widgets.dart';
import 'package:flutter/material.dart';
import 'package:universal_io/io.dart';

class MenuChoice {
  final IconData icon;
  final String title;
  final int index;
  final Function(BuildContext) builder;
  final bool enabled;
  final double width;
  final double height;
  MenuChoice({
    this.icon,
    this.title,
    this.index,
    this.enabled = true,
    this.builder,
    this.width,
    this.height,
  });
}

class MenuDialog extends StatefulWidget {
  final List<MenuChoice> choices;
  const MenuDialog({Key key, @required this.choices}) : super(key: key);

  @override
  _MenuDialogState createState() => _MenuDialogState();

  static show(context,
      {List<MenuChoice> choices,
      String title,
      double width = 300,
      double height,
      Color color}) async {
    var h = height ?? (kToolbarHeight * (choices.length + 1));
    if (Platform.isIOS || Platform.isAndroid || Platform.isFuchsia)
      h += kToolbarHeight;
    return Dialogs.showModal(context,
        title: title ?? 'Menu',
        width: width,
        height: h + 0.0,
        child: MenuDialog(
          choices: choices,
        ),
        color: color);
  }
}

extension _DoubleExt on double {
  min(double b) => (this > b) ? b : this;
}

class _MenuDialogState extends State<MenuDialog> {
  int itemSelect = 0;
//Cria uma listview com os itens do menu
  Widget _listMenu() {
    final double maxWidth = size.width;
    final double maxHeigth = size.height;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (var item in widget.choices)
          _tiles(item, item.title, item.icon, item.index, () {
            Navigator.pop(context);
            Dialogs.showPage(
              context,
              width: (item.width ?? maxWidth * 0.8).min(maxWidth),
              height: (item.height ?? maxHeigth * 0.8).min(maxHeigth),
              child: item.builder(context),
            );
          }),
      ],
    );
  }

//cria cada item do menu
  Widget _tiles(
      MenuChoice choice, String text, IconData icon, int item, Function onTap) {
    Color _color =
        choice.enabled ? theme.popupMenuTheme.color : theme.dividerColor;
    return ListTile(
        leading: (icon != null) ? Icon(icon) : null,
        onTap: choice.enabled ? onTap : null,
        selected: item == itemSelect,
        title: Align(
            alignment: Alignment.centerLeft,
            child: Material(
                child: Text(text,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: _color,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)))));
  }

  ThemeData theme;
  Size size;

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    size = MediaQuery.of(context).size;
    return Material(child: _listMenu());
  }
}

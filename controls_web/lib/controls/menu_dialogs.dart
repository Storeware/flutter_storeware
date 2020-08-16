import 'package:controls_web/controls/dialogs_widgets.dart';
import 'package:flutter/material.dart';
import 'package:universal_io/io.dart';

class MenuChoice {
  final IconData icon;
  final String title;
  final int index;
  final Function(BuildContext) builder;
  MenuChoice({
    this.icon,
    this.title,
    this.index,
    this.builder,
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
    if (Platform.isIOS) h += kToolbarHeight;
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

class _MenuDialogState extends State<MenuDialog> {
  int itemSelect = 0;

//Cria uma listview com os itens do menu
  Widget _listMenu() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (var item in widget.choices)
          _tiles(item.title, item.icon, item.index, () {
            Navigator.pop(context);
            Dialogs.showPage(context, child: item.builder(context));
          }),
      ],
    );
  }

//cria cada item do menu
  Widget _tiles(String text, IconData icon, int item, Function onTap) {
    return ListTile(
        leading: (icon != null) ? Icon(icon) : null,
        onTap: onTap,
        selected: item == itemSelect,
        title: Align(
            alignment: Alignment.centerLeft,
            child: MaterialButton(
                child: Text(text,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)))));
  }

  ThemeData theme;

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    return Material(child: _listMenu());
  }
}

import 'package:controls_web/controls/dialogs_widgets.dart';
import 'package:flutter/material.dart';

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
      double height = 200,
      Color color}) async {
    return Dialogs.showModal(context,
        title: title,
        width: width,
        height: height,
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
      leading: Icon(icon),
      onTap: onTap,
      selected: item == itemSelect,
      title: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(child: _listMenu());
  }
}

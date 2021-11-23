// @dart=2.12
import 'package:controls_web/controls/dialogs_widgets.dart';
import 'package:controls_web/controls/staggered_animation.dart';
import 'package:flutter/material.dart';
import 'package:universal_io/io.dart';

class MenuChoice {
  final IconData? icon;
  final String? title;
  final int? index;
  final Widget Function(BuildContext)? builder;
  final bool enabled;
  final double? width;
  final double? height;
  final List<Widget>? actions;
  final String? tooltip;
  MenuChoice({
    this.icon,
    this.title,
    this.index,
    this.enabled = true,
    this.builder,
    this.width,
    this.height,
    this.actions,
    this.tooltip,
  });
}

class MenuDialog extends StatefulWidget {
  final List<MenuChoice>? choices;
  final DialogsTransition? transition;
  final bool? closeMainDialog;
  const MenuDialog(
      {Key? key,
      @required this.choices,
      this.closeMainDialog = true,
      this.transition = DialogsTransition.menuDown})
      : super(key: key);

  @override
  _MenuDialogState createState() => _MenuDialogState();

  static show(
    context, {
    List<MenuChoice>? choices,
    String? title,
    double width = 300,
    double? height,
    Color? color,
    bool desktop = false,
    bool closeMainDialog = true,
    Alignment? transitionAlign = Alignment.topRight,
    DialogsTransition? transitionItem = DialogsTransition.menuRightDown,
  }) async {
    var h = height ?? (kToolbarHeight * (choices!.length + 1));
    if (Platform.isIOS || Platform.isAndroid || Platform.isFuchsia)
      h += kToolbarHeight;
    return Dialogs.showPage(
      context,
      width: width,
      desktop: desktop,
      alignment: Alignment.topRight,
      transition: DialogsTransition.menuTop,
      height: h + 0.0,
      transitionAlign: transitionAlign,
      barrierColor: Colors.black.withOpacity(0.05),
      child: Scaffold(
          appBar: AppBar(
            title: Text(title ?? 'Menu'),
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          ),
          body: MenuDialog(
            transition: transitionItem,
            closeMainDialog: closeMainDialog,
            choices: choices,
          )),
      //color: color
    );
  }
}

extension _DoubleExt on double {
  min(double b) => (this > b) ? b : this;
}

class _MenuDialogState extends State<MenuDialog> {
  int itemSelect = 0;
//Cria uma listview com os itens do menu
  Widget _listMenu() {
    final double maxWidth = size!.width;
    final double maxHeigth = size!.height;
    int i = 0;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (var item in widget.choices!)
          StaggeredAnimation(
              itemIndex: i++,
              child: _tiles(item, item.title, item.icon, item.index, () {
                if (widget.closeMainDialog!) Navigator.pop(context);
                Dialogs.showPage(
                  context,
                  transition: widget.transition!,
                  iconRight: true,
                  title: item.title!,
                  transitionDuration: 1000,
                  actions: item.actions,
                  width: (item.width ?? maxWidth * 0.8).min(maxWidth),
                  height: (item.height ?? maxHeigth * 0.8).min(maxHeigth),
                  child: (item.builder == null) ? null : item.builder!(context),
                );
              })),
      ],
    );
  }

//cria cada item do menu
  Widget _tiles(MenuChoice choice, String? text, IconData? icon, int? item,
      Function onTap) {
    Color? _color =
        choice.enabled ? theme!.popupMenuTheme.color : theme!.dividerColor;
    return ListTile(
      leading: (icon == null) ? null : Icon(icon),
      onTap: () => (choice.enabled ? onTap() : null),
      selected: item == itemSelect,
      title: Align(
        alignment: Alignment.centerLeft,
        child: (choice.tooltip == null)
            ? _tilesLabel(text, _color)
            : Tooltip(
                message: choice.tooltip!,
                child: _tilesLabel(text, _color),
              ),
      ),
    );
  }

  _tilesLabel(text, _color) {
    return Material(
      color: Colors.transparent,
      child: Text(text ?? '',
          textAlign: TextAlign.left,
          style: TextStyle(
              color: _color, fontWeight: FontWeight.bold, fontSize: 16)),
    );
  }

  ThemeData? theme;
  Size? size;

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    size = MediaQuery.of(context).size;
    return Material(child: _listMenu());
  }
}

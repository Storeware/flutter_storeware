import 'package:comum/widgets/widget_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

//import 'package:controls_web/controls.dart';
import '../config/config.dart';
import '../config/left_menu_items.dart';
import 'main_appbar.dart';
import 'main_drawer.dart';
import 'left_menu.dart';

class MainView extends StatefulWidget {
  MainView({Key? key}) : super(key: key);

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  bool intedLeftMenu = false;
  bool leftExpanded = true;
  @override
  Widget build(BuildContext context) {
    ConfigApp().mainContext = context;

    if (!intedLeftMenu) setExpanded(MediaQuery.of(context).size.width > 800);
    return Scaffold(
      drawer: Drawer(child: MainDrawer()),
      appBar: AppBar(
          title: MainAppBar(
              //title: 'Console',
              )),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          SafeArea(
              child: Wrap(
            spacing: 5,
            children: [for (var item in _createTopBars(context)) item],
          )),
          //..._createWidgets(context),
          SizedBox(
            height: 3,
          ),
          Container(height: 1, color: Colors.black12),
          SizedBox(
            height: 2,
          ),
          Expanded(
              child: Row(
            //mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              LeftMenuContainer(
                  visible: LeftMenuItems().visible,
                  children: LeftMenuItems().items,
                  expanded: leftExpanded,
                  onChange: (bool b) {
                    setState(() {
                      setExpanded(b);
                    });
                  }),
              Expanded(
                child: Wrap(
                  spacing: 2,
                  runSpacing: 2,
                  runAlignment: WrapAlignment.spaceBetween,
                  children: [..._createWidgets(context) ?? []],
                ),
              ),
            ],
          ))
        ]),
      ),
      persistentFooterButtons: <Widget>[..._createBottomNav(context)],
    );
  }

  void setExpanded(bool b) {
    leftExpanded = b;
    intedLeftMenu = true;
  }

  List<Widget> _createTopBars(context) {
    return [for (var item in WidgetData().headers) createItem(context, item)];
  }

  createItem(context, WidgetItem item) {
    print(item.title);
    return item.builder(context);
  }

  List<Widget>? _createWidgets(context) {
    List<Widget> rt = [];

    print('create items');
    for (var item in WidgetData().items) {
      print(item.title);
      if (item.active!)
        rt.add(
          Container(
              constraints: BoxConstraints(
                minWidth: 90,
                // maxWidth: 150,
                minHeight: 90,
                maxHeight: 90,
              ),
              padding: EdgeInsets.all(2),
              child: item.builder(context)),
        );
    }
    return rt;
  }
}

_createBottomNav(BuildContext context) {
  return [
    Container(
        height: 50,
        //color: Colors.grey,
        child: Wrap(
          children: <Widget>[
            for (var item in WidgetData().footers) item.builder(context),
          ],
        ))
  ];
}

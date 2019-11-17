import 'dart:convert';
import 'assets_files.dart';
import 'package:flutter/material.dart';
import 'package:controls/models/config_model.dart';
import 'package:controls/drivers.dart';

final translate = Translate._create();
final translateHistory = {};

class TranslateChangedBloc extends BlocModel<bool> {
  static final _singleton = TranslateChangedBloc._create();
  TranslateChangedBloc._create();
  factory TranslateChangedBloc() => _singleton;
}

class TranslateNotify extends StatelessWidget {
  final Function builder;
  const TranslateNotify({Key key,@required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: TranslateChangedBloc().stream,
      builder: (x,y){
        return this.builder();
      }
    );
  }
}

class Translate extends AssetsJson {
  Translate._create() {
    this.filename = 'intl/pt_br.json';
  }
  factory Translate() => translate;
  operator [](key) {
    String r = Translate.string(key);
    return r;
  }

  dispose() {
    String hist = json.encode(translateHistory);
    super.save('translate_history.json', hist);
    return this;
  }

  log(){
    String hist = json.encode(translateHistory);
    print([this.filename,hist]);  
  }

  static instance({String lang}) async {
    String l = lang ?? translate.filename;
    if (!l.contains('.')) l = 'intl/' + lang + '.json';
    try {
      print(['translate', l]);
      await translate.load(l);
      TranslateChangedBloc().notify(true);
    } catch (e) {
      /// nao faz nada
    }
    return translate;
  }

  static String string(String key) {
    String base = key.replaceAll(' ', '_').toLowerCase();
    var r = (translate.value(base) ?? '').toString();
    if (r.isEmpty)
      r = key.substring(0, 1).toUpperCase() +
          key.substring(1).replaceAll('_', ' ');
    translateHistory[base] = r;
    return r;
  }

  static String concat(List<String> lst) {
    String r = '';
    lst.forEach((f) {
      if (f.startsWith('_')) {
        r += f.substring(1);
      } else
        r += ' ' + Translate.string(f);
    });
    return r;
  }
}

class LangWidget extends StatefulWidget {
  final Function(String) onChanged;
  const LangWidget({Key key, this.onChanged}) : super(key: key);

  @override
  _LangWidgetState createState() => _LangWidgetState();
}

class _LangWidgetState extends State<LangWidget> {
  String _current;
  @override
  void initState() {
    _current = configModel.lang;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        color: Colors.transparent,
        child: new Center(
            child: new DropdownButton<String>(
          value: _current,
          items: getDropDownMenuItems(),
          onChanged: changedDropDownItem,
        )));
  }

  void changedDropDownItem(String selected) {
    print("Selected $selected, we are going to refresh the UI");
    configModel.lang = selected;
    configModel.save();
    Translate.instance(lang: selected);
    setState(() {
      _current = selected;
    });
    if (this.widget.onChanged != null) this.widget.onChanged(selected);
    RebuilderBloc().notify(selected);
  }

  getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = List();
    for (String item in configModel.langList) {
      items.add(DropdownMenuItem(value: item, child: new Text(item)));
    }
    return items;
  }
}

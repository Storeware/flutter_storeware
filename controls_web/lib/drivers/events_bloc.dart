import './bloc_model.dart';


class TopMessageEvent extends BlocModel<String> {
  static final _singleton = TopMessageEvent._create();
  TopMessageEvent._create();
  factory TopMessageEvent() => _singleton;
  static send(String texto) {
    _singleton.notify(texto);
  }
}


class BodyMessageEvent extends BlocModel<String> {
  static final _singleton = BodyMessageEvent._create();
  BodyMessageEvent._create();
  factory BodyMessageEvent() => _singleton;
  static send(String texto) {
    _singleton.notify(texto);
  }
}


class MainMessageEvent extends BlocModel<String> {
  static final _singleton = MainMessageEvent._create();
  MainMessageEvent._create();
  factory MainMessageEvent() => _singleton;
  static send(String texto) {
    _singleton.notify(texto);
  }
}


class BottomMessageEvent extends BlocModel<String> {
  static final _singleton = BottomMessageEvent._create();
  BottomMessageEvent._create();
  factory BottomMessageEvent() => _singleton;
  static send(String texto) {
    _singleton.notify(texto);
  }

  @override
  notify(String text, {int seconds = 30}) {
    sink.add(text);
    Future.delayed(Duration(seconds: seconds), () {
      sink.add('');
    });
  }
}

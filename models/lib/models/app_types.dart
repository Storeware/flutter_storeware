// @dart=2.12

class AppTypes {
  static final _singleton = AppTypes._create();
  AppTypes._create();
  factory AppTypes() => _singleton;
  final List<String> appTypes = [];
  bool contains(String value) {
    return appTypes.contains(value);
  }

  add(String value) {
    if (!contains(value)) appTypes.add(value);
  }

  get isPET => contains('pet');
  get hasContato => contains('agendaContato');
}

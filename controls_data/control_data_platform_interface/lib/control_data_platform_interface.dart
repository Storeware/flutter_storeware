library control_data_platform_interface;

abstract class LocalStorageInterface {
  init();
  setKey(String key, String value);
  String getKey(String key);
  dispose() {}

  setBool(String key, bool value) => setKey(key, value ? 'true' : 'false');
  bool getBool(String key) => ((getKey(key) ?? 'false') == 'true');

  String getString(String key) => getKey(key);
  setString(String key, String value) => setKey(key, value);

  num getNum(String key) => num.tryParse(getKey(key));
  setNum(String key, num value) => setKey(key, value.toString());

  int getInt(String key) => int.tryParse(getKey(key));
  setInt(key, value) => setKey(key, value.toString());
}

abstract class LocalStorageInterface {
  init();
  setKey(String key, String value);
  String getKey(String key);
  dispose();
  getBool(String key) {
    return (getKey(key) ?? '0') == '1';
  }

  setBool(String key, bool value) {
    setKey(key, value ? '1' : '0');
  }
}

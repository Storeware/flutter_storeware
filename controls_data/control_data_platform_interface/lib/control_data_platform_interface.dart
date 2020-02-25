library control_data_platform_interface;

abstract class LocalStorageInterface {
  init();
  setKey(String key, String value);
  String getKey(String key);
  dispose();
  setBool(String key, bool value) {
    return setKey(key, value ? 'true' : 'false');
  }

  getBool(String key) {
    return ((getKey(key) ?? 'false') == 'true');
  }
}

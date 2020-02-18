abstract class LocalStorageInterface {
  init();
  setKey(String key, String value);
  String getKey(String key);
  dispose();
}

//import 'dart:html';
import "dart:convert";


abstract class LocalStorageModel{
    LocalStorage storage = LocalStorage();
    String storageName;
    Map<String,dynamic> toJson();
    String toString(){
       return json.encode( toJson() );  
    } 
    fromMap(Map<String,dynamic> map);

    save(){
       print(['Save',toString()]);
       storage.setKey(storageName, toString());
       return this;
    }
    restore(){
      String s = storage.getKey(storageName)??'{}';
      fromMap( json.decode(s)??[] );
      print(['Restore',s]);
      return this;
    }
}

class LocalStorage {
  static final _singleton = LocalStorage._create();
  //final Storage _localStorage = window.localStorage;
  final Map<String,dynamic> _localStorage = {};
  LocalStorage._create();
  factory LocalStorage() => _singleton;

  Future setKey(key, value) async {
    _localStorage[key] = value;
  }

  getKey(key)  {
    return _localStorage[key];
  }

  remove(key) async {
    _localStorage.remove(key);
    return this;
  }

  clear() {
    _localStorage.clear();
    return this;
  }

  get length => _localStorage.length;

  get keys => _localStorage.keys;

  get values => _localStorage.values;

  containsKey(key) => _localStorage.containsKey(key);
  containsValue(value) => _localStorage.containsValue(value);
  addAll(Map<String, String> other) {
    _localStorage.addAll(other);
    return this;
  }
  get storage=>_localStorage;
  
}

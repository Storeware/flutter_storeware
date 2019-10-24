import 'dart:html';
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
       //print(['Save',toString()]);
       storage.setKey(storageName, toString());
       return this;
    }
    restore(){
      String s = storage.getKey(storageName)??'{}';
      fromMap( json.decode(s)??[] );
      //print(['Restore',s]);
      return this;
    }
}

class LocalStorage {
  static final _singleton = LocalStorage._create();
  final Storage _localStorage = window.localStorage;
  LocalStorage._create();
  factory LocalStorage() => _singleton;

  Future setKey(key, value) async {
    _localStorage[key] = value;
  }

  setBool(key,bool value){
     var v =  value?'true':'false';
    _localStorage[key]=value.toString();
  }
  getBool(key){
    var r = _localStorage[key]??'false';
    return (r=='true'?true:false) ;
  }

  setJson(key,Map<String,dynamic> values){
    var s = jsonEncode(values);
    return setKey(key,s);
  }
  Map<String,dynamic> getJson(key){
    var s = getKey(key);
    return jsonDecode(s);
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

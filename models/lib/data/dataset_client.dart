import 'dart:async';
import 'dart:convert' as CONVERT;


class DatasetClient<T extends Fields> {
  List<T> items = [];
  bool _eof = true;
  bool _bof = true;
  int _current = -1;
  FieldsChange<Fields> dataChangeEvent = FieldsChange<Fields>();

  add(T item) {
    items.add(item);
    last();
    return this;
  }

  int _validCurrent(int p) {
    var _old = _current;
    var l = length;
    _current += p;
    _bof = _current < 0;
    _eof = _current >= l;
    if (l == 0) {
      _current = -1;
      _bof = true;
      _eof = true;
    } else {
      if (_current >= l) _current = l - 1;
      if (_current < 0) _current = 0;
    }
    if (_old != _current) dataChangeEvent.notify(fields);
    return _current;
  }

  int get length => items.length;
  T get fields {
    _validCurrent(0);
    return items[_current];
  }

  fieldByName(name) {
    return fields.fieldByName(name);
  }

  fieldByNumber(int item) {
    return fields.fieldByNumber(item);
  }

  T last() {
    _current = length;
    _validCurrent(0);
    return items[_current];
  }

  get eof => _eof;
  get bof => _bof;

  T next() {
    _validCurrent(1);
    return fields;
  }

  T prior() {
    _validCurrent(-1);
    return fields;
  }

  T first() {
    _current = 0;
    _validCurrent(0);
    return fields;
  }

  T append(T item) {
    add(item);
    return item;
  }
}


class Field{
   String fieldName;
   dynamic value;
   String get asString => value.toString();
   set asString(v) { value = v.toString(); }
   double get asDouble => double.tryParse(asString);
   set asDouble(v) { value = double.tryParse(v.toString());}
   int get asInteger => int.tryParse(asString);
   set asInteger(int v) { value = int.tryParse(v.toString());}
   Map<String,dynamic> toJson(){
     return {"fieldName":fieldName,"value":value};
   }
}

class Fields {
  int rowid;
  Map<String, dynamic> _data = {};
  fromJson(Map<String, dynamic> json) {
    return this;
  }

  Map<String, dynamic> toJson() {
    return {};
  }

  String get json => CONVERT.json.encode(toJson());
  String asText( { names = '' } ) {
    String r='';
    _update().forEach((k,v){
      if (names=='' ||  names.contains(k)   )
      {
       r += (r==''?'':', ')+' $k: $v ';  
      }
    });
    return r;
  }
  fieldByName(name) {
    _data = toJson();
    return _data[name];
  }
  fieldByNumber(int item) {
    return values.toList()[item];
  }
  Map<String,dynamic> _update(){
    _data = toJson();
    return _data;
  }
  get keys {  return _update().keys;}
  get values => _update().values;
  List<Field> get toList {
    var r = [];
    _update().forEach((k,v){
      var f = Field();
      f.fieldName = k;
      f.value = v;
      r.add(f);
    });
    return r;
  }
}

class FieldsChange<T> {
  var _stream = StreamController<T>.broadcast();
  dispose() {
    _stream.close();
  }

  notify(T item) {
    _stream.sink.add(item);
  }

  get stream => _stream.stream;
}


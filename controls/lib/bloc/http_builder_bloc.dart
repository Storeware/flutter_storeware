import 'dart:async';
import 'dart:convert';
import 'firebase_model.dart';
import 'package:http/http.dart' as http;


class BLoCHttpApi{

  Future<String> encodeUrl(String servico) async{
    var r = await FirebaseModel.getCloudFunctionUrl(servico);
    return r;
  }

   get(String servico, {Map<String,String> headers}) async{

    String url = servico;

    var rt = http.get(url,headers:headers )
    .then ((res)=> res.body)
        .then(json.decode)
        .then((json)=> json['value'])
        .then( (values) => jsonDecode( values ) );

    //print(rt);

    return rt;

  }


}
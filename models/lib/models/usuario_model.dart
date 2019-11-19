
import '../data/data_model.dart';

class UsuarioItem extends DataItem {
  String idLogin="";
  String codigo = "";
  String nome = "";
  String caixa = "";
  int filial = 0;
  String funcao = "";
  int inativo = 0;
  String grupo = "";
  int sigven = 0;
  int clifor = 0;
  String vendedor = "";
  static create(){
    return UsuarioItem();
  }
  @override  
  fromJson(js){
    nome = js['nome'];
    codigo = js['codigo'];
    grupo = js['grupo']; // acessos
    filial = js['filial'];
    return this;
  }
  @override
  toJson(){
    var r = {"codigo":codigo,"nome":nome,"grupo":grupo,"filial":filial};
    return r;
  }
}

class UsuarioModel extends DataModel{
  
}

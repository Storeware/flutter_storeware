import 'package:models/models/usuarios_model.dart';

enum TipoAcesso { todos, admin, gestor, adminGestor, operador, leitura }

class Acesso {
  num id;
  String nome;
  TipoAcesso tipo;
  List<Acesso> items = [];
  Acesso({this.id, this.nome, this.tipo});
  addOrReplace(Acesso item) {
    int index = indexOf(item.id);
    if (index < 0) {
      items.add(item);
      return item;
    }
    return items[index].fromMap(item.toJson());
  }

  int indexOf(num id) {
    for (var i = 0; i < items.length; i++) {
      if (items[i].id == id) return i;
    }
    return -1;
  }

  fromMap(Map<String, dynamic> json) {
    this.id = json['id'];
    this.nome = json['nome'];
    this.tipo = TipoAcesso.values[json['tipo'] ?? 0];
    return this;
  }

  toJson() {
    return {"id": id, "nome": nome, "tipo": tipo.index};
  }

  /// usado durante a carga do app, não subsitui cargas já feitas
  register(String nome, num id, TipoAcesso tipo) {
    if (indexOf(id) < 0)
      return addOrReplace(Acesso(nome: nome, id: id, tipo: tipo));
  }

  get key => id;
  get name => nome;
  List<num> get keys => [for (var i = 0; i < items.length; i++) items[i].id];
  List<String> get names =>
      [for (var i = 0; i < items.length; i++) items[i].nome];
  operator [](num id) => findOf(id);
  findOf(num id) {
    int index = indexOf(id);
    if (index >= 0) return items[index];
    if (items.length > 0)
      for (var i = 0; i < items.length; i++) {
        var item = items[i].findOf(id);
        if (item != null) return item;
      }
    return null;
  }
}

/// [Acessos] habilita ou desliga acessibilidade
class Acessos {
  static final _singleton = Acessos._create();
  Acessos._create();
  factory Acessos() => _singleton;
  SenhasItem dadosUsuario = SenhasItem.fromJson({"grupo": 'Operador'});
  List<Acesso> acessos = [
    Acesso(
      id: 0,
      nome: 'Principal',
      tipo: TipoAcesso.todos,
    )
  ];
  int indexOf(num id) {
    for (var i = 0; i < acessos.length; i++) {
      if (acessos[i].id == id) return i;
    }
    return -1;
  }

  findOf(num id) {
    return findFirst(id);
  }

  Acesso findFirst(num id) {
    for (var i = 0; i < acessos.length; i++) {
      if (acessos[i].id == id) return acessos[i];
      var item = acessos[i].findOf(id);
      if (item != null) return item;
    }
    return null;
  }

  static bool habilitado(num id) {
    // procura o item
    var ac = Acessos();
    Acesso item = ac.findFirst(id);
    TipoAcesso tipo = item?.tipo ?? TipoAcesso.todos;
    switch (tipo) {
      case TipoAcesso.admin:
        return ac.dadosUsuario.isAdmin;
        break;
      case TipoAcesso.gestor:
        return ac.dadosUsuario.isGestor;
        break;
      case TipoAcesso.adminGestor:
        return ac.dadosUsuario.isAdmin || ac.dadosUsuario.isGestor;
        break;
      case TipoAcesso.operador:
        return ac.dadosUsuario.isOperador ||
            ac.dadosUsuario.isAdmin ||
            ac.dadosUsuario.isGestor;
        break;
      case TipoAcesso.leitura:
        return !ac.dadosUsuario.isReadOnly;
        break;

      default:
        return true;
    }
  }

  /// registrar o acesso caso ainda não esteja na lista
  /// usado para auto-registro das rotinas - nao usar para carga de configuração inicial
  static register(num pai, String nome, num acesso, TipoAcesso tipo) {
    // procura o pai
    var ac = Acessos();
    Acesso itemPai = ac.findFirst(pai) ?? ac.acessos[0];
    if (itemPai.indexOf(acesso) < 0) {
      var item = Acesso(nome: nome, id: acesso, tipo: tipo);
      return itemPai.addOrReplace(item);
    }
    return itemPai;
  }

  /// atualiza o acesso na lista de registro, se existir substitui
  /// usado para carregar as configurações de usuario
  /// usar para carga inicial
  static addOrReplace(num pai, String nome, num acesso, TipoAcesso tipo) {
    /// permite o mesmo id estar ligado a dois pais.
    var ac = Acessos();
    var itemPai = ac.findFirst(pai) ?? ac.acessos[0];
    itemPai.addOrReplace(Acesso(nome: nome, id: acesso, tipo: tipo));
    return itemPai;
  }

  operator [](num id) => _singleton.findFirst(id);
  static String name(num id) => _singleton.findFirst(id)?.nome;
}

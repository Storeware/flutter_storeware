// @dart=2.12
import 'package:flutter_storeware/login.dart';

class AgendaAcessos {
  static register() {
    var it =
        Acessos.register(0, acesso_Agenda_Studio, 'Agenda', TipoAcesso.todos);
    it.register(acesso_Agenda_Recurso, 'Cadastro de Recursos',
        TipoAcesso.adminOrGestor);
    it.register(acesso_Agenda_Tipo, 'Cadastro de Tipos de Agenda',
        TipoAcesso.adminOrGestor);
    it.register(acesso_Agenda_Estado, 'Cadastro de Estados da Agenda',
        TipoAcesso.adminOrGestor);
  }
}

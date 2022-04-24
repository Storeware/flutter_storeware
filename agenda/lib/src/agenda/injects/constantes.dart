// @dart=2.12
import 'package:models/models.dart';

const String injectAgendaEditHeader = 'AgendaEditHeader';
const String injectAgendaEditPosTitulo = 'AgendaEditPosTitulo';
const String injectAgendaEditBottom = 'AgendaEditBottom';

final labelContatoAgenda =
    (AppTypes().isPET) ? 'Tutor ou Proprietário' : 'Contato';
final identificacaoContatoObrigatorio = (AppTypes().isPET);

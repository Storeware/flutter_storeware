import 'package:models/models/eventos_item_model.dart';

class HistoricoItem extends EventosItemItem {
  @override
  Map<String, dynamic> toJson() {
    final rsp = super.toJson();
    return rsp;
  }
}

class HistoricoItemModel extends EventosItemItemModel {
  HistoricoItemModel() : super() {
    //API = CloudV3().client;
  }
  HistoricoItem newItem() => HistoricoItem();

  static register({
    String dcto,
    String autor,
    String titulo,
    String tabela,
    double tabelaId,
    String tabelaGid,
    String texto,
    String arquivado,
    double idmaster,
    double cliente,
    double valor,
    double ordem,
    String master,
    String masterGid,
    DateTime dataLimite,
  }) {
    final item = HistoricoItem();
    item.dcto = dcto;
    item.autor = autor;
    item.arquivado = arquivado;
    item.data = DateTime.now();
    item.tabela = tabela;
    item.titulo = titulo;
    item.idtabela = tabelaId;
    item.tabelaGid = tabelaGid;
    item.obs = texto;
    item.pessoa = autor;
    item.usuario = autor;
    item.idmaster = idmaster;
    item.cliente = cliente;
    item.valor = valor;
    item.ordemtabela = ordem;
    item.master = master;
    item.masterGid = masterGid;
    item.datalimite = dataLimite;
    return HistoricoItemModel().post(item.toJson());
  }

  static registerLGPD(
      {double codigoPessoa,
      String titulo,
      String info,
      String origem,
      String usuario,
      String origemGid,
      double origemId,
      String dcto,
      int dias}) {
    return HistoricoItemModel.register(
      arquivado: 'S',
      autor: usuario,
      tabela: origem,
      tabelaGid: origemGid,
      tabelaId: origemId,
      texto: info,
      titulo: titulo,
      dcto: dcto,
      cliente: codigoPessoa,
      master: 'SIGCAD',
      idmaster: codigoPessoa,
      dataLimite: DateTime.now().add(Duration(days: dias ?? (365 * 2))),
    );
  }
}

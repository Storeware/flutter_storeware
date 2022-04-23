// @dart=2.12

import 'package:controls_data/odata_client.dart';
import 'package:controls_data/odata_firestore.dart';
import 'package:models/models.dart';

class ContatoItem extends SigcadItem {
  static get keys => SigcadItem.fromJson({}).toJson().keys;
  get exists => (codigo ?? 0) > 0;
}

final Map<double?, SigcadItem> sigcadCheched = {};

class ContatoItemModel extends ODataModelClass<ContatoItem> {
  ContatoItemModel() {
    collectionName = 'sigcad';
    super.API = ODataInst();
    super.CC = CloudV3().client..client.silent = true;

    columns = ContatoItem.keys.join(',');
  }
  ContatoItem newItem() => ContatoItem();

  /// [listRows] permite paginação dos registros.
  Future<ODataResult> listRows(
      {filter, select, orderBy = 'nome', top = 20, skip = 0}) {
    var cols = select ??
        'codigo,nome,tipo,terminal,filial,celular,cidade,bairro,ender,numero,cep,estado,cnpj,email';

    return search(
        resource: 'sigcad',
        select: cols,
        filter: filter,
        top: top,
        orderBy: orderBy,
        skip: skip);
  }

  Future<SigcadItem> buscarPorCodigo(num? codigo) async {
    var ch = sigcadCheched[codigo as double];
    if (ch != null) return ch;
    return getOne(filter: 'codigo eq $codigo').then((rsp) {
      sigcadCheched[codigo] = SigcadItem.fromJson(rsp!);
      return sigcadCheched[codigo]!;
    });
  }
}

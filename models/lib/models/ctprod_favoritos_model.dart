import 'package:controls_data/data_model.dart';
import 'package:controls_data/odata_client.dart';

class CtprodFavoritosItem extends DataItem {
  String? codigo;
  double? filial;
  int? curtidas;
  int? visualizados;

  CtprodFavoritosItem(
      {this.codigo, this.filial, this.curtidas, this.visualizados});

  CtprodFavoritosItem.fromJson(Map<String, dynamic> json) {
    fromMap(json);
  }
  @override
  fromMap(Map<String, dynamic> json) {
    codigo = json['codigo'];
    filial = toDouble(json['filial']);
    curtidas = json['curtidas'];
    visualizados = json['visualizados'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['codigo'] = this.codigo;
    data['filial'] = this.filial;
    data['curtidas'] = this.curtidas;
    data['visualizados'] = this.visualizados;
    data['id'] = '$filial-$codigo';
    return data;
  }
}

class CtprodFavoritosItemModel extends ODataModelClass<CtprodFavoritosItem> {
  CtprodFavoritosItemModel() {
    collectionName = 'ctprod_favoritos';
    super.API = ODataInst();
  }
  CtprodFavoritosItem newItem() => CtprodFavoritosItem();

  rankSum() {
    //String qry = "SELECT sum( CURTIDAS) curtidas, " +
    //    "sum(VISUALIZADOS) visualizados " +
    //    "FROM CTPROD_FAVORITOS a ";
    return search(
            resource: 'ctprod_favoritos',
            select: 'sum( CURTIDAS) curtidas,sum(VISUALIZADOS) visualizados')
        .then((rsp) => rsp.asMap());
  }

  listRank({filter, top = 20, skip, orderBy}) {
    return search(
            resource: 'ctprod_favoritos a',
            select: 'a.codigo,b.nome, a.curtidas,a.visualizados',
            top: top,
            join: 'join ctprod b on (b.codigo=a.codigo)',
            skip: skip,
            orderBy: orderBy)
        .then((rsp) => rsp.asMap());
  }
}

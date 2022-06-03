import 'package:controls_data/data_model.dart';
import 'package:controls_data/odata_client.dart';

class CategoriasItem extends DataItem {
  int? codigo;
  String? nome;
  int? prioridade;
  double? qtdeSelecionavel;
  String? codigoPai;
  String? bmp;
  CategoriasItem({this.codigo, this.nome, this.prioridade});

  CategoriasItem.fromJson(Map<String, dynamic> json) {
    fromMap(json);
  }
  @override
  fromMap(Map<String, dynamic> json) {
    codigo = json['codigo'];
    nome = json['nome'];
    prioridade = json['prioridade'];
    qtdeSelecionavel = json['qtde_selecionavel'] ?? 0;
    codigoPai = json['codigo_pai'];
    bmp = json['bmp'];
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['codigo'] = this.codigo;
    data['nome'] = this.nome;
    data['prioridade'] = this.prioridade;
    data['codigo_pai'] = this.codigoPai;
    data['qtde_selecionavel'] = this.qtdeSelecionavel;
    data['bmp'] = this.bmp;
    return data;
  }
}

class CategoriasItemModel extends ODataModelClass<CategoriasItem> {
  CategoriasItemModel() {
    collectionName = 'ctprod_atalho_titulo';
    API = ODataInst();
    columns = 'codigo,nome,codigo_pai,prioridade,qtde_selecionavel,bmp';
  }
  CategoriasItem newItem() => CategoriasItem();

  Future<ODataResult> listBy() async {
    return search(filter: "codigo_pai is null ", orderBy: 'prioridade');
  }

  Future<List<dynamic>> listByCodigoPai(double codigoPai) async {
    return listNoCached(
      resource: 'web_ctprod_atalho_titulo_comb',
      filter: ' codigo_pai eq $codigoPai and codigo<>$codigoPai',
      orderBy: 'prioridade',
      select: '*',
    ).then((rsp) {
      //  print(rsp);
      return rsp;
    });
  }
}

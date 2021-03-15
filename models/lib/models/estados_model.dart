import 'package:controls_data/data_model.dart';
import 'package:controls_data/odata_client.dart';
import 'package:controls_extensions/extensions.dart';

class EstadosItem extends DataItem {
  double? aliqicms;
  String? nome;
  String? sigla;
  double? redbaseicms;
  double? aliqicmsinterna;
  String? regiao;
  double? codigoibgeUf;
  double? partilhaPfcpufdest;
  double? partilhaPicmsufdest;
  double? partilhaPicmsinterpart;

  EstadosItem(
      {this.aliqicms,
      this.nome,
      this.sigla,
      this.redbaseicms,
      this.aliqicmsinterna,
      this.regiao,
      this.codigoibgeUf,
      this.partilhaPfcpufdest,
      this.partilhaPicmsufdest,
      this.partilhaPicmsinterpart});

  EstadosItem.fromJson(Map<String, dynamic> json) {
    fromMap(json);
  }
  @override
  fromMap(Map<String, dynamic> json) {
    aliqicms.from(json['aliqicms']);
    nome.from(json['nome']);
    sigla.from(json['sigla']);
    redbaseicms.from(json['redbaseicms']);
    aliqicmsinterna.from(json['aliqicmsinterna']);
    regiao.from(json['regiao']);
    codigoibgeUf.from(json['codigoibge_uf']);
    partilhaPfcpufdest.from(json['partilha_pfcpufdest']);
    partilhaPicmsufdest.from(json['partilha_picmsufdest']);
    partilhaPicmsinterpart.from(json['partilha_picmsinterpart']);
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['aliqicms'] = this.aliqicms;
    data['nome'] = this.nome;
    data['sigla'] = this.sigla;
    data['redbaseicms'] = this.redbaseicms;
    data['aliqicmsinterna'] = this.aliqicmsinterna;
    data['regiao'] = this.regiao;
    data['codigoibge_uf'] = this.codigoibgeUf;
    data['partilha_pfcpufdest'] = this.partilhaPfcpufdest;
    data['partilha_picmsufdest'] = this.partilhaPicmsufdest;
    data['partilha_picmsinterpart'] = this.partilhaPicmsinterpart;
    return data;
  }
}

class EstadosItemModel extends ODataModelClass<EstadosItem> {
  EstadosItemModel() {
    collectionName = 'estados';
    super.API = ODataInst();
  }
  EstadosItem newItem() => EstadosItem();
  procurar(String uf) async {
    return await listCached().then((rsp) {
      var r = rsp.where((r) => r['sigla'] == uf);
      return r.first;
    });
  }
}

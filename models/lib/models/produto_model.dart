
import '../data.dart';

class ProdutoItem extends DataItem {
  String codigo;
  String nome;
  String unidade;
  String nfCodicms;
  String nfCodpis;
  String nfCodcofins;
  String nfCodipi;
  String ncm;
  String bmp;
  double filial;
  double precovenda;
  double qtde;
  clear(){
    this.codigo='';
    this.nome = '';
    this.precovenda = 0;
    this.qtde = 0;
    this.filial = 0;
    this.unidade = '';
    this.nfCodcofins = '';
    this.nfCodicms = '';
    this.nfCodipi = '';
    this.nfCodpis = '';
    this.bmp = '';
    this.ncm = '';
    return this;
  }
  ProdutoItem(
      {this.codigo,
      this.nome,
      this.unidade,
      this.nfCodicms,
      this.nfCodpis,
      this.nfCodcofins,
      this.nfCodipi,
      this.ncm,
      this.bmp,
      this.filial,
      this.precovenda,
      this.qtde});

  @override
  fromJson(Map<String, dynamic> json) {
    print(json);
    this.codigo = json['codigo'];
    this.nome = json['nome'];
    this.unidade = json['unidade'];
    this.nfCodicms = json['nf_codicms'];
    this.nfCodpis = json['nf_codpis'];
    this.nfCodcofins = json['nf_codcofins'];
    this.nfCodipi = json['nf_codipi'];
    this.ncm = json['ncm'];
    this.bmp = json['bmp'];
    this.filial = double.tryParse(json['filial'].toString());
    this.precovenda = double.tryParse(json['precovenda'].toString());
    this.qtde = double.tryParse(json['qtde'].toString());
    return this;
  }
  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['codigo'] = this.codigo;
    data['nome'] = this.nome;
    data['unidade'] = this.unidade;
    data['nf_codicms'] = this.nfCodicms;
    data['nf_codpis'] = this.nfCodpis;
    data['nf_codcofins'] = this.nfCodcofins;
    data['nf_codipi'] = this.nfCodipi;
    data['ncm'] = this.ncm;
    data['bmp'] = this.bmp;
    data['filial'] = this.filial;
    data['precovenda'] = this.precovenda;
    data['qtde'] = this.qtde;
    return data;
  }

  String asText() { return this.nome;}
}

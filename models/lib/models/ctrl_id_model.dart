// @dart=2.12
import 'dart:convert';

import 'package:controls_data/data_model.dart';
import 'package:controls_data/odata_client.dart';

class CtrlIdItem extends DataItem {
  String? nome;
  double? numero;
  int? status;
  double? valor;

  CtrlIdItem({this.nome, this.numero, this.status, this.valor});

  CtrlIdItem.fromJson(Map<String, dynamic> json) {
    fromMap(json);
  }
  @override
  fromMap(Map<String, dynamic> json) {
    nome = json['nome'];
    numero = toDouble(json['numero']);
    status = toInt(json['status']);
    valor = toDouble(json['valor']);
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nome'] = this.nome;
    data['numero'] = this.numero;
    data['status'] = this.status;
    data['valor'] = this.valor;
    return data;
  }
}

class CtrlIdItemModel extends ODataModelClass<CtrlIdItem> {
  CtrlIdItemModel() {
    collectionName = 'ctrl_id';
    super.API = ODataInst();
  }
  CtrlIdItem newItem() => CtrlIdItem();

  static Future<CtrlIdItem> proximo(String nome) async {
    if (CtrlIdItemModel().driver == 'mssql') {
      return CtrlIdItemModel().API!.execute("""
begin
  DECLARE	@return_value int;
  EXEC	@return_value = [dbo].[proc_ObterID] '$nome', 1
  SELECT '$nome' as nome,	@return_value as 'numero'
end""").then((rsp) {
        var j = jsonDecode(rsp);
        return CtrlIdItem.fromJson(j['result'][0]);
      });
    } else
      return CtrlIdItemModel()
          .API!
          .openJson("select * from obter_id('$nome')")
          .then((rsp) {
        return CtrlIdItem.fromJson(rsp['result'][0]);
      });
  }

  static Future<double> proximoNumero(String nome, double filial) async {
    return CtrlIdItemModel.proximo(nome).then((rsp) {
      if (filial > 0)
        return (rsp.numero! * 1000) + filial;
      else
        return rsp.numero!;
    });
  }
}

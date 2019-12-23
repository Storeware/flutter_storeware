import 'package:controls_data/data_model.dart';
import 'package:controls_data/odata_client.dart';

String cloudBaseUrl;
String cloudPrefix = '/lojas/{project}';
String cloudProject;

abstract class CloudModelClass<T extends DataModelItem> {
  String collectionName;
  ODataClient client = ODataClient();
  static project(id) {
    cloudProject = id;
  }

  set baseUrl(b) {
    client.baseUrl = b;
    print('url: $b');
  }

  get baseUrl => client.baseUrl;

  formatCollection(nome) {
    collectionName = nome;
    client.prefix = cloudPrefix.replaceAll('{project}', cloudProject ?? 'null');
    client.baseUrl = cloudBaseUrl;
    return nome;
  }

  T createItem();

  snapshots({bool inativo}) async {
    return client
        .send(ODataQuery(
          resource: collectionName,
          select: '*',
          filter: "inativo eq $inativo",
        ))
        .then((data) => ODataResult(json: data));
  }

  getAll({String select = '*', String filter}) async {
    return await client
        .send(ODataQuery(
      resource: collectionName,
      select: select,
      filter: filter,
    ))
        .then((query) {
      return ODataResult(json: query);
    });
  }

  enviar(T dados) async {
    if (dados.isDeleting)
      return await delete(dados);
    else if (dados.isEditing)
      return await post(dados);
    else if (dados.isInserting)
      return await put(dados);
    else {
      print('Não definiu o tipo de operação com os dados');
      return null;
    }
  }

  getOne(String id) async {
    return await client.getOne('$collectionName/$id').then((query) {
      return ODataResult(json: query);
    });
  }

  post(T dados) {
    return client.post('$collectionName/${dados.id}', dados.toJson());
  }

  put(T dados) {
    return client.put('$collectionName/${dados.id}', dados.toJson());
  }

  delete(T dados) {
    return client.delete('$collectionName/${dados.id}', dados.toJson());
  }
}

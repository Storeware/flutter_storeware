// @dart=2.12

class StoreModel {
  imagePgtoAssets(String? fp) {
    if ('110,111,112,114,116,121,123'.contains((fp ?? '000').substring(0, 2)))
      return 'assets/$fp.png';
    return 'assets/nav/pgto_000.png';
  }
}

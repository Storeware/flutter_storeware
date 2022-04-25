// import test
import 'package:controls_data/data.dart';
import 'package:flutter_test/flutter_test.dart';

import 'testar_search_form_builder.dart';

void main() async {
  var rest = ODataInst();
  await rest.login('m0', 'm0', 'm0').then((r) {
    group('search form builder: ', () {
      builderTest();
    });
  });
}

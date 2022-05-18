// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:models/builders.dart';
//import 'package:get/get.dart';

runApp(Widget wg) {
  return MaterialApp(
    home: Material(child: wg),
  );
}

builderTest(DioAdapter adapter) {
  testWidgets("test Atalhos", (WidgetTester tester) async {
    await tester.pumpWidget(
      runApp(AtalhosSearchFormField()),
    );
    var r = await tester.pump();
    var f = find.byType(IconButton);
    expect(f, findsNothing,
        reason: 'esperado nao tem um icone de busca, nao ativou onSearch');
    f = find.byType(TextField);
    expect(f, findsOneWidget);
    expect(f, isNotNull, reason: 'não achou um TextField no objeto de busca');
  });
  testWidgets('teste ctprod', (WidgetTester tester) async {
    await runSearch(tester, CtprodSearchFormField(
      onSearch: (x) {
        return Future.value({});
      },
    ));
  });
  // testar EstoperSearchFormField
  testWidgets('teste estoper', (WidgetTester tester) async {
    runSearch(
        tester,
        EstoperSearchFormField(
          suggestionController: SuggestionController(),
          onSearch: (x) {
            return Future.value({});
          },
        ));
  });
  // testar FilialSearchFormField
  testWidgets('teste filial', (WidgetTester tester) async {
    runSearch(
        tester,
        FilialSearchFormField(
          suggestionController: SuggestionController(),
          onChanged: (x) => {},
          onSearch: (x) {
            return Future.value({});
          },
        ));
  });
  // testar Sig01SearchFormField
  testWidgets('teste sig01', (WidgetTester tester) async {
    runSearch(
        tester,
        Sig01SearchFormField(
          suggestionController: SuggestionController(),
          onSearch: (x) {
            return Future.value({});
          },
        ));
  });
  // testar SigcadSearchFormField
  testWidgets('teste sigcad', (WidgetTester tester) async {
    runSearch(
        tester,
        SigcadSearchFormField(
          suggestionController: SuggestionController(),
          onSearch: (x) {
            return Future.value({});
          },
          onNew: (ctx, x) => Future.value({}),
          onChanged: (x) => {},
        ));
  });
  // testar SigvenSearchFormField
  testWidgets('teste sigven', (WidgetTester tester) async {
    await runSearch(
        tester,
        SigvenSearchFormField(
          suggestionController: SuggestionController(),
          onSearch: (x) {
            return Future.value({});
          },
        ));
  });
  // testar simple AtalhoBuilder
  testWidgets('teste atalhoBuilder', (WidgetTester tester) async {
    runSimple(
        tester,
        AtalhoBuilder(
          builder: (c, x) {
            return Container();
          },
          future: Future.value([]),
        ));
  });

  // testar simple CodigoProdutoFormField
  testWidgets('teste codigoProduto', (WidgetTester tester) async {
    await runSimple(
        tester,
        CodigoProdutoFormField(
          codigo: '1',
          onSaved: (x) => print(['salvou: ', x]),
          buscarFuture: (c) =>
              Future.value({'codigo': '1', 'nome': 'teste-$c'}),
          onSearch: (x) {
            return Future.value({});
          },
          onChanged: (x) => print(['selecionou: ', x]),
        ));
    tester.pump();
  });
}

runSimple(tester, wg) async {
  await tester.pumpWidget(
    runApp(
      wg,
    ),
  );
}

runSearch(tester, wg) async {
  await tester.pumpWidget(
    runApp(
      wg,
    ),
  );
  await tester.pump();
  var f = find.byType(IconButton);
  expect(f, findsOneWidget,
      reason: 'esperado ter um icone de busca, ativou onSearch');
  f = find.byType(TextField);
  expect(f, findsOneWidget);
  expect(f, isNotNull, reason: 'não achou um TextField no objeto de busca');
}

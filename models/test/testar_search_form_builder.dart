// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:models/builders.dart';
//import 'package:get/get.dart';

runApp(Widget wg) {
  return MaterialApp(
    home: Material(child: wg),
  );
}

builderTest() {
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
    runSearch(tester, CtprodSearchFormField(
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
    runSearch(
        tester,
        SigvenSearchFormField(
          suggestionController: SuggestionController(),
          onSearch: (x) {
            return Future.value({});
          },
        ));
  });
  // testar simple AcgruposDropdownBuilder
  /* testWidgets('teste acgruposDropDownBuilder', (WidgetTester tester) async {
    runSimple(tester, AcgruposDropdownBuilder());
  });
  // testar simple AtalhoBuilder
  testWidgets('teste atalhoBuilder', (WidgetTester tester) async {
    runSimple(tester, AtalhoBuilder(
      builder: (x, y) {
        return Text('teste');
      },
    ));
  });
  */
}

runSimple(tester, wg) async {
  await tester.pumpWidget(
    runApp(
      wg,
    ),
  );
  await tester.pump();
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

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:recipes_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("Probamos que haga una busqueda y vea detalles de la receta",
      ((WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    final searchBar = find.byKey(Key("searchBar"));
    expect(searchBar, findsOneWidget);

    await tester.enterText(searchBar, "pollo");

    final dropdown = find.byKey(ValueKey("dropdown"));
    expect(dropdown, findsOneWidget);

    await tester.tap(dropdown);
    await tester.pumpAndSettle();

    final dropdownitem = find.text("low-carb").last;
    expect(dropdownitem, findsOneWidget);

    await tester.tap(dropdownitem);
    await tester
        .pumpAndSettle(); //recarga el arbol al final de que se carguen todas las animaciones

    final button = find.text("SEARCH");
    expect(button, findsOneWidget);

    await tester.tap(button);
    await tester.pumpAndSettle();

    final lastItem1 = find.text("Calabacita con Pollo");
    expect(lastItem1, findsNothing);

    final scrollableListview = find.descendant(
      of: find.byType(ListView),
      matching: find.byType(Scrollable),
    );
    expect(scrollableListview, findsOneWidget);
    final lastItem = find.text("Calabacita con Pollo");
    await tester.scrollUntilVisible(
      lastItem,
      500.0,
      scrollable: scrollableListview,
    );
    expect(lastItem, findsOneWidget);

    await tester.tap(lastItem);
    await tester.pumpAndSettle();

    final url = find.byKey(Key("url"));
    expect(url, findsOneWidget);

    await tester.tap(url);
    await tester.pumpAndSettle();

    final url2 = find.byKey(Key("url2"));
    expect(url2, findsOneWidget);
  }));
  testWidgets("Probamos a hacer una búsqueda erronea",
      ((WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();
    final searchBar = find.byKey(Key("searchBar"));
    expect(searchBar, findsOneWidget);

    await tester.enterText(searchBar, "pollomalbuscado");

    final button = find.text("SEARCH");
    expect(button, findsOneWidget);

    await tester.tap(button);
    await tester.pumpAndSettle();

    final warning = find.text("No results for this search");
    expect(warning, findsOneWidget);

    final okbutton = find.text("OK");
    expect(okbutton, findsOneWidget);

    await tester.tap(okbutton);
    await tester.pumpAndSettle();
  }));
  testWidgets("Probamos que dea error el Prev", ((WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    final prevbutton = find.text("< Prev");
    expect(prevbutton, findsOneWidget);

    await tester.tap(prevbutton);
    await tester.pumpAndSettle();

    final warning = find.text("No previous block");
    expect(warning, findsOneWidget);

    final okbutton = find.text("OK");
    expect(okbutton, findsOneWidget);

    await tester.tap(okbutton);
    await tester.pumpAndSettle();
  }));
  testWidgets("Probamos que dea error el Next", ((WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    final prevbutton = find.text("Next >");
    expect(prevbutton, findsOneWidget);

    await tester.tap(prevbutton);
    await tester.pumpAndSettle();

    final warning = find.text("No next block");
    expect(warning, findsOneWidget);

    final okbutton = find.text("OK");
    expect(okbutton, findsOneWidget);

    await tester.tap(okbutton);
    await tester.pumpAndSettle();
  }));
  testWidgets("Probamos a cargar un siguiente bloque correctamente",
      ((WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    final searchBar = find.byKey(Key("searchBar"));
    expect(searchBar, findsOneWidget);

    await tester.enterText(searchBar, "pollo");

    final dropdown = find.byKey(ValueKey("dropdown"));
    expect(dropdown, findsOneWidget);

    await tester.tap(dropdown);
    await tester.pumpAndSettle();

    final dropdownitem = find.text("low-carb").last;
    expect(dropdownitem, findsOneWidget);

    await tester.tap(dropdownitem);
    await tester
        .pumpAndSettle(); //recarga el arbol al final de que se carguen todas las animaciones

    final button = find.text("SEARCH");
    expect(button, findsOneWidget);

    await tester.tap(button);
    await tester.pumpAndSettle();

    final nextbutton = find.text("Next >");
    expect(nextbutton, findsOneWidget);

    await tester.tap(nextbutton);
    await tester.pumpAndSettle();

    final scrollableListview = find.descendant(
      of: find.byType(ListView),
      matching: find.byType(Scrollable),
    );
    expect(scrollableListview, findsOneWidget);
    final lastItem = find.text("Peruvian Grilled Chicken");
    await tester.scrollUntilVisible(
      lastItem,
      500.0,
      scrollable: scrollableListview,
    );
    expect(lastItem, findsOneWidget);
  }));
  testWidgets(
      "Probamos que cargue un siguiente bloque y luego vuelva al anterior",
      ((WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    final searchBar = find.byKey(Key("searchBar"));
    expect(searchBar, findsOneWidget);

    await tester.enterText(searchBar, "pollo");

    final dropdown = find.byKey(ValueKey("dropdown"));
    expect(dropdown, findsOneWidget);

    await tester.tap(dropdown);
    await tester.pumpAndSettle();

    final dropdownitem = find.text("low-carb").last;
    expect(dropdownitem, findsOneWidget);

    await tester.tap(dropdownitem);
    await tester
        .pumpAndSettle(); //recarga el arbol al final de que se carguen todas las animaciones

    final button = find.text("SEARCH");
    expect(button, findsOneWidget);

    await tester.tap(button);
    await tester.pumpAndSettle();

    final nextbutton = find.text("Next >");
    expect(nextbutton, findsOneWidget);

    await tester.tap(nextbutton);
    await tester.pumpAndSettle();

    final scrollableListview = find.descendant(
      of: find.byType(ListView),
      matching: find.byType(Scrollable),
    );
    expect(scrollableListview, findsOneWidget);
    final lastItem = find.text("Peruvian Grilled Chicken");
    await tester.scrollUntilVisible(
      lastItem,
      500.0,
      scrollable: scrollableListview,
    );
    expect(lastItem, findsOneWidget);

    final prevbutton = find.text("< Prev");
    expect(prevbutton, findsOneWidget);

    await tester.tap(prevbutton);
    await tester.pumpAndSettle();

    final firstItem = find.text("Tinga de Pollo");
    expect(firstItem, findsOneWidget);
  }));
  /* testWidgets("Probamos a hacer una búsqueda erronea",
      ((WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();
  }));*/
}

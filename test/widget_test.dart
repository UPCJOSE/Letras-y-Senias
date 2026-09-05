import 'package:flutter_test/flutter_test.dart';
import 'package:movi/ui/app.dart';

void main() {
  testWidgets('La app muestra Señas, Traducir y Grabar', (tester) async {
    await tester.pumpWidget(const MoviApp());

    expect(find.text('Señas'), findsOneWidget);
    expect(find.text('Traducir'), findsOneWidget);
    expect(find.text('Grabar'), findsOneWidget);
    expect(find.text('Aquí aparecerán las señas'), findsOneWidget);
    expect(find.text('Toca aquí para escribir...'), findsOneWidget);
  });
}

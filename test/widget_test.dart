import 'package:flutter_test/flutter_test.dart';
import 'package:movi/ui/aplicacion.dart';

void main() {
  testWidgets('La app muestra Señas, Traducir y Grabar', (probador) async {
    await probador.pumpWidget(const AplicacionMovi());

    expect(find.text('Señas'), findsOneWidget);
    expect(find.text('Traducir'), findsOneWidget);
    expect(find.text('Grabar'), findsOneWidget);
    expect(find.text('Aquí aparecerán las señas'), findsOneWidget);
    expect(find.text('Toca aquí para escribir...'), findsOneWidget);
  });
}

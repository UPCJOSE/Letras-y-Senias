import 'package:flutter_test/flutter_test.dart';
import 'package:movi/ui/aplicacion.dart';

void main() {
  testWidgets('Navegación muestra Traductor y Admin CMS', (probador) async {
    await probador.pumpWidget(const AplicacionMovi());

    expect(find.text('Traductor'), findsWidgets);
    expect(find.text('Admin CMS'), findsOneWidget);
    expect(find.text('Señas'), findsOneWidget);

    await probador.tap(find.text('Admin CMS'));
    await probador.pumpAndSettle();

    expect(find.text('Panel Administrador'), findsOneWidget);
    expect(find.text('Palabras'), findsOneWidget);

    await probador.tap(find.text('Palabras'));
    await probador.pumpAndSettle();

    expect(find.text('+ Añadir alias'), findsOneWidget);
    expect(find.textContaining('añadir alias'), findsWidgets);
  });

  testWidgets('Diálogo Añadir alias se abre desde Palabras', (probador) async {
    await probador.pumpWidget(const AplicacionMovi());

    await probador.tap(find.text('Admin CMS'));
    await probador.pumpAndSettle();
    await probador.tap(find.text('Palabras'));
    await probador.pumpAndSettle();

    await probador.tap(find.text('+ Añadir alias').first);
    await probador.pumpAndSettle();

    expect(find.text('Añadir alias'), findsOneWidget);
    expect(find.text('Texto del alias'), findsOneWidget);
    expect(find.text('Concepto / seña asociada'), findsOneWidget);
    expect(find.text('Guardar alias'), findsOneWidget);
  });
}

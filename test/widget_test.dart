import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movi/ui/aplicacion.dart';

void main() {
  testWidgets('Shell LSC muestra diseño del mockup', (probador) async {
    await probador.pumpWidget(const AplicacionMovi());

    expect(find.text('LSC App'), findsOneWidget);
    expect(find.text('Fase 1'), findsOneWidget);
    expect(find.text('Traductor'), findsOneWidget);
    expect(find.text('Palabras'), findsOneWidget);
    expect(find.text('Vectorial'), findsOneWidget);
    expect(find.text('Admin CMS'), findsOneWidget);
    expect(find.text('Suscripción'), findsOneWidget);
    expect(find.text('Traductor Texto → Señas'), findsOneWidget);
  });

  testWidgets('Traductor encuentra seña del catálogo', (probador) async {
    await probador.pumpWidget(const AplicacionMovi());

    await probador.enterText(
      find.byType(TextField).first,
      'hola',
    );
    await probador.tap(find.text('Traducir'));
    await probador.pumpAndSettle();

    expect(find.text('✓ En catálogo'), findsOneWidget);
  });

  testWidgets('Admin abre Añadir alias en Palabras', (probador) async {
    await probador.pumpWidget(const AplicacionMovi());

    await probador.tap(find.text('Admin CMS'));
    await probador.pumpAndSettle();
    await probador.tap(find.text('Palabras').last);
    await probador.pumpAndSettle();

    await probador.tap(find.text('+ Añadir alias').first);
    await probador.pumpAndSettle();

    expect(find.text('Añadir alias'), findsOneWidget);
    expect(find.text('Guardar alias'), findsOneWidget);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movi/ui/auth/pagina_splash.dart';
import 'package:movi/ui/shell/pagina_principal.dart';

void main() {
  testWidgets('Splash muestra marca SeñasApp', (probador) async {
    await probador.pumpWidget(const MaterialApp(home: PaginaSplash()));
    expect(find.text('SeñasApp'), findsOneWidget);
    expect(
      find.textContaining('Lengua de Señas Colombiana'),
      findsOneWidget,
    );
    await probador.pump(const Duration(milliseconds: 2500));
  });

  testWidgets('Navegación principal Inicio Diccionario Perfil', (probador) async {
    await probador.pumpWidget(const MaterialApp(home: PaginaPrincipal()));

    expect(find.text('Inicio'), findsWidgets);
    expect(find.text('Diccionario'), findsOneWidget);
    expect(find.text('Perfil'), findsOneWidget);
    expect(find.text('Traducir a LSC'), findsOneWidget);

    await probador.tap(find.text('Diccionario'));
    await probador.pumpAndSettle();
    expect(find.text('Diccionario LSC'), findsOneWidget);

    await probador.tap(find.text('Perfil'));
    await probador.pumpAndSettle();
    expect(find.text('Mi perfil'), findsOneWidget);
    expect(find.text('Ana Gómez'), findsOneWidget);
  });

  testWidgets('Menú hamburguesa muestra opciones', (probador) async {
    await probador.pumpWidget(const MaterialApp(home: PaginaPrincipal()));

    await probador.tap(find.byType(FloatingActionButton));
    await probador.pumpAndSettle();

    expect(find.text('NAVEGAR A PANTALLA'), findsOneWidget);
    expect(find.text('Splash'), findsOneWidget);
    expect(find.text('Inicio de sesión'), findsOneWidget);
    expect(find.text('Diccionario'), findsWidgets);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:senas_app/app.dart';
import 'package:senas_app/controllers/app_controller.dart';
import 'package:senas_app/views/management_screens.dart';

void main() {
  testWidgets('muestra splash y avanza al primer paso del onboarding', (
    tester,
  ) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AppController(),
        child: const SenasApp(),
      ),
    );
    expect(find.text('SeñasApp'), findsOneWidget);
    expect(find.textContaining('Conectando personas'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 1700));
    await tester.pumpAndSettle();
    expect(
      find.text('Traduce texto a Lengua de Señas Colombiana'),
      findsOneWidget,
    );
    expect(find.text('Siguiente'), findsOneWidget);
  });

  testWidgets('el menú administrador se cierra y conserva el regreso', (
    tester,
  ) async {
    final router = GoRouter(
      initialLocation: '/admin',
      routes: [
        GoRoute(
          path: '/admin',
          builder: (_, _) => const AdminDashboardScreen(),
        ),
        GoRoute(
          path: '/admin/users',
          builder: (_, _) => const Scaffold(body: Text('Destino personas')),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));

    await tester.tap(find.byTooltip('Abrir menú'));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Cerrar menú'), findsOneWidget);

    await tester.tap(
      find.descendant(of: find.byType(Drawer), matching: find.text('Resumen')),
    );
    await tester.pumpAndSettle();
    expect(find.byTooltip('Cerrar menú'), findsNothing);

    await tester.tap(find.byTooltip('Abrir menú'));
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(of: find.byType(Drawer), matching: find.text('Personas')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Destino personas'), findsOneWidget);
    expect(router.canPop(), isTrue);
    router.pop();
    await tester.pumpAndSettle();
    expect(find.text('Panel Administrador'), findsOneWidget);
  });
}

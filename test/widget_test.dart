import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:senas_app/app.dart';
import 'package:senas_app/controllers/app_controller.dart';

void main() {
  testWidgets('muestra el primer paso del onboarding', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AppController(),
        child: const SenasApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      find.text('Traduce texto a Lengua de Señas Colombiana'),
      findsOneWidget,
    );
    expect(find.text('Siguiente'), findsOneWidget);
  });
}

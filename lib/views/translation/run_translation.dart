import 'package:flutter/material.dart';

import '../../controllers/app_controller.dart';
import '../../shared/widgets/app_widgets.dart';

Future<void> runTranslation(
  BuildContext context,
  AppController controller,
  String input,
) async {
  if (controller.isTranslating) return;
  if (input.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Escribe una palabra o frase primero.')),
    );
    return;
  }
  try {
    final route = await controller.translateRoute(input);
    if (!context.mounted) return;
    openTranslationDestination(context, route);
  } catch (_) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('No se pudo cargar el diccionario desde Firebase.'),
      ),
    );
  }
}

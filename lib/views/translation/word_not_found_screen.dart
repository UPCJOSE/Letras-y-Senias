import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/app_controller.dart';
import '../../shared/widgets/app_widgets.dart';
import '../../theme/app_theme.dart';
import '../translation/run_translation.dart';

class WordNotFoundScreen extends StatelessWidget {
  const WordNotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AppController>();
    final result = controller.currentTranslation;
    return MobileCanvas(
      child: Scaffold(
        appBar: const SenasHeader(
          title: 'Palabra no encontrada',
          showBack: true,
          backFallback: '/translate',
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(20, 6, 20, 24),
          children: [
            TranslationNotice(controller.translationNotice),
            const SizedBox(height: 10),
            const CircleAvatar(
              radius: 42,
              backgroundColor: AppColors.paleYellow,
              child: Icon(
                Icons.manage_search,
                size: 44,
                color: AppColors.blueDark,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'No encontramos “${result?.originalText ?? ''}”',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Revisa estas coincidencias del diccionario de SeñasApp.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            const SectionTitle('¿Quisiste decir?'),
            const SizedBox(height: 10),
            if (result == null || result.suggestions.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(18),
                  child: Text('No hay sugerencias disponibles.'),
                ),
              )
            else
              ...result.suggestions.map(
                (suggestion) => Card(
                  child: ListTile(
                    minTileHeight: 76,
                    leading: const CircleAvatar(
                      backgroundColor: AppColors.paleBlue,
                      child: Icon(Icons.sign_language, color: AppColors.blue),
                    ),
                    title: Text(
                      suggestion.term,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    subtitle: Text(
                      '${(suggestion.similarity * 100).round()}% de similitud',
                    ),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () =>
                        runTranslation(context, controller, suggestion.term),
                  ),
                ),
              ),
            const SizedBox(height: 14),
            OutlinedButton.icon(
              onPressed: () => navigateBack(context, '/translate'),
              icon: const Icon(Icons.edit_outlined),
              label: const Text('Editar texto'),
            ),
          ],
        ),
      ),
    );
  }
}

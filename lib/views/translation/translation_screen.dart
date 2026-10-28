import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/app_controller.dart';
import '../../shared/widgets/app_widgets.dart';
import '../../shared/widgets/lsc70_player.dart';
import '../../theme/app_theme.dart';
import '../translation/run_translation.dart';

class TranslationScreen extends StatefulWidget {
  const TranslationScreen({super.key});
  @override
  State<TranslationScreen> createState() => _TranslationScreenState();
}

class _TranslationScreenState extends State<TranslationScreen> {
  final _text = TextEditingController();
  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AppController>();
    final result = controller.currentTranslation;
    if (_text.text.isEmpty && result != null) _text.text = result.originalText;
    return Scaffold(
      appBar: const SenasHeader(title: 'Traducción'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        children: [
          TextField(
            controller: _text,
            decoration: InputDecoration(
              hintText: 'Escribe una palabra o frase...',
              suffixIcon: IconButton(
                icon: controller.isTranslating
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.arrow_forward),
                onPressed: controller.isTranslating
                    ? null
                    : () => runTranslation(context, controller, _text.text),
              ),
            ),
            onSubmitted: controller.isTranslating
                ? null
                : (value) => runTranslation(context, controller, value),
          ),
          const SizedBox(height: 18),
          TranslationNotice(controller.translationNotice),
          if (result == null)
            const FirebaseSignStage(
              title: 'Listo para buscar',
              message: 'Escribe una palabra para consultar el diccionario.',
            )
          else ...[
            Lsc70Player(
              sequence: result.sequenceEntries
                  .map((sign) => sign?.media)
                  .toList(),
              initialSpeed: controller.playbackSpeed,
            ),
            if (result.sequenceEntries.isEmpty ||
                result.sequenceEntries.any((sign) => sign?.media == null))
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  'Algunas señas todavía no tienen un recurso visual publicado.',
                  textAlign: TextAlign.center,
                ),
              ),
          ],
          const SizedBox(height: 14),
          if (result != null) ...[
            const SizedBox(height: 10),
            if (result.signs.isNotEmpty) ...[
              const SectionTitle('Señas detectadas'),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: result.signs
                    .map(
                      (sign) => Chip(
                        avatar: const Icon(Icons.sign_language, size: 17),
                        label: Text(sign.term),
                      ),
                    )
                    .toList(),
              ),
            ],
            if (result.suggestions.isNotEmpty) ...[
              const SizedBox(height: 18),
              Card(
                color: AppColors.paleYellow,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '¿Quisiste decir?',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: AppColors.ink,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...result.suggestions.map(
                        (item) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          title: Text(
                            item.term,
                            style: const TextStyle(color: AppColors.ink),
                          ),
                          subtitle: Text(
                            '${(item.similarity * 100).round()}% de similitud',
                          ),
                          trailing: TextButton(
                            onPressed: () {
                              _text.text = item.term;
                              runTranslation(context, controller, item.term);
                            },
                            child: const Text('Usar'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            if (result.spelling.isNotEmpty) ...[
              const SizedBox(height: 18),
              const SectionTitle('Deletreo'),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: result.spelling
                    .asMap()
                    .entries
                    .map(
                      (item) => CircleAvatar(
                        backgroundColor: item.key == 0
                            ? AppColors.blue
                            : AppColors.paleBlue,
                        foregroundColor: item.key == 0
                            ? Colors.white
                            : AppColors.blueDark,
                        child: Text(
                          item.value,
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 10),
              const Text(
                'La palabra no está en el catálogo y se muestra letra por letra.',
              ),
            ],
          ] else ...[
            const SizedBox(height: 20),
            const Text(
              'Prueba con “Hola, necesito ayuda”.',
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

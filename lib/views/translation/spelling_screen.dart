import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/app_controller.dart';
import '../../models/app_models.dart';
import '../../shared/widgets/app_widgets.dart';
import '../../shared/widgets/lsc70_player.dart';
import '../../theme/app_theme.dart';

class SpellingScreen extends StatefulWidget {
  const SpellingScreen({super.key});

  @override
  State<SpellingScreen> createState() => _SpellingScreenState();
}

class _SpellingScreenState extends State<SpellingScreen> {
  SignEntry? _selectedLetter;
  int _currentLetterIndex = 0;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AppController>();
    final result = controller.currentTranslation;
    final letters = result?.spelling ?? const <String>[];
    return MobileCanvas(
      child: Scaffold(
        appBar: const SenasHeader(
          title: 'Deletreo',
          showBack: true,
          backFallback: '/translate',
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          children: [
            TranslationNotice(controller.translationNotice),
            Text(
              result?.originalText ?? '',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            Text(
              letters.isEmpty
                  ? 'Sin letras para deletrear'
                  : 'Letra ${(_currentLetterIndex + 1).clamp(1, letters.length)} de ${letters.length}',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            Lsc70Player(
              sequence: (result?.sequenceEntries ?? const <SignEntry?>[])
                  .map((sign) => sign?.media)
                  .toList(),
              height: 220,
              onSequenceIndexChanged: (index) {
                final sequence =
                    result?.sequence ?? const <TranslationReference>[];
                if (!mounted ||
                    index >= sequence.length ||
                    sequence[index].kind != SignKind.letter) {
                  return;
                }
                final letterIndex =
                    sequence
                        .take(index + 1)
                        .where((reference) => reference.kind == SignKind.letter)
                        .length -
                    1;
                if (letterIndex < letters.length) {
                  setState(() => _currentLetterIndex = letterIndex);
                }
              },
              initialSpeed: controller.playbackSpeed,
            ),
            if ((result?.sequenceEntries ?? const <SignEntry?>[]).any(
              (sign) => sign?.media == null,
            ))
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  'Algunas letras aún no tienen un recurso visual publicado.',
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 18),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: letters.asMap().entries.map((entry) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: entry.key == _currentLetterIndex
                        ? AppColors.blue
                        : AppColors.paleBlue,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    entry.value.toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: entry.key == _currentLetterIndex
                          ? Colors.white
                          : AppColors.blueDark,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 18),
            Text(
              '“${result?.originalText ?? ''}” se reproduce con las letras del alfabeto LSC70 cuando sus recursos están publicados.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            const SectionTitle('Alfabeto LSC70'),
            const SizedBox(height: 10),
            StreamBuilder<List<SignEntry>>(
              stream: controller.publicSigns,
              builder: (context, snapshot) {
                final alphabet =
                    (snapshot.data ?? const <SignEntry>[])
                        .where((sign) => sign.kind == SignKind.letter)
                        .toList()
                      ..sort((a, b) => a.term.compareTo(b.term));
                if (snapshot.hasError) {
                  return const Text(
                    'No se pudo consultar el alfabeto en Firestore.',
                  );
                }
                if (alphabet.isEmpty) {
                  return const Text(
                    'El alfabeto todavía no está publicado en Firestore.',
                  );
                }
                return Column(
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: alphabet
                          .map(
                            (sign) => ChoiceChip(
                              label: Text(sign.term),
                              selected: _selectedLetter?.id == sign.id,
                              onSelected: (_) =>
                                  setState(() => _selectedLetter = sign),
                            ),
                          )
                          .toList(),
                    ),
                    if (_selectedLetter != null) ...[
                      const SizedBox(height: 12),
                      Lsc70Player(
                        media: _selectedLetter!.media,
                        initialSpeed: controller.playbackSpeed,
                      ),
                    ],
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

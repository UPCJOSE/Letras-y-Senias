import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../controllers/app_controller.dart';
import '../models/app_models.dart';
import '../shared/widgets/app_widgets.dart';
import '../shared/widgets/lsc70_player.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _text = TextEditingController();
  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AppController>();
    return Scaffold(
      appBar: SenasHeader(
        actions: [
          IconButton(
            onPressed: () => context.push('/history'),
            icon: const Icon(Icons.history),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 6, 20, 24),
        children: [
          Text(
            controller.isAuthenticated
                ? 'Hola, ${controller.userDisplayName} 👋'
                : 'Hola 👋',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 6),
          Text(
            '¿Qué quieres comunicar hoy?',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 22),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Texto para traducir',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _text,
                    maxLines: 4,
                    minLines: 3,
                    decoration: const InputDecoration(
                      hintText: 'Escribe una palabra o frase...',
                      alignLabelWithHint: true,
                    ),
                  ),
                  const SizedBox(height: 14),
                  FilledButton.icon(
                    onPressed: controller.isTranslating
                        ? null
                        : () =>
                              _runTranslation(context, controller, _text.text),
                    icon: controller.isTranslating
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.sign_language_outlined),
                    label: Text(
                      controller.isTranslating
                          ? 'Consultando diccionario…'
                          : 'Traducir a LSC',
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: ListTile(
              onTap: () => context.push('/conversation'),
              minTileHeight: 76,
              leading: const CircleAvatar(
                backgroundColor: AppColors.blue,
                foregroundColor: Colors.white,
                child: Icon(Icons.forum_outlined),
              ),
              title: const Text(
                'Conversación',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              subtitle: const Text(
                'Habla en una sala compartida con un código',
              ),
              trailing: const Icon(Icons.chevron_right),
            ),
          ),
          const SizedBox(height: 22),
          const SectionTitle('Accesos rápidos'),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: .82,
            children: const [
              _QuickAction(
                'Hospital',
                Icons.local_hospital_outlined,
                AppColors.paleBlue,
              ),
              _QuickAction(
                'Banco',
                Icons.account_balance_outlined,
                AppColors.paleGreen,
              ),
              _QuickAction(
                'Colegio',
                Icons.school_outlined,
                AppColors.lavender,
              ),
              _QuickAction(
                'Emergencia',
                Icons.sos_outlined,
                AppColors.paleYellow,
              ),
            ],
          ),
          const SizedBox(height: 22),
          SectionTitle(
            'Recientes',
            action: TextButton(
              onPressed: () => context.push('/history'),
              child: const Text('Ver todo'),
            ),
          ),
          const SizedBox(height: 8),
          _HomeHistory(controller: controller),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction(this.label, this.icon, this.color);
  final String label;
  final IconData icon;
  final Color color;
  @override
  Widget build(BuildContext context) => InkWell(
    borderRadius: BorderRadius.circular(20),
    onTap: () {
      final controller = context.read<AppController>();
      _runTranslation(context, controller, label);
    },
    child: Ink(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.blueDark),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.blueDark,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _HomeHistory extends StatelessWidget {
  const _HomeHistory({required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) =>
      StreamBuilder<List<TranslationHistoryItem>>(
        stream: controller.history,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Card(
              child: ListTile(
                leading: Icon(Icons.cloud_off_outlined),
                title: Text('No se pudo cargar el historial.'),
              ),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final items = snapshot.data!.take(3).toList();
          if (items.isEmpty) {
            return Card(
              child: ListTile(
                leading: const Icon(Icons.history),
                title: Text(
                  controller.isAuthenticated
                      ? 'Aún no tienes traducciones guardadas.'
                      : 'Inicia sesión para guardar tu historial.',
                ),
              ),
            );
          }
          return Column(
            children: items
                .map(
                  (item) => Card(
                    child: ListTile(
                      title: Text(
                        item.text,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text('${item.label} · ${item.signCount} señas'),
                      trailing: IconButton(
                        onPressed: () async {
                          final route = await controller.replayHistory(item);
                          if (context.mounted) {
                            openTranslationDestination(context, route);
                          }
                        },
                        icon: const Icon(
                          Icons.play_circle_fill,
                          color: AppColors.blue,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          );
        },
      );
}

Future<void> _runTranslation(
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
                    : () => _runTranslation(context, controller, _text.text),
              ),
            ),
            onSubmitted: controller.isTranslating
                ? null
                : (value) => _runTranslation(context, controller, value),
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
                              _runTranslation(context, controller, item.term);
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
                        _runTranslation(context, controller, suggestion.term),
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

class DictionaryScreen extends StatefulWidget {
  const DictionaryScreen({super.key});
  @override
  State<DictionaryScreen> createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {
  String query = '';
  String category = 'Todas';

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AppController>();
    return Scaffold(
      appBar: const SenasHeader(title: 'Diccionario LSC'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
            child: TextField(
              onChanged: (value) => setState(() => query = value),
              decoration: const InputDecoration(
                hintText: 'Buscar una seña',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<SignEntry>>(
              stream: controller.publicSigns,
              builder: (context, signSnapshot) {
                if (signSnapshot.hasError) {
                  return const Center(
                    child: Text('No se pudo cargar el diccionario.'),
                  );
                }
                if (!signSnapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                return StreamBuilder<List<SignCategory>>(
                  stream: controller.categories,
                  builder: (context, categorySnapshot) {
                    if (categorySnapshot.hasError) {
                      return const Center(
                        child: Text('No se pudieron cargar las categorías.'),
                      );
                    }
                    if (!categorySnapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return _buildCatalog(
                      context,
                      signSnapshot.data!,
                      categorySnapshot.data!,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCatalog(
    BuildContext context,
    List<SignEntry> signs,
    List<SignCategory> firestoreCategories,
  ) {
    final categoryNames = {
      ...firestoreCategories.map((item) => item.name),
      ...signs.map((item) => item.category),
    }.toList()..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    final categories = ['Todas', ...categoryNames];
    final selectedCategory = categories.contains(category) ? category : 'Todas';
    final items = signs.where((sign) {
      final matchesQuery = sign.term.toLowerCase().contains(
        query.toLowerCase(),
      );
      return matchesQuery &&
          (selectedCategory == 'Todas' || sign.category == selectedCategory);
    }).toList();

    if (signs.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(28),
          child: Text(
            'El diccionario aún no tiene señas validadas. El equipo está preparando el catálogo.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return Column(
      children: [
        SizedBox(
          height: 44,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (_, index) => ChoiceChip(
              label: Text(categories[index]),
              selected: selectedCategory == categories[index],
              onSelected: (_) => setState(() => category = categories[index]),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: items.isEmpty
              ? const Center(child: Text('No hay señas que coincidan.'))
              : GridView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: .88,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: items.length,
                  itemBuilder: (_, index) {
                    final sign = items[index];
                    final colors = [
                      AppColors.paleBlue,
                      AppColors.lavender,
                      AppColors.paleYellow,
                      AppColors.paleGreen,
                    ];
                    return Card(
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () => _showSignDetail(context, sign),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                color: colors[index % colors.length],
                                alignment: Alignment.center,
                                child: sign.media?.isUsable == true
                                    ? Image.network(
                                        sign.media!.frameUrls.first,
                                        fit: BoxFit.contain,
                                        errorBuilder: (_, _, _) => const Icon(
                                          Icons.broken_image_outlined,
                                          size: 40,
                                        ),
                                      )
                                    : const Text(
                                        'Recurso visual no disponible',
                                        textAlign: TextAlign.center,
                                      ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    sign.term,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  Text(
                                    sign.category,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  void _showSignDetail(BuildContext context, SignEntry sign) {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      constraints: const BoxConstraints(maxWidth: 430),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        final availableHeight = MediaQuery.sizeOf(sheetContext).height * .88;
        final sheetHeight = availableHeight < 560 ? availableHeight : 560.0;
        return SizedBox(
          height: sheetHeight,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        sign.term,
                        style: Theme.of(sheetContext).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      Lsc70Player(
                        media: sign.media,
                        height: sheetHeight < 520 ? 180 : 240,
                        initialSpeed: context
                            .read<AppController>()
                            .playbackSpeed,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () async {
                      Navigator.pop(sheetContext);
                      final controller = context.read<AppController>();
                      final path = await controller.translateRoute(sign.term);
                      if (context.mounted) {
                        openTranslationDestination(context, path);
                      }
                    },
                    child: const Text('Traducir este término'),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

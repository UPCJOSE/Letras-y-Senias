import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../controllers/app_controller.dart';
import '../services/translation_service.dart';
import '../shared/widgets/app_widgets.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _text = TextEditingController(text: 'Hola, necesito ayuda');
  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AppController>();
    return MobileCanvas(
      child: Scaffold(
        appBar: SenasHeader(
          actions: [
            IconButton(
              onPressed: () => context.push('/history'),
              icon: const Icon(Icons.history),
            ),
            const SizedBox(width: 8),
          ],
        ),
        bottomNavigationBar: const AppBottomNav(index: 0),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(20, 6, 20, 24),
          children: [
            Text(
              'Hola, Alex 👋',
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
                      onPressed: () {
                        context.go(controller.translateRoute(_text.text));
                      },
                      icon: const Icon(Icons.sign_language_outlined),
                      label: const Text('Traducir a LSC'),
                    ),
                  ],
                ),
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
            ...controller.history
                .take(3)
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
                        onPressed: () {
                          context.go(controller.translateRoute(item.text));
                        },
                        icon: const Icon(
                          Icons.play_circle_fill,
                          color: AppColors.blue,
                        ),
                      ),
                    ),
                  ),
                ),
          ],
        ),
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
      context.go(controller.translateRoute(label));
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

class TranslationScreen extends StatefulWidget {
  const TranslationScreen({super.key});
  @override
  State<TranslationScreen> createState() => _TranslationScreenState();
}

class _TranslationScreenState extends State<TranslationScreen> {
  final _text = TextEditingController();
  bool playing = false;
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
    return MobileCanvas(
      child: Scaffold(
        appBar: const SenasHeader(title: 'Traducción'),
        bottomNavigationBar: const AppBottomNav(index: 1),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          children: [
            TextField(
              controller: _text,
              decoration: InputDecoration(
                hintText: 'Escribe una palabra o frase...',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () =>
                      context.go(controller.translateRoute(_text.text)),
                ),
              ),
              onSubmitted: (value) =>
                  context.go(controller.translateRoute(value)),
            ),
            const SizedBox(height: 18),
            AvatarStage(
              label: result?.signs.isNotEmpty == true
                  ? result!.signs.first.term
                  : 'Listo para traducir',
            ),
            const SizedBox(height: 14),
            if (result != null) ...[
              LinearProgressIndicator(
                value: playing ? .62 : 0,
                minHeight: 7,
                borderRadius: BorderRadius.circular(10),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton.filledTonal(
                    onPressed: () => setState(() => playing = false),
                    icon: const Icon(Icons.replay),
                  ),
                  const SizedBox(width: 14),
                  IconButton.filled(
                    onPressed: () => setState(() => playing = !playing),
                    iconSize: 34,
                    icon: Icon(playing ? Icons.pause : Icons.play_arrow),
                  ),
                  const SizedBox(width: 14),
                  PopupMenuButton<double>(
                    initialValue: controller.playbackSpeed,
                    onSelected: controller.setSpeed,
                    itemBuilder: (_) => const [.5, 1.0, 1.5]
                        .map(
                          (speed) => PopupMenuItem(
                            value: speed,
                            child: Text('${speed}x'),
                          ),
                        )
                        .toList(),
                    child: Chip(label: Text('${controller.playbackSpeed}x')),
                  ),
                ],
              ),
              const SizedBox(height: 20),
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
                                context.go(
                                  controller.translateRoute(item.term),
                                );
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
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(20, 6, 20, 24),
          children: [
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
                        context.go(controller.translateRoute(suggestion.term)),
                  ),
                ),
              ),
            const SizedBox(height: 14),
            OutlinedButton.icon(
              onPressed: () => context.go('/home'),
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
  bool playing = true;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AppController>();
    final result = controller.currentTranslation;
    final letters = result?.spelling ?? const <String>[];
    return MobileCanvas(
      child: Scaffold(
        appBar: const SenasHeader(title: 'Deletreo', showBack: true),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          children: [
            AvatarStage(
              height: 270,
              label: letters.isEmpty ? 'Listo para deletrear' : letters.first,
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: playing && letters.isNotEmpty ? 1 / letters.length : 0,
              minHeight: 7,
              borderRadius: BorderRadius.circular(10),
            ),
            const SizedBox(height: 18),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: letters.asMap().entries.map((entry) {
                final active = entry.key == 0 && playing;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: active ? AppColors.blue : AppColors.paleBlue,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    entry.value.toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: active ? Colors.white : AppColors.blueDark,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 18),
            Text(
              '“${result?.originalText ?? ''}” no está en el catálogo. La mostramos letra por letra con el alfabeto LSC.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton.filledTonal(
                  onPressed: () => setState(() => playing = true),
                  icon: const Icon(Icons.replay),
                ),
                const SizedBox(width: 14),
                IconButton.filled(
                  onPressed: () => setState(() => playing = !playing),
                  iconSize: 34,
                  icon: Icon(playing ? Icons.pause : Icons.play_arrow),
                ),
                const SizedBox(width: 14),
                Chip(label: Text('${controller.playbackSpeed}x')),
              ],
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
    final categories = [
      'Todas',
      ...{for (final sign in demoCatalog) sign.category},
    ];
    final items = demoCatalog.where((sign) {
      final matchesQuery = sign.term.toLowerCase().contains(
        query.toLowerCase(),
      );
      return matchesQuery && (category == 'Todas' || sign.category == category);
    }).toList();
    return MobileCanvas(
      child: Scaffold(
        appBar: const SenasHeader(title: 'Diccionario LSC'),
        bottomNavigationBar: const AppBottomNav(index: 2),
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
            SizedBox(
              height: 44,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (_, index) => ChoiceChip(
                  label: Text(categories[index]),
                  selected: category == categories[index],
                  onSelected: (_) =>
                      setState(() => category = categories[index]),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.builder(
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
                      onTap: () {
                        final controller = context.read<AppController>();
                        context.go(controller.translateRoute(sign.term));
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              color: colors[index % colors.length],
                              alignment: Alignment.center,
                              child: const MiniAvatar(),
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
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
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
        ),
      ),
    );
  }
}

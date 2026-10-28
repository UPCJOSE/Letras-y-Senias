import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/app_controller.dart';
import '../../models/app_models.dart';
import '../../shared/widgets/app_widgets.dart';
import '../../shared/widgets/lsc70_player.dart';
import '../../theme/app_theme.dart';

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

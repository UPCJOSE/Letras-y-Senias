import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/app_controller.dart';
import '../../shared/widgets/app_widgets.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});
  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String query = '';
  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AppController>();
    return MobileCanvas(
      child: Scaffold(
        appBar: const SenasHeader(
          title: 'Historial',
          showBack: true,
          backFallback: '/profile',
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                onChanged: (value) => setState(() => query = value),
                decoration: const InputDecoration(
                  hintText: 'Buscar en el historial',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: controller.history,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('No se pudo cargar tu historial.'),
                    );
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final items = snapshot.data!
                      .where(
                        (item) => item.text.toLowerCase().contains(
                          query.toLowerCase(),
                        ),
                      )
                      .toList();
                  if (items.isEmpty) {
                    return Center(
                      child: Text(
                        controller.isAuthenticated
                            ? 'Aún no tienes traducciones guardadas.'
                            : 'Inicia sesión para consultar tu historial.',
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    itemCount: items.length,
                    itemBuilder: (_, index) {
                      final item = items[index];
                      final group = item.label.split(',').first;
                      final previousGroup = index == 0
                          ? null
                          : items[index - 1].label.split(',').first;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (group != previousGroup) ...[
                            Padding(
                              padding: EdgeInsets.only(
                                top: index == 0 ? 0 : 16,
                                bottom: 8,
                              ),
                              child: Text(
                                group,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w800),
                              ),
                            ),
                          ],
                          Card(
                            child: ListTile(
                              minTileHeight: 76,
                              title: Text(
                                item.text,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              subtitle: Text(
                                '${item.label.contains(',') ? item.label.split(',').skip(1).join(',').trim() : item.label} · ${item.signCount} señas',
                              ),
                              trailing: IconButton.filledTonal(
                                onPressed: () async {
                                  final route = await controller.replayHistory(
                                    item,
                                  );
                                  if (context.mounted) {
                                    openTranslationDestination(context, route);
                                  }
                                },
                                icon: const Icon(Icons.play_arrow),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
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

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../controllers/app_controller.dart';
import '../../models/app_models.dart';
import '../../shared/widgets/app_widgets.dart';
import '../../theme/app_theme.dart';
import '../translation/run_translation.dart';

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
                        : () => runTranslation(context, controller, _text.text),
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
      runTranslation(context, controller, label);
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

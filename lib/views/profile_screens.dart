import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../controllers/app_controller.dart';
import '../models/app_models.dart';
import '../shared/widgets/app_widgets.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AppController>();
    final role = controller.role;
    final name = controller.userDisplayName;
    final email = controller.userEmail;
    final initials = name
        .trim()
        .split(' ')
        .where((p) => p.isNotEmpty)
        .take(2)
        .map((p) => p[0].toUpperCase())
        .join();

    return Scaffold(
      appBar: const SenasHeader(title: 'Perfil'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 34,
                    backgroundColor: AppColors.paleBlue,
                    child: Text(
                      initials.isEmpty ? 'U' : initials,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: AppColors.blue,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(email),
                        const SizedBox(height: 6),
                        Chip(
                          label: Text(
                            role == AppRole.admin
                                ? 'Administrador'
                                : 'Plan gratuito',
                          ),
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          _ProfileTile(
            Icons.history,
            'Historial de traducciones',
            'Revisa y reproduce tus consultas',
            () => context.push('/history'),
          ),
          _ProfileTile(
            Icons.workspace_premium_outlined,
            'Plan Premium',
            '50 palabras vs. 200+ señas',
            () => context.push('/premium'),
          ),
          _ProfileTile(
            Icons.settings_outlined,
            'Ajustes',
            'Tema, accesibilidad y reproducción',
            () => context.push('/settings'),
          ),
          if (role == AppRole.admin)
            _ProfileTile(
              Icons.admin_panel_settings_outlined,
              'Panel administrador',
              'Gestión global de SeñasApp',
              () => context.go('/admin'),
            ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () async {
              await controller.logout();
              if (context.mounted) context.go('/login');
            },
            icon: const Icon(Icons.logout),
            label: const Text('Cerrar sesión'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile(this.icon, this.title, this.subtitle, this.onTap);
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      onTap: onTap,
      minTileHeight: 72,
      leading: CircleAvatar(
        backgroundColor: AppColors.paleBlue,
        child: Icon(icon, color: AppColors.blue),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
    ),
  );
}

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

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AppController>();
    return MobileCanvas(
      child: Scaffold(
        appBar: const SenasHeader(
          title: 'Ajustes',
          showBack: true,
          backFallback: '/profile',
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          children: [
            const SectionTitle('Preferencias'),
            const SizedBox(height: 10),
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    value: controller.notifications,
                    onChanged: controller.setNotifications,
                    title: const Text('Notificaciones'),
                    secondary: const Icon(Icons.notifications_outlined),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.speed),
                    title: const Text('Velocidad de reproducción'),
                    trailing: DropdownButton<double>(
                      value: controller.playbackSpeed,
                      items: const <double>[0.5, 1.0, 1.5]
                          .map(
                            (speed) => DropdownMenuItem(
                              value: speed,
                              child: Text('${speed}x'),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) controller.setPlaybackSpeed(value);
                      },
                    ),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    value: controller.darkMode,
                    onChanged: controller.setDarkMode,
                    title: const Text('Tema oscuro'),
                    secondary: const Icon(Icons.dark_mode_outlined),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    value: controller.highContrast,
                    onChanged: controller.setHighContrast,
                    title: const Text('Alto contraste'),
                    secondary: const Icon(Icons.contrast),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            const SectionTitle('Privacidad'),
            const SizedBox(height: 10),
            Card(
              child: Column(
                children: const [
                  ListTile(
                    leading: Icon(Icons.shield_outlined),
                    title: Text('Política de privacidad'),
                    trailing: Icon(Icons.chevron_right),
                  ),
                  Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.delete_outline),
                    title: Text('Eliminar mis datos'),
                    subtitle: Text(
                      'Solicita la eliminación de tu cuenta desde soporte.',
                    ),
                    trailing: Icon(Icons.chevron_right),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            OutlinedButton.icon(
              onPressed: () async {
                await context.read<AppController>().logout();
                if (context.mounted) context.go('/login');
              },
              icon: const Icon(Icons.logout),
              label: const Text('Cerrar sesión'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});
  @override
  Widget build(BuildContext context) => MobileCanvas(
    child: Scaffold(
      appBar: SenasHeader(
        title: 'Plan Premium',
        showBack: true,
        backFallback: context.read<AppController>().isAuthenticated
            ? '/profile'
            : '/home',
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.blue, Color(0xFF6D5CE7)],
              ),
              borderRadius: BorderRadius.circular(28),
            ),
            child: const Column(
              children: [
                Icon(Icons.workspace_premium, color: Colors.white, size: 46),
                SizedBox(height: 12),
                Text(
                  'Amplía tu forma de comunicar',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Comparación informativa para el MVP académico',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Row(
                children: const [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          '50',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            color: AppColors.muted,
                          ),
                        ),
                        Text('palabras gratis', textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward, color: AppColors.blue),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          '200+',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            color: AppColors.blue,
                          ),
                        ),
                        Text('con Premium', textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _PlanCard(
            title: 'Gratuito',
            price: r'$0 COP',
            features: const [
              'Diccionario de 50 palabras',
              'Traducciones básicas',
              'Historial reciente',
            ],
          ),
          const SizedBox(height: 12),
          _PlanCard(
            title: 'Premium',
            price: r'$14.900 COP / mes',
            highlighted: true,
            features: const [
              'Diccionario de 200+ palabras y señas',
              'Traducciones ilimitadas',
              'Historial completo',
              'Nuevas señas y actualizaciones',
            ],
          ),
          const SizedBox(height: 18),
          FilledButton(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Premium es informativo en esta versión.'),
              ),
            ),
            child: const Text('Obtener Premium'),
          ),
        ],
      ),
    ),
  );
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.title,
    required this.price,
    required this.features,
    this.highlighted = false,
  });
  final String title;
  final String price;
  final List<String> features;
  final bool highlighted;
  @override
  Widget build(BuildContext context) => Card(
    color: highlighted ? AppColors.paleBlue : null,
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: highlighted ? AppColors.blueDark : null,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            price,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          ...features.map(
            (feature) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: AppColors.green,
                    size: 20,
                  ),
                  const SizedBox(width: 9),
                  Expanded(child: Text(feature)),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

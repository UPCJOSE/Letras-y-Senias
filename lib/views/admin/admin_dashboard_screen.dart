import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../controllers/app_controller.dart';
import '../../models/app_models.dart';
import '../../shared/widgets/app_widgets.dart';
import '../../theme/app_theme.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AppController>();
    return MobileCanvas(
      child: Scaffold(
        appBar: const SenasHeader(
          title: 'Panel Administrador',
          showBack: true,
          backFallback: '/profile',
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          children: [
            Text(
              'Resumen global',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            FutureBuilder<AdminDashboardStats>(
              future: controller.dashboardStats,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Card(
                    child: ListTile(
                      leading: Icon(Icons.cloud_off_outlined),
                      title: Text('No se pudieron cargar las métricas.'),
                    ),
                  );
                }
                if (!snapshot.hasData) {
                  return const SizedBox(
                    height: 160,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final stats = snapshot.data!;
                final textScale = MediaQuery.textScalerOf(context).scale(1);
                return GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: textScale >= 1.75
                        ? 210
                        : textScale >= 1.25
                        ? 148
                        : 116,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    StatCard(
                      label: 'Personas',
                      value: '${stats.people}',
                      icon: Icons.people_outline,
                    ),
                    StatCard(
                      label: 'Traducciones',
                      value: '${stats.translations}',
                      icon: Icons.translate_outlined,
                      color: AppColors.green,
                    ),
                    StatCard(
                      label: 'Señas en borrador',
                      value: '${stats.draftSigns}',
                      icon: Icons.sign_language_outlined,
                      color: const Color(0xFF7C3AED),
                    ),
                    StatCard(
                      label: 'Consultas pendientes',
                      value: '${stats.untranslatedWords}',
                      icon: Icons.help_outline,
                      color: const Color(0xFFEA580C),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            const SectionTitle('Gestión'),
            const SizedBox(height: 8),
            _AdminTile(
              Icons.manage_accounts_outlined,
              'Gestionar personas',
              'Cuentas y roles',
              () => context.push('/admin/users'),
            ),
            _AdminTile(
              Icons.menu_book_outlined,
              'Gestionar diccionario',
              'Señas y categorías',
              () => context.push('/admin/dictionary'),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminTile extends StatelessWidget {
  const _AdminTile(this.icon, this.title, this.subtitle, this.onTap);
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      minTileHeight: 76,
      onTap: onTap,
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

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../controllers/app_controller.dart';
import '../../models/app_models.dart';
import '../../shared/widgets/app_widgets.dart';
import '../../theme/app_theme.dart';

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

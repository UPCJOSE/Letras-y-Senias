import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../controllers/app_controller.dart';
import '../../shared/widgets/app_widgets.dart';

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

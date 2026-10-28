import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../controllers/app_controller.dart';
import '../../controllers/conversation_controller.dart';
import '../../models/app_models.dart';
import '../../shared/widgets/app_widgets.dart';
import '../../theme/app_theme.dart';

/// Punto de entrada de las conversaciones: crear una sala con código
/// aleatorio o unirse con el código que compartió la otra persona.
class ConversationHomeScreen extends StatefulWidget {
  const ConversationHomeScreen({super.key});
  @override
  State<ConversationHomeScreen> createState() => _ConversationHomeScreenState();
}

class _ConversationHomeScreenState extends State<ConversationHomeScreen> {
  final _codeController = TextEditingController();
  CommunicationProfile? _selected;
  bool _changingProfile = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile(ConversationController controller) async {
    final selected = _selected;
    if (selected == null) return;
    await controller.chooseProfile(selected);
    if (mounted && controller.error == null) {
      setState(() => _changingProfile = false);
    }
  }

  Future<void> _create(ConversationController controller) async {
    final code = await controller.create();
    if (code != null && mounted) context.push('/conversation/room/$code');
  }

  Future<void> _join(ConversationController controller) async {
    final code = await controller.join(_codeController.text);
    if (code != null && mounted) {
      _codeController.clear();
      context.push('/conversation/room/$code');
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ConversationController>();
    final profile = context.select<AppController, CommunicationProfile?>(
      (app) => app.communicationProfile,
    );
    final current = profile;
    final busy = controller.isBusy;
    return MobileCanvas(
      child: Scaffold(
        appBar: const SenasHeader(
          title: 'Conversación',
          showBack: true,
          backFallback: '/home',
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          children: [
            Text(
              'Conversa en una sala compartida',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 6),
            Text(
              'Una persona oyente escribe y la persona sorda ve el mensaje '
              'en señas. Ambas pueden responder por escrito.',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 18),
            if (controller.error != null)
              _ErrorCard(controller.error!, onClose: controller.clearError),
            if (current == null || _changingProfile) ...[
              const SectionTitle('¿Cómo te comunicas?'),
              const SizedBox(height: 12),
              CommunicationProfilePicker(
                value: _selected ?? profile,
                enabled: !busy,
                onChanged: (value) => setState(() => _selected = value),
              ),
              const SizedBox(height: 6),
              FilledButton(
                onPressed: busy || (_selected ?? profile) == null
                    ? null
                    : () {
                        _selected ??= profile;
                        unawaited(_saveProfile(controller));
                      },
                child: const Text('Guardar y continuar'),
              ),
            ] else ...[
              Card(
                child: ListTile(
                  leading: Icon(current.icon, color: AppColors.blue),
                  title: Text(
                    current.label,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  subtitle: Text(current.description),
                  trailing: TextButton(
                    onPressed: busy
                        ? null
                        : () => setState(() {
                            _selected = current;
                            _changingProfile = true;
                          }),
                    child: const Text('Cambiar'),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Crear una conversación',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Generamos un código al azar para que lo compartas '
                        'con ${current == CommunicationProfile.hearing ? 'una persona sorda' : 'una persona oyente'}.',
                      ),
                      const SizedBox(height: 14),
                      FilledButton.icon(
                        onPressed: busy ? null : () => _create(controller),
                        icon: const Icon(Icons.add_comment_outlined),
                        label: const Text('Generar código'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Unirme con un código',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _codeController,
                        enabled: !busy,
                        textCapitalization: TextCapitalization.characters,
                        autocorrect: false,
                        maxLength: 7,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[A-Za-z0-9-]'),
                          ),
                        ],
                        decoration: const InputDecoration(
                          labelText: 'Código de la conversación',
                          hintText: 'ABC-234',
                          prefixIcon: Icon(Icons.key_outlined),
                        ),
                        onSubmitted: busy ? null : (_) => _join(controller),
                      ),
                      const SizedBox(height: 8),
                      FilledButton.tonalIcon(
                        onPressed: busy ? null : () => _join(controller),
                        icon: busy
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.login),
                        label: const Text('Unirme'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard(this.message, {this.onClose});
  final String message;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Card(
      color: Theme.of(context).colorScheme.errorContainer,
      child: ListTile(
        leading: Icon(
          Icons.error_outline,
          color: Theme.of(context).colorScheme.onErrorContainer,
        ),
        title: Text(
          message,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onErrorContainer,
          ),
        ),
        trailing: onClose == null
            ? null
            : IconButton(
                tooltip: 'Cerrar aviso',
                onPressed: onClose,
                icon: const Icon(Icons.close),
              ),
      ),
    ),
  );
}

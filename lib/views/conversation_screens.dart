import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../controllers/app_controller.dart';
import '../controllers/conversation_controller.dart';
import '../models/app_models.dart';
import '../repositories/conversation_repository.dart';
import '../shared/widgets/app_widgets.dart';
import '../shared/widgets/lsc70_player.dart';
import '../theme/app_theme.dart';

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

/// Sala de conversación: muestra el código mientras se espera a la otra
/// persona y luego el chat con los mensajes en texto y en señas.
class ConversationRoomScreen extends StatefulWidget {
  const ConversationRoomScreen({super.key, required this.code});
  final String code;
  @override
  State<ConversationRoomScreen> createState() => _ConversationRoomScreenState();
}

class _ConversationRoomScreenState extends State<ConversationRoomScreen> {
  final _text = TextEditingController();
  final _scroll = ScrollController();
  late final ConversationController _controller;
  late final Stream<Conversation?> _conversation;
  late final Stream<List<ConversationMessage>> _messages;
  int _lastCount = 0;

  @override
  void initState() {
    super.initState();
    _controller = context.read<ConversationController>();
    _conversation = _controller.watch(widget.code);
    _messages = _controller.watchMessages(widget.code);
  }

  @override
  void dispose() {
    _text.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final value = _text.text;
    if (value.trim().isEmpty) return;
    _text.clear();
    final sent = await _controller.send(widget.code, value);
    if (!sent && mounted) {
      _text.text = value;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_controller.error ?? 'No se pudo enviar.')),
      );
    }
  }

  Future<void> _finish() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Finalizar conversación'),
        content: const Text(
          'Nadie podrá enviar más mensajes en esta sala. '
          '¿Quieres finalizarla?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Finalizar'),
          ),
        ],
      ),
    );
    if (confirmed == true) await _controller.finish(widget.code);
  }

  void _scrollToEnd(int count) {
    if (count == _lastCount) return;
    _lastCount = count;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final uid = context.select<ConversationController, String>((c) => c.uid);
    return MobileCanvas(
      child: StreamBuilder<Conversation?>(
        stream: _conversation,
        builder: (context, snapshot) {
          final conversation = snapshot.data;
          return Scaffold(
            appBar: SenasHeader(
              title: 'Conversación',
              showBack: true,
              backFallback: '/conversation',
              actions: [
                if (conversation != null &&
                    !conversation.isClosed &&
                    conversation.includes(uid))
                  IconButton(
                    tooltip: 'Finalizar conversación',
                    onPressed: _finish,
                    icon: const Icon(Icons.call_end_outlined),
                  ),
                const SizedBox(width: 4),
              ],
            ),
            body: _body(context, snapshot, conversation, uid),
          );
        },
      ),
    );
  }

  Widget _body(
    BuildContext context,
    AsyncSnapshot<Conversation?> snapshot,
    Conversation? conversation,
    String uid,
  ) {
    if (snapshot.hasError) {
      return const _RoomMessage(
        icon: Icons.cloud_off_outlined,
        title: 'No se pudo abrir la conversación',
        message: 'Revisa tu conexión e inténtalo de nuevo.',
      );
    }
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }
    if (conversation == null) {
      return const _RoomMessage(
        icon: Icons.search_off_outlined,
        title: 'Conversación no encontrada',
        message: 'Revisa el código e inténtalo de nuevo.',
      );
    }
    if (!conversation.includes(uid)) {
      return const _RoomMessage(
        icon: Icons.lock_outline,
        title: 'No participas en esta conversación',
        message: 'Únete usando el código desde la pantalla anterior.',
      );
    }
    if (!conversation.hasGuest && !conversation.isClosed) {
      return _WaitingInvite(conversation: conversation);
    }
    return _chat(context, conversation, uid);
  }

  Widget _chat(BuildContext context, Conversation conversation, String uid) {
    final partner = conversation.partnerName(uid);
    final partnerProfile = conversation.partnerProfile(uid);
    final me = context.select<ConversationController, CommunicationProfile?>(
      (c) => c.profile,
    );
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundColor: AppColors.paleBlue,
            child: Icon(
              partnerProfile?.icon ?? Icons.person_outline,
              color: AppColors.blue,
            ),
          ),
          title: Text(
            partner.isEmpty ? 'Participante' : partner,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
          subtitle: Text(partnerProfile?.label ?? ''),
          trailing: Text(
            ConversationRepository.formatCode(conversation.code),
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: StreamBuilder<List<ConversationMessage>>(
            stream: _messages,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const _RoomMessage(
                  icon: Icons.cloud_off_outlined,
                  title: 'No se pudieron cargar los mensajes',
                  message: 'Revisa tu conexión e inténtalo de nuevo.',
                );
              }
              final messages = snapshot.data;
              if (messages == null) {
                return const Center(child: CircularProgressIndicator());
              }
              if (messages.isEmpty) {
                return const _RoomMessage(
                  icon: Icons.chat_bubble_outline,
                  title: 'Todo listo',
                  message: 'Escribe el primer mensaje para empezar.',
                );
              }
              _scrollToEnd(messages.length);
              final lastIncomingSigned = messages.lastWhere(
                (m) =>
                    m.senderId != uid &&
                    m.senderProfile == CommunicationProfile.hearing,
                orElse: () => const ConversationMessage(
                  id: '',
                  senderId: '',
                  senderName: '',
                  senderProfile: CommunicationProfile.deaf,
                  text: '',
                ),
              );
              return ListView.builder(
                controller: _scroll,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return _MessageBubble(
                    key: ValueKey(message.id),
                    message: message,
                    isMine: message.senderId == uid,
                    openSigns:
                        me == CommunicationProfile.deaf &&
                        message.id == lastIncomingSigned.id,
                  );
                },
              );
            },
          ),
        ),
        if (conversation.isClosed)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            color: Theme.of(context).colorScheme.surfaceContainerHigh,
            child: const Text(
              'Esta conversación fue finalizada.',
              textAlign: TextAlign.center,
            ),
          )
        else
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 8, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _text,
                      minLines: 1,
                      maxLines: 4,
                      maxLength: ConversationRepository.maxMessageLength,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        hintText: 'Escribe un mensaje...',
                        counterText: '',
                      ),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                  const SizedBox(width: 4),
                  IconButton.filled(
                    tooltip: 'Enviar mensaje',
                    onPressed: _send,
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _RoomMessage extends StatelessWidget {
  const _RoomMessage({
    required this.icon,
    required this.title,
    required this.message,
  });
  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48, color: AppColors.blue),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
          ),
          const SizedBox(height: 6),
          Text(message, textAlign: TextAlign.center),
        ],
      ),
    ),
  );
}

class _WaitingInvite extends StatelessWidget {
  const _WaitingInvite({required this.conversation});
  final Conversation conversation;

  @override
  Widget build(BuildContext context) {
    final formatted = ConversationRepository.formatCode(conversation.code);
    final inviting = conversation.hostProfile == CommunicationProfile.hearing
        ? 'una persona sorda'
        : 'una persona oyente';
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Text(
                  'Comparte este código',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                ),
                const SizedBox(height: 14),
                Semantics(
                  label:
                      'Código de la conversación: ${formatted.split('').join(' ')}',
                  child: ExcludeSemantics(
                    child: Text(
                      formatted,
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        letterSpacing: 4,
                        color: AppColors.blue,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                OutlinedButton.icon(
                  onPressed: () async {
                    await Clipboard.setData(
                      ClipboardData(text: conversation.code),
                    );
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Código copiado.')),
                    );
                  },
                  icon: const Icon(Icons.copy_outlined),
                  label: const Text('Copiar código'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        const Center(child: CircularProgressIndicator()),
        const SizedBox(height: 14),
        Text(
          'Esperando a $inviting…\nLa conversación empieza cuando se una.',
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _MessageBubble extends StatefulWidget {
  const _MessageBubble({
    super.key,
    required this.message,
    required this.isMine,
    required this.openSigns,
  });
  final ConversationMessage message;
  final bool isMine;
  final bool openSigns;

  @override
  State<_MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<_MessageBubble> {
  late bool _showSigns = widget.openSigns;

  @override
  void didUpdateWidget(covariant _MessageBubble oldWidget) {
    super.didUpdateWidget(oldWidget);
    // El mensaje nuevo de la persona oyente se abre solo para la persona sorda.
    if (!oldWidget.openSigns && widget.openSigns) _showSigns = true;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final message = widget.message;
    final mine = widget.isMine;
    final hasSigns = message.senderProfile == CommunicationProfile.hearing;
    final foreground = mine ? Colors.white : scheme.onSurface;
    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * .85,
        ),
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 6),
          decoration: BoxDecoration(
            color: mine ? AppColors.blue : scheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!mine)
                Text(
                  message.senderName.isEmpty
                      ? message.senderProfile.label
                      : message.senderName,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: scheme.primary,
                  ),
                ),
              Text(message.text, style: TextStyle(color: foreground)),
              if (hasSigns) ...[
                TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: mine ? Colors.white : AppColors.blue,
                    visualDensity: VisualDensity.compact,
                    minimumSize: const Size(48, 40),
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: () => setState(() => _showSigns = !_showSigns),
                  icon: Icon(
                    _showSigns
                        ? Icons.visibility_off_outlined
                        : Icons.sign_language_outlined,
                    size: 18,
                  ),
                  label: Text(_showSigns ? 'Ocultar señas' : 'Ver en señas'),
                ),
                if (_showSigns)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _SignPanel(message: message),
                  ),
              ] else
                const SizedBox(height: 6),
            ],
          ),
        ),
      ),
    );
  }
}

/// Muestra el mensaje como secuencia LSC70 usando las señas de Firestore.
class _SignPanel extends StatefulWidget {
  const _SignPanel({required this.message});
  final ConversationMessage message;

  @override
  State<_SignPanel> createState() => _SignPanelState();
}

class _SignPanelState extends State<_SignPanel> {
  late final Future<TranslationResult> _future = context
      .read<ConversationController>()
      .translate(widget.message.id, widget.message.text);

  @override
  Widget build(BuildContext context) {
    final speed = context.select<ConversationController, double>(
      (c) => c.playbackSpeed,
    );
    return FutureBuilder<TranslationResult>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('No se pudo consultar el diccionario de señas.');
        }
        final result = snapshot.data;
        if (result == null) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final medias = result.sequenceEntries
            .map((sign) => sign?.media)
            .toList();
        if (!medias.any((media) => media != null)) {
          return const Text(
            'Todavía no hay señas con recurso visual para este mensaje. '
            'Lee el texto.',
          );
        }
        final scheme = Theme.of(context).colorScheme;
        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.circular(20),
          ),
          child: DefaultTextStyle.merge(
            style: TextStyle(color: scheme.onSurface),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Lsc70Player(sequence: medias, height: 200, initialSpeed: speed),
                if (medias.any((media) => media == null) ||
                    result.suggestions.isNotEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 6),
                    child: Text(
                      'Algunas palabras no tienen seña disponible; '
                      'complementa con el texto.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

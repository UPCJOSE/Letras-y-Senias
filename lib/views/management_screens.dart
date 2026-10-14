import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../controllers/app_controller.dart';
import '../models/app_models.dart';
import '../shared/widgets/app_widgets.dart';
import '../services/lsc70_manifest_service.dart';
import '../theme/app_theme.dart';

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

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  String _query = '';

  Future<void> _showCreateUserDialog(BuildContext context) async {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    var selectedRole = AppRole.individual;
    var isSaving = false;
    try {
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 20,
            ),
            title: const Text('Crear cuenta'),
            content: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nameController,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(labelText: 'Nombre'),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? 'Escribe el nombre.'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      decoration: const InputDecoration(labelText: 'Correo'),
                      validator: (value) =>
                          value == null ||
                              !RegExp(
                                r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                              ).hasMatch(value.trim())
                          ? 'Escribe un correo válido.'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Contraseña inicial',
                        helperText:
                            'Mínimo 6 caracteres. Compártela en privado.',
                      ),
                      validator: (value) => value == null || value.length < 6
                          ? 'Usa al menos 6 caracteres.'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<AppRole>(
                      initialValue: selectedRole,
                      decoration: const InputDecoration(
                        labelText: 'Tipo de cuenta',
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: AppRole.individual,
                          child: Text('Persona'),
                        ),
                        DropdownMenuItem(
                          value: AppRole.admin,
                          child: Text('Administrador'),
                        ),
                      ],
                      onChanged: isSaving
                          ? null
                          : (value) {
                              if (value != null) {
                                setDialogState(() => selectedRole = value);
                              }
                            },
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Se enviará un correo para verificar la cuenta. La sesión actual no se cerrará.',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: isSaving ? null : () => Navigator.pop(dialogContext),
                child: const Text('Cancelar'),
              ),
              FilledButton(
                onPressed: isSaving
                    ? null
                    : () async {
                        if (!formKey.currentState!.validate()) return;
                        setDialogState(() => isSaving = true);
                        try {
                          await context.read<AppController>().createUserByAdmin(
                            name: nameController.text,
                            email: emailController.text,
                            password: passwordController.text,
                            role: selectedRole,
                          );
                          if (!dialogContext.mounted) return;
                          Navigator.pop(dialogContext);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Cuenta creada. Se envió el correo de verificación.',
                              ),
                            ),
                          );
                        } catch (error) {
                          if (!context.mounted) return;
                          setDialogState(() => isSaving = false);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                error.toString().replaceFirst(
                                  'Exception: ',
                                  '',
                                ),
                              ),
                            ),
                          );
                        }
                      },
                child: isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Crear cuenta'),
              ),
            ],
          ),
        ),
      );
    } finally {
      nameController.dispose();
      emailController.dispose();
      passwordController.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AppController>();
    return MobileCanvas(
      child: Scaffold(
        appBar: const SenasHeader(
          title: 'Gestión de personas',
          showBack: true,
          backFallback: '/admin',
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
              child: TextField(
                onChanged: (value) => setState(() => _query = value),
                decoration: const InputDecoration(
                  hintText: 'Buscar por nombre o correo',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: SectionTitle('Personas registradas'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => _showCreateUserDialog(context),
                  icon: const Icon(Icons.person_add_alt_1),
                  label: const Text('Crear persona o administrador'),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<List<AppUserProfile>>(
                stream: controller.users,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('No se pudieron cargar las personas.'),
                    );
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final people = snapshot.data!.where((user) {
                    final search = _query.toLowerCase();
                    return user.displayName.toLowerCase().contains(search) ||
                        user.email.toLowerCase().contains(search);
                  }).toList();
                  if (people.isEmpty) {
                    return const Center(
                      child: Text('No hay personas que coincidan.'),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 96),
                    itemCount: people.length,
                    itemBuilder: (context, index) {
                      final user = people[index];
                      final initial = user.displayName.trim().isEmpty
                          ? '?'
                          : user.displayName.trim()[0].toUpperCase();
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(child: Text(initial)),
                          title: Text(
                            user.displayName.isEmpty
                                ? 'Sin nombre'
                                : user.displayName,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          subtitle: Text(user.email),
                          trailing: Chip(
                            label: Text(
                              user.role == AppRole.admin ? 'Admin' : 'Persona',
                            ),
                          ),
                        ),
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

class DictionaryManagementScreen extends StatefulWidget {
  const DictionaryManagementScreen({super.key});

  @override
  State<DictionaryManagementScreen> createState() =>
      _DictionaryManagementScreenState();
}

class _DictionaryManagementScreenState
    extends State<DictionaryManagementScreen> {
  bool _publishingAll = false;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AppController>();
    return MobileCanvas(
      child: Scaffold(
        appBar: const SenasHeader(
          title: 'Gestionar diccionario',
          showBack: true,
          backFallback: '/admin',
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _showForm(context),
          icon: const Icon(Icons.add),
          label: const Text('Nueva seña'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 6, 20, 0),
              child: OutlinedButton.icon(
                onPressed: () => _showManifest(context),
                icon: const Icon(Icons.cloud_upload_outlined),
                label: const Text('Importar manifiesto LSC70'),
              ),
            ),
            StreamBuilder<List<SignCategory>>(
              stream: controller.adminCategories,
              builder: (context, snapshot) {
                if (snapshot.hasError || !snapshot.hasData) {
                  return const SizedBox.shrink();
                }
                final categories = snapshot.data!;
                if (categories.isEmpty) return const SizedBox.shrink();
                return SizedBox(
                  height: 58,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    scrollDirection: Axis.horizontal,
                    children: categories
                        .map(
                          (category) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Chip(
                              label: Text(category.name),
                              avatar: Icon(
                                category.active
                                    ? Icons.category_outlined
                                    : Icons.pending_outlined,
                                size: 16,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                );
              },
            ),
            Expanded(
              child: StreamBuilder<List<SignEntry>>(
                stream: controller.allSigns,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('No se pudo cargar el diccionario.'),
                    );
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final signs = snapshot.data!;
                  if (signs.isEmpty) {
                    return const Center(
                      child: Text('Aún no hay señas en el catálogo.'),
                    );
                  }
                  final pending = signs
                      .where(
                        (sign) =>
                            !sign.validated &&
                            sign.id != null &&
                            sign.media?.isUsable == true,
                      )
                      .toList();
                  final withoutMedia = signs
                      .where((sign) => !sign.validated && sign.media == null)
                      .length;
                  return Column(
                    children: [
                      if (pending.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
                          child: SizedBox(
                            width: double.infinity,
                            child: FilledButton.icon(
                              onPressed: _publishingAll
                                  ? null
                                  : () => _validateAll(
                                      controller,
                                      pending,
                                      withoutMedia,
                                    ),
                              icon: _publishingAll
                                  ? const SizedBox.square(
                                      dimension: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(Icons.fact_check_outlined),
                              label: Text('Validar todas (${pending.length})'),
                            ),
                          ),
                        ),
                      Expanded(
                        child: ListView.separated(
                          padding: const EdgeInsets.fromLTRB(20, 4, 20, 90),
                          itemCount: signs.length,
                          separatorBuilder: (_, _) => const SizedBox(height: 2),
                          itemBuilder: (_, index) {
                            final sign = signs[index];
                            return Card(
                              child: ListTile(
                                leading: const CircleAvatar(
                                  backgroundColor: AppColors.paleBlue,
                                  child: Icon(
                                    Icons.sign_language,
                                    color: AppColors.blue,
                                  ),
                                ),
                                title: Text(
                                  sign.term,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                subtitle: Text(
                                  '${sign.category} · ${sign.animationKey}\n${sign.validated ? 'Validada y publicada' : 'Borrador · pendiente de revisión LSC'}',
                                ),
                                isThreeLine: true,
                                trailing: sign.validated && sign.active
                                    ? const Icon(
                                        Icons.verified,
                                        color: AppColors.green,
                                      )
                                    : IconButton(
                                        tooltip: 'Validar y publicar seña',
                                        onPressed: sign.id == null
                                            ? null
                                            : () => _validate(
                                                context,
                                                controller,
                                                sign,
                                              ),
                                        icon: const Icon(
                                          Icons.publish_outlined,
                                        ),
                                      ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _validateAll(
    AppController controller,
    List<SignEntry> pending,
    int withoutMedia,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Validar todas las señas'),
        content: Text(
          'Se publicarán ${pending.length} señas pendientes con recurso LSC70. '
          '${withoutMedia > 0 ? '$withoutMedia sin recurso visual quedarán sin publicar. ' : ''}'
          'Confirma únicamente si ya revisaste su correspondencia con LSC; este botón no verifica las señas automáticamente.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Validar y publicar'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted || _publishingAll) return;
    setState(() => _publishingAll = true);
    try {
      final count = await controller.validateSigns(
        pending.map((sign) => sign.id!).toList(),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$count señas validadas y publicadas.')),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo publicar el lote: $error')),
        );
      }
    } finally {
      if (mounted) setState(() => _publishingAll = false);
    }
  }

  Future<void> _validate(
    BuildContext context,
    AppController controller,
    SignEntry sign,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Validar y publicar'),
        content: Text(
          'Confirma que “${sign.term}” fue revisada con una referencia confiable de LSC antes de publicarla.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Confirmar validación'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    try {
      await controller.validateSign(sign.id!);
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo publicar la seña.')),
        );
      }
    }
  }

  void _showForm(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      constraints: const BoxConstraints(maxWidth: 430),
      builder: (_) => const _NewSignSheet(),
    );
  }

  Future<void> _showManifest(BuildContext context) async {
    final text = TextEditingController();
    List<Map<String, dynamic>>? preview;
    String? error;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 20,
          ),
          title: const Text('Importar recursos LSC70'),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Pega un JSON con entries. Las URLs deben ser HTTPS de Cloudinary. Se crearán borradores; el contenido existente solo recibirá el medio.',
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: text,
                    minLines: 6,
                    maxLines: 12,
                    decoration: const InputDecoration(
                      labelText: 'Manifiesto JSON',
                      hintText: '{"entries":[...]}',
                    ),
                  ),
                  if (error != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        error!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  if (preview != null) ...[
                    const SizedBox(height: 10),
                    Text('Vista previa: ${preview!.length} entradas'),
                    const Divider(),
                    ...preview!.map(
                      (entry) => ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.image_outlined),
                        title: Text(
                          '${entry['term']} · ${entry['animationKey']}',
                        ),
                        subtitle: Text(
                          '${entry['subset']} · ${entry['kind']} · ${entry['frameUrls'].length} fotogramas · participante ${entry['participantId']}',
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                try {
                  final parsed = Lsc70ManifestService().parse(text.text);
                  setState(() {
                    preview = parsed;
                    error = null;
                  });
                } catch (e) {
                  setState(() => error = e.toString());
                }
              },
              child: const Text('Validar'),
            ),
            FilledButton(
              onPressed: preview == null
                  ? null
                  : () async {
                      try {
                        final count = await context
                            .read<AppController>()
                            .importLsc70Manifest(text.text);
                        if (dialogContext.mounted) Navigator.pop(dialogContext);
                        if (mounted) {
                          ScaffoldMessenger.of(this.context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '$count recursos guardados como borrador.',
                              ),
                            ),
                          );
                        }
                      } catch (e) {
                        setState(() => error = e.toString());
                      }
                    },
              child: const Text('Guardar borradores'),
            ),
          ],
        ),
      ),
    );
    text.dispose();
  }
}

class _NewSignSheet extends StatefulWidget {
  const _NewSignSheet();

  @override
  State<_NewSignSheet> createState() => _NewSignSheetState();
}

class _NewSignSheetState extends State<_NewSignSheet> {
  final _formKey = GlobalKey<FormState>();
  final _term = TextEditingController();
  final _category = TextEditingController();
  final _animation = TextEditingController();
  final _aliases = TextEditingController();
  final _source = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _term.dispose();
    _category.dispose();
    _animation.dispose();
    _aliases.dispose();
    _source.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.fromLTRB(
      24,
      24,
      24,
      24 + MediaQuery.viewInsetsOf(context).bottom,
    ),
    child: Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Nueva seña', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            const Text(
              'Se guardará como borrador, aún no visible en el diccionario.',
            ),
            const SizedBox(height: 16),
            _field(_term, 'Palabra o frase'),
            _field(_category, 'Categoría'),
            _field(_animation, 'Clave de animación'),
            _field(_aliases, 'Alias separados por coma', required: false),
            _field(_source, 'Referencia LSC (opcional)', required: false),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const CircularProgressIndicator()
                  : const Text('Guardar borrador'),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _field(
    TextEditingController controller,
    String label, {
    bool required = true,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      validator: required
          ? (value) => value == null || value.trim().isEmpty
                ? 'Completa este campo'
                : null
          : null,
    ),
  );

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      await context.read<AppController>().saveDraftSign(
        term: _term.text,
        category: _category.text,
        animationKey: _animation.text,
        aliases: _aliases.text
            .split(',')
            .map((alias) => alias.trim())
            .where((alias) => alias.isNotEmpty)
            .toList(),
        source: _source.text,
      );
      if (mounted) Navigator.pop(context);
    } catch (_) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo guardar el borrador.')),
        );
      }
    }
  }
}

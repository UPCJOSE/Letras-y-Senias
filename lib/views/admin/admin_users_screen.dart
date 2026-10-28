import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/app_controller.dart';
import '../../models/app_models.dart';
import '../../shared/widgets/app_widgets.dart';

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

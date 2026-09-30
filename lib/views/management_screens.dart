import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/app_models.dart';
import '../services/translation_service.dart';
import '../shared/widgets/app_widgets.dart';
import '../theme/app_theme.dart';

const demoUsers = <DemoUser>[
  DemoUser('Juan Pérez', 'juan@empresa.com', 'Recepción', true),
  DemoUser('María Gómez', 'maria@empresa.com', 'Enfermería', true),
  DemoUser('Carlos Rodríguez', 'carlos@empresa.com', 'Administración', true),
  DemoUser('Laura Martínez', 'laura@empresa.com', 'Atención al cliente', false),
];

class CompanyDashboardScreen extends StatelessWidget {
  const CompanyDashboardScreen({super.key});
  @override
  Widget build(BuildContext context) => MobileCanvas(
    child: Scaffold(
      appBar: SenasHeader(
        title: 'SeñasApp Empresas',
        actions: [
          IconButton(
            onPressed: () => context.go('/profile'),
            icon: const Icon(Icons.person_outline),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        children: [
          Text(
            'Clínica Erasmo Ltda.',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 6),
          const Text('Panel de accesibilidad institucional'),
          const SizedBox(height: 20),
          SizedBox(
            height: 160,
            child: Row(
              children: const [
                Expanded(
                  child: StatCard(
                    label: 'Usuarios',
                    value: '127',
                    icon: Icons.people_outline,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    label: 'Traducciones',
                    value: '4.582',
                    icon: Icons.translate,
                    color: AppColors.green,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Card(
            color: AppColors.paleGreen,
            child: const ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.verified_outlined, color: AppColors.green),
              ),
              title: Text(
                'Licencia activa',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),
              subtitle: Text(
                'Plan Institucional · 127 de 150 cupos',
                style: TextStyle(color: AppColors.ink),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const SectionTitle('Acciones rápidas'),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _ActionCard(
                  icon: Icons.manage_accounts_outlined,
                  title: 'Gestionar usuarios',
                  color: AppColors.paleBlue,
                  onTap: () => context.push('/company/users'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ActionCard(
                  icon: Icons.upload_file_outlined,
                  title: 'Importar Excel',
                  color: AppColors.lavender,
                  onTap: () => context.push('/company/import'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const SectionTitle('Actividad reciente'),
          const SizedBox(height: 8),
          const Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.person_add_alt_1),
                  title: Text('3 usuarios agregados'),
                  subtitle: Text('Hoy, 10:42 a. m.'),
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.translate),
                  title: Text('218 traducciones realizadas'),
                  subtitle: Text('Esta semana'),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Card(
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: color,
              child: Icon(icon, color: AppColors.blueDark),
            ),
            const SizedBox(height: 28),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            const Icon(Icons.arrow_forward, size: 18),
          ],
        ),
      ),
    ),
  );
}

class CompanyUsersScreen extends StatefulWidget {
  const CompanyUsersScreen({super.key, this.title = 'Usuarios de empresa'});
  final String title;
  @override
  State<CompanyUsersScreen> createState() => _CompanyUsersScreenState();
}

class _CompanyUsersScreenState extends State<CompanyUsersScreen> {
  String query = '';
  @override
  Widget build(BuildContext context) {
    final users = demoUsers
        .where(
          (user) => '${user.name} ${user.email}'.toLowerCase().contains(
            query.toLowerCase(),
          ),
        )
        .toList();
    return MobileCanvas(
      child: Scaffold(
        appBar: SenasHeader(title: widget.title, showBack: true),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _showAddUser(context),
          icon: const Icon(Icons.person_add_alt_1),
          label: const Text('Agregar'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                onChanged: (value) => setState(() => query = value),
                decoration: const InputDecoration(
                  hintText: 'Buscar usuario',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 90),
                itemCount: users.length,
                itemBuilder: (_, index) {
                  final user = users[index];
                  return Card(
                    child: ListTile(
                      minTileHeight: 84,
                      leading: CircleAvatar(
                        child: Text(
                          user.name
                              .split(' ')
                              .take(2)
                              .map((part) => part[0])
                              .join(),
                        ),
                      ),
                      title: Text(
                        user.name,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      subtitle: Text('${user.role}\n${user.email}'),
                      isThreeLine: true,
                      trailing: Chip(
                        label: Text(user.active ? 'Activo' : 'Inactivo'),
                        backgroundColor: user.active
                            ? AppColors.paleGreen
                            : null,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddUser(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(
          24,
          24,
          24,
          24 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Agregar usuario',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 18),
            const TextField(decoration: InputDecoration(labelText: 'Nombre')),
            const SizedBox(height: 12),
            const TextField(decoration: InputDecoration(labelText: 'Correo')),
            const SizedBox(height: 12),
            const TextField(decoration: InputDecoration(labelText: 'Cargo')),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Usuario preparado para conectar con Firebase.',
                    ),
                  ),
                );
              },
              child: const Text('Guardar usuario'),
            ),
          ],
        ),
      ),
    );
  }
}

class ImportUsersScreen extends StatefulWidget {
  const ImportUsersScreen({super.key});
  @override
  State<ImportUsersScreen> createState() => _ImportUsersScreenState();
}

class _ImportUsersScreenState extends State<ImportUsersScreen> {
  bool loaded = false;
  @override
  Widget build(BuildContext context) => MobileCanvas(
    child: Scaffold(
      appBar: const SenasHeader(title: 'Importar usuarios', showBack: true),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        children: [
          Text(
            'Carga un archivo Excel',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          const Text(
            'La primera fila debe incluir: nombre, correo y cargo. Máximo 200 personas.',
          ),
          const SizedBox(height: 20),
          InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () => setState(() => loaded = true),
            child: Container(
              height: 180,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.blue, width: 1.5),
                borderRadius: BorderRadius.circular(24),
                color: AppColors.paleBlue.withValues(alpha: .5),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    loaded ? Icons.check_circle : Icons.upload_file,
                    size: 52,
                    color: loaded ? AppColors.green : AppColors.blue,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    loaded
                        ? 'empleados_senasapp.xlsx'
                        : 'Seleccionar archivo .xlsx',
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    loaded
                        ? '4 filas válidas · 0 errores'
                        : 'Vista de demostración',
                  ),
                ],
              ),
            ),
          ),
          if (loaded) ...[
            const SizedBox(height: 22),
            const SectionTitle('Vista previa'),
            const SizedBox(height: 10),
            Card(
              clipBehavior: Clip.antiAlias,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Nombre')),
                    DataColumn(label: Text('Correo')),
                    DataColumn(label: Text('Cargo')),
                  ],
                  rows: demoUsers
                      .map(
                        (user) => DataRow(
                          cells: [
                            DataCell(Text(user.name)),
                            DataCell(Text(user.email)),
                            DataCell(Text(user.role)),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('4 invitaciones listas para Firebase.'),
                ),
              ),
              icon: const Icon(Icons.group_add_outlined),
              label: const Text('Importar usuarios'),
            ),
          ],
        ],
      ),
    ),
  );
}

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});
  @override
  Widget build(BuildContext context) => MobileCanvas(
    child: Scaffold(
      appBar: SenasHeader(
        title: 'Panel Administrador',
        leading: Builder(
          builder: (context) => IconButton(
            tooltip: 'Abrir menú',
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: const Icon(Icons.menu),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => context.go('/profile'),
            icon: const Icon(Icons.close),
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 12, 10),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: AppColors.paleBlue,
                      child: Icon(
                        Icons.admin_panel_settings,
                        color: AppColors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SeñasApp',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            'Administración',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Cerrar menú',
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              _AdminDrawerTile(
                icon: Icons.dashboard_outlined,
                label: 'Resumen',
                onTap: () => _openAdminDestination(context, '/admin'),
              ),
              _AdminDrawerTile(
                icon: Icons.manage_accounts_outlined,
                label: 'Personas',
                onTap: () => _openAdminDestination(context, '/admin/users'),
              ),
              _AdminDrawerTile(
                icon: Icons.menu_book_outlined,
                label: 'Diccionario',
                onTap: () =>
                    _openAdminDestination(context, '/admin/dictionary'),
              ),
              _AdminDrawerTile(
                icon: Icons.category_outlined,
                label: 'Categorías',
                onTap: () =>
                    _openAdminDestination(context, '/admin/dictionary'),
              ),
              _AdminDrawerTile(
                icon: Icons.workspace_premium_outlined,
                label: 'Suscripciones',
                onTap: () => _openAdminDestination(context, '/premium'),
              ),
              const Spacer(),
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Panel demostrativo · sin conexiones',
                  style: TextStyle(color: AppColors.muted, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        children: [
          Text(
            'Resumen global',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.08,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: const [
              StatCard(
                label: 'Personas',
                value: '1.284',
                icon: Icons.people_outline,
              ),
              StatCard(
                label: 'Traducciones',
                value: '4.860',
                icon: Icons.translate_outlined,
                color: AppColors.green,
              ),
              StatCard(
                label: 'Nuevas señas',
                value: '12',
                icon: Icons.sign_language_outlined,
                color: Color(0xFF7C3AED),
              ),
              StatCard(
                label: 'Sin traducción',
                value: '86',
                icon: Icons.help_outline,
                color: Color(0xFFEA580C),
              ),
            ],
          ),
          const SizedBox(height: 22),
          const SectionTitle('Gestión'),
          const SizedBox(height: 10),
          _AdminTile(
            Icons.manage_accounts_outlined,
            'Gestionar personas',
            'Personas registradas',
            () => context.push('/admin/users'),
          ),
          _AdminTile(
            Icons.menu_book_outlined,
            'Gestionar diccionario',
            '${demoCatalog.length} señas en el catálogo demo',
            () => context.push('/admin/dictionary'),
          ),
          _AdminTile(
            Icons.animation_outlined,
            'Editor de avatar',
            'Prototipo de movimientos y keyframes',
            () => context.push('/admin/avatar-editor'),
          ),
        ],
      ),
    ),
  );
}

void _openAdminDestination(BuildContext context, String location) {
  final router = GoRouter.of(context);
  final currentLocation = GoRouterState.of(context).uri.path;
  Navigator.of(context).pop();
  if (currentLocation != location) router.push(location);
}

class _AdminDrawerTile extends StatelessWidget {
  const _AdminDrawerTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ListTile(
    leading: Icon(icon),
    title: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
    onTap: onTap,
  );
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

class AdminUsersScreen extends StatelessWidget {
  const AdminUsersScreen({super.key});
  @override
  Widget build(BuildContext context) => MobileCanvas(
    child: Scaffold(
      appBar: const SenasHeader(title: 'Gestión de personas', showBack: true),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        children: [
          const SectionTitle('Personas registradas'),
          const SizedBox(height: 10),
          for (final user in const [
            DemoUser('Andrés López', 'andres@email.com', 'Persona', true),
            DemoUser('Camila Torres', 'camila@email.com', 'Persona', true),
            DemoUser('Sebastián Ruiz', 'sebastian@email.com', 'Persona', true),
            DemoUser('Laura Martínez', 'laura@email.com', 'Persona', false),
          ])
            Card(
              child: ListTile(
                leading: CircleAvatar(child: Text(user.name[0])),
                title: Text(
                  user.name,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: Text(user.email),
                trailing: Chip(
                  label: Text(user.active ? 'Activo' : 'Inactivo'),
                ),
              ),
            ),
        ],
      ),
    ),
  );
}

class DictionaryManagementScreen extends StatelessWidget {
  const DictionaryManagementScreen({super.key});
  @override
  Widget build(BuildContext context) => MobileCanvas(
    child: Scaffold(
      appBar: const SenasHeader(title: 'Gestionar diccionario', showBack: true),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showForm(context),
        icon: const Icon(Icons.add),
        label: const Text('Nueva seña'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 90),
        itemCount: demoCatalog.length,
        separatorBuilder: (_, _) => const SizedBox(height: 2),
        itemBuilder: (_, index) {
          final sign = demoCatalog[index];
          return Card(
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: AppColors.paleBlue,
                child: Icon(Icons.sign_language, color: AppColors.blue),
              ),
              title: Text(
                sign.term,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              subtitle: Text('${sign.category} · ${sign.animationKey}'),
              trailing: Icon(
                sign.validated ? Icons.verified : Icons.pending_outlined,
                color: sign.validated ? AppColors.green : AppColors.muted,
              ),
            ),
          );
        },
      ),
    ),
  );

  void _showForm(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(
          24,
          24,
          24,
          24 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Nueva seña', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            const TextField(decoration: InputDecoration(labelText: 'Palabra')),
            const SizedBox(height: 12),
            const TextField(
              decoration: InputDecoration(labelText: 'Categoría'),
            ),
            const SizedBox(height: 12),
            const TextField(
              decoration: InputDecoration(labelText: 'Descripción'),
              maxLines: 2,
            ),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                context.push('/admin/avatar-editor');
              },
              child: const Text('Continuar al editor'),
            ),
          ],
        ),
      ),
    );
  }
}

class AvatarEditorScreen extends StatefulWidget {
  const AvatarEditorScreen({super.key});
  @override
  State<AvatarEditorScreen> createState() => _AvatarEditorScreenState();
}

class _AvatarEditorScreenState extends State<AvatarEditorScreen> {
  double shoulder = 0;
  double elbow = 25;
  double wrist = -12;
  double head = 0;
  @override
  Widget build(BuildContext context) => MobileCanvas(
    child: Scaffold(
      appBar: const SenasHeader(title: 'Editor de avatar', showBack: true),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        children: [
          const AvatarStage(height: 220, label: 'Vista previa del rig'),
          const SizedBox(height: 18),
          _EditorSlider(
            'Rotación hombro',
            shoulder,
            (value) => setState(() => shoulder = value),
          ),
          _EditorSlider(
            'Rotación codo',
            elbow,
            (value) => setState(() => elbow = value),
          ),
          _EditorSlider(
            'Rotación muñeca',
            wrist,
            (value) => setState(() => wrist = value),
          ),
          _EditorSlider(
            'Giro de cabeza',
            head,
            (value) => setState(() => head = value),
          ),
          const SizedBox(height: 14),
          const SectionTitle('Timeline'),
          const SizedBox(height: 12),
          Container(
            height: 72,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                for (var index = 0; index < 4; index++) ...[
                  CircleAvatar(
                    radius: 10,
                    backgroundColor: index == 1
                        ? AppColors.blue
                        : AppColors.paleBlue,
                  ),
                  if (index < 3) const Expanded(child: Divider(thickness: 3)),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add_circle_outline),
            label: const Text('Agregar keyframe'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
            ),
          ),
          const SizedBox(height: 10),
          FilledButton.icon(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Borrador guardado. La exportación Rive llegará en otro hito.',
                ),
              ),
            ),
            icon: const Icon(Icons.save_outlined),
            label: const Text('Guardar seña'),
          ),
        ],
      ),
    ),
  );
}

class _EditorSlider extends StatelessWidget {
  const _EditorSlider(this.label, this.value, this.onChanged);
  final String label;
  final double value;
  final ValueChanged<double> onChanged;
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              Text('${value.round()}°'),
            ],
          ),
          Slider(value: value, min: -90, max: 90, onChanged: onChanged),
        ],
      ),
    ),
  );
}

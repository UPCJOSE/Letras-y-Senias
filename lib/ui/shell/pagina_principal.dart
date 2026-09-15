import 'package:flutter/material.dart';
import 'package:movi/ui/admin/pagina_admin.dart';
import 'package:movi/ui/aplicacion.dart';
import 'package:movi/ui/traductor/pagina_traductor.dart';

/// Contenedor con navegación inferior: Traductor y Admin CMS.
class PaginaPrincipal extends StatefulWidget {
  const PaginaPrincipal({super.key});

  @override
  State<PaginaPrincipal> createState() => _EstadoPaginaPrincipal();
}

class _EstadoPaginaPrincipal extends State<PaginaPrincipal> {
  int _indice = 0;

  static const _paginas = [
    PaginaTraductor(),
    PaginaAdmin(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _indice,
        children: _paginas,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indice,
        onDestinationSelected: (i) => setState(() => _indice = i),
        indicatorColor: ColoresApp.azul.withValues(alpha: 0.15),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.sign_language_outlined),
            selectedIcon: Icon(Icons.sign_language, color: ColoresApp.azul),
            label: 'Traductor',
          ),
          NavigationDestination(
            icon: Icon(Icons.admin_panel_settings_outlined),
            selectedIcon: Icon(
              Icons.admin_panel_settings,
              color: ColoresApp.azul,
            ),
            label: 'Admin CMS',
          ),
        ],
      ),
    );
  }
}

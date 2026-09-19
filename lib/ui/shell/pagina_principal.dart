import 'package:flutter/material.dart';
import 'package:movi/ui/aplicacion.dart';
import 'package:movi/ui/diccionario/pagina_diccionario.dart';
import 'package:movi/ui/inicio/pagina_inicio.dart';
import 'package:movi/ui/perfil/pagina_perfil.dart';
import 'package:movi/ui/shell/widgets/menu_hamburguesa.dart';

/// Shell principal: Inicio · Diccionario · Perfil + FAB hamburguesa.
class PaginaPrincipal extends StatefulWidget {
  const PaginaPrincipal({super.key});

  @override
  State<PaginaPrincipal> createState() => _EstadoPaginaPrincipal();
}

class _EstadoPaginaPrincipal extends State<PaginaPrincipal> {
  int _indice = 0;

  static const _paginas = [
    PaginaInicio(),
    PaginaDiccionario(),
    PaginaPerfil(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColoresApp.fondo,
      body: SafeArea(
        child: IndexedStack(
          index: _indice,
          children: _paginas,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => mostrarMenuHamburguesa(
          context,
          irAPestana: (i) => setState(() => _indice = i),
        ),
        backgroundColor: ColoresApp.azul,
        elevation: 4,
        child: const Icon(Icons.menu, color: ColoresApp.blanco),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: NavigationBar(
        height: 68,
        backgroundColor: ColoresApp.blanco,
        indicatorColor: ColoresApp.azulSuave,
        selectedIndex: _indice,
        onDestinationSelected: (i) => setState(() => _indice = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: ColoresApp.azul),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book, color: ColoresApp.azul),
            label: 'Diccionario',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: ColoresApp.azul),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

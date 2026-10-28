import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.index,
    this.onDestinationSelected,
  });
  final int index;
  final ValueChanged<int>? onDestinationSelected;
  @override
  Widget build(BuildContext context) => NavigationBar(
    selectedIndex: index,
    height: 72,
    destinations: const [
      NavigationDestination(
        icon: Icon(Icons.home_outlined),
        selectedIcon: Icon(Icons.home),
        label: 'Inicio',
      ),
      NavigationDestination(
        icon: Icon(Icons.translate_outlined),
        selectedIcon: Icon(Icons.translate),
        label: 'Traducir',
      ),
      NavigationDestination(
        icon: Icon(Icons.menu_book_outlined),
        selectedIcon: Icon(Icons.menu_book),
        label: 'Diccionario',
      ),
      NavigationDestination(
        icon: Icon(Icons.person_outline),
        selectedIcon: Icon(Icons.person),
        label: 'Perfil',
      ),
    ],
    onDestinationSelected: (value) {
      if (onDestinationSelected != null) {
        onDestinationSelected!(value);
        return;
      }
      const locations = ['/home', '/translate', '/dictionary', '/profile'];
      context.go(locations[value]);
    },
  );
}

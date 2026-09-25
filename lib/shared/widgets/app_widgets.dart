import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme/app_theme.dart';

class MobileCanvas extends StatelessWidget {
  const MobileCanvas({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => ColoredBox(
    color: Theme.of(context).colorScheme.surfaceContainerHighest,
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 430),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            boxShadow: const [
              BoxShadow(
                color: Color(0x26000000),
                blurRadius: 28,
                spreadRadius: 3,
              ),
            ],
          ),
          child: child,
        ),
      ),
    ),
  );
}

class SenasHeader extends StatelessWidget implements PreferredSizeWidget {
  const SenasHeader({
    super.key,
    this.title,
    this.showBack = false,
    this.actions,
  });
  final String? title;
  final bool showBack;
  final List<Widget>? actions;
  @override
  Size get preferredSize => const Size.fromHeight(68);
  @override
  Widget build(BuildContext context) => AppBar(
    automaticallyImplyLeading: showBack,
    titleSpacing: showBack ? 0 : 20,
    title: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title == null) ...[
          const Text('🤟', style: TextStyle(fontSize: 24)),
          const SizedBox(width: 8),
        ],
        Text(
          title ?? 'SeñasApp',
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ],
    ),
    actions: actions,
    centerTitle: false,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    surfaceTintColor: Colors.transparent,
  );
}

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key, required this.index});
  final int index;
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
      const locations = ['/home', '/translate', '/dictionary', '/profile'];
      context.go(locations[value]);
    },
  );
}

class AvatarStage extends StatelessWidget {
  const AvatarStage({super.key, this.height = 250, this.label = 'Avatar 2D'});
  final double height;
  final String label;
  @override
  Widget build(BuildContext context) => Container(
    height: height,
    width: double.infinity,
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFFE7F0FF), Color(0xFFF5F0FF)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(24),
    ),
    child: Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          top: 14,
          right: 14,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text(
                'DEMO',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: AppColors.blue,
                ),
              ),
            ),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              radius: 42,
              backgroundColor: Color(0xFFFFCC80),
              child: Icon(Icons.face_3, size: 62, color: AppColors.blueDark),
            ),
            Transform.translate(
              offset: const Offset(0, -2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.sign_language,
                    size: 42,
                    color: AppColors.blueDark,
                  ),
                  Container(
                    width: 92,
                    height: 62,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: const BoxDecoration(
                      color: AppColors.blue,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.sign_language,
                    size: 42,
                    color: AppColors.blueDark,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.blueDark,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.title, {super.key, this.action});
  final String title;
  final Widget? action;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Text(title, style: Theme.of(context).textTheme.titleLarge),
      ),
      ...[action].nonNulls,
    ],
  );
}

class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.color = AppColors.blue,
  });
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: color.withValues(alpha: .12),
            child: Icon(icon, color: color),
          ),
          const Spacer(),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
          Text(
            label,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    ),
  );
}

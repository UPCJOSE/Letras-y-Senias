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
    this.backFallback = '/home',
    this.actions,
    this.leading,
  });
  final String? title;
  final bool showBack;
  final String backFallback;
  final List<Widget>? actions;
  final Widget? leading;
  @override
  Size get preferredSize => const Size.fromHeight(68);
  @override
  Widget build(BuildContext context) => AppBar(
    automaticallyImplyLeading: false,
    leading:
        leading ??
        (showBack
            ? IconButton(
                tooltip: 'Volver',
                onPressed: () => navigateBack(context, backFallback),
                icon: const Icon(Icons.arrow_back),
              )
            : null),
    titleSpacing: showBack ? 0 : 20,
    title: Row(
      children: [
        if (title == null) ...[
          const Text('🤟', style: TextStyle(fontSize: 24)),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Text(
            title ?? 'SeñasApp',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
      ],
    ),
    actions: actions,
    centerTitle: false,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    surfaceTintColor: Colors.transparent,
  );
}

void navigateBack(BuildContext context, String fallback) {
  if (context.canPop()) {
    context.pop();
  } else {
    context.go(fallback);
  }
}

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

void openTranslationDestination(BuildContext context, String route) {
  if (route == '/translate') {
    context.go(route);
  } else if (GoRouterState.of(context).uri.path != route) {
    context.push(route);
  }
}

class TranslationNotice extends StatelessWidget {
  const TranslationNotice(this.message, {super.key});

  final String? message;

  @override
  Widget build(BuildContext context) {
    if (message == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Text(message!),
        ),
      ),
    );
  }
}

class FirebaseSignStage extends StatelessWidget {
  const FirebaseSignStage({
    required this.title,
    required this.message,
    this.icon = Icons.cloud_outlined,
    super.key,
  });

  final String title;
  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Container(
    height: 250,
    width: double.infinity,
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFFE7F0FF), Color(0xFFF5F0FF)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(24),
    ),
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 54, color: AppColors.blue),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.blueDark,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(message, textAlign: TextAlign.center),
        ],
      ),
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
  Widget build(BuildContext context) {
    final largeText = MediaQuery.textScalerOf(context).scale(1) >= 1.5;
    final iconBadge = CircleAvatar(
      radius: 18,
      backgroundColor: color.withValues(alpha: .12),
      child: Icon(icon, color: color, size: 20),
    );
    final metric = Text(
      value,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(
        context,
      ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
    );
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (largeText) ...[
              iconBadge,
              metric,
            ] else
              Row(children: [iconBadge, const Spacer(), metric]),
            Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

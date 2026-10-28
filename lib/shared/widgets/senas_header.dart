import 'package:flutter/material.dart';

import 'navigation_helpers.dart';

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

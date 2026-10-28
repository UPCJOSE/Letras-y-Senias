import 'package:flutter/material.dart';

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

import 'package:flutter/material.dart';

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

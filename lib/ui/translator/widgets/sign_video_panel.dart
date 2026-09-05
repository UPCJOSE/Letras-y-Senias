import 'package:flutter/material.dart';
import 'package:movi/ui/app.dart';
import 'package:movi/ui/translator/widgets/video_controls_bar.dart';

/// Panel superior: aquí se reproducirán los videos de las señas.
class SignVideoPanel extends StatelessWidget {
  const SignVideoPanel({
    super.key,
    required this.durationLabel,
    this.signLabel,
  });

  final String durationLabel;

  /// Texto de la seña actual (placeholder hasta conectar el video real).
  final String? signLabel;

  @override
  Widget build(BuildContext context) {
    final haySena = signLabel != null && signLabel!.isNotEmpty;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.blue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Señas',
                style: TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  border: Border.all(color: AppColors.black, width: 1.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: haySena
                            ? _SignPlaceholder(label: signLabel!)
                            : const _EmptySignPlaceholder(),
                      ),
                    ),
                    if (haySena)
                      VideoControlsBar(durationLabel: durationLabel),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Estado vacío: aún no hay seña que mostrar.
class _EmptySignPlaceholder extends StatelessWidget {
  const _EmptySignPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.sign_language_outlined,
            size: 64,
            color: AppColors.black,
          ),
          SizedBox(height: 12),
          Text(
            'Aquí aparecerán las señas',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Escribe un texto y pulsa Traducir',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.hint,
            ),
          ),
        ],
      ),
    );
  }
}

/// Placeholder temporal cuando ya hay texto traducido (luego será video).
class _SignPlaceholder extends StatelessWidget {
  const _SignPlaceholder({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.black, width: 2),
          ),
          child: const Icon(
            Icons.person_outline,
            size: 72,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.blackSoft,
          ),
        ),
      ],
    );
  }
}

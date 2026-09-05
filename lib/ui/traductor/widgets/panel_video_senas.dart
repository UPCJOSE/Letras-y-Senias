import 'package:flutter/material.dart';
import 'package:movi/ui/aplicacion.dart';
import 'package:movi/ui/traductor/widgets/barra_controles_video.dart';

/// Panel superior: aquí se reproducirán los videos de las señas.
class PanelVideoSenas extends StatelessWidget {
  const PanelVideoSenas({
    super.key,
    required this.etiquetaDuracion,
    this.etiquetaSena,
  });

  final String etiquetaDuracion;

  /// Texto de la seña actual (placeholder hasta conectar el video real).
  final String? etiquetaSena;

  @override
  Widget build(BuildContext context) {
    final haySena = etiquetaSena != null && etiquetaSena!.isNotEmpty;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: ColoresApp.blanco,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColoresApp.borde, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: ColoresApp.azul,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Señas',
                style: TextStyle(
                  color: ColoresApp.blanco,
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
                  color: ColoresApp.blanco,
                  border: Border.all(color: ColoresApp.negro, width: 1.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: haySena
                            ? _MarcadorSena(etiqueta: etiquetaSena!)
                            : const _MarcadorSenaVacio(),
                      ),
                    ),
                    if (haySena)
                      BarraControlesVideo(etiquetaDuracion: etiquetaDuracion),
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
class _MarcadorSenaVacio extends StatelessWidget {
  const _MarcadorSenaVacio();

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
            color: ColoresApp.negro,
          ),
          SizedBox(height: 12),
          Text(
            'Aquí aparecerán las señas',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: ColoresApp.negro,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Escribe un texto y pulsa Traducir',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: ColoresApp.textoAyuda,
            ),
          ),
        ],
      ),
    );
  }
}

/// Marcador temporal cuando ya hay texto traducido (luego será video).
class _MarcadorSena extends StatelessWidget {
  const _MarcadorSena({required this.etiqueta});

  final String etiqueta;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            border: Border.all(color: ColoresApp.negro, width: 2),
          ),
          child: const Icon(
            Icons.person_outline,
            size: 72,
            color: ColoresApp.negro,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          etiqueta,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: ColoresApp.negroSuave,
          ),
        ),
      ],
    );
  }
}

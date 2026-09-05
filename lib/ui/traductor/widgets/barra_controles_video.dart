import 'package:flutter/material.dart';
import 'package:movi/ui/aplicacion.dart';

/// Barra de controles del video (solo UI; sin reproducción real aún).
class BarraControlesVideo extends StatelessWidget {
  const BarraControlesVideo({
    super.key,
    required this.etiquetaDuracion,
  });

  final String etiquetaDuracion;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: Row(
        children: [
          const Icon(Icons.play_arrow, color: ColoresApp.azul, size: 28),
          const SizedBox(width: 4),
          const Icon(Icons.volume_up, color: ColoresApp.negro, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 3,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                activeTrackColor: ColoresApp.azul,
                inactiveTrackColor: Color(0xFFDDDDDD),
                thumbColor: ColoresApp.azul,
              ),
              child: Slider(
                value: 0,
                onChanged: (_) {},
              ),
            ),
          ),
          Text(
            etiquetaDuracion,
            style: const TextStyle(
              fontSize: 12,
              color: ColoresApp.negroSuave,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.fullscreen, color: ColoresApp.negro, size: 22),
        ],
      ),
    );
  }
}

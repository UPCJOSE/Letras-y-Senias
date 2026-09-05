import 'package:flutter/material.dart';
import 'package:movi/ui/app.dart';

/// Barra de controles del video (solo UI; sin reproducción real aún).
class VideoControlsBar extends StatelessWidget {
  const VideoControlsBar({
    super.key,
    required this.durationLabel,
  });

  final String durationLabel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: Row(
        children: [
          const Icon(Icons.play_arrow, color: AppColors.blue, size: 28),
          const SizedBox(width: 4),
          const Icon(Icons.volume_up, color: AppColors.black, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 3,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                activeTrackColor: AppColors.blue,
                inactiveTrackColor: Color(0xFFDDDDDD),
                thumbColor: AppColors.blue,
              ),
              child: Slider(
                value: 0,
                onChanged: (_) {},
              ),
            ),
          ),
          Text(
            durationLabel,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.blackSoft,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.fullscreen, color: AppColors.black, size: 22),
        ],
      ),
    );
  }
}

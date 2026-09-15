import 'package:flutter/material.dart';
import 'package:movi/ui/aplicacion.dart';

/// Placeholder de video de seña (como VideoPlaceholder del mockup React).
class MarcadorVideoSena extends StatefulWidget {
  const MarcadorVideoSena({
    super.key,
    required this.palabra,
    required this.emoji,
    this.grande = false,
  });

  final String palabra;
  final String emoji;
  final bool grande;

  @override
  State<MarcadorVideoSena> createState() => _EstadoMarcadorVideoSena();
}

class _EstadoMarcadorVideoSena extends State<MarcadorVideoSena> {
  bool _reproduciendo = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _reproduciendo = !_reproduciendo),
      child: AspectRatio(
        aspectRatio: widget.grande ? 16 / 9 : 1,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1E3A8A), ColoresApp.azul],
            ),
          ),
          child: Stack(
            children: [
              Center(
                child: AnimatedOpacity(
                  opacity: _reproduciendo ? 0.55 : 1,
                  duration: const Duration(milliseconds: 250),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.emoji,
                        style: TextStyle(fontSize: widget.grande ? 64 : 40),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.palabra.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: ColoresApp.blanco.withValues(alpha: 0.75),
                          fontSize: 11,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_reproduciendo)
                const Center(
                  child: SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: ColoresApp.blanco,
                    ),
                  ),
                ),
              Positioned(
                right: 12,
                bottom: 12,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: _reproduciendo
                        ? const Color(0xFFE11D48)
                        : ColoresApp.blanco.withValues(alpha: 0.22),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _reproduciendo ? Icons.stop : Icons.play_arrow,
                    color: ColoresApp.blanco,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

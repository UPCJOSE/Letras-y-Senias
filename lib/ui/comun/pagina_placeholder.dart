import 'package:flutter/material.dart';
import 'package:movi/ui/aplicacion.dart';

/// Pantalla temporal para opciones del menú aún sin UI completa.
class PaginaPlaceholder extends StatelessWidget {
  const PaginaPlaceholder({super.key, required this.titulo});

  final String titulo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColoresApp.fondo,
      appBar: AppBar(
        backgroundColor: ColoresApp.blanco,
        foregroundColor: ColoresApp.negro,
        elevation: 0,
        title: Text(titulo),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.construction, size: 48, color: ColoresApp.azul),
              const SizedBox(height: 12),
              Text(
                titulo,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: ColoresApp.negro,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Pantalla del menú (UI pendiente).',
                textAlign: TextAlign.center,
                style: TextStyle(color: ColoresApp.textoAyuda),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

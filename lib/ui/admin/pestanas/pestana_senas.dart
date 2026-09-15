import 'package:flutter/material.dart';
import 'package:movi/ui/admin/widgets/dialogo_nueva_sena.dart';
import 'package:movi/ui/aplicacion.dart';

/// Pestaña Señas del CMS (referencia de UX para "Nueva Seña").
class PestanaSenas extends StatelessWidget {
  const PestanaSenas({super.key});

  Future<void> _abrirNuevaSena(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (_) => const DialogoNuevaSena(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  '6 señas registradas',
                  style: TextStyle(color: ColoresApp.textoAyuda),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _abrirNuevaSena(context),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('+ Añadir Seña'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView(
              children: const [
                _FilaSenaDemo(
                  palabra: 'Hola',
                  detalle: 'Saludos · 2026-09-10',
                  estado: 'publicado',
                ),
                _FilaSenaDemo(
                  palabra: 'Gracias',
                  detalle: 'Saludos · 2026-09-10',
                  estado: 'publicado',
                ),
                _FilaSenaDemo(
                  palabra: 'Familia',
                  detalle: 'Familia · 2026-09-08',
                  estado: 'borrador',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FilaSenaDemo extends StatelessWidget {
  const _FilaSenaDemo({
    required this.palabra,
    required this.detalle,
    required this.estado,
  });

  final String palabra;
  final String detalle;
  final String estado;

  @override
  Widget build(BuildContext context) {
    final publicado = estado == 'publicado';
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: ColoresApp.blanco,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      child: ListTile(
        title: Text(
          palabra,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: ColoresApp.negro,
          ),
        ),
        subtitle: Text(detalle),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: publicado
                ? const Color(0xFFE8F5E9)
                : const Color(0xFFEEEEEE),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            estado,
            style: TextStyle(
              fontSize: 12,
              color: publicado
                  ? const Color(0xFF2E7D32)
                  : ColoresApp.textoAyuda,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:movi/model/concepto_palabra.dart';
import 'package:movi/service/servicio_palabras.dart';
import 'package:movi/ui/admin/widgets/dialogo_anadir_alias.dart';
import 'package:movi/ui/admin/widgets/tarjeta_concepto.dart';
import 'package:movi/ui/aplicacion.dart';

/// Pestaña Palabras: enlaza conceptos con alias y abre el diálogo de alta.
class PestanaPalabras extends StatelessWidget {
  const PestanaPalabras({
    super.key,
    required this.servicio,
    required this.alCambiar,
  });

  final ServicioPalabras servicio;
  final VoidCallback alCambiar;

  Future<void> _abrirAnadirAlias(
    BuildContext context, {
    ConceptoPalabra? conceptoPreseleccionado,
  }) async {
    final resultado = await showDialog<ResultadoAlias>(
      context: context,
      builder: (_) => DialogoAnadirAlias(
        conceptos: servicio.obtenerConceptos(),
        conceptoInicial: conceptoPreseleccionado,
      ),
    );

    if (resultado == null || !context.mounted) return;

    final ok = servicio.anadirAlias(
      idConcepto: resultado.idConcepto,
      alias: resultado.alias,
    );

    alCambiar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok
              ? 'Alias "${resultado.alias}" añadido'
              : 'Ese alias ya existe o no es válido',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final conceptos = servicio.obtenerConceptos();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Palabras enlazadas a señas',
                  style: TextStyle(color: ColoresApp.textoAyuda),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _abrirAnadirAlias(context),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('+ Añadir alias'),
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
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFFFE082)),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, color: Color(0xFFF9A825), size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Aquí se enlazan palabras en español con sus señas '
                    'en el catálogo. Un mismo concepto puede tener '
                    'múltiples palabras asociadas.',
                    style: TextStyle(
                      fontSize: 13,
                      color: ColoresApp.negroSuave,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              itemCount: conceptos.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final concepto = conceptos[i];
                return TarjetaConcepto(
                  concepto: concepto,
                  alAnadirAlias: () => _abrirAnadirAlias(
                    context,
                    conceptoPreseleccionado: concepto,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:movi/model/concepto_palabra.dart';
import 'package:movi/ui/aplicacion.dart';

/// Tarjeta de un concepto con chips de alias y botón "+ añadir alias".
class TarjetaConcepto extends StatelessWidget {
  const TarjetaConcepto({
    super.key,
    required this.concepto,
    required this.alAnadirAlias,
  });

  final ConceptoPalabra concepto;
  final VoidCallback alAnadirAlias;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ColoresApp.blanco,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFEEF5FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(concepto.emoji, style: const TextStyle(fontSize: 22)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  concepto.titulo,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: ColoresApp.negro,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    ...concepto.aliases.map(
                      (alias) => Chip(
                        label: Text(alias),
                        labelStyle: const TextStyle(
                          fontSize: 12,
                          color: ColoresApp.azul,
                        ),
                        backgroundColor: const Color(0xFFEEF5FF),
                        side: BorderSide.none,
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: EdgeInsets.zero,
                      ),
                    ),
                    ActionChip(
                      avatar: const Icon(
                        Icons.add,
                        size: 16,
                        color: ColoresApp.textoAyuda,
                      ),
                      label: const Text('+ añadir alias'),
                      labelStyle: const TextStyle(
                        fontSize: 12,
                        color: ColoresApp.textoAyuda,
                      ),
                      backgroundColor: const Color(0xFFF5F5F5),
                      side: BorderSide.none,
                      onPressed: alAnadirAlias,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '→ ${concepto.claveSena}',
            style: const TextStyle(
              fontSize: 12,
              color: ColoresApp.textoAyuda,
            ),
          ),
        ],
      ),
    );
  }
}

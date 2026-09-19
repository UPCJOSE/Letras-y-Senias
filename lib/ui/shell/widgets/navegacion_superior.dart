import 'package:flutter/material.dart';
import 'package:movi/ui/aplicacion.dart';

/// Navegación superior del mockup (emoji + etiqueta, scroll en móvil).
class NavegacionSuperior extends StatelessWidget {
  const NavegacionSuperior({
    super.key,
    required this.indice,
    required this.alCambiar,
  });

  final int indice;
  final ValueChanged<int> alCambiar;

  static const _items = [
    ('🤟', 'Traductor'),
    ('📖', 'Palabras'),
    ('🧬', 'Vectorial'),
    ('⚙️', 'Admin CMS'),
    ('⭐', 'Suscripción'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColoresApp.blanco,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Row(
          children: List.generate(_items.length, (i) {
            final item = _items[i];
            final activo = i == indice;
            return InkWell(
              onTap: () => alCambiar(i),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: activo ? ColoresApp.azul : Colors.transparent,
                      width: 2.5,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Text(item.$1, style: const TextStyle(fontSize: 15)),
                    const SizedBox(width: 6),
                    Text(
                      item.$2,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight:
                            activo ? FontWeight.w700 : FontWeight.w500,
                        color: activo ? ColoresApp.azul : ColoresApp.textoAyuda,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

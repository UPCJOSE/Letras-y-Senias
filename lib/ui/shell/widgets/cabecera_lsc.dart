import 'package:flutter/material.dart';
import 'package:movi/model/sesion_usuario.dart';
import 'package:movi/ui/aplicacion.dart';

/// Cabecera del mockup: logo + Fase 1 | sesión o estado LSC.
class CabeceraLsc extends StatelessWidget {
  const CabeceraLsc({super.key, this.sesion});

  final SesionUsuario? sesion;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColoresApp.blanco,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: Row(
        children: [
          const Text('🤟', style: TextStyle(fontSize: 26)),
          const SizedBox(width: 8),
          const Text(
            'LSC App',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: ColoresApp.azul,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: ColoresApp.azulSuave,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Fase 1',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: ColoresApp.azul,
              ),
            ),
          ),
          const Spacer(),
          if (sesion != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: ColoresApp.azulSuave,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: ColoresApp.azulClaro),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 10,
                    backgroundColor: ColoresApp.azulClaro,
                    child: Text(
                      sesion!.nombre[0],
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: ColoresApp.azul,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  if (sesion!.esAdmin)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: ColoresApp.azul,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'admin',
                        style: TextStyle(
                          fontSize: 9,
                          color: ColoresApp.blanco,
                        ),
                      ),
                    ),
                ],
              ),
            )
          else
            const Row(
              children: [
                Icon(Icons.circle, size: 8, color: ColoresApp.verde),
                SizedBox(width: 6),
                Text(
                  'Lengua de Señas Colombiana',
                  style: TextStyle(
                    fontSize: 11,
                    color: ColoresApp.textoAyuda,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

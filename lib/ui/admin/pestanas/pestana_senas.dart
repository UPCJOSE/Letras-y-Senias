import 'package:flutter/material.dart';
import 'package:movi/ui/admin/widgets/dialogo_nueva_sena.dart';
import 'package:movi/ui/aplicacion.dart';

/// Pestaña Señas del CMS (tabla + Añadir Seña del mockup).
class PestanaSenas extends StatefulWidget {
  const PestanaSenas({super.key});

  @override
  State<PestanaSenas> createState() => _EstadoPestanaSenas();
}

class _EstadoPestanaSenas extends State<PestanaSenas> {
  final List<_SenaAdmin> _senas = [
    _SenaAdmin(1, 'hola', 'Saludos', 'publicado', 1240, '2026-09-10'),
    _SenaAdmin(2, 'gracias', 'Saludos', 'publicado', 987, '2026-09-08'),
    _SenaAdmin(3, 'familia', 'Familia', 'borrador', 0, '2026-09-14'),
    _SenaAdmin(4, 'comer', 'Verbos', 'revisión', 320, '2026-09-12'),
    _SenaAdmin(5, 'amor', 'Emociones', 'publicado', 756, '2026-09-05'),
    _SenaAdmin(6, 'rojo', 'Colores', 'borrador', 0, '2026-09-15'),
  ];

  Future<void> _abrirNuevaSena() async {
    final resultado = await showDialog<ResultadoNuevaSena>(
      context: context,
      builder: (_) => const DialogoNuevaSena(),
    );
    if (resultado == null) return;
    setState(() {
      _senas.add(
        _SenaAdmin(
          _senas.length + 1,
          resultado.palabra,
          resultado.categoria,
          'borrador',
          0,
          '2026-09-15',
        ),
      );
    });
  }

  Color _colorEstado(String estado) {
    switch (estado) {
      case 'publicado':
        return ColoresApp.verde;
      case 'revisión':
        return const Color(0xFFF59E0B);
      default:
        return ColoresApp.textoAyuda;
    }
  }

  Color _fondoEstado(String estado) {
    switch (estado) {
      case 'publicado':
        return ColoresApp.verdeSuave;
      case 'revisión':
        return ColoresApp.amarilloSuave;
      default:
        return const Color(0xFFF3F4F6);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${_senas.length} señas registradas',
                  style: const TextStyle(color: ColoresApp.textoAyuda),
                ),
              ),
              ElevatedButton.icon(
                onPressed: _abrirNuevaSena,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('+ Añadir Seña'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: _senas.length,
              itemBuilder: (context, i) {
                final s = _senas[i];
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: ColoresApp.blanco,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: ColoresApp.borde),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 28,
                        child: Text(
                          '${s.id}',
                          style: const TextStyle(
                            color: ColoresApp.textoAyuda,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              s.palabra,
                              style: const TextStyle(fontWeight: FontWeight.w700),
                            ),
                            Text(
                              '${s.categoria} · ${s.actualizado}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: ColoresApp.textoAyuda,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _fondoEstado(s.estado),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          s.estado,
                          style: TextStyle(
                            fontSize: 11,
                            color: _colorEstado(s.estado),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        s.vistas.toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'monospace',
                          color: ColoresApp.textoAyuda,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 16, color: Colors.red),
                        onPressed: () {
                          setState(() => _senas.removeWhere((x) => x.id == s.id));
                        },
                      ),
                    ],
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

class _SenaAdmin {
  _SenaAdmin(
    this.id,
    this.palabra,
    this.categoria,
    this.estado,
    this.vistas,
    this.actualizado,
  );

  final int id;
  final String palabra;
  final String categoria;
  String estado;
  final int vistas;
  final String actualizado;
}

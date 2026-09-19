import 'package:flutter/material.dart';
import 'package:movi/ui/aplicacion.dart';
import 'package:movi/ui/traduccion/pagina_traduccion_lsc.dart';

/// Historial de traducciones.
class PaginaHistorial extends StatefulWidget {
  const PaginaHistorial({super.key});

  @override
  State<PaginaHistorial> createState() => _EstadoPaginaHistorial();
}

class _EstadoPaginaHistorial extends State<PaginaHistorial> {
  final _busqueda = TextEditingController();

  static const _grupos = [
    _Grupo('HOY', [
      _Item('Hola, ¿cómo estás?', '9:30 AM', 3),
      _Item('Necesito una cita médica', '8:15 AM', 4),
    ]),
    _Grupo('AYER', [
      _Item('Muchas gracias', '6:40 PM', 2),
    ]),
    _Grupo('14 SEP', [
      _Item('¿Dónde está el baño?', '3:20 PM', 3),
    ]),
  ];

  @override
  void dispose() {
    _busqueda.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final q = _busqueda.text.trim().toLowerCase();

    return Scaffold(
      backgroundColor: ColoresApp.fondo,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 16, 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    style: IconButton.styleFrom(
                      backgroundColor: ColoresApp.blanco,
                      side: const BorderSide(color: ColoresApp.borde),
                    ),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Historial de traducciones',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _busqueda,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Buscar en historial...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: ColoresApp.blanco,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(28),
                    borderSide: const BorderSide(color: ColoresApp.borde),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(28),
                    borderSide: const BorderSide(color: ColoresApp.borde),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(28),
                    borderSide: const BorderSide(color: ColoresApp.azul, width: 1.5),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                children: [
                  for (final g in _grupos) ...[
                    if (g.items.any((i) =>
                        q.isEmpty || i.texto.toLowerCase().contains(q))) ...[
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        child: Text(
                          g.titulo,
                          style: const TextStyle(
                            fontSize: 12,
                            letterSpacing: 1,
                            color: ColoresApp.textoAyuda,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      ...g.items
                          .where((i) =>
                              q.isEmpty ||
                              i.texto.toLowerCase().contains(q))
                          .map(
                            (i) => Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: ColoresApp.blanco,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: ColoresApp.borde),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 42,
                                    height: 42,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE8EEF8),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: ColoresApp.borde),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          i.texto,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Text(
                                          '${i.hora} · ${i.senas} señas',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: ColoresApp.azul,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Material(
                                    color: ColoresApp.azul,
                                    shape: const CircleBorder(),
                                    child: InkWell(
                                      customBorder: const CircleBorder(),
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) => PaginaTraduccionLsc(
                                              texto: i.texto,
                                              senasDetectadas: List.generate(
                                                i.senas,
                                                (n) => 'Seña ${n + 1}',
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      child: const SizedBox(
                                        width: 40,
                                        height: 40,
                                        child: Icon(
                                          Icons.play_arrow,
                                          color: ColoresApp.blanco,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                    ],
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Grupo {
  const _Grupo(this.titulo, this.items);
  final String titulo;
  final List<_Item> items;
}

class _Item {
  const _Item(this.texto, this.hora, this.senas);
  final String texto;
  final String hora;
  final int senas;
}

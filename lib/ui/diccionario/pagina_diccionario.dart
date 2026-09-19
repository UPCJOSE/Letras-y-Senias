import 'package:flutter/material.dart';
import 'package:movi/service/servicio_diccionario.dart';
import 'package:movi/ui/aplicacion.dart';
import 'package:movi/ui/traduccion/pagina_traduccion_lsc.dart';

/// Diccionario LSC (pantalla principal del mockup).
class PaginaDiccionario extends StatefulWidget {
  const PaginaDiccionario({super.key});

  @override
  State<PaginaDiccionario> createState() => _EstadoPaginaDiccionario();
}

class _EstadoPaginaDiccionario extends State<PaginaDiccionario> {
  final _servicio = ServicioDiccionario();
  final _busqueda = TextEditingController();
  String _categoria = 'Todos';

  /// Categorías del mockup + las del catálogo.
  static const _filtros = [
    'Todos',
    'Saludos',
    'Salud',
    'Educación',
    'Transporte',
    'Familia',
    'Números',
    'Colores',
    'Verbos',
    'Emociones',
  ];

  @override
  void dispose() {
    _busqueda.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lista = _servicio.filtrar(
      categoria: _categoria == 'Salud' ||
              _categoria == 'Educación' ||
              _categoria == 'Transporte'
          ? 'Todos'
          : _categoria,
      busqueda: _busqueda.text,
    ).where((s) {
      // Filtros extra del mockup sin datos aún: mostrar vacíos o todos.
      if (_categoria == 'Salud' ||
          _categoria == 'Educación' ||
          _categoria == 'Transporte') {
        return false;
      }
      return true;
    }).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      children: [
        const Text(
          'Diccionario LSC',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: ColoresApp.negro,
          ),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: _busqueda,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: 'Buscar seña...',
            prefixIcon: const Icon(Icons.search, color: ColoresApp.textoAyuda),
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
        const SizedBox(height: 14),
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _filtros.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final c = _filtros[i];
              final activo = c == _categoria;
              return ChoiceChip(
                label: Text(c),
                selected: activo,
                onSelected: (_) => setState(() => _categoria = c),
                selectedColor: ColoresApp.azul,
                labelStyle: TextStyle(
                  color: activo ? ColoresApp.blanco : ColoresApp.azul,
                  fontWeight: FontWeight.w600,
                ),
                backgroundColor: ColoresApp.blanco,
                side: const BorderSide(color: ColoresApp.azulClaro),
                showCheckmark: false,
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        if (lista.isEmpty)
          const Padding(
            padding: EdgeInsets.all(32),
            child: Text(
              'No hay señas en esta categoría todavía.',
              textAlign: TextAlign.center,
              style: TextStyle(color: ColoresApp.textoAyuda),
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: lista.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.82,
            ),
            itemBuilder: (context, i) {
              final s = lista[i];
              return InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => PaginaTraduccionLsc(
                        texto: s.palabraVisible,
                        senasDetectadas: [s.palabraVisible],
                      ),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  decoration: BoxDecoration(
                    color: ColoresApp.blanco,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: ColoresApp.borde),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8EEF8),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: ColoresApp.borde),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'Video',
                            style: TextStyle(
                              color: ColoresApp.textoAyuda,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              s.palabraVisible,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              s.categoria,
                              style: const TextStyle(
                                fontSize: 12,
                                color: ColoresApp.textoAyuda,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}

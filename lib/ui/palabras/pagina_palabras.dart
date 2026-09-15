import 'package:flutter/material.dart';
import 'package:movi/service/servicio_diccionario.dart';
import 'package:movi/ui/aplicacion.dart';
import 'package:movi/ui/comun/marcador_video_sena.dart';

/// Galería de palabras frecuentes (portada del mockup React).
class PaginaPalabras extends StatefulWidget {
  const PaginaPalabras({super.key});

  @override
  State<PaginaPalabras> createState() => _EstadoPaginaPalabras();
}

class _EstadoPaginaPalabras extends State<PaginaPalabras> {
  final _servicio = ServicioDiccionario();
  final _busqueda = TextEditingController();
  String _categoria = 'Todos';

  @override
  void dispose() {
    _busqueda.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lista = _servicio.filtrar(
      categoria: _categoria,
      busqueda: _busqueda.text,
    );

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      children: [
        const Text(
          'Palabras Frecuentes',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: ColoresApp.azul,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${_servicio.cantidad} señas disponibles en LSC',
          textAlign: TextAlign.center,
          style: const TextStyle(color: ColoresApp.textoAyuda),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _busqueda,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: 'Buscar palabra...',
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: ColoresApp.blanco,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: ColoresApp.azulClaro, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: ColoresApp.azulClaro, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: ColoresApp.azul, width: 2),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ServicioDiccionario.categorias.map((c) {
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
          }).toList(),
        ),
        const SizedBox(height: 16),
        if (lista.isEmpty)
          Padding(
            padding: const EdgeInsets.all(32),
            child: Text(
              'No se encontraron señas para "${_busqueda.text}"',
              textAlign: TextAlign.center,
              style: const TextStyle(color: ColoresApp.textoAyuda),
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
              childAspectRatio: 0.78,
            ),
            itemBuilder: (context, i) {
              final s = lista[i];
              return Container(
                decoration: BoxDecoration(
                  color: ColoresApp.blanco,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: ColoresApp.azulClaro, width: 2),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: MarcadorVideoSena(
                        palabra: s.palabraVisible,
                        emoji: s.emoji,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s.palabraVisible,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: ColoresApp.negro,
                            ),
                          ),
                          Text(
                            s.categoria,
                            style: const TextStyle(
                              fontSize: 12,
                              color: ColoresApp.azul,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }
}

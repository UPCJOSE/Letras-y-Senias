import 'package:flutter/material.dart';
import 'package:movi/ui/aplicacion.dart';

/// Base vectorial (portada del mockup React).
class PaginaVectorial extends StatefulWidget {
  const PaginaVectorial({super.key});

  @override
  State<PaginaVectorial> createState() => _EstadoPaginaVectorial();
}

class _EstadoPaginaVectorial extends State<PaginaVectorial> {
  final _busqueda = TextEditingController();
  int _dimension = 128;

  static const _todas = [
    _Fila('vec_001', 'hola', '[0.82, -0.14, 0.37, ...]', 0.97, ['saludo', 'frecuente']),
    _Fila('vec_002', 'gracias', '[0.71, 0.23, -0.45, ...]', 0.94, ['cortesía']),
    _Fila('vec_003', 'familia', '[-0.33, 0.88, 0.12, ...]', 0.91, ['sustantivo']),
    _Fila('vec_004', 'comer', '[0.55, -0.67, 0.29, ...]', 0.89, ['verbo', 'básico']),
    _Fila('vec_005', 'amor', '[0.94, 0.11, -0.22, ...]', 0.88, ['emoción']),
    _Fila('vec_006', 'agua', '[-0.12, 0.76, 0.54, ...]', 0.85, ['sustantivo', 'básico']),
  ];

  late List<_Fila> _resultados = List.from(_todas);

  @override
  void dispose() {
    _busqueda.dispose();
    super.dispose();
  }

  void _buscar() {
    final q = _busqueda.text.trim().toLowerCase();
    setState(() {
      if (q.isEmpty) {
        _resultados = List.from(_todas);
      } else {
        _resultados = _todas
            .where(
              (e) =>
                  e.palabra.contains(q) ||
                  e.tags.any((t) => t.contains(q)),
            )
            .toList()
          ..sort((a, b) => b.similitud.compareTo(a.similitud));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final consulta = _busqueda.text.trim().isEmpty ? 'hola' : _busqueda.text.trim();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Base de Datos Vectorial',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: ColoresApp.azul,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Embeddings semánticos para búsqueda por similitud',
                    style: TextStyle(fontSize: 13, color: ColoresApp.textoAyuda),
                  ),
                ],
              ),
            ),
            PopupMenuButton<int>(
              initialValue: _dimension,
              onSelected: (v) => setState(() => _dimension = v),
              itemBuilder: (_) => [64, 128, 256, 512]
                  .map((d) => PopupMenuItem(value: d, child: Text('$d')))
                  .toList(),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: ColoresApp.azulSuave,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: ColoresApp.azulClaro),
                ),
                child: Row(
                  children: [
                    const Text('dim ', style: TextStyle(color: ColoresApp.azul, fontSize: 12)),
                    Text(
                      '$_dimension',
                      style: const TextStyle(
                        color: ColoresApp.azul,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down, color: ColoresApp.azul),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _Stat('20', 'Vectores', ColoresApp.azulSuave, ColoresApp.azulClaro),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _Stat('${_dimension}d', 'Dimensión', ColoresApp.tealSuave, ColoresApp.teal),
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: _Stat('HNSW', 'Índice', ColoresApp.amarilloSuave, Color(0xFFFFE082)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _busqueda,
                onSubmitted: (_) => _buscar(),
                decoration: InputDecoration(
                  hintText: 'Búsqueda semántica... ej: saludo',
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
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: _buscar,
              style: ElevatedButton.styleFrom(backgroundColor: ColoresApp.teal),
              child: const Text('Buscar'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: ColoresApp.blanco,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: ColoresApp.borde),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: const BoxDecoration(
                  color: Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: const Row(
                  children: [
                    SizedBox(width: 70, child: Text('ID', style: _cab)),
                    Expanded(child: Text('Palabra', style: _cab)),
                    SizedBox(width: 90, child: Text('Similitud', style: _cab, textAlign: TextAlign.right)),
                  ],
                ),
              ),
              ..._resultados.map((f) => _FilaResultado(fila: f)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF111827),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            '# Ejemplo de consulta\n'
            'import vectordb from "@lsc/vector"\n'
            'const results = await vectordb.query({\n'
            '  vector: embed("$consulta"),\n'
            '  topK: 5, dim: $_dimension\n'
            '});',
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 11,
              height: 1.45,
              color: Color(0xFF4ADE80),
            ),
          ),
        ),
      ],
    );
  }
}

const _cab = TextStyle(
  fontSize: 11,
  color: ColoresApp.textoAyuda,
  fontWeight: FontWeight.w600,
);

class _Stat extends StatelessWidget {
  const _Stat(this.valor, this.etiqueta, this.fondo, this.borde);

  final String valor;
  final String etiqueta;
  final Color fondo;
  final Color borde;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: fondo,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borde.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          Text(
            valor,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: ColoresApp.negro,
            ),
          ),
          Text(
            etiqueta,
            style: const TextStyle(fontSize: 11, color: ColoresApp.textoAyuda),
          ),
        ],
      ),
    );
  }
}

class _Fila {
  const _Fila(this.id, this.palabra, this.vector, this.similitud, this.tags);
  final String id;
  final String palabra;
  final String vector;
  final double similitud;
  final List<String> tags;
}

class _FilaResultado extends StatelessWidget {
  const _FilaResultado({required this.fila});
  final _Fila fila;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: ColoresApp.borde)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 70,
                child: Text(
                  fila.id,
                  style: const TextStyle(
                    fontSize: 11,
                    fontFamily: 'monospace',
                    color: ColoresApp.textoAyuda,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fila.palabra,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      fila.vector,
                      style: const TextStyle(
                        fontSize: 10,
                        fontFamily: 'monospace',
                        color: ColoresApp.textoAyuda,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 90,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: fila.similitud,
                          minHeight: 6,
                          backgroundColor: ColoresApp.borde,
                          color: ColoresApp.teal,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      fila.similitud.toStringAsFixed(2),
                      style: const TextStyle(
                        fontSize: 11,
                        color: ColoresApp.teal,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 4,
            children: fila.tags
                .map(
                  (t) => Chip(
                    label: Text(t),
                    labelStyle: const TextStyle(fontSize: 10, color: ColoresApp.azul),
                    backgroundColor: ColoresApp.azulSuave,
                    side: BorderSide.none,
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: EdgeInsets.zero,
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

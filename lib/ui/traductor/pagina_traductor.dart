import 'package:flutter/material.dart';
import 'package:movi/model/entrada_sena.dart';
import 'package:movi/service/servicio_diccionario.dart';
import 'package:movi/ui/aplicacion.dart';
import 'package:movi/ui/comun/marcador_video_sena.dart';

/// Traductor Texto → Señas (portado del mockup React).
class PaginaTraductor extends StatefulWidget {
  const PaginaTraductor({super.key});

  @override
  State<PaginaTraductor> createState() => _EstadoPaginaTraductor();
}

class _EstadoPaginaTraductor extends State<PaginaTraductor> {
  final _servicio = ServicioDiccionario();
  final _controlador = TextEditingController();
  final _nodoFoco = FocusNode();

  EntradaSena? _sena;
  String? _textoBuscado;
  bool _buscado = false;
  final List<String> _historial = ['hola', 'gracias', 'familia'];

  @override
  void dispose() {
    _controlador.dispose();
    _nodoFoco.dispose();
    super.dispose();
  }

  void _traducir([String? forzado]) {
    if (forzado != null) _controlador.text = forzado;
    final texto = _controlador.text.trim();
    _nodoFoco.unfocus();

    final encontrada = _servicio.buscarPorPalabra(texto);
    setState(() {
      _textoBuscado = texto;
      _sena = encontrada;
      _buscado = texto.isNotEmpty;
      if (encontrada != null && !_historial.contains(encontrada.clave)) {
        _historial.insert(0, encontrada.clave);
        if (_historial.length > 8) _historial.removeLast();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
      children: [
        const Center(child: Text('🤟', style: TextStyle(fontSize: 40))),
        const SizedBox(height: 8),
        const Text(
          'Traductor Texto → Señas',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: ColoresApp.azul,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Escribe una palabra en español y ve su seña en LSC',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: ColoresApp.textoAyuda),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controlador,
                focusNode: _nodoFoco,
                textInputAction: TextInputAction.search,
                onSubmitted: (_) => _traducir(),
                decoration: _campo('Escribe una palabra... ej: hola'),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: _traducir,
              child: const Text('Traducir'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ['hola', 'gracias', 'familia', 'agua', 'amor', 'ayuda']
              .map(
                (w) => ActionChip(
                  label: Text(w),
                  labelStyle: const TextStyle(color: ColoresApp.azul),
                  backgroundColor: ColoresApp.azulSuave,
                  side: const BorderSide(color: ColoresApp.azulClaro),
                  onPressed: () {
                    _controlador.text = w;
                    setState(() {});
                  },
                ),
              )
              .toList(),
        ),
        if (_buscado && _textoBuscado != null) ...[
          const SizedBox(height: 20),
          _ResultadoTraduccion(
            texto: _textoBuscado!,
            sena: _sena,
          ),
        ],
        if (_historial.isNotEmpty) ...[
          const SizedBox(height: 24),
          const Text(
            'BÚSQUEDAS RECIENTES',
            style: TextStyle(
              fontSize: 11,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w600,
              color: ColoresApp.textoAyuda,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _historial.map((clave) {
              final s = _servicio.buscarPorPalabra(clave);
              return InkWell(
                onTap: () {
                  _controlador.text = clave.replaceAll('_', ' ');
                  setState(() {});
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: ColoresApp.borde),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(s?.emoji ?? '❔', style: const TextStyle(fontSize: 16)),
                      const SizedBox(width: 8),
                      Text(
                        clave.replaceAll('_', ' '),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: ColoresApp.negroSuave,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  InputDecoration _campo(String pista) {
    return InputDecoration(
      hintText: pista,
      hintStyle: const TextStyle(color: ColoresApp.textoAyuda),
      filled: true,
      fillColor: ColoresApp.blanco,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
    );
  }
}

class _ResultadoTraduccion extends StatelessWidget {
  const _ResultadoTraduccion({required this.texto, required this.sena});

  final String texto;
  final EntradaSena? sena;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColoresApp.blanco,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColoresApp.azulClaro, width: 2),
        boxShadow: [
          BoxShadow(
            color: ColoresApp.azul.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: sena != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            sena!.categoria.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 11,
                              letterSpacing: 1.5,
                              color: ColoresApp.azul,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            texto,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: ColoresApp.negro,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: ColoresApp.verdeSuave,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        '✓ En catálogo',
                        style: TextStyle(
                          fontSize: 11,
                          color: ColoresApp.verde,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                MarcadorVideoSena(
                  palabra: sena!.palabraVisible,
                  emoji: sena!.emoji,
                  grande: true,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        child: const Text('↻ Repetir'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        child: const Text('★ Guardar'),
                      ),
                    ),
                  ],
                ),
              ],
            )
          : Column(
              children: [
                const Text('🔍', style: TextStyle(fontSize: 40)),
                const SizedBox(height: 8),
                Text(
                  '"$texto" no está en el catálogo aún',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: ColoresApp.negroSuave,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Prueba con deletreo manual o sugiere añadirla',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: ColoresApp.textoAyuda),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 4,
                  children: 'abcdefgh'
                      .split('')
                      .map(
                        (l) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            l.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 11,
                              color: ColoresApp.textoAyuda,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    backgroundColor: ColoresApp.azulSuave,
                    foregroundColor: ColoresApp.azul,
                  ),
                  child: const Text('+ Sugerir esta seña'),
                ),
              ],
            ),
    );
  }
}

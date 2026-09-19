import 'package:flutter/material.dart';
import 'package:movi/service/servicio_diccionario.dart';
import 'package:movi/ui/aplicacion.dart';
import 'package:movi/ui/sugerencias/pagina_palabra_no_encontrada.dart';
import 'package:movi/ui/traduccion/pagina_traduccion_lsc.dart';

/// Inicio / Traducir al instante (mockup SeñasApp).
class PaginaInicio extends StatefulWidget {
  const PaginaInicio({super.key});

  @override
  State<PaginaInicio> createState() => _EstadoPaginaInicio();
}

class _EstadoPaginaInicio extends State<PaginaInicio> {
  final _controlador = TextEditingController();
  final _servicio = ServicioDiccionario();
  final List<_ItemHistorial> _historial = [
    const _ItemHistorial('Hola, necesito ayuda', 'hace 2 min'),
    const _ItemHistorial('¿Dónde está el baño?', 'hace 1 hora'),
    const _ItemHistorial('Gracias por su ayuda', 'ayer'),
  ];

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  void _abrirAccesoRapido({
    required String texto,
    required List<String> senas,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PaginaTraduccionLsc(
          texto: texto,
          senasDetectadas: senas,
        ),
      ),
    );
  }

  void _traducir() {
    final texto = _controlador.text.trim();
    if (texto.isEmpty) return;

    final sena = _servicio.buscarPorPalabra(texto);

    setState(() {
      _historial.insert(0, _ItemHistorial(texto, 'ahora'));
    });

    if (sena == null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => PaginaPalabraNoEncontrada(textoEscrito: texto),
        ),
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PaginaTraduccionLsc(
          texto: texto,
          senasDetectadas: [sena.palabraVisible],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      children: [
        Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: ColoresApp.azulSuave,
                borderRadius: BorderRadius.circular(21),
              ),
              alignment: Alignment.center,
              child: const Text('🧢', style: TextStyle(fontSize: 22)),
            ),
            const SizedBox(width: 10),
            const Text(
              'SeñasApp',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: ColoresApp.azul,
              ),
            ),
            const Spacer(),
            _BotonIcono(Icons.history, () {}),
            const SizedBox(width: 8),
            _BotonIcono(Icons.notifications_none, () {}),
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          'TRADUCIR AL INSTANTE',
          style: TextStyle(
            fontSize: 12,
            letterSpacing: 1,
            fontWeight: FontWeight.w600,
            color: ColoresApp.textoAyuda,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: ColoresApp.blanco,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _controlador,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Escribe una palabra o frase...',
                  hintStyle: const TextStyle(color: ColoresApp.textoAyuda),
                  filled: true,
                  fillColor: ColoresApp.fondo,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: ColoresApp.borde),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: ColoresApp.borde),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: ColoresApp.azul, width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Ejemplo: Hola, necesito ayuda',
                style: TextStyle(fontSize: 12, color: ColoresApp.textoAyuda),
              ),
              const SizedBox(height: 14),
              ElevatedButton.icon(
                onPressed: _traducir,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Traducir a LSC'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'ACCESOS RÁPIDOS',
          style: TextStyle(
            fontSize: 12,
            letterSpacing: 1,
            fontWeight: FontWeight.w600,
            color: ColoresApp.textoAyuda,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _AccesoRapido(
                emoji: '🏥',
                etiqueta: 'Hospital',
                colorTexto: const Color(0xFFE53935),
                colorFondo: const Color(0xFFFFEBEE),
                alPulsar: () => _abrirAccesoRapido(
                  texto: 'Hospital',
                  senas: const ['Hola', 'Ayuda', 'Dolor'],
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _AccesoRapido(
                emoji: '🏦',
                etiqueta: 'Banco',
                colorTexto: const Color(0xFFF9A825),
                colorFondo: const Color(0xFFFFF8E1),
                alPulsar: () => _abrirAccesoRapido(
                  texto: 'Banco',
                  senas: const ['Dinero', 'Cuenta', 'Ayuda'],
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _AccesoRapido(
                emoji: '🎓',
                etiqueta: 'Colegio',
                colorTexto: const Color(0xFF43A047),
                colorFondo: const Color(0xFFE8F5E9),
                alPulsar: () => _abrirAccesoRapido(
                  texto: 'Colegio',
                  senas: const ['Estudiar', 'Maestro', 'Ayuda'],
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _AccesoRapido(
                emoji: '🚨',
                etiqueta: 'Emergencia',
                colorTexto: const Color(0xFFEF6C00),
                colorFondo: const Color(0xFFFFF3E0),
                alPulsar: () => _abrirAccesoRapido(
                  texto: 'Emergencia',
                  senas: const ['Hola', 'Necesitar', 'Ayuda'],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Text(
          'HISTORIAL RECIENTE',
          style: TextStyle(
            fontSize: 12,
            letterSpacing: 1,
            fontWeight: FontWeight.w600,
            color: ColoresApp.textoAyuda,
          ),
        ),
        const SizedBox(height: 12),
        ..._historial.map(
          (h) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: ColoresApp.blanco,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: ColoresApp.azulSuave,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: const Text('🧢', style: TextStyle(fontSize: 20)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        h.texto,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: ColoresApp.negro,
                        ),
                      ),
                      Text(
                        h.tiempo,
                        style: const TextStyle(
                          fontSize: 12,
                          color: ColoresApp.textoAyuda,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: ColoresApp.negro),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _BotonIcono extends StatelessWidget {
  const _BotonIcono(this.icono, this.alPulsar);

  final IconData icono;
  final VoidCallback alPulsar;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: alPulsar,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: ColoresApp.borde),
          color: ColoresApp.blanco,
        ),
        child: Icon(icono, size: 20, color: ColoresApp.negroSuave),
      ),
    );
  }
}

class _AccesoRapido extends StatelessWidget {
  const _AccesoRapido({
    required this.emoji,
    required this.etiqueta,
    required this.colorTexto,
    required this.colorFondo,
    required this.alPulsar,
  });

  final String emoji;
  final String etiqueta;
  final Color colorTexto;
  final Color colorFondo;
  final VoidCallback alPulsar;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: alPulsar,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        children: [
          Container(
            height: 56,
            decoration: BoxDecoration(
              color: colorFondo,
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: Text(emoji, style: const TextStyle(fontSize: 24)),
          ),
          const SizedBox(height: 6),
          Text(
            etiqueta,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: colorTexto,
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemHistorial {
  const _ItemHistorial(this.texto, this.tiempo);
  final String texto;
  final String tiempo;
}

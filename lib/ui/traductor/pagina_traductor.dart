import 'package:flutter/material.dart';
import 'package:movi/ui/aplicacion.dart';
import 'package:movi/ui/traductor/widgets/panel_video_senas.dart';
import 'package:movi/ui/traductor/widgets/panel_entrada_texto.dart';

/// Pantalla principal del traductor: señas arriba, texto y acciones abajo.
///
/// Flujo pensado para móvil:
/// 1) El usuario toca el campo → se abre el teclado.
/// 2) Escribe el texto.
/// 3) Pulsa Traducir → las señas se muestran en el panel superior
///    (no es automático al escribir; así controlamos cuándo buscar).
class PaginaTraductor extends StatefulWidget {
  const PaginaTraductor({super.key});

  @override
  State<PaginaTraductor> createState() => _EstadoPaginaTraductor();
}

class _EstadoPaginaTraductor extends State<PaginaTraductor> {
  final TextEditingController _controladorTexto = TextEditingController();
  final FocusNode _nodoFocoTexto = FocusNode();

  /// Por ahora solo UI: más adelante aquí irá el video de la seña.
  String? _etiquetaSena;

  @override
  void dispose() {
    _controladorTexto.dispose();
    _nodoFocoTexto.dispose();
    super.dispose();
  }

  void _cerrarTeclado() {
    _nodoFocoTexto.unfocus();
  }

  void _alPulsarTraducir() {
    _cerrarTeclado();
    final texto = _controladorTexto.text.trim();

    setState(() {
      _etiquetaSena = texto.isEmpty ? null : texto;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          texto.isEmpty
              ? 'Escribe un texto y pulsa Traducir'
              : 'Se mostrará la seña de: "$texto"',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _alPulsarGrabar() {
    _cerrarTeclado();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Grabar: aquí irá la voz → texto'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColoresApp.fondo,
      // Al abrir el teclado, la pantalla se ajusta y no tapa el campo.
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Expanded(
                flex: 5,
                child: PanelVideoSenas(
                  etiquetaDuracion: '0:00/3:53',
                  etiquetaSena: _etiquetaSena,
                ),
              ),
              const _SeparadorPaneles(),
              Expanded(
                flex: 4,
                child: PanelEntradaTexto(
                  controlador: _controladorTexto,
                  nodoFoco: _nodoFocoTexto,
                  alTraducir: _alPulsarTraducir,
                  alGrabar: _alPulsarGrabar,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Separador visual entre el panel de señas y el de texto (mockup).
class _SeparadorPaneles extends StatelessWidget {
  const _SeparadorPaneles();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const Expanded(
            child: Divider(thickness: 1, color: ColoresApp.negro),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: List.generate(
                3,
                (_) => Container(
                  width: 5,
                  height: 5,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: const BoxDecoration(
                    color: ColoresApp.negro,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
          const Expanded(
            child: Divider(thickness: 1, color: ColoresApp.negro),
          ),
        ],
      ),
    );
  }
}

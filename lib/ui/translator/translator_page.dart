import 'package:flutter/material.dart';
import 'package:movi/ui/app.dart';
import 'package:movi/ui/translator/widgets/sign_video_panel.dart';
import 'package:movi/ui/translator/widgets/text_input_panel.dart';

/// Pantalla principal del traductor: señas arriba, texto y acciones abajo.
///
/// Flujo pensado para móvil:
/// 1) El usuario toca el campo → se abre el teclado.
/// 2) Escribe el texto.
/// 3) Pulsa Traducir → las señas se muestran en el panel superior
///    (no es automático al escribir; así controlamos cuándo buscar).
class TranslatorPage extends StatefulWidget {
  const TranslatorPage({super.key});

  @override
  State<TranslatorPage> createState() => _TranslatorPageState();
}

class _TranslatorPageState extends State<TranslatorPage> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFocusNode = FocusNode();

  /// Por ahora solo UI: más adelante aquí irá el video de la seña.
  String? _signLabel;

  @override
  void dispose() {
    _textController.dispose();
    _textFocusNode.dispose();
    super.dispose();
  }

  void _cerrarTeclado() {
    _textFocusNode.unfocus();
  }

  void _onTraducir() {
    _cerrarTeclado();
    final texto = _textController.text.trim();

    setState(() {
      _signLabel = texto.isEmpty ? null : texto;
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

  void _onGrabar() {
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
      backgroundColor: AppColors.background,
      // Al abrir el teclado, la pantalla se ajusta y no tapa el campo.
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Expanded(
                flex: 5,
                child: SignVideoPanel(
                  durationLabel: '0:00/3:53',
                  signLabel: _signLabel,
                ),
              ),
              const _PanelDivider(),
              Expanded(
                flex: 4,
                child: TextInputPanel(
                  controller: _textController,
                  focusNode: _textFocusNode,
                  onTraducir: _onTraducir,
                  onGrabar: _onGrabar,
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
class _PanelDivider extends StatelessWidget {
  const _PanelDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const Expanded(
            child: Divider(thickness: 1, color: AppColors.black),
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
                    color: AppColors.black,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
          const Expanded(
            child: Divider(thickness: 1, color: AppColors.black),
          ),
        ],
      ),
    );
  }
}

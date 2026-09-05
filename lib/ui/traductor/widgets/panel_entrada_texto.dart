import 'package:flutter/material.dart';
import 'package:movi/ui/aplicacion.dart';

/// Panel inferior: campo de texto + botones Traducir y Grabar.
/// Al tocar el campo se abre el teclado del móvil.
class PanelEntradaTexto extends StatelessWidget {
  const PanelEntradaTexto({
    super.key,
    required this.controlador,
    required this.nodoFoco,
    required this.alTraducir,
    required this.alGrabar,
  });

  final TextEditingController controlador;
  final FocusNode nodoFoco;
  final VoidCallback alTraducir;
  final VoidCallback alGrabar;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColoresApp.blanco,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColoresApp.borde, width: 1.5),
      ),
      child: Column(
        children: [
          Expanded(
            // Tocar cualquier parte del área del texto enfoca el campo.
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => nodoFoco.requestFocus(),
              child: TextField(
                controller: controlador,
                focusNode: nodoFoco,
                enabled: true,
                readOnly: false,
                autofocus: false,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                textCapitalization: TextCapitalization.sentences,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                cursorColor: ColoresApp.azul,
                style: const TextStyle(
                  fontSize: 16,
                  color: ColoresApp.negroSuave,
                ),
                decoration: InputDecoration(
                  hintText: 'Toca aquí para escribir...',
                  hintStyle: const TextStyle(color: ColoresApp.textoAyuda),
                  contentPadding: const EdgeInsets.all(12),
                  filled: true,
                  fillColor: ColoresApp.blanco,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: ColoresApp.negro),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: ColoresApp.negro),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: ColoresApp.azul,
                      width: 1.5,
                    ),
                  ),
                ),
                onTap: () => nodoFoco.requestFocus(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: alTraducir,
                  child: const Text('Traducir'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: alGrabar,
                  child: const Text('Grabar'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

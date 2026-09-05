import 'package:flutter/material.dart';
import 'package:movi/ui/app.dart';

/// Panel inferior: campo de texto + botones Traducir y Grabar.
/// Al tocar el campo se abre el teclado del móvil.
class TextInputPanel extends StatelessWidget {
  const TextInputPanel({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onTraducir,
    required this.onGrabar,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onTraducir;
  final VoidCallback onGrabar;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 1.5),
      ),
      child: Column(
        children: [
          Expanded(
            // Tocar cualquier parte del área del texto enfoca el campo.
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => focusNode.requestFocus(),
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                enabled: true,
                readOnly: false,
                autofocus: false,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                textCapitalization: TextCapitalization.sentences,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                cursorColor: AppColors.blue,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.blackSoft,
                ),
                decoration: InputDecoration(
                  hintText: 'Toca aquí para escribir...',
                  hintStyle: const TextStyle(color: AppColors.hint),
                  contentPadding: const EdgeInsets.all(12),
                  filled: true,
                  fillColor: AppColors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.black),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: AppColors.blue,
                      width: 1.5,
                    ),
                  ),
                ),
                onTap: () => focusNode.requestFocus(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onTraducir,
                  child: const Text('Traducir'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: onGrabar,
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

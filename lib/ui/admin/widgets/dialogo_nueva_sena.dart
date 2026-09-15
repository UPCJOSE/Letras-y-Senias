import 'package:flutter/material.dart';
import 'package:movi/ui/aplicacion.dart';

/// Diálogo "Nueva Seña" (referencia de UX para el de alias).
class DialogoNuevaSena extends StatefulWidget {
  const DialogoNuevaSena({super.key});

  @override
  State<DialogoNuevaSena> createState() => _EstadoDialogoNuevaSena();
}

class _EstadoDialogoNuevaSena extends State<DialogoNuevaSena> {
  final _controladorPalabra = TextEditingController();
  String _categoria = 'Saludos';

  static const _categorias = [
    'Saludos',
    'Familia',
    'Números',
    'Colores',
    'Verbos',
    'Emociones',
  ];

  @override
  void dispose() {
    _controladorPalabra.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Nueva Seña',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: ColoresApp.negro,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Palabra en español',
                style: TextStyle(fontSize: 13, color: ColoresApp.textoAyuda),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _controladorPalabra,
                decoration: _decoracionCampo('ej: buenas noches'),
              ),
              const SizedBox(height: 14),
              const Text(
                'Categoría',
                style: TextStyle(fontSize: 13, color: ColoresApp.textoAyuda),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: _categoria,
                decoration: _decoracionCampo(null),
                items: _categorias
                    .map(
                      (c) => DropdownMenuItem(value: c, child: Text(c)),
                    )
                    .toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _categoria = v);
                },
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: ColoresApp.azul.withValues(alpha: 0.45),
                    style: BorderStyle.solid,
                    width: 1.5,
                  ),
                  color: const Color(0xFFEEF5FF),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.folder_open, color: ColoresApp.azul, size: 32),
                    SizedBox(height: 8),
                    Text(
                      'Subir video de la seña (.mp4 · máx 10 MB)',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: ColoresApp.azul,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: ColoresApp.negroSuave,
                        side: const BorderSide(color: Color(0xFFBDBDBD)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Seña guardada como borrador (demo UI)',
                            ),
                          ),
                        );
                      },
                      child: const Text('Guardar borrador'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _decoracionCampo(String? pista) {
    return InputDecoration(
      hintText: pista,
      hintStyle: const TextStyle(color: ColoresApp.textoAyuda),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFBDBDBD)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFBDBDBD)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: ColoresApp.azul, width: 1.5),
      ),
    );
  }
}

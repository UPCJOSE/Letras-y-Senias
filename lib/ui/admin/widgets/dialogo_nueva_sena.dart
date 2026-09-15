import 'package:flutter/material.dart';
import 'package:movi/service/servicio_diccionario.dart';
import 'package:movi/ui/aplicacion.dart';

class ResultadoNuevaSena {
  final String palabra;
  final String categoria;

  const ResultadoNuevaSena({
    required this.palabra,
    required this.categoria,
  });
}

/// Diálogo "Nueva Seña" (como el modal del mockup React).
class DialogoNuevaSena extends StatefulWidget {
  const DialogoNuevaSena({super.key});

  @override
  State<DialogoNuevaSena> createState() => _EstadoDialogoNuevaSena();
}

class _EstadoDialogoNuevaSena extends State<DialogoNuevaSena> {
  final _controladorPalabra = TextEditingController();
  String _categoria = 'Saludos';

  @override
  void dispose() {
    _controladorPalabra.dispose();
    super.dispose();
  }

  void _guardar() {
    final palabra = _controladorPalabra.text.trim();
    if (palabra.isEmpty) return;
    Navigator.of(context).pop(
      ResultadoNuevaSena(palabra: palabra, categoria: _categoria),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categorias = ServicioDiccionario.categorias.skip(1).toList();

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
                  fontWeight: FontWeight.w800,
                  color: ColoresApp.negro,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Palabra en español',
                style: TextStyle(fontSize: 12, color: ColoresApp.textoAyuda),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _controladorPalabra,
                autofocus: true,
                decoration: _campo('ej: buenas noches'),
              ),
              const SizedBox(height: 14),
              const Text(
                'Categoría',
                style: TextStyle(fontSize: 12, color: ColoresApp.textoAyuda),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: _categoria,
                decoration: _campo(null),
                items: categorias
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _categoria = v);
                },
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: ColoresApp.azulClaro,
                    width: 2,
                  ),
                  color: ColoresApp.azulSuave,
                ),
                child: const Column(
                  children: [
                    Text('📁', style: TextStyle(fontSize: 28)),
                    SizedBox(height: 8),
                    Text(
                      'Subir video de la seña (.mp4 · máx 10 MB)',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: ColoresApp.azul),
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
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _guardar,
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

  InputDecoration _campo(String? pista) {
    return InputDecoration(
      hintText: pista,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: ColoresApp.borde, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: ColoresApp.borde, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: ColoresApp.azul, width: 2),
      ),
    );
  }
}

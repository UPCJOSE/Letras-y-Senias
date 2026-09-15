import 'package:flutter/material.dart';
import 'package:movi/model/concepto_palabra.dart';
import 'package:movi/ui/aplicacion.dart';

/// Resultado del diálogo de alias (para la pestaña Palabras).
class ResultadoAlias {
  final String idConcepto;
  final String alias;

  const ResultadoAlias({
    required this.idConcepto,
    required this.alias,
  });
}

/// Diálogo "Añadir alias", intuitivo como "Nueva Seña".
class DialogoAnadirAlias extends StatefulWidget {
  const DialogoAnadirAlias({
    super.key,
    required this.conceptos,
    this.conceptoInicial,
  });

  final List<ConceptoPalabra> conceptos;
  final ConceptoPalabra? conceptoInicial;

  @override
  State<DialogoAnadirAlias> createState() => _EstadoDialogoAnadirAlias();
}

class _EstadoDialogoAnadirAlias extends State<DialogoAnadirAlias> {
  final _controladorAlias = TextEditingController();
  late String _idConcepto;
  String? _error;

  @override
  void initState() {
    super.initState();
    _idConcepto =
        widget.conceptoInicial?.id ?? widget.conceptos.first.id;
  }

  @override
  void dispose() {
    _controladorAlias.dispose();
    super.dispose();
  }

  void _guardar() {
    final alias = _controladorAlias.text.trim();
    if (alias.isEmpty) {
      setState(() => _error = 'Escribe un alias');
      return;
    }
    Navigator.of(context).pop(
      ResultadoAlias(idConcepto: _idConcepto, alias: alias),
    );
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
                'Añadir alias',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: ColoresApp.negro,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Asocia otra forma de escribir la misma seña '
                '(ej: "buenos días" → Hola).',
                style: TextStyle(
                  fontSize: 13,
                  color: ColoresApp.textoAyuda,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Texto del alias',
                style: TextStyle(fontSize: 13, color: ColoresApp.textoAyuda),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _controladorAlias,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                decoration: _decoracionCampo('ej: buenas tardes'),
                onChanged: (_) {
                  if (_error != null) setState(() => _error = null);
                },
              ),
              if (_error != null) ...[
                const SizedBox(height: 6),
                Text(
                  _error!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ],
              const SizedBox(height: 14),
              const Text(
                'Concepto / seña asociada',
                style: TextStyle(fontSize: 13, color: ColoresApp.textoAyuda),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: _idConcepto,
                decoration: _decoracionCampo(null),
                items: widget.conceptos
                    .map(
                      (c) => DropdownMenuItem(
                        value: c.id,
                        child: Text('${c.emoji}  ${c.titulo}'),
                      ),
                    )
                    .toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _idConcepto = v);
                },
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: ColoresApp.azul.withValues(alpha: 0.35),
                  ),
                  color: const Color(0xFFEEF5FF),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.link, color: ColoresApp.azul),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'El alias no crea una seña nueva: apunta '
                        'al video ya registrado del concepto.',
                        style: TextStyle(
                          fontSize: 13,
                          color: ColoresApp.azul,
                        ),
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
                      onPressed: _guardar,
                      child: const Text('Guardar alias'),
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

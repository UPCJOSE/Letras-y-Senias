import 'package:movi/model/concepto_palabra.dart';

/// Servicio de palabras y alias (datos en memoria para la UI de Fase 1).
class ServicioPalabras {
  final List<ConceptoPalabra> _conceptos = [
    ConceptoPalabra(
      id: '1',
      titulo: 'Hola',
      claveSena: 'hola',
      emoji: '👏',
      aliases: ['hola', 'buenos días', 'buenas'],
    ),
    ConceptoPalabra(
      id: '2',
      titulo: 'Gracias',
      claveSena: 'gracias',
      emoji: '🙏',
      aliases: ['gracias', 'muchas gracias', 'agradezco'],
    ),
    ConceptoPalabra(
      id: '3',
      titulo: 'Familia',
      claveSena: 'familia',
      emoji: '👨‍👩‍👧‍👦',
      aliases: ['familia', 'parientes', 'hogar'],
    ),
  ];

  List<ConceptoPalabra> obtenerConceptos() {
    return List.unmodifiable(_conceptos);
  }

  /// Añade un alias a un concepto. Devuelve false si ya existía.
  bool anadirAlias({
    required String idConcepto,
    required String alias,
  }) {
    final texto = alias.trim().toLowerCase();
    if (texto.isEmpty) return false;

    final indice = _conceptos.indexWhere((c) => c.id == idConcepto);
    if (indice < 0) return false;

    final concepto = _conceptos[indice];
    if (concepto.aliases.any((a) => a.toLowerCase() == texto)) {
      return false;
    }

    final nuevos = [...concepto.aliases, texto];
    _conceptos[indice] = concepto.copiarCon(aliases: nuevos);
    return true;
  }
}

/// Concepto en español enlazado a una seña, con posibles alias (sinónimos).
class ConceptoPalabra {
  final String id;
  final String titulo;
  final String claveSena;
  final String emoji;
  final List<String> aliases;

  ConceptoPalabra({
    required this.id,
    required this.titulo,
    required this.claveSena,
    required this.emoji,
    List<String>? aliases,
  }) : aliases = aliases ?? [];

  ConceptoPalabra copiarCon({
    String? id,
    String? titulo,
    String? claveSena,
    String? emoji,
    List<String>? aliases,
  }) {
    return ConceptoPalabra(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      claveSena: claveSena ?? this.claveSena,
      emoji: emoji ?? this.emoji,
      aliases: aliases ?? List<String>.from(this.aliases),
    );
  }
}

/// Entrada del catálogo LSC (equivalente a SIGNS del mockup React).
class EntradaSena {
  final String clave;
  final String emoji;
  final String categoria;
  final String rutaVideo;

  const EntradaSena({
    required this.clave,
    required this.emoji,
    required this.categoria,
    required this.rutaVideo,
  });

  String get palabraVisible => clave.replaceAll('_', ' ');
}

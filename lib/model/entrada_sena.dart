/// Representa una entrada del diccionario de señas (LSC).
/// Por ahora solo el modelo; la búsqueda y los videos vienen después.
class EntradaSena {
  final String palabra;
  final String rutaVideo;
  final String? categoria;

  EntradaSena({
    required this.palabra,
    required this.rutaVideo,
    this.categoria,
  });

  factory EntradaSena.desdeJson(Map<String, dynamic> json) {
    return EntradaSena(
      palabra: json['palabra'] as String,
      rutaVideo: json['rutaVideo'] as String,
      categoria: json['categoria'] as String?,
    );
  }

  Map<String, dynamic> aJson() {
    return {
      'palabra': palabra,
      'rutaVideo': rutaVideo,
      'categoria': categoria,
    };
  }
}

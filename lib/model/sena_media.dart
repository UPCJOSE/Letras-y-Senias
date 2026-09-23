/// Origen del archivo. `remoto` queda listo para URLs de Supabase Storage.
enum OrigenMedia { asset, remoto }

enum TipoMedia { imagen, video }

/// Seña del catálogo, independiente de dónde se guarde (assets o Supabase).
class SenaMedia {
  const SenaMedia({
    required this.clave,
    required this.palabraVisible,
    required this.tipo,
    required this.origen,
    required this.ruta,
    this.alias = const [],
  });

  final String clave;
  final String palabraVisible;
  final TipoMedia tipo;
  final OrigenMedia origen;

  /// Ruta de asset (`Palabras/...`) o URL cuando [origen] sea [OrigenMedia.remoto].
  final String ruta;
  final List<String> alias;
}

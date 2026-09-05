/// Representa una entrada del diccionario de señas (LSC).
/// Por ahora solo el modelo; la búsqueda y los videos vienen después.
class SignEntry {
  final String word;
  final String videoPath;
  final String? category;

  SignEntry({
    required this.word,
    required this.videoPath,
    this.category,
  });

  factory SignEntry.fromJson(Map<String, dynamic> json) {
    return SignEntry(
      word: json['word'] as String,
      videoPath: json['videoPath'] as String,
      category: json['category'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'word': word,
      'videoPath': videoPath,
      'category': category,
    };
  }
}

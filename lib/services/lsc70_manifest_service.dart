import 'dart:convert';

import '../models/app_models.dart';

class Lsc70ManifestService {
  List<Map<String, dynamic>> parse(String source) {
    final decoded = jsonDecode(source);
    final rows = decoded is List
        ? decoded
        : decoded is Map
        ? decoded['entries']
        : null;
    if (rows is! List || rows.isEmpty) {
      throw const FormatException(
        'El manifiesto debe contener una lista entries.',
      );
    }
    if (rows.length > 200) {
      throw const FormatException(
        'El manifiesto admite máximo 200 entradas por lote.',
      );
    }
    final terms = <String>{};
    final keys = <String>{};
    final result = <Map<String, dynamic>>[];
    for (final raw in rows) {
      if (raw is! Map) {
        throw const FormatException('Cada entrada debe ser un objeto JSON.');
      }
      final row = Map<String, dynamic>.from(raw);
      for (final field in [
        'term',
        'animationKey',
        'subset',
        'sourceLabel',
        'participantId',
        'frameUrls',
      ]) {
        if (!row.containsKey(field)) {
          throw FormatException('Falta el campo obligatorio "$field".');
        }
      }
      final term = (row['term'] as String).trim();
      final key = (row['animationKey'] as String).trim();
      if (term.isEmpty || key.isEmpty) {
        throw const FormatException('El término y la clave son obligatorios.');
      }
      if (!terms.add(term.toLowerCase()) || !keys.add(key)) {
        throw FormatException('Término o clave duplicada: $term / $key.');
      }
      if (!['LSC70W', 'LSC70AN'].contains(row['subset'])) {
        throw FormatException('Subconjunto no válido para $term.');
      }
      final kind =
          row['kind'] as String? ??
          (row['subset'] == 'LSC70AN' ? 'letter' : 'word');
      if (!['word', 'letter'].contains(kind) ||
          (row['subset'] == 'LSC70AN' && kind != 'letter') ||
          (row['subset'] == 'LSC70W' && kind != 'word')) {
        throw FormatException(
          'El tipo de entrada no coincide con el subconjunto para $term.',
        );
      }
      final frames = row['frameUrls'];
      if (frames is! List ||
          frames.isEmpty ||
          frames.length > 6 ||
          frames.any((url) => url is! String)) {
        throw FormatException(
          '$term debe tener entre 1 y 6 URLs de fotogramas.',
        );
      }
      final media = SignMedia.fromMap({
        'provider': 'cloudinary',
        'type': 'imageSequence',
        'frameUrls': frames,
        'frameDurationMs': row['frameDurationMs'] ?? 167,
        'dataset': 'LSC70',
        'datasetVersion': '2',
        'subset': row['subset'],
        'sourceLabel': row['sourceLabel'],
        'participantId': row['participantId'],
        'license': 'CC BY 4.0',
        'attribution': 'LSC70 v2 · DOI 10.17632/9ssyn8tff5.2',
      });
      if (media == null) {
        throw FormatException(
          '$term contiene URLs que no son HTTPS de Cloudinary o metadatos inválidos.',
        );
      }
      row['term'] = term;
      row['animationKey'] = key;
      row['kind'] = kind;
      result.add(row);
    }
    return result;
  }
}

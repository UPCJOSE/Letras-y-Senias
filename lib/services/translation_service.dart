import 'dart:math' as math;

import '../models/app_models.dart';

class TranslationService {
  TranslationService({List<SignEntry>? catalog})
    : catalog = catalog ?? demoCatalog;
  final List<SignEntry> catalog;

  TranslationResult translate(String input) {
    final normalized = normalize(input);
    final words = normalized.isEmpty ? <String>[] : normalized.split(' ');
    final signs = <SignEntry>[];
    final missing = <String>[];
    final spelling = <String>[];
    final suggestions = <SignSuggestion>[];
    var index = 0;
    while (index < words.length) {
      SignEntry? match;
      var consumed = 0;
      for (var size = math.min(4, words.length - index); size >= 1; size--) {
        final candidate = words.sublist(index, index + size).join(' ');
        match = _exact(candidate);
        if (match != null) {
          consumed = size;
          break;
        }
      }
      if (match != null) {
        signs.add(match);
        index += consumed;
        continue;
      }
      final word = words[index];
      final ranked =
          catalog
              .map(
                (sign) => SignSuggestion(
                  sign.term,
                  similarity(word, normalize(sign.term)),
                ),
              )
              .where((item) => item.similarity >= .66)
              .toList()
            ..sort((a, b) => b.similarity.compareTo(a.similarity));
      if (ranked.isNotEmpty) {
        suggestions.addAll(ranked.take(3));
      } else {
        missing.add(word);
        spelling.addAll(word.toUpperCase().split(''));
      }
      index++;
    }
    return TranslationResult(
      originalText: input.trim(),
      normalizedText: normalized,
      signs: signs,
      missingWords: missing,
      spelling: spelling,
      suggestions: _uniqueSuggestions(suggestions),
    );
  }

  SignEntry? _exact(String candidate) {
    for (final sign in catalog) {
      if (normalize(sign.term) == candidate ||
          sign.aliases.any((alias) => normalize(alias) == candidate)) {
        return sign;
      }
    }
    return null;
  }

  static String normalize(String value) {
    var result = value.toLowerCase().trim();
    const accents = {
      'á': 'a',
      'é': 'e',
      'í': 'i',
      'ó': 'o',
      'ú': 'u',
      'ü': 'u',
      'ñ': 'n',
    };
    accents.forEach(
      (key, replacement) => result = result.replaceAll(key, replacement),
    );
    result = result.replaceAll(RegExp(r'[^a-z0-9\s]'), ' ');
    result = result.replaceAllMapped(
      RegExp(r'([a-z])\1{2,}'),
      (match) => match.group(1)!,
    );
    return result.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  static double similarity(String first, String second) {
    if (first == second) return 1;
    if (first.isEmpty || second.isEmpty) return 0;
    return 1 -
        _levenshtein(first, second) / math.max(first.length, second.length);
  }

  static int _levenshtein(String first, String second) {
    var previous = List<int>.generate(second.length + 1, (index) => index);
    for (var i = 1; i <= first.length; i++) {
      final current = List<int>.filled(second.length + 1, 0)..[0] = i;
      for (var j = 1; j <= second.length; j++) {
        final cost = first[i - 1] == second[j - 1] ? 0 : 1;
        current[j] = math.min(
          math.min(current[j - 1] + 1, previous[j] + 1),
          previous[j - 1] + cost,
        );
      }
      previous = current;
    }
    return previous.last;
  }

  static List<SignSuggestion> _uniqueSuggestions(List<SignSuggestion> source) {
    final byTerm = <String, SignSuggestion>{};
    for (final item in source) {
      final current = byTerm[item.term];
      if (current == null || item.similarity > current.similarity) {
        byTerm[item.term] = item;
      }
    }
    final result = byTerm.values.toList()
      ..sort((a, b) => b.similarity.compareTo(a.similarity));
    return result.take(3).toList();
  }
}

const demoCatalog = <SignEntry>[
  SignEntry(
    term: 'Hola',
    category: 'Saludos',
    animationKey: 'hola',
    validated: true,
  ),
  SignEntry(term: 'Gracias', category: 'Saludos', animationKey: 'gracias'),
  SignEntry(term: 'Por favor', category: 'Saludos', animationKey: 'por_favor'),
  SignEntry(term: 'Adiós', category: 'Saludos', animationKey: 'adios'),
  SignEntry(
    term: 'Buenos días',
    category: 'Saludos',
    animationKey: 'buenos_dias',
  ),
  SignEntry(term: 'Ayuda', category: 'Emergencias', animationKey: 'ayuda'),
  SignEntry(
    term: 'Emergencia',
    category: 'Emergencias',
    animationKey: 'emergencia',
  ),
  SignEntry(term: 'Policía', category: 'Emergencias', animationKey: 'policia'),
  SignEntry(term: 'Peligro', category: 'Emergencias', animationKey: 'peligro'),
  SignEntry(term: 'Hospital', category: 'Salud', animationKey: 'hospital'),
  SignEntry(
    term: 'Médico',
    category: 'Salud',
    animationKey: 'medico',
    aliases: ['doctor'],
  ),
  SignEntry(term: 'Dolor', category: 'Salud', animationKey: 'dolor'),
  SignEntry(term: 'Cita', category: 'Salud', animationKey: 'cita'),
  SignEntry(
    term: 'Medicamento',
    category: 'Salud',
    animationKey: 'medicamento',
  ),
  SignEntry(term: 'Colegio', category: 'Educación', animationKey: 'colegio'),
  SignEntry(term: 'Profesor', category: 'Educación', animationKey: 'profesor'),
  SignEntry(
    term: 'Estudiante',
    category: 'Educación',
    animationKey: 'estudiante',
  ),
  SignEntry(term: 'Libro', category: 'Educación', animationKey: 'libro'),
  SignEntry(term: 'Aprender', category: 'Educación', animationKey: 'aprender'),
  SignEntry(term: 'Banco', category: 'Servicios', animationKey: 'banco'),
  SignEntry(term: 'Dinero', category: 'Servicios', animationKey: 'dinero'),
  SignEntry(
    term: 'Documento',
    category: 'Servicios',
    animationKey: 'documento',
  ),
  SignEntry(term: 'Baño', category: 'Servicios', animationKey: 'bano'),
  SignEntry(term: 'Bus', category: 'Transporte', animationKey: 'bus'),
  SignEntry(term: 'Taxi', category: 'Transporte', animationKey: 'taxi'),
  SignEntry(term: 'Carro', category: 'Transporte', animationKey: 'carro'),
  SignEntry(term: 'Casa', category: 'Familia', animationKey: 'casa'),
  SignEntry(term: 'Mamá', category: 'Familia', animationKey: 'mama'),
  SignEntry(term: 'Papá', category: 'Familia', animationKey: 'papa'),
  SignEntry(term: 'Amigo', category: 'Familia', animationKey: 'amigo'),
  SignEntry(
    term: 'Necesitar',
    category: 'Verbos',
    animationKey: 'necesitar',
    aliases: ['necesito'],
  ),
  SignEntry(
    term: 'Querer',
    category: 'Verbos',
    animationKey: 'querer',
    aliases: ['quiero'],
  ),
  SignEntry(term: 'Ir', category: 'Verbos', animationKey: 'ir'),
  SignEntry(term: 'Comer', category: 'Alimentos', animationKey: 'comer'),
  SignEntry(term: 'Agua', category: 'Alimentos', animationKey: 'agua'),
  SignEntry(term: 'Comida', category: 'Alimentos', animationKey: 'comida'),
];

import 'dart:math' as math;

import '../models/app_models.dart';

class TranslationService {
  TranslationService({List<SignEntry>? catalog})
    : catalog = catalog ?? const [];
  final List<SignEntry> catalog;

  TranslationResult translate(String input) {
    final normalized = normalize(input);
    final words = normalized.isEmpty ? <String>[] : normalized.split(' ');
    final signs = <SignEntry>[];
    final missing = <String>[];
    final spelling = <String>[];
    final suggestions = <SignSuggestion>[];
    final sequence = <TranslationReference>[];
    final sequenceEntries = <SignEntry?>[];
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
        sequence.add(
          TranslationReference(
            label: match.term,
            kind: SignKind.word,
            signId: match.id,
            animationKey: match.animationKey,
          ),
        );
        sequenceEntries.add(match);
        index += consumed;
        continue;
      }
      final word = words[index];
      final ranked =
          catalog
              .where((sign) => sign.kind == SignKind.word)
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
        final letters = word.toUpperCase().split('');
        spelling.addAll(letters);
        for (final letter in letters) {
          final letterSign = _letter(letter);
          sequence.add(
            TranslationReference(
              label: letter,
              kind: SignKind.letter,
              signId: letterSign?.id,
              animationKey: letterSign?.animationKey ?? '',
            ),
          );
          sequenceEntries.add(letterSign);
        }
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
      sequence: sequence,
      sequenceEntries: sequenceEntries,
    );
  }

  TranslationService withCatalog(List<SignEntry> signs) =>
      TranslationService(catalog: signs);

  SignEntry? _exact(String candidate) {
    final candidateKeys = lookupKeys(candidate);
    for (final sign in catalog) {
      if (sign.kind != SignKind.word) continue;
      final signKeys = {
        ...lookupKeys(normalize(sign.term)),
        for (final alias in sign.aliases) ...lookupKeys(normalize(alias)),
      };
      if (candidateKeys.any(signKeys.contains)) return sign;
    }
    return null;
  }

  /// Formas de número (día/días, mes/meses) usadas para coincidir la misma seña.
  static Set<String> lookupKeys(String normalized) {
    if (normalized.isEmpty) return const {};
    final parts = normalized.split(' ');
    if (parts.length == 1) return _numberForms(parts.single);
    final prefix = parts.sublist(0, parts.length - 1).join(' ');
    return {for (final form in _numberForms(parts.last)) '$prefix $form'};
  }

  static Set<String> _numberForms(String word) {
    if (word.length < 3 || !RegExp(r'^[a-zñ]+$').hasMatch(word)) {
      return {word};
    }
    final forms = <String>{word};
    if (RegExp(r'[aeiou]$').hasMatch(word)) {
      forms.add('${word}s');
    } else if (!word.endsWith('s')) {
      forms.add('${word}es');
    }
    if (word.endsWith('s') && word.length >= 4) {
      final singular = word.substring(0, word.length - 1);
      if (RegExp(r'[aeiou]$').hasMatch(singular)) {
        forms.add(singular);
      }
    }
    if (word.endsWith('es') && word.length >= 5) {
      final stem = word.substring(0, word.length - 2);
      if (RegExp(r'[^aeiouñ]$').hasMatch(stem)) {
        forms.add(stem);
      }
    }
    return forms;
  }

  SignEntry? _letter(String letter) {
    for (final sign in catalog) {
      if (sign.kind == SignKind.letter &&
          (sign.term.toUpperCase() == letter ||
              sign.animationKey.toUpperCase() == letter)) {
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
    };
    accents.forEach(
      (key, replacement) => result = result.replaceAll(key, replacement),
    );
    result = result.replaceAll(RegExp(r'[^a-zñ0-9\s]'), ' ');
    result = result.replaceAllMapped(
      RegExp(r'([a-zñ])\1{2,}'),
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

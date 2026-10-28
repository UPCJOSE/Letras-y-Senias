import 'enums.dart';
import 'sign.dart';

class SignSuggestion {
  const SignSuggestion(this.term, this.similarity);
  final String term;
  final double similarity;
}

class TranslationResult {
  const TranslationResult({
    required this.originalText,
    required this.normalizedText,
    required this.signs,
    required this.missingWords,
    required this.spelling,
    required this.suggestions,
    this.sequence = const [],
    this.sequenceEntries = const [],
  });
  final String originalText;
  final String normalizedText;
  final List<SignEntry> signs;
  final List<String> missingWords;
  final List<String> spelling;
  final List<SignSuggestion> suggestions;
  final List<TranslationReference> sequence;
  final List<SignEntry?> sequenceEntries;
  int get estimatedSeconds => (signs.length * 2) + spelling.length;
}

class TranslationReference {
  const TranslationReference({
    required this.label,
    required this.kind,
    this.signId,
    this.animationKey = '',
  });
  final String label;
  final SignKind kind;
  final String? signId;
  final String animationKey;
  Map<String, dynamic> toMap() => {
    'label': label,
    'kind': kind.name,
    'signId': signId,
    'animationKey': animationKey,
  };
}

class TranslationHistoryItem {
  const TranslationHistoryItem({
    required this.text,
    required this.signCount,
    this.id = '',
    this.normalizedText = '',
    this.signs = const [],
    this.missingWords = const [],
    this.spelling = const [],
    this.createdAt,
    this.sequence = const [],
  });
  final String id;
  final String text;
  final String normalizedText;
  final int signCount;
  final List<SignEntry> signs;
  final List<String> missingWords;
  final List<String> spelling;
  final DateTime? createdAt;
  final List<TranslationReference> sequence;

  String get label {
    final timestamp = createdAt;
    if (timestamp == null) return '';
    final local = timestamp.toLocal();
    final now = DateTime.now();
    final date = DateTime(local.year, local.month, local.day);
    final today = DateTime(now.year, now.month, now.day);
    final dayLabel = date == today
        ? 'Hoy'
        : date == today.subtract(const Duration(days: 1))
        ? 'Ayer'
        : '${local.day} ${_monthName(local.month)}';
    final hour = local.hour % 12 == 0 ? 12 : local.hour % 12;
    final minute = local.minute.toString().padLeft(2, '0');
    final period = local.hour < 12 ? 'a. m.' : 'p. m.';
    return '$dayLabel, $hour:$minute $period';
  }

  static String _monthName(int month) => const [
    'ene',
    'feb',
    'mar',
    'abr',
    'may',
    'jun',
    'jul',
    'ago',
    'sep',
    'oct',
    'nov',
    'dic',
  ][month - 1];
}

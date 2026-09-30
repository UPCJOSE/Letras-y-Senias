enum AppRole { individual, admin }

class SignEntry {
  const SignEntry({
    required this.term,
    required this.category,
    required this.animationKey,
    this.aliases = const [],
    this.validated = false,
  });
  final String term;
  final String category;
  final String animationKey;
  final List<String> aliases;
  final bool validated;
}

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
  });
  final String originalText;
  final String normalizedText;
  final List<SignEntry> signs;
  final List<String> missingWords;
  final List<String> spelling;
  final List<SignSuggestion> suggestions;
  int get estimatedSeconds => (signs.length * 2) + spelling.length;
}

class TranslationHistoryItem {
  const TranslationHistoryItem({
    required this.text,
    required this.label,
    required this.signCount,
  });
  final String text;
  final String label;
  final int signCount;
}

class DemoUser {
  const DemoUser(this.name, this.email, this.role, this.active);
  final String name;
  final String email;
  final String role;
  final bool active;
}

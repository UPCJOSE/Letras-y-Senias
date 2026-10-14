enum AppRole { individual, admin }

enum SignStatus { draft, validated }

enum SignKind { word, letter }

class SignMedia {
  const SignMedia({
    required this.frameUrls,
    required this.subset,
    required this.sourceLabel,
    required this.participantId,
    required this.attribution,
    this.frameDurationMs = 167,
    this.provider = 'cloudinary',
    this.type = 'imageSequence',
    this.dataset = 'LSC70',
    this.datasetVersion = '2',
    this.license = 'CC BY 4.0',
  });
  final List<String> frameUrls;
  final int frameDurationMs;
  final String provider;
  final String type;
  final String dataset;
  final String datasetVersion;
  final String subset;
  final String sourceLabel;
  final String participantId;
  final String license;
  final String attribution;

  bool get isUsable =>
      provider == 'cloudinary' &&
      type == 'imageSequence' &&
      dataset == 'LSC70' &&
      datasetVersion == '2' &&
      (subset == 'LSC70W' || subset == 'LSC70AN') &&
      sourceLabel.trim().isNotEmpty &&
      participantId.trim().isNotEmpty &&
      license == 'CC BY 4.0' &&
      attribution.trim().isNotEmpty &&
      frameUrls.isNotEmpty &&
      frameUrls.length <= 6 &&
      frameDurationMs >= 50 &&
      frameDurationMs <= 2000 &&
      frameUrls.every(_isCloudinaryUrl);

  static bool _isCloudinaryUrl(String value) {
    final uri = Uri.tryParse(value);
    return uri != null &&
        uri.scheme == 'https' &&
        uri.host == 'res.cloudinary.com' &&
        uri.pathSegments.length >= 3;
  }

  Map<String, dynamic> toMap() => {
    'provider': provider,
    'type': type,
    'frameUrls': frameUrls,
    'frameDurationMs': frameDurationMs,
    'dataset': dataset,
    'datasetVersion': datasetVersion,
    'subset': subset,
    'sourceLabel': sourceLabel,
    'participantId': participantId,
    'license': license,
    'attribution': attribution,
  };

  static SignMedia? fromMap(Object? value) {
    if (value is! Map) return null;
    final urls = value['frameUrls'];
    if (urls is! List || urls.any((url) => url is! String)) return null;
    try {
      final media = SignMedia(
        frameUrls: urls.cast<String>().toList(),
        frameDurationMs: value['frameDurationMs'] as int? ?? 167,
        provider: value['provider'] as String? ?? '',
        type: value['type'] as String? ?? '',
        dataset: value['dataset'] as String? ?? '',
        datasetVersion: value['datasetVersion'] as String? ?? '',
        subset: value['subset'] as String? ?? '',
        sourceLabel: value['sourceLabel'] as String? ?? '',
        participantId: value['participantId'] as String? ?? '',
        license: value['license'] as String? ?? '',
        attribution: value['attribution'] as String? ?? '',
      );
      return media.isUsable ? media : null;
    } on TypeError {
      return null;
    }
  }
}

class AppUserProfile {
  const AppUserProfile({
    required this.id,
    required this.displayName,
    required this.email,
    required this.role,
    this.active = true,
    this.preferences = const {},
  });

  final String id;
  final String displayName;
  final String email;
  final AppRole role;
  final bool active;
  final Map<String, dynamic> preferences;

  factory AppUserProfile.fromMap(String id, Map<String, dynamic> data) {
    return AppUserProfile(
      id: id,
      displayName: data['displayName'] as String? ?? '',
      email: data['email'] as String? ?? '',
      role: data['role'] == 'admin' ? AppRole.admin : AppRole.individual,
      active: data['active'] as bool? ?? true,
      preferences: data['preferences'] as Map<String, dynamic>? ?? const {},
    );
  }
}

class SignEntry {
  const SignEntry({
    required this.term,
    required this.category,
    required this.animationKey,
    this.aliases = const [],
    this.validated = false,
    this.active = false,
    this.id,
    this.source,
    this.media,
    this.kind = SignKind.word,
  });
  final String? id;
  final String term;
  final String category;
  final String animationKey;
  final List<String> aliases;
  final bool validated;
  final bool active;
  final String? source;
  final SignMedia? media;
  final SignKind kind;

  SignStatus get status => validated ? SignStatus.validated : SignStatus.draft;
}

class SignCategory {
  const SignCategory({
    required this.id,
    required this.name,
    this.active = true,
  });

  final String id;
  final String name;
  final bool active;
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

class AdminDashboardStats {
  const AdminDashboardStats({
    required this.people,
    required this.translations,
    required this.draftSigns,
    required this.untranslatedWords,
  });

  final int people;
  final int translations;
  final int draftSigns;
  final int untranslatedWords;
}

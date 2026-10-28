import 'enums.dart';

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

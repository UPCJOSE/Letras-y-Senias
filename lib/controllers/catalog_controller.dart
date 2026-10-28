part of 'app_controller.dart';

/// Catálogo público y de administración de señas.
mixin CatalogController on AppControllerCore {
  late final SharedLatestStream<List<SignEntry>> _publicSignsStream =
      SharedLatestStream(_signRepository.watchPublishedSigns);
  late final SharedLatestStream<List<SignEntry>> _allSignsStream =
      SharedLatestStream(_signRepository.watchAllSigns);
  late final SharedLatestStream<List<SignCategory>> _categoriesStream =
      SharedLatestStream(() => _signRepository.watchCategories());
  late final SharedLatestStream<List<SignCategory>> _adminCategoriesStream =
      SharedLatestStream(
        () => _signRepository.watchCategories(includeDrafts: true),
      );

  Stream<List<SignEntry>> get publicSigns => _publicSignsStream;
  Stream<List<SignEntry>> get allSigns => _allSignsStream;
  Stream<List<SignCategory>> get categories => _categoriesStream;
  Stream<List<SignCategory>> get adminCategories => _adminCategoriesStream;

  Future<void> saveDraftSign({
    required String term,
    required String category,
    required String animationKey,
    required List<String> aliases,
    required String source,
  }) => _signRepository.saveDraft(
    term: term,
    category: category,
    animationKey: animationKey,
    aliases: aliases,
    source: source,
  );

  Future<void> validateSign(String id) => _signRepository.validateSign(id);

  Future<int> validateSigns(List<String> ids) =>
      _signRepository.validateSigns(ids);
}

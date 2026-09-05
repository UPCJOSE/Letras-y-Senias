import 'package:movi/model/sign_entry.dart';

/// Servicio del diccionario texto → señas.
/// En esta fase solo existe la clase; la lógica se implementará después.
class DictionaryService {
  /// Busca una seña por palabra. Aún no conectado a datos reales.
  Future<SignEntry?> findByWord(String word) async {
    // TODO: cargar diccionario (JSON / BD local) y buscar la palabra.
    return null;
  }

  /// Lista todas las señas del catálogo.
  Future<List<SignEntry>> getAllSigns() async {
    // TODO: devolver el catálogo completo.
    return [];
  }
}

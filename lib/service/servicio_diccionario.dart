import 'package:movi/model/entrada_sena.dart';

/// Servicio del diccionario texto → señas.
/// En esta fase solo existe la clase; la lógica se implementará después.
class ServicioDiccionario {
  /// Busca una seña por palabra. Aún no conectado a datos reales.
  Future<EntradaSena?> buscarPorPalabra(String palabra) async {
    // TODO: cargar diccionario (JSON / BD local) y buscar la palabra.
    return null;
  }

  /// Lista todas las señas del catálogo.
  Future<List<EntradaSena>> obtenerTodasLasSenas() async {
    // TODO: devolver el catálogo completo.
    return [];
  }
}

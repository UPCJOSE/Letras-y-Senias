import 'package:flutter_test/flutter_test.dart';
import 'package:senas_app/services/translation_service.dart';

void main() {
  final service = TranslationService();

  test('normaliza tildes, signos y repeticiones', () {
    expect(TranslationService.normalize('  ¡Holaaa, MÉDICO! '), 'hola medico');
  });

  test('resuelve palabras, frases y alias del catálogo', () {
    final result = service.translate('Hola, necesito ayuda por favor');
    expect(result.signs.map((sign) => sign.term), [
      'Hola',
      'Necesitar',
      'Ayuda',
      'Por favor',
    ]);
    expect(result.missingWords, isEmpty);
  });

  test('sugiere una palabra parecida', () {
    final result = service.translate('holi');
    expect(result.suggestions.first.term, 'Hola');
  });

  test('prepara deletreo cuando no encuentra coincidencias', () {
    final result = service.translate('xyz');
    expect(result.missingWords, ['xyz']);
    expect(result.spelling, ['X', 'Y', 'Z']);
  });
}

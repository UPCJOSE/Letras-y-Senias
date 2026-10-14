import 'package:flutter_test/flutter_test.dart';
import 'package:senas_app/models/app_models.dart';
import 'package:senas_app/services/translation_service.dart';

void main() {
  final service = TranslationService(
    catalog: const [
      SignEntry(term: 'Hola', category: 'Saludos', animationKey: 'hola'),
      SignEntry(
        term: 'Por favor',
        category: 'Saludos',
        animationKey: 'por_favor',
      ),
      SignEntry(term: 'Ayuda', category: 'Emergencias', animationKey: 'ayuda'),
      SignEntry(
        term: 'Necesitar',
        category: 'Verbos',
        animationKey: 'necesitar',
        aliases: ['necesito'],
      ),
    ],
  );

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

  test('conserva la Ñ al normalizar para deletreo', () {
    expect(TranslationService.normalize('NIÑO'), 'niño');
    expect(service.translate('niño').spelling, ['N', 'I', 'Ñ', 'O']);
  });

  test('genera referencias ordenadas a palabra y letras disponibles', () {
    final withAlphabet = TranslationService(
      catalog: [
        const SignEntry(
          term: 'Hola',
          category: 'Saludos',
          animationKey: 'hola',
          id: 'hola',
        ),
        const SignEntry(
          term: 'A',
          category: 'Alfabeto',
          animationKey: 'A',
          id: 'letter-a',
          kind: SignKind.letter,
        ),
      ],
    ).translate('Hola X');
    expect(withAlphabet.sequence.map((entry) => entry.label), ['Hola', 'X']);
    expect(withAlphabet.sequence.first.signId, 'hola');
    expect(withAlphabet.sequence.last.signId, isNull);
  });
}

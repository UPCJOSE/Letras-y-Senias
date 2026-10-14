import 'package:flutter_test/flutter_test.dart';
import 'package:senas_app/services/lsc70_manifest_service.dart';

void main() {
  const row =
      '''{"entries":[{"term":"Hola","animationKey":"hola","subset":"LSC70W","sourceLabel":"HELLO","participantId":"P01","frameUrls":["https://res.cloudinary.com/demo/image/upload/f1.jpg","https://res.cloudinary.com/demo/image/upload/f2.jpg"]}]}''';

  test('acepta manifiesto Cloudinary HTTPS y devuelve su preview', () {
    expect(Lsc70ManifestService().parse(row).single['term'], 'Hola');
  });

  test('infiere kind letter para el subconjunto alfanumérico', () {
    final letter = row
        .replaceAll('LSC70W', 'LSC70AN')
        .replaceAll('"Hello"', '"Ñ"');
    expect(Lsc70ManifestService().parse(letter).single['kind'], 'letter');
  });

  test('rechaza hosts locales o externos', () {
    expect(
      () => Lsc70ManifestService().parse(
        row.replaceAll(
          'https://res.cloudinary.com/demo/image/upload/f1.jpg',
          'http://localhost/frame.jpg',
        ),
      ),
      throwsFormatException,
    );
  });

  test('rechaza claves y términos duplicados', () {
    final entry = row.substring(row.indexOf('{"term"'), row.lastIndexOf(']'));
    expect(
      () => Lsc70ManifestService().parse('{"entries":[$entry,$entry]}'),
      throwsFormatException,
    );
  });
}

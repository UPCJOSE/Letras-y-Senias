import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:senas_app/models/app_models.dart';
import 'package:senas_app/shared/widgets/lsc70_player.dart';

void main() {
  const media = SignMedia(
    frameUrls: [
      'https://res.cloudinary.com/demo/image/upload/f1.jpg',
      'https://res.cloudinary.com/demo/image/upload/f2.jpg',
    ],
    subset: 'LSC70W',
    sourceLabel: 'Hello',
    participantId: 'Per01',
    attribution: 'LSC70 v2',
  );

  testWidgets('reproduce, pausa y repite desde Play al terminar', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Lsc70Player(media: media, imageBuilder: (_, url) => Text(url)),
        ),
      ),
    );
    expect(find.text(media.frameUrls.first), findsOneWidget);
    await tester.tap(find.byTooltip('Reproducir'));
    await tester.pump(const Duration(milliseconds: 168));
    expect(find.text(media.frameUrls.last), findsOneWidget);
    await tester.tap(find.byTooltip('Pausar'));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text(media.frameUrls.last), findsOneWidget);
    await tester.tap(find.byTooltip('Reproducir'));
    await tester.pump(const Duration(milliseconds: 168));
    expect(find.byTooltip('Repetir'), findsOneWidget);
    expect(find.byTooltip('Reiniciar'), findsNothing);
    await tester.tap(find.byTooltip('Repetir'));
    await tester.pump();
    expect(find.text(media.frameUrls.first), findsOneWidget);
    expect(find.byTooltip('Pausar'), findsOneWidget);
  });

  testWidgets('sin medio no muestra controles de reproducción', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: Lsc70Player())),
    );
    expect(find.text('Recurso visual no disponible'), findsOneWidget);
    expect(find.byTooltip('Reproducir'), findsNothing);
    expect(find.byTooltip('Repetir'), findsNothing);
  });

  testWidgets('pausa la secuencia al ocultar su pestaña', (tester) async {
    Widget player(bool visible) => MaterialApp(
      home: Scaffold(
        body: TickerMode(
          enabled: visible,
          child: Lsc70Player(media: media, imageBuilder: (_, url) => Text(url)),
        ),
      ),
    );
    await tester.pumpWidget(player(true));
    await tester.tap(find.byTooltip('Reproducir'));
    await tester.pumpWidget(player(false));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text(media.frameUrls.first), findsOneWidget);
    expect(find.byTooltip('Reproducir'), findsOneWidget);
  });
}

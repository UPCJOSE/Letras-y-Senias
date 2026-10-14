import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:senas_app/services/shared_latest_stream.dart';

void main() {
  test(
    'comparte el listener, repite el último dato y libera la fuente',
    () async {
      final sources = <StreamController<int>>[];
      var cancelled = 0;
      final stream = SharedLatestStream<int>(() {
        final source = StreamController<int>.broadcast(
          onCancel: () => cancelled++,
        );
        sources.add(source);
        return source.stream;
      });
      addTearDown(() async {
        await stream.dispose();
        for (final source in sources) {
          await source.close();
        }
      });

      final firstValues = <int>[];
      final first = stream.listen(firstValues.add);
      sources.single.add(1);
      await Future<void>.delayed(Duration.zero);

      final secondValues = <int>[];
      final second = stream.listen(secondValues.add);
      await Future<void>.delayed(Duration.zero);
      expect(sources.length, 1);
      expect(secondValues, [1]);
      sources.single.add(2);
      await Future<void>.delayed(Duration.zero);
      expect(firstValues, [1, 2]);
      expect(secondValues, [1, 2]);

      await first.cancel();
      await second.cancel();
      expect(cancelled, 1);

      final thirdValues = <int>[];
      final third = stream.listen(thirdValues.add);
      expect(sources.length, 2);
      expect(thirdValues, isEmpty);
      sources.last.add(3);
      await Future<void>.delayed(Duration.zero);
      expect(thirdValues, [3]);
      await third.cancel();
    },
  );
}

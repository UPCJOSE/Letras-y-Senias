import 'dart:async';

/// Shares one live source among screens and replays its latest Firestore value.
/// The source is recreated when the last screen leaves and a new one subscribes.
class SharedLatestStream<T> extends Stream<T> {
  SharedLatestStream(this._createSource);

  final Stream<T> Function() _createSource;
  late final StreamController<T> _shared = StreamController<T>.broadcast(
    onListen: _start,
    onCancel: _stop,
  );
  StreamSubscription<T>? _source;
  T? _latest;
  bool _hasLatest = false;
  bool _disposed = false;
  int _generation = 0;

  T? get latest => _hasLatest ? _latest : null;

  void _start() {
    if (_disposed) return;
    final generation = ++_generation;
    _source = _createSource().listen(
      (value) {
        if (_disposed || generation != _generation) return;
        _latest = value;
        _hasLatest = true;
        _shared.add(value);
      },
      onError: (Object error, StackTrace stack) {
        if (!_disposed && generation == _generation) {
          _shared.addError(error, stack);
        }
      },
    );
  }

  void _stop() {
    ++_generation;
    final source = _source;
    _source = null;
    _latest = null;
    _hasLatest = false;
    if (source != null) unawaited(source.cancel());
  }

  @override
  StreamSubscription<T> listen(
    void Function(T event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    late final StreamController<T> personal;
    StreamSubscription<T>? relay;
    personal = StreamController<T>(
      sync: true,
      onListen: () {
        if (_hasLatest) personal.add(_latest as T);
        relay = _shared.stream.listen(
          personal.add,
          onError: personal.addError,
          onDone: personal.close,
        );
      },
      onCancel: () => relay?.cancel(),
    );
    return personal.stream.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    ++_generation;
    await _source?.cancel();
    _source = null;
    await _shared.close();
  }
}

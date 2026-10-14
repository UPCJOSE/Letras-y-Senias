import 'dart:async';

import 'package:flutter/material.dart';

import '../../models/app_models.dart';

/// Reproduces the original LSC70 frames; it never substitutes local imagery.
class Lsc70Player extends StatefulWidget {
  const Lsc70Player({
    super.key,
    this.media,
    this.sequence = const [],
    this.height = 250,
    this.initialSpeed = 1,
    this.imageBuilder,
    this.onSequenceIndexChanged,
  });
  final SignMedia? media;
  final List<SignMedia?> sequence;
  final double height;
  final double initialSpeed;
  final ValueChanged<int>? onSequenceIndexChanged;
  @visibleForTesting
  final Widget Function(BuildContext context, String url)? imageBuilder;

  @override
  State<Lsc70Player> createState() => _Lsc70PlayerState();
}

class _Lsc70PlayerState extends State<Lsc70Player> {
  Timer? _timer;
  int _frame = 0;
  double _speed = 1;
  bool _playing = false;
  bool _completed = false;
  bool _failed = false;
  bool _showAttribution = false;
  int? _lastPrefetchedIndex;

  @override
  void initState() {
    super.initState();
    _speed = widget.initialSpeed;
  }

  List<(String, int, int)> get _frames => [
    for (final (index, item)
        in (widget.sequence.isEmpty ? [widget.media] : widget.sequence).indexed)
      if (item != null && item.isUsable)
        for (final url in item.frameUrls) (url, item.frameDurationMs, index),
  ];
  String get _fingerprint => _frames.map((frame) => frame.$1).join('|');

  void _start() {
    final frames = _frames;
    if (frames.isEmpty) return;
    _timer?.cancel();
    setState(() {
      if (_completed) _frame = 0;
      _completed = false;
      _playing = true;
      _failed = false;
    });
    widget.onSequenceIndexChanged?.call(frames[_frame].$3);
    _warmNextFrame();
    _scheduleNext();
  }

  void _warmNextFrame() {
    if (widget.imageBuilder != null) return;
    final next = _frame + 1;
    final frames = _frames;
    if (next >= frames.length || _lastPrefetchedIndex == next) return;
    _lastPrefetchedIndex = next;
    unawaited(
      precacheImage(NetworkImage(frames[next].$1), context).catchError((_) {}),
    );
  }

  void _scheduleNext() {
    final frames = _frames;
    if (frames.isEmpty) return;
    _timer = Timer(
      Duration(milliseconds: (frames[_frame].$2 / _speed).round()),
      () {
        if (!mounted || !_playing) return;
        if (_frame >= frames.length - 1) {
          setState(() {
            _playing = false;
            _completed = true;
          });
          _timer?.cancel();
          return;
        }
        final previousIndex = frames[_frame].$3;
        setState(() => _frame++);
        if (frames[_frame].$3 != previousIndex) {
          widget.onSequenceIndexChanged?.call(frames[_frame].$3);
        }
        _warmNextFrame();
        _scheduleNext();
      },
    );
  }

  void _pause() {
    _timer?.cancel();
    setState(() => _playing = false);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!TickerMode.valuesOf(context).enabled && _playing) {
      _timer?.cancel();
      _playing = false;
    }
  }

  @override
  void didUpdateWidget(covariant Lsc70Player oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldFingerprint = [
      for (final item
          in (oldWidget.sequence.isEmpty
              ? [oldWidget.media]
              : oldWidget.sequence))
        if (item != null && item.isUsable) ...item.frameUrls,
    ].join('|');
    if (oldFingerprint != _fingerprint) {
      _timer?.cancel();
      _frame = 0;
      _playing = false;
      _completed = false;
      _failed = false;
      _lastPrefetchedIndex = null;
    }
    if (oldWidget.initialSpeed != widget.initialSpeed) {
      _speed = widget.initialSpeed;
      if (_playing) {
        _timer?.cancel();
        _scheduleNext();
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final frames = _frames;
    final mediaItems =
        (widget.sequence.isEmpty ? [widget.media] : widget.sequence)
            .whereType<SignMedia>()
            .where((item) => item.isUsable)
            .toList();
    if (frames.isEmpty) {
      return SizedBox(
        height: widget.height,
        child: const Center(child: Text('Recurso visual no disponible')),
      );
    }
    final safeFrame = _frame.clamp(0, frames.length - 1);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: widget.height,
          width: double.infinity,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: const Color(0xFFF0F3FF),
              borderRadius: BorderRadius.circular(24),
            ),
            child: _failed
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('No se pudo cargar la imagen.'),
                        TextButton.icon(
                          onPressed: () {
                            setState(() => _failed = false);
                            _start();
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child:
                        widget.imageBuilder?.call(
                          context,
                          frames[safeFrame].$1,
                        ) ??
                        Image.network(
                          frames[safeFrame].$1,
                          fit: BoxFit.contain,
                          loadingBuilder: (context, child, progress) =>
                              progress == null
                              ? child
                              : const Center(
                                  child: CircularProgressIndicator(),
                                ),
                          errorBuilder: (_, _, _) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (mounted) {
                                _timer?.cancel();
                                setState(() {
                                  _failed = true;
                                  _playing = false;
                                });
                              }
                            });
                            return const Center(
                              child: Text('No se pudo cargar la imagen.'),
                            );
                          },
                        ),
                  ),
          ),
        ),
        const SizedBox(height: 10),
        LinearProgressIndicator(value: (safeFrame + 1) / frames.length),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              tooltip: _playing
                  ? 'Pausar'
                  : _completed
                  ? 'Repetir'
                  : 'Reproducir',
              onPressed: _playing ? _pause : _start,
              icon: Icon(
                _playing ? Icons.pause_circle : Icons.play_circle,
                size: 38,
              ),
            ),
            DropdownButton<double>(
              value: _speed,
              items: const <double>[0.5, 1.0, 1.5]
                  .map(
                    (speed) => DropdownMenuItem(
                      value: speed,
                      child: Text('${speed}x'),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value == null) return;
                setState(() => _speed = value);
                if (_playing) _start();
              },
            ),
          ],
        ),
        Text(
          'LSC70 v2 · CC BY 4.0',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        TextButton(
          onPressed: () => setState(() => _showAttribution = !_showAttribution),
          child: Text(
            _showAttribution ? 'Ocultar fuente' : 'Ver fuente y licencia',
          ),
        ),
        if (_showAttribution) ...[
          Text(
            mediaItems
                .map(
                  (item) =>
                      '${item.subset} · ${item.sourceLabel} · participante ${item.participantId}',
                )
                .toSet()
                .join('  |  '),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Text(
            mediaItems.map((item) => item.attribution).toSet().join('  |  '),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ],
    );
  }
}

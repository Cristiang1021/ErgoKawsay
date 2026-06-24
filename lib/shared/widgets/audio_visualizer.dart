import 'dart:math';
import 'package:flutter/material.dart';

/// Animated vertical-bar audio visualizer.
/// Bars animate when [isPlaying] is true; they settle to low height when paused.
class AudioVisualizer extends StatefulWidget {
  const AudioVisualizer({
    super.key,
    required this.isPlaying,
    required this.color,
    this.barCount = 22,
    this.maxHeight = 52,
  });

  final bool isPlaying;
  final Color color;
  final int barCount;
  final double maxHeight;

  @override
  State<AudioVisualizer> createState() => _AudioVisualizerState();
}

class _AudioVisualizerState extends State<AudioVisualizer>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;
  late final List<Animation<double>> _animations;
  final _rng = Random(37);

  @override
  void initState() {
    super.initState();

    _controllers = List.generate(widget.barCount, (i) {
      return AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 280 + _rng.nextInt(360)),
      );
    });

    _animations = List.generate(widget.barCount, (i) {
      final minFrac = 0.04 + _rng.nextDouble() * 0.08;
      final maxFrac = 0.35 + _rng.nextDouble() * 0.65;
      return Tween<double>(begin: minFrac, end: maxFrac).animate(
        CurvedAnimation(
          parent: _controllers[i],
          curve: i.isEven ? Curves.easeInOut : Curves.easeOutSine,
        ),
      );
    });

    if (widget.isPlaying) _startAll();
  }

  void _startAll() {
    for (var i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 18), () {
        if (mounted) _controllers[i].repeat(reverse: true);
      });
    }
  }

  void _stopAll() {
    for (final c in _controllers) {
      c.animateTo(0.07, duration: const Duration(milliseconds: 350));
    }
  }

  @override
  void didUpdateWidget(AudioVisualizer old) {
    super.didUpdateWidget(old);
    if (widget.isPlaying != old.isPlaying) {
      widget.isPlaying ? _startAll() : _stopAll();
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) { c.dispose(); }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.maxHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(widget.barCount, (i) {
          return AnimatedBuilder(
            animation: _animations[i],
            builder: (_, __) {
              final h =
                  (_animations[i].value * widget.maxHeight).clamp(3.0, widget.maxHeight);
              return Container(
                width: 3,
                height: h,
                margin: const EdgeInsets.symmetric(horizontal: 1.5),
                decoration: BoxDecoration(
                  color: widget.color,
                  borderRadius: BorderRadius.circular(2),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}

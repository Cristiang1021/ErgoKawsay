import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

enum TimerState { idle, running, paused, finished }

class TimerController extends ChangeNotifier {
  TimerController({required this.totalSeconds, this.onFinished});

  final int totalSeconds;
  final VoidCallback? onFinished;

  Timer? _timer;
  int _remaining = 0;
  TimerState _state = TimerState.idle;

  int get remaining => _remaining;
  TimerState get state => _state;
  double get progress =>
      totalSeconds == 0 ? 0 : 1 - (_remaining / totalSeconds);

  void start() {
    if (_state == TimerState.finished) {
      _remaining = totalSeconds;
    } else if (_state == TimerState.idle) {
      _remaining = totalSeconds;
    }
    _state = TimerState.running;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remaining <= 1) {
        _remaining = 0;
        _state = TimerState.finished;
        _timer?.cancel();
        onFinished?.call();
      } else {
        _remaining--;
      }
      notifyListeners();
    });
    notifyListeners();
  }

  void pause() {
    _timer?.cancel();
    _state = TimerState.paused;
    notifyListeners();
  }

  void reset() {
    _timer?.cancel();
    _remaining = totalSeconds;
    _state = TimerState.idle;
    notifyListeners();
  }

  void finish() {
    _timer?.cancel();
    _remaining = 0;
    _state = TimerState.finished;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

class CircularTimerWidget extends StatelessWidget {
  const CircularTimerWidget({
    super.key,
    required this.remaining,
    required this.total,
    required this.progress,
    this.size = 180,
  });

  final int remaining;
  final int total;
  final double progress;
  final double size;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 14,
              backgroundColor: p.surface2,
              color: p.accent,
              strokeCap: StrokeCap.round,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _formatTime(remaining),
                style: AppTypography.timerDisplay(p),
              ),
              const SizedBox(height: 4),
              Text(
                '/ ${_formatTime(total)}',
                style: AppTypography.bodySm(p),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
}

class LinearTimerBar extends StatelessWidget {
  const LinearTimerBar({super.key, required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: LinearProgressIndicator(
        value: progress,
        minHeight: 10,
        backgroundColor: p.surface2,
        color: p.accent,
      ),
    );
  }
}

class TimerControls extends StatelessWidget {
  const TimerControls({
    super.key,
    required this.state,
    required this.onStart,
    required this.onPause,
    required this.onFinish,
    this.startLabel = 'Iniciar',
    this.pauseLabel = 'Pausar',
    this.resumeLabel = 'Reanudar',
    this.finishLabel = 'Finalizar',
  });

  final TimerState state;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onFinish;
  final String startLabel;
  final String pauseLabel;
  final String resumeLabel;
  final String finishLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (state == TimerState.idle || state == TimerState.finished)
          ElevatedButton.icon(
            onPressed: onStart,
            icon: const Icon(Icons.play_arrow),
            label: Text(startLabel),
          ),
        if (state == TimerState.running)
          ElevatedButton.icon(
            onPressed: onPause,
            icon: const Icon(Icons.pause),
            label: Text(pauseLabel),
          ),
        if (state == TimerState.paused)
          ElevatedButton.icon(
            onPressed: onStart,
            icon: const Icon(Icons.play_arrow),
            label: Text(resumeLabel),
          ),
        const SizedBox(width: 12),
        if (state != TimerState.idle)
          OutlinedButton.icon(
            onPressed: onFinish,
            icon: const Icon(Icons.stop),
            label: Text(finishLabel),
          ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/exercise.dart';
import '../../features/language/splash_screen.dart';
import '../../shared/widgets/timer_widget.dart';

class ExerciseSessionScreen extends StatefulWidget {
  const ExerciseSessionScreen({
    super.key,
    required this.exercise,
    this.onSessionComplete,
  });

  final Exercise exercise;
  final Future<void> Function()? onSessionComplete;

  @override
  State<ExerciseSessionScreen> createState() => _ExerciseSessionScreenState();
}

class _ExerciseSessionScreenState extends State<ExerciseSessionScreen> {
  late final TimerController _timer;
  bool _recorded = false;

  @override
  void initState() {
    super.initState();
    _timer = TimerController(
      totalSeconds: widget.exercise.durationSeconds,
      onFinished: _onFinished,
    );
    _timer.addListener(() => setState(() {}));
  }

  Future<void> _onFinished() async {
    if (_recorded) return;
    _recorded = true;
    if (widget.onSessionComplete != null) {
      await widget.onSessionComplete!();
    } else {
      await StorageServiceScope.of(context).recordExerciseCompleted();
    }
  }

  @override
  void dispose() {
    _timer.dispose();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final p = context.palette;
    final exercise = widget.exercise;
    final steps = exercise.steps(l10n.isKichwa);

    final displayRemaining = _timer.state == TimerState.idle
        ? exercise.durationSeconds
        : _timer.remaining;

    return Scaffold(
      backgroundColor: p.canvas,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screen,
                AppSpacing.md,
                AppSpacing.screen,
                0,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      Navigator.maybePop(context);
                    },
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: p.hairline),
                      ),
                      child: Icon(
                        Icons.close_rounded,
                        color: p.ink,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      exercise.name(l10n.isKichwa),
                      style: AppTypography.displayMd(p),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // Timer block
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
                decoration: BoxDecoration(
                  color: _timer.state == TimerState.finished
                      ? p.blockMint
                      : p.surface2,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                ),
                child: Column(
                  children: [
                    Text(
                      _formatTime(displayRemaining),
                      style: AppTypography.timerDisplay(
                        p,
                        color: _timer.state == TimerState.finished
                            ? p.blockMintText
                            : p.ink,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xl,
                      ),
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusPill),
                        child: LinearProgressIndicator(
                          value: _timer.progress,
                          minHeight: 4,
                          backgroundColor: p.hairline,
                          color: _timer.state == TimerState.finished
                              ? p.blockMintText
                              : p.ink,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '/ ${_formatTime(exercise.durationSeconds)}',
                      style: AppTypography.micro(p),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Steps
            if (steps.isNotEmpty)
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screen,
                  ),
                  itemCount: steps.length,
                  separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xxs),
                  itemBuilder: (context, index) {
                    return _StepRow(
                      number: index + 1,
                      text: steps[index],
                      p: p,
                    );
                  },
                ),
              )
            else
              const Spacer(),

            const SizedBox(height: AppSpacing.lg),

            // Controls
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screen,
                0,
                AppSpacing.screen,
                AppSpacing.lg,
              ),
              child: _TimerButtons(
                state: _timer.state,
                onStart: _timer.start,
                onPause: _timer.pause,
                onFinish: () {
                  _timer.finish();
                  _onFinished();
                },
                startLabel: l10n.start,
                pauseLabel: l10n.pause,
                resumeLabel: l10n.resume,
                finishLabel: l10n.finish,
                p: p,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({required this.number, required this.text, required this.p});

  final int number;
  final String text;
  final AppPalette p;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: p.ink,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            '$number',
            style: AppTypography.micro(p, color: p.primaryBtnFg)
                .copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(text, style: AppTypography.body(p)),
          ),
        ),
      ],
    );
  }
}

class _TimerButtons extends StatelessWidget {
  const _TimerButtons({
    required this.state,
    required this.onStart,
    required this.onPause,
    required this.onFinish,
    required this.startLabel,
    required this.pauseLabel,
    required this.resumeLabel,
    required this.finishLabel,
    required this.p,
  });

  final TimerState state;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onFinish;
  final String startLabel;
  final String pauseLabel;
  final String resumeLabel;
  final String finishLabel;
  final AppPalette p;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              if (state == TimerState.running) {
                onPause();
              } else {
                onStart();
              }
            },
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: p.ink,
                borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
              ),
              alignment: Alignment.center,
              child: Text(
                state == TimerState.running
                    ? pauseLabel
                    : state == TimerState.paused
                        ? resumeLabel
                        : startLabel,
                style: AppTypography.button(p, color: p.primaryBtnFg),
              ),
            ),
          ),
        ),
        if (state != TimerState.idle) ...[
          const SizedBox(width: AppSpacing.xs),
          GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              onFinish();
            },
            child: Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                border: Border.all(color: p.hairline),
              ),
              alignment: Alignment.center,
              child: Text(
                finishLabel,
                style: AppTypography.button(p, color: p.ink),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

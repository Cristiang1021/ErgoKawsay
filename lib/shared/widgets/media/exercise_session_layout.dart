import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../timer_widget.dart';
import 'flat_illustration.dart';
import 'media_hero.dart';
import 'step_pager.dart';

class ExerciseSessionLayout extends StatelessWidget {
  const ExerciseSessionLayout({
    super.key,
    required this.title,
    required this.steps,
    required this.stepLabel,
    required this.remaining,
    required this.total,
    required this.progress,
    required this.timerState,
    required this.onStart,
    required this.onPause,
    required this.onFinish,
    required this.startLabel,
    required this.pauseLabel,
    required this.resumeLabel,
    required this.finishLabel,
    this.videoUrl,
    this.imageAsset,
    this.imageUrl,
  });

  final String title;
  final List<String> steps;
  final String Function(int current, int total) stepLabel;
  final int remaining;
  final int total;
  final double progress;
  final TimerState timerState;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onFinish;
  final String startLabel;
  final String pauseLabel;
  final String resumeLabel;
  final String finishLabel;
  final String? videoUrl;
  final String? imageAsset;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MediaHero(
          videoUrl: videoUrl,
          imageAsset: imageAsset,
          imageUrl: imageUrl,
          illustrationPreset: IllustrationPreset.home,
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.lg,
              AppSpacing.lg,
            ),
            child: Column(
              children: [
                Text(title, style: AppTypography.displayMd(p), textAlign: TextAlign.center),
                const SizedBox(height: AppSpacing.lg),
                StepPager(steps: steps, stepLabel: stepLabel),
                const SizedBox(height: AppSpacing.xl),
                CircularTimerWidget(
                  remaining: remaining,
                  total: total,
                  progress: progress,
                  size: 200,
                ),
                const SizedBox(height: AppSpacing.xl),
                TimerControls(
                  state: timerState,
                  onStart: onStart,
                  onPause: onPause,
                  onFinish: onFinish,
                  startLabel: startLabel,
                  pauseLabel: pauseLabel,
                  resumeLabel: resumeLabel,
                  finishLabel: finishLabel,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

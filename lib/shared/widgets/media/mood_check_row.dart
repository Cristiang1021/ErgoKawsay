import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_theme.dart';

class MoodOption {
  const MoodOption({
    required this.id,
    required this.labelEs,
    required this.labelQu,
    required this.emoji,
  });

  final String id;
  final String labelEs;
  final String labelQu;
  final String emoji;

  String label(bool isKichwa) => isKichwa ? labelQu : labelEs;
}

const kDefaultMoodOptions = [
  MoodOption(id: 'calm', labelEs: 'Tranquilo', labelQu: 'Samay', emoji: '😌'),
  MoodOption(id: 'tired', labelEs: 'Cansado', labelQu: 'Pisi k\'ari', emoji: '😴'),
  MoodOption(id: 'stressed', labelEs: 'Estresado', labelQu: 'Llakik', emoji: '😰'),
  MoodOption(id: 'happy', labelEs: 'Bien', labelQu: 'Alli', emoji: '🙂'),
  MoodOption(id: 'anxious', labelEs: 'Ansioso', labelQu: 'Llakishka', emoji: '😟'),
];

class MoodCheckRow extends StatelessWidget {
  const MoodCheckRow({
    super.key,
    required this.title,
    required this.options,
    required this.isKichwa,
    required this.onMoodTap,
  });

  final String title;
  final List<MoodOption> options;
  final bool isKichwa;
  final ValueChanged<MoodOption> onMoodTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTypography.headline(p)),
        const SizedBox(height: AppSpacing.sm),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: options.map((mood) {
              return Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: _MoodChip(
                  emoji: mood.emoji,
                  label: mood.label(isKichwa),
                  onTap: () {
                    HapticFeedback.selectionClick();
                    onMoodTap(mood);
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _MoodChip extends StatelessWidget {
  const _MoodChip({
    required this.emoji,
    required this.label,
    required this.onTap,
  });

  final String emoji;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;

    return Material(
      color: p.surface1,
      borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
            border: Border.all(color: p.hairline),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: AppSpacing.xs),
              Text(label, style: AppTypography.bodySm(p, color: p.ink)),
            ],
          ),
        ),
      ),
    );
  }
}

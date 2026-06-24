import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_theme.dart';
import '../../data/local/local_data_repository.dart';
import '../../data/models/exercise.dart';
import '../../shared/widgets/feature_scaffold.dart';
import 'exercise_session_screen.dart';

class ExercisesScreen extends StatelessWidget {
  const ExercisesScreen({super.key});

  IconData _iconForCategory(String iconName) {
    switch (iconName) {
      case 'neck':
        return Icons.face_retouching_natural_outlined;
      case 'shoulders':
        return Icons.accessibility_new_outlined;
      case 'hands':
        return Icons.back_hand_outlined;
      case 'back':
        return Icons.airline_seat_recline_normal_outlined;
      case 'hips':
        return Icons.directions_walk_outlined;
      case 'legs':
        return Icons.directions_run_outlined;
      case 'vision':
        return Icons.remove_red_eye_outlined;
      case 'breathing':
        return Icons.air_outlined;
      default:
        return Icons.fitness_center_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final p = context.palette;
    final categories = LocalDataRepository.instance.exerciseCategories;

    final blockColors = [
      (p.blockMint, p.blockMintText),
      (p.blockLilac, p.blockLilacText),
      (p.blockCoral, p.blockCoralText),
      (p.blockLime, p.blockLimeText),
      (p.blockPink, p.blockPinkText),
      (p.blockCream, p.blockCreamText),
    ];

    return FeatureScaffold(
      title: l10n.moduleExercises,
      categoryEyebrow: l10n.isKichwa ? 'Kuyuykuna' : 'Cuerpo',
      body: GridView.builder(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screen,
          vertical: AppSpacing.md,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: AppSpacing.xs,
          crossAxisSpacing: AppSpacing.xs,
          childAspectRatio: 1.1,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final count = LocalDataRepository.instance
              .exercisesByCategory(category.id)
              .length;
          final (bg, fg) = blockColors[index % blockColors.length];
          return _CategoryTile(
            category: category,
            count: count,
            isKichwa: l10n.isKichwa,
            icon: _iconForCategory(category.iconName),
            bg: bg,
            fg: fg,
          );
        },
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.category,
    required this.count,
    required this.isKichwa,
    required this.icon,
    required this.bg,
    required this.fg,
  });

  final ExerciseCategory category;
  final int count;
  final bool isKichwa;
  final IconData icon;
  final Color bg;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ExerciseListScreen(category: category),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: fg, size: 28),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.name(isKichwa),
                  style: AppTypography.body(context.palette, color: fg)
                      .copyWith(fontWeight: FontWeight.w700),
                ),
                Text(
                  '$count ejercicios',
                  style: AppTypography.micro(
                    context.palette,
                    color: fg.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ExerciseListScreen extends StatelessWidget {
  const ExerciseListScreen({super.key, required this.category});

  final ExerciseCategory category;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final p = context.palette;
    final exercises = LocalDataRepository.instance.exercisesByCategory(category.id);

    return Scaffold(
      backgroundColor: p.canvas,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screen,
                AppSpacing.md,
                AppSpacing.screen,
                AppSpacing.lg,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: p.hairline),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: p.ink,
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Text(
                    category.name(l10n.isKichwa),
                    style: AppTypography.displayMd(p),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screen,
                  vertical: AppSpacing.xs,
                ),
                itemCount: exercises.length,
                separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xs),
                itemBuilder: (context, index) {
                  final exercise = exercises[index];
                  return _ExerciseCard(
                    exercise: exercise,
                    isKichwa: l10n.isKichwa,
                    p: p,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExerciseCard extends StatelessWidget {
  const _ExerciseCard({
    required this.exercise,
    required this.isKichwa,
    required this.p,
  });

  final Exercise exercise;
  final bool isKichwa;
  final AppPalette p;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: p.surface2,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: p.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            exercise.name(isKichwa),
            style: AppTypography.body(p).copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            exercise.description(isKichwa),
            style: AppTypography.bodySm(p),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xxs,
                ),
                decoration: BoxDecoration(
                  color: p.hairline,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                ),
                child: Text(
                  '${exercise.durationSeconds}s',
                  style: AppTypography.micro(p),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ExerciseSessionScreen(exercise: exercise),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: p.ink,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                  ),
                  child: Text(
                    'Iniciar →',
                    style: AppTypography.button(p, color: p.primaryBtnFg)
                        .copyWith(fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

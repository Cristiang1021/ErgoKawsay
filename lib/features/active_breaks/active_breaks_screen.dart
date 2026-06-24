import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/localization/tr.dart';
import '../../core/theme/app_theme.dart';
import '../../data/local/local_data_repository.dart';
import '../../data/models/active_break_step.dart';
import '../../data/models/exercise.dart';
import '../../features/language/splash_screen.dart';
import '../exercises/exercise_session_screen.dart';
import '../../shared/widgets/feature_scaffold.dart';

// ── Distribución: Secuencia vertical con stepper ─────────────────────────────
// Ver todos los pasos a la vez en una línea de tiempo numerada.
// Cada paso tiene botón de inicio inline — no hay que navegar para comenzar.
// Diferente a story cards: scroll vertical, visión global del programa.

class ActiveBreaksScreen extends StatelessWidget {
  const ActiveBreaksScreen({super.key});

  Exercise _exerciseFromStep(ActiveBreakStep step) {
    return Exercise(
      id: step.id,
      categoryId: 'active_break',
      nameEs: step.nameEs,
      nameQu: step.nameQu,
      descriptionEs: step.descriptionEs,
      descriptionQu: step.descriptionQu,
      durationSeconds: step.durationSeconds,
      videoUrl: LocalDataRepository.instance.exercises.first.videoUrl,
      imageUrl: LocalDataRepository.instance.exercises.first.imageUrl,
      stepsEs: [step.descriptionEs],
      stepsQu: [step.descriptionQu],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final p = context.palette;
    final isKichwa = l10n.isKichwa;
    final repo = LocalDataRepository.instance;
    final steps = repo.activeBreakSteps;

    final stepColors = <Color>[
      p.blockCream,
      p.blockLilac,
      p.blockLime,
      p.blockCoral,
      p.blockPink,
    ];
    final stepTextColors = <Color>[
      p.blockCreamText,
      p.blockLilacText,
      p.blockLimeText,
      p.blockCoralText,
      p.blockPinkText,
    ];

    return FeatureScaffold(
      title: l10n.moduleActiveBreaks,
      categoryEyebrow: Tr.vocabularyBody(isKichwa),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screen,
          vertical: AppSpacing.md,
        ),
        children: [
          // ── Tarjeta intro ────────────────────────────────────────────────
          _IntroCard(p: p, isKichwa: isKichwa, repo: repo),
          const SizedBox(height: AppSpacing.lg),

          // ── Encabezado de secuencia ──────────────────────────────────────
          Row(
            children: [
              Text(
                Tr.activeBreaksSequenceHeader(isKichwa).toUpperCase(),
                style: AppTypography.eyebrow(p),
              ),
              const SizedBox(width: AppSpacing.xs),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xs,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: p.blockLime,
                  borderRadius:
                      BorderRadius.circular(AppSpacing.radiusFull),
                ),
                child: Text(
                  '${steps.length} ${Tr.activeBreaksSteps(isKichwa)}',
                  style: AppTypography.micro(p, color: p.blockLimeText),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),

          // ── Línea de tiempo ──────────────────────────────────────────────
          ...List.generate(steps.length, (i) {
            final step = steps[i];
            final color = stepColors[i % stepColors.length];
            final fg = stepTextColors[i % stepTextColors.length];
            final isLast = i == steps.length - 1;

            return _StepperItem(
              step: step,
              index: i,
              totalSteps: steps.length,
              color: color,
              fg: fg,
              isLast: isLast,
              isKichwa: isKichwa,
              p: p,
              exercise: _exerciseFromStep(step),
            );
          }),

          // ── Cierre motivacional ──────────────────────────────────────────
          const SizedBox(height: AppSpacing.xs),
          _ClosingCard(p: p, isKichwa: isKichwa),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}

// ── Intro card ───────────────────────────────────────────────────────────────

class _IntroCard extends StatelessWidget {
  const _IntroCard({
    required this.p,
    required this.isKichwa,
    required this.repo,
  });

  final AppPalette p;
  final bool isKichwa;
  final LocalDataRepository repo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: p.blockMint,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: p.blockMintText.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.self_improvement_rounded,
              color: p.blockMintText,
              size: 26,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Tr.activeBreaksWhatIsTitle(isKichwa),
                  style: AppTypography.cardTitle(p, color: p.blockMintText),
                ),
                const SizedBox(height: 4),
                Text(
                  repo.activeBreaksIntro(isKichwa),
                  style: AppTypography.bodySm(p, color: p.blockMintText.withValues(alpha: 0.8)),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  repo.activeBreaksFrequency(isKichwa),
                  style: AppTypography.caption(
                    p,
                    color: p.blockMintText.withValues(alpha: 0.85),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xxs,
                  ),
                  decoration: BoxDecoration(
                    color: p.blockMintText.withValues(alpha: 0.15),
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusPill),
                  ),
                  child: Text(
                    Tr.activeBreaksSequenceTitle(isKichwa),
                    style: AppTypography.caption(
                        p, color: p.blockMintText),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Stepper item (un paso de la secuencia) ────────────────────────────────────

class _StepperItem extends StatelessWidget {
  const _StepperItem({
    required this.step,
    required this.index,
    required this.totalSteps,
    required this.color,
    required this.fg,
    required this.isLast,
    required this.isKichwa,
    required this.p,
    required this.exercise,
  });

  final ActiveBreakStep step;
  final int index;
  final int totalSteps;
  final Color color;
  final Color fg;
  final bool isLast;
  final bool isKichwa;
  final AppPalette p;
  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Indicador vertical (línea + círculo numerado) ─────────────
          SizedBox(
            width: 48,
            child: Column(
              children: [
                // Número del paso
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: AppTypography.body(p, color: fg)
                          .copyWith(fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
                // Línea conectora (solo si no es el último)
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: p.hairline,
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusFull),
                      ),
                    ),
                  ),
                if (!isLast) const SizedBox(height: AppSpacing.xs),
              ],
            ),
          ),

          const SizedBox(width: AppSpacing.md),

          // ── Contenido del paso ────────────────────────────────────────
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: isLast ? 0 : AppSpacing.md,
              ),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius:
                      BorderRadius.circular(AppSpacing.radiusLg),
                  border: Border.all(
                    color: color.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nombre + duración
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            step.name(isKichwa),
                            style: AppTypography.body(p)
                                .copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.xs,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: fg.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(
                                AppSpacing.radiusFull),
                          ),
                          child: Text(
                            '${step.durationSeconds}s',
                            style: AppTypography.caption(p, color: fg),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Descripción
                    Text(
                      step.description(isKichwa),
                      style: AppTypography.bodySm(p,
                          color: p.ink.withValues(alpha: 0.7)),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    // Botón iniciar
                    Builder(
                      builder: (ctx) => GestureDetector(
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          Navigator.push(
                            ctx,
                            MaterialPageRoute(
                              builder: (_) => ExerciseSessionScreen(
                                exercise: exercise,
                                onSessionComplete: () =>
                                    StorageServiceScope.of(ctx)
                                        .recordActiveBreakCompleted(),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(
                                AppSpacing.radiusPill),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.play_arrow_rounded,
                                  color: fg, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                Tr.pick(isKichwa, 'Iniciar', 'Kallariy'),
                                style: AppTypography.caption(p,
                                    color: fg).copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Cierre motivacional ───────────────────────────────────────────────────────

class _ClosingCard extends StatelessWidget {
  const _ClosingCard({required this.p, required this.isKichwa});

  final AppPalette p;
  final bool isKichwa;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: p.blockNavy,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: p.blockNavyText.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.repeat_rounded, color: p.blockNavyText, size: 22),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Tr.activeBreaksRepeat(isKichwa),
                  style: AppTypography.body(p, color: p.blockNavyText)
                      .copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  isKichwa
                      ? 'Ama nanaymantas suyakunki.'
                      : 'No esperes a sentir dolor para hacer la pausa.',
                  style: AppTypography.bodySm(
                      p, color: p.blockNavyText.withValues(alpha: 0.7)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

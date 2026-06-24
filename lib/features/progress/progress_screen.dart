import 'package:flutter/material.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_theme.dart';
import '../../data/local/local_data_repository.dart';
import '../../data/models/progress_data.dart';
import '../../features/language/splash_screen.dart';
import '../../shared/widgets/feature_scaffold.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key, this.embedded = false});

  final bool embedded;

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  ProgressData? _progress;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  void _loadProgress() {
    setState(() {
      _progress = StorageServiceScope.of(context).getProgress();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final p = context.palette;
    final progress = _progress ?? ProgressData.empty();
    final emotions = LocalDataRepository.instance.emotions;
    final body = RefreshIndicator(
      onRefresh: () async => _loadProgress(),
      child: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screen,
          vertical: AppSpacing.lg,
        ),
        children: [
          // Stat blocks
          _buildStatBlock(
            context,
            p,
            value: '${progress.exercisesCompleted}',
            label: l10n.exercisesCompleted,
            bg: p.blockLilac,
            fg: p.blockLilacText,
            icon: Icons.fitness_center_rounded,
          ),
          const SizedBox(height: AppSpacing.xs),
          _buildStatBlock(
            context,
            p,
            value: '${progress.activeBreaksCompleted}',
            label: l10n.breaksCompleted,
            bg: p.blockMint,
            fg: p.blockMintText,
            icon: Icons.self_improvement_rounded,
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Expanded(
                child: _buildStatBlockSmall(
                  p,
                  value: '${progress.totalEmotionsRecorded}',
                  label: l10n.emotionsRecorded,
                  bg: p.blockPink,
                  fg: p.blockPinkText,
                  icon: Icons.favorite_border_rounded,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: _buildStatBlockSmall(
                  p,
                  value: '${progress.usageDays.length}',
                  label: l10n.usageDays,
                  bg: p.blockCream,
                  fg: p.blockCreamText,
                  icon: Icons.calendar_today_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          // Emotion history
          Text(
            l10n.emotionsRecorded.toUpperCase(),
            style: AppTypography.eyebrow(p),
          ),
          const SizedBox(height: AppSpacing.md),
          if (progress.emotionsRecorded.isEmpty)
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: p.surface2,
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                border: Border.all(color: p.hairline),
              ),
              child: Text(l10n.noData, style: AppTypography.bodySm(p)),
            )
          else
            ...progress.emotionsRecorded.entries.map((entry) {
              final emotion = emotions.firstWhere(
                (e) => e.id == entry.key,
                orElse: () => emotions.first,
              );
              return _buildEmotionRow(p, l10n.isKichwa, emotion, entry.value);
            }),
        ],
      ),
    );

    if (widget.embedded) {
      return Scaffold(
        backgroundColor: p.canvas,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.screen,
                  AppSpacing.lg,
                  AppSpacing.screen,
                  AppSpacing.lg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PROGRESO'.toUpperCase(),
                      style: AppTypography.eyebrow(p),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(l10n.progress, style: AppTypography.displayMd(p)),
                  ],
                ),
              ),
              Expanded(child: body),
            ],
          ),
        ),
      );
    }

    return FeatureScaffold(
      title: l10n.moduleProgress,
      body: body,
    );
  }

  Widget _buildStatBlock(
    BuildContext context,
    AppPalette p, {
    required String value,
    required String label,
    required Color bg,
    required Color fg,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Row(
        children: [
          Icon(icon, color: fg, size: 28),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: AppTypography.displayMd(p, color: fg),
                ),
                Text(
                  label,
                  style: AppTypography.bodySm(p, color: fg.withValues(alpha: 0.75)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBlockSmall(
    AppPalette p, {
    required String value,
    required String label,
    required Color bg,
    required Color fg,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: fg, size: 24),
          const SizedBox(height: AppSpacing.sm),
          Text(value, style: AppTypography.displayMd(p, color: fg)),
          Text(
            label,
            style: AppTypography.micro(p, color: fg.withValues(alpha: 0.75)),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildEmotionRow(
    AppPalette p,
    bool isKichwa,
    dynamic emotion,
    int count,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.xs),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: p.surface2,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: p.hairline),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              emotion.name(isKichwa),
              style: AppTypography.body(p),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xxs,
            ),
            decoration: BoxDecoration(
              color: p.ink,
              borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
            ),
            child: Text(
              '$count',
              style: AppTypography.caption(p, color: p.primaryBtnFg),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/localization/tr.dart';
import '../../core/theme/app_theme.dart';

class WellbeingScreen extends StatelessWidget {
  const WellbeingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final p = context.palette;
    final isKichwa = l10n.isKichwa;
    final top = MediaQuery.paddingOf(context).top;

    return CustomScrollView(
      physics: const ClampingScrollPhysics(),
      slivers: [
        // ── Header ──────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.screen,
              top + AppSpacing.md,
              AppSpacing.screen,
              0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Tr.wellbeingResources(isKichwa).toUpperCase(),
                  style: AppTypography.eyebrow(p),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  isKichwa ? l10n.appSubtitle : 'Bienestar',
                  style: AppTypography.displayLg(p),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  Tr.wellbeingSubtitle(isKichwa),
                  style: AppTypography.bodySm(p),
                ),
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ),

        // ── CUERPO ──────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: _WellSection(
            eyebrow: isKichwa ? Tr.modulesErgonomicsQu.toUpperCase() : 'CUERPO',
            p: p,
            child: _GridCards(
              p: p,
              items: [
                _WellItem(
                  label: isKichwa ? Tr.activeBreaksTitleQu : Tr.activeBreaksTitleEs,
                  sublabel: isKichwa ? Tr.activeBreaksSubtitleQu : '5 min de movimiento',
                  icon: Icons.self_improvement_rounded,
                  bg: p.blockMint,
                  fg: p.blockMintText,
                  route: '/active-breaks',
                ),
                _WellItem(
                  label: isKichwa ? Tr.exercisesTitleQu : Tr.exercisesTitleEs,
                  sublabel: Tr.wellbeingStretches(isKichwa),
                  icon: Icons.fitness_center_rounded,
                  bg: p.blockLime,
                  fg: p.blockLimeText,
                  route: '/exercises',
                ),
                _WellItem(
                  label: isKichwa ? Tr.modulesErgonomicsQu : Tr.modulesErgonomicsEs,
                  sublabel: isKichwa ? Tr.ergonomicsPrinciplesTitleQu : Tr.ergonomicsPrinciplesTitleEs,
                  icon: Icons.chair_alt_rounded,
                  bg: p.blockCream,
                  fg: p.blockCreamText,
                  route: '/ergonomics',
                ),
                _WellItem(
                  label: isKichwa ? Tr.diseasesTitleQu : Tr.diseasesTitleEs,
                  sublabel: isKichwa ? Tr.diseasesMusculoskeletalTitleQu : Tr.diseasesMusculoskeletalTitleEs,
                  icon: Icons.medical_information_outlined,
                  bg: p.blockCoral,
                  fg: p.blockCoralText,
                  route: '/diseases',
                ),
              ],
            ),
          ),
        ),

        // ── MENTE ────────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: _WellSection(
            eyebrow: isKichwa ? Tr.mentalHealthTitleQu : 'MENTE',
            p: p,
            child: _DuoCards(
              p: p,
              left: _WellItem(
                label: isKichwa ? Tr.mentalHealthTitleQu : 'Emociones',
                sublabel: isKichwa ? Tr.mentalHealthRecognizeCareTitleQu : Tr.mentalHealthRecognizeCareTitleEs,
                icon: Icons.favorite_border_rounded,
                bg: p.blockPink,
                fg: p.blockPinkText,
                route: '/emotions',
              ),
              right: _WellItem(
                label: isKichwa ? Tr.mediaMusicTitleQu : Tr.mediaMusicTitleEs,
                sublabel: Tr.wellbeingRelaxingSounds(isKichwa),
                icon: Icons.music_note_rounded,
                bg: p.blockLilac,
                fg: p.blockLilacText,
                route: '/music',
              ),
            ),
          ),
        ),

        // ── APRENDIZAJE ──────────────────────────────────────────────
        SliverToBoxAdapter(
          child: _WellSection(
            eyebrow: isKichwa ? Tr.vocabularyLearningQu.toUpperCase() : Tr.vocabularyLearningEs.toUpperCase(),
            p: p,
            child: _FeatureCard(
              p: p,
              item: _WellItem(
                label: isKichwa ? Tr.mediaVideosTitleQu : Tr.mediaVideosTitleEs,
                sublabel: isKichwa ? Tr.vocabularyLearningQu : Tr.vocabularyLearningEs,
                icon: Icons.play_circle_outline_rounded,
                bg: p.blockNavy,
                fg: p.blockNavyText,
                route: '/videos',
              ),
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),
      ],
    );
  }
}

// ── Section wrapper ───────────────────────────────────────────────────────────

class _WellSection extends StatelessWidget {
  const _WellSection({
    required this.eyebrow,
    required this.p,
    required this.child,
  });

  final String eyebrow;
  final AppPalette p;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen, 0, AppSpacing.screen, AppSpacing.xl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(eyebrow, style: AppTypography.eyebrow(p)),
          const SizedBox(height: AppSpacing.md),
          child,
        ],
      ),
    );
  }
}

// ── 2×2 grid (CUERPO) ────────────────────────────────────────────────────────

class _GridCards extends StatelessWidget {
  const _GridCards({required this.p, required this.items});

  final AppPalette p;
  final List<_WellItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _Card(item: items[0], height: 150)),
            const SizedBox(width: AppSpacing.xs),
            Expanded(child: _Card(item: items[1], height: 150)),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            Expanded(child: _Card(item: items[2], height: 150)),
            const SizedBox(width: AppSpacing.xs),
            Expanded(child: _Card(item: items[3], height: 150)),
          ],
        ),
      ],
    );
  }
}

// ── Side-by-side pair (MENTE) ─────────────────────────────────────────────────

class _DuoCards extends StatelessWidget {
  const _DuoCards({required this.p, required this.left, required this.right});

  final AppPalette p;
  final _WellItem left;
  final _WellItem right;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _Card(item: left, height: 160)),
        const SizedBox(width: AppSpacing.xs),
        Expanded(child: _Card(item: right, height: 160)),
      ],
    );
  }
}

// ── Full-width feature card (APRENDIZAJE) ─────────────────────────────────────

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({required this.p, required this.item});

  final AppPalette p;
  final _WellItem item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        Navigator.pushNamed(context, item.route);
      },
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: item.bg,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
        child: Row(
          children: [
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.label,
                    style: AppTypography.cardTitle(p, color: item.fg),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    item.sublabel,
                    style: AppTypography.bodySm(
                        p, color: item.fg.withValues(alpha: 0.68)),
                    maxLines: 2,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.xxs + 2,
                    ),
                    decoration: BoxDecoration(
                      color: item.fg.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                    ),
                    child: Builder(
                      builder: (ctx) {
                        final isK = AppLocalizations.of(ctx).isKichwa;
                        return Text(
                          '${Tr.wellbeingWatchVideos(isK)} →',
                          style: AppTypography.bodySm(p, color: item.fg)
                              .copyWith(fontWeight: FontWeight.w600),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            // Icon
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: item.fg.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(item.icon, color: item.fg, size: 30),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Standard card ─────────────────────────────────────────────────────────────

class _Card extends StatelessWidget {
  const _Card({required this.item, required this.height});

  final _WellItem item;
  final double height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        Navigator.pushNamed(context, item.route);
      },
      child: Container(
        height: height,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: item.bg,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Icon circle
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: item.fg.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(item.icon, color: item.fg, size: 20),
            ),
            // Labels
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: item.fg,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  item.sublabel,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: item.fg.withValues(alpha: 0.65),
                    height: 1.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Data model ────────────────────────────────────────────────────────────────

class _WellItem {
  const _WellItem({
    required this.label,
    required this.sublabel,
    required this.icon,
    required this.bg,
    required this.fg,
    required this.route,
  });

  final String label;
  final String sublabel;
  final IconData icon;
  final Color bg;
  final Color fg;
  final String route;
}

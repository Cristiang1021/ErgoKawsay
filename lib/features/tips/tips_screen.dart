import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_theme.dart';
import '../../data/local/local_data_repository.dart';
import '../../data/models/tip.dart';
import '../../shared/widgets/feature_scaffold.dart';
import '../../shared/widgets/smart_bullet_list.dart';

class TipsScreen extends StatelessWidget {
  const TipsScreen({super.key});

  static IconData _iconForTip(String iconName) {
    switch (iconName) {
      case 'chair':
        return Icons.chair_alt_outlined;
      case 'blackboard':
        return Icons.draw_outlined;
      case 'laptop':
        return Icons.laptop_outlined;
      case 'tasks':
        return Icons.checklist_rounded;
      case 'posture':
        return Icons.accessibility_new_outlined;
      case 'shoes':
        return Icons.hiking_outlined;
      default:
        return Icons.lightbulb_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final p = context.palette;
    final isKichwa = l10n.isKichwa;
    final tips = LocalDataRepository.instance.tips;

    if (tips.isEmpty) {
      return FeatureScaffold(
        title: l10n.moduleTips,
        categoryEyebrow: isKichwa ? 'Kunaykuna' : 'Bienestar',
        body: Center(child: Text('—', style: AppTypography.body(p))),
      );
    }

    final colors = <(Color, Color)>[
      (p.blockNavy, p.blockNavyText),
      (p.blockLime, p.blockLimeText),
      (p.blockCream, p.blockCreamText),
      (p.blockMint, p.blockMintText),
      (p.blockLilac, p.blockLilacText),
      (p.blockPink, p.blockPinkText),
    ];

    // Featured tip rotates daily
    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year)).inDays;
    final featuredIdx = dayOfYear % tips.length;
    final featured = tips[featuredIdx];
    final (featuredBg, featuredFg) = colors[featuredIdx % colors.length];

    // Remaining tips (all except featured), preserving original order
    final rest = [
      for (int i = 0; i < tips.length; i++)
        if (i != featuredIdx) (tips[i], colors[i % colors.length]),
    ];

    final bool hasRemainder = rest.length.isOdd;
    final int pairCount = hasRemainder ? rest.length - 1 : rest.length;

    return FeatureScaffold(
      title: l10n.moduleTips,
      categoryEyebrow: isKichwa ? 'Kunaykuna' : 'Bienestar',
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screen,
          AppSpacing.sm,
          AppSpacing.screen,
          AppSpacing.xl + MediaQuery.paddingOf(context).bottom,
        ),
        children: [
          // ── Consejo destacado ──────────────────────────────────────────
          _FeaturedCard(
            tip: featured,
            isKichwa: isKichwa,
            p: p,
            bg: featuredBg,
            fg: featuredFg,
            icon: _iconForTip(featured.iconName),
          ),

          const SizedBox(height: AppSpacing.lg),

          // ── Etiqueta "Más consejos" ────────────────────────────────────
          Text(
            (isKichwa ? 'SHUKTAK KUNAYKUNA' : 'MÁS CONSEJOS'),
            style: AppTypography.eyebrow(p),
          ),

          const SizedBox(height: AppSpacing.sm),

          // ── Cuadrícula 2×2 ────────────────────────────────────────────
          for (int i = 0; i < pairCount; i += 2) ...[
            if (i > 0) const SizedBox(height: AppSpacing.xs),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: _GridCard(
                      tip: rest[i].$1,
                      isKichwa: isKichwa,
                      p: p,
                      bg: rest[i].$2.$1,
                      fg: rest[i].$2.$2,
                      icon: _iconForTip(rest[i].$1.iconName),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: _GridCard(
                      tip: rest[i + 1].$1,
                      isKichwa: isKichwa,
                      p: p,
                      bg: rest[i + 1].$2.$1,
                      fg: rest[i + 1].$2.$2,
                      icon: _iconForTip(rest[i + 1].$1.iconName),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // ── Tarjeta impar (full-width) ─────────────────────────────────
          if (hasRemainder) ...[
            const SizedBox(height: AppSpacing.xs),
            _GridCard(
              tip: rest.last.$1,
              isKichwa: isKichwa,
              p: p,
              bg: rest.last.$2.$1,
              fg: rest.last.$2.$2,
              icon: _iconForTip(rest.last.$1.iconName),
              fullWidth: true,
            ),
          ],
        ],
      ),
    );
  }
}

// ── Consejo destacado ─────────────────────────────────────────────────────────

class _FeaturedCard extends StatelessWidget {
  const _FeaturedCard({
    required this.tip,
    required this.isKichwa,
    required this.p,
    required this.bg,
    required this.fg,
    required this.icon,
  });

  final Tip tip;
  final bool isKichwa;
  final AppPalette p;
  final Color bg;
  final Color fg;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        showModalBottomSheet<void>(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (_) => _TipDetailSheet(
            tip: tip,
            isKichwa: isKichwa,
            p: p,
            bg: bg,
            fg: fg,
            icon: icon,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: fg.withValues(alpha: 0.18),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: fg, size: 22),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              (isKichwa ? 'SUMAK KUNAY' : 'CONSEJO DESTACADO'),
              style: AppTypography.eyebrow(p, color: fg.withValues(alpha: 0.6)),
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              tip.title(isKichwa),
              style: AppTypography.headline(p, color: fg),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              tip.content(isKichwa).split('\n').first,
              style: AppTypography.body(p, color: fg.withValues(alpha: 0.78)),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Tarjeta de cuadrícula ─────────────────────────────────────────────────────

class _GridCard extends StatelessWidget {
  const _GridCard({
    required this.tip,
    required this.isKichwa,
    required this.p,
    required this.bg,
    required this.fg,
    required this.icon,
    this.fullWidth = false,
  });

  final Tip tip;
  final bool isKichwa;
  final AppPalette p;
  final Color bg;
  final Color fg;
  final IconData icon;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        showModalBottomSheet<void>(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (_) => _TipDetailSheet(
            tip: tip,
            isKichwa: isKichwa,
            p: p,
            bg: bg,
            fg: fg,
            icon: icon,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
        child: fullWidth
            ? Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: fg.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: fg, size: 18),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tip.title(isKichwa),
                          style: AppTypography.body(p, color: fg)
                              .copyWith(fontWeight: FontWeight.w700),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: AppSpacing.xxs),
                        Text(
                          isKichwa ? 'Ashtawan rikuy ›' : 'Ver más ›',
                          style: AppTypography.bodySm(
                              p, color: fg.withValues(alpha: 0.55)),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: fg.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: fg, size: 18),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    tip.title(isKichwa),
                    style: AppTypography.body(p, color: fg)
                        .copyWith(fontWeight: FontWeight.w700),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    isKichwa ? 'Ashtawan rikuy ›' : 'Ver más ›',
                    style: AppTypography.bodySm(
                        p, color: fg.withValues(alpha: 0.55)),
                  ),
                ],
              ),
      ),
    );
  }
}

// ── Hoja de detalle ───────────────────────────────────────────────────────────

class _TipDetailSheet extends StatelessWidget {
  const _TipDetailSheet({
    required this.tip,
    required this.isKichwa,
    required this.p,
    required this.bg,
    required this.fg,
    required this.icon,
  });

  final Tip tip;
  final bool isKichwa;
  final AppPalette p;
  final Color bg;
  final Color fg;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screen,
        AppSpacing.lg,
        AppSpacing.screen,
        AppSpacing.xxl + MediaQuery.paddingOf(context).bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: fg.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: fg.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: fg, size: 26),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(tip.title(isKichwa),
                style: AppTypography.headline(p, color: fg)),
            const SizedBox(height: AppSpacing.sm),
            SmartBulletList(
              text: tip.content(isKichwa),
              p: p,
              fg: fg.withValues(alpha: 0.85),
            ),
            const SizedBox(height: AppSpacing.lg),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: fg.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                ),
                child: Center(
                  child: Text(
                    isKichwa ? 'Wichkayana' : 'Cerrar',
                    style: AppTypography.button(p, color: fg),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


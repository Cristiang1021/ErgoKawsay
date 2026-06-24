import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/constants/app_assets.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_theme.dart';
import '../../data/local/local_data_repository.dart';
import '../../data/local/quiz_data.dart';
import '../../shared/widgets/feature_scaffold.dart';
import '../../shared/widgets/story_deck.dart';
import '../quiz/quiz_screen.dart';

class ErgonomicsScreen extends StatelessWidget {
  const ErgonomicsScreen({super.key});

  // Visuals per slide index — images replace icons
  static Widget _visual(int i, Color fg) {
    switch (i) {
      case 0:
        return Image.asset(AppAssets.ergonomiaDocente,
            fit: BoxFit.contain);
      case 1:
        return Image.asset(AppAssets.posturaUsandoTablet,
            fit: BoxFit.contain);
      case 2:
        return Image.asset(AppAssets.posturaEnLaPizarra,
            fit: BoxFit.contain);
      case 3:
        return Image.asset(AppAssets.posturaZonasAfectadas,
            fit: BoxFit.contain);
      case 4:
        return Image.asset(AppAssets.posturaUsandoComputadora,
            fit: BoxFit.contain);
      case 5:
        return Image.asset(AppAssets.posturaDePie,
            fit: BoxFit.contain);
      default:
        return StoryIconVisual(icon: Icons.public_rounded, fg: fg);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final p = context.palette;
    final sections = LocalDataRepository.instance.ergonomicsSections(l10n.isKichwa);

    final colors = <(Color, Color)>[
      (p.blockCream, p.blockCreamText),
      (p.blockMint, p.blockMintText),
      (p.blockCoral, p.blockCoralText),
      (p.blockLilac, p.blockLilacText),
      (p.blockLime, p.blockLimeText),
      (p.blockNavy, p.blockNavyText),
    ];

    final isLast = sections.length - 1;
    final slides = List.generate(sections.length, (i) {
      final section = sections[i];
      final (bg, fg) = colors[i % colors.length];
      final content = section['content'] ?? '';
      // Slides 2 (causas físicas) and 4 (puesto de corrección) use 2×2 grid
      // Slide 3 (zonas afectadas) uses zone chips
      final useGrid = i == 2 || i == 4;
      final useChips = i == 3;
      return StorySlide(
        bg: bg,
        fg: fg,
        visual: _visual(i, fg),
        eyebrow: l10n.isKichwa ? 'Allillamkayachay' : 'Ergonomía',
        title: section['title'] ?? '',
        body: (useGrid || useChips) ? null : content,
        bodyWidget: useGrid
            ? _ContentGrid(content: content, fg: fg)
            : useChips
                ? _ZoneChips(content: content, fg: fg)
                : null,
        compact: false,
        action: i == isLast
            ? GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const QuizScreen(quiz: ergonomicsQuiz),
                    ),
                  );
                },
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: fg.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                    border: Border.all(color: fg.withValues(alpha: 0.45)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.quiz_outlined, color: fg, size: 18),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        'Pon a prueba lo que aprendiste',
                        style: TextStyle(
                          color: fg,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : null,
      );
    });

    return FeatureScaffold(
      title: l10n.moduleErgonomics,
      categoryEyebrow: l10n.isKichwa ? 'Allillamkayachay' : 'Cuerpo',
      body: StoryDeck(slides: slides),
    );
  }
}

// ── Chips de zonas afectadas ─────────────────────────────────────────────────

class _ZoneChips extends StatelessWidget {
  const _ZoneChips({required this.content, required this.fg});

  final String content;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    final zones = content
        .split('·')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: zones
          .map((zone) => Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: fg.withValues(alpha: 0.13),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                  border: Border.all(color: fg.withValues(alpha: 0.28)),
                ),
                child: Text(
                  zone,
                  style: TextStyle(
                    color: fg,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.1,
                  ),
                ),
              ))
          .toList(),
    );
  }
}

// ── Grid 2×2 para contenido con múltiples ítems ──────────────────────────────

class _ContentGrid extends StatelessWidget {
  const _ContentGrid({required this.content, required this.fg});

  final String content;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final paragraphs = content
        .split('\n\n')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    // First paragraph without ":" is treated as intro text
    String? intro;
    var items = paragraphs;
    if (paragraphs.isNotEmpty && !paragraphs[0].contains(':')) {
      intro = paragraphs[0];
      items = paragraphs.sublist(1);
    }

    final rows = (items.length / 2).ceil();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (intro != null) ...[
          Text(
            intro,
            style: AppTypography.bodySm(p, color: fg.withValues(alpha: 0.75)),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        for (int row = 0; row < rows; row++) ...[
          if (row > 0) const SizedBox(height: AppSpacing.xs),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _ContentCell(text: items[row * 2], fg: fg, p: p),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: row * 2 + 1 < items.length
                    ? _ContentCell(text: items[row * 2 + 1], fg: fg, p: p)
                    : const SizedBox(),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _ContentCell extends StatelessWidget {
  const _ContentCell({
    required this.text,
    required this.fg,
    required this.p,
  });

  final String text;
  final Color fg;
  final AppPalette p;

  @override
  Widget build(BuildContext context) {
    final colonIdx = text.indexOf(':');
    final label = colonIdx > 0 ? text.substring(0, colonIdx).trim() : '';
    final desc = colonIdx > 0 ? text.substring(colonIdx + 1).trim() : text;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: fg.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label.isNotEmpty) ...[
            Text(
              label,
              style: AppTypography.caption(p, color: fg)
                  .copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 3),
          ],
          Text(
            desc,
            style: AppTypography.micro(p, color: fg.withValues(alpha: 0.82)),
          ),
        ],
      ),
    );
  }
}

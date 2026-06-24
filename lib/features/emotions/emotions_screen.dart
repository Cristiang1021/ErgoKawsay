import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/localization/tr.dart';
import '../../core/theme/app_theme.dart';
import '../../data/local/local_data_repository.dart';
import '../../data/models/emotion.dart';
import '../../features/language/splash_screen.dart';
import '../../shared/widgets/feature_scaffold.dart';

class EmotionsScreen extends StatelessWidget {
  const EmotionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final emotions = LocalDataRepository.instance.emotions;
    final p = context.palette;

    final blockColors = [
      (p.blockCoral, p.blockCoralText),
      (p.blockLilac, p.blockLilacText),
      (p.blockLime, p.blockLimeText),
      (p.blockPink, p.blockPinkText),
      (p.blockMint, p.blockMintText),
    ];

    final isKichwa = l10n.isKichwa;

    return FeatureScaffold(
      title: l10n.moduleEmotions,
      categoryEyebrow: isKichwa ? 'Ñuktu alli kay' : 'Salud Mental',
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screen,
          vertical: AppSpacing.md,
        ),
        itemCount: emotions.length + 1,
        separatorBuilder: (_, i) =>
            i == 0 ? const SizedBox(height: AppSpacing.lg) : const SizedBox(height: AppSpacing.sm),
        itemBuilder: (context, index) {
          if (index == 0) {
            return _EmotionsHeader(isKichwa: isKichwa, p: p);
          }
          final emotion = emotions[index - 1];
          final (bg, fg) = blockColors[(index - 1) % blockColors.length];
          return _EmotionCard(
            emotion: emotion,
            isKichwa: isKichwa,
            bg: bg,
            fg: fg,
          );
        },
      ),
    );
  }
}

class _EmotionsHeader extends StatelessWidget {
  const _EmotionsHeader({required this.isKichwa, required this.p});

  final bool isKichwa;
  final AppPalette p;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Tr.mentalHealthRecognizeCareTitle(isKichwa),
          style: AppTypography.headline(p),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          Tr.mentalHealthRecognizeCareDesc(isKichwa),
          style: AppTypography.bodySm(p, color: p.inkMuted),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          Tr.mentalHealthTapEmotion(isKichwa),
          style: AppTypography.body(p).copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _EmotionCard extends StatelessWidget {
  const _EmotionCard({
    required this.emotion,
    required this.isKichwa,
    required this.bg,
    required this.fg,
  });

  final Emotion emotion;
  final bool isKichwa;
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
            builder: (_) => EmotionDetailScreen(emotion: emotion),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    emotion.name(isKichwa),
                    style: AppTypography.cardTitle(context.palette, color: fg),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    emotion.whatIs(isKichwa),
                    style: AppTypography.bodySm(
                      context.palette,
                      color: fg.withValues(alpha: 0.75),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            SizedBox(
              width: 90,
              height: 110,
              child: emotion.imageAsset != null
                  ? Image.asset(emotion.imageAsset!, fit: BoxFit.contain)
                  : Icon(Icons.sentiment_neutral_rounded, size: 56, color: fg),
            ),
          ],
        ),
      ),
    );
  }
}

class EmotionDetailScreen extends StatefulWidget {
  const EmotionDetailScreen({super.key, required this.emotion});

  final Emotion emotion;

  @override
  State<EmotionDetailScreen> createState() => _EmotionDetailScreenState();
}

class _EmotionDetailScreenState extends State<EmotionDetailScreen> {
  bool _saved = false;

  Future<void> _saveEmotion() async {
    await StorageServiceScope.of(context).recordEmotion(widget.emotion.id);
    setState(() => _saved = true);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Emoción registrada')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isKichwa = l10n.isKichwa;
    final emotion = widget.emotion;
    final p = context.palette;

    return Scaffold(
      backgroundColor: p.canvas,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screen,
                  AppSpacing.md,
                  AppSpacing.screen,
                  0,
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
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screen,
                  AppSpacing.lg,
                  AppSpacing.screen,
                  AppSpacing.xl,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Hero card ────────────────────────────────────────
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: Color(emotion.colorHex).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  emotion.name(isKichwa),
                                  style: AppTypography.displayMd(p),
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                Text(
                                  emotion.whatIs(isKichwa),
                                  style: AppTypography.bodyLg(p),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          SizedBox(
                            width: 96,
                            height: 116,
                            child: emotion.imageAsset != null
                                ? Image.asset(emotion.imageAsset!,
                                    fit: BoxFit.contain)
                                : Icon(Icons.sentiment_neutral_rounded,
                                    size: 64,
                                    color: Color(emotion.colorHex)),
                          ),
                        ],
                      ),
                    ),

                    // ── Causas / señales / fuentes ───────────────────────
                    if (emotion.causes(isKichwa).isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.xl),
                      _SectionLabel(
                        title: emotion.causesTitle(isKichwa) ??
                            l10n.commonCauses,
                        p: p,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      _DotList(
                        content: emotion.causes(isKichwa),
                        dotColor: Color(emotion.colorHex),
                        p: p,
                      ),
                    ],

                    // ── Acciones / estrategias ────────────────────────────
                    if (emotion.actions(isKichwa).isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.xl),
                      _SectionLabel(
                        title: emotion.actionsTitle(isKichwa) ??
                            l10n.whatCanIDo,
                        p: p,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      _StepList(
                        content: emotion.actions(isKichwa),
                        accentColor: Color(emotion.colorHex),
                        p: p,
                      ),
                    ],

                    // ── Frase motivacional ────────────────────────────────
                    const SizedBox(height: AppSpacing.xl),
                    _AffirmationBlock(
                      phrase: emotion.phrase(isKichwa),
                      p: p,
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    // ── Botón guardar ─────────────────────────────────────
                    GestureDetector(
                      onTap: _saved ? null : _saveEmotion,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: _saved ? 0.5 : 1.0,
                        child: Container(
                          height: 56,
                          decoration: BoxDecoration(
                            color: _saved ? p.surface2 : p.ink,
                            borderRadius:
                                BorderRadius.circular(AppSpacing.radiusPill),
                            border:
                                _saved ? Border.all(color: p.hairline) : null,
                          ),
                          child: Center(
                            child: Text(
                              _saved ? '✓ Registrado' : l10n.save,
                              style: AppTypography.button(
                                p,
                                color: _saved ? p.inkMuted : p.primaryBtnFg,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Etiqueta de sección ───────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.title, required this.p});
  final String title;
  final AppPalette p;

  @override
  Widget build(BuildContext context) => Text(
        title.toUpperCase(),
        style: AppTypography.eyebrow(p),
      );
}

// ── Lista con puntos de color (causas / señales / fuentes) ───────────────────

class _DotList extends StatelessWidget {
  const _DotList({
    required this.content,
    required this.dotColor,
    required this.p,
  });
  final String content;
  final Color dotColor;
  final AppPalette p;

  @override
  Widget build(BuildContext context) {
    final lines = content
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();

    return Column(
      children: lines.map((line) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.xs),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5, right: AppSpacing.sm),
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Expanded(
                child: Text(line, style: AppTypography.body(p)),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// ── Pasos numerados (acciones / estrategias) ─────────────────────────────────

class _StepList extends StatelessWidget {
  const _StepList({
    required this.content,
    required this.accentColor,
    required this.p,
  });
  final String content;
  final Color accentColor;
  final AppPalette p;

  static const int _labelMaxLen = 35;

  @override
  Widget build(BuildContext context) {
    final lines = content
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();

    return Column(
      children: List.generate(lines.length, (i) {
        final line = lines[i];
        final colonIdx = line.indexOf(':');
        final hasLabel = colonIdx > 0 && colonIdx <= _labelMaxLen;

        String? label;
        String desc;
        if (hasLabel) {
          label = line.substring(0, colonIdx).trim();
          desc = line.substring(colonIdx + 1).trim();
        } else {
          desc = line;
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: Border.all(
                color: accentColor.withValues(alpha: 0.18),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Número de paso
                Container(
                  width: 28,
                  height: 28,
                  margin: const EdgeInsets.only(right: AppSpacing.sm, top: 1),
                  decoration: BoxDecoration(
                    color: accentColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${i + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                // Contenido
                Expanded(
                  child: label != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              label,
                              style: AppTypography.body(p).copyWith(
                                  fontWeight: FontWeight.w700),
                            ),
                            if (desc.isNotEmpty) ...[
                              const SizedBox(height: AppSpacing.xxs),
                              Text(
                                desc,
                                style: AppTypography.bodySm(p,
                                    color: p.inkMuted),
                              ),
                            ],
                          ],
                        )
                      : Text(desc, style: AppTypography.body(p)),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

// ── Frase motivacional ────────────────────────────────────────────────────────

class _AffirmationBlock extends StatelessWidget {
  const _AffirmationBlock({required this.phrase, required this.p});
  final String phrase;
  final AppPalette p;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: p.blockNavy,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '"',
            style: TextStyle(
              fontSize: 40,
              height: 0.8,
              color: p.blockNavyText.withValues(alpha: 0.35),
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            phrase,
            style: AppTypography.body(p, color: p.blockNavyText).copyWith(
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/localization/tr.dart';
import '../../core/theme/app_theme.dart';
import '../../data/local/local_data_repository.dart';
import '../../data/local/quiz_data.dart';
import '../../data/models/disease.dart';
import '../../shared/widgets/feature_scaffold.dart';
import '../quiz/quiz_screen.dart';

// ── Distribución: Acordeón expandible ────────────────────────────────────────
// Cada enfermedad se colapsa/expande con animación.
// Permite ver todas de un vistazo y entrar al detalle sin salir de la pantalla.

class DiseasesScreen extends StatelessWidget {
  const DiseasesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final p = context.palette;
    final isKichwa = l10n.isKichwa;
    final diseases = LocalDataRepository.instance.diseases;

    final colors = <(Color, Color)>[
      (p.blockPink, p.blockPinkText),
      (p.blockCoral, p.blockCoralText),
      (p.blockLilac, p.blockLilacText),
      (p.blockLime, p.blockLimeText),
    ];

    final icons = <IconData>[
      Icons.front_hand_outlined,
      Icons.sports_handball_outlined,
      Icons.airline_seat_recline_extra_rounded,
      Icons.personal_injury_outlined,
    ];

    return FeatureScaffold(
      title: l10n.moduleDiseases,
      categoryEyebrow: isKichwa ? Tr.diseasesTitleQu : 'Prevención',
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screen,
          vertical: AppSpacing.md,
        ),
        children: [
          // Subtítulo introductorio
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.lg),
            child: Text(
              isKichwa
                  ? 'Kutin kutin ruraykuna aychata tukuchin. Sapa unanchay yachay.'
                  : 'Trastornos más frecuentes en docentes. Toca cada tarjeta para conocerla.',
              style: AppTypography.bodySm(p),
            ),
          ),

          // Enfermedades expandibles
          ...List.generate(diseases.length, (i) {
            final (bg, fg) = colors[i % colors.length];
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: _ExpandableDisease(
                disease: diseases[i],
                isKichwa: isKichwa,
                p: p,
                accentBg: bg,
                accentFg: fg,
                icon: icons[i % icons.length],
                l10n: l10n,
              ),
            );
          }),

          // Cuándo consultar
          const SizedBox(height: AppSpacing.xs),
          Container(
            decoration: BoxDecoration(
              color: p.surface2,
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              border: Border.all(color: p.hairline),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.sm,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: p.blockCoral,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.local_hospital_outlined,
                          color: p.blockCoralText,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        Tr.seeDoctorTitle(isKichwa),
                        style: AppTypography.body(p).copyWith(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
                _ConsultRow(
                  p: p,
                  text: Tr.seeDoctorReasonPainWeeks(isKichwa),
                ),
                _ConsultRow(
                  p: p,
                  text: Tr.seeDoctorReasonTingling(isKichwa),
                ),
                _ConsultRow(
                  p: p,
                  text: Tr.seeDoctorReasonWeakness(isKichwa),
                  isLast: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // Quiz CTA
          _QuizCta(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const QuizScreen(quiz: diseasesQuiz),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}

class _ConsultRow extends StatelessWidget {
  const _ConsultRow({required this.p, required this.text, this.isLast = false});
  final AppPalette p;
  final String text;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: isLast
          ? null
          : BoxDecoration(
              border: Border(bottom: BorderSide(color: p.hairline, width: 1)),
            ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: p.blockCoralText,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(text, style: AppTypography.bodySm(p)),
          ),
        ],
      ),
    );
  }
}

// ── Tarjeta expandible ────────────────────────────────────────────────────────

class _ExpandableDisease extends StatefulWidget {
  const _ExpandableDisease({
    required this.disease,
    required this.isKichwa,
    required this.p,
    required this.accentBg,
    required this.accentFg,
    required this.icon,
    required this.l10n,
  });

  final Disease disease;
  final bool isKichwa;
  final AppPalette p;
  final Color accentBg;
  final Color accentFg;
  final IconData icon;
  final AppLocalizations l10n;

  @override
  State<_ExpandableDisease> createState() => _ExpandableDiseaseState();
}

class _ExpandableDiseaseState extends State<_ExpandableDisease>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<double> _rotate;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _rotate = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggle() {
    HapticFeedback.selectionClick();
    setState(() => _expanded = !_expanded);
    _expanded ? _ctrl.forward() : _ctrl.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.p;
    final d = widget.disease;
    final isKichwa = widget.isKichwa;

    return GestureDetector(
      onTap: _toggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        decoration: BoxDecoration(
          color: widget.accentBg,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: widget.accentFg.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      widget.icon,
                      color: widget.accentFg,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      d.name(isKichwa),
                      style: AppTypography.body(
                        p,
                        color: widget.accentFg,
                      ).copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  RotationTransition(
                    turns: _rotate,
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: widget.accentFg.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),

            // Expanded content
            if (_expanded)
              FadeTransition(
                opacity: _fade,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 1,
                        color: widget.accentFg.withValues(alpha: 0.2),
                        margin: const EdgeInsets.only(bottom: AppSpacing.md),
                      ),
                      Text(
                        d.description(isKichwa),
                        style: AppTypography.body(
                          p,
                          color: widget.accentFg.withValues(alpha: 0.85),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _DetailChip(
                        label: '',
                        content: d.cause(isKichwa),
                        fg: widget.accentFg,
                        p: p,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      _DetailChip(
                        label: '',
                        content: d.warning(isKichwa),
                        fg: widget.accentFg,
                        p: p,
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

class _DetailChip extends StatelessWidget {
  const _DetailChip({
    required this.label,
    required this.content,
    required this.fg,
    required this.p,
  });

  final String label;
  final String content;
  final Color fg;
  final AppPalette p;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: fg.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label.isNotEmpty) ...[
            Text(label, style: AppTypography.eyebrow(p, color: fg.withValues(alpha: 0.6))),
            const SizedBox(height: 3),
          ],
          Text(content, style: AppTypography.bodySm(p, color: fg)),
        ],
      ),
    );
  }
}

// ── Detail screen (mantiene ruta fallback) ───────────────────────────────────

class DiseaseDetailScreen extends StatelessWidget {
  const DiseaseDetailScreen({super.key, required this.disease});
  final Disease disease;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isKichwa = l10n.isKichwa;
    final p = context.palette;

    return Scaffold(
      backgroundColor: p.canvas,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screen, AppSpacing.md, AppSpacing.screen, AppSpacing.lg),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: p.hairline),
                        ),
                        child: Icon(Icons.arrow_back_ios_new_rounded,
                            color: p.ink, size: 18),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(disease.name(isKichwa),
                          style: AppTypography.displayMd(p)),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
                child: Column(
                  children: [
                    _Block(l10n.description, disease.description(isKichwa), p, p.surface2, p.ink),
                    const SizedBox(height: AppSpacing.xs),
                    _Block('', disease.cause(isKichwa), p, p.blockCream, p.blockCreamText),
                    const SizedBox(height: AppSpacing.xs),
                    _Block('', disease.warning(isKichwa), p, p.blockPink, p.blockPinkText),
                    const SizedBox(height: AppSpacing.xs),
                    _Block(l10n.whenToSeeDoctor, disease.consult(isKichwa), p, p.blockCoral, p.blockCoralText),
                    const SizedBox(height: AppSpacing.xl),
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

// ── Quiz CTA card ─────────────────────────────────────────────────────────────

class _QuizCta extends StatelessWidget {
  const _QuizCta({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: p.blockLilac,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: p.blockLilacText.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.psychology_rounded,
                color: p.blockLilacText,
                size: 22,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '¿Reconoces las señales?',
                    style: AppTypography.body(p, color: p.blockLilacText)
                        .copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Pon a prueba lo que aprendiste',
                    style: AppTypography.bodySm(
                      p,
                      color: p.blockLilacText.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: p.blockLilacText,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

class _Block extends StatelessWidget {
  const _Block(this.title, this.content, this.p, this.bg, this.fg);
  final String title;
  final String content;
  final AppPalette p;
  final Color bg;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty) ...[
            Text(title.toUpperCase(),
                style: AppTypography.eyebrow(p, color: fg.withValues(alpha: 0.6))),
            const SizedBox(height: AppSpacing.xs),
          ],
          Text(content, style: AppTypography.body(p, color: fg)),
        ],
      ),
    );
  }
}

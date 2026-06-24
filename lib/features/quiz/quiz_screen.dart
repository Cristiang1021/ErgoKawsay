import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_theme.dart';
import '../../data/models/quiz_question.dart';
import '../../shared/widgets/feature_scaffold.dart';
import '../../shared/widgets/framer/framer_buttons.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key, required this.quiz});

  final AppQuiz quiz;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
  int _questionIndex = 0;
  int? _selectedIndex;
  int _correctCount = 0;
  bool _showResults = false;

  late final AnimationController _progressCtrl;
  late final AnimationController _feedbackCtrl;
  late final Animation<double> _feedbackAnim;

  QuizQuestion get _current => widget.quiz.questions[_questionIndex];
  int get _total => widget.quiz.questions.length;
  bool get _answered => _selectedIndex != null;

  static const _correctGreen = Color(0xFF2E7D32);
  static const _correctGreenLight = Color(0xFFE8F5E9);
  static const _wrongRed = Color(0xFFB71C1C);
  static const _wrongRedLight = Color(0xFFFFEBEE);
  static const _starGold = Color(0xFFFFC107);

  @override
  void initState() {
    super.initState();
    _progressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      value: 1 / _total,
    );
    _feedbackCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _feedbackAnim = CurvedAnimation(parent: _feedbackCtrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _progressCtrl.dispose();
    _feedbackCtrl.dispose();
    super.dispose();
  }

  void _onOptionTap(int index) {
    if (_answered) return;
    final correct = index == _current.correctIndex;
    if (correct) {
      HapticFeedback.mediumImpact();
      _correctCount++;
    } else {
      HapticFeedback.vibrate();
    }
    setState(() => _selectedIndex = index);
    _feedbackCtrl.forward();
  }

  void _nextQuestion() {
    HapticFeedback.lightImpact();
    _feedbackCtrl.reset();
    if (_questionIndex + 1 < _total) {
      setState(() {
        _questionIndex++;
        _selectedIndex = null;
      });
      _progressCtrl.animateTo(
        (_questionIndex + 1) / _total,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _progressCtrl.animateTo(1.0, duration: const Duration(milliseconds: 300));
      setState(() => _showResults = true);
    }
  }

  void _retry() {
    _feedbackCtrl.reset();
    setState(() {
      _questionIndex = 0;
      _selectedIndex = null;
      _correctCount = 0;
      _showResults = false;
    });
    _progressCtrl.animateTo(
      1 / _total,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  (Color, Color) _cardColor(AppPalette p) {
    final pairs = [
      (p.blockMint, p.blockMintText),
      (p.blockLilac, p.blockLilacText),
      (p.blockCream, p.blockCreamText),
      (p.blockCoral, p.blockCoralText),
      (p.blockLime, p.blockLimeText),
      (p.blockPink, p.blockPinkText),
    ];
    return pairs[_questionIndex % pairs.length];
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return FeatureScaffold(
      categoryEyebrow: _showResults ? 'RESULTADO' : 'QUIZ',
      title: widget.quiz.title,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _showResults
            ? _buildResults(p)
            : _buildQuestion(p),
      ),
    );
  }

  // ── Question UI ─────────────────────────────────────────────────────────────

  Widget _buildQuestion(AppPalette p) {
    final q = _current;
    final (cardBg, cardFg) = _cardColor(p);
    final selected = _selectedIndex;
    final correctIdx = q.correctIndex;
    final isCorrectAnswer = selected == correctIdx;

    return SingleChildScrollView(
      key: ValueKey(_questionIndex),
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screen,
        AppSpacing.sm,
        AppSpacing.screen,
        AppSpacing.xxl + MediaQuery.paddingOf(context).bottom,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Progress bar
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                  child: AnimatedBuilder(
                    animation: _progressCtrl,
                    builder: (ctx, _) => LinearProgressIndicator(
                      value: _progressCtrl.value,
                      backgroundColor: p.surface2,
                      valueColor: AlwaysStoppedAnimation<Color>(p.ink),
                      minHeight: 6,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Pregunta ${_questionIndex + 1} de $_total',
                style: AppTypography.caption(p, color: p.inkMuted),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // Question card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PREGUNTA ${_questionIndex + 1}',
                  style: AppTypography.eyebrow(p,
                      color: cardFg.withValues(alpha: 0.55)),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  q.question,
                  style: AppTypography.headline(p, color: cardFg),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Options
          ...List.generate(q.options.length, (i) {
            final letter = String.fromCharCode(65 + i);
            final isSelected = selected == i;
            final isCorrect = i == correctIdx;

            Color optBg;
            Color optFg;
            Color badgeBg;
            Color badgeFg;
            double opacity = 1.0;
            Widget? trailingIcon;

            if (selected == null) {
              optBg = p.surface2;
              optFg = p.ink;
              badgeBg = p.hairline;
              badgeFg = p.inkMuted;
            } else if (isCorrect) {
              optBg = _correctGreen;
              optFg = Colors.white;
              badgeBg = Colors.white.withValues(alpha: 0.2);
              badgeFg = Colors.white;
              trailingIcon = const Icon(Icons.check_circle_rounded,
                  color: Colors.white, size: 20);
            } else if (isSelected) {
              optBg = _wrongRed;
              optFg = Colors.white;
              badgeBg = Colors.white.withValues(alpha: 0.2);
              badgeFg = Colors.white;
              trailingIcon = const Icon(Icons.cancel_rounded,
                  color: Colors.white, size: 20);
            } else {
              optBg = p.surface2;
              optFg = p.inkMuted;
              badgeBg = p.hairline;
              badgeFg = p.inkMuted;
              opacity = 0.4;
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 220),
                opacity: opacity,
                child: GestureDetector(
                  onTap: () => _onOptionTap(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 260),
                    curve: Curves.easeOut,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.md,
                    ),
                    decoration: BoxDecoration(
                      color: optBg,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      border: Border.all(
                        color: selected == null
                            ? p.hairline
                            : Colors.transparent,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 260),
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: badgeBg,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              letter,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: badgeFg,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Text(
                            q.options[i],
                            style: AppTypography.body(p, color: optFg),
                          ),
                        ),
                        if (trailingIcon != null) ...[
                          const SizedBox(width: AppSpacing.sm),
                          trailingIcon,
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),

          // Feedback + next button
          if (_answered)
            FadeTransition(
              opacity: _feedbackAnim,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AppSpacing.xs),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: isCorrectAnswer
                          ? _correctGreenLight
                          : _wrongRedLight,
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusMd),
                      border: Border.all(
                        color: isCorrectAnswer
                            ? _correctGreen.withValues(alpha: 0.3)
                            : _wrongRed.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          isCorrectAnswer
                              ? Icons.check_circle_rounded
                              : Icons.info_rounded,
                          color: isCorrectAnswer ? _correctGreen : _wrongRed,
                          size: 20,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            _current.feedback,
                            style: AppTypography.bodySm(
                              p,
                              color: isCorrectAnswer
                                  ? const Color(0xFF1B5E20)
                                  : const Color(0xFF7F0000),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  FramerPrimaryButton(
                    label: _questionIndex + 1 < _total
                        ? 'Siguiente →'
                        : 'Ver resultado →',
                    onPressed: _nextQuestion,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // ── Results UI ───────────────────────────────────────────────────────────────

  Widget _buildResults(AppPalette p) {
    final correct = _correctCount;
    final total = _total;
    final pct = correct / total;

    final int stars = pct <= 0.40 ? 1 : pct <= 0.70 ? 2 : 3;
    final bool isGood = pct >= 0.70;
    final String message = pct <= 0.40
        ? 'Vuelve a revisar el módulo e inténtalo de nuevo.'
        : pct <= 0.70
            ? '¡Buen intento! Repasa algunos conceptos clave.'
            : pct < 0.90
                ? '¡Muy bien! Casi lo tienes dominado.'
                : '¡Excelente! Dominas muy bien los conceptos.';

    final Color circleBg = isGood ? _correctGreen : _wrongRed;

    return Stack(
      key: const ValueKey('results'),
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.screen,
            0,
            AppSpacing.screen,
            AppSpacing.xl + MediaQuery.paddingOf(context).bottom,
          ),
          child: Column(
            children: [
              const Spacer(),

              // Stars
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (i) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: Duration(milliseconds: 400 + i * 150),
                    curve: Curves.elasticOut,
                    builder: (ctx, v, _) => Transform.scale(
                      scale: v,
                      child: Icon(
                        i < stars ? Icons.star_rounded : Icons.star_outline_rounded,
                        color: i < stars ? _starGold : p.hairline,
                        size: 44,
                      ),
                    ),
                  ),
                )),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Score circle
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 600),
                curve: Curves.elasticOut,
                builder: (ctx, v, _) => Transform.scale(
                  scale: v,
                  child: Container(
                    width: 128,
                    height: 128,
                    decoration: BoxDecoration(
                      color: circleBg,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: circleBg.withValues(alpha: 0.35),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$correct',
                            style: const TextStyle(
                              fontSize: 52,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              height: 1.0,
                            ),
                          ),
                          Text(
                            'de $total',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withValues(alpha: 0.8),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text('correctas', style: AppTypography.eyebrow(p)),
              const SizedBox(height: AppSpacing.lg),
              Text(
                message,
                style: AppTypography.body(p),
                textAlign: TextAlign.center,
              ),
              const Spacer(),

              FramerPrimaryButton(
                label: '↺  Intentar de nuevo',
                onPressed: _retry,
              ),
              const SizedBox(height: AppSpacing.sm),
              FramerSecondaryButton(
                label: 'Volver al módulo',
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),

        // Confetti overlay — solo en buenos resultados
        if (isGood)
          const Positioned.fill(
            child: IgnorePointer(child: _ConfettiOverlay()),
          ),
      ],
    );
  }
}

// ── Confetti ──────────────────────────────────────────────────────────────────

class _ConfettiOverlay extends StatefulWidget {
  const _ConfettiOverlay();

  @override
  State<_ConfettiOverlay> createState() => _ConfettiOverlayState();
}

class _ConfettiOverlayState extends State<_ConfettiOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final List<_Particle> _particles;

  @override
  void initState() {
    super.initState();
    final rng = math.Random();
    _particles = List.generate(90, (_) => _Particle(rng));
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (ctx, _) => CustomPaint(
        painter: _ConfettiPainter(_particles, _ctrl.value),
        size: Size.infinite,
      ),
    );
  }
}

class _Particle {
  _Particle(math.Random rng)
      : x = rng.nextDouble(),
        delay = rng.nextDouble() * 0.4,
        speed = 0.5 + rng.nextDouble() * 0.5,
        sway = (rng.nextDouble() - 0.5) * 0.12,
        size = 7.0 + rng.nextDouble() * 8.0,
        angle = rng.nextDouble() * math.pi * 2,
        spin = (rng.nextDouble() - 0.5) * 10,
        color = _kColors[rng.nextInt(_kColors.length)],
        isCircle = rng.nextBool();

  final double x;
  final double delay;
  final double speed;
  final double sway;
  final double size;
  final double angle;
  final double spin;
  final Color color;
  final bool isCircle;

  static const _kColors = [
    Color(0xFF97BF06),
    Color(0xFF030A8C),
    Color(0xFFFFC107),
    Color(0xFFE53935),
    Color(0xFF43A047),
    Color(0xFFFF7043),
    Color(0xFFAB47BC),
    Color(0xFF29B6F6),
  ];
}

class _ConfettiPainter extends CustomPainter {
  const _ConfettiPainter(this.particles, this.progress);

  final List<_Particle> particles;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (final p in particles) {
      final t = ((progress - p.delay) * p.speed).clamp(0.0, 1.0);
      if (t <= 0) continue;

      final x = (p.x + math.sin(t * math.pi * 2) * p.sway) * size.width;
      final y = t * (size.height + 60);
      final rotation = p.angle + t * p.spin;
      final opacity = (1.0 - math.max(0.0, (t - 0.75) / 0.25)).clamp(0.0, 1.0);

      paint.color = p.color.withValues(alpha: opacity);

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(rotation);

      if (p.isCircle) {
        canvas.drawCircle(Offset.zero, p.size / 2, paint);
      } else {
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset.zero,
            width: p.size,
            height: p.size * 0.45,
          ),
          paint,
        );
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => old.progress != progress;
}

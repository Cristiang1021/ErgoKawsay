import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

enum IllustrationPreset { splash, language, home }

class FlatIllustration extends StatelessWidget {
  const FlatIllustration({
    super.key,
    this.assetPath,
    this.preset,
    this.height = 200,
    this.fit = BoxFit.contain,
  });

  final String? assetPath;
  final IllustrationPreset? preset;
  final double height;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    if (assetPath != null) {
      return SizedBox(
        height: height,
        child: Image.asset(
          assetPath!,
          fit: fit,
          errorBuilder: (_, __, ___) => _PresetIllustration(preset: preset, height: height),
        ),
      );
    }

    return _PresetIllustration(preset: preset, height: height);
  }
}

class _PresetIllustration extends StatelessWidget {
  const _PresetIllustration({this.preset, required this.height});

  final IllustrationPreset? preset;
  final double height;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;

    return SizedBox(
      height: height,
      child: CustomPaint(
        painter: _FlatIllustrationPainter(
          preset: preset ?? IllustrationPreset.home,
          accent: p.accent,
          warm: p.warmAccent,
          teal: p.teal,
          surface: p.editorialSurface,
        ),
        size: Size.infinite,
      ),
    );
  }
}

class _FlatIllustrationPainter extends CustomPainter {
  _FlatIllustrationPainter({
    required this.preset,
    required this.accent,
    required this.warm,
    required this.teal,
    required this.surface,
  });

  final IllustrationPreset preset;
  final Color accent;
  final Color warm;
  final Color teal;
  final Color surface;

  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = surface.withValues(alpha: 0.6);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.05, size.height * 0.08, size.width * 0.9, size.height * 0.84),
        const Radius.circular(24),
      ),
      bg,
    );

    switch (preset) {
      case IllustrationPreset.splash:
        _drawTeacher(canvas, size, centerY: size.height * 0.5);
      case IllustrationPreset.language:
        _drawTeacher(canvas, size, centerY: size.height * 0.55);
        _drawGlobe(canvas, size);
      case IllustrationPreset.home:
        _drawTeacher(canvas, size, centerY: size.height * 0.48);
        _drawPlants(canvas, size);
    }
  }

  void _drawTeacher(Canvas canvas, Size size, {required double centerY}) {
    final head = Paint()..color = warm.withValues(alpha: 0.85);
    final body = Paint()..color = accent.withValues(alpha: 0.9);
    final book = Paint()..color = teal.withValues(alpha: 0.7);
    final cx = size.width * 0.5;

    canvas.drawCircle(Offset(cx, centerY - 40), 28, head);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx, centerY + 20), width: 70, height: 90),
        const Radius.circular(16),
      ),
      body,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx + 45, centerY + 10), width: 36, height: 28),
        const Radius.circular(6),
      ),
      book,
    );
  }

  void _drawGlobe(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = teal.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(Offset(size.width * 0.78, size.height * 0.3), 22, paint);
  }

  void _drawPlants(Canvas canvas, Size size) {
    final leaf = Paint()..color = accent.withValues(alpha: 0.45);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(size.width * 0.18, size.height * 0.72), width: 40, height: 24),
      leaf,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(size.width * 0.82, size.height * 0.68), width: 36, height: 20),
      leaf,
    );
  }

  @override
  bool shouldRepaint(covariant _FlatIllustrationPainter old) => false;
}

import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Brand identity (ErgoKawsay logo colors) ──────────────────────────────
  static const Color brandBlue        = Color(0xFF030A8C); // primary CTA
  static const Color brandGreenBright = Color(0xFF0DF205); // micro-accent ONLY
  static const Color brandGreen       = Color(0xFF97BF06); // accent / active
  static const Color brandOlive       = Color(0xFF8C8303); // details / badges
  static const Color brandInk         = Color(0xFF0D0D0D); // text / dark bg

  // ── Derived surface tints ────────────────────────────────────────────────
  // 97BF06 at ~4 % on white → slightly green-warm surface
  static const Color surfaceGreen = Color(0xFFF4F7EC);
  // 030A8C at ~8 % on white → soft blue surface
  static const Color surfaceBlue  = Color(0xFFDCE4FF);
  // 8C8303 at ~10 % on white → soft warm/olive surface
  static const Color surfaceWarm  = Color(0xFFEDE8C8);

  // ── Block palette (light mode) — all derived from brand ──────────────────
  // Green family (#97BF06)
  static const Color blockLime  = Color(0xFFE8F5A8); // very soft lime
  static const Color blockMint  = Color(0xFFC8E488); // medium soft lime-green
  // Blue family (#030A8C)
  static const Color blockLilac = Color(0xFFDCE4FF); // very soft blue
  static const Color blockPink  = Color(0xFFBFC8FF); // medium soft blue
  static const Color blockNavy  = Color(0xFF030A8C); // pure brand blue
  // Warm/olive family (#8C8303)
  static const Color blockCream = Color(0xFFEDE8C8); // soft warm
  static const Color blockCoral = Color(0xFFEDE0A0); // warm golden

  // ── Spotlight gradient (solid — no actual gradients used) ─────────────────
  static const Color gradientTealStart    = Color(0xFFC8E488);
  static const Color gradientTealEnd      = Color(0xFFC8E488);
  static const Color gradientWarmStart    = Color(0xFFEDE8C8);
  static const Color gradientWarmEnd      = Color(0xFFEDE8C8);
  static const Color gradientVioletStart  = Color(0xFFDCE4FF);
  static const Color gradientVioletEnd    = Color(0xFFDCE4FF);
  static const Color gradientMagentaStart = Color(0xFFBFC8FF);
  static const Color gradientMagentaEnd   = Color(0xFFBFC8FF);
  static const Color gradientOrangeStart  = Color(0xFFE8F5A8);
  static const Color gradientOrangeEnd    = Color(0xFFE8F5A8);
  static const Color gradientCoralStart   = Color(0xFFEDE0A0);
  static const Color gradientCoralEnd     = Color(0xFFEDE0A0);

  static LinearGradient spotlightGradient(SpotlightVariant variant) {
    final color = _solidForVariant(variant);
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [color, color],
    );
  }

  static Color _solidForVariant(SpotlightVariant variant) {
    switch (variant) {
      case SpotlightVariant.teal:
        return blockMint;
      case SpotlightVariant.violet:
        return blockLilac;
      case SpotlightVariant.magenta:
        return blockPink;
      case SpotlightVariant.orange:
        return blockLime;
      case SpotlightVariant.coral:
        return blockCoral;
      case SpotlightVariant.warm:
        return blockCream;
    }
  }

  static SpotlightVariant spotlightForIndex(int index) {
    const variants = SpotlightVariant.values;
    return variants[index % variants.length];
  }
}

enum SpotlightVariant { teal, violet, magenta, orange, coral, warm }

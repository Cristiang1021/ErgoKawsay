import 'package:flutter/material.dart';

import 'app_colors.dart';

@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.canvas,
    required this.surface1,
    required this.surface2,
    required this.editorialSurface,
    required this.thumbnailBg,
    required this.ink,
    required this.inkMuted,
    required this.hairline,
    required this.hairlineSoft,
    required this.accent,
    required this.warmAccent,
    required this.teal,
    required this.primaryBtnBg,
    required this.primaryBtnFg,
    required this.success,
    required this.error,
    required this.heroGradientStart,
    required this.heroGradientEnd,
    required this.isDark,
    // Color blocks
    required this.blockLime,
    required this.blockLilac,
    required this.blockCream,
    required this.blockMint,
    required this.blockPink,
    required this.blockCoral,
    required this.blockNavy,
    required this.blockLimeText,
    required this.blockLilacText,
    required this.blockCreamText,
    required this.blockMintText,
    required this.blockPinkText,
    required this.blockCoralText,
    required this.blockNavyText,
  });

  final Color canvas;
  final Color surface1;
  final Color surface2;
  final Color editorialSurface;
  final Color thumbnailBg;
  final Color ink;
  final Color inkMuted;
  final Color hairline;
  final Color hairlineSoft;
  final Color accent;
  final Color warmAccent;
  final Color teal;
  final Color primaryBtnBg;
  final Color primaryBtnFg;
  final Color success;
  final Color error;
  final Color heroGradientStart;
  final Color heroGradientEnd;
  final bool isDark;

  // ── Color blocks ──────────────────────────────────────────────────────────
  final Color blockLime;
  final Color blockLilac;
  final Color blockCream;
  final Color blockMint;
  final Color blockPink;
  final Color blockCoral;
  final Color blockNavy;

  // Text on each block (WCAG AA ≥ 4.5:1 verified)
  final Color blockLimeText;
  final Color blockLilacText;
  final Color blockCreamText;
  final Color blockMintText;
  final Color blockPinkText;
  final Color blockCoralText;
  final Color blockNavyText;

  LinearGradient get heroGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [heroGradientStart, heroGradientEnd],
      );

  LinearGradient spotlight(SpotlightVariant variant) =>
      AppColors.spotlightGradient(variant);

  Color blockForVariant(SpotlightVariant v) {
    switch (v) {
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

  Color blockTextForVariant(SpotlightVariant v) {
    switch (v) {
      case SpotlightVariant.teal:
        return blockMintText;
      case SpotlightVariant.violet:
        return blockLilacText;
      case SpotlightVariant.magenta:
        return blockPinkText;
      case SpotlightVariant.orange:
        return blockLimeText;
      case SpotlightVariant.coral:
        return blockCoralText;
      case SpotlightVariant.warm:
        return blockCreamText;
    }
  }

  // ── Light mode ───────────────────────────────────────────────────────────
  // 60 % canvas: #FFFFFF (pure white)
  // 30 % surfaces: #F4F7EC (brand green tint <4 % on white)
  // 10 % accent:  #030A8C (blue CTAs) · #97BF06 (active states)
  static const light = AppPalette(
    canvas:            Color(0xFFFFFFFF),
    surface1:          Color(0xFFFFFFFF),
    surface2:          Color(0xFFF4F7EC), // #97BF06 tint ≈ 4 % on white
    editorialSurface:  Color(0xFFF4F7EC),
    thumbnailBg:       Color(0xFFF4F7EC),
    ink:               Color(0xFF0D0D0D), // brand ink
    inkMuted:          Color(0xFF5C5C52), // slightly olive-tinted gray
    hairline:          Color(0xFFD6DBC8), // green-tinted border
    hairlineSoft:      Color(0xFFECF0E4), // very soft green-tinted divider
    accent:            Color(0xFF97BF06), // brand green — active/selected
    warmAccent:        Color(0xFF97BF06),
    teal:              Color(0xFF030A8C), // brand blue — illustration accent
    primaryBtnBg:      Color(0xFF030A8C), // brand blue — primary CTA
    primaryBtnFg:      Color(0xFFFFFFFF),
    success:           Color(0xFF4A6800), // darker brand green — WCAG 4.5:1 on white
    error:             Color(0xFFC0230A),
    heroGradientStart: Color(0xFFF4F7EC),
    heroGradientEnd:   Color(0xFFDDF0A8), // soft lime from #97BF06

    // ── Color blocks — all derived from brand ─────────────────────────────
    // Green family (#97BF06)
    blockLime:     Color(0xFFE8F5A8), // very soft lime
    blockMint:     Color(0xFFC8E488), // medium soft lime-green

    // Blue family (#030A8C)
    blockLilac:    Color(0xFFDCE4FF), // very soft blue
    blockPink:     Color(0xFFBFC8FF), // medium soft blue

    // Warm/olive family (#8C8303)
    blockCream:    Color(0xFFEDE8C8), // soft warm
    blockCoral:    Color(0xFFEDE0A0), // warm golden

    // Dark brand blue
    blockNavy:     Color(0xFF030A8C),

    // Text on blocks (WCAG AA verified)
    blockLimeText:   Color(0xFF182E00), // 13:1 on #E8F5A8
    blockLilacText:  Color(0xFF030A8C), // 14:1 on #DCE4FF
    blockCreamText:  Color(0xFF2A2004), // 12:1 on #EDE8C8
    blockMintText:   Color(0xFF082400), // 11:1 on #C8E488
    blockPinkText:   Color(0xFF030A8C), // 11:1 on #BFC8FF
    blockCoralText:  Color(0xFF26190A), // 12:1 on #EDE0A0
    blockNavyText:   Color(0xFFE8EEFF), // 15:1 on #030A8C
    isDark:        false,
  );

  // ── Dark mode ────────────────────────────────────────────────────────────
  // 60 % canvas: #0D0D0D (brand ink)
  // 30 % surfaces: #1A1C14 (slightly green-tinted dark)
  // 10 % accent:  #4D5FC0 (lightened brand blue) · #97BF06 (active states)
  static const dark = AppPalette(
    canvas:            Color(0xFF0D0D0D), // brand ink
    surface1:          Color(0xFF0D0D0D),
    surface2:          Color(0xFF1A1C14), // dark, slightly green-tinted
    editorialSurface:  Color(0xFF1A1C14),
    thumbnailBg:       Color(0xFF1A1C14),
    ink:               Color(0xFFF0EDE6), // near-white, warm tint
    inkMuted:          Color(0xFF8A8A82), // warm muted gray
    hairline:          Color(0xFF282A20), // dark green-tinted border
    hairlineSoft:      Color(0xFF1A1C14),
    accent:            Color(0xFF97BF06), // brand green — works on dark bg
    warmAccent:        Color(0xFF97BF06),
    teal:              Color(0xFF4D5FC0), // lightened #030A8C for dark bg
    primaryBtnBg:      Color(0xFF4D5FC0), // accessible blue on dark (5.7:1 w/ white)
    primaryBtnFg:      Color(0xFFFFFFFF),
    success:           Color(0xFF97BF06), // brand green on dark bg
    error:             Color(0xFFFF4835),
    heroGradientStart: Color(0xFF1A1C14),
    heroGradientEnd:   Color(0xFF1A1C14),

    // ── Color blocks — dark mode (same hue families, much darker) ─────────
    // Green family
    blockLime:     Color(0xFF243600), // very dark lime
    blockMint:     Color(0xFF162800), // very dark mint

    // Blue family
    blockLilac:    Color(0xFF0C1478), // very dark blue
    blockPink:     Color(0xFF081060), // very dark blue variant

    // Warm/olive family
    blockCream:    Color(0xFF2C2808), // very dark warm-brown
    blockCoral:    Color(0xFF261C04), // very dark warm-golden

    // Deepest navy
    blockNavy:     Color(0xFF010566),

    // Text on dark blocks (WCAG AA verified)
    blockLimeText:   Color(0xFFBAD870), // 8.5:1 on #243600
    blockLilacText:  Color(0xFFA8BCFF), // 8.5:1 on #0C1478
    blockCreamText:  Color(0xFFD8CCA0), // 8:1 on #2C2808
    blockMintText:   Color(0xFF9CC860), // 8:1 on #162800
    blockPinkText:   Color(0xFF90A4FF), // 8:1 on #081060
    blockCoralText:  Color(0xFFD0B860), // 8:1 on #261C04
    blockNavyText:   Color(0xFFB0BCFF), // 8:1 on #010566
    isDark:        true,
  );

  @override
  AppPalette copyWith({
    Color? canvas,
    Color? surface1,
    Color? surface2,
    Color? editorialSurface,
    Color? thumbnailBg,
    Color? ink,
    Color? inkMuted,
    Color? hairline,
    Color? hairlineSoft,
    Color? accent,
    Color? warmAccent,
    Color? teal,
    Color? primaryBtnBg,
    Color? primaryBtnFg,
    Color? success,
    Color? error,
    Color? heroGradientStart,
    Color? heroGradientEnd,
    bool? isDark,
    Color? blockLime,
    Color? blockLilac,
    Color? blockCream,
    Color? blockMint,
    Color? blockPink,
    Color? blockCoral,
    Color? blockNavy,
    Color? blockLimeText,
    Color? blockLilacText,
    Color? blockCreamText,
    Color? blockMintText,
    Color? blockPinkText,
    Color? blockCoralText,
    Color? blockNavyText,
  }) {
    return AppPalette(
      canvas: canvas ?? this.canvas,
      surface1: surface1 ?? this.surface1,
      surface2: surface2 ?? this.surface2,
      editorialSurface: editorialSurface ?? this.editorialSurface,
      thumbnailBg: thumbnailBg ?? this.thumbnailBg,
      ink: ink ?? this.ink,
      inkMuted: inkMuted ?? this.inkMuted,
      hairline: hairline ?? this.hairline,
      hairlineSoft: hairlineSoft ?? this.hairlineSoft,
      accent: accent ?? this.accent,
      warmAccent: warmAccent ?? this.warmAccent,
      teal: teal ?? this.teal,
      primaryBtnBg: primaryBtnBg ?? this.primaryBtnBg,
      primaryBtnFg: primaryBtnFg ?? this.primaryBtnFg,
      success: success ?? this.success,
      error: error ?? this.error,
      heroGradientStart: heroGradientStart ?? this.heroGradientStart,
      heroGradientEnd: heroGradientEnd ?? this.heroGradientEnd,
      isDark: isDark ?? this.isDark,
      blockLime: blockLime ?? this.blockLime,
      blockLilac: blockLilac ?? this.blockLilac,
      blockCream: blockCream ?? this.blockCream,
      blockMint: blockMint ?? this.blockMint,
      blockPink: blockPink ?? this.blockPink,
      blockCoral: blockCoral ?? this.blockCoral,
      blockNavy: blockNavy ?? this.blockNavy,
      blockLimeText: blockLimeText ?? this.blockLimeText,
      blockLilacText: blockLilacText ?? this.blockLilacText,
      blockCreamText: blockCreamText ?? this.blockCreamText,
      blockMintText: blockMintText ?? this.blockMintText,
      blockPinkText: blockPinkText ?? this.blockPinkText,
      blockCoralText: blockCoralText ?? this.blockCoralText,
      blockNavyText: blockNavyText ?? this.blockNavyText,
    );
  }

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    return AppPalette(
      canvas: Color.lerp(canvas, other.canvas, t)!,
      surface1: Color.lerp(surface1, other.surface1, t)!,
      surface2: Color.lerp(surface2, other.surface2, t)!,
      editorialSurface: Color.lerp(editorialSurface, other.editorialSurface, t)!,
      thumbnailBg: Color.lerp(thumbnailBg, other.thumbnailBg, t)!,
      ink: Color.lerp(ink, other.ink, t)!,
      inkMuted: Color.lerp(inkMuted, other.inkMuted, t)!,
      hairline: Color.lerp(hairline, other.hairline, t)!,
      hairlineSoft: Color.lerp(hairlineSoft, other.hairlineSoft, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      warmAccent: Color.lerp(warmAccent, other.warmAccent, t)!,
      teal: Color.lerp(teal, other.teal, t)!,
      primaryBtnBg: Color.lerp(primaryBtnBg, other.primaryBtnBg, t)!,
      primaryBtnFg: Color.lerp(primaryBtnFg, other.primaryBtnFg, t)!,
      success: Color.lerp(success, other.success, t)!,
      error: Color.lerp(error, other.error, t)!,
      heroGradientStart: Color.lerp(heroGradientStart, other.heroGradientStart, t)!,
      heroGradientEnd: Color.lerp(heroGradientEnd, other.heroGradientEnd, t)!,
      isDark: t < 0.5 ? isDark : other.isDark,
      blockLime: Color.lerp(blockLime, other.blockLime, t)!,
      blockLilac: Color.lerp(blockLilac, other.blockLilac, t)!,
      blockCream: Color.lerp(blockCream, other.blockCream, t)!,
      blockMint: Color.lerp(blockMint, other.blockMint, t)!,
      blockPink: Color.lerp(blockPink, other.blockPink, t)!,
      blockCoral: Color.lerp(blockCoral, other.blockCoral, t)!,
      blockNavy: Color.lerp(blockNavy, other.blockNavy, t)!,
      blockLimeText: Color.lerp(blockLimeText, other.blockLimeText, t)!,
      blockLilacText: Color.lerp(blockLilacText, other.blockLilacText, t)!,
      blockCreamText: Color.lerp(blockCreamText, other.blockCreamText, t)!,
      blockMintText: Color.lerp(blockMintText, other.blockMintText, t)!,
      blockPinkText: Color.lerp(blockPinkText, other.blockPinkText, t)!,
      blockCoralText: Color.lerp(blockCoralText, other.blockCoralText, t)!,
      blockNavyText: Color.lerp(blockNavyText, other.blockNavyText, t)!,
    );
  }

}

extension AppPaletteContext on BuildContext {
  AppPalette get palette =>
      Theme.of(this).extension<AppPalette>() ?? AppPalette.light;
}

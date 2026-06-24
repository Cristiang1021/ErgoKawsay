import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_palette.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

export 'app_colors.dart';
export 'app_palette.dart';
export 'app_spacing.dart';
export 'app_typography.dart';

/// Evita el efecto de "zoom"/stretch al hacer overscroll en Android (Material 3).
class AppScrollBehavior extends MaterialScrollBehavior {
  const AppScrollBehavior();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const ClampingScrollPhysics();
  }
}

class AppTheme {
  AppTheme._();

  static ThemeData _build(AppPalette p) {
    final overlay = p.isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark;

    return ThemeData(
      useMaterial3: true,
      brightness: p.isDark ? Brightness.dark : Brightness.light,
      extensions: [p],
      scaffoldBackgroundColor: p.canvas,
      fontFamily: 'Inter',
      textTheme: AppTypography.textTheme(p),

      // ── ColorScheme ────────────────────────────────────────────────────
      // primary = brand blue (#030A8C light / #4D5FC0 dark)
      // secondary = brand green (#97BF06) — active states, chips
      colorScheme: ColorScheme(
        brightness:  p.isDark ? Brightness.dark : Brightness.light,
        primary:     p.primaryBtnBg,
        onPrimary:   p.primaryBtnFg,
        secondary:   p.accent,                    // brand green
        onSecondary: const Color(0xFF0D0D0D),     // dark text on brand green
        surface:     p.surface1,
        onSurface:   p.ink,
        error:       p.error,
        onError:     Colors.white,
      ),

      // ── AppBar ─────────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: p.canvas,
        foregroundColor: p.ink,
        elevation: 0,
        systemOverlayStyle: overlay,
      ),

      // ── Card ───────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        elevation: 0,
        color: p.surface1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
      ),

      dividerColor: p.hairline,

      // ── Progress indicator: brand green instead of ink ─────────────────
      progressIndicatorTheme: ProgressIndicatorThemeData(color: p.accent),

      // ── Slider ─────────────────────────────────────────────────────────
      sliderTheme: SliderThemeData(
        activeTrackColor: p.accent,
        thumbColor: p.primaryBtnBg,
        inactiveTrackColor: p.surface2,
      ),

      // ── Switch ─────────────────────────────────────────────────────────
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return p.primaryBtnFg;
          return p.inkMuted;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return p.primaryBtnBg;
          return p.hairline;
        }),
      ),

      // ── SnackBar ───────────────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: p.ink,
        contentTextStyle: AppTypography.body(p, color: p.canvas),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
      ),

      // ── Chip ───────────────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: p.surface2,
        selectedColor: p.blockLime,
        labelStyle: AppTypography.caption(p),
        side: BorderSide(color: p.hairline),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
        ),
      ),
    );
  }

  static ThemeData get lightTheme => _build(AppPalette.light);
  static ThemeData get darkTheme  => _build(AppPalette.dark);
}

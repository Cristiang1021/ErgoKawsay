import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_palette.dart';

class AppTypography {
  AppTypography._();

  static TextStyle displayXl(AppPalette p, {Color? color}) => GoogleFonts.inter(
        fontSize: 48,
        fontWeight: FontWeight.w400,
        height: 1.0,
        letterSpacing: -1.2,
        color: color ?? p.ink,
      );

  static TextStyle displayLg(AppPalette p, {Color? color}) => GoogleFonts.inter(
        fontSize: 40,
        fontWeight: FontWeight.w400,
        height: 1.05,
        letterSpacing: -1.0,
        color: color ?? p.ink,
      );

  static TextStyle displayMd(AppPalette p, {Color? color}) => GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 1.18,
        letterSpacing: -0.4,
        color: color ?? p.ink,
      );

  static TextStyle headline(AppPalette p, {Color? color}) => GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 1.18,
        letterSpacing: -0.4,
        color: color ?? p.ink,
      );

  static TextStyle subhead(AppPalette p, {Color? color}) => GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w400,
        height: 1.25,
        letterSpacing: -0.3,
        color: color ?? p.inkMuted,
      );

  static TextStyle cardTitle(AppPalette p, {Color? color}) => GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        height: 1.25,
        letterSpacing: -0.2,
        color: color ?? p.ink,
      );

  static TextStyle bodyLg(AppPalette p, {Color? color}) => GoogleFonts.inter(
        fontSize: 19,
        fontWeight: FontWeight.w400,
        height: 1.42,
        letterSpacing: -0.1,
        color: color ?? p.ink,
      );

  static TextStyle body(AppPalette p, {Color? color}) => GoogleFonts.inter(
        fontSize: 17,
        fontWeight: FontWeight.w400,
        height: 1.45,
        letterSpacing: 0,
        color: color ?? p.ink,
      );

  static TextStyle bodySm(AppPalette p, {Color? color}) => GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.45,
        letterSpacing: 0,
        color: color ?? p.inkMuted,
      );

  static TextStyle button(AppPalette p, {Color? color}) => GoogleFonts.inter(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: 0,
        color: color ?? p.primaryBtnFg,
      );

  static TextStyle eyebrow(AppPalette p, {Color? color}) =>
      GoogleFonts.jetBrainsMono(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.8,
        height: 1.25,
        color: color ?? p.inkMuted,
      );

  static TextStyle caption(AppPalette p, {Color? color}) => GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        height: 1.25,
        letterSpacing: 0,
        color: color ?? p.inkMuted,
      );

  static TextStyle micro(AppPalette p, {Color? color}) => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.25,
        color: color ?? p.inkMuted,
      );

  static TextStyle editorialQuote(AppPalette p, {Color? color}) =>
      GoogleFonts.inter(
        fontSize: 19,
        fontWeight: FontWeight.w400,
        height: 1.5,
        letterSpacing: -0.1,
        fontStyle: FontStyle.italic,
        color: color ?? p.inkMuted,
      );

  static TextStyle timerDisplay(AppPalette p, {Color? color}) =>
      GoogleFonts.inter(
        fontSize: 56,
        fontWeight: FontWeight.w700,
        height: 1.0,
        letterSpacing: -2.0,
        color: color ?? p.ink,
      );

  static TextTheme textTheme(AppPalette p) => TextTheme(
        displayLarge: displayXl(p),
        displayMedium: displayLg(p),
        displaySmall: displayMd(p),
        headlineMedium: headline(p),
        titleLarge: cardTitle(p),
        bodyLarge: bodyLg(p),
        bodyMedium: body(p),
        bodySmall: bodySm(p),
        labelLarge: button(p),
      );
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_theme.dart';

class FramerPrimaryButton extends StatelessWidget {
  const FramerPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.enabled = true,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool enabled;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: enabled ? 1.0 : 0.4,
      child: GestureDetector(
        onTap: enabled
            ? () {
                HapticFeedback.lightImpact();
                onPressed?.call();
              }
            : null,
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: p.primaryBtnBg,
            borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(label, style: AppTypography.button(p, color: p.primaryBtnFg)),
              if (icon != null) ...[
                const SizedBox(width: AppSpacing.xs),
                Icon(icon, size: 18, color: p.primaryBtnFg),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class FramerSecondaryButton extends StatelessWidget {
  const FramerSecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.selected = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onPressed();
      },
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: selected ? p.ink : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
          border: Border.all(
            color: selected ? p.ink : p.hairline,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTypography.button(
              p,
              color: selected ? p.primaryBtnFg : p.ink,
            ),
          ),
        ),
      ),
    );
  }
}

class FramerIconButton extends StatelessWidget {
  const FramerIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = 44,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final double size;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onPressed();
      },
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: p.hairline),
        ),
        child: Icon(icon, color: p.ink, size: 18),
      ),
    );
  }
}

/// Botón de acción grande tipo color-block.
class AppActionButton extends StatelessWidget {
  const AppActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.fullWidth = true,
  });

  final String label;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final bg = backgroundColor ?? p.primaryBtnBg;
    final fg = textColor ?? p.primaryBtnFg;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onPressed();
      },
      child: Container(
        height: 56,
        width: fullWidth ? double.infinity : null,
        padding: fullWidth ? null : const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18, color: fg),
              const SizedBox(width: AppSpacing.xs),
            ],
            Text(label, style: AppTypography.button(p, color: fg)),
          ],
        ),
      ),
    );
  }
}

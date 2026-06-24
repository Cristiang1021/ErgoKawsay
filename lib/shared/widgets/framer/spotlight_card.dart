import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class SpotlightCard extends StatelessWidget {
  const SpotlightCard({
    super.key,
    required this.child,
    this.variant = SpotlightVariant.violet,
    this.onTap,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
  });

  final Widget child;
  final SpotlightVariant variant;
  final VoidCallback? onTap;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final bg = p.blockForVariant(variant);
    final textColor = p.blockTextForVariant(variant);

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        child: Padding(
          padding: padding,
          child: DefaultTextStyle(
            style: TextStyle(color: textColor),
            child: IconTheme(
              data: IconThemeData(color: textColor),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class SurfaceCard extends StatelessWidget {
  const SurfaceCard({
    super.key,
    required this.child,
    this.onTap,
    this.featured = false,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
  });

  final Widget child;
  final VoidCallback? onTap;
  final bool featured;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final bg = featured ? p.surface2 : p.surface1;

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            border: Border.all(color: p.hairline),
          ),
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}

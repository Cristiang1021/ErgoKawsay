import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_theme.dart';
import '../../data/models/module_item.dart';
import 'framer/spotlight_card.dart';

class ModuleCard extends StatelessWidget {
  const ModuleCard({
    super.key,
    required this.module,
    required this.isKichwa,
    required this.onTap,
    this.index = 0,
  });

  final ModuleItem module;
  final bool isKichwa;
  final VoidCallback onTap;
  final int index;

  bool get _isSpotlight => index % 4 == 0;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final title = module.title(isKichwa);
    final variant = AppColors.spotlightForIndex(index ~/ 4);

    if (_isSpotlight) {
      return SpotlightCard(
        variant: variant,
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: _CardContent(icon: module.icon, title: title, spotlight: true, palette: p),
      );
    }

    return SurfaceCard(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: _CardContent(icon: module.icon, title: title, spotlight: false, palette: p),
    );
  }
}

class _CardContent extends StatelessWidget {
  const _CardContent({
    required this.icon,
    required this.title,
    required this.spotlight,
    required this.palette,
  });

  final IconData icon;
  final String title;
  final bool spotlight;
  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: spotlight
                ? Colors.white.withValues(alpha: 0.2)
                : palette.surface2,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          child: Icon(
            icon,
            color: spotlight ? Colors.white : palette.ink,
            size: 22,
          ),
        ),
        const Spacer(),
        Text(
          title,
          style: AppTypography.body(palette, color: spotlight ? Colors.white : palette.ink)
              .copyWith(fontWeight: FontWeight.w600, height: 1.25),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          '→',
          style: AppTypography.caption(
            palette,
            color: spotlight ? Colors.white70 : palette.accent,
          ),
        ),
      ],
    );
  }
}

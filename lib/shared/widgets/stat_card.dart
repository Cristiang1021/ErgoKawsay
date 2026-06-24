import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import 'framer/spotlight_card.dart';

class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.spotlight = false,
    this.variant = SpotlightVariant.violet,
  });

  final String title;
  final String value;
  final IconData icon;
  final bool spotlight;
  final SpotlightVariant variant;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: spotlight ? Colors.white : p.inkMuted, size: 24),
        const Spacer(),
        Text(
          value,
          style: AppTypography.displayMd(p, color: spotlight ? Colors.white : p.ink),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          title,
          style: AppTypography.bodySm(p, color: spotlight ? Colors.white70 : p.inkMuted),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );

    if (spotlight) {
      return SpotlightCard(
        variant: variant,
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: SizedBox(height: 110, child: content),
      );
    }

    return SurfaceCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: SizedBox(height: 110, child: content),
    );
  }
}

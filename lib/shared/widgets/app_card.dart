import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import 'framer/spotlight_card.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.featured = false,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets padding;
  final bool featured;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      onTap: onTap,
      featured: featured,
      padding: padding,
      child: child,
    );
  }
}

class InfoSection extends StatelessWidget {
  const InfoSection({super.key, required this.title, required this.content});

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.headline(p)),
          const SizedBox(height: AppSpacing.sm),
          Text(content, style: AppTypography.body(p, color: p.inkMuted)),
        ],
      ),
    );
  }
}

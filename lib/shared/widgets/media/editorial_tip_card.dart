import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class EditorialTipCard extends StatelessWidget {
  const EditorialTipCard({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.content,
    this.onTap,
  });

  final String eyebrow;
  final String title;
  final String content;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;

    return Material(
      color: p.editorialSurface,
      borderRadius: BorderRadius.circular(AppSpacing.radiusXxl),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXxl),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusXxl),
            border: Border.all(color: p.hairline),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(eyebrow, style: AppTypography.eyebrow(p)),
              const SizedBox(height: AppSpacing.sm),
              Text(title, style: AppTypography.headline(p)),
              const SizedBox(height: AppSpacing.md),
              Container(
                width: 32,
                height: 3,
                decoration: BoxDecoration(
                  color: p.warmAccent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(content, style: AppTypography.editorialQuote(p, color: p.inkMuted)),
            ],
          ),
        ),
      ),
    );
  }
}

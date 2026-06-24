import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

export 'app_card.dart' show AppCard, InfoSection;

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.displayMd(p)),
          if (subtitle != null) ...[
            const SizedBox(height: AppSpacing.xxs),
            Text(subtitle!, style: AppTypography.bodySm(p)),
          ],
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/models/module_item.dart';
import 'media_thumbnail_card.dart';

class ModuleCarousel extends StatelessWidget {
  const ModuleCarousel({
    super.key,
    required this.title,
    required this.modules,
    required this.isKichwa,
    required this.onModuleTap,
  });

  final String title;
  final List<ModuleItem> modules;
  final bool isKichwa;
  final ValueChanged<ModuleItem> onModuleTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;

    if (modules.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Text(title, style: AppTypography.headline(p)),
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 200,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            scrollDirection: Axis.horizontal,
            itemCount: modules.length,
            separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
            itemBuilder: (context, index) {
              final module = modules[index];
              return MediaThumbnailCard(
                compact: true,
                title: module.title(isKichwa),
                subtitle: module.subtitle(isKichwa),
                imageAsset: module.thumbnailAsset,
                imageUrl: module.thumbnailUrl,
                accentColor: module.color,
                icon: module.icon,
                onTap: () => onModuleTap(module),
              );
            },
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class MediaThumbnailCard extends StatelessWidget {
  const MediaThumbnailCard({
    super.key,
    required this.title,
    this.subtitle,
    this.durationLabel,
    this.imageAsset,
    this.imageUrl,
    this.accentColor,
    this.icon,
    this.onTap,
    this.compact = false,
    this.width,
  });

  final String title;
  final String? subtitle;
  final String? durationLabel;
  final String? imageAsset;
  final String? imageUrl;
  final Color? accentColor;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool compact;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final accent = accentColor ?? p.accent;
    final cardWidth = width ?? (compact ? 160.0 : double.infinity);

    return SizedBox(
      width: cardWidth,
      child: Material(
        color: p.surface1,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: compact ? 4 / 3 : 16 / 9,
                child: _ThumbnailImage(
                  imageAsset: imageAsset,
                  imageUrl: imageUrl,
                  accent: accent,
                  icon: icon ?? Icons.self_improvement_rounded,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(compact ? AppSpacing.sm : AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (durationLabel != null) ...[
                      Text(
                        durationLabel!,
                        style: AppTypography.micro(p, color: accent),
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                    ],
                    Text(
                      title,
                      style: compact
                          ? AppTypography.cardTitle(p, color: p.ink)
                          : AppTypography.headline(p),
                      maxLines: compact ? 2 : 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        subtitle!,
                        style: AppTypography.bodySm(p),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThumbnailImage extends StatelessWidget {
  const _ThumbnailImage({
    required this.accent,
    required this.icon,
    this.imageAsset,
    this.imageUrl,
  });

  final String? imageAsset;
  final String? imageUrl;
  final Color accent;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;

    Widget child;
    if (imageUrl != null) {
      child = Image.network(
        imageUrl!,
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (_, __, ___) => _placeholder(p),
      );
    } else if (imageAsset != null) {
      child = Image.asset(
        imageAsset!,
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (_, __, ___) => _placeholder(p),
      );
    } else {
      child = _placeholder(p);
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        child,
        if (imageUrl != null || imageAsset != null)
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withValues(alpha: 0.15)],
              ),
            ),
          ),
      ],
    );
  }

  Widget _placeholder(AppPalette p) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accent.withValues(alpha: 0.25),
            p.thumbnailBg,
          ],
        ),
      ),
      child: Center(
        child: Icon(icon, size: 40, color: accent.withValues(alpha: 0.7)),
      ),
    );
  }
}

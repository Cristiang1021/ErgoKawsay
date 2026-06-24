import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../core/theme/app_theme.dart';
import 'flat_illustration.dart';

class MediaHero extends StatefulWidget {
  const MediaHero({
    super.key,
    this.videoUrl,
    this.imageAsset,
    this.imageUrl,
    this.illustrationPreset,
    this.heightFactor = 0.38,
    this.showPlayBadge = true,
  });

  final String? videoUrl;
  final String? imageAsset;
  final String? imageUrl;
  final IllustrationPreset? illustrationPreset;
  final double heightFactor;
  final bool showPlayBadge;

  @override
  State<MediaHero> createState() => _MediaHeroState();
}

class _MediaHeroState extends State<MediaHero> {
  VideoPlayerController? _videoController;
  bool _videoReady = false;
  bool _videoFailed = false;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    final url = widget.videoUrl;
    if (url == null || url.isEmpty) return;

    final controller = VideoPlayerController.networkUrl(Uri.parse(url));
    _videoController = controller;
    try {
      await controller.initialize();
      controller.setLooping(true);
      await controller.play();
      if (mounted) setState(() => _videoReady = true);
    } catch (_) {
      if (mounted) setState(() => _videoFailed = true);
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final height = MediaQuery.sizeOf(context).height * widget.heightFactor;

    return SizedBox(
      height: height,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(AppSpacing.radiusXxl),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            _buildContent(p, height),
            if (widget.showPlayBadge && widget.videoUrl != null && _videoReady)
              Positioned(
                top: AppSpacing.md,
                right: AppSpacing.md,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.play_circle_fill, color: Colors.white, size: 16),
                      const SizedBox(width: 4),
                      Text('Demo', style: AppTypography.micro(p, color: Colors.white)),
                    ],
                  ),
                ),
              ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, p.canvas.withValues(alpha: 0.85)],
                  stops: const [0.5, 1.0],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(AppPalette p, double height) {
    if (_videoReady && _videoController != null && !_videoFailed) {
      return FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: _videoController!.value.size.width,
          height: _videoController!.value.size.height,
          child: VideoPlayer(_videoController!),
        ),
      );
    }

    if (widget.imageUrl != null) {
      return Image.network(
        widget.imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _fallback(p, height),
      );
    }

    if (widget.imageAsset != null) {
      return Image.asset(
        widget.imageAsset!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _fallback(p, height),
      );
    }

    return _fallback(p, height);
  }

  Widget _fallback(AppPalette p, double height) {
    return DecoratedBox(
      decoration: BoxDecoration(gradient: p.heroGradient),
      child: FlatIllustration(
        preset: widget.illustrationPreset ?? IllustrationPreset.home,
        height: height,
        fit: BoxFit.cover,
      ),
    );
  }
}

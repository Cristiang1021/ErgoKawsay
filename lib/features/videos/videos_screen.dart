import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_theme.dart';
import '../../data/local/local_data_repository.dart';
import '../../data/models/video_item.dart';
import '../../shared/widgets/feature_scaffold.dart';

// ── Videos screen ─────────────────────────────────────────────────────────────

class VideosScreen extends StatelessWidget {
  const VideosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final p = context.palette;
    final isKichwa = l10n.isKichwa;
    final videos = LocalDataRepository.instance.videos;

    // Visual config per card (index-based)
    final configs = <_CardConfig>[
      _CardConfig(
        bg: p.blockLilac,
        fg: p.blockLilacText,
        icon: Icons.airline_seat_recline_extra_rounded,
        decoIcon: Icons.chair_alt_rounded,
        category: 'CUERPO',
      ),
      _CardConfig(
        bg: p.blockMint,
        fg: p.blockMintText,
        icon: Icons.self_improvement_rounded,
        decoIcon: Icons.spa_rounded,
        category: 'BIENESTAR',
      ),
    ];

    return FeatureScaffold(
      title: l10n.moduleVideos,
      categoryEyebrow: 'Aprendizaje',
      subtitle: isKichwa
          ? 'Alli kawsay yachachiy rimaykuna.'
          : 'Recursos visuales para tu bienestar docente.',
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screen, AppSpacing.xs, AppSpacing.screen, AppSpacing.xxl,
        ),
        itemCount: videos.length,
        itemBuilder: (context, i) {
          final cfg = configs[i.clamp(0, configs.length - 1)];
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: _CinemaCard(
              video: videos[i],
              isKichwa: isKichwa,
              p: p,
              bg: cfg.bg,
              fg: cfg.fg,
              icon: cfg.icon,
              decoIcon: cfg.decoIcon,
              category: cfg.category,
            ),
          );
        },
      ),
    );
  }
}

class _CardConfig {
  const _CardConfig({
    required this.bg,
    required this.fg,
    required this.icon,
    required this.decoIcon,
    required this.category,
  });
  final Color bg, fg;
  final IconData icon, decoIcon;
  final String category;
}

// ── Cinema card (equal-weight, no competing controllers) ──────────────────────

class _CinemaCard extends StatelessWidget {
  const _CinemaCard({
    required this.video,
    required this.isKichwa,
    required this.p,
    required this.bg,
    required this.fg,
    required this.icon,
    required this.decoIcon,
    required this.category,
  });

  final VideoItem video;
  final bool isKichwa;
  final AppPalette p;
  final Color bg, fg;
  final IconData icon, decoIcon;
  final String category;

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.sizeOf(context).height;
    final cardH = screenH * 0.62;

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        final allVideos = LocalDataRepository.instance.videos;
        final idx = allVideos.indexWhere((v) => v.id == video.id);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VideoPlayerScreen(
              playlist: allVideos,
              initialIndex: idx < 0 ? 0 : idx,
            ),
          ),
        );
      },
      child: Container(
        height: cardH,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // ── Decorative background icons ────────────────────────
            Positioned(
              top: cardH * -0.08,
              right: cardH * -0.12,
              child: Icon(
                decoIcon,
                size: cardH * 0.62,
                color: fg.withValues(alpha: 0.06),
              ),
            ),
            Positioned(
              bottom: cardH * 0.38,
              left: cardH * -0.08,
              child: Icon(
                icon,
                size: cardH * 0.28,
                color: fg.withValues(alpha: 0.04),
              ),
            ),

            // ── Bottom gradient overlay ────────────────────────────
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.transparent,
                      bg.withValues(alpha: 0.55),
                      bg.withValues(alpha: 0.97),
                    ],
                    stops: const [0.0, 0.38, 0.66, 1.0],
                  ),
                ),
              ),
            ),

            // ── Centered play button ───────────────────────────────
            Positioned(
              top: cardH * 0.25,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.94),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: fg.withValues(alpha: 0.22),
                        blurRadius: 28,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.play_arrow_rounded,
                    color: bg,
                    size: 42,
                  ),
                ),
              ),
            ),

            // ── Info overlay at bottom ─────────────────────────────
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Category badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: fg.withValues(alpha: 0.14),
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusPill),
                        border: Border.all(
                          color: fg.withValues(alpha: 0.22),
                        ),
                      ),
                      child: Text(
                        category,
                        style: AppTypography.micro(p, color: fg).copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.3,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),

                    // Title
                    Text(
                      video.title(isKichwa),
                      style: AppTypography.displayMd(p, color: fg),
                    ),
                    const SizedBox(height: AppSpacing.xxs),

                    // Description
                    Text(
                      video.description(isKichwa),
                      style: AppTypography.body(
                          p, color: fg.withValues(alpha: 0.72)),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // CTA pill
                    Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: fg,
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusPill),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.play_arrow_rounded, color: bg, size: 22),
                          const SizedBox(width: AppSpacing.xxs),
                          Text(
                            'Ver video',
                            style: AppTypography.button(p, color: bg),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Video player screen ───────────────────────────────────────────────────────

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({
    super.key,
    required this.playlist,
    required this.initialIndex,
  });

  final List<VideoItem> playlist;
  final int initialIndex;

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late int _currentIndex;
  VideoPlayerController? _controller;
  bool _loading = true;
  bool _error = false;
  bool _showControls = true;
  bool _isFullscreen = false;

  VideoItem get _current => widget.playlist[_currentIndex];
  bool get _hasPrev => _currentIndex > 0;
  bool get _hasNext => _currentIndex < widget.playlist.length - 1;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    try {
      final path = _current.assetPath;
      if (path != null && path.isNotEmpty) {
        _controller = VideoPlayerController.asset(path);
      } else if (_current.url != null) {
        _controller =
            VideoPlayerController.networkUrl(Uri.parse(_current.url!));
      } else {
        if (mounted) setState(() { _loading = false; _error = true; });
        return;
      }
      await _controller!.initialize();
      _controller!.addListener(() {
        if (mounted) setState(() {});
      });
      if (mounted) setState(() => _loading = false);
    } catch (_) {
      if (mounted) setState(() { _loading = false; _error = true; });
    }
  }

  void _goTo(int index) {
    _controller?.dispose();
    _controller = null;
    setState(() {
      _currentIndex = index;
      _loading = true;
      _error = false;
    });
    _initPlayer();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    _controller?.dispose();
    super.dispose();
  }

  void _togglePlay() {
    HapticFeedback.selectionClick();
    if (_controller!.value.isPlaying) {
      _controller!.pause();
    } else {
      _controller!.play();
    }
    _showControlsBriefly();
  }

  void _showControlsBriefly() {
    setState(() => _showControls = true);
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _controller?.value.isPlaying == true) {
        setState(() => _showControls = false);
      }
    });
  }

  void _toggleFullscreen() {
    setState(() => _isFullscreen = !_isFullscreen);
    if (_isFullscreen) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    } else {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: SystemUiOverlay.values,
      );
    }
  }

  String _fmt(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final p = context.palette;
    final isKichwa = l10n.isKichwa;

    if (_isFullscreen && _controller != null && !_error) {
      return _FullscreenPlayer(
        controller: _controller!,
        title: _current.title(isKichwa),
        isKichwa: isKichwa,
        onTogglePlay: _togglePlay,
        onExitFullscreen: _toggleFullscreen,
        showControls: _showControls,
        onTap: _showControlsBriefly,
        fmt: _fmt,
        p: p,
      );
    }

    return Scaffold(
      backgroundColor: p.canvas,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Back + title ─────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screen,
                AppSpacing.md,
                AppSpacing.screen,
                AppSpacing.md,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: p.hairline),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: p.ink,
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'APRENDIZAJE'.toUpperCase(),
                          style: AppTypography.eyebrow(p),
                        ),
                        Text(
                          _current.title(isKichwa),
                          style: AppTypography.headline(p),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Video ────────────────────────────────────────────────
            Expanded(
              child: _loading
                  ? Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: p.accent,
                      ),
                    )
                  : _error
                      ? _ErrorView(
                          video: _current,
                          isKichwa: isKichwa,
                          p: p,
                        )
                      : _PlayerView(
                          controller: _controller!,
                          onTogglePlay: _togglePlay,
                          onFullscreen: _toggleFullscreen,
                          showControls: _showControls,
                          onTap: _showControlsBriefly,
                          fmt: _fmt,
                          p: p,
                        ),
            ),

            // ── Description + prev/next ───────────────────────────────
            if (!_loading && !_error) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screen, AppSpacing.sm,
                  AppSpacing.screen, 0,
                ),
                child: Text(
                  _current.description(isKichwa),
                  style: AppTypography.body(p, color: p.inkMuted),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (widget.playlist.length > 1)
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screen, AppSpacing.md,
                    AppSpacing.screen, AppSpacing.lg,
                  ),
                  child: Row(
                    children: [
                      _NavBtn(
                        icon: Icons.skip_previous_rounded,
                        label: 'Anterior',
                        onTap: _hasPrev
                            ? () {
                                HapticFeedback.selectionClick();
                                _goTo(_currentIndex - 1);
                              }
                            : null,
                        p: p,
                      ),
                      const Spacer(),
                      // Counter chip
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xxs,
                        ),
                        decoration: BoxDecoration(
                          color: p.surface2,
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusPill),
                        ),
                        child: Text(
                          '${_currentIndex + 1} / ${widget.playlist.length}',
                          style: AppTypography.micro(p, color: p.inkMuted),
                        ),
                      ),
                      const Spacer(),
                      _NavBtn(
                        icon: Icons.skip_next_rounded,
                        label: 'Siguiente',
                        onTap: _hasNext
                            ? () {
                                HapticFeedback.selectionClick();
                                _goTo(_currentIndex + 1);
                              }
                            : null,
                        p: p,
                        reverse: true,
                      ),
                    ],
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _NavBtn extends StatelessWidget {
  const _NavBtn({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.p,
    this.reverse = false,
  });
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final AppPalette p;
  final bool reverse;

  @override
  Widget build(BuildContext context) {
    final active = onTap != null;
    final color = active ? p.ink : p.inkMuted.withValues(alpha: 0.3);
    final children = [
      Icon(icon, size: 20, color: color),
      const SizedBox(width: 6),
      Text(label,
          style:
              AppTypography.bodySm(p, color: color).copyWith(fontWeight: FontWeight.w600)),
    ];
    return GestureDetector(
      onTap: onTap,
      child: Row(children: reverse ? children.reversed.toList() : children),
    );
  }
}

// ── Inline player view (portrait) ─────────────────────────────────────────────

class _PlayerView extends StatelessWidget {
  const _PlayerView({
    required this.controller,
    required this.onTogglePlay,
    required this.onFullscreen,
    required this.showControls,
    required this.onTap,
    required this.fmt,
    required this.p,
  });

  final VideoPlayerController controller;
  final VoidCallback onTogglePlay;
  final VoidCallback onFullscreen;
  final bool showControls;
  final VoidCallback onTap;
  final String Function(Duration) fmt;
  final AppPalette p;

  @override
  Widget build(BuildContext context) {
    final pos = controller.value.position;
    final dur = controller.value.duration;
    final progress =
        dur.inMilliseconds > 0 ? pos.inMilliseconds / dur.inMilliseconds : 0.0;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Video frame
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              child: AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    VideoPlayer(controller),
                    AnimatedOpacity(
                      opacity: showControls ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: Container(
                        color: Colors.black.withValues(alpha: 0.35),
                        child: Center(
                          child: GestureDetector(
                            onTap: onTogglePlay,
                            child: Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.9),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                controller.value.isPlaying
                                    ? Icons.pause_rounded
                                    : Icons.play_arrow_rounded,
                                color: Colors.black,
                                size: 32,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Progress + controls
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
            child: Column(
              children: [
                SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: p.ink,
                    inactiveTrackColor: p.hairline,
                    thumbColor: p.ink,
                    overlayColor: Colors.transparent,
                    trackHeight: 3,
                    thumbShape:
                        const RoundSliderThumbShape(enabledThumbRadius: 6),
                  ),
                  child: Slider(
                    value: progress.clamp(0.0, 1.0),
                    onChanged: (v) {
                      final target = Duration(
                          milliseconds: (v * dur.inMilliseconds).round());
                      controller.seekTo(target);
                    },
                  ),
                ),
                Row(
                  children: [
                    Text(fmt(pos), style: AppTypography.micro(p)),
                    const Spacer(),
                    Text(fmt(dur), style: AppTypography.micro(p)),
                    const SizedBox(width: AppSpacing.md),
                    GestureDetector(
                      onTap: onFullscreen,
                      child: Icon(Icons.fullscreen_rounded,
                          color: p.inkMuted, size: 24),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Fullscreen player ─────────────────────────────────────────────────────────

class _FullscreenPlayer extends StatelessWidget {
  const _FullscreenPlayer({
    required this.controller,
    required this.title,
    required this.isKichwa,
    required this.onTogglePlay,
    required this.onExitFullscreen,
    required this.showControls,
    required this.onTap,
    required this.fmt,
    required this.p,
  });

  final VideoPlayerController controller;
  final String title;
  final bool isKichwa;
  final VoidCallback onTogglePlay;
  final VoidCallback onExitFullscreen;
  final bool showControls;
  final VoidCallback onTap;
  final String Function(Duration) fmt;
  final AppPalette p;

  @override
  Widget build(BuildContext context) {
    final pos = controller.value.position;
    final dur = controller.value.duration;
    final progress =
        dur.inMilliseconds > 0 ? pos.inMilliseconds / dur.inMilliseconds : 0.0;

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: onTap,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Center(
              child: AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: VideoPlayer(controller),
              ),
            ),
            AnimatedOpacity(
              opacity: showControls ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xCC000000),
                      Colors.transparent,
                      Colors.transparent,
                      Color(0xCC000000),
                    ],
                    stops: [0, 0.2, 0.7, 1],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.md,
                          AppSpacing.md,
                          AppSpacing.md,
                          0,
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: onExitFullscreen,
                              child: const Icon(
                                Icons.fullscreen_exit_rounded,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Text(
                                title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: GestureDetector(
                            onTap: onTogglePlay,
                            child: Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.9),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                controller.value.isPlaying
                                    ? Icons.pause_rounded
                                    : Icons.play_arrow_rounded,
                                color: Colors.black,
                                size: 36,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.md,
                          0,
                          AppSpacing.md,
                          AppSpacing.md,
                        ),
                        child: Column(
                          children: [
                            SliderTheme(
                              data: const SliderThemeData(
                                activeTrackColor: Colors.white,
                                inactiveTrackColor: Color(0x44FFFFFF),
                                thumbColor: Colors.white,
                                overlayColor: Colors.transparent,
                                trackHeight: 3,
                                thumbShape: RoundSliderThumbShape(
                                    enabledThumbRadius: 6),
                              ),
                              child: Slider(
                                value: progress.clamp(0.0, 1.0),
                                onChanged: (v) {
                                  final t = Duration(
                                      milliseconds:
                                          (v * dur.inMilliseconds).round());
                                  controller.seekTo(t);
                                },
                              ),
                            ),
                            Row(
                              children: [
                                Text(fmt(pos),
                                    style: const TextStyle(
                                        color: Colors.white70, fontSize: 11)),
                                const Spacer(),
                                Text(fmt(dur),
                                    style: const TextStyle(
                                        color: Colors.white70, fontSize: 11)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Error view ────────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  const _ErrorView({
    required this.video,
    required this.isKichwa,
    required this.p,
  });

  final VideoItem video;
  final bool isKichwa;
  final AppPalette p;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
      child: Center(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            color: p.surface2,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: p.hairline,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.video_library_outlined,
                    color: p.inkMuted, size: 28),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                video.title(isKichwa),
                textAlign: TextAlign.center,
                style: AppTypography.cardTitle(p),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                isKichwa
                    ? 'Videoqa manaraq chaninchasqachu'
                    : 'No se pudo cargar el video',
                textAlign: TextAlign.center,
                style: AppTypography.bodySm(p, color: p.inkMuted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

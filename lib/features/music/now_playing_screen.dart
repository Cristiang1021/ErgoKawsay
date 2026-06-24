import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/localization/tr.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/audio_visualizer.dart';
import 'audio_controller.dart';

class NowPlayingScreen extends StatelessWidget {
  const NowPlayingScreen({super.key});

  static void show(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, animation, __) => const NowPlayingScreen(),
        transitionsBuilder: (_, animation, __, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            )),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 380),
      ),
    );
  }

  static IconData _iconFor(String id) {
    switch (id) {
      case 'forest':
        return Icons.forest_rounded;
      case 'rain':
        return Icons.water_drop_rounded;
      case 'energizing':
        return Icons.graphic_eq_rounded;
      default:
        return Icons.music_note_rounded;
    }
  }

  static Color _bgFor(String id) {
    switch (id) {
      case 'forest':
        return const Color(0xFFC8E488); // blockMint
      case 'rain':
        return const Color(0xFFDCE4FF); // blockLilac
      case 'energizing':
        return const Color(0xFFE8F5A8); // blockLime
      default:
        return const Color(0xFFEDE8C8); // blockCream
    }
  }

  static String _labelFor(String id, bool isKichwa) {
    return Tr.nowPlayingLabelForTrack(isKichwa, id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: ListenableBuilder(
        listenable: AudioController.instance,
        builder: (context, _) {
          final ctrl = AudioController.instance;
          final track = ctrl.currentTrack;

          if (track == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.mounted) Navigator.maybePop(context);
            });
            return const SizedBox.shrink();
          }

          final isKichwa =
              Localizations.localeOf(context).languageCode == 'qu';

          return SafeArea(
            child: Column(
              children: [
                _TopBar(isKichwa: isKichwa),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.screen),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // ── Visualizer ──────────────────────────────────
                        AudioVisualizer(
                          isPlaying: ctrl.isPlaying,
                          color: const Color(0xFF97BF06),
                          barCount: 24,
                          maxHeight: 56,
                        ),
                        const SizedBox(height: AppSpacing.xl),

                        // ── Track icon ──────────────────────────────────
                        Container(
                          width: 152,
                          height: 152,
                          decoration: BoxDecoration(
                            color: _bgFor(track.id),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _iconFor(track.id),
                            size: 68,
                            color: const Color(0xFF0D0D0D),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xl),

                        // ── Track info ──────────────────────────────────
                        Text(
                          _labelFor(track.id, isKichwa).toUpperCase(),
                          style: AppTypography.eyebrow(
                            _darkPalette(context),
                            color: Colors.white.withValues(alpha: 0.45),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.xxs),
                        Text(
                          track.title(isKichwa),
                          style: AppTypography.displayMd(
                            _darkPalette(context),
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.xxs),
                        Text(
                          track.description(isKichwa),
                          style: AppTypography.bodySm(
                            _darkPalette(context),
                            color: Colors.white.withValues(alpha: 0.5),
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: AppSpacing.xxl),

                        // ── Progress bar ─────────────────────────────────
                        _ProgressSection(ctrl: ctrl),
                        const SizedBox(height: AppSpacing.xl),

                        // ── Playback controls ────────────────────────────
                        _Controls(ctrl: ctrl, isKichwa: isKichwa),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          );
        },
      ),
    );
  }

  AppPalette _darkPalette(BuildContext context) => context.palette;
}

// ── Top bar ───────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  const _TopBar({required this.isKichwa});
  final bool isKichwa;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen, AppSpacing.md, AppSpacing.screen, AppSpacing.md,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              Navigator.maybePop(context);
            },
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.white,
                size: 26,
              ),
            ),
          ),
          const Spacer(),
          Text(
            Tr.nowPlaying(isKichwa),
            style: AppTypography.eyebrow(
              context.palette,
              color: Colors.white.withValues(alpha: 0.55),
            ),
          ),
          const Spacer(),
          const SizedBox(width: 44), // balance
        ],
      ),
    );
  }
}

// ── Progress section ──────────────────────────────────────────────────────────

class _ProgressSection extends StatelessWidget {
  const _ProgressSection({required this.ctrl});
  final AudioController ctrl;

  @override
  Widget build(BuildContext context) {
    final pos = ctrl.position;
    final dur = ctrl.duration;
    final remaining = dur - pos;

    return Column(
      children: [
        // Slider
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: const Color(0xFF97BF06),
            inactiveTrackColor: Colors.white.withValues(alpha: 0.12),
            thumbColor: Colors.white,
            overlayColor: Colors.transparent,
            trackHeight: 3,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
          ),
          child: Slider(
            value: ctrl.progress,
            onChanged: (v) {
              final target = Duration(
                  milliseconds: (v * dur.inMilliseconds).round());
              ctrl.seek(target);
            },
          ),
        ),
        // Times
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          child: Row(
            children: [
              Text(
                ctrl.formatDuration(pos),
                style: AppTypography.micro(
                  context.palette,
                  color: Colors.white.withValues(alpha: 0.45),
                ),
              ),
              const Spacer(),
              Text(
                '-${ctrl.formatDuration(remaining)}',
                style: AppTypography.micro(
                  context.palette,
                  color: Colors.white.withValues(alpha: 0.45),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Controls ──────────────────────────────────────────────────────────────────

class _Controls extends StatelessWidget {
  const _Controls({required this.ctrl, required this.isKichwa});
  final AudioController ctrl;
  final bool isKichwa;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Previous
        _SecondaryBtn(
          icon: Icons.skip_previous_rounded,
          onTap: ctrl.hasPrevious
              ? () {
                  HapticFeedback.selectionClick();
                  ctrl.previous();
                }
              : null,
        ),
        const SizedBox(width: AppSpacing.xl),

        // Play / Pause (main)
        GestureDetector(
          onTap: () {
            HapticFeedback.mediumImpact();
            ctrl.togglePlayPause();
          },
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.12),
                  blurRadius: 24,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: Icon(
              ctrl.isPlaying
                  ? Icons.pause_rounded
                  : Icons.play_arrow_rounded,
              color: const Color(0xFF0D0D0D),
              size: 40,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.xl),

        // Next
        _SecondaryBtn(
          icon: Icons.skip_next_rounded,
          onTap: ctrl.hasNext
              ? () {
                  HapticFeedback.selectionClick();
                  ctrl.next();
                }
              : null,
        ),
      ],
    );
  }
}

class _SecondaryBtn extends StatelessWidget {
  const _SecondaryBtn({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final active = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: active ? 0.1 : 0.04),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.white.withValues(alpha: active ? 0.85 : 0.25),
          size: 26,
        ),
      ),
    );
  }
}

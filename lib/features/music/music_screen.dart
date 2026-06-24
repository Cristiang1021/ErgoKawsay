import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/localization/tr.dart';
import '../../core/theme/app_theme.dart';
import '../../data/local/local_data_repository.dart';
import '../../data/models/music_track.dart';
import '../../shared/widgets/feature_scaffold.dart';
import 'audio_controller.dart';

class MusicScreen extends StatelessWidget {
  const MusicScreen({super.key});

  static IconData _iconForTrack(String id) {
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isKichwa = l10n.isKichwa;
    final tracks = LocalDataRepository.instance.musicTracks;
    final featured = tracks.first;

    return FeatureScaffold(
      title: l10n.moduleMusic,
      categoryEyebrow: Tr.musicCategory(isKichwa),
      subtitle: Tr.musicSubtitle(isKichwa),
      hideMiniPlayer: true, // controls shown inline
      body: ListenableBuilder(
        listenable: AudioController.instance,
        builder: (context, _) {
          final ctrl = AudioController.instance;
          final p = context.palette;

          return ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screen, 0, AppSpacing.screen, AppSpacing.xxl,
            ),
            children: [
              // ── Ambiente destacado ──────────────────────────────────
              _FeaturedCard(
                track: featured,
                isKichwa: isKichwa,
                ctrl: ctrl,
                p: p,
                icon: _iconForTrack(featured.id),
                playlist: tracks,
              ),
              const SizedBox(height: AppSpacing.xl),

              // ── Lista de ambientes ──────────────────────────────────
              Text(
                Tr.musicAmbientSection(isKichwa).toUpperCase(),
                style: AppTypography.eyebrow(p),
              ),
              const SizedBox(height: AppSpacing.sm),

              ...tracks.map((track) {
                final colors = _colorsForTrack(track.id, p);
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                  child: _AmbientCard(
                    track: track,
                    isKichwa: isKichwa,
                    ctrl: ctrl,
                    p: p,
                    bg: colors.$1,
                    fg: colors.$2,
                    icon: _iconForTrack(track.id),
                    playlist: tracks,
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }

  static (Color, Color) _colorsForTrack(String id, AppPalette p) {
    switch (id) {
      case 'forest':
        return (p.blockLime, p.blockLimeText);
      case 'rain':
        return (p.blockLilac, p.blockLilacText);
      case 'energizing':
        return (p.blockMint, p.blockMintText);
      default:
        return (p.blockCream, p.blockCreamText);
    }
  }
}

// ── Tarjeta destacada ─────────────────────────────────────────────────────────

class _FeaturedCard extends StatelessWidget {
  const _FeaturedCard({
    required this.track,
    required this.isKichwa,
    required this.ctrl,
    required this.p,
    required this.icon,
    required this.playlist,
  });

  final MusicTrack track;
  final bool isKichwa;
  final AudioController ctrl;
  final AppPalette p;
  final IconData icon;
  final List<MusicTrack> playlist;

  bool get _isActive => ctrl.currentTrack?.id == track.id;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: p.blockMint,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Visual + badge row
          Row(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: p.blockMintText.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: p.blockMintText, size: 34),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xxs,
                ),
                decoration: BoxDecoration(
                  color: p.blockMintText.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                ),
                child: Text(
                  Tr.musicRecommended(isKichwa),
                  style: AppTypography.micro(p, color: p.blockMintText),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // Eyebrow
          Text(
            Tr.musicNaturalAmbient(isKichwa).toUpperCase(),
            style: AppTypography.eyebrow(
                p, color: p.blockMintText.withValues(alpha: 0.6)),
          ),
          const SizedBox(height: AppSpacing.xxs),

          // Title
          Text(
            track.title(isKichwa),
            style: AppTypography.displayMd(p, color: p.blockMintText),
          ),
          const SizedBox(height: AppSpacing.xs),

          // Description
          Text(
            track.description(isKichwa),
            style: AppTypography.body(
                p, color: p.blockMintText.withValues(alpha: 0.8)),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            Tr.musicFeaturedDesc(isKichwa),
            style: AppTypography.bodySm(
                p, color: p.blockMintText.withValues(alpha: 0.55)),
          ),

          // Progress bar if active
          if (_isActive) ...[
            const SizedBox(height: AppSpacing.md),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              child: LinearProgressIndicator(
                value: ctrl.progress,
                backgroundColor: p.blockMintText.withValues(alpha: 0.15),
                valueColor:
                    AlwaysStoppedAnimation<Color>(p.blockMintText),
                minHeight: 3,
              ),
            ),
            const SizedBox(height: AppSpacing.xxs),
            Row(
              children: [
                Text(
                  ctrl.formatDuration(ctrl.position),
                  style: AppTypography.micro(
                      p, color: p.blockMintText.withValues(alpha: 0.5)),
                ),
                const Spacer(),
                Text(
                  ctrl.formatDuration(ctrl.duration),
                  style: AppTypography.micro(
                      p, color: p.blockMintText.withValues(alpha: 0.5)),
                ),
              ],
            ),
          ],
          const SizedBox(height: AppSpacing.lg),

          // CTA button
          GestureDetector(
            onTap: () {
              HapticFeedback.mediumImpact();
              if (_isActive) {
                ctrl.togglePlayPause();
              } else {
                ctrl.playTrack(track, playlist: playlist);
              }
            },
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: p.blockMintText,
                borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _isActive && ctrl.isPlaying
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                    color: p.blockMint,
                    size: 22,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    _isActive && ctrl.isPlaying
                        ? Tr.pick(isKichwa, 'Pausar', 'Sayachiy')
                        : Tr.musicPlay(isKichwa),
                    style: AppTypography.button(p, color: p.blockMint),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Tarjeta de ambiente (lista) ───────────────────────────────────────────────

class _AmbientCard extends StatelessWidget {
  const _AmbientCard({
    required this.track,
    required this.isKichwa,
    required this.ctrl,
    required this.p,
    required this.bg,
    required this.fg,
    required this.icon,
    required this.playlist,
  });

  final MusicTrack track;
  final bool isKichwa;
  final AudioController ctrl;
  final AppPalette p;
  final Color bg;
  final Color fg;
  final IconData icon;
  final List<MusicTrack> playlist;

  bool get _isActive => ctrl.currentTrack?.id == track.id;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        if (_isActive) {
          ctrl.togglePlayPause();
        } else {
          ctrl.playTrack(track, playlist: playlist);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: _isActive ? p.ink : bg,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Icon
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: (_isActive ? Colors.white : fg)
                        .withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isActive && ctrl.isPlaying
                        ? Icons.pause_rounded
                        : icon,
                    color: _isActive ? Colors.white : fg,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                // Name + description
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        track.title(isKichwa),
                        style: AppTypography.body(
                          p,
                          color: _isActive ? Colors.white : fg,
                        ).copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        track.description(isKichwa),
                        style: AppTypography.bodySm(
                          p,
                          color: (_isActive ? Colors.white : fg)
                              .withValues(alpha: 0.7),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Active indicator dot
                if (_isActive && ctrl.isPlaying)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF97BF06),
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
            // Progress bar when active
            if (_isActive) ...[
              const SizedBox(height: AppSpacing.sm),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                child: LinearProgressIndicator(
                  value: ctrl.progress,
                  backgroundColor: Colors.white.withValues(alpha: 0.15),
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(Color(0xFF97BF06)),
                  minHeight: 2,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

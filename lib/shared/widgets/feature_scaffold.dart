import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_theme.dart';
import '../../features/music/audio_controller.dart';
import 'framer/framer_buttons.dart';
import 'mini_audio_player.dart';

class FeatureScaffold extends StatelessWidget {
  const FeatureScaffold({
    super.key,
    required this.title,
    required this.body,
    this.subtitle,
    this.categoryEyebrow,
    this.moduleId,
    this.floatingActionButton,
    this.actions,
    this.hideMiniPlayer = false,
  });

  final String title;
  final String? subtitle;
  final String? categoryEyebrow;
  final String? moduleId;
  final Widget body;
  final Widget? floatingActionButton;
  final List<Widget>? actions;
  final bool hideMiniPlayer;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final top = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: p.canvas,
      floatingActionButton: floatingActionButton,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Header ────────────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.screen,
              top + AppSpacing.md,
              AppSpacing.screen,
              AppSpacing.lg,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FramerIconButton(
                  icon: Icons.arrow_back_ios_new_rounded,
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    Navigator.maybePop(context);
                  },
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (categoryEyebrow != null) ...[
                        Text(
                          categoryEyebrow!.toUpperCase(),
                          style: AppTypography.eyebrow(p),
                        ),
                        const SizedBox(height: AppSpacing.xxs),
                      ],
                      Text(title, style: AppTypography.displayMd(p)),
                      if (subtitle != null) ...[
                        const SizedBox(height: AppSpacing.xxs),
                        Text(subtitle!, style: AppTypography.bodySm(p)),
                      ],
                    ],
                  ),
                ),
                if (actions != null) ...actions!,
              ],
            ),
          ),

          // ── Content ───────────────────────────────────────────────────
          Expanded(child: body),

          // ── Mini audio player (global, shows when audio is active) ────
          if (!hideMiniPlayer)
            ListenableBuilder(
              listenable: AudioController.instance,
              builder: (ctx, _) {
                final ctrl = AudioController.instance;
                if (!ctrl.hasActiveTrack) return const SizedBox.shrink();
                return MiniAudioPlayer(ctrl: ctrl);
              },
            ),
        ],
      ),
    );
  }
}

class AppScreenBackground extends StatelessWidget {
  const AppScreenBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(color: context.palette.canvas, child: child);
  }
}

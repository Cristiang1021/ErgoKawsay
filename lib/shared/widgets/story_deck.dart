import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_theme.dart';

class StorySlide {
  const StorySlide({
    required this.bg,
    required this.fg,
    required this.visual,
    this.eyebrow,
    required this.title,
    this.body,
    this.bodyWidget,
    this.action,
    this.badge,
    this.compact = false,
  });

  final Color bg;
  final Color fg;
  final Widget visual;
  final String? eyebrow;
  final String title;
  final String? body;
  final Widget? bodyWidget;
  final Widget? action;
  final String? badge;
  final bool compact;
}

class StoryDeck extends StatefulWidget {
  const StoryDeck({
    super.key,
    required this.slides,
    this.onComplete,
  });

  final List<StorySlide> slides;
  final VoidCallback? onComplete;

  @override
  State<StoryDeck> createState() => _StoryDeckState();
}

class _StoryDeckState extends State<StoryDeck> {
  final PageController _controller = PageController();
  int _current = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goToPage(int page) {
    HapticFeedback.selectionClick();
    _controller.animateToPage(
      page,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final total = widget.slides.length;

    return Column(
      children: [
        // Progress bars
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screen, AppSpacing.sm, AppSpacing.screen, AppSpacing.xs,
          ),
          child: Row(
            children: List.generate(total, (i) {
              final isActive = i == _current;
              final isDone = i < _current;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: i < total - 1 ? 4 : 0),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    height: 3,
                    decoration: BoxDecoration(
                      color: isDone || isActive ? p.ink : p.hairline,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),

        // Swipeable slides
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapUp: (details) {
              final width = context.size?.width ?? 375;
              if (details.localPosition.dx < width * 0.3) {
                if (_current > 0) _goToPage(_current - 1);
              } else if (details.localPosition.dx > width * 0.7) {
                if (_current < total - 1) {
                  _goToPage(_current + 1);
                } else {
                  widget.onComplete?.call();
                }
              }
            },
            child: PageView.builder(
              controller: _controller,
              physics: const BouncingScrollPhysics(),
              onPageChanged: (i) => setState(() => _current = i),
              itemCount: total,
              itemBuilder: (context, index) => _SlideView(
                slide: widget.slides[index],
                index: index,
                total: total,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SlideView extends StatelessWidget {
  const _SlideView({
    required this.slide,
    required this.index,
    required this.total,
  });

  final StorySlide slide;
  final int index;
  final int total;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;

    return Container(
      color: slide.bg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Visual area (smaller when compact)
          Expanded(
            flex: slide.compact ? 18 : 42,
            child: Center(child: slide.visual),
          ),

          // Content area
          Expanded(
            flex: slide.compact ? 82 : 58,
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.screen,
                AppSpacing.md,
                AppSpacing.screen,
                AppSpacing.xl + MediaQuery.paddingOf(context).bottom,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge chip
                  if (slide.badge != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xxs,
                      ),
                      decoration: BoxDecoration(
                        color: slide.fg.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                      ),
                      child: Text(
                        slide.badge!,
                        style: AppTypography.caption(p, color: slide.fg),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                  ],

                  // Eyebrow
                  if (slide.eyebrow != null) ...[
                    Text(
                      slide.eyebrow!.toUpperCase(),
                      style: AppTypography.eyebrow(
                        p,
                        color: slide.fg.withValues(alpha: 0.55),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                  ],

                  // Title
                  Text(
                    slide.title,
                    style: AppTypography.displayMd(p, color: slide.fg),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Body
                  if (slide.bodyWidget != null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    slide.bodyWidget!,
                  ] else if (slide.body != null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      slide.body!,
                      style: AppTypography.body(
                        p,
                        color: slide.fg.withValues(alpha: 0.78),
                      ),
                    ),
                  ],

                  // Action widget
                  if (slide.action != null) ...[
                    const SizedBox(height: AppSpacing.lg),
                    slide.action!,
                  ],

                  // Counter
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    '${index + 1} / $total',
                    style: AppTypography.micro(
                      p,
                      color: slide.fg.withValues(alpha: 0.35),
                    ),
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

// ─── Shared visual helpers ───────────────────────────────────────────────────

class StoryIconVisual extends StatelessWidget {
  const StoryIconVisual({
    super.key,
    required this.icon,
    required this.fg,
    this.size = 56.0,
    this.circleSize = 120.0,
  });

  final IconData icon;
  final Color fg;
  final double size;
  final double circleSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: circleSize,
      height: circleSize,
      decoration: BoxDecoration(
        color: fg.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: size, color: fg),
    );
  }
}

class StoryNumberVisual extends StatelessWidget {
  const StoryNumberVisual({
    super.key,
    required this.number,
    required this.fg,
  });

  final int number;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        color: fg.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '$number',
          style: TextStyle(
            fontSize: 64,
            fontWeight: FontWeight.w700,
            color: fg,
            height: 1.0,
            letterSpacing: -2,
          ),
        ),
      ),
    );
  }
}

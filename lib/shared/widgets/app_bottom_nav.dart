import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_theme.dart';

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.labels,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<String> labels;

  static const _icons = [
    Icons.home_outlined,
    Icons.spa_outlined,
    Icons.settings_outlined,
  ];

  static const _iconsSelected = [
    Icons.home_rounded,
    Icons.spa_rounded,
    Icons.settings_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screen,
        AppSpacing.sm,
        AppSpacing.screen,
        bottom + AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: p.canvas,
        border: Border(top: BorderSide(color: p.hairline, width: 1)),
      ),
      child: Row(
        children: List.generate(labels.length, (i) {
          final selected = currentIndex == i;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                onTap(i);
              },
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                decoration: BoxDecoration(
                  color: selected ? p.ink : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      selected ? _iconsSelected[i] : _icons[i],
                      color: selected ? p.canvas : p.inkMuted,
                      size: 22,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      labels[i],
                      style: AppTypography.micro(
                        p,
                        color: selected ? p.canvas : p.inkMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

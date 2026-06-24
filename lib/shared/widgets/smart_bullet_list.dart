import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

/// Renders a list of `\n`-separated lines as bullet points.
/// Lines with a short "Label: description" pattern are displayed with
/// the label in bold and the description on a separate indented line.
class SmartBulletList extends StatelessWidget {
  const SmartBulletList({
    super.key,
    required this.text,
    required this.p,
    required this.fg,
  });

  final String text;
  final AppPalette p;
  final Color fg;

  // Threshold: if the text before ":" is ≤ this many chars → treat as label.
  static const int _labelMaxLen = 35;

  @override
  Widget build(BuildContext context) {
    final lines = text
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();

    if (lines.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.map((line) => _BulletItem(
            line: line,
            p: p,
            fg: fg,
            labelMaxLen: _labelMaxLen,
          )).toList(),
    );
  }
}

class _BulletItem extends StatelessWidget {
  const _BulletItem({
    required this.line,
    required this.p,
    required this.fg,
    required this.labelMaxLen,
  });

  final String line;
  final AppPalette p;
  final Color fg;
  final int labelMaxLen;

  @override
  Widget build(BuildContext context) {
    final colonIdx = line.indexOf(':');
    final isLabelFormat =
        colonIdx > 0 && colonIdx <= labelMaxLen;

    final bodyStyle = AppTypography.body(p, color: fg);

    if (isLabelFormat) {
      final label = line.substring(0, colonIdx).trim();
      final desc = line.substring(colonIdx + 1).trim();
      final boldStyle =
          bodyStyle.copyWith(fontWeight: FontWeight.w700);

      return Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• ', style: bodyStyle),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: boldStyle),
                  if (desc.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      desc,
                      style: bodyStyle.copyWith(
                          color: fg.withValues(alpha: 0.82)),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      );
    }

    // Plain bullet
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: bodyStyle),
          Expanded(child: Text(line, style: bodyStyle)),
        ],
      ),
    );
  }
}

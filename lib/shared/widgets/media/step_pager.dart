import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class StepPager extends StatefulWidget {
  const StepPager({
    super.key,
    required this.steps,
    required this.stepLabel,
    this.onPageChanged,
  });

  final List<String> steps;
  final String Function(int current, int total) stepLabel;
  final ValueChanged<int>? onPageChanged;

  @override
  State<StepPager> createState() => _StepPagerState();
}

class _StepPagerState extends State<StepPager> {
  late final PageController _controller;
  int _current = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final total = widget.steps.length;

    return Column(
      children: [
        Text(
          widget.stepLabel(_current + 1, total),
          style: AppTypography.eyebrow(p),
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: 100,
          child: PageView.builder(
            controller: _controller,
            itemCount: total,
            onPageChanged: (i) {
              setState(() => _current = i);
              widget.onPageChanged?.call(i);
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Center(
                  child: Text(
                    widget.steps[index],
                    textAlign: TextAlign.center,
                    style: AppTypography.bodyLg(p),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(total, (i) {
            final active = i == _current;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: active ? 18 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: active ? p.accent : p.surface2,
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
      ],
    );
  }
}

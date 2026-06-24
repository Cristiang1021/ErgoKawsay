import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/services/notification_service.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/reminder_settings.dart';
import '../../features/language/splash_screen.dart';
import '../../shared/widgets/feature_scaffold.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  late ReminderSettings _settings;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    final storage = StorageServiceScope.of(context);
    setState(() {
      _settings = storage.getReminderSettings();
      _loading = false;
    });
  }

  Future<void> _save() async {
    HapticFeedback.lightImpact();
    final storage = StorageServiceScope.of(context);
    await storage.saveReminderSettings(_settings);
    final locale = StorageServiceScope.of(context).getLanguage() ?? 'es';
    await NotificationService.instance.scheduleReminders(_settings, locale);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context).save),
        backgroundColor: context.palette.ink,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final p = context.palette;

    if (_loading) {
      return Scaffold(
        backgroundColor: p.canvas,
        body: Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2, color: p.ink),
          ),
        ),
      );
    }

    return FeatureScaffold(
      title: l10n.moduleReminders,
      categoryEyebrow: l10n.isKichwa ? 'Yuyariykuna' : 'Configuración',
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screen,
          vertical: AppSpacing.md,
        ),
        children: [
          // Active toggle
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: _settings.notificationsActive ? p.ink : p.surface2,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: _settings.notificationsActive
                  ? null
                  : Border.all(color: p.hairline),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.remindersActive,
                        style: AppTypography.body(
                          p,
                          color: _settings.notificationsActive
                              ? p.primaryBtnFg
                              : p.ink,
                        ).copyWith(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        l10n.isKichwa
                            ? 'Willachiy uyariy'
                            : 'Activar notificaciones',
                        style: AppTypography.bodySm(
                          p,
                          color: _settings.notificationsActive
                              ? p.primaryBtnFg.withValues(alpha: 0.6)
                              : p.inkMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    setState(() {
                      _settings = _settings.copyWith(
                        notificationsActive: !_settings.notificationsActive,
                      );
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 48,
                    height: 28,
                    decoration: BoxDecoration(
                      color: _settings.notificationsActive
                          ? p.primaryBtnFg
                          : p.hairline,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                    ),
                    child: Align(
                      alignment: _settings.notificationsActive
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        width: 22,
                        height: 22,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          color: _settings.notificationsActive
                              ? p.ink
                              : p.primaryBtnFg,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          if (_settings.notificationsActive) ...[
            const SizedBox(height: AppSpacing.lg),

            // Break frequency
            Text(
              l10n.breakFrequency.toUpperCase(),
              style: AppTypography.eyebrow(p),
            ),
            const SizedBox(height: AppSpacing.sm),
            _PillSelector<int>(
              options: const [30, 60, 120, 180],
              selected: _settings.breakFrequencyMinutes,
              label: (v) => v < 60 ? '$v min' : '${v ~/ 60} h',
              onSelected: (v) =>
                  setState(() => _settings = _settings.copyWith(breakFrequencyMinutes: v)),
              p: p,
            ),

            const SizedBox(height: AppSpacing.lg),

            // Daily exercise hour
            Text(
              l10n.dailyExercise.toUpperCase(),
              style: AppTypography.eyebrow(p),
            ),
            const SizedBox(height: AppSpacing.sm),
            _PillSelector<int>(
              options: const [6, 7, 8],
              selected: _settings.dailyExerciseHour,
              label: (v) => '${v.toString().padLeft(2, '0')}:00',
              onSelected: (v) =>
                  setState(() => _settings = _settings.copyWith(dailyExerciseHour: v)),
              p: p,
            ),

            const SizedBox(height: AppSpacing.lg),

            // Night silence info block
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: p.blockNavy,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: Row(
                children: [
                  Icon(Icons.nightlight_round, color: p.blockNavyText, size: 22),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.nightSilence,
                          style: AppTypography.body(p, color: p.blockNavyText)
                              .copyWith(fontWeight: FontWeight.w700),
                        ),
                        Text(
                          l10n.nightSilenceDesc,
                          style: AppTypography.bodySm(
                              p, color: p.blockNavyText.withValues(alpha: 0.7)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: AppSpacing.xl),

          // Save button
          GestureDetector(
            onTap: _save,
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: p.ink,
                borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
              ),
              alignment: Alignment.center,
              child: Text(
                l10n.save,
                style: AppTypography.button(p, color: p.primaryBtnFg),
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}

class _PillSelector<T> extends StatelessWidget {
  const _PillSelector({
    required this.options,
    required this.selected,
    required this.label,
    required this.onSelected,
    required this.p,
  });

  final List<T> options;
  final T selected;
  final String Function(T) label;
  final ValueChanged<T> onSelected;
  final AppPalette p;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: options.map((opt) {
        final isSelected = opt == selected;
        return Padding(
          padding: const EdgeInsets.only(right: AppSpacing.xs),
          child: GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              onSelected(opt);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: isSelected ? p.ink : Colors.transparent,
                borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                border: Border.all(
                  color: isSelected ? p.ink : p.hairline,
                ),
              ),
              child: Text(
                label(opt),
                style: AppTypography.body(
                  p,
                  color: isSelected ? p.primaryBtnFg : p.ink,
                ).copyWith(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

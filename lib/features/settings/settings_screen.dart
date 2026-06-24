import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/constants/app_assets.dart';
import '../../core/constants/app_constants.dart';
import '../../core/localization/accessibility_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/localization/theme_controller.dart';
import '../../core/services/notification_service.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/accessibility_settings.dart';
import '../../data/models/reminder_settings.dart';
import '../../core/localization/tr.dart';
import '../../features/language/language_selection_screen.dart';
import '../../features/language/splash_screen.dart';
import '../../features/teacher_profile/teacher_profile_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, this.embedded = false});

  final bool embedded;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _initialized = false;
  late bool _notificationsEnabled;
  late ReminderSettings _reminders;
  late AccessibilitySettings _accessibility;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final s = StorageServiceScope.of(context);
      _notificationsEnabled = s.notificationsEnabled;
      _reminders = s.getReminderSettings();
      _accessibility = s.getAccessibilitySettings();
    }
  }

  Future<void> _saveReminders(ReminderSettings r) async {
    setState(() => _reminders = r);
    final s = StorageServiceScope.of(context);
    await s.saveReminderSettings(r);
    final locale = s.getLanguage() ?? 'es';
    if (r.notificationsActive && s.notificationsEnabled) {
      await NotificationService.instance.scheduleReminders(r, locale);
    } else {
      await NotificationService.instance.cancelAll();
    }
  }

  Future<void> _saveA11y(AccessibilitySettings a) async {
    setState(() => _accessibility = a);
    await AccessibilityControllerScope.of(context).updateSettings(a);
  }

  Future<void> _toggleNotifications(bool v) async {
    setState(() => _notificationsEnabled = v);
    await StorageServiceScope.of(context).setNotificationsEnabled(v);
    await _saveReminders(_reminders.copyWith(notificationsActive: v));
  }

  Future<void> _sendTestNotification() async {
    final locale = StorageServiceScope.of(context).getLanguage() ?? 'es';
    await NotificationService.instance.showTestNotification(locale);
    if (!mounted) return;
    final p = context.palette;
    final isKichwa = AppLocalizations.of(context).isKichwa;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          Tr.settingsNotificationSent(isKichwa),
          style: AppTypography.body(p, color: p.canvas),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _showScheduleSheet(bool isKichwa) async {
    final p = context.palette;
    var start = _reminders.workStartHour;
    var end = _reminders.workEndHour;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: p.surface1,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.screen,
            AppSpacing.lg,
            AppSpacing.screen,
            AppSpacing.lg + MediaQuery.paddingOf(ctx).bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Tr.scheduleSheetTitle(isKichwa),
                style: AppTypography.eyebrow(p),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                Tr.scheduleSheetDesc(isKichwa),
                style: AppTypography.bodySm(p),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: _TimeButton(
                      label: Tr.scheduleSheetStart(isKichwa),
                      hour: start,
                      palette: p,
                      onTap: () async {
                        final t = await showTimePicker(
                          context: ctx,
                          initialTime: TimeOfDay(hour: start, minute: 0),
                          initialEntryMode: TimePickerEntryMode.input,
                          builder: (c, child) => Localizations.override(
                            context: c,
                            locale: const Locale('es'),
                            child: MediaQuery(
                              data: MediaQuery.of(c).copyWith(
                                  alwaysUse24HourFormat: true),
                              child: child!,
                            ),
                          ),
                        );
                        if (t != null) setSheet(() => start = t.hour);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md),
                    child: Text('–',
                        style: AppTypography.headline(p, color: p.inkMuted)),
                  ),
                  Expanded(
                    child: _TimeButton(
                      label: Tr.scheduleSheetEnd(isKichwa),
                      hour: end,
                      palette: p,
                      onTap: () async {
                        final t = await showTimePicker(
                          context: ctx,
                          initialTime: TimeOfDay(hour: end, minute: 0),
                          initialEntryMode: TimePickerEntryMode.input,
                          builder: (c, child) => Localizations.override(
                            context: c,
                            locale: const Locale('es'),
                            child: MediaQuery(
                              data: MediaQuery.of(c).copyWith(
                                  alwaysUse24HourFormat: true),
                              child: child!,
                            ),
                          ),
                        );
                        if (t != null) setSheet(() => end = t.hour);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () async {
                    Navigator.pop(ctx);
                    await _saveReminders(_reminders.copyWith(
                        workStartHour: start, workEndHour: end));
                  },
                  child: Text(Tr.scheduleSheetSave(isKichwa)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showFrequencySheet(bool isKichwa) async {
    final p = context.palette;
    final options = [
      (30, Tr.freqEvery30(isKichwa)),
      (45, Tr.freqEvery45(isKichwa)),
      (60, Tr.freqEvery60(isKichwa)),
      (-1, Tr.freqCustom(isKichwa)),
    ];
    int? customMinutes;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: p.surface1,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) {
          final isCustomSelected =
              !options.sublist(0, 3).any((o) => o.$1 == _reminders.breakFrequencyMinutes);
          return Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.screen,
              AppSpacing.lg,
              AppSpacing.screen,
              AppSpacing.lg + MediaQuery.paddingOf(ctx).bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Tr.freqSheetTitle(isKichwa).toUpperCase(),
                  style: AppTypography.eyebrow(p),
                ),
                const SizedBox(height: AppSpacing.md),
                ...options.map((o) {
                  final isCustomOption = o.$1 == -1;
                  final selected = isCustomOption
                      ? isCustomSelected
                      : _reminders.breakFrequencyMinutes == o.$1;
                  return GestureDetector(
                    onTap: () async {
                      HapticFeedback.selectionClick();
                      if (isCustomOption) {
                        setSheet(() {
                          customMinutes =
                              isCustomSelected ? _reminders.breakFrequencyMinutes : 45;
                        });
                      } else {
                        Navigator.pop(ctx);
                        await _saveReminders(
                            _reminders.copyWith(breakFrequencyMinutes: o.$1));
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: AppSpacing.xs),
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg, vertical: AppSpacing.md),
                      decoration: BoxDecoration(
                        color: selected ? p.ink : p.surface2,
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusMd),
                        border: Border.all(
                            color: selected ? p.ink : p.hairline),
                      ),
                      child: Text(
                        o.$2,
                        style: AppTypography.body(
                            p, color: selected ? p.canvas : p.ink),
                      ),
                    ),
                  );
                }),
                if (customMinutes != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Expanded(
                        child: Slider(
                          value: customMinutes!.toDouble(),
                          min: 10,
                          max: 120,
                          divisions: 22,
                          label: '$customMinutes min',
                          onChanged: (v) =>
                              setSheet(() => customMinutes = v.round()),
                        ),
                      ),
                      SizedBox(
                        width: 60,
                        child: Text('$customMinutes min',
                            style: AppTypography.caption(p),
                            textAlign: TextAlign.center),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () async {
                        Navigator.pop(ctx);
                        await _saveReminders(_reminders.copyWith(
                            breakFrequencyMinutes: customMinutes,
                            customFrequencyMinutes: customMinutes));
                      },
                      child: Text(Tr.freqSave(isKichwa)),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _showTypesSheet(bool isKichwa) async {
    final p = context.palette;
    final types = [
      ('neck', Tr.typeNeck(isKichwa)),
      ('shoulders', Tr.typeShoulders(isKichwa)),
      ('vision', Tr.typeVision(isKichwa)),
      ('breathing', Tr.typeBreathing(isKichwa)),
      ('hydration', Tr.typeHydration(isKichwa)),
    ];
    var current = List<String>.from(_reminders.reminderTypes);

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: p.surface1,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.screen,
            AppSpacing.lg,
            AppSpacing.screen,
            AppSpacing.lg + MediaQuery.paddingOf(ctx).bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Tr.settingsReminderTypes(isKichwa).toUpperCase(),
                style: AppTypography.eyebrow(p),
              ),
              const SizedBox(height: AppSpacing.md),
              ...types.map((t) {
                final enabled = current.contains(t.$1);
                return GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    setSheet(() {
                      if (enabled) {
                        current.remove(t.$1);
                      } else {
                        current.add(t.$1);
                      }
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: AppSpacing.xs),
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg, vertical: AppSpacing.md),
                    decoration: BoxDecoration(
                      color: p.surface2,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      border: Border.all(color: p.hairline),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(t.$2, style: AppTypography.body(p))),
                        Icon(
                          enabled
                              ? Icons.check_box_rounded
                              : Icons.check_box_outline_blank_rounded,
                          color: enabled ? p.ink : p.hairline,
                          size: 22,
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () async {
                    Navigator.pop(ctx);
                    await _saveReminders(
                        _reminders.copyWith(reminderTypes: current));
                  },
                  child: Text(Tr.freqSave(isKichwa)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showTextSizeSheet(bool isKichwa) async {
    final p = context.palette;
    final opts = [
      (TextSizeOption.normal, Tr.textSizeNormal(isKichwa)),
      (TextSizeOption.large, Tr.textSizeLarge(isKichwa)),
      (TextSizeOption.extraLarge, Tr.textSizeXLarge(isKichwa)),
    ];
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: p.surface1,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screen,
          AppSpacing.lg,
          AppSpacing.screen,
          AppSpacing.lg + MediaQuery.paddingOf(ctx).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Tr.settingsTextSize(isKichwa).toUpperCase(),
              style: AppTypography.eyebrow(p),
            ),
            const SizedBox(height: AppSpacing.md),
            ...opts.map((o) {
              final selected = _accessibility.textSize == o.$1;
              return GestureDetector(
                onTap: () async {
                  Navigator.pop(ctx);
                  await _saveA11y(
                      _accessibility.copyWith(textSize: o.$1));
                },
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: AppSpacing.xs),
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg, vertical: AppSpacing.md),
                  decoration: BoxDecoration(
                    color: selected ? p.ink : p.surface2,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    border: Border.all(
                        color: selected ? p.ink : p.hairline),
                  ),
                  child: Text(
                    o.$2,
                    style: AppTypography.body(
                        p, color: selected ? p.canvas : p.ink),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Future<void> _resetLanguage(AppLocalizations l10n) async {
    final p = context.palette;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: p.surface1,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg)),
        title: Text(l10n.changeLanguage, style: AppTypography.headline(p)),
        content: Text(
          l10n.isKichwa
              ? '¿Shimita musuqta akllay?'
              : '¿Volver a la pantalla de idioma?',
          style: AppTypography.body(p, color: p.inkMuted),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l10n.back)),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.continueBtn,
                style:
                    TextStyle(color: p.ink, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    await StorageServiceScope.of(context).clearLanguage();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/language', (_) => false);
  }

  String _freqLabel(bool isKichwa) {
    final m = _reminders.breakFrequencyMinutes;
    return Tr.freqLabel(isKichwa, m);
  }

  String _timeLabel(int h) => '${h.toString().padLeft(2, '0')}:00';

  String _typesLabel(bool isKichwa) {
    final n = _reminders.reminderTypes.length;
    final total = ReminderSettings.allTypes.length;
    return Tr.typesLabel(isKichwa, n, total);
  }

  String _textSizeLabel(bool isKichwa) => switch (_accessibility.textSize) {
        TextSizeOption.normal => Tr.textSizeNormal(isKichwa),
        TextSizeOption.large => Tr.textSizeLarge(isKichwa),
        TextSizeOption.extraLarge => Tr.textSizeXLarge(isKichwa),
      };

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final p = context.palette;
    final isKichwa = l10n.isKichwa;
    final themeMode = ThemeControllerScope.of(context).themeMode;
    final storage = StorageServiceScope.of(context);
    final lang = storage.getLanguage() ?? AppConstants.langSpanish;

    final bottomPad = MediaQuery.paddingOf(context).bottom;
    final body = ListView(
      padding: EdgeInsets.fromLTRB(
          AppSpacing.screen, 0, AppSpacing.screen, AppSpacing.xxl + bottomPad),
      children: [

        // ── PERFIL ───────────────────────────────────────────────────────
        _Section(label: isKichwa ? 'RIKUCHI' : 'PERFIL'),
        _Row(
          title: Tr.profileEditProfile(isKichwa),
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                fullscreenDialog: true,
                builder: (_) => const TeacherProfileScreen(fromSettings: true),
              ),
            );
            if (mounted) setState(() {});
          },
        ),
        const SizedBox(height: AppSpacing.xl),

        // ── APARIENCIA ───────────────────────────────────────────────────
        _Section(label: Tr.settingsAppearance(isKichwa)),
        _ThemeSelector(
          current: themeMode,
          isKichwa: isKichwa,
          onChanged: (m) =>
              ThemeControllerScope.of(context).setThemeMode(m),
        ),
        const SizedBox(height: AppSpacing.xl),

        // ── IDIOMA ───────────────────────────────────────────────────────
        _Section(label: Tr.settingsLanguageSection(isKichwa)),
        _Row(
          title: l10n.changeLanguage,
          value: lang == AppConstants.langKichwa ? 'Kichwa' : 'Español',
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                fullscreenDialog: true,
                builder: (_) =>
                    const LanguageSelectionScreen(fromSettings: true),
              ),
            );
            if (mounted) setState(() {});
          },
        ),
        _Row(
          title: Tr.settingsResetLanguage(isKichwa),
          onTap: () => _resetLanguage(l10n),
          destructive: true,
        ),
        const SizedBox(height: AppSpacing.xl),

        // ── PAUSAS ACTIVAS ───────────────────────────────────────────────
        _Section(label: isKichwa ? 'Llamkaypi samariy' : 'PAUSAS ACTIVAS'),
        _ToggleRow(
          title: Tr.settingsActivateReminders(isKichwa),
          value: _notificationsEnabled,
          onChanged: _toggleNotifications,
        ),
        if (_notificationsEnabled) ...[
          _Row(
            title: Tr.settingsWorkSchedule(isKichwa),
            value:
                '${_timeLabel(_reminders.workStartHour)} – ${_timeLabel(_reminders.workEndHour)}',
            onTap: () => _showScheduleSheet(isKichwa),
          ),
          _Row(
            title: Tr.settingsFrequency(isKichwa),
            value: _freqLabel(isKichwa),
            onTap: () => _showFrequencySheet(isKichwa),
          ),
          _Row(
            title: Tr.settingsReminderTypes(isKichwa),
            value: _typesLabel(isKichwa),
            onTap: () => _showTypesSheet(isKichwa),
          ),
          _Row(
            title: Tr.settingsTestNotification(isKichwa),
            onTap: _sendTestNotification,
          ),
        ],
        const SizedBox(height: AppSpacing.xl),

        // ── ACCESIBILIDAD ────────────────────────────────────────────────
        _Section(label: Tr.settingsAccessibility(isKichwa)),
        _Row(
          title: Tr.settingsTextSize(isKichwa),
          value: _textSizeLabel(isKichwa),
          onTap: () => _showTextSizeSheet(isKichwa),
        ),
        _ToggleRow(
          title: Tr.settingsColorBlind(isKichwa),
          value: _accessibility.colorBlind,
          onChanged: (v) =>
              _saveA11y(_accessibility.copyWith(colorBlind: v)),
        ),
        const SizedBox(height: AppSpacing.xl),

        // ── INFORMACIÓN ──────────────────────────────────────────────────
        _Section(label: Tr.settingsInfo(isKichwa)),
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: p.surface2,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(color: p.hairline),
          ),
          child: Column(
            children: [
              Image.asset(AppAssets.logo, height: 52, fit: BoxFit.contain),
              const SizedBox(height: AppSpacing.md),
              Text(AppConstants.appName,
                  style: AppTypography.cardTitle(p),
                  textAlign: TextAlign.center),
              const SizedBox(height: 4),
              Text(
                isKichwa ? l10n.appSubtitle : AppConstants.appSubtitle,
                  style:
                      AppTypography.bodySm(p, color: p.inkMuted),
                  textAlign: TextAlign.center),
              const SizedBox(height: AppSpacing.md),
              Text(
                '${Tr.settingsVersion(isKichwa)} ${AppConstants.appVersion}',
                style: AppTypography.caption(p, color: p.inkMuted),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                decoration: BoxDecoration(
                  color: const Color(0xFFB71C1C),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Center(
                  child: Image.asset(AppAssets.espochLogo, height: 48, fit: BoxFit.contain),
                ),
              ),
            ],
          ),
        ),
      ],
    );

    if (widget.embedded) {
      return Scaffold(
        backgroundColor: p.canvas,
        body: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.screen,
                    AppSpacing.lg, AppSpacing.screen, AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        l10n.settings.toUpperCase(),
                        style: AppTypography.eyebrow(p)),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(l10n.settings,
                        style: AppTypography.displayMd(p)),
                  ],
                ),
              ),
              Expanded(child: body),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: p.canvas,
      body: SafeArea(child: body),
    );
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────────

class _Section extends StatelessWidget {
  const _Section({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(label.toUpperCase(), style: AppTypography.eyebrow(p)),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.title,
    this.value,
    this.onTap,
    this.destructive = false,
  });

  final String title;
  final String? value;
  final VoidCallback? onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return GestureDetector(
      onTap: onTap != null
          ? () {
              HapticFeedback.selectionClick();
              onTap!();
            }
          : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.xs),
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: p.surface2,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: p.hairline),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: AppTypography.body(
                          p,
                          color: destructive ? p.error : p.ink)),
                  if (value != null) ...[
                    const SizedBox(height: 2),
                    Text(value!,
                        style: AppTypography.caption(
                            p, color: p.inkMuted)),
                  ],
                ],
              ),
            ),
            if (onTap != null)
              Icon(Icons.chevron_right_rounded,
                  color: p.inkMuted, size: 18),
          ],
        ),
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.xs),
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: p.surface2,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: p.hairline),
      ),
      child: Row(
        children: [
          Expanded(child: Text(title, style: AppTypography.body(p))),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _TimeButton extends StatelessWidget {
  const _TimeButton({
    required this.label,
    required this.hour,
    required this.palette,
    required this.onTap,
  });

  final String label;
  final int hour;
  final AppPalette palette;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = palette;
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.lg),
        decoration: BoxDecoration(
          color: p.surface2,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: p.hairline),
        ),
        child: Column(
          children: [
            Text(label,
                style: AppTypography.caption(p, color: p.inkMuted)),
            const SizedBox(height: AppSpacing.xs),
            Text(
              '${hour.toString().padLeft(2, '0')}:00',
              style: AppTypography.cardTitle(p),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xs),
            Icon(Icons.edit_rounded, size: 14, color: p.inkMuted),
          ],
        ),
      ),
    );
  }
}

class _ThemeSelector extends StatelessWidget {
  const _ThemeSelector({
    required this.current,
    required this.isKichwa,
    required this.onChanged,
  });

  final ThemeMode current;
  final bool isKichwa;
  final ValueChanged<ThemeMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final labels = Tr.themeModeLabels(isKichwa);
    final modes = [ThemeMode.system, ThemeMode.light, ThemeMode.dark];

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxs),
      decoration: BoxDecoration(
        color: p.surface2,
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
        border: Border.all(color: p.hairline),
      ),
      child: Row(
        children: List.generate(3, (i) {
          final selected = current == modes[i];
          return Expanded(
            child: GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                onChanged(modes[i]);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                decoration: BoxDecoration(
                  color: selected ? p.ink : Colors.transparent,
                  borderRadius:
                      BorderRadius.circular(AppSpacing.radiusPill),
                ),
                child: Text(
                  labels[i],
                  style: AppTypography.caption(
                    p,
                    color: selected ? p.canvas : p.inkMuted,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

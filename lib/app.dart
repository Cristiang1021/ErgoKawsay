import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/constants/app_constants.dart';
import 'core/localization/accessibility_controller.dart';
import 'core/localization/app_localizations.dart';
import 'core/localization/locale_controller.dart';
import 'core/localization/theme_controller.dart';
import 'core/storage/storage_service.dart';
import 'core/theme/app_theme.dart';
import 'features/active_breaks/active_breaks_screen.dart';
import 'features/diseases/diseases_screen.dart';
import 'features/emotions/emotions_screen.dart';
import 'features/ergonomics/ergonomics_screen.dart';
import 'features/exercises/exercises_screen.dart';
import 'features/home/home_screen.dart';
import 'features/language/language_selection_screen.dart';
import 'features/language/splash_screen.dart';
import 'features/teacher_profile/teacher_profile_screen.dart';
import 'features/music/music_screen.dart';
import 'features/progress/progress_screen.dart';
import 'features/reminders/reminders_screen.dart';
import 'features/settings/settings_screen.dart';
import 'features/tips/tips_screen.dart';
import 'features/videos/videos_screen.dart';

// Kichwa ('qu') is not in flutter_localizations, so Material/Widgets
// delegates skip it. These fallbacks inject Spanish Material & Widgets
// localizations for 'qu', ensuring dialogs, time pickers, etc. work.
class _KichwaMaterialDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const _KichwaMaterialDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'qu';

  @override
  Future<MaterialLocalizations> load(Locale locale) =>
      SynchronousFuture<MaterialLocalizations>(
          const DefaultMaterialLocalizations());

  @override
  bool shouldReload(_KichwaMaterialDelegate old) => false;
}

class _KichwaWidgetsDelegate
    extends LocalizationsDelegate<WidgetsLocalizations> {
  const _KichwaWidgetsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'qu';

  @override
  Future<WidgetsLocalizations> load(Locale locale) =>
      SynchronousFuture<WidgetsLocalizations>(
          const DefaultWidgetsLocalizations());

  @override
  bool shouldReload(_KichwaWidgetsDelegate old) => false;
}

class ErgoKawsayApp extends StatefulWidget {
  const ErgoKawsayApp({super.key, required this.storage});

  final StorageService storage;

  @override
  State<ErgoKawsayApp> createState() => _ErgoKawsayAppState();
}

class _ErgoKawsayAppState extends State<ErgoKawsayApp> {
  late final LocaleController _localeController;
  late final ThemeController _themeController;
  late final AccessibilityController _accessibilityController;

  @override
  void initState() {
    super.initState();
    _localeController = LocaleController(widget.storage);
    _themeController = ThemeController(widget.storage);
    _accessibilityController = AccessibilityController(widget.storage);
  }

  @override
  void dispose() {
    _localeController.dispose();
    _themeController.dispose();
    _accessibilityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StorageServiceScope(
      storage: widget.storage,
      child: LocaleControllerScope(
        controller: _localeController,
        child: ThemeControllerScope(
          controller: _themeController,
          child: AccessibilityControllerScope(
            controller: _accessibilityController,
            child: ListenableBuilder(
              listenable: Listenable.merge([
                _localeController,
                _themeController,
                _accessibilityController,
              ]),
              builder: (context, _) {
                final a11y = _accessibilityController.settings;
                return MaterialApp(
                  scrollBehavior: const AppScrollBehavior(),
                  title: AppConstants.appName,
                  debugShowCheckedModeBanner: false,
                  theme: AppTheme.lightTheme,
                  darkTheme: AppTheme.darkTheme,
                  themeMode: _themeController.themeMode,
                  locale: _localeController.locale,
                  supportedLocales: AppLocalizations.supportedLocales,
                  localizationsDelegates: const [
                    AppLocalizations.delegate,
                    // Kichwa fallbacks must be listed BEFORE the Global*
                    // delegates so they win the first-match resolution.
                    _KichwaMaterialDelegate(),
                    _KichwaWidgetsDelegate(),
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  localeResolutionCallback: (_, __) =>
                      _localeController.locale,
                  initialRoute: '/',
                  routes: {
                    '/': (_) => const SplashScreen(),
                    '/language': (_) => const LanguageSelectionScreen(),
                    '/teacher-profile': (_) => const TeacherProfileScreen(),
                    '/home': (_) => const HomeScreen(),
                    '/ergonomics': (_) => const ErgonomicsScreen(),
                    '/diseases': (_) => const DiseasesScreen(),
                    '/active-breaks': (_) => const ActiveBreaksScreen(),
                    '/exercises': (_) => const ExercisesScreen(),
                    '/reminders': (_) => const RemindersScreen(),
                    '/tips': (_) => const TipsScreen(),
                    '/emotions': (_) => const EmotionsScreen(),
                    '/music': (_) => const MusicScreen(),
                    '/videos': (_) => const VideosScreen(),
                    '/progress': (_) => const ProgressScreen(),
                    '/settings': (_) => const SettingsScreen(),
                  },
                  builder: (context, child) {
                    var content = child ?? const SizedBox.shrink();
                    if (a11y.colorBlind) {
                      content = ColorFiltered(
                        colorFilter: const ColorFilter.matrix([
                          0.625, 0.375, 0,   0, 0,
                          0.700, 0.300, 0,   0, 0,
                          0,     0.300, 0.7, 0, 0,
                          0,     0,     0,   1, 0,
                        ]),
                        child: content,
                      );
                    }
                    return MediaQuery(
                      data: MediaQuery.of(context).copyWith(
                        textScaler: TextScaler.linear(a11y.textScale),
                      ),
                      child: content,
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

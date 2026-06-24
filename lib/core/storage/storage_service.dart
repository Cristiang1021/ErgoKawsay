import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/accessibility_settings.dart';
import '../../data/models/progress_data.dart';
import '../../data/models/reminder_settings.dart';
import '../constants/app_constants.dart';

class StorageService {
  StorageService(this._prefs);

  final SharedPreferences _prefs;

  static Future<StorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return StorageService(prefs);
  }

  // --- Idioma ---

  String? getLanguage() => _prefs.getString(AppConstants.keyLanguage);

  Future<void> setLanguage(String code) =>
      _prefs.setString(AppConstants.keyLanguage, code);

  Future<void> clearLanguage() => _prefs.remove(AppConstants.keyLanguage);

  bool get hasLanguage => getLanguage() != null;

  // --- Tema ---

  ThemeMode getThemeMode() {
    final value = _prefs.getString(AppConstants.keyThemeMode);
    switch (value) {
      case AppConstants.themeLight:
        return ThemeMode.light;
      case AppConstants.themeDark:
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) {
    final value = switch (mode) {
      ThemeMode.light => AppConstants.themeLight,
      ThemeMode.dark => AppConstants.themeDark,
      ThemeMode.system => AppConstants.themeSystem,
    };
    return _prefs.setString(AppConstants.keyThemeMode, value);
  }

  // --- Notificaciones globales ---

  bool get notificationsEnabled =>
      _prefs.getBool(AppConstants.keyNotificationsEnabled) ?? true;

  Future<void> setNotificationsEnabled(bool value) =>
      _prefs.setBool(AppConstants.keyNotificationsEnabled, value);

  // --- Recordatorios ---

  ReminderSettings getReminderSettings() {
    final json = _prefs.getString(AppConstants.keyReminders);
    if (json == null) return ReminderSettings.defaults();
    return ReminderSettings.fromJson(jsonDecode(json) as Map<String, dynamic>);
  }

  Future<void> saveReminderSettings(ReminderSettings settings) =>
      _prefs.setString(AppConstants.keyReminders, jsonEncode(settings.toJson()));

  // --- Accesibilidad ---

  AccessibilitySettings getAccessibilitySettings() =>
      AccessibilitySettings.fromJsonString(
          _prefs.getString(AppConstants.keyAccessibility));

  Future<void> saveAccessibilitySettings(AccessibilitySettings s) =>
      _prefs.setString(AppConstants.keyAccessibility, jsonEncode(s.toJson()));

  // --- Progreso ---

  ProgressData getProgress() {
    final json = _prefs.getString(AppConstants.keyProgress);
    if (json == null) return ProgressData.empty();
    return ProgressData.fromJson(jsonDecode(json) as Map<String, dynamic>);
  }

  Future<void> saveProgress(ProgressData progress) =>
      _prefs.setString(AppConstants.keyProgress, jsonEncode(progress.toJson()));

  Future<ProgressData> recordExerciseCompleted() async {
    final progress = getProgress();
    final updated = progress.copyWith(
      exercisesCompleted: progress.exercisesCompleted + 1,
      lastUsedDate: DateTime.now(),
    );
    await saveProgress(updated);
    return updated;
  }

  Future<ProgressData> recordActiveBreakCompleted() async {
    final progress = getProgress();
    final updated = progress.copyWith(
      activeBreaksCompleted: progress.activeBreaksCompleted + 1,
      lastUsedDate: DateTime.now(),
    );
    await saveProgress(updated);
    return updated;
  }

  Future<ProgressData> recordEmotion(String emotionId) async {
    final progress = getProgress();
    final emotions = Map<String, int>.from(progress.emotionsRecorded);
    emotions[emotionId] = (emotions[emotionId] ?? 0) + 1;
    final updated = progress.copyWith(
      emotionsRecorded: emotions,
      lastUsedDate: DateTime.now(),
    );
    await saveProgress(updated);
    return updated;
  }

  // --- Perfil docente ---

  String? getProfileName() => _prefs.getString(AppConstants.keyProfileName);

  Future<void> setProfileName(String name) =>
      _prefs.setString(AppConstants.keyProfileName, name);

  String? getProfileAvatar() => _prefs.getString(AppConstants.keyProfileAvatar);

  Future<void> setProfileAvatar(String path) =>
      _prefs.setString(AppConstants.keyProfileAvatar, path);

  bool getProfileCompleted() =>
      _prefs.getBool(AppConstants.keyProfileCompleted) ?? false;

  Future<void> setProfileCompleted(bool value) =>
      _prefs.setBool(AppConstants.keyProfileCompleted, value);

  Future<ProgressData> recordAppOpen() async {
    final progress = getProgress();
    final today = DateTime.now();
    final todayKey =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    final days = Set<String>.from(progress.usageDays)..add(todayKey);
    final updated = progress.copyWith(
      usageDays: days.toList(),
      lastUsedDate: today,
    );
    await saveProgress(updated);
    return updated;
  }
}

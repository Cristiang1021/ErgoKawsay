import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app.dart';
import 'core/services/notification_service.dart';
import 'core/storage/storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Evita que la app se quede colgada en release sin internet esperando fuentes.
  GoogleFonts.config.allowRuntimeFetching = false;

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final storage = await StorageService.init();

  runApp(ErgoKawsayApp(storage: storage));

  // No bloquear el arranque: en dispositivos reales las notificaciones pueden
  // fallar o tardar y dejar la app en pantalla en blanco antes de runApp().
  unawaited(_bootstrapNotifications(storage));
}

Future<void> _bootstrapNotifications(StorageService storage) async {
  try {
    await NotificationService.instance.init();
    final reminderSettings = storage.getReminderSettings();
    if (reminderSettings.notificationsActive && storage.notificationsEnabled) {
      final locale = storage.getLanguage() ?? 'es';
      await NotificationService.instance.scheduleReminders(
        reminderSettings,
        locale,
      );
    }
  } catch (e, st) {
    debugPrint('Notification bootstrap failed: $e\n$st');
  }
}

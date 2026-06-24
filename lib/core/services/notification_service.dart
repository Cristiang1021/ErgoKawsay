import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../data/models/reminder_settings.dart';
import '../localization/tr.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    tz.initializeTimeZones();
    try {
      tz.setLocalLocation(tz.getLocation('America/Guayaquil'));
    } catch (_) {
      // Si falla la zona horaria, seguir con la local por defecto.
    }

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.requestNotificationsPermission();

    _initialized = true;
  }

  static void _onNotificationTap(NotificationResponse response) {
    // Notification tap opens the app normally (Android default behavior).
    // Deep-link navigation can be added here when a navigator key is wired up.
  }

  // ── Messages ─────────────────────────────────────────────────────────────

  static const _messagesEs = [
    'Pausa activa: estira cuello y hombros durante 2 minutos.',
    'Hidratación: toma un vaso de agua ahora.',
    'Descansa la vista: mira un punto lejano durante 20 segundos.',
    'Respira profundo: inhala 4 s, retén 4 s, exhala 4 s.',
    'Pausa de hombros: eleva y suelta 5 veces lentamente.',
    'Levántate y camina 2 minutos. Tu cuerpo lo agradece.',
    'Estira la espalda: entrelaza los dedos y estira hacia arriba.',
    'Parpadea 20 veces para relajar los ojos.',
    'Mueve los tobillos en círculos mientras estás sentado.',
    'Gira el cuello suavemente de lado a lado, sin forzar.',
  ];

  static const _messagesQu = [
    'Kawsay sayay: kunkata, rikrak\'ta samachiy.',
    'Yakuta upiy kunan. Alli kawsaypaqmi.',
    'Ñawikunata samachiy: karupi rikhuriq rurayta qhawaychiy.',
    'Ukhu samay: 4 sigundu ukhu, 4 chariy, 4 llujshiy.',
    'Rikrak\'ta sayariy: 5 kutita sinchita wicharichiy, samariy.',
    'Sayariy, 2 minututa puriy. Aychata samachiy.',
    'Wasan q\'ipiyta alliyachiy: makikunata wichaypi.',
    'Ñawikunata 20 kutita kinrayachiy.',
    'Chaki moqokunata muyu muyu tukuchiy.',
    'Kunkata sinchiyachishpa muyurichiy.',
  ];

  static const _testMessageEs = 'Pausa activa: estira cuello y hombros.';
  static const _testMessageQu = 'Kawsay sayay: kunkata, rikrak\'ta samachiy.';

  static const _channelId = 'active_breaks';
  static const _channelName = 'Pausas Activas';
  static const _channelDesc = 'Recordatorios de pausas activas';

  static const _notificationDetails = NotificationDetails(
    android: AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDesc,
      importance: Importance.high,
      priority: Priority.high,
    ),
  );

  // ── Public API ────────────────────────────────────────────────────────────

  Future<void> scheduleReminders(
      ReminderSettings settings, String locale) async {
    await cancelAll();
    if (!settings.notificationsActive) return;
    await _scheduleBreakReminders(settings, locale);
    await _scheduleDailyExercise(settings, locale);
  }

  Future<void> showTestNotification(String locale) => _plugin.show(
        999,
        Tr.appNameEs,
        locale == 'qu' ? _testMessageQu : _testMessageEs,
        _notificationDetails,
      );

  Future<void> cancelAll() => _plugin.cancelAll();

  // ── Scheduling ────────────────────────────────────────────────────────────

  Future<void> _scheduleBreakReminders(
      ReminderSettings settings, String locale) async {
    final messages = locale == 'qu' ? _messagesQu : _messagesEs;
    // Vary the starting index by current minute so repeated scheduling
    // doesn't always begin with the same message.
    final offset = DateTime.now().minute % messages.length;

    final now = tz.TZDateTime.now(tz.local);
    var next = now.add(Duration(minutes: settings.breakFrequencyMinutes));

    for (var i = 0; i < 8; i++) {
      if (_isOutsideWorkHours(next, settings) ||
          _isInNightSilence(next, settings)) {
        next = _nextWorkHour(next, settings);
      }

      final msg = messages[(offset + i) % messages.length];

      await _plugin.zonedSchedule(
        100 + i,
        'ErgoKawsay',
        msg,
        next,
        _notificationDetails,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );

      next = next.add(Duration(minutes: settings.breakFrequencyMinutes));
    }
  }

  Future<void> _scheduleDailyExercise(
      ReminderSettings settings, String locale) async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      settings.dailyExerciseHour,
    );
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    final body = locale == 'qu'
        ? Tr.remindersDailyExerciseTitleQu
        : 'Es hora de tu ejercicio diario.';

    await _plugin.zonedSchedule(
      200,
      'ErgoKawsay',
      body,
      scheduled,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_exercise',
          'Ejercicio Diario',
          channelDescription: 'Recordatorio de ejercicio diario',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  bool _isInNightSilence(tz.TZDateTime time, ReminderSettings settings) {
    final hour = time.hour;
    if (settings.nightSilenceStartHour > settings.nightSilenceEndHour) {
      return hour >= settings.nightSilenceStartHour ||
          hour < settings.nightSilenceEndHour;
    }
    return hour >= settings.nightSilenceStartHour &&
        hour < settings.nightSilenceEndHour;
  }

  bool _isOutsideWorkHours(tz.TZDateTime time, ReminderSettings settings) {
    final h = time.hour;
    return h < settings.workStartHour || h >= settings.workEndHour;
  }

  tz.TZDateTime _nextWorkHour(
      tz.TZDateTime time, ReminderSettings settings) {
    var t = tz.TZDateTime(
      tz.local,
      time.year,
      time.month,
      time.day,
      settings.workStartHour,
    );
    if (t.isBefore(time) || t.isAtSameMomentAs(time)) {
      t = t.add(const Duration(days: 1));
    }
    return t;
  }
}

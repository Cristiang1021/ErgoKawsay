class ReminderSettings {
  const ReminderSettings({
    required this.notificationsActive,
    required this.breakFrequencyMinutes,
    required this.dailyExerciseHour,
    required this.nightSilenceStartHour,
    required this.nightSilenceEndHour,
    this.workStartHour = 8,
    this.workEndHour = 17,
    this.customFrequencyMinutes = 45,
    this.reminderTypes = const [
      'neck',
      'shoulders',
      'vision',
      'breathing',
      'hydration',
    ],
  });

  final bool notificationsActive;
  final int breakFrequencyMinutes;
  final int dailyExerciseHour;
  final int nightSilenceStartHour;
  final int nightSilenceEndHour;
  final int workStartHour;
  final int workEndHour;
  final int customFrequencyMinutes;
  final List<String> reminderTypes;

  static const allTypes = [
    'neck',
    'shoulders',
    'vision',
    'breathing',
    'hydration',
  ];

  factory ReminderSettings.defaults() => const ReminderSettings(
        notificationsActive: true,
        breakFrequencyMinutes: 60,
        dailyExerciseHour: 7,
        nightSilenceStartHour: 20,
        nightSilenceEndHour: 6,
      );

  ReminderSettings copyWith({
    bool? notificationsActive,
    int? breakFrequencyMinutes,
    int? dailyExerciseHour,
    int? nightSilenceStartHour,
    int? nightSilenceEndHour,
    int? workStartHour,
    int? workEndHour,
    int? customFrequencyMinutes,
    List<String>? reminderTypes,
  }) {
    return ReminderSettings(
      notificationsActive: notificationsActive ?? this.notificationsActive,
      breakFrequencyMinutes:
          breakFrequencyMinutes ?? this.breakFrequencyMinutes,
      dailyExerciseHour: dailyExerciseHour ?? this.dailyExerciseHour,
      nightSilenceStartHour:
          nightSilenceStartHour ?? this.nightSilenceStartHour,
      nightSilenceEndHour: nightSilenceEndHour ?? this.nightSilenceEndHour,
      workStartHour: workStartHour ?? this.workStartHour,
      workEndHour: workEndHour ?? this.workEndHour,
      customFrequencyMinutes:
          customFrequencyMinutes ?? this.customFrequencyMinutes,
      reminderTypes: reminderTypes ?? this.reminderTypes,
    );
  }

  Map<String, dynamic> toJson() => {
        'notificationsActive': notificationsActive,
        'breakFrequencyMinutes': breakFrequencyMinutes,
        'dailyExerciseHour': dailyExerciseHour,
        'nightSilenceStartHour': nightSilenceStartHour,
        'nightSilenceEndHour': nightSilenceEndHour,
        'workStartHour': workStartHour,
        'workEndHour': workEndHour,
        'customFrequencyMinutes': customFrequencyMinutes,
        'reminderTypes': reminderTypes,
      };

  factory ReminderSettings.fromJson(Map<String, dynamic> json) =>
      ReminderSettings(
        notificationsActive: json['notificationsActive'] as bool? ?? true,
        breakFrequencyMinutes:
            json['breakFrequencyMinutes'] as int? ?? 60,
        dailyExerciseHour: json['dailyExerciseHour'] as int? ?? 7,
        nightSilenceStartHour:
            json['nightSilenceStartHour'] as int? ?? 20,
        nightSilenceEndHour: json['nightSilenceEndHour'] as int? ?? 6,
        workStartHour: json['workStartHour'] as int? ?? 8,
        workEndHour: json['workEndHour'] as int? ?? 17,
        customFrequencyMinutes:
            json['customFrequencyMinutes'] as int? ?? 45,
        reminderTypes: (json['reminderTypes'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            const ['neck', 'shoulders', 'vision', 'breathing', 'hydration'],
      );
}

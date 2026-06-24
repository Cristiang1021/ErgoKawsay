class ProgressData {
  const ProgressData({
    required this.exercisesCompleted,
    required this.activeBreaksCompleted,
    required this.emotionsRecorded,
    required this.usageDays,
    this.lastUsedDate,
  });

  final int exercisesCompleted;
  final int activeBreaksCompleted;
  final Map<String, int> emotionsRecorded;
  final List<String> usageDays;
  final DateTime? lastUsedDate;

  int get totalEmotionsRecorded =>
      emotionsRecorded.values.fold(0, (sum, count) => sum + count);

  factory ProgressData.empty() => const ProgressData(
        exercisesCompleted: 0,
        activeBreaksCompleted: 0,
        emotionsRecorded: {},
        usageDays: [],
      );

  ProgressData copyWith({
    int? exercisesCompleted,
    int? activeBreaksCompleted,
    Map<String, int>? emotionsRecorded,
    List<String>? usageDays,
    DateTime? lastUsedDate,
  }) {
    return ProgressData(
      exercisesCompleted: exercisesCompleted ?? this.exercisesCompleted,
      activeBreaksCompleted: activeBreaksCompleted ?? this.activeBreaksCompleted,
      emotionsRecorded: emotionsRecorded ?? this.emotionsRecorded,
      usageDays: usageDays ?? this.usageDays,
      lastUsedDate: lastUsedDate ?? this.lastUsedDate,
    );
  }

  Map<String, dynamic> toJson() => {
        'exercisesCompleted': exercisesCompleted,
        'activeBreaksCompleted': activeBreaksCompleted,
        'emotionsRecorded': emotionsRecorded,
        'usageDays': usageDays,
        'lastUsedDate': lastUsedDate?.toIso8601String(),
      };

  factory ProgressData.fromJson(Map<String, dynamic> json) => ProgressData(
        exercisesCompleted: json['exercisesCompleted'] as int? ?? 0,
        activeBreaksCompleted: json['activeBreaksCompleted'] as int? ?? 0,
        emotionsRecorded: Map<String, int>.from(
          (json['emotionsRecorded'] as Map<String, dynamic>? ?? {})
              .map((k, v) => MapEntry(k, v as int)),
        ),
        usageDays: List<String>.from(json['usageDays'] as List<dynamic>? ?? []),
        lastUsedDate: json['lastUsedDate'] != null
            ? DateTime.tryParse(json['lastUsedDate'] as String)
            : null,
      );
}

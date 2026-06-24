class ActiveBreakStep {
  const ActiveBreakStep({
    required this.id,
    required this.nameEs,
    required this.nameQu,
    required this.descriptionEs,
    required this.descriptionQu,
    required this.durationSeconds,
  });

  final String id;
  final String nameEs;
  final String nameQu;
  final String descriptionEs;
  final String descriptionQu;
  final int durationSeconds;

  String name(bool isKichwa) => isKichwa ? nameQu : nameEs;
  String description(bool isKichwa) => isKichwa ? descriptionQu : descriptionEs;
}

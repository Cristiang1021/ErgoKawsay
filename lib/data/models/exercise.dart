class Exercise {
  const Exercise({
    required this.id,
    required this.categoryId,
    required this.nameEs,
    required this.nameQu,
    required this.descriptionEs,
    required this.descriptionQu,
    required this.durationSeconds,
    this.imageAsset,
    this.imageUrl,
    this.videoUrl,
    this.stepsEs,
    this.stepsQu,
  });

  final String id;
  final String categoryId;
  final String nameEs;
  final String nameQu;
  final String descriptionEs;
  final String descriptionQu;
  final int durationSeconds;
  final String? imageAsset;
  final String? imageUrl;
  final String? videoUrl;
  final List<String>? stepsEs;
  final List<String>? stepsQu;

  String name(bool isKichwa) => isKichwa ? nameQu : nameEs;
  String description(bool isKichwa) => isKichwa ? descriptionQu : descriptionEs;

  List<String> steps(bool isKichwa) {
    final list = isKichwa ? stepsQu : stepsEs;
    if (list != null && list.isNotEmpty) return list;
    return [description(isKichwa)];
  }
}

class ExerciseCategory {
  const ExerciseCategory({
    required this.id,
    required this.nameEs,
    required this.nameQu,
    required this.iconName,
  });

  final String id;
  final String nameEs;
  final String nameQu;
  final String iconName;

  String name(bool isKichwa) => isKichwa ? nameQu : nameEs;
}

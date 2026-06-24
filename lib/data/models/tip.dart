class Tip {
  const Tip({
    required this.id,
    required this.titleEs,
    required this.titleQu,
    required this.contentEs,
    required this.contentQu,
    required this.iconName,
  });

  final String id;
  final String titleEs;
  final String titleQu;
  final String contentEs;
  final String contentQu;
  final String iconName;

  String title(bool isKichwa) => isKichwa ? titleQu : titleEs;
  String content(bool isKichwa) => isKichwa ? contentQu : contentEs;
}

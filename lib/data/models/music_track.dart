class MusicTrack {
  const MusicTrack({
    required this.id,
    required this.titleEs,
    required this.titleQu,
    required this.descriptionEs,
    required this.descriptionQu,
    required this.assetPath,
    required this.isAsset,
    this.url,
  });

  final String id;
  final String titleEs;
  final String titleQu;
  final String descriptionEs;
  final String descriptionQu;
  final String assetPath;
  final bool isAsset;
  final String? url;

  String title(bool isKichwa) => isKichwa ? titleQu : titleEs;
  String description(bool isKichwa) => isKichwa ? descriptionQu : descriptionEs;
}

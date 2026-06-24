class VideoItem {
  const VideoItem({
    required this.id,
    required this.titleEs,
    required this.titleQu,
    required this.descriptionEs,
    required this.descriptionQu,
    this.assetPath,
    this.url,
  });

  final String id;
  final String titleEs;
  final String titleQu;
  final String descriptionEs;
  final String descriptionQu;
  final String? assetPath;
  final String? url;

  String title(bool isKichwa) => isKichwa ? titleQu : titleEs;
  String description(bool isKichwa) => isKichwa ? descriptionQu : descriptionEs;

  bool get hasMedia => (assetPath != null && assetPath!.isNotEmpty) ||
      (url != null && url!.isNotEmpty);
}

class Emotion {
  const Emotion({
    required this.id,
    required this.nameEs,
    required this.nameQu,
    required this.whatIsEs,
    required this.whatIsQu,
    this.causesTitleEs,
    this.causesTitleQu,
    required this.causesEs,
    required this.causesQu,
    this.actionsTitleEs,
    this.actionsTitleQu,
    required this.actionsEs,
    required this.actionsQu,
    required this.phraseEs,
    required this.phraseQu,
    required this.colorHex,
    required this.iconName,
    this.imageAsset,
  });

  final String id;
  final String nameEs;
  final String nameQu;
  final String whatIsEs;
  final String whatIsQu;
  final String? causesTitleEs;
  final String? causesTitleQu;
  final String causesEs;
  final String causesQu;
  final String? actionsTitleEs;
  final String? actionsTitleQu;
  final String actionsEs;
  final String actionsQu;
  final String phraseEs;
  final String phraseQu;
  final int colorHex;
  final String iconName;
  final String? imageAsset;

  String name(bool isKichwa) => isKichwa ? nameQu : nameEs;
  String whatIs(bool isKichwa) => isKichwa ? whatIsQu : whatIsEs;
  String? causesTitle(bool isKichwa) =>
      isKichwa ? causesTitleQu : causesTitleEs;
  String causes(bool isKichwa) => isKichwa ? causesQu : causesEs;
  String? actionsTitle(bool isKichwa) =>
      isKichwa ? actionsTitleQu : actionsTitleEs;
  String actions(bool isKichwa) => isKichwa ? actionsQu : actionsEs;
  String phrase(bool isKichwa) => isKichwa ? phraseQu : phraseEs;
}

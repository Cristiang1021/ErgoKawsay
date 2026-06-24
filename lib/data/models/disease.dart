class Disease {
  const Disease({
    required this.id,
    required this.nameEs,
    required this.nameQu,
    required this.descriptionEs,
    required this.descriptionQu,
    required this.causeEs,
    required this.causeQu,
    required this.warningEs,
    required this.warningQu,
    required this.consultEs,
    required this.consultQu,
  });

  final String id;
  final String nameEs;
  final String nameQu;
  final String descriptionEs;
  final String descriptionQu;
  final String causeEs;
  final String causeQu;
  final String warningEs;
  final String warningQu;
  final String consultEs;
  final String consultQu;

  String name(bool isKichwa) => isKichwa ? nameQu : nameEs;
  String description(bool isKichwa) => isKichwa ? descriptionQu : descriptionEs;
  String cause(bool isKichwa) => isKichwa ? causeQu : causeEs;
  String warning(bool isKichwa) => isKichwa ? warningQu : warningEs;
  String consult(bool isKichwa) => isKichwa ? consultQu : consultEs;
}

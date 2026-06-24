import '../../core/localization/tr.dart';

enum HomeCategory {
  today,
  body,
  mind,
  learn,
}

extension HomeCategoryLabels on HomeCategory {
  String label(bool isKichwa) {
    switch (this) {
      case HomeCategory.today:
        return 'Para hoy';
      case HomeCategory.body:
        return Tr.vocabularyBody(isKichwa);
      case HomeCategory.mind:
        return Tr.vocabularyMind(isKichwa);
      case HomeCategory.learn:
        return Tr.vocabularyLearning(isKichwa);
    }
  }
}

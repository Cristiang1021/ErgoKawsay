class QuizQuestion {
  const QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.feedback,
  });

  final String question;
  final List<String> options;
  final int correctIndex;
  final String feedback;
}

class AppQuiz {
  const AppQuiz({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.questions,
  });

  final String id;
  final String title;
  final String subtitle;
  final List<QuizQuestion> questions;
}

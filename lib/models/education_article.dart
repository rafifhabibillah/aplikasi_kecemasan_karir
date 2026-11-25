class EducationArticle {
  const EducationArticle({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.body,
    required this.minutes,
    this.relatedPracticeId,
    this.relatedPracticeLabel,
  });

  final String id;
  final String title;
  final String subtitle;
  final String category;
  final String body;
  final int minutes;
  /// id latihan di `mindfulness_practices.dart`, opsional.
  final String? relatedPracticeId;
  final String? relatedPracticeLabel;
}

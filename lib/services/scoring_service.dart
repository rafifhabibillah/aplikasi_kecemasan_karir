import '../data/sample_instrument.dart';
import '../models/assessment_result.dart';
import '../models/question.dart';

class ScoringService {
  static AssessmentResult calculate({
    required Map<String, int> answers,
    required String studentName,
    List<Question> questions = sampleQuestions,
  }) {
    final dimensionTotals = <String, int>{};
    final dimensionMax = <String, int>{};

    var total = 0;
    var maxTotal = 0;

    for (final question in questions) {
      final raw = answers[question.id] ?? 1;
      final scored = question.isReversed ? (5 - raw) : raw;

      total += scored;
      maxTotal += 4;

      dimensionTotals.update(
        question.dimension,
        (value) => value + scored,
        ifAbsent: () => scored,
      );
      dimensionMax.update(
        question.dimension,
        (value) => value + 4,
        ifAbsent: () => 4,
      );
    }

    final dimensions = dimensionTotals.entries
        .map(
          (entry) => DimensionScore(
            name: entry.key,
            score: entry.value,
            maxScore: dimensionMax[entry.key] ?? 0,
          ),
        )
        .toList();

    return AssessmentResult(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      createdAt: DateTime.now(),
      totalScore: total,
      maxScore: maxTotal,
      level: _levelFromPercentage(total / maxTotal),
      dimensions: dimensions,
      studentName: studentName,
    );
  }

  /// Cut-off placeholder — diganti setelah norma instrumen tesis tersedia.
  static AnxietyLevel _levelFromPercentage(double percentage) {
    if (percentage < 0.45) return AnxietyLevel.rendah;
    if (percentage < 0.70) return AnxietyLevel.sedang;
    return AnxietyLevel.tinggi;
  }
}

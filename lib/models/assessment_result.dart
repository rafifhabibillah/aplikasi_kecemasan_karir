class DimensionScore {
  const DimensionScore({
    required this.name,
    required this.score,
    required this.maxScore,
  });

  final String name;
  final int score;
  final int maxScore;

  double get percentage => maxScore == 0 ? 0 : score / maxScore;

  Map<String, dynamic> toJson() => {
        'name': name,
        'score': score,
        'maxScore': maxScore,
      };

  factory DimensionScore.fromJson(Map<String, dynamic> json) {
    return DimensionScore(
      name: json['name'] as String,
      score: json['score'] as int,
      maxScore: json['maxScore'] as int,
    );
  }
}

enum AnxietyLevel { rendah, sedang, tinggi }

extension AnxietyLevelLabel on AnxietyLevel {
  String get label {
    switch (this) {
      case AnxietyLevel.rendah:
        return 'Rendah';
      case AnxietyLevel.sedang:
        return 'Sedang';
      case AnxietyLevel.tinggi:
        return 'Tinggi';
    }
  }

  String get description {
    switch (this) {
      case AnxietyLevel.rendah:
        return 'Kecemasan karirmu masih terkendali. Pertahankan eksplorasi pilihan secara bertahap.';
      case AnxietyLevel.sedang:
        return 'Ada beberapa area yang membuatmu khawatir. Mulai dari informasi dan rencana kecil yang realistis.';
      case AnxietyLevel.tinggi:
        return 'Kecemasan karir terasa cukup menekan. Disarankan memperbanyak informasi, menyusun langkah kecil, dan bicara dengan guru BK bila perlu.';
    }
  }
}

class AssessmentResult {
  const AssessmentResult({
    required this.id,
    required this.createdAt,
    required this.totalScore,
    required this.maxScore,
    required this.level,
    required this.dimensions,
    required this.studentName,
  });

  final String id;
  final DateTime createdAt;
  final int totalScore;
  final int maxScore;
  final AnxietyLevel level;
  final List<DimensionScore> dimensions;
  final String studentName;

  double get percentage => maxScore == 0 ? 0 : totalScore / maxScore;

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt.toIso8601String(),
        'totalScore': totalScore,
        'maxScore': maxScore,
        'level': level.name,
        'dimensions': dimensions.map((d) => d.toJson()).toList(),
        'studentName': studentName,
      };

  factory AssessmentResult.fromJson(Map<String, dynamic> json) {
    return AssessmentResult(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      totalScore: json['totalScore'] as int,
      maxScore: json['maxScore'] as int,
      level: AnxietyLevel.values.byName(json['level'] as String),
      dimensions: (json['dimensions'] as List)
          .map((e) => DimensionScore.fromJson(e as Map<String, dynamic>))
          .toList(),
      studentName: json['studentName'] as String,
    );
  }
}

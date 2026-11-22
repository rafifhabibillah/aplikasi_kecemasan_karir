class CheckIn {
  const CheckIn({
    required this.id,
    required this.createdAt,
    required this.anxietyLevel,
    required this.note,
  });

  final String id;
  final DateTime createdAt;
  /// Skala 1–5: 1 tenang, 5 sangat cemas soal karier.
  final int anxietyLevel;
  final String note;

  String get label {
    switch (anxietyLevel) {
      case 1:
        return 'Tenang';
      case 2:
        return 'Agak ringan';
      case 3:
        return 'Sedang';
      case 4:
        return 'Cukup berat';
      default:
        return 'Sangat cemas';
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt.toIso8601String(),
        'anxietyLevel': anxietyLevel,
        'note': note,
      };

  factory CheckIn.fromJson(Map<String, dynamic> json) {
    return CheckIn(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      anxietyLevel: json['anxietyLevel'] as int,
      note: json['note'] as String? ?? '',
    );
  }
}

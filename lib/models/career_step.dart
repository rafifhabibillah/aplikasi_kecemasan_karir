class CareerStep {
  const CareerStep({
    required this.id,
    required this.title,
    required this.createdAt,
    this.isDone = false,
    this.doneAt,
  });

  final String id;
  final String title;
  final DateTime createdAt;
  final bool isDone;
  final DateTime? doneAt;

  CareerStep copyWith({
    String? title,
    bool? isDone,
    DateTime? doneAt,
  }) {
    return CareerStep(
      id: id,
      title: title ?? this.title,
      createdAt: createdAt,
      isDone: isDone ?? this.isDone,
      doneAt: doneAt ?? this.doneAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'createdAt': createdAt.toIso8601String(),
        'isDone': isDone,
        'doneAt': doneAt?.toIso8601String(),
      };

  factory CareerStep.fromJson(Map<String, dynamic> json) {
    return CareerStep(
      id: json['id'] as String,
      title: json['title'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isDone: json['isDone'] as bool? ?? false,
      doneAt: json['doneAt'] == null
          ? null
          : DateTime.parse(json['doneAt'] as String),
    );
  }
}

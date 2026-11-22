class ActivityLog {
  const ActivityLog({
    required this.id,
    required this.createdAt,
    required this.type,
    required this.title,
  });

  final String id;
  final DateTime createdAt;
  final String type;
  final String title;

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt.toIso8601String(),
        'type': type,
        'title': title,
      };

  factory ActivityLog.fromJson(Map<String, dynamic> json) {
    return ActivityLog(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      type: json['type'] as String,
      title: json['title'] as String,
    );
  }
}

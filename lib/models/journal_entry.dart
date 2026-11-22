class JournalEntry {
  const JournalEntry({
    required this.id,
    required this.createdAt,
    required this.prompt,
    required this.body,
  });

  final String id;
  final DateTime createdAt;
  final String prompt;
  final String body;

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt.toIso8601String(),
        'prompt': prompt,
        'body': body,
      };

  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      prompt: json['prompt'] as String,
      body: json['body'] as String,
    );
  }
}

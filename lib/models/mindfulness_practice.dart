enum PracticeKind {
  breathing,
  grounding,
  mindfulPause,
  bodyScan,
  worrySort,
  strengthPick,
}

class MindfulnessPractice {
  const MindfulnessPractice({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.durationLabel,
    required this.kind,
    required this.iconName,
    required this.category,
    required this.accent,
  });

  final String id;
  final String title;
  final String subtitle;
  final String durationLabel;
  final PracticeKind kind;
  final String iconName;
  final String category;
  final int accent;
}

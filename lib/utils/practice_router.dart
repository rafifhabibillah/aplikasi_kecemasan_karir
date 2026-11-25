import 'package:material_ui/material_ui.dart';

import '../models/mindfulness_practice.dart';
import '../screens/body_scan_screen.dart';
import '../screens/breathing_screen.dart';
import '../screens/grounding_screen.dart';
import '../screens/mindful_pause_screen.dart';
import '../screens/strength_pick_screen.dart';
import '../screens/worry_sort_screen.dart';

Widget practicePageFor(PracticeKind kind) {
  return switch (kind) {
    PracticeKind.breathing => const BreathingScreen(),
    PracticeKind.grounding => const GroundingScreen(),
    PracticeKind.mindfulPause => const MindfulPauseScreen(),
    PracticeKind.bodyScan => const BodyScanScreen(),
    PracticeKind.worrySort => const WorrySortScreen(),
    PracticeKind.strengthPick => const StrengthPickScreen(),
  };
}

PracticeKind? practiceKindFromId(String? id) {
  switch (id) {
    case 'breathing':
      return PracticeKind.breathing;
    case 'grounding':
      return PracticeKind.grounding;
    case 'mindful_pause':
      return PracticeKind.mindfulPause;
    case 'body_scan':
      return PracticeKind.bodyScan;
    case 'worry_sort':
      return PracticeKind.worrySort;
    case 'strength_pick':
      return PracticeKind.strengthPick;
    default:
      return null;
  }
}

Future<void> openPracticeById(BuildContext context, String? practiceId) async {
  final kind = practiceKindFromId(practiceId);
  if (kind == null) return;
  await Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => practicePageFor(kind)),
  );
}

import 'package:material_ui/material_ui.dart';

import '../data/mindfulness_practices.dart';
import '../models/mindfulness_practice.dart';
import '../navigation/shell_nav.dart';
import '../theme/app_theme.dart';
import '../utils/practice_router.dart';
import '../widgets/common_widgets.dart';

class PracticeHubScreen extends StatelessWidget {
  const PracticeHubScreen({super.key});

  IconData _icon(String name) {
    switch (name) {
      case 'air':
        return Icons.air_rounded;
      case 'spa':
        return Icons.spa_rounded;
      case 'accessibility':
        return Icons.accessibility_new_rounded;
      case 'filter':
        return Icons.filter_alt_outlined;
      case 'star':
        return Icons.star_outline_rounded;
      default:
        return Icons.self_improvement_rounded;
    }
  }

  Future<void> _open(BuildContext context, MindfulnessPractice practice) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => practicePageFor(practice.kind)),
    );
    ShellNav.bump();
  }

  @override
  Widget build(BuildContext context) {
    final categories = <String, List<MindfulnessPractice>>{};
    for (final practice in mindfulnessPractices) {
      categories.putIfAbsent(practice.category, () => []).add(practice);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Latihan tenang')),
      body: AtmosphereBackground(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          children: [
            SoftPanel(
              color: AppColors.deep,
              padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pilih cara tenang yang cocok',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Bukan sekadar baca instruksi. Setiap latihan punya interaksi singkat yang bisa langsung dicoba.',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.78),
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ...categories.entries.expand((entry) {
              return [
                SectionHeader(
                  title: entry.key,
                  subtitle: '${entry.value.length} latihan tersedia',
                ),
                const SizedBox(height: 10),
                ...entry.value.map((practice) {
                  final accent = Color(practice.accent);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(24),
                        onTap: () => _open(context, practice),
                        child: Ink(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.deep.withValues(alpha: 0.06),
                                blurRadius: 18,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              children: [
                                PracticeIconBadge(
                                  icon: _icon(practice.iconName),
                                  color: accent,
                                  size: 56,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        practice.title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: -0.2,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        practice.subtitle,
                                        style: const TextStyle(
                                          color: AppColors.muted,
                                          height: 1.35,
                                          fontSize: 13,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      LevelBadge(
                                        label: practice.durationLabel,
                                        color: accent,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(Icons.play_circle_filled_rounded,
                                    color: accent, size: 30),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 8),
              ];
            }),
            SoftPanel(
              elevated: false,
              color: AppColors.creamSoft,
              child: Text(
                'Latihan ini pendukung pengelolaan kecemasan karier, bukan pengganti konseling bila kamu butuh bantuan lebih lanjut.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.deep,
                      height: 1.45,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

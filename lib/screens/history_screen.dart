import 'package:material_ui/material_ui.dart';
import 'package:intl/intl.dart';

import '../models/assessment_result.dart';
import '../navigation/shell_nav.dart';
import '../services/session_service.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'assessment_screen.dart';
import 'result_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final _store = AssessmentStore();
  late Future<List<AssessmentResult>> _future;

  @override
  void initState() {
    super.initState();
    _future = _store.getHistory();
  }

  Color _levelColor(AnxietyLevel level) {
    switch (level) {
      case AnxietyLevel.rendah:
        return AppColors.low;
      case AnxietyLevel.sedang:
        return AppColors.warn;
      case AnxietyLevel.tinggi:
        return AppColors.high;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat asesmen')),
      body: AtmosphereBackground(
        child: FutureBuilder<List<AssessmentResult>>(
          future: _future,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final items = snapshot.data!;
            if (items.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: EmptyState(
                  icon: Icons.assignment_outlined,
                  title: 'Belum ada riwayat',
                  message:
                      'Selesaikan asesmen pertama untuk melihat skor dan trenmu di sini.',
                  actionLabel: 'Mulai asesmen',
                  onAction: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const AssessmentScreen(),
                      ),
                    );
                    ShellNav.bump();
                    setState(() => _future = _store.getHistory());
                  },
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = items[index];
                final dateLabel = DateFormat('d MMM yyyy, HH.mm', 'id_ID')
                    .format(item.createdAt);
                return SoftPanel(
                  padding: const EdgeInsets.all(14),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Skor ${item.totalScore}/${item.maxScore}',
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    subtitle: Text(
                      dateLabel,
                      style: const TextStyle(color: AppColors.muted),
                    ),
                    trailing: LevelBadge(
                      label: item.level.label,
                      color: _levelColor(item.level),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ResultScreen(result: item),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

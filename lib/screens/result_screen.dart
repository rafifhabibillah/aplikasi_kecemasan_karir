import 'package:material_ui/material_ui.dart';
import 'package:intl/intl.dart';

import '../models/assessment_result.dart';
import '../navigation/shell_nav.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'breathing_screen.dart';
import 'education_list_screen.dart';
import 'grounding_screen.dart';
import 'mindful_pause_screen.dart';
import 'steps_screen.dart';
import 'strength_pick_screen.dart';
import 'worry_sort_screen.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key, required this.result});

  final AssessmentResult result;

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

  ({String title, String subtitle, Widget page, String cta}) _primaryNext() {
    switch (result.level) {
      case AnxietyLevel.rendah:
        return (
          title: 'Ambil 3 kekuatanmu',
          subtitle: 'Ingatkan modal diri sebelum menyusun langkah berikutnya.',
          page: const StrengthPickScreen(),
          cta: 'Mulai latihan ini',
        );
      case AnxietyLevel.sedang:
        return (
          title: 'Pilah rasa khawatir',
          subtitle: 'Pisahkan yang bisa dikendalikan hari ini dari yang perlu dilepas.',
          page: const WorrySortScreen(),
          cta: 'Mulai pilah khawatir',
        );
      case AnxietyLevel.tinggi:
        return (
          title: 'Grounding interaktif',
          subtitle: 'Kembalikan tubuh ke saat ini sebelum memikirkan langkah besar.',
          page: const GroundingScreen(),
          cta: 'Mulai grounding',
        );
    }
  }

  List<({String title, Widget page})> _secondary() {
    switch (result.level) {
      case AnxietyLevel.rendah:
        return [
          (title: 'Napas box', page: const BreathingScreen()),
          (title: 'Langkah kecil', page: const StepsScreen()),
        ];
      case AnxietyLevel.sedang:
        return [
          (title: 'Napas box', page: const BreathingScreen()),
          (title: 'Jeda mindful', page: const MindfulPauseScreen()),
        ];
      case AnxietyLevel.tinggi:
        return [
          (title: 'Napas box', page: const BreathingScreen()),
          (title: 'Pilah khawatir', page: const WorrySortScreen()),
        ];
    }
  }

  void _backToShell(BuildContext context, {int tab = 0}) {
    ShellNav.goTab(tab);
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final dateLabel =
        DateFormat('d MMM yyyy, HH.mm', 'id_ID').format(result.createdAt);
    final color = _levelColor(result.level);
    final primary = _primaryNext();
    final secondary = _secondary();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil asesmen'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => _backToShell(context),
        ),
      ),
      body: AtmosphereBackground(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          children: [
            SoftPanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          result.studentName,
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                      LevelBadge(label: result.level.label, color: color),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    dateLabel,
                    style: const TextStyle(color: AppColors.muted, fontSize: 13),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    '${result.totalScore}',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: AppColors.deep,
                        ),
                  ),
                  Text(
                    'dari ${result.maxScore} poin',
                    style: const TextStyle(color: AppColors.muted),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    result.level.description,
                    style: const TextStyle(height: 1.45),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const SectionHeader(
              title: 'Langkah berikutnya',
              subtitle: 'Fokus ke satu aksi dulu — disesuaikan level hasilmu.',
            ),
            const SizedBox(height: 10),
            SoftPanel(
              color: AppColors.deep,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    primary.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    primary.subtitle,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.78),
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => primary.page),
                      );
                      ShellNav.bump();
                    },
                    child: Text(primary.cta),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                for (var i = 0; i < secondary.length; i++) ...[
                  if (i > 0) const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => secondary[i].page,
                          ),
                        );
                      },
                      child: Text(
                        secondary[i].title,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 18),
            const SectionHeader(
              title: 'Skor per aspek',
              subtitle: 'Dimensi masih mengikuti draft prototipe.',
            ),
            const SizedBox(height: 10),
            ...result.dimensions.map(
              (dimension) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: SoftPanel(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              dimension.name,
                              style: const TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                          Text('${dimension.score}/${dimension.maxScore}'),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: LinearProgressIndicator(
                          value: dimension.percentage,
                          minHeight: 8,
                          backgroundColor: AppColors.soft,
                          color: AppColors.seed,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (result.level == AnxietyLevel.tinggi) ...[
              SoftPanel(
                color: const Color(0xFFFFF4F2),
                child: Text(
                  'Jika kecemasan sudah mengganggu tidur, belajar, atau aktivitas harian, '
                  'pertimbangkan berbicara dengan guru BK atau orang dewasa yang kamu percaya.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.high,
                        height: 1.4,
                      ),
                ),
              ),
              const SizedBox(height: 12),
            ],
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const EducationListScreen()),
                );
              },
              child: const Text('Lihat materi edukasi'),
            ),
            const SizedBox(height: 4),
            OutlinedButton(
              onPressed: () => _backToShell(context),
              child: const Text('Kembali ke beranda'),
            ),
          ],
        ),
      ),
    );
  }
}

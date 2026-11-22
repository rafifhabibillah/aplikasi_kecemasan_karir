import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/assessment_result.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'breathing_screen.dart';
import 'education_list_screen.dart';
import 'grounding_screen.dart';
import 'main_shell.dart';
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

  List<({String title, String subtitle, Widget page})> _recommendations() {
    switch (result.level) {
      case AnxietyLevel.rendah:
        return [
          (
            title: 'Ambil 3 kekuatanmu',
            subtitle: 'Ingatkan modal diri sebelum melangkah.',
            page: const StrengthPickScreen(),
          ),
          (
            title: 'Napas box interaktif',
            subtitle: 'Jaga ketenangan dengan jalur visual yang ringan.',
            page: const BreathingScreen(),
          ),
          (
            title: 'Susun langkah kecil',
            subtitle: 'Pertahankan arah dengan tindakan realistis.',
            page: const StepsScreen(),
          ),
        ];
      case AnxietyLevel.sedang:
        return [
          (
            title: 'Pilah rasa khawatir',
            subtitle: 'Pisahkan yang bisa dikendalikan hari ini.',
            page: const WorrySortScreen(),
          ),
          (
            title: 'Napas box interaktif',
            subtitle: 'Redakan ketegangan sebelum menyusun rencana.',
            page: const BreathingScreen(),
          ),
          (
            title: 'Jeda mindful karier',
            subtitle: 'Kenali kekhawatiran lalu pilih respons kecil.',
            page: const MindfulPauseScreen(),
          ),
        ];
      case AnxietyLevel.tinggi:
        return [
          (
            title: 'Grounding interaktif',
            subtitle: 'Kembalikan tubuh ke saat ini dengan pilihan indra.',
            page: const GroundingScreen(),
          ),
          (
            title: 'Napas box interaktif',
            subtitle: 'Ikuti jalur kotak untuk turun dari mode waspada.',
            page: const BreathingScreen(),
          ),
          (
            title: 'Pilah rasa khawatir',
            subtitle: 'Setelah lebih tenang, fokus ke yang masih bisa digeser.',
            page: const WorrySortScreen(),
          ),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateLabel =
        DateFormat('d MMM yyyy, HH.mm', 'id_ID').format(result.createdAt);
    final color = _levelColor(result.level);
    final recommendations = _recommendations();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil asesmen'),
        automaticallyImplyLeading: false,
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
          const SizedBox(height: 12),
          const SectionHeader(
            title: 'Rekomendasi berikutnya',
            subtitle: 'Disesuaikan dengan level hasil asesmenmu.',
          ),
          const SizedBox(height: 10),
          ...recommendations.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: SoftPanel(
                padding: const EdgeInsets.all(14),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    item.title,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(
                    item.subtitle,
                    style: const TextStyle(color: AppColors.muted),
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => item.page),
                    );
                  },
                ),
              ),
            ),
          ),
          if (result.level == AnxietyLevel.tinggi) ...[
            const SizedBox(height: 4),
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
          FilledButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const EducationListScreen()),
              );
            },
            child: const Text('Lihat materi edukasi'),
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const MainShell()),
                (_) => false,
              );
            },
            child: const Text('Kembali ke beranda'),
          ),
        ],
        ),
      ),
    );
  }
}

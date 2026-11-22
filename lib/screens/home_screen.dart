import 'package:flutter/material.dart';

import '../data/sample_articles.dart';
import '../data/sample_instrument.dart';
import '../models/assessment_result.dart';
import '../models/check_in.dart';
import '../services/session_service.dart';
import '../services/wellbeing_store.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'assessment_screen.dart';
import 'breathing_screen.dart';
import 'check_in_screen.dart';
import 'education_detail_screen.dart';
import 'education_list_screen.dart';
import 'history_screen.dart';
import 'login_screen.dart';
import 'worry_sort_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _session = SessionService();
  final _store = AssessmentStore();
  final _wellbeing = WellbeingStore();
  String _name = '';
  AssessmentResult? _latest;
  CheckIn? _todayCheckIn;
  int _streak = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final name = await _session.getStudentName();
    final history = await _store.getHistory();
    final today = await _wellbeing.todayCheckIn();
    final streak = await _wellbeing.practiceStreakDays();
    if (!mounted) return;
    setState(() {
      _name = name;
      _latest = history.isEmpty ? null : history.first;
      _todayCheckIn = today;
      _streak = streak;
    });
  }

  Future<void> _logout() async {
    await _session.logout();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
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
    final previewArticles = sampleArticles.take(2).toList();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const BrandMark(size: 28, showShadow: false),
            const SizedBox(width: 10),
            Text(
              'ArahTenang',
              style: Theme.of(context).appBarTheme.titleTextStyle,
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Keluar',
            onPressed: _logout,
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
      body: AtmosphereBackground(
        child: RefreshIndicator(
          onRefresh: _load,
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
                      'Halo, ${_name.isEmpty ? 'Siswa' : _name}',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.4,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Asesmen, mindfulness, dan langkah kecil untuk menenangkan kecemasan karier.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withValues(alpha: 0.78),
                            height: 1.45,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: SoftPanel(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Streak',
                            style: TextStyle(color: AppColors.muted, fontSize: 12),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$_streak hari',
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SoftPanel(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Hari ini',
                            style: TextStyle(color: AppColors.muted, fontSize: 12),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _todayCheckIn == null
                                ? 'Belum check-in'
                                : _todayCheckIn!.label,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              SoftPanel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Asesmen kecemasan karier',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.3,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$sampleInstrumentTitle · ${sampleQuestions.length} item',
                      style: const TextStyle(color: AppColors.muted, height: 1.4),
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const AssessmentScreen(),
                          ),
                        );
                        await _load();
                      },
                      child: const Text('Mulai asesmen'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              const SectionHeader(
                title: 'Butuh tenang dulu?',
                subtitle: 'Pilih bantuan singkat sebelum atau sesudah asesmen.',
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _QuickAction(
                      icon: Icons.air_rounded,
                      label: 'Napas',
                      onTap: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const BreathingScreen(),
                          ),
                        );
                        await _load();
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _QuickAction(
                      icon: Icons.favorite_outline_rounded,
                      label: 'Check-in',
                      onTap: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const CheckInScreen(),
                          ),
                        );
                        await _load();
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _QuickAction(
                      icon: Icons.filter_alt_outlined,
                      label: 'Pilah',
                      onTap: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const WorrySortScreen(),
                          ),
                        );
                        await _load();
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              if (_latest != null) ...[
                SectionHeader(
                  title: 'Hasil terakhir',
                  action: TextButton(
                    onPressed: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const HistoryScreen()),
                      );
                      await _load();
                    },
                    child: const Text('Riwayat'),
                  ),
                ),
                const SizedBox(height: 10),
                SoftPanel(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Skor ${_latest!.totalScore}/${_latest!.maxScore}',
                              style: const TextStyle(fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Level: ${_latest!.level.label}',
                              style: const TextStyle(color: AppColors.muted),
                            ),
                          ],
                        ),
                      ),
                      LevelBadge(
                        label: _latest!.level.label,
                        color: _levelColor(_latest!.level),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
              ],
              SectionHeader(
                title: 'Materi edukasi',
                subtitle: 'Termasuk bacaan mindfulness yang relevan.',
                action: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const EducationListScreen(),
                      ),
                    );
                  },
                  child: const Text('Semua'),
                ),
              ),
              const SizedBox(height: 10),
              ...previewArticles.map(
                (article) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: SoftPanel(
                    padding: const EdgeInsets.all(14),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        article.title,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          '${article.category} · ${article.minutes} menit baca',
                          style: const TextStyle(color: AppColors.muted),
                        ),
                      ),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                EducationDetailScreen(article: article),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SoftPanel(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Column(
          children: [
            Icon(icon, color: AppColors.deep),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

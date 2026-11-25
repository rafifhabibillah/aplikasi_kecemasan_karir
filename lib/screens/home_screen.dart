import 'package:material_ui/material_ui.dart';

import '../brand/app_brand.dart';
import '../data/sample_instrument.dart';
import '../models/assessment_result.dart';
import '../models/check_in.dart';
import '../navigation/shell_nav.dart';
import '../services/session_service.dart';
import '../services/wellbeing_store.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'assessment_screen.dart';
import 'breathing_screen.dart';
import 'check_in_screen.dart';
import 'history_screen.dart';
import 'login_screen.dart';
import 'result_screen.dart';

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
    ShellNav.refreshTick.addListener(_onRefresh);
    _load();
  }

  @override
  void dispose() {
    ShellNav.refreshTick.removeListener(_onRefresh);
    super.dispose();
  }

  void _onRefresh() => _load();

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

  String get _insightLine {
    if (_todayCheckIn != null) {
      return 'Check-in hari ini: ${_todayCheckIn!.label}';
    }
    if (_latest != null) {
      return 'Hasil terakhir: ${_latest!.level.label} '
          '(${_latest!.totalScore}/${_latest!.maxScore})';
    }
    if (_streak > 0) {
      return 'Streak aktif $_streak hari — lanjutkan langkah kecilmu.';
    }
    return 'Belum ada jejak hari ini. Mulai dari asesmen atau check-in singkat.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const BrandWordmark(markSize: 28, fontSize: 20),
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
              // Hero composition — satu fokus di viewport pertama
              SoftPanel(
                color: AppColors.deep,
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
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
                      AppBrand.shortPitch,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withValues(alpha: 0.78),
                            height: 1.45,
                          ),
                    ),
                    const SizedBox(height: 18),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const AssessmentScreen(),
                          ),
                        );
                        ShellNav.bump();
                        await _load();
                      },
                      child: Text(
                        _latest == null ? 'Mulai asesmen' : 'Ulangi asesmen',
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '$sampleInstrumentTitle · ${sampleQuestions.length} item',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.55),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              SoftPanel(
                elevated: false,
                color: AppColors.creamSoft,
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: AppColors.soft,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        _todayCheckIn == null
                            ? Icons.favorite_outline_rounded
                            : Icons.insights_rounded,
                        color: AppColors.deep,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _streak > 0 ? 'Streak $_streak hari' : 'Insight hari ini',
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _insightLine,
                            style: const TextStyle(
                              color: AppColors.muted,
                              height: 1.35,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              const SectionHeader(
                title: 'Butuh tenang dulu?',
                subtitle: 'Bantuan singkat sebelum atau sesudah asesmen.',
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
                        ShellNav.bump();
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
                        ShellNav.bump();
                        await _load();
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _QuickAction(
                      icon: Icons.spa_outlined,
                      label: 'Latihan',
                      onTap: () => ShellNav.goPractice(),
                    ),
                  ),
                ],
              ),
              if (_latest != null) ...[
                const SizedBox(height: 22),
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
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ResultScreen(result: _latest!),
                        ),
                      );
                      ShellNav.bump();
                      await _load();
                    },
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
                              const Text(
                                'Ketuk untuk melihat rekomendasi',
                                style: TextStyle(color: AppColors.muted, fontSize: 13),
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
                ),
              ],
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.72),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withValues(alpha: 0.8)),
          ),
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
      ),
    );
  }
}

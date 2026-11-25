import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../models/activity_log.dart';
import '../models/assessment_result.dart';
import '../models/career_step.dart';
import '../models/check_in.dart';
import '../navigation/shell_nav.dart';
import '../services/export_service.dart';
import '../services/session_service.dart';
import '../services/wellbeing_store.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'history_screen.dart';
import 'login_screen.dart';
import 'steps_screen.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  final _wellbeing = WellbeingStore();
  final _assessmentStore = AssessmentStore();
  final _export = ExportService();

  CheckIn? _todayCheckIn;
  int _streak = 0;
  int _doneSteps = 0;
  int _openSteps = 0;
  AssessmentResult? _latestAssessment;
  List<ActivityLog> _activities = [];
  List<int?> _weekLevels = List.filled(7, null);
  Set<DateTime> _activeDays = {};
  var _loading = true;

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
    final results = await Future.wait([
      _wellbeing.todayCheckIn(),
      _wellbeing.practiceStreakDays(),
      _wellbeing.getSteps(),
      _assessmentStore.getHistory(),
      _wellbeing.getActivities(),
      _wellbeing.last7DayCheckInLevels(),
      _wellbeing.activityDaysInLast(14),
    ]);

    final steps = results[2] as List<CareerStep>;
    final history = results[3] as List<AssessmentResult>;

    if (!mounted) return;
    setState(() {
      _todayCheckIn = results[0] as CheckIn?;
      _streak = results[1] as int;
      _doneSteps = steps.where((e) => e.isDone).length;
      _openSteps = steps.where((e) => !e.isDone).length;
      _latestAssessment = history.isEmpty ? null : history.first;
      _activities = (results[4] as List<ActivityLog>).take(8).toList();
      _weekLevels = results[5] as List<int?>;
      _activeDays = results[6] as Set<DateTime>;
      _loading = false;
    });
  }

  IconData _activityIcon(String type) {
    switch (type) {
      case 'breathing':
        return Icons.air_rounded;
      case 'grounding':
        return Icons.spa_rounded;
      case 'check_in':
        return Icons.favorite_outline_rounded;
      case 'journal':
        return Icons.edit_note_rounded;
      case 'step_add':
      case 'step_done':
        return Icons.flag_outlined;
      case 'worry_sort':
        return Icons.filter_alt_outlined;
      case 'strength_pick':
        return Icons.star_outline_rounded;
      case 'body_scan':
        return Icons.accessibility_new_rounded;
      case 'mindful_pause':
        return Icons.self_improvement_rounded;
      default:
        return Icons.check_circle_outline_rounded;
    }
  }

  Future<void> _exportData() async {
    final json = await _export.buildJsonExport();
    await Clipboard.setData(ClipboardData(text: json));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data JSON disalin ke clipboard (mode penelitian).'),
      ),
    );
  }

  Future<void> _confirmClear() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus semua data lokal?'),
        content: const Text(
          'Asesmen, check-in, jurnal, langkah, dan aktivitas di perangkat ini akan dihapus. '
          'Profil login juga dibersihkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await _export.clearAllLocalData();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progres'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'export') _exportData();
              if (value == 'clear') _confirmClear();
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'export',
                child: Text('Ekspor JSON (penelitian)'),
              ),
              PopupMenuItem(
                value: 'clear',
                child: Text('Hapus data lokal'),
              ),
            ],
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : AtmosphereBackground(
              child: RefreshIndicator(
                onRefresh: _load,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: SoftPanel(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Streak',
                                  style: TextStyle(color: AppColors.muted),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '$_streak hari',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 22,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: SoftPanel(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Langkah selesai',
                                  style: TextStyle(color: AppColors.muted),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '$_doneSteps',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 22,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    WeekSparkline(levels: _weekLevels),
                    const SizedBox(height: 12),
                    StreakCalendarStrip(activeDays: _activeDays),
                    const SizedBox(height: 12),
                    SoftPanel(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Check-in hari ini',
                            style: TextStyle(fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _todayCheckIn == null
                                ? 'Belum ada check-in hari ini.'
                                : 'Level ${_todayCheckIn!.anxietyLevel}/5 · ${_todayCheckIn!.label}',
                            style: const TextStyle(
                              color: AppColors.muted,
                              height: 1.4,
                            ),
                          ),
                          if (_todayCheckIn?.note.isNotEmpty == true) ...[
                            const SizedBox(height: 6),
                            Text(_todayCheckIn!.note),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    SoftPanel(
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text(
                          'Langkah kecil',
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                        subtitle: Text(
                          _openSteps == 0
                              ? 'Tidak ada langkah terbuka'
                              : '$_openSteps langkah masih berjalan',
                        ),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const StepsScreen(),
                            ),
                          );
                          await _load();
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    SoftPanel(
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text(
                          'Riwayat asesmen',
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                        subtitle: Text(
                          _latestAssessment == null
                              ? 'Belum ada asesmen'
                              : 'Terakhir: ${_latestAssessment!.level.label} '
                                  '(${_latestAssessment!.totalScore}/${_latestAssessment!.maxScore})',
                        ),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const HistoryScreen(),
                            ),
                          );
                          await _load();
                        },
                      ),
                    ),
                    const SizedBox(height: 18),
                    const SectionHeader(
                      title: 'Aktivitas terbaru',
                      subtitle:
                          'Jejak latihan, jurnal, dan langkah di perangkat ini.',
                    ),
                    const SizedBox(height: 10),
                    if (_activities.isEmpty)
                      EmptyState(
                        icon: Icons.insights_outlined,
                        title: 'Belum ada jejak',
                        message:
                            'Mulai dari latihan napas, check-in, atau tulis jurnal singkat.',
                        actionLabel: 'Ke latihan',
                        onAction: () => ShellNav.goPractice(),
                      )
                    else
                      ..._activities.map((item) {
                        final date = DateFormat('d MMM, HH.mm', 'id_ID')
                            .format(item.createdAt);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: SoftPanel(
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              children: [
                                PracticeIconBadge(
                                  icon: _activityIcon(item.type),
                                  color: AppColors.seed,
                                  size: 42,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        date,
                                        style: const TextStyle(
                                          color: AppColors.muted,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                  ],
                ),
              ),
            ),
    );
  }
}

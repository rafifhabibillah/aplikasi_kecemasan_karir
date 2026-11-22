import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/activity_log.dart';
import '../models/assessment_result.dart';
import '../models/career_step.dart';
import '../models/check_in.dart';
import '../services/session_service.dart';
import '../services/wellbeing_store.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'history_screen.dart';
import 'steps_screen.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  final _wellbeing = WellbeingStore();
  final _assessmentStore = AssessmentStore();

  CheckIn? _todayCheckIn;
  int _streak = 0;
  int _doneSteps = 0;
  int _openSteps = 0;
  AssessmentResult? _latestAssessment;
  List<ActivityLog> _activities = [];
  var _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final results = await Future.wait([
      _wellbeing.todayCheckIn(),
      _wellbeing.practiceStreakDays(),
      _wellbeing.getSteps(),
      _assessmentStore.getHistory(),
      _wellbeing.getActivities(),
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
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Progres')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
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
                          MaterialPageRoute(builder: (_) => const StepsScreen()),
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
                    subtitle: 'Jejak latihan, jurnal, dan langkah di perangkat ini.',
                  ),
                  const SizedBox(height: 10),
                  if (_activities.isEmpty)
                    const SoftPanel(
                      child: Text(
                        'Belum ada aktivitas. Mulai dari latihan napas atau check-in.',
                        style: TextStyle(color: AppColors.muted, height: 1.4),
                      ),
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
                              const Icon(
                                Icons.check_circle_outline_rounded,
                                color: AppColors.seed,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
    );
  }
}

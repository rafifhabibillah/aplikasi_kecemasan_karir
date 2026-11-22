import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/activity_log.dart';
import '../models/career_step.dart';
import '../models/check_in.dart';
import '../models/journal_entry.dart';

class WellbeingStore {
  static const _checkInsKey = 'check_ins';
  static const _journalsKey = 'journal_entries';
  static const _stepsKey = 'career_steps';
  static const _activitiesKey = 'activity_logs';

  Future<List<CheckIn>> getCheckIns() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_checkInsKey) ?? [];
    return raw
        .map((e) => CheckIn.fromJson(jsonDecode(e) as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> saveCheckIn(CheckIn item) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getStringList(_checkInsKey) ?? [];
    current.add(jsonEncode(item.toJson()));
    await prefs.setStringList(_checkInsKey, current);
    await logActivity(
      type: 'check_in',
      title: 'Check-in kecemasan: ${item.label}',
    );
  }

  Future<CheckIn?> todayCheckIn() async {
    final items = await getCheckIns();
    final now = DateTime.now();
    for (final item in items) {
      if (item.createdAt.year == now.year &&
          item.createdAt.month == now.month &&
          item.createdAt.day == now.day) {
        return item;
      }
    }
    return null;
  }

  Future<List<JournalEntry>> getJournals() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_journalsKey) ?? [];
    return raw
        .map(
          (e) => JournalEntry.fromJson(jsonDecode(e) as Map<String, dynamic>),
        )
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> saveJournal(JournalEntry item) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getStringList(_journalsKey) ?? [];
    current.add(jsonEncode(item.toJson()));
    await prefs.setStringList(_journalsKey, current);
    await logActivity(type: 'journal', title: 'Jurnal refleksi disimpan');
  }

  Future<List<CareerStep>> getSteps() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_stepsKey) ?? [];
    return raw
        .map((e) => CareerStep.fromJson(jsonDecode(e) as Map<String, dynamic>))
        .toList()
      ..sort((a, b) {
        if (a.isDone != b.isDone) return a.isDone ? 1 : -1;
        return b.createdAt.compareTo(a.createdAt);
      });
  }

  Future<void> saveSteps(List<CareerStep> steps) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _stepsKey,
      steps.map((e) => jsonEncode(e.toJson())).toList(),
    );
  }

  Future<void> addStep(CareerStep step) async {
    final steps = await getSteps();
    steps.add(step);
    await saveSteps(steps);
    await logActivity(type: 'step_add', title: 'Langkah baru: ${step.title}');
  }

  Future<void> toggleStep(String id) async {
    final steps = await getSteps();
    final updated = steps.map((step) {
      if (step.id != id) return step;
      final nextDone = !step.isDone;
      return CareerStep(
        id: step.id,
        title: step.title,
        createdAt: step.createdAt,
        isDone: nextDone,
        doneAt: nextDone ? DateTime.now() : null,
      );
    }).toList();
    await saveSteps(updated);
    final target = updated.firstWhere((e) => e.id == id);
    if (target.isDone) {
      await logActivity(
        type: 'step_done',
        title: 'Langkah selesai: ${target.title}',
      );
    }
  }

  Future<void> deleteStep(String id) async {
    final steps = await getSteps();
    await saveSteps(steps.where((e) => e.id != id).toList());
  }

  Future<List<ActivityLog>> getActivities() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_activitiesKey) ?? [];
    return raw
        .map(
          (e) => ActivityLog.fromJson(jsonDecode(e) as Map<String, dynamic>),
        )
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> logActivity({
    required String type,
    required String title,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getStringList(_activitiesKey) ?? [];
    final item = ActivityLog(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      createdAt: DateTime.now(),
      type: type,
      title: title,
    );
    current.add(jsonEncode(item.toJson()));
    // Batasi supaya storage lokal tidak membengkak.
    final trimmed = current.length > 80
        ? current.sublist(current.length - 80)
        : current;
    await prefs.setStringList(_activitiesKey, trimmed);
  }

  Future<int> practiceStreakDays() async {
    final activities = await getActivities();
    final practiceTypes = {
      'breathing',
      'grounding',
      'mindful_pause',
      'body_scan',
      'worry_sort',
      'strength_pick',
      'check_in',
      'journal',
    };
    final days = activities
        .where((e) => practiceTypes.contains(e.type))
        .map((e) => DateTime(e.createdAt.year, e.createdAt.month, e.createdAt.day))
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a));

    if (days.isEmpty) return 0;

    var streak = 0;
    var cursor = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    // Izinkan streak tetap jalan jika hari ini belum mulai, mulai dari kemarin.
    if (!days.contains(cursor)) {
      cursor = cursor.subtract(const Duration(days: 1));
    }

    while (days.contains(cursor)) {
      streak += 1;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return streak;
  }
}

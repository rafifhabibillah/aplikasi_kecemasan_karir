import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'session_service.dart';
import 'wellbeing_store.dart';

/// Ekspor data lokal (mode penelitian / backup) tanpa mengirim ke server.
class ExportService {
  final _session = SessionService();
  final _assessments = AssessmentStore();
  final _wellbeing = WellbeingStore();

  Future<String> buildJsonExport() async {
    final prefs = await SharedPreferences.getInstance();
    final name = await _session.getStudentName();
    final nis = await _session.getStudentNis();
    final history = await _assessments.getHistory();
    final checkIns = await _wellbeing.getCheckIns();
    final journals = await _wellbeing.getJournals();
    final steps = await _wellbeing.getSteps();
    final activities = await _wellbeing.getActivities();

    final payload = {
      'exportedAt': DateTime.now().toIso8601String(),
      'app': 'Arahku',
      'student': {
        'name': name,
        'nis': nis,
      },
      'assessments': history.map((e) => e.toJson()).toList(),
      'checkIns': checkIns.map((e) => e.toJson()).toList(),
      'journals': journals.map((e) => e.toJson()).toList(),
      'careerSteps': steps.map((e) => e.toJson()).toList(),
      'activities': activities.map((e) => e.toJson()).toList(),
      'meta': {
        'keysPresent': prefs.getKeys().toList()..sort(),
        'note':
            'Data diekspor dari penyimpanan lokal perangkat. Anonimkan sebelum dibagikan.',
      },
    };

    return const JsonEncoder.withIndent('  ').convert(payload);
  }

  Future<void> clearAllLocalData() async {
    await _assessments.clear();
    await _wellbeing.clearAll();
    await _session.clearProfile();
  }
}

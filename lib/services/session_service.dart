import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/assessment_result.dart';

class SessionService {
  static const _nameKey = 'student_name';
  static const _nisKey = 'student_nis';
  static const _loggedInKey = 'is_logged_in';

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_loggedInKey) ?? false;
  }

  Future<void> login({required String name, required String nis}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nameKey, name.trim());
    await prefs.setString(_nisKey, nis.trim());
    await prefs.setBool(_loggedInKey, true);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loggedInKey, false);
  }

  Future<String> getStudentName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_nameKey) ?? 'Siswa';
  }

  Future<String> getStudentNis() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_nisKey) ?? '-';
  }
}

class AssessmentStore {
  static const _historyKey = 'assessment_history';

  Future<List<AssessmentResult>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_historyKey) ?? [];
    return raw
        .map((item) => AssessmentResult.fromJson(
              jsonDecode(item) as Map<String, dynamic>,
            ))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> save(AssessmentResult result) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getStringList(_historyKey) ?? [];
    current.add(jsonEncode(result.toJson()));
    await prefs.setStringList(_historyKey, current);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }
}

import 'package:flutter/material.dart';

import '../models/check_in.dart';
import '../services/wellbeing_store.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({super.key});

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  final _noteController = TextEditingController();
  final _store = WellbeingStore();
  double _level = 3;
  var _saving = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final item = CheckIn(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      createdAt: DateTime.now(),
      anxietyLevel: _level.round().clamp(1, 5),
      note: _noteController.text.trim(),
    );
    await _store.saveCheckIn(item);
    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final level = _level.round().clamp(1, 5);
    final labels = {
      1: 'Tenang',
      2: 'Agak ringan',
      3: 'Sedang',
      4: 'Cukup berat',
      5: 'Sangat cemas',
    };

    return Scaffold(
      appBar: AppBar(title: const Text('Check-in harian')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          SoftPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Seberapa cemas kamu soal karier hari ini?',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 18),
                Center(
                  child: Text(
                    '$level · ${labels[level]}',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: AppColors.deep,
                        ),
                  ),
                ),
                Slider(
                  value: _level,
                  min: 1,
                  max: 5,
                  divisions: 4,
                  label: labels[level],
                  onChanged: (value) => setState(() => _level = value),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _noteController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Catatan singkat (opsional)',
                    hintText: 'Apa yang sedang kamu rasakan?',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: _saving ? null : _save,
            child: Text(_saving ? 'Menyimpan...' : 'Simpan check-in'),
          ),
        ],
      ),
    );
  }
}

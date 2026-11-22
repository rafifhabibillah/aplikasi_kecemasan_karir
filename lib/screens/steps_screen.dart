import 'package:flutter/material.dart';

import '../data/mindfulness_practices.dart';
import '../models/career_step.dart';
import '../services/wellbeing_store.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class StepsScreen extends StatefulWidget {
  const StepsScreen({super.key});

  @override
  State<StepsScreen> createState() => _StepsScreenState();
}

class _StepsScreenState extends State<StepsScreen> {
  final _store = WellbeingStore();
  late Future<List<CareerStep>> _future;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    setState(() => _future = _store.getSteps());
  }

  Future<void> _addCustom() async {
    final controller = TextEditingController();
    final title = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Langkah kecil baru'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Contoh: cari info 1 jurusan',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Tambah'),
          ),
        ],
      ),
    );
    if (title == null || title.isEmpty) return;
    await _store.addStep(
      CareerStep(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        createdAt: DateTime.now(),
      ),
    );
    _reload();
  }

  Future<void> _addSuggested(String title) async {
    await _store.addStep(
      CareerStep(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        createdAt: DateTime.now(),
      ),
    );
    _reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Langkah kecil')),
      floatingActionButton: FloatingActionButton(
        onPressed: _addCustom,
        child: const Icon(Icons.add_rounded),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
        children: [
          SoftPanel(
            color: const Color(0xFFE7F1EE),
            child: Text(
              'Fokus pada tindakan kecil yang bisa dikerjakan hari ini. '
              'Ini membantu menurunkan rasa “harus segera tahu segalanya”.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.deep,
                    height: 1.45,
                  ),
            ),
          ),
          const SizedBox(height: 16),
          const SectionHeader(title: 'Saran siap pakai'),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: suggestedCareerSteps
                .map(
                  (title) => ActionChip(
                    label: Text(title),
                    onPressed: () => _addSuggested(title),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 18),
          const SectionHeader(title: 'Daftar langkahmu'),
          const SizedBox(height: 10),
          FutureBuilder<List<CareerStep>>(
            future: _future,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SoftPanel(
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final items = snapshot.data!;
              if (items.isEmpty) {
                return const SoftPanel(
                  child: Text(
                    'Belum ada langkah. Tambah dari saran atau buat sendiri.',
                    style: TextStyle(color: AppColors.muted, height: 1.4),
                  ),
                );
              }
              return Column(
                children: items.map((step) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: SoftPanel(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: CheckboxListTile(
                        value: step.isDone,
                        title: Text(
                          step.title,
                          style: TextStyle(
                            decoration: step.isDone
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            color: step.isDone
                                ? AppColors.muted
                                : AppColors.ink,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        secondary: IconButton(
                          tooltip: 'Hapus',
                          onPressed: () async {
                            await _store.deleteStep(step.id);
                            _reload();
                          },
                          icon: const Icon(Icons.delete_outline_rounded),
                        ),
                        onChanged: (_) async {
                          await _store.toggleStep(step.id);
                          _reload();
                        },
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

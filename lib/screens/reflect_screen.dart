import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/mindfulness_practices.dart';
import '../models/journal_entry.dart';
import '../services/wellbeing_store.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'check_in_screen.dart';
import 'journal_editor_screen.dart';

class ReflectScreen extends StatefulWidget {
  const ReflectScreen({super.key});

  @override
  State<ReflectScreen> createState() => _ReflectScreenState();
}

class _ReflectScreenState extends State<ReflectScreen> {
  final _store = WellbeingStore();
  late Future<List<JournalEntry>> _future;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    setState(() {
      _future = _store.getJournals();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Refleksi')),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.seed,
        foregroundColor: Colors.white,
        onPressed: () async {
          final saved = await Navigator.of(context).push<bool>(
            MaterialPageRoute(builder: (_) => const JournalEditorScreen()),
          );
          if (saved == true) _reload();
        },
        icon: const Icon(Icons.edit_note_rounded),
        label: const Text('Tulis jurnal'),
      ),
      body: AtmosphereBackground(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
          children: [
          SoftPanel(
            color: AppColors.deep,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Check-in harian',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Pantau naik-turun kecemasan kariermu dalam 1 menit.',
                  style: TextStyle(color: AppColors.soft, height: 1.4),
                ),
                const SizedBox(height: 14),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.deep,
                  ),
                  onPressed: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const CheckInScreen()),
                    );
                  },
                  child: const Text('Isi check-in'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const SectionHeader(
            title: 'Prompt refleksi',
            subtitle: 'Pilih satu pertanyaan untuk memulai jurnal.',
          ),
          const SizedBox(height: 10),
          ...journalPrompts.take(3).map(
                (prompt) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: SoftPanel(
                    padding: const EdgeInsets.all(14),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(prompt),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () async {
                        final saved = await Navigator.of(context).push<bool>(
                          MaterialPageRoute(
                            builder: (_) => JournalEditorScreen(prompt: prompt),
                          ),
                        );
                        if (saved == true) _reload();
                      },
                    ),
                  ),
                ),
              ),
          const SizedBox(height: 10),
          const SectionHeader(title: 'Jurnal terakhir'),
          const SizedBox(height: 10),
          FutureBuilder<List<JournalEntry>>(
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
                    'Belum ada jurnal. Menulis singkat sering membantu melonggarkan pikiran.',
                    style: TextStyle(color: AppColors.muted, height: 1.4),
                  ),
                );
              }
              return Column(
                children: items.take(5).map((item) {
                  final date = DateFormat('d MMM yyyy, HH.mm', 'id_ID')
                      .format(item.createdAt);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: SoftPanel(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.prompt,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            item.body,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.muted,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            date,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
        ),
      ),
    );
  }
}

import 'package:material_ui/material_ui.dart';

import '../data/mindfulness_practices.dart';
import '../models/journal_entry.dart';
import '../services/wellbeing_store.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class JournalEditorScreen extends StatefulWidget {
  const JournalEditorScreen({super.key, this.prompt});

  final String? prompt;

  @override
  State<JournalEditorScreen> createState() => _JournalEditorScreenState();
}

class _JournalEditorScreenState extends State<JournalEditorScreen> {
  late final TextEditingController _promptController;
  final _bodyController = TextEditingController();
  final _store = WellbeingStore();
  var _saving = false;

  @override
  void initState() {
    super.initState();
    _promptController = TextEditingController(
      text: widget.prompt ?? journalPrompts.first,
    );
  }

  @override
  void dispose() {
    _promptController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_bodyController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Isi jurnal dulu sebelum disimpan')),
      );
      return;
    }
    setState(() => _saving = true);
    await _store.saveJournal(
      JournalEntry(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        createdAt: DateTime.now(),
        prompt: _promptController.text.trim(),
        body: _bodyController.text.trim(),
      ),
    );
    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tulis jurnal')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          SoftPanel(
            child: Column(
              children: [
                TextField(
                  controller: _promptController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Prompt / pertanyaan',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _bodyController,
                  maxLines: 10,
                  decoration: const InputDecoration(
                    labelText: 'Tulisanmu',
                    alignLabelWithHint: true,
                    hintText: 'Tuliskan apa adanya. Tidak perlu sempurna.',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: journalPrompts
                .map(
                  (prompt) => ActionChip(
                    label: Text(
                      prompt,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onPressed: () =>
                        setState(() => _promptController.text = prompt),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: _saving ? null : _save,
            child: Text(_saving ? 'Menyimpan...' : 'Simpan jurnal'),
          ),
          const SizedBox(height: 8),
          const Text(
            'Jurnal hanya tersimpan di perangkat ini untuk saat ini.',
            style: TextStyle(color: AppColors.muted, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

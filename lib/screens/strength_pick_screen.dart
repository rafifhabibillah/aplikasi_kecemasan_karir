import 'package:material_ui/material_ui.dart';

import '../services/wellbeing_store.dart';
import '../widgets/practice_widgets.dart';

class StrengthPickScreen extends StatefulWidget {
  const StrengthPickScreen({super.key});

  @override
  State<StrengthPickScreen> createState() => _StrengthPickScreenState();
}

class _StrengthPickScreenState extends State<StrengthPickScreen> {
  static const _strengths = [
    'Rajin belajar',
    'Empati',
    'Kreatif',
    'Disiplin',
    'Komunikasi',
    'Kerja sama',
    'Sabar',
    'Cepat belajar',
    'Teliti',
    'Berani bertanya',
    'Konsisten',
    'Adaptif',
  ];

  final _store = WellbeingStore();
  final _selected = <String>{};
  final _noteController = TextEditingController();
  var _saving = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _toggle(String value) {
    setState(() {
      if (_selected.contains(value)) {
        _selected.remove(value);
      } else if (_selected.length < 3) {
        _selected.add(value);
      }
    });
  }

  Future<void> _finish() async {
    if (_selected.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih 3 kekuatan dulu')),
      );
      return;
    }
    setState(() => _saving = true);
    await _store.logActivity(
      type: 'strength_pick',
      title: 'Memilih 3 kekuatan diri',
    );
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return PracticeScaffold(
      title: '3 kekuatan',
      footer: FilledButton(
        onPressed: _saving ? null : _finish,
        child: const Text('Simpan & selesai'),
      ),
      child: ListView(
        children: [
          PracticeHeroCard(
            color: const Color(0xFF2A6F8F),
            eyebrow: 'Arah karier',
            title: 'Ambil 3 kekuatanmu',
            subtitle:
                'Sebelum memikirkan kekurangan, lihat dulu modal yang sudah kamu punya.',
            trailing: Text(
              '${_selected.length}/3',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _strengths
                .map(
                  (item) => SelectableChipCard(
                    label: item,
                    selected: _selected.contains(item),
                    icon: Icons.star_outline_rounded,
                    onTap: () => _toggle(item),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextField(
              controller: _noteController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Bagaimana kekuatan ini membantumu? (opsional)',
                alignLabelWithHint: true,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

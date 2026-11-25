import 'package:material_ui/material_ui.dart';

import '../services/wellbeing_store.dart';
import '../theme/app_theme.dart';
import '../widgets/practice_widgets.dart';

class WorrySortScreen extends StatefulWidget {
  const WorrySortScreen({super.key});

  @override
  State<WorrySortScreen> createState() => _WorrySortScreenState();
}

class _WorrySortScreenState extends State<WorrySortScreen> {
  static const _items = [
    'Nilai rapor semester ini',
    'Pilihan jurusan 5 tahun ke depan',
    'Pendapat teman soal mimpiku',
    'Mencarikan info beasiswa hari ini',
    'Reaksi orang tua suatu hari nanti',
    'Menyusun daftar minat minggu ini',
    'Ekonomi keluarga di masa depan',
    'Bertanya ke guru BK minggu ini',
  ];

  final _store = WellbeingStore();
  final _controllable = <String>{};
  final _outside = <String>{};
  var _index = 0;
  var _saving = false;

  bool get _finished => _index >= _items.length;

  Future<void> _sort(bool canControl) async {
    final item = _items[_index];
    setState(() {
      if (canControl) {
        _controllable.add(item);
      } else {
        _outside.add(item);
      }
      _index += 1;
    });

    if (_index >= _items.length) {
      setState(() => _saving = true);
      await _store.logActivity(
        type: 'worry_sort',
        title: 'Menyelesaikan pilah rasa khawatir',
      );
      if (!mounted) return;
      setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PracticeScaffold(
      title: 'Pilah khawatir',
      footer: _finished
          ? FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Selesai'),
            )
          : null,
      child: ListView(
        children: [
          if (!_finished) ...[
            StepDots(total: _items.length, current: _index),
            const SizedBox(height: 14),
            PracticeHeroCard(
              color: const Color(0xFF8A5A2B),
              eyebrow: 'Kartu ${_index + 1} / ${_items.length}',
              title: _items[_index],
              subtitle:
                  'Apakah ini sesuatu yang masih bisa kamu kerjakan hari ini/minggu ini?',
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: _saving ? null : () => _sort(true),
                    child: const Text('Bisa kukendalikan'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _saving ? null : () => _sort(false),
                    child: const Text('Di luar kendali'),
                  ),
                ),
              ],
            ),
          ] else ...[
            const PracticeHeroCard(
              color: Color(0xFF1F6F66),
              eyebrow: 'Ringkasan',
              title: 'Fokus ke yang bisa digeser',
              subtitle:
                  'Simpan energi untuk hal yang masih dalam jangkauanmu. Sisanya boleh dilepas dulu.',
            ),
            const SizedBox(height: 14),
            _SummaryCard(
              title: 'Bisa dikendalikan (${_controllable.length})',
              items: _controllable.toList(),
              color: AppColors.low,
            ),
            const SizedBox(height: 10),
            _SummaryCard(
              title: 'Di luar kendali (${_outside.length})',
              items: _outside.toList(),
              color: AppColors.warn,
            ),
          ],
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.title,
    required this.items,
    required this.color,
  });

  final String title;
  final List<String> items;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Icon(Icons.circle, size: 8, color: color),
                  const SizedBox(width: 8),
                  Expanded(child: Text(item)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

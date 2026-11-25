import 'package:material_ui/material_ui.dart';

import '../services/wellbeing_store.dart';
import '../theme/app_theme.dart';
import '../widgets/practice_widgets.dart';

class GroundingScreen extends StatefulWidget {
  const GroundingScreen({super.key});

  @override
  State<GroundingScreen> createState() => _GroundingScreenState();
}

class _GroundingScreenState extends State<GroundingScreen> {
  static const _steps = [
    (
      count: 5,
      title: 'Apa yang kamu lihat?',
      icon: Icons.visibility_outlined,
      options: ['Dinding', 'Lampu', 'Buku', 'Jendela', 'HP', 'Teman', 'Papan tulis', 'Tanaman'],
    ),
    (
      count: 4,
      title: 'Apa yang bisa kamu sentuh?',
      icon: Icons.touch_app_outlined,
      options: ['Meja', 'Kain baju', 'Lantai', 'Pena', 'Kursi', 'Tas', 'Rambut', 'Kulit tangan'],
    ),
    (
      count: 3,
      title: 'Apa yang kamu dengar?',
      icon: Icons.hearing_outlined,
      options: ['Kipas', 'Suara orang', 'Napas sendiri', 'Langkah kaki', 'AC', 'Burung', 'Hening', 'Notifikasi'],
    ),
    (
      count: 2,
      title: 'Bau apa yang terasa?',
      icon: Icons.air_rounded,
      options: ['Udara ruangan', 'Parfum', 'Minuman', 'Buku', 'Sabun', 'Makanan', 'Tidak jelas', 'Segar'],
    ),
    (
      count: 1,
      title: 'Satu rasa di tubuh',
      icon: Icons.favorite_border_rounded,
      options: ['Kaki di lantai', 'Bahu longgar', 'Dada naik-turun', 'Tangan hangat', 'Wajah rileks', 'Perut tenang'],
    ),
  ];

  final _store = WellbeingStore();
  final _selected = <int, Set<String>>{};
  var _index = 0;
  var _saving = false;

  int get _needed => _steps[_index].count;
  Set<String> get _currentSelected =>
      _selected.putIfAbsent(_index, () => <String>{});

  Future<void> _next() async {
    if (_currentSelected.length < _needed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pilih $_needed item dulu')),
      );
      return;
    }

    if (_index < _steps.length - 1) {
      setState(() => _index += 1);
      return;
    }

    setState(() => _saving = true);
    await _store.logActivity(
      type: 'grounding',
      title: 'Menyelesaikan grounding 5-4-3-2-1',
    );
    if (!mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.spa_rounded, size: 40, color: AppColors.seed),
            const SizedBox(height: 12),
            Text(
              'Kamu sudah kembali ke saat ini',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Kekhawatiran karier boleh tetap ada, tapi tubuhmu tidak harus ikut tegang sepanjang waktu.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.muted, height: 1.45),
            ),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Selesai'),
            ),
          ],
        ),
      ),
    );
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  void _toggle(String option) {
    final selected = _currentSelected;
    setState(() {
      if (selected.contains(option)) {
        selected.remove(option);
      } else if (selected.length < _needed) {
        selected.add(option);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final step = _steps[_index];
    final selectedCount = _currentSelected.length;

    return PracticeScaffold(
      title: 'Grounding',
      footer: FilledButton(
        onPressed: _saving ? null : _next,
        child: Text(
          _index == _steps.length - 1 ? 'Selesaikan grounding' : 'Lanjut',
        ),
      ),
      child: ListView(
        children: [
          StepDots(total: _steps.length, current: _index),
          const SizedBox(height: 14),
          PracticeHeroCard(
            color: const Color(0xFF2F6B4F),
            eyebrow: 'Langkah ${_index + 1} dari ${_steps.length}',
            title: step.title,
            subtitle: 'Ketuk ${step.count} pilihan yang paling terasa nyata sekarang.',
            trailing: Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(step.icon, color: Colors.white),
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Terpilih $selectedCount / $_needed',
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
                ...List.generate(_needed, (i) {
                  final filled = i < selectedCount;
                  return Container(
                    width: 12,
                    height: 12,
                    margin: const EdgeInsets.only(left: 6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: filled ? AppColors.seed : AppColors.soft,
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: step.options.map((option) {
              final selected = _currentSelected.contains(option);
              return SelectableChipCard(
                label: option,
                selected: selected,
                onTap: () => _toggle(option),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../services/wellbeing_store.dart';
import '../theme/app_theme.dart';
import '../widgets/practice_widgets.dart';

class BodyScanScreen extends StatefulWidget {
  const BodyScanScreen({super.key});

  @override
  State<BodyScanScreen> createState() => _BodyScanScreenState();
}

class _BodyScanScreenState extends State<BodyScanScreen> {
  static const _zones = [
    (title: 'Kepala & wajah', hint: 'Longgarkan dahi, rahang, dan mata.', icon: Icons.sentiment_satisfied_alt_outlined),
    (title: 'Leher & bahu', hint: 'Biarkan bahu turun jauh dari telinga.', icon: Icons.accessibility_new_rounded),
    (title: 'Dada & napas', hint: 'Rasakan napas naik-turun tanpa mengubahnya.', icon: Icons.favorite_outline_rounded),
    (title: 'Perut', hint: 'Lepaskan sedikit jika sedang menahan napas.', icon: Icons.spa_outlined),
    (title: 'Tangan', hint: 'Perhatikan suhu dan kontak jari dengan udara/benda.', icon: Icons.back_hand_outlined),
    (title: 'Kaki', hint: 'Rasakan telapak kaki menempel ke lantai.', icon: Icons.directions_walk_rounded),
  ];

  final _store = WellbeingStore();
  final _done = <int>{};
  var _index = 0;
  var _saving = false;

  Future<void> _markAndNext() async {
    setState(() => _done.add(_index));
    if (_index < _zones.length - 1) {
      setState(() => _index += 1);
      return;
    }
    setState(() => _saving = true);
    await _store.logActivity(
      type: 'body_scan',
      title: 'Menyelesaikan body scan singkat',
    );
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final zone = _zones[_index];

    return PracticeScaffold(
      title: 'Body scan',
      footer: FilledButton(
        onPressed: _saving ? null : _markAndNext,
        child: Text(
          _index == _zones.length - 1
              ? 'Selesai body scan'
              : 'Sudah kurasakan, lanjut',
        ),
      ),
      child: ListView(
        children: [
          StepDots(total: _zones.length, current: _index),
          const SizedBox(height: 14),
          PracticeHeroCard(
            color: const Color(0xFF3D7A72),
            eyebrow: 'Area ${_index + 1} / ${_zones.length}',
            title: zone.title,
            subtitle: zone.hint,
            trailing: Icon(zone.icon, color: Colors.white, size: 40),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(_zones.length, (i) {
              final selected = i == _index;
              final done = _done.contains(i);
              return AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: selected
                      ? AppColors.seed
                      : done
                          ? AppColors.soft
                          : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: selected ? AppColors.seed : AppColors.soft,
                  ),
                ),
                child: Text(
                  _zones[i].title.split(' ').first,
                  style: TextStyle(
                    color: selected ? Colors.white : AppColors.ink,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Tidak perlu mengubah apa pun. Cukup perhatikan 5–10 detik, lalu lanjut ke area berikutnya.',
              style: TextStyle(color: AppColors.muted, height: 1.45),
            ),
          ),
        ],
      ),
    );
  }
}

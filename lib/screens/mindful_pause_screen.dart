import 'package:material_ui/material_ui.dart';

import '../services/wellbeing_store.dart';
import '../widgets/practice_widgets.dart';

class MindfulPauseScreen extends StatefulWidget {
  const MindfulPauseScreen({super.key});

  @override
  State<MindfulPauseScreen> createState() => _MindfulPauseScreenState();
}

class _MindfulPauseScreenState extends State<MindfulPauseScreen> {
  final _store = WellbeingStore();
  var _index = 0;
  var _saving = false;
  String? _worry;
  String? _action;

  static const _worries = [
    'Takut salah pilih jurusan',
    'Takut mengecewakan orang tua',
    'Membandingkan diri dengan teman',
    'Belum tahu minatku',
    'Takut gagal di masa depan',
    'Tekanan harus segera memutuskan',
  ];

  static const _actions = [
    'Minum air & tarik napas 3x',
    'Tulis 1 langkah kecil',
    'Buka materi edukasi singkat',
    'Tanya 1 orang yang dipercaya',
    'Istirahat 5 menit tanpa HP',
  ];

  Future<void> _next() async {
    if (_index == 1 && _worry == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih satu kekhawatiran dulu')),
      );
      return;
    }
    if (_index == 4 && _action == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih satu respons kecil dulu')),
      );
      return;
    }

    if (_index < 4) {
      setState(() => _index += 1);
      return;
    }

    setState(() => _saving = true);
    await _store.logActivity(
      type: 'mindful_pause',
      title: 'Menyelesaikan jeda mindful karier',
    );
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return PracticeScaffold(
      title: 'Jeda mindful',
      footer: FilledButton(
        onPressed: _saving ? null : _next,
        child: Text(_index == 4 ? 'Selesai' : 'Lanjut'),
      ),
      child: ListView(
        children: [
          StepDots(total: 5, current: _index),
          const SizedBox(height: 14),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: KeyedSubtree(
              key: ValueKey(_index),
              child: _buildStep(context),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildStep(BuildContext context) {
    switch (_index) {
      case 0:
        return PracticeHeroCard(
          color: const Color(0xFFB7791F),
          eyebrow: 'Langkah 1',
          title: 'Berhenti sejenak',
          subtitle:
              'Letakkan kaki di lantai. Longgarkan rahang. Kamu tidak harus menyelesaikan semua soal karier sekarang.',
          trailing: const Icon(Icons.pause_circle_filled_rounded,
              color: Colors.white, size: 42),
        );
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PracticeHeroCard(
              color: Color(0xFFB7791F),
              eyebrow: 'Langkah 2',
              title: 'Kenali kekhawatiranmu',
              subtitle: 'Ketuk satu yang paling terasa hari ini.',
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _worries
                  .map(
                    (item) => SelectableChipCard(
                      label: item,
                      selected: _worry == item,
                      onTap: () => setState(() => _worry = item),
                    ),
                  )
                  .toList(),
            ),
          ],
        );
      case 2:
        return PracticeHeroCard(
          color: const Color(0xFF8A5A2B),
          eyebrow: 'Langkah 3',
          title: 'Temani, jangan dilawan',
          subtitle:
              'Bilang dalam hati: “${_worry ?? 'Kekhawatiran ini'} boleh ada. Aku bisa menemaninya tanpa harus segera selesai.”',
          trailing: const Icon(Icons.favorite_rounded,
              color: Colors.white, size: 36),
        );
      case 3:
        return const PracticeHeroCard(
          color: Color(0xFF1F6F66),
          eyebrow: 'Langkah 4',
          title: 'Kembali ke napas',
          subtitle:
              'Ambil 3 napas pelan. Saat menghembuskan, biarkan bahu turun sedikit. Perhatikan satu sensasi tubuh yang netral.',
          trailing: Icon(Icons.air_rounded, color: Colors.white, size: 36),
        );
      default:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PracticeHeroCard(
              color: Color(0xFF2A6F8F),
              eyebrow: 'Langkah 5',
              title: 'Pilih respons kecil',
              subtitle: 'Akhiri dengan satu tindakan yang bisa dilakukan hari ini.',
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _actions
                  .map(
                    (item) => SelectableChipCard(
                      label: item,
                      selected: _action == item,
                      onTap: () => setState(() => _action = item),
                    ),
                  )
                  .toList(),
            ),
          ],
        );
    }
  }
}

import 'package:flutter/material.dart';

import '../data/sample_instrument.dart';
import '../models/question.dart';
import '../services/scoring_service.dart';
import '../services/session_service.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'result_screen.dart';

class AssessmentScreen extends StatefulWidget {
  const AssessmentScreen({super.key});

  @override
  State<AssessmentScreen> createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends State<AssessmentScreen> {
  final _answers = <String, int>{};
  final _session = SessionService();
  final _store = AssessmentStore();
  var _index = 0;
  var _submitting = false;

  Question get _current => sampleQuestions[_index];
  bool get _isLast => _index == sampleQuestions.length - 1;
  double get _progress => (_index + 1) / sampleQuestions.length;

  Future<void> _next() async {
    if (!_answers.containsKey(_current.id)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih salah satu jawaban dulu')),
      );
      return;
    }

    if (!_isLast) {
      setState(() => _index += 1);
      return;
    }

    setState(() => _submitting = true);
    final name = await _session.getStudentName();
    final result = ScoringService.calculate(
      answers: _answers,
      studentName: name,
    );
    await _store.save(result);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => ResultScreen(result: result)),
    );
  }

  void _back() {
    if (_index == 0) {
      Navigator.of(context).maybePop();
      return;
    }
    setState(() => _index -= 1);
  }

  @override
  Widget build(BuildContext context) {
    final selected = _answers[_current.id];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Asesmen'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: _back,
        ),
      ),
      body: AtmosphereBackground(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Pertanyaan ${_index + 1} dari ${sampleQuestions.length}',
                          style: const TextStyle(
                            color: AppColors.muted,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Text(
                        '${(_progress * 100).round()}%',
                        style: const TextStyle(
                          color: AppColors.deep,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: _progress,
                      minHeight: 8,
                      backgroundColor: Colors.white,
                      color: AppColors.seed,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
                children: [
                  SoftPanel(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LevelBadge(
                          label: _current.dimension,
                          color: AppColors.seed,
                        ),
                        const SizedBox(height: 14),
                        Text(
                          _current.text,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    height: 1.35,
                                    letterSpacing: -0.2,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...likertOptions.map((option) {
                    final isSelected = selected == option.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Material(
                        color: isSelected ? AppColors.seed : Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: () {
                            setState(() => _answers[_current.id] = option.value);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.seed
                                    : AppColors.soft,
                                width: isSelected ? 1.6 : 1,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: AppColors.seed
                                            .withValues(alpha: 0.2),
                                        blurRadius: 14,
                                        offset: const Offset(0, 6),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isSelected
                                      ? Icons.check_circle_rounded
                                      : Icons.circle_outlined,
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.muted,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    option.label,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : AppColors.ink,
                                      fontWeight: isSelected
                                          ? FontWeight.w800
                                          : FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: FilledButton(
                  onPressed: _submitting ? null : _next,
                  child: Text(
                    _submitting
                        ? 'Menghitung...'
                        : (_isLast ? 'Lihat hasil' : 'Lanjut'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:async';
import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

import '../services/wellbeing_store.dart';
import '../theme/app_theme.dart';
import '../widgets/practice_widgets.dart';

enum _BreathPhase { ready, inhale, holdIn, exhale, holdOut, done }

class BreathingScreen extends StatefulWidget {
  const BreathingScreen({super.key});

  @override
  State<BreathingScreen> createState() => _BreathingScreenState();
}

class _BreathingScreenState extends State<BreathingScreen>
    with SingleTickerProviderStateMixin {
  static const _phaseSeconds = 4;
  static const _totalCycles = 4;

  late final AnimationController _controller;
  final _store = WellbeingStore();

  _BreathPhase _phase = _BreathPhase.ready;
  var _cycle = 0;
  var _secondsLeft = _phaseSeconds;
  Timer? _timer;
  var _running = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: _phaseSeconds),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  String get _phaseLabel => switch (_phase) {
        _BreathPhase.ready => 'Siap mengikuti jalur',
        _BreathPhase.inhale => 'Tarik napas',
        _BreathPhase.holdIn => 'Tahan',
        _BreathPhase.exhale => 'Buang napas',
        _BreathPhase.holdOut => 'Tahan kosong',
        _BreathPhase.done => 'Selesai dengan baik',
      };

  String get _hint => switch (_phase) {
        _BreathPhase.ready =>
          'Titik akan berjalan mengelilingi kotak. Ikuti ritmenya, bukan memaksakan napas.',
        _BreathPhase.inhale => 'Hirup pelan lewat hidung sambil mengikuti sisi atas.',
        _BreathPhase.holdIn => 'Diam sejenak. Biarkan bahu tetap longgar.',
        _BreathPhase.exhale => 'Hembuskan perlahan, lepaskan tegangan soal masa depan.',
        _BreathPhase.holdOut => 'Istirahat singkat sebelum siklus berikutnya.',
        _BreathPhase.done => 'Tubuhmu sudah mendapat jeda. Bisa diulang kapan saja.',
      };

  int get _phaseIndex => switch (_phase) {
        _BreathPhase.inhale => 0,
        _BreathPhase.holdIn => 1,
        _BreathPhase.exhale => 2,
        _BreathPhase.holdOut => 3,
        _ => -1,
      };

  Future<void> _start() async {
    setState(() {
      _running = true;
      _cycle = 1;
      _phase = _BreathPhase.inhale;
      _secondsLeft = _phaseSeconds;
    });
    _controller.forward(from: 0);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    if (_secondsLeft > 1) {
      setState(() => _secondsLeft -= 1);
      return;
    }

    if (_phase == _BreathPhase.inhale) {
      setState(() {
        _phase = _BreathPhase.holdIn;
        _secondsLeft = _phaseSeconds;
      });
      _controller.forward(from: 0);
      return;
    }
    if (_phase == _BreathPhase.holdIn) {
      setState(() {
        _phase = _BreathPhase.exhale;
        _secondsLeft = _phaseSeconds;
      });
      _controller.forward(from: 0);
      return;
    }
    if (_phase == _BreathPhase.exhale) {
      setState(() {
        _phase = _BreathPhase.holdOut;
        _secondsLeft = _phaseSeconds;
      });
      _controller.forward(from: 0);
      return;
    }
    if (_phase == _BreathPhase.holdOut) {
      if (_cycle >= _totalCycles) {
        _finish();
        return;
      }
      setState(() {
        _cycle += 1;
        _phase = _BreathPhase.inhale;
        _secondsLeft = _phaseSeconds;
      });
      _controller.forward(from: 0);
    }
  }

  Future<void> _finish() async {
    _timer?.cancel();
    _controller.stop();
    setState(() {
      _running = false;
      _phase = _BreathPhase.done;
      _secondsLeft = 0;
    });
    await _store.logActivity(
      type: 'breathing',
      title: 'Menyelesaikan latihan napas box',
    );
  }

  @override
  Widget build(BuildContext context) {
    final phases = const ['Tarik', 'Tahan', 'Buang', 'Tahan'];

    return PracticeScaffold(
      title: 'Napas box',
      footer: _phase == _BreathPhase.done
          ? Column(
              children: [
                FilledButton(
                  onPressed: () => setState(() => _phase = _BreathPhase.ready),
                  child: const Text('Ulangi latihan'),
                ),
                const SizedBox(height: 10),
                OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Kembali'),
                ),
              ],
            )
          : FilledButton(
              onPressed: _running ? null : _start,
              child: Text(_running ? 'Mengikuti ritme...' : 'Mulai ikuti jalur'),
            ),
      child: ListView(
        children: [
          PracticeHeroCard(
            eyebrow: _running
                ? 'Siklus $_cycle / $_totalCycles'
                : 'Visual box breathing',
            title: _phaseLabel,
            subtitle: _hint,
            trailing: Container(
              width: 54,
              height: 54,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                _running ? '$_secondsLeft' : '4',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 22,
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: AppColors.deep.withValues(alpha: 0.07),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 210,
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, _) {
                      final sideProgress = _running ? _controller.value : 0.0;
                      final side = _phaseIndex < 0 ? 0 : _phaseIndex;
                      return CustomPaint(
                        painter: _BoxBreathPainter(
                          side: side,
                          progress: sideProgress,
                          active: _running || _phase == _BreathPhase.done,
                        ),
                        child: const SizedBox.expand(),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: List.generate(phases.length, (index) {
                    final active = _phaseIndex == index;
                    return Expanded(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: EdgeInsets.only(
                          right: index == phases.length - 1 ? 0 : 8,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: active
                              ? AppColors.seed
                              : AppColors.creamSoft,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          phases[index],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: active ? Colors.white : AppColors.muted,
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.72),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Row(
              children: [
                Icon(Icons.tips_and_updates_outlined, color: AppColors.deep),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Tidak perlu sempurna. Kalau ketinggalan ritme, cukup kembali di napas berikutnya.',
                    style: TextStyle(color: AppColors.muted, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _BoxBreathPainter extends CustomPainter {
  _BoxBreathPainter({
    required this.side,
    required this.progress,
    required this.active,
  });

  final int side;
  final double progress;
  final bool active;

  @override
  void paint(Canvas canvas, Size size) {
    final squareSize = math.min(size.width, size.height) * 0.62;
    final left = (size.width - squareSize) / 2;
    final top = (size.height - squareSize) / 2;
    final rect = Rect.fromLTWH(left, top, squareSize, squareSize);

    final track = Paint()
      ..color = AppColors.soft
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round;
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(18)),
      track,
    );

    final glow = Paint()
      ..color = AppColors.seed.withValues(alpha: 0.18)
      ..strokeWidth = 16
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final activePaint = Paint()
      ..color = AppColors.seed
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Offset corner(int index) {
      switch (index % 4) {
        case 0:
          return Offset(rect.left, rect.top);
        case 1:
          return Offset(rect.right, rect.top);
        case 2:
          return Offset(rect.right, rect.bottom);
        default:
          return Offset(rect.left, rect.bottom);
      }
    }

    if (active && side >= 0) {
      final a = corner(side);
      final b = corner(side + 1);
      final current = Offset.lerp(a, b, progress.clamp(0.0, 1.0))!;
      canvas.drawLine(a, current, glow);
      canvas.drawLine(a, current, activePaint);

      final dotGlow = Paint()
        ..color = AppColors.seed.withValues(alpha: 0.25)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
      canvas.drawCircle(current, 14, dotGlow);
      canvas.drawCircle(current, 8, Paint()..color = AppColors.deep);
      canvas.drawCircle(current, 4, Paint()..color = Colors.white);
    } else {
      canvas.drawCircle(corner(0), 7, Paint()..color = AppColors.seed);
    }

    final labelStyle = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    void drawLabel(String text, Offset pos) {
      labelStyle.text = TextSpan(
        text: text,
        style: const TextStyle(
          color: AppColors.muted,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      );
      labelStyle.layout();
      labelStyle.paint(
        canvas,
        Offset(pos.dx - labelStyle.width / 2, pos.dy - labelStyle.height / 2),
      );
    }

    drawLabel('tarik', Offset(rect.center.dx, rect.top - 18));
    drawLabel('tahan', Offset(rect.right + 28, rect.center.dy));
    drawLabel('buang', Offset(rect.center.dx, rect.bottom + 18));
    drawLabel('tahan', Offset(rect.left - 28, rect.center.dy));
  }

  @override
  bool shouldRepaint(covariant _BoxBreathPainter oldDelegate) {
    return oldDelegate.side != side ||
        oldDelegate.progress != progress ||
        oldDelegate.active != active;
  }
}

import 'package:material_ui/material_ui.dart';

import '../brand/app_brand.dart';
import '../services/session_service.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  final _session = SessionService();
  var _page = 0;

  static const _pages = [
    (
      title: 'Pahami cemas kariermu',
      body:
          'Arahku membantu mengukur kecemasan soal masa depan, lalu memberi arah latihan yang cocok — bukan menghakimi.',
      icon: Icons.explore_rounded,
    ),
    (
      title: 'Data tetap di perangkatmu',
      body:
          'Hasil asesmen, jurnal, dan check-in disimpan lokal di HP. Cocok untuk uji coba dan demo penelitian.',
      icon: Icons.lock_outline_rounded,
    ),
    (
      title: 'Bukan pengganti konseling',
      body:
          'Latihan di sini bersifat pendukung. Jika rasa cemas sudah mengganggu tidur atau belajar, bicara dengan guru BK.',
      icon: Icons.favorite_outline_rounded,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    await _session.setOnboardingDone();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 420),
      ),
    );
  }

  void _next() {
    if (_page >= _pages.length - 1) {
      _finish();
      return;
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 360),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AtmosphereBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: Column(
              children: [
                Row(
                  children: [
                    const BrandMark(size: 36, showShadow: false),
                    const SizedBox(width: 10),
                    Text(
                      AppBrand.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.4,
                          ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: _finish,
                      child: const Text('Lewati'),
                    ),
                  ],
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _pages.length,
                    onPageChanged: (value) => setState(() => _page = value),
                    itemBuilder: (context, index) {
                      final item = _pages[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SoftPanel(
                              color: AppColors.deep,
                              padding: const EdgeInsets.all(28),
                              child: Icon(
                                item.icon,
                                size: 56,
                                color: AppColors.accent,
                              ),
                            ),
                            const SizedBox(height: 28),
                            Text(
                              item.title,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.5,
                                  ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              item.body,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color: AppColors.muted,
                                    height: 1.5,
                                  ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_pages.length, (index) {
                    final active = index == _page;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: active ? 22 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: active ? AppColors.seed : AppColors.soft,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 22),
                FilledButton(
                  onPressed: _next,
                  child: Text(
                    _page == _pages.length - 1 ? 'Mulai' : 'Lanjut',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:material_ui/material_ui.dart';

import '../navigation/shell_nav.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';
import 'practice_hub_screen.dart';
import 'progress_screen.dart';
import 'reflect_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
    ShellNav.tabIndex.value = _index;
    ShellNav.tabIndex.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    final next = ShellNav.tabIndex.value;
    if (next != _index && mounted) {
      setState(() => _index = next);
    }
  }

  @override
  void dispose() {
    ShellNav.tabIndex.removeListener(_onTabChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: const [
          HomeScreen(),
          PracticeHubScreen(),
          ReflectScreen(),
          ProgressScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        backgroundColor: Colors.white,
        indicatorColor: AppColors.soft,
        surfaceTintColor: Colors.transparent,
        shadowColor: AppColors.deep.withValues(alpha: 0.08),
        elevation: 8,
        onDestinationSelected: (value) {
          setState(() => _index = value);
          ShellNav.tabIndex.value = value;
          ShellNav.bump();
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.spa_outlined),
            selectedIcon: Icon(Icons.spa_rounded),
            label: 'Latihan',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book_rounded),
            label: 'Refleksi',
          ),
          NavigationDestination(
            icon: Icon(Icons.insights_outlined),
            selectedIcon: Icon(Icons.insights_rounded),
            label: 'Progres',
          ),
        ],
      ),
    );
  }
}

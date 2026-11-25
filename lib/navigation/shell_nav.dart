import 'package:flutter/foundation.dart';

/// Kontrol tab shell + sinyal refresh lintas layar tanpa remount.
class ShellNav {
  ShellNav._();

  static final ValueNotifier<int> tabIndex = ValueNotifier<int>(0);
  static final ValueNotifier<int> refreshTick = ValueNotifier<int>(0);

  static void goTab(int index) {
    tabIndex.value = index;
    bump();
  }

  static void goHome() => goTab(0);

  static void goPractice() => goTab(1);

  static void goReflect() => goTab(2);

  static void goProgress() => goTab(3);

  static void bump() {
    refreshTick.value = refreshTick.value + 1;
  }
}

import 'package:aplikasi_kecemasan_karir/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App starts at splash branding', (tester) async {
    await tester.pumpWidget(const ArahTenangApp());
    expect(find.text('ArahTenang'), findsOneWidget);
  });
}

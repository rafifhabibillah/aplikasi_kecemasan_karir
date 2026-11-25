import 'package:aplikasi_kecemasan_karir/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Arahku splash shows brand', (tester) async {
    await tester.pumpWidget(const ArahkuApp());
    expect(find.text('Arahku'), findsOneWidget);
  });
}

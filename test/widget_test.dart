import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:platinum_world_management_system/main.dart';

void main() {
  testWidgets('PWMS App renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: PWMSApp(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('PWMS'), findsOneWidget);
    expect(find.text('Tu Mundo Digital'), findsOneWidget);
  });
}

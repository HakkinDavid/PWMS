import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:platinum_world_management_system/main.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';

void main() {
  testWidgets('PWMS App renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: PWMSApp(),
      ),
    );

    await tester.pump(const Duration(seconds: 1));

    expect(find.text(AppStrings.appName), findsWidgets);
  });
}

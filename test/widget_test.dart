import 'package:flutter/material.dart';
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

  testWidgets('MainShellScreen renders single persistent + FAB across tabs', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: PWMSApp(),
      ),
    );
    await tester.pump(const Duration(seconds: 1));

    // There should be exactly one FloatingActionButton in the shell
    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.widgetWithIcon(FloatingActionButton, Icons.add), findsOneWidget);

    // Switch to Inventario tab
    final inventoryTab = find.byIcon(Icons.inventory_2_outlined);
    if (inventoryTab.evaluate().isNotEmpty) {
      await tester.tap(inventoryTab);
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.widgetWithIcon(FloatingActionButton, Icons.add), findsOneWidget);
    }

    // Switch to Catálogo tab
    final catalogTab = find.byIcon(Icons.category_outlined);
    if (catalogTab.evaluate().isNotEmpty) {
      await tester.tap(catalogTab);
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.widgetWithIcon(FloatingActionButton, Icons.add), findsOneWidget);
    }

    // Switch to Buscar tab
    final searchTab = find.byIcon(Icons.search_outlined);
    if (searchTab.evaluate().isNotEmpty) {
      await tester.tap(searchTab);
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.widgetWithIcon(FloatingActionButton, Icons.add), findsOneWidget);
    }
  });
}

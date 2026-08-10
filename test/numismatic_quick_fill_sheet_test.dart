import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/numismatic_recognition_models.dart';
import 'package:platinum_world_management_system/src/features/catalog/presentation/numismatic_quick_fill_sheet.dart';

void main() {
  testWidgets('NumismaticQuickFillSheet blocks submit if fields are null/empty', (WidgetTester tester) async {
    NumismaticScanResult? submittedResult;

    final dummyObverse = File('/tmp/obverse.jpg');

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: NumismaticQuickFillSheet(
              obversePhoto: dummyObverse,
              isCoin: true,
              onResultSubmitted: (result) {
                submittedResult = result;
              },
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify all dropdown fields display 'Sin selección' as default value
    expect(find.text('Sin selección'), findsNWidgets(5)); // País, Denominación, Divisa, Conservación, Material

    // Tap submit button with null fields
    final submitText = find.text(AppStrings.confirmAndRegisterPieceAction);
    await tester.ensureVisible(submitText);
    await tester.tap(submitText);
    await tester.pumpAndSettle();

    // Should NOT submit because fields are null
    expect(submittedResult, isNull);
    expect(find.text('Por favor completa todos los campos antes de guardar.'), findsOneWidget);
  });

  testWidgets('NumismaticQuickFillSheet submits successfully when all fields are populated', (WidgetTester tester) async {
    NumismaticScanResult? submittedResult;

    final dummyObverse = File('/tmp/obverse.jpg');

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: NumismaticQuickFillSheet(
              obversePhoto: dummyObverse,
              isCoin: true,
              onResultSubmitted: (result) {
                submittedResult = result;
              },
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // 1. Select Country (México)
    final countryDropdown = find.byType(DropdownButtonFormField<String?>).at(0);
    await tester.tap(countryDropdown);
    await tester.pumpAndSettle();
    await tester.tap(find.text('México').last);
    await tester.pumpAndSettle();

    // 2. Select Denomination (5)
    final denomDropdown = find.byType(DropdownButtonFormField<String?>).at(1);
    await tester.tap(denomDropdown);
    await tester.pumpAndSettle();
    await tester.tap(find.text('5').last);
    await tester.pumpAndSettle();

    // 3. Select Currency (MXN)
    final currencyDropdown = find.byType(DropdownButtonFormField<String?>).at(2);
    await tester.tap(currencyDropdown);
    await tester.pumpAndSettle();
    await tester.tap(find.text('MXN (Peso Mexicano)').last);
    await tester.pumpAndSettle();

    // 4. Enter Year (1982)
    final yearField = find.byType(TextFormField);
    await tester.enterText(yearField, '1982');
    await tester.pumpAndSettle();

    // 5. Select Grade (MBC / VF (Muy Buena))
    final gradeDropdown = find.byType(DropdownButtonFormField<String?>).at(3);
    await tester.tap(gradeDropdown);
    await tester.pumpAndSettle();
    await tester.tap(find.text('MBC / VF (Muy Buena)').last);
    await tester.pumpAndSettle();

    // 6. Select Material (Cuproníquel)
    final matDropdown = find.byType(DropdownButtonFormField<String?>).at(4);
    await tester.tap(matDropdown);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cuproníquel').last);
    await tester.pumpAndSettle();

    // Submit
    final submitText = find.text(AppStrings.confirmAndRegisterPieceAction);
    await tester.ensureVisible(submitText);
    await tester.tap(submitText);
    await tester.pumpAndSettle();

    expect(submittedResult, isNotNull);
    expect(submittedResult!.country, equals('México'));
    expect(submittedResult!.currencyCode, equals('MXN'));
    expect(submittedResult!.currencyName, equals('Peso Mexicano'));
    expect(submittedResult!.faceValueNumber, equals(5.0));
    expect(submittedResult!.year, equals('1982'));
    expect(submittedResult!.grade, equals('MBC / VF (Muy Buena)'));
    expect(submittedResult!.composition, equals('Cuproníquel'));
    expect(submittedResult!.subspeciesName, equals('5 Peso Mexicano - México - (1982)'));
  });
}

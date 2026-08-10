import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/numismatic_recognition_models.dart';
import 'package:platinum_world_management_system/src/features/catalog/presentation/numismatic_quick_fill_sheet.dart';

void main() {
  testWidgets('NumismaticQuickFillSheet has all fields empty/unselected by default', (WidgetTester tester) async {
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

    final submitText = find.text(AppStrings.confirmAndRegisterPieceAction);
    await tester.ensureVisible(submitText);
    await tester.tap(submitText);
    await tester.pumpAndSettle();

    expect(submittedResult, isNotNull);
    expect(submittedResult!.country, isNull);
    expect(submittedResult!.currencyCode, isNull);
    expect(submittedResult!.currencyName, isNull);
    expect(submittedResult!.faceValueNumber, isNull);
    expect(submittedResult!.grade, isNull);
    expect(submittedResult!.composition, isNull);
    expect(submittedResult!.year, isNull);
    expect(submittedResult!.isSpecialEdition, isFalse);
    expect(submittedResult!.subspeciesName, equals('Moneda'));
  });
}

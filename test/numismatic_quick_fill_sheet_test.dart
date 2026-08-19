import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/widgets/app_wheel_picker.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/numismatic_recognition_models.dart';
import 'package:platinum_world_management_system/src/features/catalog/presentation/numismatic_quick_fill_sheet.dart';

void main() {
  Future<void> selectWheelOption(WidgetTester tester, Finder fieldFinder, String optionText) async {
    await tester.scrollUntilVisible(fieldFinder, 100, scrollable: find.byType(Scrollable).first);
    await tester.pumpAndSettle();
    await tester.tap(fieldFinder);
    await tester.pumpAndSettle();

    final optionFinder = find.text(optionText);
    if (optionFinder.evaluate().isNotEmpty) {
      await tester.tap(optionFinder.last, warnIfMissed: false);
      await tester.pumpAndSettle();
    } else {
      final picker = find.byType(CupertinoPicker);
      if (picker.evaluate().isNotEmpty) {
        for (int i = 0; i < 20; i++) {
          await tester.drag(picker, const Offset(0, -44));
          await tester.pumpAndSettle();
          if (find.text(optionText).evaluate().isNotEmpty) {
            await tester.tap(find.text(optionText).last, warnIfMissed: false);
            await tester.pumpAndSettle();
            break;
          }
        }
      }
    }

    final confirmButton = find.widgetWithText(ElevatedButton, AppStrings.confirm);
    await tester.tap(confirmButton);
    await tester.pumpAndSettle();
  }

  testWidgets('NumismaticQuickFillSheet blocks submit if fields are null/empty', (WidgetTester tester) async {
    NumismaticScanResult? submittedResult;

    final dummyObverse = File('/tmp/obverse.jpg');

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          key: UniqueKey(),
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
      ),
    );

    await tester.pumpAndSettle();

    // Verify all wheel picker fields display 'Sin selección' as default value
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
      ProviderScope(
        child: MaterialApp(
          key: UniqueKey(),
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
      ),
    );

    await tester.pumpAndSettle();

    // 1. Select Country (México)
    final countryField = find.byType(AppWheelPickerField<String?>).at(0);
    await selectWheelOption(tester, countryField, 'México');

    // 2. Select Denomination (5)
    final denomField = find.byType(AppWheelPickerField<String?>).at(1);
    await selectWheelOption(tester, denomField, '5');

    // 3. Select Currency (MXN)
    final currencyField = find.byType(AppWheelPickerField<String?>).at(2);
    await selectWheelOption(tester, currencyField, 'MXN (Pesos Mexicanos)');

    // 4. Enter Year (1982)
    final yearField = find.byType(TextFormField);
    await tester.enterText(yearField, '1982');
    await tester.pumpAndSettle();

    // 5. Select Grade (MBC / VF (Muy Buena))
    final gradeField = find.byType(AppWheelPickerField<String?>).at(3);
    await selectWheelOption(tester, gradeField, 'Muy buena');

    // 6. Select Material (Cuproníquel)
    final matField = find.byType(AppWheelPickerField<String?>).at(4);
    await selectWheelOption(tester, matField, 'Cuproníquel');

    // Submit
    final submitText = find.text(AppStrings.confirmAndRegisterPieceAction);
    await tester.ensureVisible(submitText);
    await tester.tap(submitText);
    await tester.pumpAndSettle();

    expect(submittedResult, isNotNull);
    expect(submittedResult!.country, equals('México'));
    expect(submittedResult!.currencyCode, equals('MXN'));
    expect(submittedResult!.currencyName, equals('Pesos Mexicanos'));
    expect(submittedResult!.faceValueNumber, equals(5.0));
    expect(submittedResult!.year, equals('1982'));
    expect(submittedResult!.grade, equals('Muy buena'));
    expect(submittedResult!.composition, equals('Cuproníquel'));
    expect(submittedResult!.subspeciesName, equals('5 Pesos Mexicanos - México (1982)'));
  });

  testWidgets('NumismaticQuickFillSheet summons numeric decimal text entry when denomination is Otro and validates properly', (WidgetTester tester) async {
    NumismaticScanResult? submittedResult;

    final dummyObverse = File('/tmp/obverse.jpg');

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          key: UniqueKey(),
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
      ),
    );

    await tester.pumpAndSettle();

    // 1. Select Country (México)
    final countryField = find.byType(AppWheelPickerField<String?>).at(0);
    await selectWheelOption(tester, countryField, 'México');

    // 2. Select Denomination ("Otro")
    final denomField = find.byType(AppWheelPickerField<String?>).at(1);
    await selectWheelOption(tester, denomField, 'Otro');

    // Verify the custom denomination text field is summoned
    expect(find.text('Número de denominación'), findsOneWidget);

    // 3. Select Currency (MXN)
    final currencyField = find.byType(AppWheelPickerField<String?>).at(2);
    await selectWheelOption(tester, currencyField, 'MXN (Pesos Mexicanos)');

    // 4. Enter Year (1975)
    final yearField = find.widgetWithText(TextFormField, 'Año de emisión');
    await tester.enterText(yearField, '1975');
    await tester.pumpAndSettle();

    // 5. Select Grade (Sin circular)
    final gradeField = find.byType(AppWheelPickerField<String?>).at(3);
    await selectWheelOption(tester, gradeField, 'Sin circular');

    // 6. Select Material (Plata)
    final matField = find.byType(AppWheelPickerField<String?>).at(4);
    await selectWheelOption(tester, matField, 'Plata');

    // Try to submit with empty custom denomination -> should fail
    final submitButton = find.text(AppStrings.confirmAndRegisterPieceAction);
    await tester.ensureVisible(submitButton);
    await tester.tap(submitButton);
    await tester.pumpAndSettle();

    expect(submittedResult, isNull);
    expect(find.text('Ingresa el número de denominación'), findsOneWidget);

    // Dismiss SnackBar and enter custom denomination
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();

    // Enter a decimal custom denomination (e.g. 0.50)
    final customDenomField = find.widgetWithText(TextFormField, 'Número de denominación');
    await tester.enterText(customDenomField, '0.50');
    await tester.pumpAndSettle();

    // Submit successfully
    await tester.ensureVisible(submitButton);
    await tester.tap(submitButton);
    await tester.pumpAndSettle();

    expect(submittedResult, isNotNull);
    expect(submittedResult!.faceValueNumber, equals(0.5));
    expect(submittedResult!.subspeciesName, equals('0.50 Pesos Mexicanos - México (1975)'));
    expect(submittedResult!.country, equals('México'));
    expect(submittedResult!.currencyCode, equals('MXN'));
  });

  testWidgets('NumismaticQuickFillSheet handles Special Edition Otro option with summoned notes', (WidgetTester tester) async {
    NumismaticScanResult? submittedResult;

    final dummyObverse = File('/tmp/obverse.jpg');

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          key: UniqueKey(),
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
      ),
    );

    await tester.pumpAndSettle();

    // 1. Select Country (México)
    final countryField = find.byType(AppWheelPickerField<String?>).at(0);
    await selectWheelOption(tester, countryField, 'México');

    // 2. Select Denomination (20)
    final denomField = find.byType(AppWheelPickerField<String?>).at(1);
    await selectWheelOption(tester, denomField, '20');

    // 3. Select Currency (MXN)
    final currencyField = find.byType(AppWheelPickerField<String?>).at(2);
    await selectWheelOption(tester, currencyField, 'MXN (Pesos Mexicanos)');

    // 4. Enter Year (2021)
    final yearField = find.widgetWithText(TextFormField, 'Año de emisión');
    await tester.enterText(yearField, '2021');
    await tester.pumpAndSettle();

    // 5. Select Grade (Sin circular)
    final gradeField = find.byType(AppWheelPickerField<String?>).at(3);
    await selectWheelOption(tester, gradeField, 'Sin circular');

    // 6. Select Material (Bimetálica)
    final matField = find.byType(AppWheelPickerField<String?>).at(4);
    await selectWheelOption(tester, matField, 'Bimetálica');

    // 7. Check Special Edition
    final checkbox = find.byType(CheckboxListTile);
    await tester.ensureVisible(checkbox);
    await tester.tap(checkbox);
    await tester.pumpAndSettle();

    // 8. Select Special Edition Reason ('Otro')
    final reasonField = find.byType(AppWheelPickerField<String?>).last;
    await selectWheelOption(tester, reasonField, 'Otro');

    // Verify notes field is summoned
    expect(find.text(AppStrings.specialEditionNotesLabel), findsOneWidget);

    // Enter notes
    final notesField = find.widgetWithText(TextFormField, AppStrings.specialEditionNotesLabel);
    await tester.ensureVisible(notesField);
    await tester.enterText(notesField, 'Bicentenario de la Independencia');
    await tester.pumpAndSettle();

    // Submit
    final submitButton = find.text(AppStrings.confirmAndRegisterPieceAction);
    await tester.ensureVisible(submitButton);
    await tester.tap(submitButton);
    await tester.pumpAndSettle();

    expect(submittedResult, isNotNull);
    expect(submittedResult!.isSpecialEdition, isTrue);
    expect(submittedResult!.specialEditionReason, equals('Otro'));
    expect(submittedResult!.specialEditionNotes, equals('Bicentenario de la Independencia'));
  });

  testWidgets('NumismaticQuickFillSheet filters currencies based on selected country and resets currency if not valid', (WidgetTester tester) async {
    final dummyObverse = File('/tmp/obverse.jpg');

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          key: UniqueKey(),
          home: Scaffold(
            body: SingleChildScrollView(
              child: NumismaticQuickFillSheet(
                obversePhoto: dummyObverse,
                isCoin: true,
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // 1. Select Country 'Estados Unidos'
    final countryField = find.byType(AppWheelPickerField<String?>).at(0);
    await selectWheelOption(tester, countryField, 'Estados Unidos');

    // 2. Open Currency Picker -> Should only show 'Sin selección' and 'USD (Dólares Estadounidenses)'
    final currencyField = find.byType(AppWheelPickerField<String?>).at(2);
    await tester.ensureVisible(currencyField);
    await tester.tap(currencyField);
    await tester.pumpAndSettle();

    expect(find.text('USD (Dólares Estadounidenses)'), findsWidgets);
    expect(find.text('MXN (Pesos Mexicanos)'), findsNothing);

    // Select USD
    await tester.tap(find.text('USD (Dólares Estadounidenses)').last);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, AppStrings.confirm));
    await tester.pumpAndSettle();

    // 3. Change Country to 'México'
    await selectWheelOption(tester, countryField, 'México');

    // USD is not a currency for Mexico, so currency dropdown should reset to null ('Sin selección')
    // Open Currency Picker -> Should show MXN and MXP, but not USD
    await tester.ensureVisible(currencyField);
    await tester.tap(currencyField);
    await tester.pumpAndSettle();

    expect(find.text('MXN (Pesos Mexicanos)'), findsWidgets);
    expect(find.text('MXP (Pesos Mexicanos Antiguos)'), findsWidgets);
    expect(find.text('USD (Dólares Estadounidenses)'), findsNothing);

    // Dismiss bottom sheet
    await tester.tap(find.widgetWithText(ElevatedButton, AppStrings.confirm));
    await tester.pumpAndSettle();
  });
}


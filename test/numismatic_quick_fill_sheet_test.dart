import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/core/database/app_database.dart';
import 'package:platinum_world_management_system/src/core/providers/providers.dart';
import 'package:platinum_world_management_system/src/core/widgets/app_wheel_picker.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/numismatic_recognition_models.dart';
import 'package:platinum_world_management_system/src/features/catalog/presentation/numismatic_quick_fill_sheet.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    FocusManager.instance.primaryFocus?.unfocus();
    NumismaticQuickFillSheet.resetStaticCache();
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });
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
        for (int i = 0; i < 30; i++) {
          if (find.text(optionText).evaluate().isNotEmpty) {
            await tester.tap(find.text(optionText).last, warnIfMissed: false);
            await tester.pumpAndSettle();
            break;
          }
          await tester.drag(picker, const Offset(0, -44));
          await tester.pumpAndSettle();
        }
        if (find.text(optionText).evaluate().isEmpty) {
          for (int i = 0; i < 30; i++) {
            await tester.drag(picker, const Offset(0, 44));
            await tester.pumpAndSettle();
            if (find.text(optionText).evaluate().isNotEmpty) {
              await tester.tap(find.text(optionText).last, warnIfMissed: false);
              await tester.pumpAndSettle();
              break;
            }
          }
        }
      }
    }

    final confirmButton = find.widgetWithText(ElevatedButton, AppStrings.confirm);
    await tester.tap(confirmButton);
    await tester.pumpAndSettle();
  }

  testWidgets('NumismaticQuickFillSheet filters currencies based on selected country and resets currency if not valid', (WidgetTester tester) async {
    final dummyObverse = File('/tmp/obverse.jpg');

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
        ],
        child: MaterialApp(
          key: UniqueKey(),
          home: Scaffold(
            body: SingleChildScrollView(
              child: NumismaticQuickFillSheet(
                obversePhoto: dummyObverse,
                isCoin: true,
                initialLocationId: 'loc-1',
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

    // 2. Select Currency USD
    final currencyField = find.byType(AppWheelPickerField<String?>).at(2);
    await selectWheelOption(tester, currencyField, 'USD (Dólares Estadounidenses)');

    // 3. Change Country to 'México'
    await selectWheelOption(tester, countryField, 'México');

    // 4. Select Currency MXN
    await selectWheelOption(tester, currencyField, 'MXN (Pesos Mexicanos)');

    expect(find.text('MXN (Pesos Mexicanos)'), findsWidgets);
  });

  testWidgets('NumismaticQuickFillSheet blocks submit if fields are null/empty', (WidgetTester tester) async {
    NumismaticScanResult? submittedResult;

    final dummyObverse = File('/tmp/obverse.jpg');

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
        ],
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
        overrides: [
          databaseProvider.overrideWithValue(db),
        ],
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
        overrides: [
          databaseProvider.overrideWithValue(db),
        ],
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
    expect(find.text(AppStrings.denominationNumberLabel), findsOneWidget);

    // 3. Select Currency (MXN)
    final currencyField = find.byType(AppWheelPickerField<String?>).at(2);
    await selectWheelOption(tester, currencyField, 'MXN (Pesos Mexicanos)');

    // 4. Enter Year (1975)
    final yearField = find.widgetWithText(TextFormField, AppStrings.mintageYearLabel);
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
    expect(find.text(AppStrings.enterDenominationNumberPrompt), findsOneWidget);

    // Dismiss SnackBar and enter custom denomination
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();

    // Enter a decimal custom denomination (e.g. 0.50)
    final customDenomField = find.widgetWithText(TextFormField, AppStrings.denominationNumberLabel);
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
        overrides: [
          databaseProvider.overrideWithValue(db),
        ],
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
    final yearField = find.widgetWithText(TextFormField, AppStrings.mintageYearLabel);
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

  testWidgets('NumismaticQuickFillSheet does not pop navigator when onResultSubmitted is provided', (WidgetTester tester) async {
    NumismaticScanResult? submittedResult;
    final dummyObverse = File('/tmp/obverse.jpg');

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (sheetContext) => NumismaticQuickFillSheet(
                      obversePhoto: dummyObverse,
                      isCoin: true,
                      onResultSubmitted: (result) {
                        submittedResult = result;
                      },
                    ),
                  );
                },
                child: const Text('Open Sheet'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.text('Open Sheet'));
    await tester.pumpAndSettle();

    expect(find.byType(NumismaticQuickFillSheet), findsOneWidget);

    // Populate required fields
    await selectWheelOption(tester, find.byType(AppWheelPickerField<String?>).at(0), 'México');
    await selectWheelOption(tester, find.byType(AppWheelPickerField<String?>).at(1), '5');
    await selectWheelOption(tester, find.byType(AppWheelPickerField<String?>).at(2), 'MXN (Pesos Mexicanos)');
    await tester.enterText(find.byType(TextFormField), '1982');
    await selectWheelOption(tester, find.byType(AppWheelPickerField<String?>).at(3), 'Muy buena');
    await selectWheelOption(tester, find.byType(AppWheelPickerField<String?>).at(4), 'Cuproníquel');

    final submitText = find.text(AppStrings.confirmAndRegisterPieceAction);
    await tester.ensureVisible(submitText);
    await tester.tap(submitText);
    await tester.pumpAndSettle();

    expect(submittedResult, isNotNull);
    // Sheet must still be mounted (not popped directly by sheet, giving parent control)
    expect(find.byType(NumismaticQuickFillSheet), findsOneWidget);
  });

  testWidgets('NumismaticQuickFillSheet close button triggers onResultSubmitted with null', (WidgetTester tester) async {
    bool onResultCalled = false;
    NumismaticScanResult? submittedResult = NumismaticScanResult(
      speciesType: 'Dummy',
      generalSpeciesName: 'Dummy',
      subspeciesName: 'Dummy',
      obversePhotoPath: '/tmp/dummy.jpg',
      sourceEngine: 'Dummy',
    );
    final dummyObverse = File('/tmp/obverse.jpg');

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: NumismaticQuickFillSheet(
                obversePhoto: dummyObverse,
                isCoin: true,
                onResultSubmitted: (result) {
                  onResultCalled = true;
                  submittedResult = result;
                },
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    final closeButton = find.byIcon(Icons.close);
    expect(closeButton, findsOneWidget);
    await tester.tap(closeButton);
    await tester.pumpAndSettle();

    expect(onResultCalled, isTrue);
    expect(submittedResult, isNull);
  });
}


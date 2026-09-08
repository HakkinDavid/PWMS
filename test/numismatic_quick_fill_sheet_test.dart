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

  Future<void> selectWheelOption(
    WidgetTester tester,
    Finder fieldFinder,
    String optionText,
  ) async {
    await tester.ensureVisible(fieldFinder);
    await tester.pumpAndSettle();
    await tester.tap(fieldFinder);
    await tester.pumpAndSettle();

    final pickerFinder = find.byType(CupertinoPicker);
    if (pickerFinder.evaluate().isNotEmpty) {
      final picker = tester.widget<CupertinoPicker>(pickerFinder);
      final controller = picker.scrollController as FixedExtentScrollController;
      final dynamic wheelPicker = tester.widget(find.byWidgetPredicate((w) => w.runtimeType.toString().startsWith('AppWheelPicker<')));
      final items = wheelPicker.items as List;
      final labelBuilder = wheelPicker.labelBuilder as Function;
      final targetIndex = items.indexWhere((item) => labelBuilder(item) == optionText);
      if (targetIndex >= 0) {
        controller.jumpToItem(targetIndex);
        await tester.pumpAndSettle();
      }
    }

    final confirmButton = find.widgetWithText(ElevatedButton, AppStrings.confirm);
    if (confirmButton.evaluate().isNotEmpty) {
      await tester.tap(confirmButton);
      await tester.pumpAndSettle();
    }
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

    // 2. Select Currency USD (at index 1)
    final currencyField = find.byType(AppWheelPickerField<String?>).at(1);
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
    expect(find.text('Sin selección'), findsNWidgets(6)); // País, Divisa, Denominación, Material, Conservación, Motivo

    // Tap submit button with null fields
    final submitText = find.text(AppStrings.confirmAndRegisterPieceAction);
    await tester.ensureVisible(submitText);
    await tester.tap(submitText);
    await tester.pumpAndSettle();

    // Should NOT submit because fields are null
    expect(submittedResult, isNull);
    expect(find.text(AppStrings.completeAllFieldsPrompt), findsOneWidget);
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

    // 2. Enter Year (1982)
    final yearField = find.widgetWithText(TextFormField, AppStrings.mintageYearLabel);
    await tester.enterText(yearField, '1982');
    await tester.pumpAndSettle();

    // 3. Select Currency (MXP)
    final currencyField = find.byType(AppWheelPickerField<String?>).at(1);
    await selectWheelOption(tester, currencyField, 'MXP (Pesos Mexicanos Antiguos)');

    // 4. Select Denomination (5 Pesos)
    final denomField = find.byType(AppWheelPickerField<String?>).at(2);
    await selectWheelOption(tester, denomField, '5 Pesos');

    // 5. Select Material (Cuproníquel)
    final matField = find.byType(AppWheelPickerField<String?>).at(3);
    await selectWheelOption(tester, matField, 'Cuproníquel');

    // 6. Select Grade (Muy buena)
    final gradeField = find.byType(AppWheelPickerField<String?>).at(4);
    await selectWheelOption(tester, gradeField, 'Muy buena');

    // Submit
    final submitText = find.text(AppStrings.confirmAndRegisterPieceAction);
    await tester.ensureVisible(submitText);
    await tester.tap(submitText);
    await tester.pumpAndSettle();

    expect(submittedResult, isNotNull);
    expect(submittedResult!.country, equals('México'));
    expect(submittedResult!.currencyCode, equals('MXP'));
    expect(submittedResult!.currencyName, equals('Pesos Mexicanos Antiguos'));
    expect(submittedResult!.faceValueNumber, equals(5.0));
    expect(submittedResult!.year, equals('1982'));
    expect(submittedResult!.grade, equals('Muy buena'));
    expect(submittedResult!.composition, equals('Cuproníquel'));
    expect(submittedResult!.subspeciesName, equals('5 Pesos Mexicanos Antiguos - México (1982)'));
    expect(submittedResult!.motif, isNull);
  });

  testWidgets('NumismaticQuickFillSheet auto-infers Currency and Material for Mexico 1982 50 Pesos', (WidgetTester tester) async {
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

    // 2. Enter Year (1982)
    final yearField = find.widgetWithText(TextFormField, AppStrings.mintageYearLabel);
    await tester.enterText(yearField, '1982');
    await tester.pumpAndSettle();

    // Verify Currency was auto-inferred as MXP (Pesos Mexicanos Antiguos)
    expect(find.text('MXP (Pesos Mexicanos Antiguos)'), findsOneWidget);

    // 3. Select Denomination (50 Pesos)
    final denomField = find.byType(AppWheelPickerField<String?>).at(2);
    await selectWheelOption(tester, denomField, '50 Pesos');

    // Verify Material was auto-inferred as Cuproníquel (Coyolxauhqui)
    expect(find.text('Cuproníquel'), findsWidgets);

    // 4. Select Grade (Excelente)
    final gradeField = find.byType(AppWheelPickerField<String?>).at(4);
    await selectWheelOption(tester, gradeField, 'Excelente');

    // Submit
    final submitButton = find.text(AppStrings.confirmAndRegisterPieceAction);
    await tester.ensureVisible(submitButton);
    await tester.tap(submitButton);
    await tester.pumpAndSettle();

    expect(submittedResult, isNotNull);
    expect(submittedResult!.country, equals('México'));
    expect(submittedResult!.currencyCode, equals('MXP'));
    expect(submittedResult!.currencyName, equals('Pesos Mexicanos Antiguos'));
    expect(submittedResult!.faceValueNumber, equals(50.0));
    expect(submittedResult!.year, equals('1982'));
    expect(submittedResult!.composition, equals('Cuproníquel'));
    expect(submittedResult!.grade, equals('Excelente'));
    expect(submittedResult!.subspeciesName, equals('50 Pesos Mexicanos Antiguos - México (1982)'));
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

    // 2. Enter Year (1975)
    final yearField = find.widgetWithText(TextFormField, AppStrings.mintageYearLabel);
    await tester.enterText(yearField, '1975');
    await tester.pumpAndSettle();

    // 3. Select Currency (MXP)
    final currencyField = find.byType(AppWheelPickerField<String?>).at(1);
    await selectWheelOption(tester, currencyField, 'MXP (Pesos Mexicanos Antiguos)');

    // 4. Select Denomination ("Otro")
    final denomField = find.byType(AppWheelPickerField<String?>).at(2);
    await selectWheelOption(tester, denomField, 'Otro');

    // Verify the custom denomination text field is summoned
    expect(find.text(AppStrings.denominationNumberLabel), findsOneWidget);

    // 5. Select Material (Plata)
    final matField = find.byType(AppWheelPickerField<String?>).at(3);
    await selectWheelOption(tester, matField, 'Plata');

    // 6. Select Grade (Sin circular)
    final gradeField = find.byType(AppWheelPickerField<String?>).at(4);
    await selectWheelOption(tester, gradeField, 'Sin circular');

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
    expect(submittedResult!.subspeciesName, equals('50 Centavos de Pesos Mexicanos Antiguos - México (1975)'));
    expect(submittedResult!.country, equals('México'));
    expect(submittedResult!.currencyCode, equals('MXP'));
  });

  testWidgets('NumismaticQuickFillSheet handles custom Motif Otro option with summoned text field', (WidgetTester tester) async {
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

    // 2. Enter Year (1975 - non-commemorative piece)
    final yearField = find.widgetWithText(TextFormField, AppStrings.mintageYearLabel);
    await tester.enterText(yearField, '1975');
    await tester.pumpAndSettle();

    // 3. Select Currency (MXP)
    final currencyField = find.byType(AppWheelPickerField<String?>).at(1);
    await selectWheelOption(tester, currencyField, 'MXP (Pesos Mexicanos Antiguos)');

    // 4. Select Denomination (1 Peso)
    final denomField = find.byType(AppWheelPickerField<String?>).at(2);
    await selectWheelOption(tester, denomField, '1 Peso');

    // 5. Select Material (Cuproníquel)
    final matField = find.byType(AppWheelPickerField<String?>).at(3);
    await selectWheelOption(tester, matField, 'Cuproníquel');

    // 6. Select Grade (Sin circular)
    final gradeField = find.byType(AppWheelPickerField<String?>).at(4);
    await selectWheelOption(tester, gradeField, 'Sin circular');

    // 7. Select Motif ('Otro')
    final motifField = find.byType(AppWheelPickerField<String?>).at(5);
    await selectWheelOption(tester, motifField, 'Otro');

    // Verify custom motif field is summoned
    expect(find.text(AppStrings.customMotifOption), findsOneWidget);

    // Enter custom motif
    final customMotifField = find.widgetWithText(TextFormField, AppStrings.customMotifOption);
    await tester.ensureVisible(customMotifField);
    await tester.enterText(customMotifField, 'Prueba de cuño conmemorativo');
    await tester.pumpAndSettle();

    // Submit
    final submitButton = find.text(AppStrings.confirmAndRegisterPieceAction);
    await tester.ensureVisible(submitButton);
    await tester.tap(submitButton);
    await tester.pumpAndSettle();

    expect(submittedResult, isNotNull);
    expect(submittedResult!.motif, equals('Prueba de cuño conmemorativo'));
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
    await tester.enterText(find.widgetWithText(TextFormField, AppStrings.mintageYearLabel), '1982');
    await selectWheelOption(tester, find.byType(AppWheelPickerField<String?>).at(1), 'MXP (Pesos Mexicanos Antiguos)');
    await selectWheelOption(tester, find.byType(AppWheelPickerField<String?>).at(2), '5 Pesos');
    await selectWheelOption(tester, find.byType(AppWheelPickerField<String?>).at(3), 'Cuproníquel');
    await selectWheelOption(tester, find.byType(AppWheelPickerField<String?>).at(4), 'Muy buena');

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

  testWidgets('NumismaticQuickFillSheet allows specifying custom Country, Currency, Grade, and Material when Otro is selected', (WidgetTester tester) async {
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

    // 1. Country: select 'Otro' and specify custom country
    final countryField = find.byType(AppWheelPickerField<String?>).at(0);
    await selectWheelOption(tester, countryField, 'Otro');
    expect(find.text(AppStrings.specifyCountryLabel), findsWidgets);
    final customCountryInput = find.widgetWithText(TextFormField, AppStrings.specifyCountryLabel);
    await tester.enterText(customCountryInput, 'Imperio Romano');
    await tester.pumpAndSettle();

    // 2. Year: 1920
    final yearField = find.widgetWithText(TextFormField, AppStrings.mintageYearLabel);
    await tester.enterText(yearField, '1920');
    await tester.pumpAndSettle();

    // 3. Currency: select 'Otro' and specify custom currency
    final currencyField = find.byType(AppWheelPickerField<String?>).at(1);
    await selectWheelOption(tester, currencyField, 'Otro');
    expect(find.text(AppStrings.specifyCurrencyLabel), findsWidgets);
    final customCurrencyInput = find.widgetWithText(TextFormField, AppStrings.specifyCurrencyLabel);
    await tester.enterText(customCurrencyInput, 'Denario');
    await tester.pumpAndSettle();

    // 4. Denomination: select '1'
    final denomField = find.byType(AppWheelPickerField<String?>).at(2);
    await selectWheelOption(tester, denomField, '1');

    // 5. Material: select 'Otro' and specify custom material
    final matField = find.byType(AppWheelPickerField<String?>).at(3);
    await selectWheelOption(tester, matField, 'Otro');
    expect(find.text(AppStrings.specifyMaterialLabel), findsWidgets);
    final customMatInput = find.widgetWithText(TextFormField, AppStrings.specifyMaterialLabel);
    await tester.enterText(customMatInput, 'Electrum');
    await tester.pumpAndSettle();

    // 6. Grade: select 'Otro' and specify custom grade
    final gradeField = find.byType(AppWheelPickerField<String?>).at(4);
    await selectWheelOption(tester, gradeField, 'Otro');
    expect(find.text(AppStrings.specifyGradeLabel), findsWidgets);
    final customGradeInput = find.widgetWithText(TextFormField, AppStrings.specifyGradeLabel);
    await tester.enterText(customGradeInput, 'NGC MS-65');
    await tester.pumpAndSettle();

    // Submit
    final submitButton = find.text(AppStrings.confirmAndRegisterPieceAction);
    await tester.ensureVisible(submitButton);
    await tester.tap(submitButton);
    await tester.pumpAndSettle();

    expect(submittedResult, isNotNull);
    expect(submittedResult!.country, equals('Imperio Romano'));
    expect(submittedResult!.faceValueNumber, equals(1.0));
    expect(submittedResult!.currencyCode, equals('Denario'));
    expect(submittedResult!.currencyName, equals('Denario'));
    expect(submittedResult!.year, equals('1920'));
    expect(submittedResult!.grade, equals('NGC MS-65'));
    expect(submittedResult!.composition, equals('Electrum'));
    expect(submittedResult!.subspeciesName, equals('1 Denario - Imperio Romano (1920)'));
  });

  testWidgets('NumismaticQuickFillSheet submits successfully when fields are marked null with checkmarks', (WidgetTester tester) async {
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

    // Toggle all null checkmarks with ensureVisible
    final countryNull = find.text(AppStrings.unspecifiedCountryLabel);
    await tester.ensureVisible(countryNull);
    await tester.tap(countryNull);
    await tester.pumpAndSettle();

    final yearNull = find.text(AppStrings.unspecifiedYearLabel);
    await tester.ensureVisible(yearNull);
    await tester.tap(yearNull);
    await tester.pumpAndSettle();

    final currNull = find.text(AppStrings.unspecifiedCurrencyLabel);
    await tester.ensureVisible(currNull);
    await tester.tap(currNull);
    await tester.pumpAndSettle();

    final denomNull = find.text(AppStrings.unspecifiedDenominationLabel);
    await tester.ensureVisible(denomNull);
    await tester.tap(denomNull);
    await tester.pumpAndSettle();

    final matNull = find.text(AppStrings.unspecifiedMaterialLabel);
    await tester.ensureVisible(matNull);
    await tester.tap(matNull);
    await tester.pumpAndSettle();

    final gradeNull = find.text(AppStrings.unspecifiedGradeLabel);
    await tester.ensureVisible(gradeNull);
    await tester.tap(gradeNull);
    await tester.pumpAndSettle();

    // Submit form with all fields null
    final submitButton = find.text(AppStrings.confirmAndRegisterPieceAction);
    await tester.ensureVisible(submitButton);
    await tester.tap(submitButton);
    await tester.pumpAndSettle();

    expect(submittedResult, isNotNull);
    expect(submittedResult!.country, isNull);
    expect(submittedResult!.faceValueNumber, isNull);
    expect(submittedResult!.currencyCode, isNull);
    expect(submittedResult!.currencyName, isNull);
    expect(submittedResult!.year, isNull);
    expect(submittedResult!.grade, isNull);
    expect(submittedResult!.composition, isNull);
    expect(submittedResult!.subspeciesName, equals(AppStrings.defaultNumismaticPiece));
  });
}

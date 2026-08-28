import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:platinum_world_management_system/src/core/constants/app_strings.dart';
import 'package:platinum_world_management_system/src/features/catalog/presentation/numismatic_camera_capture_view.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Numismatic Camera Shutter & Volume Key Tests', () {
    testWidgets('Renders enlarged shutter button and volume trigger tip', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: NumismaticCameraCaptureView(
                isCoin: true,
                hideSideSelector: false,
              ),
            ),
          ),
        ),
      );

      // Verify Volume Shutter hint text is present
      expect(find.text(AppStrings.numisVolumeShutterTip), findsOneWidget);
      expect(find.byIcon(Icons.volume_up_outlined), findsOneWidget);

      // Verify Shutter button container with enlarged 88x88 dimensions
      final shutterFinder = find.byWidgetPredicate((widget) {
        if (widget is Container && widget.constraints != null) {
          final c = widget.constraints!;
          return c.minWidth == 88 && c.minHeight == 88;
        }
        return false;
      });
      expect(shutterFinder, findsOneWidget);
    });

    testWidgets('Hardware key listener processes volume buttons without throwing', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: NumismaticCameraCaptureView(
                isCoin: true,
                hideSideSelector: true,
              ),
            ),
          ),
        ),
      );

      // Simulate Volume Up key down
      await tester.sendKeyEvent(LogicalKeyboardKey.audioVolumeUp);
      await tester.pump();

      // Simulate Volume Down key down
      await tester.sendKeyEvent(LogicalKeyboardKey.audioVolumeDown);
      await tester.pump();

      // Simulate Camera hardware key down
      await tester.sendKeyEvent(LogicalKeyboardKey.camera);
      await tester.pump();

      // View remains stable and mounts correctly
      expect(find.byType(NumismaticCameraCaptureView), findsOneWidget);
    });
  });
}

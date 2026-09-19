import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/main.dart';
import 'package:tictactoe/screens/start_menu_screen.dart';
import 'package:tictactoe/screens/active_match_screen.dart';

void main() {
  testWidgets(
    'App starts on StartMenuScreen and can navigate to ActiveMatchScreen',
    (WidgetTester tester) async {
      // Set viewport to standard phone size (e.g. 412x892)
      tester.view.physicalSize = const Size(412, 892);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      // Build app and advance animation clock
      await tester.pumpWidget(const TicTacToeApp());
      await tester.pump(const Duration(milliseconds: 1000));

      // Verify Start Menu is visible
      expect(find.byType(StartMenuScreen), findsOneWidget);
      expect(find.text('PLAY DUEL'), findsOneWidget);
      expect(find.text('LOCAL PARTY'), findsOneWidget);

      // Tap PLAY DUEL (with repeating animations active, use pump with duration)
      await tester.tap(find.text('PLAY DUEL'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));

      // Verify Active Match Screen is shown
      expect(find.byType(ActiveMatchScreen), findsOneWidget);
      expect(find.text('TIC TAC TOE'), findsOneWidget);
      expect(find.text("RED PLAYER'S TURN (X)"), findsOneWidget);
    },
  );
}

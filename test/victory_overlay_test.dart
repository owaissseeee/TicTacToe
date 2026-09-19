import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/main.dart';
import 'package:tictactoe/widgets/victory_overlay.dart';

void main() {
  testWidgets(
    'Playing to a win triggers the VictoryOverlay and Play Again resets',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(412, 892);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      // 1. Launch app and wait for entrance animation (1000ms) to finish
      await tester.pumpWidget(const TicTacToeApp());
      await tester.pump(const Duration(milliseconds: 1200));

      // 2. Navigate to Active Match
      await tester.tap(find.text('PLAY DUEL'), warnIfMissed: false);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));

      // 3. Find cells: The 3x3 grid has 9 cells
      // Cells can be found by find.byIcon(Icons.add_rounded) since they start empty
      final emptyCells = find.byIcon(Icons.add_rounded);
      expect(emptyCells, findsNWidgets(9));

      // Move 1: X plays at index 0 (top-left)
      await tester.tap(emptyCells.first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // Move 2: O plays at index 3
      final emptyAfter1 = find.byIcon(Icons.add_rounded);
      await tester.tap(emptyAfter1.at(2)); // cell index 3
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // Move 3: X plays at index 1
      final emptyAfter2 = find.byIcon(Icons.add_rounded);
      await tester.tap(emptyAfter2.first); // cell index 1
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // Move 4: O plays at index 4
      final emptyAfter3 = find.byIcon(Icons.add_rounded);
      await tester.tap(emptyAfter3.at(1)); // cell index 4
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // Move 5: X plays at index 2 -> X wins! (Row 0: [0, 1, 2])
      final emptyAfter4 = find.byIcon(Icons.add_rounded);
      await tester.tap(emptyAfter4.first); // cell index 2
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));

      // 4. Verify Victory Overlay appears
      expect(find.byType(VictoryOverlay), findsOneWidget);
      expect(find.text('VICTORY!'), findsOneWidget);
      expect(find.text('✨ Player 1 Wins The Duel! ✨'), findsOneWidget);
      expect(find.text('PLAY AGAIN'), findsOneWidget);
      expect(find.text('MAIN MENU'), findsOneWidget);

      // 5. Tap "PLAY AGAIN"
      await tester.tap(find.text('PLAY AGAIN'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // Overlay is dismissed and board is reset
      expect(find.byType(VictoryOverlay), findsNothing);
      expect(find.byIcon(Icons.add_rounded), findsNWidgets(9));
    },
  );
}

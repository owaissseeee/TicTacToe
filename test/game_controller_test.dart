import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/controllers/game_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GameController Tests', () {
    late GameController controller;

    setUp(() {
      controller = GameController();
    });

    test('Initial board state should be empty with Player X starting', () {
      expect(controller.board.length, 9);
      expect(controller.board.every((cell) => cell.isEmpty), isTrue);
      expect(controller.currentPlayer, 'X');
      expect(controller.winner, isNull);
      expect(controller.winningLine, isNull);
      expect(controller.isDraw, isFalse);
      expect(controller.isGameOver, isFalse);
      expect(controller.turnsCount, 0);
      expect(controller.scoreX, 0);
      expect(controller.scoreO, 0);
    });

    test('Valid moves alternate players and increment turn count', () {
      final res1 = controller.makeMove(0);
      expect(res1, MoveResult.valid);
      expect(controller.board[0], 'X');
      expect(controller.currentPlayer, 'O');
      expect(controller.turnsCount, 1);

      final res2 = controller.makeMove(4);
      expect(res2, MoveResult.valid);
      expect(controller.board[4], 'O');
      expect(controller.currentPlayer, 'X');
      expect(controller.turnsCount, 2);
    });

    test('Tapping an already occupied cell is rejected', () {
      controller.makeMove(0); // X at 0
      final res = controller.makeMove(0); // O tries to play 0
      expect(res, MoveResult.cellOccupied);
      expect(controller.board[0], 'X');
      expect(controller.currentPlayer, 'O');
      expect(controller.turnsCount, 1);
      expect(controller.invalidCellIndex, 0);
    });

    test('Player X wins across Row 0 [0, 1, 2]', () {
      // Moves: X:0, O:3, X:1, O:4, X:2
      controller.makeMove(0); // X
      controller.makeMove(3); // O
      controller.makeMove(1); // X
      controller.makeMove(4); // O
      controller.makeMove(2); // X

      expect(controller.winner, 'X');
      expect(controller.winningLine, [0, 1, 2]);
      expect(controller.isGameOver, isTrue);
      expect(controller.scoreX, 1);
      expect(controller.scoreO, 0);
    });

    test('Player O wins down Col 1 [1, 4, 7]', () {
      // Moves: X:0, O:1, X:2, O:4, X:8, O:7
      controller.makeMove(0); // X
      controller.makeMove(1); // O
      controller.makeMove(2); // X
      controller.makeMove(4); // O
      controller.makeMove(8); // X
      controller.makeMove(7); // O

      expect(controller.winner, 'O');
      expect(controller.winningLine, [1, 4, 7]);
      expect(controller.isGameOver, isTrue);
      expect(controller.scoreO, 1);
    });

    test('Player X wins on Diagonal [0, 4, 8]', () {
      // Moves: X:0, O:1, X:4, O:2, X:8
      controller.makeMove(0); // X
      controller.makeMove(1); // O
      controller.makeMove(4); // X
      controller.makeMove(2); // O
      controller.makeMove(8); // X

      expect(controller.winner, 'X');
      expect(controller.winningLine, [0, 4, 8]);
      expect(controller.isGameOver, isTrue);
    });

    test('Player X wins on Anti-Diagonal [2, 4, 6]', () {
      // Moves: X:2, O:0, X:4, O:1, X:6
      controller.makeMove(2); // X
      controller.makeMove(0); // O
      controller.makeMove(4); // X
      controller.makeMove(1); // O
      controller.makeMove(6); // X

      expect(controller.winner, 'X');
      expect(controller.winningLine, [2, 4, 6]);
      expect(controller.isGameOver, isTrue);
    });

    test('Draw condition is detected when board is full and no winner', () {
      // X O X
      // X O O
      // O X X
      // Indices:
      // 0:X, 1:O, 2:X
      // 3:X, 4:O, 5:O
      // 6:O, 7:X, 8:X
      controller.makeMove(0); // X
      controller.makeMove(1); // O
      controller.makeMove(2); // X
      controller.makeMove(4); // O
      controller.makeMove(3); // X
      controller.makeMove(5); // O
      controller.makeMove(7); // X
      controller.makeMove(6); // O
      controller.makeMove(8); // X

      expect(controller.winner, isNull);
      expect(controller.isDraw, isTrue);
      expect(controller.isGameOver, isTrue);
      expect(controller.turnsCount, 9);
      expect(controller.scoreX, 0);
      expect(controller.scoreO, 0);
    });

    test('Moves rejected once game is over', () {
      // X wins: 0, 1, 2
      controller.makeMove(0);
      controller.makeMove(3);
      controller.makeMove(1);
      controller.makeMove(4);
      controller.makeMove(2);

      expect(controller.isGameOver, isTrue);
      final res = controller.makeMove(5);
      expect(res, MoveResult.gameOver);
    });

    test('resetMatch clears board but keeps score', () {
      controller.makeMove(0);
      controller.makeMove(3);
      controller.makeMove(1);
      controller.makeMove(4);
      controller.makeMove(2);

      expect(controller.scoreX, 1);
      controller.resetMatch();

      expect(controller.board.every((cell) => cell.isEmpty), isTrue);
      expect(controller.winner, isNull);
      expect(controller.winningLine, isNull);
      expect(controller.currentPlayer, 'X');
      expect(controller.turnsCount, 0);
      expect(controller.scoreX, 1); // preserved!
    });

    test('resetAll clears board and resets scores', () {
      controller.makeMove(0);
      controller.makeMove(3);
      controller.makeMove(1);
      controller.makeMove(4);
      controller.makeMove(2);

      expect(controller.scoreX, 1);
      controller.resetAll();

      expect(controller.scoreX, 0);
      expect(controller.scoreO, 0);
      expect(controller.turnsCount, 0);
    });

    test('toggleSound toggles mute status', () {
      expect(controller.isSoundMuted, isFalse);
      controller.toggleSound();
      expect(controller.isSoundMuted, isTrue);
      controller.toggleSound();
      expect(controller.isSoundMuted, isFalse);
    });
  });
}

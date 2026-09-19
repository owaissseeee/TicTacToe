import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'dart:math';

import '../services/audio_service.dart';

enum MoveResult { valid, cellOccupied, gameOver }

class GameController extends ChangeNotifier {
  final AudioService audioService = AudioService();
  GameController() {
    _initializeAudio();
  }
  Future<void> _initializeAudio() async {
    await audioService.init();
    audioService.playBGM();
  }

  List<String> _board = List.generate(9, (_) => '');

  String _currentPlayer = Random().nextBool() ? 'X' : 'O';

  String? _winner;

  List<int>? _winningLine;

  bool _isDraw = false;

  int _turnsCount = 0;

  int _scoreX = 0;
  int _scoreO = 0;

  bool _isSoundMuted = false;

  int? _invalidCellIndex;

  static const List<List<int>> winningCombinations = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6],
  ];

  List<String> get board => List.unmodifiable(_board);
  String get currentPlayer => _currentPlayer;
  String? get winner => _winner;
  List<int>? get winningLine => _winningLine;
  bool get isDraw => _isDraw;
  bool get isGameOver => _winner != null || _isDraw;
  int get turnsCount => _turnsCount;
  int get scoreX => _scoreX;
  int get scoreO => _scoreO;
  bool get isSoundMuted => _isSoundMuted;
  int? get invalidCellIndex => _invalidCellIndex;

  MoveResult makeMove(int index) {
    if (index < 0 || index >= 9) return MoveResult.gameOver;

    if (isGameOver) {
      _triggerInvalidMove(index);
      audioService.playError();
      return MoveResult.gameOver;
    }

    if (_board[index].isNotEmpty) {
      _triggerInvalidMove(index);
      audioService.playError();
      return MoveResult.cellOccupied;
    }

    _invalidCellIndex = null;
    _board[index] = _currentPlayer;
    _turnsCount++;

    audioService.playClick();

    if (!_isSoundMuted) {
      HapticFeedback.lightImpact();
    }

    final winCombo = _checkWinCondition(_board, _currentPlayer);
    if (winCombo != null) {
      _winner = _currentPlayer;
      _winningLine = winCombo;
      if (_currentPlayer == 'X') {
        _scoreX++;
      } else {
        _scoreO++;
      }
      if (!_isSoundMuted) {
        HapticFeedback.heavyImpact();
        audioService.playWin();
      }
      notifyListeners();
      return MoveResult.valid;
    }

    if (!_board.contains('')) {
      _isDraw = true;
      if (!_isSoundMuted) {
        HapticFeedback.mediumImpact();
        audioService.playWin();
      }
      notifyListeners();
      return MoveResult.valid;
    }

    _currentPlayer = (_currentPlayer == 'X') ? 'O' : 'X';
    notifyListeners();
    return MoveResult.valid;
  }

  void _triggerInvalidMove(int index) {
    _invalidCellIndex = index;
    if (!_isSoundMuted) {
      HapticFeedback.vibrate();
    }
    notifyListeners();

    Future.delayed(const Duration(milliseconds: 400), () {
      if (_invalidCellIndex == index) {
        _invalidCellIndex = null;
        notifyListeners();
      }
    });
  }

  List<int>? _checkWinCondition(List<String> b, String player) {
    for (final combo in winningCombinations) {
      if (b[combo[0]] == player &&
          b[combo[1]] == player &&
          b[combo[2]] == player) {
        return combo;
      }
    }
    return null;
  }

  void resetMatch() {
    _board = List.generate(9, (_) => '');
    _currentPlayer = Random().nextBool() ? 'X' : 'O';
    _winner = null;
    _winningLine = null;
    _isDraw = false;
    _turnsCount = 0;
    _invalidCellIndex = null;
    notifyListeners();
  }

  void resetAll() {
    resetMatch();
    _scoreX = 0;
    _scoreO = 0;
    notifyListeners();
  }

  void toggleSound() {
    _isSoundMuted = !_isSoundMuted;
    audioService.toggleMute();
    notifyListeners();
  }
}

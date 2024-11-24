import 'dart:math';
import 'package:flutter/material.dart';

class GameProvider with ChangeNotifier {
  List<List<String?>> _board = [
    [null, null, null],
    [null, null, null],
    [null, null, null],
  ];

  bool _isPlayer1Turn = true;
  int _player1Score = 0;
  int _player2Score = 0;
  bool _isPlayingAgainstAI = false;

  List<List<String?>> get board => _board;
  bool get isPlayer1Turn => _isPlayer1Turn;
  int get player1Score => _player1Score;
  int get player2Score => _player2Score;
  bool get isPlayingAgainstAI => _isPlayingAgainstAI;

  void toggleGameMode() {
    _isPlayingAgainstAI = !_isPlayingAgainstAI;
    resetBoard();
  }

  void resetBoard() {
    _board = [
      [null, null, null],
      [null, null, null],
      [null, null, null],
    ];
    _isPlayer1Turn = true;
    notifyListeners();
  }

  void resetScores() {
    _player1Score = 0;
    _player2Score = 0;
    notifyListeners();
  }

  void makeMove(int row, int col) {
    if (_board[row][col] == null) {
      _board[row][col] = _isPlayer1Turn ? 'X' : 'O';
      _isPlayer1Turn = !_isPlayer1Turn;
      notifyListeners();

      String? winner = checkWinner();
      if (winner != null) {
        if (winner == 'Jugador X') {
          _player1Score++;
        } else if (winner == 'Jugador O') {
          _player2Score++;
        }
        notifyListeners();
      } else if (_isPlayingAgainstAI && !_isPlayer1Turn) {
        _makeAIMove();
      }
    }
  }

  void _makeAIMove() {
    List<int> emptyCells = [];
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (_board[i][j] == null) {
          emptyCells.add(i * 3 + j);
        }
      }
    }

    if (emptyCells.isNotEmpty) {
      int randomIndex = Random().nextInt(emptyCells.length);
      int cell = emptyCells[randomIndex];
      int row = cell ~/ 3;
      int col = cell % 3;

      _board[row][col] = 'O';
      _isPlayer1Turn = true;
      notifyListeners();
    }
  }

  String? checkWinner() {
    for (int i = 0; i < 3; i++) {
      if (_board[i][0] != null &&
          _board[i][0] == _board[i][1] &&
          _board[i][1] == _board[i][2]) {
        return _board[i][0] == 'X' ? 'Jugador X' : 'Jugador O';
      }
      if (_board[0][i] != null &&
          _board[0][i] == _board[1][i] &&
          _board[1][i] == _board[2][i]) {
        return _board[0][i] == 'X' ? 'Jugador X' : 'Jugador O';
      }
    }

    if (_board[0][0] != null &&
        _board[0][0] == _board[1][1] &&
        _board[1][1] == _board[2][2]) {
      return _board[0][0] == 'X' ? 'Jugador X' : 'Jugador O';
    }
    if (_board[0][2] != null &&
        _board[0][2] == _board[1][1] &&
        _board[1][1] == _board[2][0]) {
      return _board[0][2] == 'X' ? 'Jugador X' : 'Jugador O';
    }

    bool isFull = true;
    for (var row in _board) {
      for (var cell in row) {
        if (cell == null) {
          isFull = false;
          break;
        }
      }
    }
    if (isFull) {
      return 'Empate';
    }

    return null;
  }
}

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:lab_moviles/models/board_position.dart';
import 'package:lab_moviles/core/enums/cell_type.dart';
import 'package:lab_moviles/services/audio_service.dart';
// Importa tus dependencias y modelos creados en los pasos anteriores:
import 'package:lab_moviles/models/move_record.dart';
import 'package:lab_moviles/models/game_record.dart';
import 'package:lab_moviles/repositories/game_history_repositories.dart';
import 'package:lab_moviles/services/preference_service.dart';

class PegSolitaireViewModel extends ChangeNotifier {
  static const int gridSize = 7;
  final Logger _logger = Logger();

  // Estado interno matricial y contadores
  late List<List<CellType>> _board;
  BoardPosition? _selectedPosition;
  int _remainingPegs = 0;
  int _moveCount = 0;
  bool _isGameOver = false;
  bool _isVictory = false;

  IGameHistoryRepository? _historyRepository;
  PreferencesService? _preferencesService;
  final List<MoveRecord> _movesHistory = [];

  List<List<CellType>> get board => _board;
  BoardPosition? get selectedPosition => _selectedPosition;
  int get remainingPegs => _remainingPegs;
  int get moveCount => _moveCount;
  bool get isGameOver => _isGameOver;
  bool get isVictory => _isVictory;
  List<MoveRecord> get movesHistory => List.unmodifiable(_movesHistory);

  // CONSTRUCTOR ACTUALIZADO CON INYECCIÓN DE DEPENDENCIAS (DIP)
  PegSolitaireViewModel({
    IGameHistoryRepository? historyRepository,
    PreferencesService? preferencesService,
  }) : _historyRepository = historyRepository,
       _preferencesService = preferencesService {
    initializeBoard();
  }

  bool isCellSelected(BoardPosition pos) {
    return _selectedPosition == pos;
  }

  void initializeBoard() {
    _board = List.generate(gridSize, (row) {
      return List.generate(gridSize, (col) {
        // Esquinas no jugables (bloques 2x2 en las cuatro esquinas)
        if ((row < 2 || row > 4) && (col < 2 || col > 4)) {
          return CellType.voidCell;
        }
        // Centro estándar desocupado (3, 3)
        if (row == 3 && col == 3) {
          return CellType.emptyHole;
        }
        return CellType.occupiedPeg;
      });
    });

    _selectedPosition = null;
    _remainingPegs = 32;
    _moveCount = 0;
    _isGameOver = false;
    _isVictory = false;
    _movesHistory.clear(); // Limpiar historial al reiniciar
    notifyListeners();
  }

  CellType getCellType(int row, int col) {
    if (row < 0 || row >= gridSize || col < 0 || col >= gridSize) {
      return CellType.voidCell;
    }
    return _board[row][col];
  }

  void onCellTapped(BoardPosition pos) {
    if (_isGameOver) return;

    final CellType tappedType = _board[pos.row][pos.col];
    if (tappedType == CellType.voidCell) return;

    if (_selectedPosition == null) {
      if (tappedType == CellType.occupiedPeg) {
        _selectedPosition = pos;
        AudioService.instance.playSelect();
        notifyListeners();
      }
      return;
    }
    final BoardPosition origin = _selectedPosition!;

    if (origin == pos) {
      _selectedPosition = null;
      notifyListeners();
      return;
    }

    if (tappedType == CellType.occupiedPeg) {
      _selectedPosition = pos;
      AudioService.instance.playSelect();
      notifyListeners();
      return;
    }

    if (tappedType == CellType.emptyHole) {
      if (_isValidMove(origin, pos)) {
        _executeMove(origin, pos);
        AudioService.instance.playJump();
        _selectedPosition = null;
        _evaluateGameTermination();
        notifyListeners();
      }
    }
  }

  // 2. Validación de Saltos Ortogonales Estrictos
  bool _isValidMove(BoardPosition from, BoardPosition to) {
    final int rowDelta = (from.row - to.row).abs();
    final int colDelta = (from.col - to.col).abs();

    final bool isOrthogonalTwoStep =
        (rowDelta == 2 && colDelta == 0) || (rowDelta == 0 && colDelta == 2);

    if (!isOrthogonalTwoStep) return false;
    if (_board[to.row][to.col] != CellType.emptyHole) return false;

    final int midRow = (from.row + to.row) ~/ 2;
    final int midCol = (from.col + to.col) ~/ 2;

    if (_board[midRow][midCol] != CellType.occupiedPeg) return false;

    return true;
  }

  // 3. Mutación en la matriz y registro del movimiento
  void _executeMove(BoardPosition from, BoardPosition to) {
    final int midRow = (from.row + to.row) ~/ 2;
    final int midCol = (from.col + to.col) ~/ 2;

    _board[from.row][from.col] = CellType.emptyHole;
    _board[midRow][midCol] = CellType.emptyHole;
    _board[to.row][to.col] = CellType.occupiedPeg;

    _remainingPegs--;
    _moveCount++;

    _movesHistory.add(
      MoveRecord(from: from, to: to, timestamp: DateTime.now()),
    );
  }

  void _evaluateGameTermination() {
    if (_remainingPegs == 1) {
      _isGameOver = true;
      _isVictory = true;
      AudioService.instance.playGameOver();
      _persistCompletedGame();
    } else if (!_hasValidMovesRemaining()) {
      _isGameOver = true;
      _isVictory = false;
      AudioService.instance.playGameOver();
      _persistCompletedGame();
    }
  }

  Future<void> _persistCompletedGame() async {
    final record = GameRecord(
      id: 'REC-${DateTime.now().millisecondsSinceEpoch}',
      date: DateTime.now(),
      remainingPegs: _remainingPegs,
      totalMoves: _moveCount,
      durationSeconds: 0,
      isVictory: _isVictory,
      moves: List.unmodifiable(_movesHistory),
    );

    try {
      await _historyRepository?.saveGame(record);
      await _preferencesService?.checkAndSaveRecord(_remainingPegs);
      _logger.i('Partida persistida con éxito en disco.');
    } catch (e) {
      _logger.e('Error al guardar resumen en ViewModel: $e');
    }
  }

  // Detección de movimientos válidos restantes
  bool _hasValidMovesRemaining() {
    const List<List<int>> directions = [
      [-2, 0],
      [2, 0],
      [0, -2],
      [0, 2],
    ];

    for (int r = 0; r < gridSize; r++) {
      for (int c = 0; c < gridSize; c++) {
        if (_board[r][c] == CellType.occupiedPeg) {
          final from = BoardPosition(r, c);

          for (final dir in directions) {
            final int targetRow = r + dir[0];
            final int targetCol = c + dir[1];

            if (targetRow >= 0 &&
                targetRow < gridSize &&
                targetCol >= 0 &&
                targetCol < gridSize) {
              final to = BoardPosition(targetRow, targetCol);
              if (_board[targetRow][targetCol] != CellType.voidCell &&
                  _isValidMove(from, to)) {
                return true;
              }
            }
          }
        }
      }
    }
    return false;
  }
}

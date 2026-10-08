import 'package:flutter/foundation.dart';
import 'package:lab_moviles/models/board_position.dart';
import 'package:lab_moviles/core/enums/cell_type.dart';
import 'package:lab_moviles/services/audio_service.dart';

class PegSolitaireViewModel extends ChangeNotifier {
  static const int gridSize = 7;

  // Estado interno matricial y contadores
  late List<List<CellType>> _board;
  BoardPosition? _selectedPosition;
  int _remainingPegs = 0;
  int _moveCount = 0;
  bool _isGameOver = false;
  bool _isVictory = false;

  List<List<CellType>> get board => _board;
  BoardPosition? get selectedPosition => _selectedPosition;
  int get remainingPegs => _remainingPegs;
  int get moveCount => _moveCount;
  bool get isGameOver => _isGameOver;
  bool get isVictory => _isVictory;

  PegSolitaireViewModel() {
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
    notifyListeners();
  }

  CellType getCellType(int row, int col) {
    if (row < 0 || row >= gridSize || col < 0 || col >= gridSize) {
      return CellType.voidCell;
    }
    return _board[row][col];
  }

  // 1. Control de interacciones y Máquina de Estados Finitos (FSM)
  void onCellTapped(BoardPosition pos) {
    if (_isGameOver) return;

    final CellType tappedType = _board[pos.row][pos.col];
    if (tappedType == CellType.voidCell) return;

    // ESTADO 0: IDLE (No hay celda origen seleccionada)
    if (_selectedPosition == null) {
      if (tappedType == CellType.occupiedPeg) {
        _selectedPosition = pos;
        AudioService.instance.playSelect(); // Reproducir sonido de selección
        notifyListeners();
      }
      return;
    }

    // ESTADO 1: SOURCE_SELECTED (Existe una clavija origen activa)
    final BoardPosition origin = _selectedPosition!;

    // Transición 1.1: Pulsar sobre la misma casilla -> Deselección (Toggle)
    if (origin == pos) {
      _selectedPosition = null;
      notifyListeners();
      return;
    }

    // Transición 1.2: Pulsar sobre otra clavija propia -> Alternar selección
    if (tappedType == CellType.occupiedPeg) {
      _selectedPosition = pos;
      AudioService.instance.playSelect(); // Reproducir sonido de selección
      notifyListeners();
      return;
    }

    // Transición 1.3: Pulsar sobre un hueco vacío -> Evaluar salto y captura
    if (tappedType == CellType.emptyHole) {
      if (_isValidMove(origin, pos)) {
        _executeMove(origin, pos);
        AudioService.instance.playJump();
        _selectedPosition = null; // Regreso automático a IDLE tras el salto
        _evaluateGameTermination();
        notifyListeners();
      }
    }
  }

  // 2. Validación de Saltos Ortogonales Estrictos

  bool _isValidMove(BoardPosition from, BoardPosition to) {
    final int rowDelta = (from.row - to.row).abs();
    final int colDelta = (from.col - to.col).abs();

    // 1. Debe ser un salto ortogonal estricto de distancia 2
    final bool isOrthogonalTwoStep =
        (rowDelta == 2 && colDelta == 0) || (rowDelta == 0 && colDelta == 2);

    if (!isOrthogonalTwoStep) return false;

    // 2. El destino debe ser un hueco vacío
    if (_board[to.row][to.col] != CellType.emptyHole) return false;

    // 3. La celda intermedia debe contener una clavija para ser capturada
    final int midRow = (from.row + to.row) ~/ 2;
    final int midCol = (from.col + to.col) ~/ 2;

    if (_board[midRow][midCol] != CellType.occupiedPeg) return false;

    return true;
  }

  // 3. Mutación en la matriz y captura de la clavija

  void _executeMove(BoardPosition from, BoardPosition to) {
    final int midRow = (from.row + to.row) ~/ 2;
    final int midCol = (from.col + to.col) ~/ 2;

    _board[from.row][from.col] = CellType.emptyHole;
    _board[midRow][midCol] = CellType.emptyHole;
    _board[to.row][to.col] = CellType.occupiedPeg;

    _remainingPegs--;
    _moveCount++;
  }

  // 4. Algoritmo para determinar el término de la partida
  void _evaluateGameTermination() {
    // Condición de Victoria: Queda exactamente 1 clavija en el tablero
    if (_remainingPegs == 1) {
      _isGameOver = true;
      _isVictory = true;
      AudioService.instance.playGameOver();
    }
    // Finalización por estancamiento: No quedan saltos ortogonales válidos
    else if (!_hasValidMovesRemaining()) {
      _isGameOver = true;
      _isVictory = false;
      AudioService.instance.playGameOver();
    }
  }

  /// Algoritmo exhaustivo de detección de estancamiento sobre las casillas jugables.
  bool _hasValidMovesRemaining() {
    const List<List<int>> directions = [
      [-2, 0], // Arriba
      [2, 0], // Abajo
      [0, -2], // Izquierda
      [0, 2], // Derecha
    ];

    for (int r = 0; r < gridSize; r++) {
      for (int c = 0; c < gridSize; c++) {
        if (_board[r][c] == CellType.occupiedPeg) {
          final from = BoardPosition(r, c);

          for (final dir in directions) {
            final int targetRow = r + dir[0];
            final int targetCol = c + dir[1];

            // Validar que el salto potencial no desborde los límites de la matriz
            if (targetRow >= 0 &&
                targetRow < gridSize &&
                targetCol >= 0 &&
                targetCol < gridSize) {
              final to = BoardPosition(targetRow, targetCol);
              if (_board[targetRow][targetCol] != CellType.voidCell &&
                  _isValidMove(from, to)) {
                return true; // Existe al menos un movimiento válido
              }
            }
          }
        }
      }
    }
    return false;
  }
}

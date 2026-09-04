import 'package:flutter/material.dart';
import 'package:lab_moviles/models/GameRecord.dart';

import '../widgets/PegCell.dart';
import '../../core/enums/CellType.dart';
import 'RulesScreen.dart';

import 'package:logger/logger.dart';

class PegSolitaireScreen extends StatelessWidget {
  PegSolitaireScreen({super.key});

  static const int gridSize = 7;
  static final Logger _logger = Logger();

  final GameRecord _lastGameRecord = GameRecord(
    date: DateTime.now(),
    remainingPegs: 32,
    totalMoves: 0,
    durationSeconds: 0,
    isVictory: false,
    id: '',
  );

  CellType _getCellType(int row, int col) {
    final bool isCorner = (row < 2 || row > 4) && (col < 2 || col > 4);
    if (isCorner) {
      return CellType.voidCell;
    }

    if (row == 3 && col == 3) {
      return CellType.emptyHole;
    }

    return CellType.occupiedPeg;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solitario Inglés'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            tooltip: 'Ayuda',
            onPressed: () {
              _logger.i('Navegando a Rules desde PegSolitaireScreen');
              _logger.i('Último registro de juego: $_lastGameRecord');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RulesScreen()),
              );
              // Handle info button press
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 60,
              color: Colors.grey[300],
              child: const Center(
                child: Text(
                  'STATUS: 0 segundos | Piezas restantes: 32',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ),
            const Divider(height: 1),
            // Area de Juego
            Expanded(child: _gameBoard()),
          ],
        ),
      ),
    );
  }

  Widget _gameBoard() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AspectRatio(
          aspectRatio: 1.0,
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: gridSize,
              crossAxisSpacing: 2.0,
              mainAxisSpacing: 2.0,
            ),
            itemCount: gridSize * gridSize, // 7x7 casillas
            itemBuilder: (context, index) {
              final int row = index ~/ gridSize;
              final int col = index % gridSize;
              final CellType cellType = _getCellType(row, col);

              return PegCell(row: row, col: col, type: cellType);
            },
          ),
        ),
      ),
    );
  }
}

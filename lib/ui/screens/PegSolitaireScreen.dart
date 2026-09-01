import 'package:flutter/material.dart';

import '../widgets/PegCell.dart';
import '../../core/enums/CellType.dart';

class PegSolitaireScreen extends StatelessWidget {
  const PegSolitaireScreen({super.key});

  static const int gridSize = 7;

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
      appBar: AppBar(title: const Text('Solitario Inglés')),
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

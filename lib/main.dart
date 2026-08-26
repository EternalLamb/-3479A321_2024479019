import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

enum CellType {
  voidCell, 
  emptyHole, 
  occupiedPeg,
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Solitario Inglés',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const PegSolitaireScreen(),
    );
  }
}

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
      appBar: AppBar(
        title: const Text('Solitario Inglés'),
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
            Expanded(
              child: _gameBoard(),
            ),
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

              return PegCell(
                row: row,
                col: col,
                type: cellType,
              );
            },
          ),
        ),
      ),
    );
  }
}

class PegCell extends StatelessWidget {
  final int row;
  final int col;
  final CellType type;
  final bool isSelected;
  final VoidCallback? onTap;

  const PegCell({
    super.key,
    required this.row,
    required this.col,
    required this.type,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    
    if (type == CellType.voidCell) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.amber[200] : Colors.grey[300],
          border: Border.all(
            color: isSelected ? Colors.orange : Colors.grey[600]!,
            width: isSelected ? 2.5 : 1.5,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: type == CellType.occupiedPeg
              ? Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.blue[800],
                    shape: BoxShape.circle,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 3,
                        offset: Offset(1, 2),
                      ),
                    ],
                  ),
                )
              : Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Colors.grey[600],
                    shape: BoxShape.circle,
                  ),
                ),
        ),
      ),
    );
  }
}
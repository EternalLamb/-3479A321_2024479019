import 'package:flutter/material.dart';

void main() {
  // Se usa MyApp como punto de entrada para incluir MaterialApp
  runApp(const MyApp());
}

/// Estados de la celda en el tablero.
enum CellType {
voidCell, // Fuera de límites jugables (Esquinas 2x2)
emptyHole, // Casilla jugable desocupada
occupiedPeg, // Casilla jugable con clavija presente
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Solitario Inglés',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      // Se asigna la pantalla de juego como home
      home: const PegSolitaireScreen(),
    );
  }
}

class PegSolitaireScreen extends StatelessWidget {
  const PegSolitaireScreen({super.key});

  static const int gridSize = 7;
  static const int totalCells = gridSize * gridSize; // 49 casillas
  /// Determina el tipo de celda según sus coordenadas matriciales (row, col)
  CellType _getCellType(int row, int col) {
  // Esquinas 2x2 no jugables en el tablero inglés estándar
  final bool isCorner = (row < 2 || row > 4) && (col < 2 || col > 4);
  if (isCorner) {
  return CellType.voidCell;
  }
  // El resto de las 33 posiciones inician ocupadas
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
                  'STATUS: 349 segundos | Piezas restantes: 33',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ),
            const Divider(height: 1),
            // Área de Juego: Integra el tablero de juego reutilizando _gameBoard()
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
              crossAxisCount: 7,
              crossAxisSpacing: 2.0,
              mainAxisSpacing: 2.0,
            ),
            itemCount: 49, // 7x7 
            itemBuilder: (context, index) {
 // Convertir el índice en coordenadas matriciales
 final int row = index ~/ gridSize;
 final int col = index % gridSize;
 final CellType cellType = _getCellType(row, col);
 return Container(
 decoration: BoxDecoration(
 color: Colors.grey[400],
 border: Border.all(color: Colors.grey[600]!, width: 1.5),
 ),
 child: Center(
 child: cellType == CellType.occupiedPeg
 ? Container(
 width: 30,
 height: 30,
 decoration: const BoxDecoration(
 color: Colors.blue,
shape: BoxShape.circle,
 ),
 )
 : cellType == CellType.emptyHole
 ? Container(
 width: 30,
 height: 30,
 decoration: const BoxDecoration(
 color: Colors.white,
shape: BoxShape.circle,
 ),
 )
 : null, // No dibuja nada para voidCell
 ),
 );
 },

          ),
        ),
      ),
    );
  }

  

}
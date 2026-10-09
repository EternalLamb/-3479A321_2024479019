import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:logger/logger.dart';

import 'package:lab_moviles/ui/widgets/peg_cell.dart';
import 'package:lab_moviles/models/board_position.dart';
import 'package:lab_moviles/models/game_record.dart';
import 'package:lab_moviles/core/enums/cell_type.dart';
import 'package:lab_moviles/models/peg_solitaire_view_model.dart';
import 'package:lab_moviles/ui/screens/history_screen.dart';
import 'package:lab_moviles/services/shake_detector.dart';

class PegSolitaireScreen extends StatefulWidget {
  final List<GameRecord> gameHistory;

  const PegSolitaireScreen({super.key, this.gameHistory = const []});

  @override
  State<PegSolitaireScreen> createState() => _PegSolitaireScreenState();
}

class _PegSolitaireScreenState extends State<PegSolitaireScreen> {
  // 1. Declaración de la instancia del servicio y el logger
  ShakeDetectorService? _shakeDetector;
  final Logger _logger = Logger();

  @override
  void initState() {
    super.initState();

    // 2. Inicialización del detector de agitamiento
    _shakeDetector = ShakeDetectorService(
      shakeThreshold:
          2.5, // Sensibilidad ajustada para emulador y prueba rápida
      onShake: _handleShakeEvent,
    );
    _shakeDetector?.startListening();
  }

  // 3. Manejador del evento de agitamiento
  void _handleShakeEvent() {
    final vm = context.read<PegSolitaireViewModel>();

    // Regla de negocio: Reinicia la partida cuando termina el juego
    if (vm.isGameOver) {
      _logger.i('Shake validado: Partida finalizada. Reiniciando tablero.');
      vm.initializeBoard();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Tablero reiniciado por movimiento físico!'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } else {
      _logger.d('Shake ignorado: La partida se encuentra activa.');
    }
  }

  @override
  void dispose() {
    // 4. Liberación del sensor para evitar fugas de memoria
    _shakeDetector?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PegSolitaireViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Solitario Inglés'),
        actions: [
          // Botón para compartir resultados
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: 'Compartir Resultado',
            onPressed: () async {
              final String message =
                  'He completado una partida de Peg Solitaire en ${vm.moveCount} movimientos '
                  'dejando solo ${vm.remainingPegs} piezas!';

              await SharePlus.instance.share(ShareParams(text: message));
            },
          ),
          // Botón para reiniciar el tablero manualmente
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Reiniciar Tablero',
            onPressed: () =>
                context.read<PegSolitaireViewModel>().initializeBoard(),
          ),
          // Botón para ir al historial de partidas
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Ver Historial',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      HistoryScreen(records: widget.gameHistory),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildScoreBoard(context, vm),
            const Divider(height: 1),
            // Área de Juego (Grid de 7x7)
            Expanded(child: _buildGameBoard(context, vm)),
            // Mensaje o Banner de Finalización
            if (vm.isGameOver) _buildGameOverBanner(context, vm),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreBoard(BuildContext context, PegSolitaireViewModel vm) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            'Piezas restantes: ${vm.remainingPegs}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            'Movimientos: ${vm.moveCount}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildGameBoard(BuildContext context, PegSolitaireViewModel vm) {
    _logger.i("Construyendo el tablero de juego");

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AspectRatio(
          aspectRatio: 1.0,
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: PegSolitaireViewModel.gridSize,
              crossAxisSpacing: 2.0,
              mainAxisSpacing: 2.0,
            ),
            itemCount:
                PegSolitaireViewModel.gridSize * PegSolitaireViewModel.gridSize,
            itemBuilder: (context, index) {
              final int row = index ~/ PegSolitaireViewModel.gridSize;
              final int col = index % PegSolitaireViewModel.gridSize;
              final position = BoardPosition(row, col);
              final CellType cellType = vm.getCellType(row, col);

              return PegCell(
                position: position,
                type: cellType,
                isSelected: vm.isCellSelected(position),
                onTap: () => context.read<PegSolitaireViewModel>().onCellTapped(
                  position,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildGameOverBanner(BuildContext context, PegSolitaireViewModel vm) {
    return Container(
      width: double.infinity,
      color: vm.isVictory ? Colors.green : Colors.redAccent,
      padding: const EdgeInsets.all(12.0),
      child: Text(
        vm.isVictory
            ? '¡VICTORIA! Has completado el juego.'
            : 'FIN DEL JUEGO: No existen más movimientos válidos.',
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}
